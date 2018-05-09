module CampaignSync
  class Database
    def self.create_test_database
      connect('test')
      define_schema
    end

    def self.seed
      connect('development')
      if ActiveRecord::Base.connection.tables.include?('campaigns')
        puts 'droping campaigns table'
        ActiveRecord::Base.connection.execute('DROP TABLE campaigns;')
      end
      define_schema
      puts 'seeding'
      # This one will be different (campaign 11)
      Campaign.create(job_id: 1, external_reference: '1', name: 'A Job',
                      ad_description: 'campaign 11 (different)')
      # This one will be the same (campaign 12)
      Campaign.create(job_id: 1, external_reference: '2', name: 'A Job',
                      ad_description: 'Description for campaign 12',
                      status: :paused)
      # This one will be missing remotely
      Campaign.create(job_id: 1, external_reference: '4', name: 'A Job',
                      ad_description: 'campaign 14 (missing remotely)')
      # campaign 13 will be missing locally
    end

    def self.connect(env)
      config = YAML.load_file('config/database.yml')[env]
      ActiveRecord::Base.establish_connection(config)
    end

    private_class_method def self.define_schema
      ActiveRecord::Schema.define do
        create_table :campaigns do |t|
          t.string :name
          # This is probably a reference but we don't have the other table
          t.integer :job_id, null: false, unique: true
          t.integer :status, null: false, default: 0
          t.string :external_reference, null: false
          t.text :ad_description, null: false
        end
      end
    end
  end
end
