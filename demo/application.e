note
	description: "[
		Root class for demonstrating/testing the graph cluster.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/demo/application.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize and launch application
		do
			io.put_string ("Begin graph testing -----------------------------------%N")
			io.put_string ("-------------------------------------------------------%N")
			create iterator
			create simple_graph
			create basic_graph
			simple_graph.compare_objects
			basic_graph.compare_objects
			build_graphs
			test
			test_path_features

--			test_b_tree
			io.put_string ("End graph testing %N")
			io.new_line
			io.new_line
		end

feature -- Basic operations

	test_b_tree
			-- Run test on b-tree
		local
			b_tree: B_TREE [INTEGER]
			rand: RANDOM
			i: INTEGER
			n: INTEGER
			test_count: INTEGER
		do
			test_count := 20
			create b_tree
			create rand.make
			from i := 1
			until i > test_count
			loop
				n := rand.i_th (i) \\ 10 + 1
				b_tree.extend (n)
				io.put_string ("insert " + n.out + "%N")
				b_tree.show
				i := i + 1
			end
		end

	test_path_features
			-- Test `shortest_paths', etc
		local
			g: VALUED_WEIGHTED_GRAPH [STRING, INTEGER]
			it: VALUED_WEIGHTED_GRAPH_ITERATOR [STRING, INTEGER]
			a_node, b_node, c_node, d_node: VALUED_WEIGHTED_NODE [STRING, INTEGER]
			sp: JJ_SORTABLE_ARRAY [VALUED_WEIGHTED_PATH [STRING, INTEGER]]
		do
			io.put_string ("APPLICATION.test_path_feature:  BEGIN %N")
			create g
--			g.compare_objects	-- because of string
			create a_node.make_with_value ("a")
			create b_node.make_with_value ("b")
			create c_node.make_with_value ("c")
			create d_node.make_with_value ("d")
			g.connect_nodes_weighted (a_node, b_node, 1)
			g.connect_nodes_weighted (a_node, c_node, 2)
			g.connect_nodes_weighted (b_node, c_node, 3)
			g.connect_nodes_weighted (b_node, d_node, 4)
			g.connect_nodes_weighted (c_node, d_node, 5)
			it := g.iterator
			sp := it.shortest_paths (a_node, d_node, 3)
			io.put_string ("Result of it.shortest_paths %N")
			from sp.start
			until sp.is_after
			loop
				sp.item.show
				sp.forth
			end
			io.put_string ("APPLICATION.test_path_feature:  END %N")
		end

	test
			-- Start the testing
		do
			io.put_string ("Enter `test' %N")
			iterator := simple_iterator
			test_traversals
			iterator := basic_iterator
			test_traversals

--			test_looping_graph
			io.put_string ("Exit `test' %N")
		end

	test_looping_graph
			-- Test path traversal for children only breadth-first
		do
			io.put_string ("APPLICATION.test_looping_graph %N")
			iterator := looping_iterator
			iterator.see_visibles
			iterator.inspect_relations
			iterator.set_breadth_first
			iterator.traverse_edges
			show
			iterator.inspect_children
			iterator.explore_paths
			iterator.see_visibles
			show
			iterator.inspect_relations
			iterator.explore_paths
			iterator.see_visibles
			show
			io.put_string ("End APPLICATION.test_looping_graph %N")
		end

	test_traversals
			-- Test the various types of graph traversals
		do

				-- Breadth-first
			io.put_string ("-------------------------------------------------------%N")
			iterator.set_breadth_first
			check_traversal_policies

				-- Pre-order
			io.put_string ("-------------------------------------------------------%N")
			iterator.set_pre_order
			check_traversal_policies

				-- Post-order
			io.put_string ("-------------------------------------------------------%N")
			iterator.set_post_order
			check_traversal_policies

--				-- In-order
--			io.put_string ("-------------------------------------------------------%N")
--			iterator.set_in_order
--			io.put_string ("In order %N")
--			show

