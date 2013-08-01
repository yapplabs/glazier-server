module Glazier
  module ApiCredentials
    if Rails.env.test?
      GITHUB_CLIENT_ID = 'fffaaabbb'
      GITHUB_CLIENT_SECRET = 'fffaaabbb123'
    else
      GITHUB_CLIENT_ID = ENV['GLAZIER_GITHUB_CLIENT_ID'] || (raise KeyError, 'GLAZIER_GITHUB_CLIENT_ID is not found in ENV')
      GITHUB_CLIENT_SECRET = ENV['GLAZIER_GITHUB_CLIENT_SECRET'] || (raise KeyError, 'GLAZIER_GITHUB_CLIENT_SECRET is not found in ENV')
    end
  end
end

unless Glazier::ApiCredentials::GITHUB_CLIENT_ID.present? &&
       Glazier::ApiCredentials::GITHUB_CLIENT_SECRET.present?
  raise 'You must set up your GITHUB app credentials as the ENV variables GLAZIER_GITHUB_CLIENT_ID and GLAZIER_GITHUB_CLIENT_SECRET'
end
