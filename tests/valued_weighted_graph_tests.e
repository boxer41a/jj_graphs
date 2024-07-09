note
	description: "[
		Test and demo of {VALUED_WEIGHTED_GRAPH}
		]"
	author:    "Jimmy J. Johnson"
	date:      "11/11/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_WEIGHTED_GRAPH_TESTS

inherit

	VALUED_GRAPH_TESTS
		redefine
			build_graph_2,
			build_graph_3,
			build_graph_4,
			build_edge_pq,
			verify_graph_2,
			breadth_first,
			depth_first,
			post_order,
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor,
			path_anchor
		end

feature {NONE} -- Intialization

	build_graph_2
			-- Create a graph containing nodes A to D
		do
			divider ("build_graph_2")
			procedure (agent graph_2.connect_nodes_weighted (node_a, node_b, 46), "connect_nodes_weighted")
			edges.extend (graph_2.last_new_edge, "ab")
			procedure (agent graph_2.connect_nodes_weighted (node_a, node_c, 67), "connect_nodes_weighted")
			edges.extend (graph_2.last_new_edge, "ac")
			procedure (agent graph_2.connect_nodes_weighted (node_b, node_b, 32), "connect_nodes_weighted")
			edges.extend (graph_2.last_new_edge, "bb")
			procedure (agent graph_2.connect_nodes_weighted (node_b, node_c, 38), "connect_nodes_weighted")
			edges.extend (graph_2.last_new_edge, "bc")
			procedure (agent graph_2.connect_nodes_weighted (node_c, node_d, 51), "connect_nodes_weighted")
			edges.extend (graph_2.last_new_edge, "cd")
			check
				correct_cost: edges.definite_item ("ab").cost = 46
			end
		end

	build_graph_3
			-- Create a graph containing nodes D to W.
			-- Notice node D is also in `graph_2' and the edge between
			-- nodes V and W `is_directed'.
		do
			divider ("build_graph_3")
			check
				same_node_d: graph_2.has_node (node_d)
					-- because it was added in `build_graph_2'
			end
				-- Edges from D
			procedure (agent graph_3.connect_nodes_weighted (node_d, node_e, 50), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "de")
			procedure (agent graph_3.connect_nodes_weighted (node_d, node_f, 61), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "df")
			procedure (agent graph_3.connect_nodes_weighted (node_d, node_g, 33), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "dg")
				-- Edges from E
			-- none
				-- Edges from F
			procedure (agent graph_3.connect_nodes_weighted (node_f, node_e, 34), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "fe")
			procedure (agent graph_3.connect_nodes_weighted (node_f, node_g, 51), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "fg")
			procedure (agent graph_3.connect_nodes_weighted (node_f, node_h, 55), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "fh")
			procedure (agent graph_3.connect_nodes_weighted (node_f, node_i, 22), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "fi")
				-- Edges from G
			-- none
				-- Edges from H
			procedure (agent graph_3.connect_nodes_weighted (node_h, node_i, 50), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "hi")
				-- Edges from I
			procedure (agent graph_3.connect_nodes_weighted (node_i, node_j, 30), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "ij")
				-- Edges from J
			procedure (agent graph_3.connect_nodes_weighted (node_j, node_k, 46), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "jk")
			procedure (agent graph_3.connect_nodes_weighted (node_j, node_l, 77), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "jl")
			procedure (agent graph_3.connect_nodes_weighted (node_j, node_m, 96), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "jm")
			procedure (agent graph_3.connect_nodes_weighted (node_j, node_n, 98), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "jn")
			procedure (agent graph_3.connect_nodes_weighted (node_j, node_o, 80), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "jo")
			procedure (agent graph_3.connect_nodes_weighted (node_j, node_p, 41), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "jp")
				-- Edges from K
			procedure (agent graph_3.connect_nodes_weighted (node_k, node_o, 105), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "ko")
			procedure (agent graph_3.connect_nodes_weighted (node_k, node_p, 83), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "kp")
				-- Edges from L
			procedure (agent graph_3.connect_nodes_weighted (node_l, node_k, 41), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "lk")
			procedure (agent graph_3.connect_nodes_weighted (node_l, node_m, 48), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "lm")
			procedure (agent graph_3.connect_nodes_weighted (node_l, node_n, 85), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "ln")
			procedure (agent graph_3.connect_nodes_weighted (node_l, node_o, 106), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "lo")
			procedure (agent graph_3.connect_nodes_weighted (node_l, node_p, 100), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "lp")
				-- Edges from M
			procedure (agent graph_3.connect_nodes_weighted (node_m, node_k, 82), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "mk")
			procedure (agent graph_3.connect_nodes_weighted (node_m, node_n, 46), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "mn")
			procedure (agent graph_3.connect_nodes_weighted (node_m, node_o, 80), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "mo")
				-- Edges from N
			procedure (agent graph_3.connect_nodes_weighted (node_n, node_k, 106), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "nk")
			procedure (agent graph_3.connect_nodes_weighted (node_n, node_o, 45), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "no")
				-- Edges from O
			-- none
				-- Edges from P
			procedure (agent graph_3.connect_nodes_weighted (node_p, node_m, 99), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "pm")
			procedure (agent graph_3.connect_nodes_weighted (node_p, node_n, 83), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "pn")
			procedure (agent graph_3.connect_nodes_weighted (node_p, node_o, 50), "connect_nodes_weighted")
			edges.extend (graph_3.last_new_edge, "po")
		end

	build_graph_4
			-- Create a graph containing nodes X, Y, and Z
		do
			divider ("build_graph_4")
				-- Edges from Q
			procedure (agent graph_4.connect_nodes_weighted (node_q, node_r, 48), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "qr")
			procedure (agent graph_4.connect_nodes_weighted (node_q, node_s, 50), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "qs")
			procedure (agent graph_4.connect_nodes_weighted (node_q, node_t, 72), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "qt")
				-- Edges from R
			procedure (agent graph_4.connect_nodes_weighted (node_r, node_u, 50), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "ru")
			procedure (agent graph_4.connect_nodes_weighted (node_r, node_v, 57), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "rv")
				-- Edges from S
			-- none
				-- Edges from T
			procedure (agent graph_4.connect_nodes_weighted_directed (node_t, node_w, 30), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "tw")
			procedure (agent graph_4.connect_nodes_weighted_directed (node_t, node_x, 32), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "tx")
			procedure (agent graph_4.connect_nodes_weighted_directed (node_t, node_y, 38), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "ty")
			procedure (agent graph_4.connect_nodes_weighted_directed (node_t, node_z, 45), "connect_nodes_weighted")
			edges.extend (graph_4.last_new_edge, "tz")
				-- Edges from U, V, W, X, Y, & Z
			-- none
		end

	build_edge_pq
			-- Create the edge between node P and node Q.
			-- This edge is NOT in (i.e. visible to) any graph.
		local
			e: like edge_anchor
		do
			divider ("build_edge_pq")
			create e
			edges.extend (e, "pq")
			procedure (agent e.connect (node_p, node_q), "connect")
			procedure (agent e.set_cost (70), "set_cost")
		end


feature -- Test routines

	verify_graph_2
			-- Check structure of `graph_2'
		do
			Precursor
		end

	breadth_first
			-- Test and demo breadth-first traversals
		do
			Precursor
		end

	depth_first
			-- Test and demo depth-first traversals
		do
			Precursor
		end

	post_order
			-- Test and demo post-order traversals
		do
			Precursor
		end

feature {NONE} -- Implementation

	graph_anchor: VALUED_WEIGHTED_GRAPH [STRING_8, INTEGER]
			-- Anchor for features using a graph.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: VALUED_WEIGHTED_NODE [STRING_8, INTEGER]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: VALUED_WEIGHTED_EDGE [STRING_8, INTEGER]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	iterator_anchor: VALUED_WEIGHTED_GRAPH_ITERATOR [STRING_8, INTEGER]
			-- Anchor for features using graph iterators.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	path_anchor: VALUED_WEIGHTED_PATH [STRING_8, INTEGER]
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end
end
