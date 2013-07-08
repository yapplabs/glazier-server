# This controller mixin adds a current_user getter/setter for authenticating the request
#
# Would love to use ActiveSupport::MessageVerifier but it forces the use of base 64 encoding
# and signed cookies forces the use of Marshal dump/load so this isn't readable from the
# client side.
#
# Backed by a signed cookie, this cookie is readable by JS and is intended to be HTTPS only
#
# uses cookies and request.env provided by the controller
module Authentication
  private

  # Gets the authenticated current_user as a hash
  def current_user
    return @current_user if defined? @current_user

    signed_user_json = cookies[:login]

    @current_user = Authentication.verified_cookie_value(signed_user_json, secret_token)
  end

  # Sets the current_user
  def current_user=(user)
    signed_user_json = Authentication.generate_cookie_value(user, secret_token)
    cookies.permanent[:login] = signed_user_json

    @current_user = user
  end

  def secret_token
    request.env["action_dispatch.secret_token"]
  end

  # Generate signed_user_json from user_serializable_hash using secret
  def self.generate_cookie_value(user, secret)
    user_serializable_hash = UserSerializer.new(user).serializable_hash
    user_json = ::ActiveSupport::JSON.encode(user_serializable_hash)
    digest = generate_digest(secret, user_json)
    "#{digest}-#{user_json}"
  end

  # Verify signed_user_json and return user hash using secret
  def self.verified_cookie_value(signed_user_json, secret)
    return nil unless signed_user_json
    digest, user_json = signed_user_json.split("-",2)
    return unless secure_compare(digest, generate_digest(secret, user_json))
    user_hash = ActiveSupport::JSON.decode(user_json, symbolize_keys: true) rescue nil
    return unless user_hash
    User.find(user_hash[:github_id])
  end

  # HMAC SHA1
  def self.generate_digest(secret, data)
    OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, secret, data)
  end

  # Taken from ActiveSupport::MessageVerifier.secure_compare
  def self.secure_compare(a, b)
    return false unless a.bytesize == b.bytesize

    l = a.unpack "C#{a.bytesize}"

    res = 0
    b.each_byte { |byte| res |= byte ^ l.shift }
    res == 0
  end
end
