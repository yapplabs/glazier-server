FactoryGirl.define do
  sequence(:repository) {|n| "owner/repo#{n}.js" }
  sequence(:uuid) { SecureRandom.uuid }

  factory :user do
    github_id 123
    github_access_token 'opaque-access-token'
    github_login 'jsnow'
    name 'Jon Snow'
    email 'jsnow@winterfell.net'
    gravatar_id '123'
  end

  factory :pane_type do
    name 'yapplabs/pane-type'
    url {
      "http://glazier.s3.amazonaws.com/#{name}/manifest.json"
    }
    manifest {
      "{\"name\":\"#{name}\",\"cardUrl\":\"http://glazier.s3.amazonaws.com/#{name}/card.js\"}"
    }
  end

  factory :pane do
    id { generate(:uuid) }
    pane_type
  end

  factory :dashboard do
    repository { generate(:repository) }

    factory :dashboard_with_default_panes do
      after(:create) do |dashboard|
        Dashboard::DEFAULT_PANE_TYPE_NAMES.each do |pane_type_name|
          pane_type = create(:pane_type, name: pane_type_name)
          create(:pane, pane_type: pane_type, repository: dashboard)
        end
      end
    end
  end
end
