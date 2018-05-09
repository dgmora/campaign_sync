RSpec.describe CampaignSync::Campaign do
  let(:campaign) do
    described_class.new(ad_description: 'foo', name: 'bar')
  end
  describe '.find_remotes' do
    let(:json) do
      str = '{ "ads": [ { "reference": "1", "status": "enabled", "descr'\
            'iption": "Description for campaign 11" }, { "reference": "'\
            '2", "status": "disabled", "description": "Description for '\
            'campaign 12" }, { "reference": "3", "status": "enabled", "'\
            'description": "Description for campaign 13" } ] }'
      StringIO.new(str)
    end

    it 'returns the remotes of the current campaign' do
      allow(described_class).to receive(:open).and_return(json)
      remote = described_class.find_remotes
      expect(remote).to be_a Array
      expect(remote.first)
    end
  end

  describe '#to_hash' do
    it 'returns a hash with correct mappings' do
      expect(campaign.ad_description).to eq campaign.to_hash['description']
    end

    it 'returns enabled as status if the status is active' do
      expect(campaign.to_hash['status']).to eq 'enabled'
    end
  end
end
