require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      if req.query_string.nil?
        @params = {}
      else
        @params = parse_www_encoded_form(req.query_string)
      end

      @params.merge!(parse_www_encoded_form(req.body)) if req.body
      @params.merge!(route_params)
    end

    def [](key)
      @params[key.to_s] || @params[key.to_sym]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      params = URI::decode_www_form(www_encoded_form)
      params_hash = {}

      params.each do |keys, value|
        keys = parse_key(keys)

        scope = params_hash

        keys.each_with_index do |key, idx|
          if idx == (keys.count - 1)
            scope[key] = value
          else
            scope[key] ||= {}
            scope = scope[key]
          end
        end
      end

      params_hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
