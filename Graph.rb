require "set"

class Graph
	def initialize()
		@nodes = Set.new
		@edges = Hash.new
		@nodes_attr = Hash.new
		@edges_attr = Hash.new
	end

	attr_accessor :nodes
	attr_accessor :edges

	def add_node(node)
		@nodes << node
		@edges[node] = Set.new
		@edges_attr[node] = Set.new
		@nodes_attr[node] = Set.new
	end

	def remove_node(node)
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		@nodes.delete(node)
		@edges_attr.delete(node)
		@nodes_attr.delete(node)
	end

	def add_vertice(node1, node2)
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		@edges[node1] << node2
		@edges[node2] << node1
	end

	def remove_vertice(node1, node2)
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		raise ArgumentError, "The graph doesn't contain the edge" if ( !@edges[node1].include?(node2) | !@edges[node2].include?(node1))
		@edges[node1].delete(node2)
		@edges[node2].delete(node1)
	end

	def order
		return @nodes.size
	end

	def nodes
		return @nodes
	end

	def a_node
		return @nodes.to_a[rand(@nodes.size)]
	end

	def neighbours(node)
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		return @edges[node]
	end

	def degree(node)
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		return @edges[node].size
	end

	def is_regular
		node = @nodes.to_a[0]
		n =  degree(node)
		@nodes.each do |x|
			if degree(x) != n
				return false
			end
		end
		return true
	end

	def is_complete
		n = @nodes.size - 1
		@nodes.each do |x|
			if degree(x) != n
				return false
			end
		end
		return true
	end

	def transitive_closure(node)
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		tc = Set.new
		return search_transitive_closure(node, tc)
	end

	def search_transitive_closure(node, areadyVisited)
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		tc = Set.new
		areadyVisited << node
		neighbours(node).each do |x|
			if ! areadyVisited.include?(x)
				tc = tc + search_transitive_closure(x, areadyVisited)
			end
		end
		return tc
	end

	def is_connected
		return @nodes == transitive_closure(a_node())
	end

	def to_s
		graph_string = String.new
		@edges.each_key do |x|
			@edges[x].each{|y| graph_string << x.to_s + "->" + y.to_s + "\n"}
		end
		return graph_string
	end
end