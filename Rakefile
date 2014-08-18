# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
<<<<<<< HEAD
Myapp::Application.load_tasks


namespace :tweetdb do
  
  task :clear_db => :environment do
    url = "http://localhost:7474/db/data/cypher"
    payload = {
     "query" => "MATCH (n)OPTIONAL MATCH (n)-[r]-() DELETE n, r",
     }.to_json
    puts RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
  end
  
  task :populate => :environment do
    Tweet.scan("#finallya5osalbum")
  end
  
  task :all_hashtags => :environment do
    url = "http://localhost:7474/db/data/cypher"
    payload = {
     "query" => "MATCH (n:Hashtag) RETURN n",
     }.to_json
    puts RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
  end
  

  
  task :count_crosshash => :environment do
    url = "http://localhost:7474/db/data/cypher"
    payload = {
     "query" => "MATCH p=(h1:Hashtag)<--(t:Tweet)-->(h2:Hashtag) WHERE id(h1)> id(h2) RETURN id(h1), h1.tag, id(h2), h2.tag, count(p)",
     }.to_json
    puts RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
  end
  
  task :trending => :environment do
    Tweet.trending[0]["trends"].each do |trend|
      puts trend["name"] if trend["name"].index("#")      
    end
  end
  
  task :trending_scan => :environment do
    Tweet.trending[0]["trends"].each do |trend|
      Tweet.scan(trend["name"]) if trend["name"].index("#")      
    end
  end
  
  task :sweep => :environment do
    t = Tweet.new 
    t.sweep
  end
  
  task :fail => :environment do
    begin
      response = RestClient.get 'https://api.twitter.com/1.1/search/tweetsasdf.json' , Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj'
      puts response
    rescue => e
      puts e.http_code
    end
  end
  
  task :top => :environment do
	url = "http://localhost:7474/db/data/cypher"
    payload = {
		"query" => "MATCH p=(h:Hashtag)<--(t:Tweet) WITH h, COUNT(t) AS tw ORDER BY tw DESC LIMIT 10 RETURN h.tag",
		}.to_json
	
    out = JSON.parse(RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json")
	puts out
  end

=begin  
    task :create_cross => :environment do
        url = "http://localhost:7474/db/data/cypher"
    payload = {
     "query" => "MERGE (n:Hashtag {tag: {hashtag} }) RETURN n",
     "params" => {
      "hashtag" => hashtag
       }  
     }.to_json
    RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
  end
  
   
  task :tweets => :environment do
    puts JSON.pretty_generate(Tweet.search_hashtag("#finallya5osalbum"))
  end
=end
end
=======

Rails.application.load_tasks
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
