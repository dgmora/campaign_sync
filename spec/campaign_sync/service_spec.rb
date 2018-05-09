RSpec.describe CampaignSync::Service do
  let(:campaign) { create(:campaign) }

  let(:service) { described_class.new }

  def fake_remotes(remotes)
    expect(CampaignSync::Campaign).to(receive(:find_remotes)
      .and_return(remotes))
  end

  describe '#call' do
    context 'when there are no discrepancies' do
      it 'is returns a hash of the job and empty discrepancies' do
        fake_remotes([build(:remote)])
        expected = [{ 'discrepancies' => [],
                      'description' => campaign.ad_description,
                      'status' => 'enabled',
                      'remote_reference' => campaign.external_reference }]
        expect(service.call).to eq expected
      end
    end

    context 'when there are discrepancies' do
      it 'shows them' do
        fake_remotes([build(:remote, status: 'disabled')])
        expected = [{
          'discrepancies' => [
            {
              'status' =>
              {
                'local' => 'enabled',
                'remote' => 'disabled'
              }
            }
          ],
          'description' => campaign.ad_description,
          'remote_reference' => '1'
        }]
        expect(service.call).to eq expected
      end
    end

    it 'shows them if the object only exists locally' do
      fake_remotes([])
      expected = [{
        'discrepancies' => [
          {
            'description' =>
            {
              'local' => campaign.ad_description,
              'remote' => nil
            }
          },
          {
            'status' => {
              # The diff is done with the external attribute names
              'local' => 'enabled',
              'remote' => nil
            }
          }
        ],
        'remote_reference' => '1'
      }]
      expect(service.call).to eq expected
    end

    it 'shows them if they only exist remotely' do
      remote = build(:remote)
      fake_remotes([remote])
      expected = [{
        'discrepancies' => [
          {
            'description' =>
            {
              'local' => nil,
              'remote' => remote['description']
            }
          },
          { 'status' =>
            { # The diff is done with the external attribute names
              'local' => nil,
              'remote' => remote['status']
            } }
        ],
        'remote_reference' => '1'
      }]
      expect(service.call).to eq expected
    end
  end
end
