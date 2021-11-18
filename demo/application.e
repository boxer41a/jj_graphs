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

			create tester
			run_tests

			io.put_string ("%N%N%N")
			io.put_string ("End graph testing %N")
			io.put_string ("%N%N%N")
		end

feature -- Access

	tester: VALUED_GRAPH_TESTS

feature -- Basic operations

	run_tests
			-- Call features from `tester' as demo
		do
			tester.verify_graph_2
			tester.verify_graph_3
			tester.verify_graph_4
--			tester.shortest_first
--			tester.breadth_first
--			tester.depth_first
--			tester.post_order
--			tester.in_order
		end


feature {NONE} -- Implementation


	declare_entities
			-- Declare an entity simply to force a compile for testing
		local
--			g: GRAPH
--			n: NODE
--			e: EDGE
--			vg: VALUED_GRAPH [CITY]
--			vn: VALUED_NODE [CITY]
--			ve: VALUED_EDGE [CITY]
--			lg: LABELED_GRAPH [STREET]
--			ln: LABELED_NODE [STREET]
--			le: LABELED_EDGE [STREET]
--			wg: WEIGHTED_GRAPH [DISTANCE]
--			wn: WEIGHTED_NODE [DISTANCE]
--			we: WEIGHTED_EDGE [DISTANCE]
--			vlg: VALUED_LABELED_GRAPH [CITY, STREET]
--			vln: VALUED_LABELED_NODE [CITY, STREET]
--			vle: VALUED_LABELED_EDGE [CITY, STREET]
--			vwg: VALUED_WEIGHTED_GRAPH [CITY, DISTANCE]
--			vwn: VALUED_WEIGHTED_NODE [CITY, DISTANCE]
--			vwe: VALUED_WEIGHTED_EDGE [CITY, DISTANCE]
--			lwg: LABELED_WEIGHTED_GRAPH [STREET, DISTANCE]
--			lwn: LABELED_WEIGHTED_NODE [STREET, DISTANCE]
--			lwe: LABELED_WEIGHTED_EDGE [STREET, DISTANCE]
--			vlwg: VALUED_LABELED_WEIGHTED_GRAPH [CITY, STREET, DISTANCE]
--			vlwn: VALUED_LABELED_WEIGHTED_NODE [CITY, STREET, DISTANCE]
--			vlwe: VALUED_LABELED_WEIGHTED_EDGE [CITY, STREET, DISTANCE]

--			t: JJ_TREE
--			vt: VALUED_TREE [CITY]
--			lt: LABELED_TREE [STREET]
--			wt: WEIGHTED_TREE [DISTANCE]
--			vlt: VALUED_LABELED_TREE [CITY, STREET]
--			vwt: VALUED_WEIGHTED_TREE [CITY, DISTANCE]
--			lwt: LABELED_WEIGHTED_TREE [STREET, DISTANCE]
--			vlwt: VALUED_LABELED_WEIGHTED_TREE [CITY, STREET, DISTANCE]

		do
		end

end
