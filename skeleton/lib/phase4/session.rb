require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      req_cookie = req.cookies.find { |cookie| cookie.name == '_rails_lite_app' }
      @cookie = (req_cookie.nil? ? {} : JSON.parse(req_cookie.value))
    end

    def [](key)
      @cookie[key]
    end

    def []=(key, val)
      @cookie[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res_cookie = WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
      res.cookies << res_cookie
    end
  end
end
