class Tweet
<<<<<<< HEAD
  def initialize
    #keeps track of hashtags already merged into db, helps cut down redudant calls
    @merged_hashtags = Array.new
  end
  
  
  def sweep
    RestClient.log =
    Object.new.tap do |proxy|
      def proxy.<<(message)
        Rails.logger.info message
      end
    end
    
    
    locations = {
      "Worldwide" => 1,
      "USA" => 23424977,
      "NY" => 2459115,
      "Cook Count (Chicago)" => 2379574,
      "LA" => 2442047,
      "SF" => 2487956,
      "London" => 44418,
      "Berlin" => 638242,
      "Japan" => 23424856,
      "South Africa" => 23424942,
      "Brazil" => 23424768,
      "Israel" => 23424852,
      "Russia" => 23424936
    }
    
    trending = Array.new
    
    #loop through locations to get trending topics
    locations.each do |key, value|
      begin
        response = JSON.parse(RestClient.get 'https://api.twitter.com/1.1/trends/place.json', params: {id: value}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj')
        response[0]["trends"].each do |trend|
          scan trend["name"] if trend["name"].index("#")  
        end
      rescue => e
        Rails.logger.debug "Error while getting trending #{e}"
      end
    end
  end
  
  def scan starting_tag
    begin
      threshold = 5
      depth = 2
      current_depth = 0
      
      #tweets scanned
      searched_tweets = Array.new
      
      #hashtags to serach
      open = [starting_tag.downcase, 'X']
      
      #hashtags that may be searched if threshold is reached
      buffer = Hash.new
      
      #hashtags already searched
      closed = Array.new
      
      
      while open.count > 0 && current_depth <= depth
        current_tag = open.shift
        
        Rails.logger.debug "Searching for #{current_tag} at depth #{current_depth}"
        
        #if it hit an X, increments depth and adds a new one to the back
        if current_tag == 'X'
          Rails.logger.debug "Diving into map depth level #{current_depth}"
          current_depth += 1
          open << 'X'
          next
        end
        
        #gets tweets with current hashtag
        tweets = search_hashtag current_tag
        
        #creates the hashtag node if one does not already exist
        merge_tag current_tag
     
        
        #serach each tweet
        tweets.each do |t|
          #skips unless tweetID has not already been searched
          next unless searched_tweets.index(t["id"]).nil?
          
          searched_tweets << t["id"]
          
          #looks at each hashtag
          t["hashtags"].each do |h|
            #discards if found the same hashtag
            next if h == current_tag       
            merge_tag h
            merge_cross(current_tag, h, t["id"]) 
            
            #adds to buffer
            if buffer[h].nil?
              buffer[h] = 1
            else
              buffer[h] = buffer[h] + 1
            end
          end
      
         
        end
        
        #removes from buffer is under threshold
        buffer.delete_if{|key, value| value < threshold}
        
        #keeps in buffer if its not already searched
        buffer.keep_if{|key, value| closed.index(key).nil?}
          
        #dumps the remaining into open
        buffer.each_key{|key| open << key}    
        
        #clears the buffer
        buffer.clear  
      end
    rescue => e
      Rails.logger.debug "Error while scanning #{e}"
    end

  end
  
  
  #returns tweetid, downcase hashtags, and text of any related tweet
  def search_hashtag tag
    response = RestClient.get 'https://api.twitter.com/1.1/search/tweets.json', params: {q: tag, count: 100}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj'
    
    tweets = Array.new
    JSON.parse(response)['statuses'].each do |t|
      hashtags = Array.new
      t["entities"]["hashtags"].each do |h|
        hashtags << ("#" + h["text"].downcase)
      end
      tweet={
        "id" => t["id"],
        "text" => t['text'],
        "hashtags" => hashtags
        }
      tweets << tweet
    end
    tweets
  end

  def self.trending
    JSON.parse(RestClient.get 'https://api.twitter.com/1.1/trends/place.json', params: {id: 23424977}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj')
  end
  


  
  def merge_tag tag
    if @merged_hashtags.index(tag) == nil
      url = "http://localhost:7474/db/data/cypher"
      payload = {"query" => "MERGE (n:Hashtag {tag: \"#{tag}\" }) RETURN n"}.to_json
      RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
    end
  end
  
  def merge_cross tag1, tag2, tweetID
    url = "http://localhost:7474/db/data/cypher"
    payload = {
     "query" => "MATCH (_h1:Hashtag {tag: {tag1}}), (_h2:Hashtag {tag: {tag2}}) MERGE (_h1)<-[:CONTAINS]-(_t:Tweet {tweet_id: {tweetID}})-[:CONTAINS]->(_h2) return _t",
     "params" => {
      "tag1" => tag1,
      "tag2" => tag2,
      "tweetID" => tweetID
       }  
     }.to_json
    RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
  end
  
=begin  
=======
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
  def self.search tag    
     RestClient.log =
      Object.new.tap do |proxy|
        def proxy.<<(message)
          Rails.logger.debug message
        end
      end
    
    response = RestClient.get 'https://api.twitter.com/1.1/search/tweets.json', params: {q: tag, count: 100}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj'
    JSON.parse(response)['statuses']
  end
  
<<<<<<< HEAD

  def self.trending
    RestClient.log =
      Object.new.tap do |proxy|
        def proxy.<<(message)
          Rails.logger.debug message
        end
      end
    response = RestClient.get 'https://api.twitter.com/1.1/trends/place.json', params: {id: 1}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj'
       
  end
  
    
=======
  def self.get_related_hashtags hashtag
    parent_hashtag = hashtag.downcase
    json = search parent_hashtag
    col = Hash.new
       
    json.each do |t|
      t['text'].scan(/#\w\w+/).each do |h|
        next if h.nil?
        h.downcase!
        next if h == parent_hashtag
        if col[h].nil?
          col[h] = 1
        else
          col[h] = col[h] + 1
        end
      end
    end
    col
  end
  
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
  def self.get_cross_hashtags(parent_hashtag, threshold, depth)
    tweetIDs = Array.new
    
    #hashtags to search
    open = [parent_hashtag.downcase, 'X']
    currentDepth = 0
    limit = 0
    
    #hashtags that may be searched if threshold is reached
    buffer = Hash.new
    
    #hashtags already searched
    closed = Array.new
    
    #co hashtag results
    cross = Hash.new
<<<<<<< HEAD
        
=======
    
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
    #while there are still hashtags to seach
    while open.count > 0 && currentDepth <= depth do
      current = open.shift
      
      Rails.logger.debug "Searching for #{current} at depth #{currentDepth}"
      
      #if it hit an X, increments depth and adds a new one to the back
      if current == 'X'
        Rails.logger.debug "Diving into map depth level #{currentDepth}"
        currentDepth += 1
        open << 'X'
        next
      end
      
      limit = limit + 1
      
      tweets = search current
      
<<<<<<< HEAD
      #merges node for current hashtag
      current_hashtag_node = get_hashtag_node current

=======
      
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
      #searches each tweet
      tweets.each do |t|
        
        #skips unless tweetID has not already been searched
        next unless tweetIDs.index(t['id']).nil?
        
        #adds tweet to already searched
        tweetIDs << t['id']
        
        #finds each hashtag
        t['text'].scan(/#\w\w+/).each do |h|
        
          #discards if nill
          next if h.nil?
          
          #downcases the hashtag
          h.downcase!
          
          #discards if found the same hashtag
          next if h == current
          
          #adds to buffer
          if buffer[h].nil?
            buffer[h] = 1
          else
            buffer[h] = buffer[h] + 1
          end
          
<<<<<<< HEAD
          #merges node for target hashtag_node
          target_hashtag_node = get_hashtag_node h
          
          add_crosshash current, h, t['id']
          
=======
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
          #generates a key based on the intersection of the hashes
          #keys are always ordered alhabetically
          ordered = [current, h].sort
          cross_hash = "#{ordered[0]}>#{ordered[1]}"
          
          #if cross has not been found, then adds it, if not, increments
          if cross[cross_hash].nil?
            cross[cross_hash] = 1
          else
            cross[cross_hash] = cross[cross_hash] + 1
          end
        end
      end
      
      #removes from buffer is under threshold
      buffer.delete_if{|key, value| value < threshold}
      
<<<<<<< HEAD
      #keeps in buffer if its not already searched
=======
      #keeps in buffer if its not in the array
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
      buffer.keep_if{|key, value| closed.index(key).nil?}
        
      #dumps the remaining into open
      buffer.each_key{|key| open << key}    
      
      #clears the buffer
      buffer.clear       
    end
    
    cross.keep_if{|key, value| value > 3}
  end
  
<<<<<<< HEAD
  # Gets the node for the hashtag, if none available then deletes
  def self.get_hashtag_node(hashtag)
    url = "http://localhost:7474/db/data/cypher"
    payload = {
     "query" => "MERGE (n:Hashtag {tag: {hashtag} }) RETURN n",
     "params" => {
      "hashtag" => hashtag
       }  
     }.to_json
    RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
  end
  
  def self.add_crosshash(hashtag1, hashtag2, tweetid)
=======
  def self.get_related_hashtags_deep(parent_hashtag, threshold)
    hash_tags = get_related_hashtags parent_hashtag
    hash_tags.delete_if{|key, value| value < treshold}
    hash_tags.each do |key, value|
      hash_tags[key] = get_related_hashtags key
    end
    hash_tags
  end
  
  def self.sub_search tag
    tag = tag.downcase
    parent = search tag.downcase
    col = Hash.new
    parent.each do |p|
      child_tag = p['text'][/#\w\w+/]
      unless child_tag.nil?
        d_child_tag = child_tag.downcase
        unless d_child_tag == tag
          if col[d_child_tag].nil?
            h[d_child_tag] = 1
          else
            h[d_child_tag] = h[d_child_tag] + 1
          end
        end        
      end
    end
    
    col
    
    
  end
  
  def self.search_tweet_text
    json = search['statuses']
    text = []
    json.each() do |t|
      text << t['text']
    end
    text
  end
  
  def self.search_hashtags 
    json = search['statuses']
    h = Hash.new
    json.each do |t|
      other_tag = t['text'][/#\w\w+/]
      unless other_tag.nil?
        other_tag = other_tag.downcase
        unless other_tag == '#crc'
          if h[other_tag].nil? 
            h[other_tag] = 1
          else
            h[other_tag] = h[other_tag] + 1
          end
        end
      end
    end
    h.delete_if{|key, value| value < 3}
    
    h.each do |k, v|
      
    end
  end
  
  def self.IDs
>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
     RestClient.log =
      Object.new.tap do |proxy|
        def proxy.<<(message)
          Rails.logger.debug message
        end
      end
<<<<<<< HEAD
     
     url = "http://localhost:7474/db/data/cypher"
     payload = {
     "query" => "MATCH (a:Hashtag)-[r:CrossHash]-(b:Hashtag) WHERE a.tag = {first} AND b.tag = {second} return r",
     "params" => {
      "first" => hashtag1,
      "second" => hashtag2
       }  
     }.to_json
     response = RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
     data = JSON.parse(response)["data"]
     
     #if empty creates crosshash relationship
     if data.empty?
       payload = {
         "query" => "MATCH (a:Hashtag), (b:Hashtag) WHERE a.tag = {first} AND b.tag = {second} CREATE (a)-[r:CrossHash {ids: {tweetids}}]->(b) return r",
         "params" => {
           "first" => hashtag1,
           "second" => hashtag2,
           "tweetids" => [tweetid]
           }  
         }.to_json
       RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
       
     #else adds to it
     else
      payload = {
        "query" => "MATCH (a:Hashtag)-[r:CrossHash]-(b:Hashtag) WHERE a.tag = {first} AND b.tag = {second} return r",
        "params" => {
           "first" => hashtag1,
           "second" => hashtag2
           }  
         }.to_json
      response = RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
      hash = JSON.parse(response)
      puts response
      ids = hash["data"][0][0]["data"]["ids"]
      
      property_url = hash["data"][0][0]["properties"]
      
      ids << tweetid

      
      payload = {
        "query" => "MATCH (a:Hashtag)-[r:CrossHash]-(b:Hashtag) WHERE a.tag = {first} AND b.tag = {second} SET r.ids = {tweetsids} return r",
        "params" => {
          "first" => hashtag1,
          "second" => hashtag2,
          "tweetsids" => ids
           }  
         }.to_json
       response = RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json"
      
     end
  end
=end
=======
    
    lastID = 0
    ids =[]
    for i in 0..9
      ids << "Round #{i} where last id is #{lastID}"
      response = RestClient.get 'https://api.twitter.com/1.1/search/tweets.json', params: {q: '#CRC', count: 100, since_id: lastID}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj'
      json = JSON.parse(response)
      json['statuses'].each_with_index do |t, index|
        if index == 0
          lastID = t['id']
        end
        ids << t['id']
      end
      sleep(1)
    end
    ids
  end
  
  
  def self.map
    h = Hash.new
    lastID = 0
    for i in 0..9
      response = RestClient.get 'https://api.twitter.com/1.1/search/tweets.json', params: {q: '#CRC', count: 100}, Authorization: 'Bearer AAAAAAAAAAAAAAAAAAAAAJr1YQAAAAAAHA%2FAKcuAEPhPSJgFqwcwKMU0wPk%3DwHtz3CIM3eluP3XQDNfXobhvApEBTpyYeWrJ31ZxUukMm1idUj'
      JSON.parse(response)
      text = []
      json['statuses'].each() do |t|
        text << t['text']
        id = t['id']
      end
      
      json.each() do |t|
        other_tag = t['text'][/#\w\w+/]
        unless other_tag.nil?
          other_tag = other_tag.downcase
          unless other_tag == '#crc'
            if h[other_tag].nil? 
              h[other_tag] = 1
            else
              h[other_tag] = h[other_tag] + 1
            end
          end
        end
      end
    end
    h.delete_if{|key, value| value < 50}
    h
  end

>>>>>>> ca020d27df6db3abc4b5743343f0fff3294b07ba
end