module SignedCookies
  def signed_cookie(name, opts={})
    verifier = ActiveSupport::MessageVerifier.new(request.env["action_dispatch.secret_token".freeze])
    if opts[:value]
      @request.cookies[name] = verifier.generate(opts[:value])
    else
      verifier.verify(cookies[name])
    end
  end
end
