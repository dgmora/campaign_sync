# There are a few assumptions in how this works:
# - We assume local entities have all fields, we are not interested
#   in fields that are not defined by Campaign#to_hash
module CampaignSync
  class Service
    def call
      locals = Campaign.all.map(&:to_hash)
      remotes = Campaign.find_remotes
      diff(locals, remotes)
    end

    private

    # 1. Iterate each local
    # 2. Delete the remote if it exists, so we can keeo track of
    #    campaigns only existing remotely
    # 3. Make the diff of each the local campaigns
    # 4. Add the diff of the campaigns that are only remotely
    def diff(locals, remotes)
      diffs = locals.map do |local|
        remote = find_and_delete_remote(local.fetch('reference'), remotes)
        campaign_diff(local, remote)
      end
      diffs + only_remote_diffs(remotes)
    end

    # 1. Construct inital hash with the reference and empty discrepancies
    # 2. Iterate the attributes. We could do this based on the hashes keys, but
    #    it's more explicit if we declare it as Campaign::external_attributes
    # 3. Same value => Store it as a simple field
    # 4. Different value => Store it as a discrepancy
    def campaign_diff(local, remote)
      reference = local&.delete('reference') || remote&.delete('reference')
      diff = { 'discrepancies' => [],
               'remote_reference' => reference }
      Campaign.external_attributes.each do |attr|
        local_value = local&.dig(attr)
        remote_value = remote&.dig(attr)
        if local_value == remote_value
          diff[attr] = local_value
        else
          diff_value = { 'local' => local_value, 'remote' => remote_value }
          diff['discrepancies'] << { attr => diff_value }
        end
      end
      diff
    end

    def only_remote_diffs(remotes)
      remotes.map { |remote| campaign_diff(nil, remote) }
    end

    def find_and_delete_remote(reference, remotes)
      remote = remotes.detect { |r| r.fetch('reference') == reference }
      remotes.delete_if { |r| r.fetch('reference') == reference }
      remote
    end
  end
end
