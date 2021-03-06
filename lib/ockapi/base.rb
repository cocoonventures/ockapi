REDIS_CONFIG = {
  'host' => "localhost",
  'port' => "6379",
  'namespace' => "ockapi",
  'db' => 15
}

redis = Redis.new(:host => REDIS_CONFIG['host'], :port => REDIS_CONFIG['port'],
                  :thread_safe => true, :db => REDIS_CONFIG['db'])
$redis = Redis::Namespace.new(REDIS_CONFIG['namespace'], :redis => redis)

module Ockapi
  class Base
    def initialize
      HTTParty::HTTPCache.logger = Logger.new(STDOUT)
      HTTParty::HTTPCache.redis = $redis
      HTTParty::HTTPCache.perform_caching = true
      CacheBar.register_api_to_cache('api.opencorporates.com', {:key_name => "opencorporates", :expire_in => 7200})
      CacheBar.register_api_to_cache('opencorporates.com', {:key_name => "opencorporates_reconciliation", :expire_in => 7200})
      CacheBar.register_api_to_cache('api.companieshouse.gov.uk', {:key_name => "companieshouse", :expire_in => 7200})
      CacheBar.register_api_to_cache('document-api.companieshouse.gov.uk', {:key_name => "companieshouse_docs", :expire_in => 7200})
    end

    def run
      if ENV['OPENC_API_TOKEN'].nil?
        $stderr.puts "WARNING: OpenCorporates API token not found. Some features will not work."
        $stderr.puts "Please export the OPENC_API_TOKEN in your shell before starting ockapi"
      end
      binding.pry
    end

    # connection = Connection.new
    # connection.query(registered_address:"Ewhurst GU6", current_status: "Active", jurisdiction_code: "gb", api_token: ENV['OPENC_API_TOKEN'])

    # client   = Client.new(connection: connection)
    # Doesn't deal with nested hash for source atm
    # result = client.companies["results"]["companies"].map {|x| x["company"] }
    # Representation.new({"companys" => result}).companys

    # Return single company - reconcile
    # OpenCorporatesAPI::Company.find
    # OpenCorporatesAPI::Company.find_by

    # Return collections
    # OpenCorporatesAPI::Company.search(opts = {q: "string", limit: 30, load_full_details: true})

    # Implement these later?
    # Placeholder
    # CorporateGrouping
    # Filing
    # Statement
  end
end
