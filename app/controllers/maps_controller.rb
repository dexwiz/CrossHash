class MapsController < ApplicationController
	def index
	url = "http://localhost:7474/db/data/cypher"
		payload = {
		"query" => "MATCH p=(h:Hashtag)<--(t:Tweet) WITH h, COUNT(t) AS tw ORDER BY tw DESC LIMIT 10 RETURN h.tag",
		}.to_json
		
		response = JSON.parse(RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json")
	
	
	@hashtags = Array.new
	response["data"].each do |t|
		@hashtags << t[0]
	end
	
	end
	
	def show
		@root_hashtag = URI.decode(params[:id])
		#get all hashtags
		#"MATCH p=(h1:Hashtag)<--(t1:Tweet)-->(h2:Hashtag) WHERE id(h1)> id(h2) RETURN id(h1), h1.tag, id(h2), h2.tag, count(t1)"
		url = "http://localhost:7474/db/data/cypher"
		payload = {
			"query" =>"MATCH p=(h1:Hashtag)<--(t1:Tweet)-->(h2:Hashtag),  shortestPath((h1:Hashtag)-[*]-(s:Hashtag { tag: {hashtag} })) WHERE id(h1)> id(h2) RETURN id(h1), h1.tag, id(h2), h2.tag, count(t1)",
			"params" => {
				"hashtag" => @root_hashtag	
		 }
		 
		 }.to_json
		response = JSON.parse(RestClient.post url, payload, accept: "application/json; charset=UTF-8", content_type: "application/json")


		nodes = Array.new
		edges = Array.new		
		x=0
		y=0
		i=0
		#data in response is returned in format
		#node1 id, hashtag1, node2, hashtag2, count relationship
		response["data"].each do |h|
			nodes << {id: "n#{h[0]}", size: 3, label: h[1], x: Math.cos(2 * i), y: Math.sin(2 * i)}
			nodes << {id: "n#{h[2]}", size: 3, label: h[3], x: 1+Math.cos(2 * i), y: 1+Math.sin(2 * i)}
			edges << {id: "e#{i}", source: "n#{h[0]}", target: "n#{h[2]}"}
			x=x+1
			y=y+1
			i=i+1 
		end

		#remove dupes from node
		nodes.uniq!{ |n| n[:id] }
		
		@graph = {nodes: nodes, edges: edges}
		@hashtag_count = nodes.length
	end
end
