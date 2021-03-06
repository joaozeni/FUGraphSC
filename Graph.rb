require "set"

class Graph
	def initialize()
		@nodes = Set.new
		@edges = Hash.new
		@nodes_attr = Hash.new
		@edges_attr = Hash.new
	end

	#Usados nos testes.
	attr_accessor :nodes
	attr_accessor :edges
	attr_accessor :nodes_attr
	attr_accessor :edges_attr

	def add_node(node, node_attr_name=[], node_attr=[])
		@nodes << node
		@edges[node] = Set.new
		@edges_attr[node] = Hash.new
		@nodes_attr[node] = Hash.new
		node_attr_name.each_index{|x| @nodes_attr[node][node_attr_name[x]] = node_attr[x]}
	end

	def add_node_attr(node, node_attr_name=[], node_attr=[])
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		node_attr_name.each_index{|x| @nodes_attr[node][node_attr_name[x]] = node_attr[x]}
	end

	def remove_node_attr(node, node_attr_name=[], node_attr=[])
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		node_attr_name.each_index{|x| @nodes_attr[node].delete(node_attr_name[x])}
	end

	def remove_node(node)
		raise ArgumentError, "The graph doesn't contais the node" if !@nodes.include?(node)
		@nodes.delete(node)
		@edges_attr.delete(node)
		@nodes_attr.delete(node)
		@edges[node].each{|x| @edges[x].delete(node)}
		@edges.delete(node)
	end

	def add_edge(node1, node2, edge_attr_name=[], edge_attr=[])
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		@edges[node1] << node2
		@edges_attr[node1][node2] = Hash.new
		edge_attr_name.each_index{|x| @edges_attr[node1][node2][edge_attr_name[x]] = edge_attr[x]}
		@edges[node2] << node1
		@edges_attr[node2][node1] = Hash.new
		edge_attr_name.each_index{|x| @edges_attr[node2][node1][edge_attr_name[x]] = edge_attr[x]}
	end

	def remove_edge(node1, node2)
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		raise ArgumentError, "The graph doesn't contain the edge" if ( !@edges[node1].include?(node2) | !@edges[node2].include?(node1))
		@edges[node1].delete(node2)
		@edges[node2].delete(node1)
		@edges_attr[node1].delete(node2)
		@edges_attr[node2].delete(node1)
	end

	def add_edge_attr(node1, node2, edge_attr_name=[], edge_attr=[])
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		raise ArgumentError, "The graph doesn't contain the edge" if ( !@edges[node1].include?(node2) | !@edges[node2].include?(node1))
		edge_attr_name.each_index{|x| @edge_attr[node1][node2][edge_attr_name[x]] = edge_attr[x]}
		edge_attr_name.each_index{|x| @edge_attr[node2][node1][edge_attr_name[x]] = edge_attr[x]}
	end

	def remove_edge_attr(node1, node2, edge_attr_name=[], edge_attr=[])
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		raise ArgumentError, "The graph doesn't contain the edge" if ( !@edges[node1].include?(node2) | !@edges[node2].include?(node1))
		edge_attr_name.each_index{|x| @edge_attr[node1][node2].delete(edge_attr_name[x])}
		edge_attr_name.each_index{|x| @edge_attr[node2][node1].delete(edge_attr_name[x])}
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
		areadyVisited = areadyVisited + node
		tc = tc + node
		neighbours(node).each do |x|
			if !areadyVisited.include?(x)
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
		printed = Set.new
		@edges.each_key do |x|
			@edges[x].each{|y| if ! printed.include?(y); graph_string << x.to_s + "<->" + y.to_s + "\n";end}
			printed << x
		end
		return graph_string
	end

	def shortest_path_dijkstra(node1, node2)
		raise ArgumentError, "The graph doesn't contais one of the nodes" if ( !@nodes.include?(node1) | !@nodes.include?(node2))
		d = Hash.new
		prev = Hash.new
		infinity = 1 << 64
		dtotal = 0
		@nodes.each { |x| d[x] = infinity }
		@nodes.each { |x| add_node_attr(x, ["mark"], [false]) }
		q = @nodes
		d[node1] = 0
		prev[node1] = nil
		atual = node1
		while(q.size > 0) do
			@edges[atual].each do |x|
				if d[x] > dtotal + @edges_attr[node1][x]["weight"]
					d[x] = dtotal + @edges_attr[node1][x]["weight"]
				end
			end
			prox = get_min(d)
			prev[prox] = atual
			dtotal = dtotal + get_min_value(d)
			q.delete(atual)
			atual = prox
		end
		path = find_path(prev, node2)
		return path
	end

	def find_path(ant, node)
		x = []
		if ant[node] == nil
			return x = x + node
		else
			return x = x + node + find_path(ant, ant[node])
		end
	end

	def get_min_key(x)
		min_value = x[x.keys[0]]
		min_key = x.keys[0]
		x.each_value do |v|
			if v < min_value
				min_value = v
				min_key = x.key(v)
			end
		end
		return min_key
	end

	def get_min_value(x)
		min_value = x[x.keys[0]]
		x.each_value do |v|
			if v < min_value
				min_value = v
			end
		end
		return min_value
	end
end