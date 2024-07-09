note
	description: "[
		Root class for demonstrating/testing the graph cluster.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize and launch application
		do
			io.put_string ("%N%N%N%N%N%N%N%N%N%N%N%N%N")
			io.put_string ("--- Begin graph testing -----------------------------------%N")

--			create graph_tester
			create valued_graph_tester
			create valued_weighted_graph_tester
			run_tests

			io.put_string ("%N%N%N")
			io.put_string ("End graph testing %N")
			io.put_string ("%N%N%N")
		end

feature -- Access

--	graph_tester: GRAPH_TESTS
	valued_graph_tester: VALUED_GRAPH_TESTS
	valued_weighted_graph_tester: VALUED_WEIGHTED_GRAPH_TESTS

feature -- Basic operations

	run_tests
			-- Call features from `tester' as demo
		do
--			test_graph
			test_valued_graph
			test_valued_weighted_graph
		end

--	test_graph
--			-- Demo/test features from {GRAPH} class
--		do
--			graph_tester.verify_graph_2
--			graph_tester.verify_graph_3
--			graph_tester.verify_graph_4
--			graph_tester.breadth_first
--			graph_tester.depth_first
--			graph_tester.post_order
--			graph_tester.in_order
--			graph_tester.shortest_first
--		end

	test_valued_graph
			-- Demo/test feature from {VALUED_GRAPH}
		do
			valued_graph_tester.verify_graph_2
			valued_graph_tester.verify_graph_3
			valued_graph_tester.verify_graph_4
			valued_graph_tester.breadth_first
			valued_graph_tester.depth_first
			valued_graph_tester.post_order
			valued_graph_tester.in_order
			valued_graph_tester.shortest_first
		end

	test_valued_weighted_graph
			-- Demo/test feature from {VALUED_WEIGHTED_GRAPH}
		do
			valued_weighted_graph_tester.verify_graph_2
			valued_weighted_graph_tester.verify_graph_3
			valued_weighted_graph_tester.verify_graph_4
			valued_weighted_graph_tester.breadth_first
			valued_weighted_graph_tester.depth_first
			valued_weighted_graph_tester.post_order
			valued_weighted_graph_tester.in_order
			valued_weighted_graph_tester.shortest_first
		end

feature {NONE} -- Implementation


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

			b_tree: B_TREE [STRING]
		do
		end

end
