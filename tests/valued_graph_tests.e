note
	description: "[
		Tests and demo of VALUED_GRAPH.
	]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_GRAPH_TESTS

inherit

	GRAPH_TESTS
		redefine
			make_graphs,
			make_nodes,
			build_graph_2,
			verify_graph_2,
			breadth_first,
			depth_first,
			post_order,
			as_node_name,
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor,
			path_anchor
		end

feature {NONE} -- Initialization

	make_graphs
			-- Redefined to change to object_comparison, because
			-- the graphs will hold {STRING} objects
		do
			Precursor
			graph_1.compare_objects
			graph_2.compare_objects
			graph_3.compare_objects
			graph_4.compare_objects
		end

	make_nodes
			-- Create the nodes
		do
			create node_a.make_with_value ("A")
			create node_b.make_with_value ("B")
			create node_c.make_with_value ("C")
			create node_d.make_with_value ("D")
			create node_e.make_with_value ("E")
			create node_f.make_with_value ("F")
			create node_g.make_with_value ("G")
			create node_h.make_with_value ("H")
			create node_i.make_with_value ("I")
			create node_j.make_with_value ("J")
			create node_k.make_with_value ("K")
			create node_l.make_with_value ("L")
			create node_m.make_with_value ("M")
			create node_n.make_with_value ("N")
			create node_o.make_with_value ("O")
			create node_p.make_with_value ("P")
			create node_q.make_with_value ("Q")
			create node_r.make_with_value ("R")
			create node_s.make_with_value ("S")
			create node_t.make_with_value ("T")
			create node_u.make_with_value ("U")
			create node_v.make_with_value ("V")
			create node_w.make_with_value ("W")
			create node_x.make_with_value ("X")
			create node_y.make_with_value ("Y")
			create node_z.make_with_value ("Z")
				-- Add nodes to container for bookkeeping
			nodes.extend (node_a, node_a.value)
			nodes.extend (node_b, node_b.value)
			nodes.extend (node_c, node_c.value)
			nodes.extend (node_d, node_d.value)
			nodes.extend (node_e, "node E")
			nodes.extend (node_f, "node F")
			nodes.extend (node_g, "node G")
			nodes.extend (node_h, "node H")
			nodes.extend (node_i, "node I")
			nodes.extend (node_j, "node J")
			nodes.extend (node_k, "node K")
			nodes.extend (node_l, "node L")
			nodes.extend (node_m, "node M")
			nodes.extend (node_n, "node N")
			nodes.extend (node_o, "node O")
			nodes.extend (node_p, "node P")
			nodes.extend (node_q, "node Q")
			nodes.extend (node_r, "node R")
			nodes.extend (node_s, "node S")
			nodes.extend (node_t, "node T")
			nodes.extend (node_u, "node U")
			nodes.extend (node_v, "node V")
			nodes.extend (node_w, "node W")
			nodes.extend (node_x, "node X")
			nodes.extend (node_y, "node Y")
			nodes.extend (node_z, "node Z")
			check
				nodes.definite_item ("A") = node_a
			end
		end

	build_graph_2
			-- Create a graph containing nodes A to D
			-- Redefined to show features from {VALUED_GRAPH}.
		do
			divider ("build_graph_2")
			procedure (agent graph_2.connect ("A", "B"), "connect")
			edges.extend (graph_2.last_new_edge, "ab")
			procedure (agent graph_2.connect ("A", "C"), "connect")
			edges.extend (graph_2.last_new_edge, "ac")
			procedure (agent graph_2.connect ("B", "B"), "connect")
			edges.extend (graph_2.last_new_edge, "bb")
			procedure (agent graph_2.connect ("B", "C"), "connect")
			edges.extend (graph_2.last_new_edge, "bc")
			procedure (agent graph_2.connect ("C", "D"), "connect")
			edges.extend (graph_2.last_new_edge, "cd")
				-- Replace values in `nodes' with the correct nodes
				-- (i.e. the ones created here, not the ones from `make_nodes'
			check attached graph_2.find_valued_node ("A") as n then
				nodes.force (n, "A")
				node_a := n
			end
			check attached graph_2.find_valued_node ("B") as n then
				nodes.force (n, "B")
				node_b := n
			end
			check attached graph_2.find_valued_node ("C") as n then
				nodes.force (n, "C")
				node_c := n
			end
			check attached graph_2.find_valued_node ("D") as n then
				nodes.force (n, "D")
				node_d := n
			end
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

feature {NONE} -- Imlementation

	as_node_name (a_node: like node_anchor): STRING_8
			-- A human readable idetifacation of `a_node'
		do
			Result := a_node.value
		end

feature {NONE} -- Implementation

	graph_anchor: VALUED_GRAPH [STRING_8]
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

	node_anchor: VALUED_NODE [STRING_8]
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

	edge_anchor: VALUED_EDGE [STRING_8]
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

	iterator_anchor: VALUED_GRAPH_ITERATOR [STRING_8]
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

	path_anchor: VALUED_PATH [STRING_8]
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


