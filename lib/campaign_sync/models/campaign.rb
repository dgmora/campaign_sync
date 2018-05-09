require 'open-uri'

module CampaignSync
  class Campaign < ActiveRecord::Base
    enum status: [:active, :paused, :deleted]

    def self.find_remotes
      # Not memoizing in purpose. Caching could be an option
      url = 'https://mockbin.org/bin/fcb30500-7b98-476f-810d-463a0b8fc3df'
      json = open(url).read
      JSON.parse(json).fetch('ads')
    end

    # This method allows us to create a hash, but also define simple
    # mappings between the names of the external attributes and local
    # attributes
    def to_hash
      {
        'description' => ad_description,
        'reference' => external_reference,
        'status' => external_status
      }
    end

    # This method should declare an array of strings,
    # which correspond to the fields that campaigns from external services
    # have. Those fields must also be used in to_hash
    def self.external_attributes
      %w[description status]
    end

    private

    def external_status
      case status.to_s
      when 'active' then 'enabled'
      when 'paused' then 'disabled'
      else status.to_s
      end
    end
  end
end
