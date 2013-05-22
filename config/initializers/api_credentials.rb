module Glazier
  module ApiCredentials
    if Rails.env.test?
      GITHUB_CLIENT_ID = 'fffaaabbb'
      GITHUB_CLIENT_SECRET = 'fffaaabbb123'
    else
      GITHUB_CLIENT_ID = ENV['GLAZIER_GITHUB_CLIENT_ID']
      GITHUB_CLIENT_SECRET = ENV['GLAZIER_GITHUB_CLIENT_SECRET']
    end
  end
end

unless Glazier::ApiCredentials::GITHUB_CLIENT_ID.present? &&
       Glazier::ApiCredentials::GITHUB_CLIENT_SECRET.present?
  raise 'You must set up your GITHUB app credentials as the ENV variables GLAZIER_GITHUB_CLIENT_ID and GLAZIER_GITHUB_CLIENT_SECRET'
end
