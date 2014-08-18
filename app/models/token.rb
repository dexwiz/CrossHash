class Token
<<<<<<< HEAD
  

=======
  def self.bearer_token
    response = RestClient.post 'https://api.twitter.com/oauth2/token', 'grant_type=client_credentials', 'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8', Authorization: 'Basic dVNmblZMVmVDRk9KOEl0OVFsa1J4RzhlYzpZV2JCc0VRMFdUSVZJNUQzd2hLZzFWS1hpNEFRY01FWjM4QkFqQVNXWmhwSUVFWEg3OA=='
    JSON.parse(response.body)
  end
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
end