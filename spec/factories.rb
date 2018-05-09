FactoryBot.define do
  factory :campaign, class: CampaignSync::Campaign do
    status 0
    name 'Ruby on Rails Developer'
    external_reference '1'
    ad_description 'Deploy fork bombs <3'
    sequence(:job_id)
  end

  factory :remote, class: Hash do
    description 'Deploy fork bombs <3'
    reference '1'
    status 'enabled'
    initialize_with { attributes.stringify_keys }
  end
end
