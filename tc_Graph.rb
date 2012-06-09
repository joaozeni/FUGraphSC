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

	def test_removing_node
		@g.add_node("x")
		@g.remove_node("x")
		assert_equal(false, @g.nodes.include?("x"))
	end

	def test_removing_error
		assert_raise (ArgumentError) { @g.remove_node("x") }
	end

	def test_adding_a_vertice
		@g.add_node("x")
		@g.add_node("y")
		@g.add_vertice("x","y")
		assert(@g.edges.has_key?("x"))
		assert(@g.edges.has_key?("y"))
		assert(@g.edges["y"].include?("x"))
		assert(@g.edges["x"].include?("y"))
	end

	def test_adding_a_vertice_error
		@g.add_node("x")
		assert_raise (ArgumentError) {@g.add_vertice("x","y")}
	end
end