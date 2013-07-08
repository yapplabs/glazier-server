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

  factory :pane_entry

  factory :pane_user_entry do
    user
  end

  factory :pane_type_user_entry do
    user
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

    factory :dashboard_with_data do
      after(:create) do |dashboard|
        pane_type = create(:pane_type)
        user = create(:user)
        pane = create(:pane, pane_type: pane_type, repository: dashboard)
        create(:pane_entry, key: 'foo', value: 'bar', pane: pane)
        create(:pane_user_entry, key: 'foo_user', value: 'bar_user', pane: pane, user: user)
        create(:pane_type_user_entry, key: 'foo_type_user', value: 'bar_type_user', pane_type: pane_type, user: user)
      end
    end
  end
end
