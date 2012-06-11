require "Graph"
require "test/unit"

class TcGraph < Test::Unit::TestCase
	
	def setup
		@g = Graph.new
	end

	def test_adding_a_node
		@g.add_node("x")
		assert(@g.nodes.include?("x"), "teste")
	end

	def test_adding_a_node_with_weight
		@g.add_node("x", ["weight"], [15])
		assert(@g.nodes.include?("x"), "teste")
		assert(@g.nodes_attr["x"].has_key?("weight"), "teste")
		assert_equal(15, @g.nodes_attr["x"]["weight"], "teste")
	end

	def test_removing_node
		@g.add_node("x")
		@g.remove_node("x")
		assert_equal(false, @g.nodes.include?("x"))
	end

	def test_removing_node_with_weight
		@g.add_node("x", ["weight"], [15])
		@g.remove_node("x")
		assert_equal(false, @g.nodes.include?("x"))
		assert_equal(false, @g.nodes_attr.has_key?("x"), "teste")
	end

	def test_removing_error
		assert_raise (ArgumentError) { @g.remove_node("x") }
	end

	def test_adding_a_edge
		@g.add_node("x")
		@g.add_node("y")
		@g.add_edge("x","y")
		assert(@g.edges.has_key?("x"))
		assert(@g.edges.has_key?("y"))
		assert(@g.edges["y"].include?("x"))
		assert(@g.edges["x"].include?("y"))
	end

	def test_adding_a_edge_with_weight
		@g.add_node("x")
		@g.add_node("y")
		@g.add_edge("x","y", ["weight"], [15])
		assert(@g.edges.has_key?("x"))
		assert(@g.edges.has_key?("y"))
		assert(@g.edges["y"].include?("x"))
		assert(@g.edges["x"].include?("y"))
	end

	def test_adding_a_edge_error
		@g.add_node("x")
		assert_raise (ArgumentError) {@g.add_edge("x","y")}
	end
end