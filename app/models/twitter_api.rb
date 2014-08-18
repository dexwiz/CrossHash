class TwitterAPI
  
  def initialize
    @bearer_auth = 'Bearer ' + bearer_token
  end
  
  def bearer_token
    response = RestClient.post 'https://api.twitter.com/oauth2/token', 'grant_type=client_credentials', 'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8', Authorization: 'Basic dVNmblZMVmVDRk9KOEl0OVFsa1J4RzhlYzpZV2JCc0VRMFdUSVZJNUQzd2hLZzFWS1hpNEFRY01FWjM4QkFqQVNXWmhwSUVFWEg3OA=='
    JSON.parse(response.body)["access_token"]
  end
  
  def execute(resource, params={})
    begin
      
      url = 'https://api.twitter.com/1.1/' + resource
      token = 'Bearer'
      response = RestClient.get url, params: params, Authorization: @bearer_auth
    rescue Exception => response
      Rails.logger.debug response.http_code
    end
  end
  
  def search string
    params = {q: string, count: 100}
    response = execute 'search/tweets.json', params
  end
end