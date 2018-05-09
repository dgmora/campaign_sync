module CampaignSync
  class Database
    def self.create_test_database
      connect('test')
      define_schema
    end

    def self.seed
      connect('development')
      define_schema
      Campaign.create(job_id: 1, external_reference: '1', name: 'A Job',
                      ad_description: 'foo')
    end

    private_class_method def self.connect(env)
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
