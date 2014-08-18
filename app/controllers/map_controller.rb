class MapController < ApplicationController
  def show
    @out1 = Tweet.get_related_hashtags URI.unescape(params[:id])
    @out2 = Tweet.get_cross_hashtags params[:id], 5, 1
    node_array = Array.new
    nodes = Array.new
    edges = Array.new
    
    @out2.each do |key, value|
      split = key.split(">")
      node_array << split[0]
      node_array << split[1]
      edges << {id: key, source: split[0], target: split[1]}
    end
    
    node_array.uniq!
    
    x = 0
    y = 0
    i = 0
    node_array.each do |n|
      nodes << {id: n, size: 3, label: n, x: Math.cos(2 * i), y: Math.sin(2 * i)}
      x=x+1
      y=y+1
      i=i+1
    end

    
    @graph = {nodes: nodes, edges: edges}

  end
end