--			iterator.set_bottom_up
--			io.put_string ("Bottom up   FIX ME !!! %N")
----			show

--			iterator.set_leaf_first
--			io.put_string ("Leaf first %N")
--			show

--			iterator.set_leaves_only
--			io.put_string ("Leaves only %N")
--			show

--			iterator.set_shortest_first
--			io.put_string ("Shortes_first  FIX ME !!! %N")
----			show	

--			iterator.set_pre_order		-- same as depth_first?
--			io.put_string ("Pre order  FIX ME !!! %N")
----			show

--			iterator.set_depth_first
--			io.put_string ("Deapth_first   FIX ME !!! %N")
----			show
		end

	check_traversal_policies
			-- Visit nodes, traverse edges, or explore paths
		do
			if iterator /= simple_iterator then
				iterator.visit_nodes
				check_traversal_visibilities
				iterator.traverse_edges
				check_traversal_visibilities
			else
				iterator.explore_paths
				check_traversal_visibilities
			end
		end

	check_traversal_visibilities
			-- Check both cases; visit only node & edges that are in the graph,
			-- then visit nodes and edges that are reachable
		do
			iterator.see_visibles
			check_traversal_directions
			iterator.see_reachables
			check_traversal_directions
		end

	check_traversal_directions
			-- Check each combination of traversal policy
		do
				iterator.inspect_children
				show
				iterator.inspect_parents
				show
				iterator.inspect_relations
				show
		end

feature {NONE} -- Implementation

	show
			-- Display the graph
		local
			s: STRING
			i: INTEGER
			p: VALUED_PATH [STRING]
			s_tab: HASH_TABLE [STRING, STRING]
			count: INTEGER
		do
			if iterator.is_breadth_first then
				s := "Breadth-first:  "
			elseif iterator.is_pre_order or iterator.is_depth_first then
				s := "Pre-order/Depth-first:  "
			elseif iterator.is_post_order then
				s := "Post-order: "
			else
				s := "Unknown:  "
			end
			if iterator.is_exploring_paths then
				s := s + "is_exploring_paths, "
			elseif iterator.is_visiting_nodes then
				s := s + "is_visiting_nodes, "
			elseif iterator.is_traversing_edges then
				s := s + "is_traversing_edges, "
			else
				s := s + "unknown, "
			end
			if iterator.is_inspecting_relations then
				s := s + "is_inspecting_relations, "
			elseif iterator.is_inspecting_children then
				s := s + "is_inspecting_children, "
			elseif iterator.is_inspecting_parents then
				s := s + "is_inspecting_parents, "
			else
				s := s + "unknown, "
			end
			if iterator.is_seeing_reachables then
				s := s + "is_seeing_reachables"
			else
				s := s + "is seeing visibles ONLY"
			end
			io.put_string (s + "%N")
			create s_tab.make (500)
			from iterator.start
			until iterator.is_after
			loop
				count := count + 1
				s := ""
				p := iterator.path
				from i := 1
				until i > p.node_count
				loop
					s := s + p.i_th_node (i).value + " "
					i := i + 1
				end
				io.put_string (count.out + ":  " + s)
				if s_tab.has (s) then
					io.put_string ("Error:  path included twice  %N")
				else
					s_tab.put (s, s)
				end
				io.new_line
				iterator.forth
			end
			io.new_line
		end

	basic_graph: VALUED_GRAPH [STRING]
	simple_graph: like basic_graph

	build_graphs
			-- Create the graphs
		do
			build_simple_graph
			build_basic_graph
		end

	build_simple_graph
			-- graph with two nodes
		do
			io.put_string ("Enter `build_simple_graph' %N")
			simple_graph.connect ("X", "Y")
			simple_graph.connect ("Y", "Y")
			io.put_string ("Exit `simple_graph' %N")
		end

	build_basic_graph
			-- Used to test traversals
		do
			basic_graph.connect_directed ("e1", "b2")
			basic_graph.connect ("b2", "d3")
			basic_graph.connect ("c5", "g7")
			basic_graph.connect ("a4", "b2")
			basic_graph.connect_directed ("a4", "c5")
			basic_graph.connect_directed ("d3", "c5")
			check attached simple_graph.find_valued_node ("X") as n then
				basic_graph.extend_node (n)
				basic_graph.connect ("c5", "X")
			end
		end

	looping_graph: VALUED_GRAPH [STRING]
			-- Test path traversals, especially in presence of loops
			-- as well as sorting.
			-- Should have edges from 1 to 2, 2 to 2, 2 to 3a, and loop from
			-- 3 to 4 to 5 back to 3.
		do
			create Result
			Result.connect ("2", "3")
			Result.connect_directed ("1", "2")
			Result.connect_directed ("3", "4")
			Result.set_ordered
