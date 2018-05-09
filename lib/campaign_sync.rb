require 'sqlite3'
require 'active_record'
require 'yaml'

require 'campaign_sync/version'
require 'campaign_sync/database'
require 'campaign_sync/models/campaign'
require 'campaign_sync/service'

module CampaignSync
  def self.discrepancies
    CampaignSync::Database.connect('development')
    puts JSON.pretty_generate(Service.new.call)
  rescue ActiveRecord::StatementInvalid => e
    raise e unless e.message.include?('no such table: campaigns')
    puts 'please call first `campaign_sync seed`'
  end
end
