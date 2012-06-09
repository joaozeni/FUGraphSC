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