--			Result.connect ("4", "5")
--			Result.connect ("5", "3")	-- loop
			Result.connect_directed ("2", "2")	-- loop
		end

	basic_iterator: VALUED_GRAPH_ITERATOR [STRING]
			-- Used to test traversals
		do
			Result := basic_graph.iterator
			Result.set_root ("a4")
		end

	looping_iterator: VALUED_GRAPH_ITERATOR [STRING]
			-- Used to test paths with loops
		do
			Result := looping_graph.iterator
			Result.set_root ("1")
		end

	simple_iterator: VALUED_GRAPH_ITERATOR [STRING]
			-- Used to test paths with loops
		do
			Result := simple_graph.iterator
			Result.set_root ("X")
		end

	iterator: VALUED_GRAPH_ITERATOR [STRING]
			-- For traversing



	declare_entities
			-- Declare an entity simply to force a compile for testing
		local
			g: GRAPH
			n: NODE
			e: EDGE
			vg: VALUED_GRAPH [CITY]
			vn: VALUED_NODE [CITY]
			ve: VALUED_EDGE [CITY]
			lg: LABELED_GRAPH [STREET]
			ln: LABELED_NODE [STREET]
			le: LABELED_EDGE [STREET]
			wg: WEIGHTED_GRAPH [DISTANCE]
			wn: WEIGHTED_NODE [DISTANCE]
			we: WEIGHTED_EDGE [DISTANCE]
			vlg: VALUED_LABELED_GRAPH [CITY, STREET]
			vln: VALUED_LABELED_NODE [CITY, STREET]
			vle: VALUED_LABELED_EDGE [CITY, STREET]
			vwg: VALUED_WEIGHTED_GRAPH [CITY, DISTANCE]
			vwn: VALUED_WEIGHTED_NODE [CITY, DISTANCE]
			vwe: VALUED_WEIGHTED_EDGE [CITY, DISTANCE]
			lwg: LABELED_WEIGHTED_GRAPH [STREET, DISTANCE]
			lwn: LABELED_WEIGHTED_NODE [STREET, DISTANCE]
			lwe: LABELED_WEIGHTED_EDGE [STREET, DISTANCE]
			vlwg: VALUED_LABELED_WEIGHTED_GRAPH [CITY, STREET, DISTANCE]
			vlwn: VALUED_LABELED_WEIGHTED_NODE [CITY, STREET, DISTANCE]
			vlwe: VALUED_LABELED_WEIGHTED_EDGE [CITY, STREET, DISTANCE]

			t: JJ_TREE
			vt: VALUED_TREE [CITY]
			lt: LABELED_TREE [STREET]
			wt: WEIGHTED_TREE [DISTANCE]
			vlt: VALUED_LABELED_TREE [CITY, STREET]
			vwt: VALUED_WEIGHTED_TREE [CITY, DISTANCE]
			lwt: LABELED_WEIGHTED_TREE [STREET, DISTANCE]
			vlwt: VALUED_LABELED_WEIGHTED_TREE [CITY, STREET, DISTANCE]

		do
		end

end
