note
	description: "[
		Root class describing tests to be run on {GRAPH} and its
		descendents.
	]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	GRAPH_TESTS

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Initialization

	on_prepare
			-- Build the nodes, edges, and graphs, demonstrating how
			-- the classes can be used to fill a graph.
			-- This tests uses [unlabled] {NODE} and {EDGE}
		do
				-- Create the containers for bookkeeping
			create graphs.make (100)
			create nodes.make (100)
			create edges.make (100)
			create expected_results.make (100)
			make_graphs
			make_nodes
			build_graph_2
			build_graph_3
			build_graph_4
			build_edge_pq
			build_expected_results
		end

	make_graphs
			-- Create the graphs
		do
			create graph_1
			create graph_2
			create graph_3
			create graph_4
				-- Add graphs to container for bookkeeping
			graphs.extend (graph_1, "Graph 1")
			graphs.extend (graph_2, "Graph 2")
			graphs.extend (graph_3, "Graph 3")
			graphs.extend (graph_4, "Graph 4")
		end

	make_nodes
			-- Create the nodes
		do
			create node_a
			create node_b
			create node_c
			create node_d
			create node_e
			create node_f
			create node_g
			create node_h
			create node_i
			create node_j
			create node_k
			create node_l
			create node_m
			create node_n
			create node_o
			create node_p
			create node_q
			create node_r
			create node_s
			create node_t
			create node_u
			create node_v
			create node_w
			create node_x
			create node_y
			create node_z
				-- Add nodes to container for bookkeeping
			nodes.extend (node_a, "A")
			nodes.extend (node_b, "B")
			nodes.extend (node_c, "C")
			nodes.extend (node_d, "D")
			nodes.extend (node_e, "E")
			nodes.extend (node_f, "F")
			nodes.extend (node_g, "G")
			nodes.extend (node_h, "H")
			nodes.extend (node_i, "I")
			nodes.extend (node_j, "J")
			nodes.extend (node_k, "K")
			nodes.extend (node_l, "L")
			nodes.extend (node_m, "M")
			nodes.extend (node_n, "N")
			nodes.extend (node_o, "O")
			nodes.extend (node_p, "P")
			nodes.extend (node_q, "Q")
			nodes.extend (node_r, "R")
			nodes.extend (node_s, "S")
			nodes.extend (node_t, "T")
			nodes.extend (node_u, "U")
			nodes.extend (node_v, "V")
			nodes.extend (node_w, "W")
			nodes.extend (node_x, "X")
			nodes.extend (node_y, "Y")
			nodes.extend (node_z, "Z")
			check
				nodes.definite_item ("A") = node_a
			end
		end

	build_graph_2
			-- Create a graph containing nodes A to D
		do
			divider ("build_graph_2")
			procedure (agent graph_2.connect_nodes (node_a, node_b), "connect_nodes")
			edges.extend (graph_2.last_new_edge, "ab")
			procedure (agent graph_2.connect_nodes (node_a, node_c), "connect_nodes")
			edges.extend (graph_2.last_new_edge, "ac")
			procedure (agent graph_2.connect_nodes (node_b, node_b), "connect_nodes")
			edges.extend (graph_2.last_new_edge, "bb")
			procedure (agent graph_2.connect_nodes (node_b, node_c), "connect_nodes")
			edges.extend (graph_2.last_new_edge, "bc")
			procedure (agent graph_2.connect_nodes (node_c, node_d), "connect_nodes")
			edges.extend (graph_2.last_new_edge, "cd")
			check
				correct_edge_count: graph_2.edge_count = 5
			end
			check
				correct_node_count: node_d.count = 1
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
			check
				correct_edge_count: node_d.count = 1
			end
				-- Edges from D
			procedure (agent graph_3.connect_nodes (node_d, node_e), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "de")
			procedure (agent graph_3.connect_nodes (node_d, node_f), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "df")
			procedure (agent graph_3.connect_nodes (node_d, node_g), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "dg")
			check
				correct_edge_count_new: node_d.count = 4
			end
				-- Edges from E
			-- none
				-- Edges from F
			procedure (agent graph_3.connect_nodes (node_f, node_e), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "fe")
			procedure (agent graph_3.connect_nodes (node_f, node_g), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "fg")
			procedure (agent graph_3.connect_nodes (node_f, node_h), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "fh")
			procedure (agent graph_3.connect_nodes (node_f, node_i), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "fi")
				-- Edges from G
			-- none
				-- Edges from H
			procedure (agent graph_3.connect_nodes (node_h, node_i), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "hi")
				-- Edges from I
			procedure (agent graph_3.connect_nodes (node_i, node_j), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "ij")
				-- Edges from J
			procedure (agent graph_3.connect_nodes (node_j, node_k), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "jk")
			procedure (agent graph_3.connect_nodes (node_j, node_l), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "jl")
			procedure (agent graph_3.connect_nodes (node_j, node_m), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "jm")
			procedure (agent graph_3.connect_nodes (node_j, node_n), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "jn")
			procedure (agent graph_3.connect_nodes (node_j, node_o), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "jo")
			procedure (agent graph_3.connect_nodes (node_j, node_p), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "jp")
				-- Edges from K
			procedure (agent graph_3.connect_nodes (node_k, node_o), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "ko")
			procedure (agent graph_3.connect_nodes (node_k, node_p), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "kp")
				-- Edges from L
			procedure (agent graph_3.connect_nodes (node_l, node_k), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "lk")
			procedure (agent graph_3.connect_nodes (node_l, node_m), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "lm")
			procedure (agent graph_3.connect_nodes (node_l, node_n), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "ln")
			procedure (agent graph_3.connect_nodes (node_l, node_o), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "lo")
			procedure (agent graph_3.connect_nodes (node_l, node_p), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "lp")
				-- Edges from M
			procedure (agent graph_3.connect_nodes (node_m, node_k), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "mk")
			procedure (agent graph_3.connect_nodes (node_m, node_n), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "mn")
			procedure (agent graph_3.connect_nodes (node_m, node_o), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "mo")
				-- Edges from N
			procedure (agent graph_3.connect_nodes (node_n, node_k), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "nk")
			procedure (agent graph_3.connect_nodes (node_n, node_o), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "no")
				-- Edges from O
			-- none
				-- Edges from P
			procedure (agent graph_3.connect_nodes (node_p, node_m), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "pm")
			procedure (agent graph_3.connect_nodes (node_p, node_n), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "pn")
			procedure (agent graph_3.connect_nodes (node_p, node_o), "connect_nodes")
			edges.extend (graph_3.last_new_edge, "po")
		end

	build_graph_4
			-- Create a graph containing nodes X, Y, and Z
		do
			divider ("build_graph_4")
				-- Edges from Q
			procedure (agent graph_4.connect_nodes (node_q, node_r), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "qr")
			procedure (agent graph_4.connect_nodes (node_q, node_s), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "qs")
			procedure (agent graph_4.connect_nodes (node_q, node_t), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "qt")
				-- Edges from R
			procedure (agent graph_4.connect_nodes (node_r, node_u), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "ru")
			procedure (agent graph_4.connect_nodes (node_r, node_v), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "rv")
				-- Edges from S
			-- none
				-- Edges from T
			procedure (agent graph_4.connect_nodes_directed (node_t, node_w), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "tw")
			procedure (agent graph_4.connect_nodes_directed (node_t, node_x), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "tx")
			procedure (agent graph_4.connect_nodes_directed (node_t, node_y), "connect_nodes")
			edges.extend (graph_4.last_new_edge, "ty")
			procedure (agent graph_4.connect_nodes_directed (node_t, node_z), "connect_nodes")
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
		end

	build_expected_results
			-- Fill `expected_results' table with lists of paths that
			-- are expected from the various traversal routines
		do

		end

feature -- Basic operations

	verify_graph_2
			-- Ensure the graphs have the expected structures
		do
			divider ("verify_graph_2")
			function (agent graph_2.node_count, "node_count", 4)
			function (agent graph_2.edge_count, "edge_count", 5)
			predicate (agent graph_2.is_undirected, "is_undirected", true)
			predicate (agent graph_2.is_empty, "is_empty", false)
--			predicate (agent graph_2.is_ordered, "is_ordered", false)
			predicate (agent graph_2.has_node (node_a), "has_node", true)
			predicate (agent graph_2.has_node (node_b), "has_node", true)
			predicate (agent graph_2.has_node (node_c), "has_node", true)
			predicate (agent graph_2.has_node (node_d), "has_node", true)
			predicate (agent graph_2.has_edge (e_name ("ab")), "has_edge", true)
			predicate (agent graph_2.has_edge (e_name ("ac")), "has_edge", true)
			predicate (agent graph_2.has_edge (e_name ("bb")), "has_edge", true)
			predicate (agent graph_2.has_edge (e_name ("bc")), "has_edge", true)
			predicate (agent graph_2.has_edge (e_name ("cd")), "has_edge", true)
				-- node A
			function (agent node_a.count, "count", 2)
			predicate (agent node_a.has_edge_to (node_b), "has_edge_to", true)
			predicate (agent node_a.has_edge_to (node_c), "has_edge_to", true)
				-- node B
			function (agent node_b.count, "count", 3)
			predicate (agent node_b.has_edge_from (node_a), "has_edge_from", true)
			predicate (agent node_b.has_edge_from (node_b), "has_edge_from", true)
			predicate (agent node_b.has_edge_to (node_b), "has_edge_to", true)
			predicate (agent node_b.has_edge_to (node_c), "has_edge_to", true)
				-- node C
			function (agent node_c.count, "count", 3)
			predicate (agent node_c.has_edge_from (node_a), "has_edge_from", true)
			predicate (agent node_c.has_edge_from (node_b), "has_edge_from", true)
			predicate (agent node_c.has_edge_to (node_d), "has_edge_to", true)
				-- node D
			predicate (agent node_d.is_in_graph (graph_2), "is_in_graph", true)
			function (agent node_d.count, "count", 4)
			predicate (agent node_d.has_edge_from (node_c), "has_edge_from", true)
			predicate (agent node_d.has_edge_to (node_e), "has_edge_to", true)
			predicate (agent node_d.has_edge_to (node_f), "has_edge_to", true)
			predicate (agent node_d.has_edge_to (node_g), "has_edge_to", true)
		end

	verify_graph_3
			-- Ensure `graph_3' has the expected structure
		do
			divider ("verify_graph_3")
			function (agent graph_3.node_count, "node_count", 13)
			function (agent graph_3.edge_count, "edge_count", 30)
			predicate (agent graph_3.is_undirected, "is_undirected", true)
			predicate (agent graph_3.is_empty, "is_empty", false)
			predicate (agent graph_3.has_node (node_d), "has_node", true)
			predicate (agent graph_3.has_node (node_e), "has_node", true)
			predicate (agent graph_3.has_node (node_f), "has_node", true)
			predicate (agent graph_3.has_node (node_g), "has_node", true)
			predicate (agent graph_3.has_node (node_h), "has_node", true)
			predicate (agent graph_3.has_node (node_i), "has_node", true)
			predicate (agent graph_3.has_node (node_j), "has_node", true)
			predicate (agent graph_3.has_node (node_k), "has_node", true)
			predicate (agent graph_3.has_node (node_l), "has_node", true)
			predicate (agent graph_3.has_node (node_m), "has_node", true)
			predicate (agent graph_3.has_node (node_n), "has_node", true)
			predicate (agent graph_3.has_node (node_o), "has_node", true)
			predicate (agent graph_3.has_node (node_p), "has_node", true)
			predicate (agent graph_3.has_edge (e_name ("de")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("df")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("dg")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("fe")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("fg")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("fh")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("fi")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("hi")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("ij")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("jk")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("jl")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("jm")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("jn")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("jo")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("jp")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("ko")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("kp")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("lk")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("lm")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("ln")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("lo")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("lp")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("mk")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("mn")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("mo")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("nk")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("no")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("pm")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("pn")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("po")), "has_edge", true)
			predicate (agent graph_3.has_edge (e_name ("pq")), "has_edge", false)
				-- node D
			predicate (agent node_d.is_in_graph (graph_3), "is_in_graph", true)
			function (agent node_d.count, "count", 4)
			predicate (agent node_d.has_edge_from (node_c), "has_edge_from", true)
			predicate (agent node_d.has_edge_to (node_e), "has_edge_to", true)
			predicate (agent node_d.has_edge_to (node_f), "has_edge_to", true)
			predicate (agent node_d.has_edge_to (node_g), "has_edge_to", true)
			predicate (agent graph_3.has_edge (e_name ("cd")), "has_edge", false)
				-- node E
			function (agent node_e.count, "count", 2)
			predicate (agent node_e.has_edge_from (node_d), "has_edge_from", true)
			predicate (agent node_e.has_edge_from (node_f), "has_edge_from", true)
				-- node F
			function (agent node_f.count, "count", 5)
			predicate (agent node_f.has_edge_from (node_d), "has_edge_from", true)
			predicate (agent node_f.has_edge_to (node_e), "has_edge_to", true)
			predicate (agent node_f.has_edge_to (node_g), "has_edge_to", true)
			predicate (agent node_f.has_edge_to (node_h), "has_edge_to", true)
			predicate (agent node_f.has_edge_to (node_i), "has_edge_to", true)
				-- node G
			function (agent node_g.count, "count", 2)
			predicate (agent node_g.has_edge_from (node_d), "has_edge_from", true)
			predicate (agent node_g.has_edge_from (node_f), "has_edge_from", true)
				-- node H
			function (agent node_h.count, "count", 2)
			predicate (agent node_h.has_edge_from (node_f), "has_edge_from", true)
			predicate (agent node_h.has_edge_to (node_i), "has_edge_to", true)
				-- node I
			function (agent node_i.count, "count", 3)
			predicate (agent node_i.has_edge_from (node_f), "has_edge_from", true)
			predicate (agent node_i.has_edge_from (node_h), "has_edge_from", true)
			predicate (agent node_i.has_edge_to (node_j), "has_edge_to", true)
				-- node J
			function (agent node_j.count, "count", 7)
			predicate (agent node_j.has_edge_from (node_i), "has_edge_from", true)
			predicate (agent node_j.has_edge_to (node_k), "has_edge_to", true)
			predicate (agent node_j.has_edge_to (node_l), "has_edge_to", true)
			predicate (agent node_j.has_edge_to (node_m), "has_edge_to", true)
			predicate (agent node_j.has_edge_to (node_n), "has_edge_to", true)
			predicate (agent node_j.has_edge_to (node_o), "has_edge_to", true)
			predicate (agent node_j.has_edge_to (node_p), "has_edge_to", true)
				-- node K
			function (agent node_k.count, "count", 6)
			predicate (agent node_k.has_edge_from (node_j), "has_edge_from", true)
			predicate (agent node_k.has_edge_from (node_l), "has_edge_from", true)
			predicate (agent node_k.has_edge_from (node_m), "has_edge_from,", true)
			predicate (agent node_k.has_edge_from (node_n), "has_edge_from", true)
			predicate (agent node_k.has_edge_to (node_o), "has_edge_to", true)
			predicate (agent node_k.has_edge_to (node_p), "has_edge_to", true)
				-- node L
			function (agent node_l.count, "count", 6)
			predicate (agent node_l.has_edge_from (node_j), "has_edge_from", true)
			predicate (agent node_l.has_edge_to (node_k), "has_edge_to", true)
			predicate (agent node_l.has_edge_to (node_m), "has_edge_to,", true)
			predicate (agent node_l.has_edge_to (node_n), "has_edge_to", true)
			predicate (agent node_l.has_edge_to (node_o), "has_edge_to", true)
			predicate (agent node_l.has_edge_to (node_p), "has_edge_to", true)
				-- node M
			function (agent node_m.count, "count", 6)
			predicate (agent node_m.has_edge_from (node_j), "has_edge_from", true)
			predicate (agent node_m.has_edge_to (node_k), "has_edge_to", true)
			predicate (agent node_m.has_edge_from (node_l), "has_edge_from,", true)
			predicate (agent node_m.has_edge_to (node_n), "has_edge_to", true)
			predicate (agent node_m.has_edge_to (node_o), "has_edge_to", true)
			predicate (agent node_m.has_edge_from (node_p), "has_edge_from", true)
				-- node N
			function (agent node_n.count, "count", 6)
			predicate (agent node_n.has_edge_from (node_j), "has_edge_from", true)
			predicate (agent node_n.has_edge_to (node_k), "has_edge_to", true)
			predicate (agent node_n.has_edge_from (node_l), "has_edge_from,", true)
			predicate (agent node_n.has_edge_from (node_m), "has_edge_from", true)
			predicate (agent node_n.has_edge_to (node_o), "has_edge_to", true)
			predicate (agent node_n.has_edge_from (node_p), "has_edge_from", true)
				-- node O
			function (agent node_o.count, "count", 6)
			predicate (agent node_o.has_edge_from (node_j), "has_edge_from", true)
			predicate (agent node_o.has_edge_from (node_k), "has_edge_from", true)
			predicate (agent node_o.has_edge_from (node_l), "has_edge_from", true)
			predicate (agent node_o.has_edge_from (node_m), "has_edge_from,", true)
			predicate (agent node_o.has_edge_from (node_n), "has_edge_from", true)
			predicate (agent node_o.has_edge_from (node_p), "has_edge_from", true)
				-- node P
			function (agent node_p.count, "count", 7)
			predicate (agent node_p.has_edge_from (node_j), "has_edge_from", true)
			predicate (agent node_p.has_edge_from (node_k), "has_edge_from", true)
			predicate (agent node_p.has_edge_from (node_l), "has_edge_from,", true)
			predicate (agent node_p.has_edge_to (node_m), "has_edge_from", true)
			predicate (agent node_p.has_edge_to (node_n), "has_edge_to", true)
			predicate (agent node_p.has_edge_to (node_o), "has_edge_from", true)
			predicate (agent node_p.has_edge_to (node_q), "has_edge_from", true)
		end

	verify_graph_4
			-- Ensure `graph_4' has the expected structure
		do
			divider ("verify_graph_4")
			function (agent graph_4.node_count, "node_count", 10)
			function (agent graph_4.edge_count, "edge_count", 9)
			predicate (agent graph_4.is_undirected, "is_undirected", false)
			predicate (agent graph_4.is_empty, "is_empty", false)
			predicate (agent graph_4.has_node (node_q), "has_node", true)
			predicate (agent graph_4.has_node (node_r), "has_node", true)
			predicate (agent graph_4.has_node (node_s), "has_node", true)
			predicate (agent graph_4.has_node (node_t), "has_node", true)
			predicate (agent graph_4.has_node (node_u), "has_node", true)
			predicate (agent graph_4.has_node (node_v), "has_node", true)
			predicate (agent graph_4.has_node (node_w), "has_node", true)
			predicate (agent graph_4.has_node (node_x), "has_node", true)
			predicate (agent graph_4.has_node (node_y), "has_node", true)
			predicate (agent graph_4.has_node (node_z), "has_node", true)
				-- Edges
			predicate (agent graph_4.has_edge (e_name ("qr")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("qs")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("qt")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("ru")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("rv")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("tw")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("tx")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("ty")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("tz")), "has_edge", true)
			predicate (agent graph_4.has_edge (e_name ("pq")), "has_edge", false)
				-- node Q
			function (agent node_q.count, "count", 4)
			predicate (agent node_q.has_edge_from (node_p), "has_edge_from", true)
			predicate (agent node_q.has_edge_to (node_r), "has_edge_to", true)
			predicate (agent node_q.has_edge_to (node_s), "has_edge_to", true)
			predicate (agent node_q.has_edge_to (node_t), "has_edge_to,", true)
				-- node R
			function (agent node_r.count, "count", 3)
			predicate (agent node_r.has_edge_from (node_q), "has_edge_from,", true)
			predicate (agent node_r.has_edge_to (node_u), "has_edge_to", true)
			predicate (agent node_r.has_edge_to (node_v), "has_edge_to", true)
				-- node S
			function (agent node_s.count, "count", 1)
			predicate (agent node_s.has_edge_from (node_q), "has_edge_from,", true)
				-- node T
			function (agent node_t.count, "count", 5)
			predicate (agent node_t.has_edge_from (node_q), "has_edge_from,", true)
			predicate (agent node_t.has_edge_to (node_w), "has_edge_to", true)
			predicate (agent node_t.has_edge_to (node_x), "has_edge_to", true)
			predicate (agent node_t.has_edge_to (node_y), "has_edge_to", true)
			predicate (agent node_t.has_edge_to (node_z), "has_edge_to", true)
				-- node U
			function (agent node_u.count, "count", 1)
			predicate (agent node_u.has_edge_from (node_r), "has_edge_from,", true)
				-- node V
			function (agent node_v.count, "count", 1)
			predicate (agent node_v.has_edge_from (node_r), "has_edge_from,", true)
				-- node W
			function (agent node_w.count, "count", 1)
			predicate (agent node_w.has_edge_from (node_t), "has_edge_from,", true)
				-- node X
			function (agent node_x.count, "count", 1)
			predicate (agent node_x.has_edge_from (node_t), "has_edge_from,", true)
				-- node Y
			function (agent node_y.count, "count", 1)
			predicate (agent node_y.has_edge_from (node_t), "has_edge_from,", true)
				-- node Z
			function (agent node_Z.count, "count", 1)
			predicate (agent node_z.has_edge_from (node_t), "has_edge_from,", true)
		end

	breadth_first
			-- Explore the graph
		local
			it: like iterator_anchor
			p: like path_anchor
			i: INTEGER
		do
				-- Use default settings for iterator
			divider ("breadth_first -- default settings")
			it := graph_4.iterator
--			execute (agent it.set_root_node (node_a), "set_root_node", 0)
			execute (agent it.root_node, "root_node", node_q)
			execute (agent it.is_breadth_first, "is_breadth_first", true)
			execute (agent it.is_exploring_paths, "is_exploring_paths", false)
			execute (agent it.is_traversing_edges, "is_traversing_edges", false)
			execute (agent it.is_visiting_nodes, "is_visiting_nodes", true)
			execute (agent it.is_inspecting_children, "is_inspecting_children", true)
			execute (agent it.is_inspecting_parents, "is_inspecting_parents", true)
			execute (agent it.is_inspecting_relations, "is_inspecting_relations", true)
			execute (agent it.is_seeing_reachables, "is_seeing_reachables", false)
			from
				it.start
				i := 1
			until it.is_after
			loop
				p := it.path
				show_path (p)
				it.forth
				i := i + 1
			end
		end

	assert_path (a_path, a_expected: like path_anchor)
			-- Check if `a_path' is equivalent to `a_expected' path
		do
			show_path (a_path)
			if a_path /~ a_expected then
				io.put_string ("%T ERROR: expected ")
				show_path (a_expected)
			end
			assert ("equivalent paths ", a_path ~ a_expected)
		end

	expected_path (a_traversal: INTEGER; a_index: INTEGER): like path_anchor
			-- The path expected for `a_index'th step of `a_traversal'
			-- as pulled from `expected_results'
		require
			valid_traversal_method: a_traversal = Order_bf or a_traversal = Order_df or
									a_traversal = Order_po or a_traversal = Order_io
		do
			Result := expected_results.definite_item (a_traversal).i_th (a_index)
		end

	expected_results: HASH_TABLE [LINKED_LIST [like path_anchor], INTEGER]
			-- Holds the list of paths expected indexed by the traversal method
			-- Built in `build_expected_results'
			-- See traversal-order constants near end of class

	Order_bf: INTEGER = 1
	Order_df: INTEGER = 2
	Order_po: INTEGER = 3
	Order_io: INTEGER = 4

	depth_first
			-- Traverse the graphs in depth-first order
		local
			it: like iterator_anchor
			p: like path_anchor
		do
			divider ("depth_first")
			it := graph_4.iterator
--			execute (agent it.set_root_node (node_d), "set_root_node", 0)
			execute (agent it.set_depth_first, "set_depth_first", 0)
			execute (agent it.root_node, "root_node", node_q)
			execute (agent it.is_depth_first, "is_depth_first", true)
			execute (agent it.is_exploring_paths, "is_exploring_paths", false)
			execute (agent it.is_traversing_edges, "is_traversing_edges", false)
			execute (agent it.is_visiting_nodes, "is_visiting_nodes", true)
			execute (agent it.is_inspecting_children, "is_inspecting_children", true)
			execute (agent it.is_inspecting_parents, "is_inspecting_parents", true)
			execute (agent it.is_inspecting_relations, "is_inspecting_relations", true)
			execute (agent it.is_seeing_reachables, "is_seeing_reachables", false)
			from it.start
			until it.is_after
			loop
				p := it.path
				show_path (p)
				it.forth
			end

		end

	post_order
			-- Traverse the graphs in post-order
		local
			it: like iterator_anchor
			p: like path_anchor
		do
			divider ("post_order")
			it := graph_4.iterator
			execute (agent it.set_post_order, "set_post_order", 0)
--			execute (agent it.set_root_node (node_d), "set_root_node", 0)
			execute (agent it.root_node, "root_node", node_q)
			execute (agent it.is_post_order, "is_post_order", true)
			execute (agent it.is_exploring_paths, "is_exploring_paths", false)
			execute (agent it.is_traversing_edges, "is_traversing_edges", false)
			execute (agent it.is_visiting_nodes, "is_visiting_nodes", true)
			execute (agent it.is_inspecting_children, "is_inspecting_children", true)
			execute (agent it.is_inspecting_parents, "is_inspecting_parents", true)
			execute (agent it.is_inspecting_relations, "is_inspecting_relations", true)
			execute (agent it.is_seeing_reachables, "is_seeing_reachables", false)
			from it.start
			until it.is_after
			loop
				p := it.path
				show_path (p)
				it.forth
			end
		end

	in_order
			-- Traverse the graphs in-order
		local
			it: like iterator_anchor
			p: like path_anchor
		do
				-- Use default settings for iterator
			divider ("in_order")
			it := graph_4.iterator
			execute (agent it.set_in_order, "set_in_order", 0)
--			execute (agent it.set_root_node (node_d), "set_root_node", 0)
			execute (agent it.root_node, "root_node", node_q)
			execute (agent it.is_in_order, "is_in_order", true)
			execute (agent it.is_exploring_paths, "is_exploring_paths", false)
			execute (agent it.is_traversing_edges, "is_traversing_edges", false)
			execute (agent it.is_visiting_nodes, "is_visiting_nodes", true)
			execute (agent it.is_inspecting_children, "is_inspecting_children", true)
			execute (agent it.is_inspecting_parents, "is_inspecting_parents", true)
			execute (agent it.is_inspecting_relations, "is_inspecting_relations", true)
			execute (agent it.is_seeing_reachables, "is_seeing_reachables", false)
			from it.start
			until it.is_after
			loop
				p := it.path
				show_path (p)
				it.forth
			end
		end

	shortest_first
			-- Explore the graph
		local
			it: like iterator_anchor
			p: like path_anchor
		do
			divider ("shortest_first -- root node_a, is_seeing_reachables")
			it := graph_2.iterator
			execute (agent it.set_root_node (node_a), "set_root_node", 0)
			execute (agent it.set_shortest_first, "set_shortest_first", 0)
			execute (agent it.see_reachables, "see_reachables", 0)
			execute (agent it.root_node, "root_node", node_a)
			execute (agent it.is_shortest_first, "is_shortest_first", true)
			execute (agent it.is_exploring_paths, "is_exploring_paths", false)
			execute (agent it.is_traversing_edges, "is_traversing_edges", false)
			execute (agent it.is_visiting_nodes, "is_visiting_nodes", true)
			execute (agent it.is_inspecting_children, "is_inspecting_children", true)
			execute (agent it.is_inspecting_parents, "is_inspecting_parents", true)
			execute (agent it.is_inspecting_relations, "is_inspecting_relations", true)
			execute (agent it.is_seeing_reachables, "is_seeing_reachables", true)
			from it.start
			until it.is_after
			loop
				p := it.path
				show_path (p)
				it.forth
			end
		end


feature {NONE} -- Implementation

	show_path (a_path: like path_anchor)
			-- Output the path in readable format
		local
			i: INTEGER
			n: like node_anchor
			e: like edge_anchor
		do
			io.put_string ("%T" + as_named (a_path.first_node))
			io.put_string (" --> ")
			io.put_string (as_named (a_path.last_node))
			io.put_string ("  ")
			io.put_string (a_path.cost.out)
			io.put_string ("%T:  ")
			io.put_string (as_named (a_path.first_node))
			io.put_string (":   ")
			from i := 1
			until i > a_path.edge_count
			loop
--				n := a_path.i_th_node (i)
				e := a_path.i_th_edge (i)
				io.put_string (as_named (e.node_from))
				io.put_string (as_named (e.node_to))
				io.put_string ("-" + e.cost.out)
				if i < a_path.edge_count then
					io.put_string (", ")
				end
--				io.put_string (as_named (n) + "  ")
				i := i + 1
			end
			io.put_string ("   --> ")
			io.put_string (as_named (a_path.last_node))
--			io.put_string ("     ")
--			io.put_string (a_path.cost.out)
			io.put_string ("%N")
		end

	is_valid_target_type (a_routine: ROUTINE): BOOLEAN
			-- Is the target of `a_routine' a type that this class can test?
		do
			Result := attached a_routine.target as t and then
				(attached {GRAPH} t or else
					attached {NODE} t or else
					attached {EDGE} t or else
					attached {GRAPH_ITERATOR} t)
			if not Result then
					-- The check for attached like Current seems to handle the case where
					-- `a_routine' is referencing an attribute.  In that case, the actual
					-- target is the second argument of the `closed operands' not the first
					-- argument as I would expect.
				check attached a_routine.target as t then
					check attached a_routine.closed_operands as args and then args.count >= 2 then
						Result := (attached {GRAPH} args [2] or else
								attached {NODE} args [2] or else
								attached {EDGE} args [2] or else
								attached {GRAPH_ITERATOR} args [2])
					end
				end
			end
		end

	function (a_function: FUNCTION [TUPLE, ANY]; a_name: STRING_8; a_expected: ANY)
			-- Execute `a_function', printing the `signature' of the call
			-- and asserting that the result of the call is equivalent
			-- to `a_expected'.
		require
			target_closed: attached a_function.target
			no_open_arguments: a_function.open_count = 0
			expected_types: is_valid_target_type (a_function)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_function, a_name)
			ans := a_function.item (a_function.operands)
			is_ok := ans.out ~ a_expected.out
			s := s + " ==> " + as_named (ans)
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	predicate (a_predicate: PREDICATE; a_name: STRING_8; a_expected: BOOLEAN)
			-- Execute `a_function', printing the `signature' of the call
			-- and asserting that the result of the call is equivalent
			-- to `a_expected'.
		require
			target_closed: attached a_predicate.target
			no_open_arguments: a_predicate.open_count = 0
			expected_types: is_valid_target_type (a_predicate)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_predicate, a_name)
			ans := a_predicate.item (a_predicate.operands)
			is_ok := ans.out ~ a_expected.out
			s := s + " ==> " + as_named (ans)
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	procedure (a_procedure: PROCEDURE; a_name: STRING_8)
			-- Execute `a_procedure', printing the `signature' of the call.
		require
			target_closed: attached a_procedure.target
			no_open_arguments: a_procedure.open_count = 0
			expected_types: is_valid_target_type (a_procedure)
		local
			s: STRING_8
		do
			s := signature (a_procedure, a_name)
			a_procedure.call
			io.put_string (s + "%N")
		end

	execute (a_routine: ROUTINE;
		a_name: STRING_8; a_expected: ANY)
			-- execute `a_routine' and output the `signature' of the call.
			-- If `a_routine' is a function, assert the result of the call
			-- is equivalent to `a_expected'.
		require
			target_closed: attached a_routine.target
			no_open_arguments: a_routine.open_count = 0
			expected_types: is_valid_target_type (a_routine)
		local
			s: STRING_8
			ans: ANY
			is_ok: BOOLEAN
		do
			s := signature (a_routine, a_name)
			if attached {PROCEDURE} a_routine as p then
				p.call
				is_ok := true
			elseif attached {PREDICATE} a_routine as p then
				ans := p.item (p.operands)
				is_ok := ans.out ~ a_expected.out
				s := s + " ==> " + as_named (ans)
			elseif attached {FUNCTION [TUPLE, ANY]} a_routine as f then
				ans := f.item (f.operands)
				is_ok := ans.out ~ a_expected.out
				s := s + " ==> " + as_named (ans)
			else
				check
					should_not_happen: False
					-- because `a_routine' is a {PROCEDURE} or a {FUNCTION}
				end
				ans := " should_not_happen "
			end
			io.put_string (s + "%N")
			if not is_ok then
				io.put_string ("%T  ERROR -- expected  " + as_named (a_expected) + "%N")
			end
			assert (s, is_ok)
		end

	signature (a_routine: ROUTINE; a_feature: STRING): STRING
			-- Create a string representing a feature's signature.
		require
			target_closed: attached a_routine.target
			no_open_arguments: a_routine.open_count = 0
			expected_types: is_valid_target_type (a_routine)
		local
			i: INTEGER
			a: detachable ANY
			c: INTEGER  -- temp for testing
		do
			Result := ""
			check attached a_routine.target as t and attached a_routine.closed_operands as args then
				if attached {like Current} t then
						-- This must be a agent for an attribute
					check args.count >= 2 and then attached args [2] as a2 then
						Result := Result + a2.generating_type + ":  "
						Result := Result + "(" + as_named (args [2]) + ")." + a_feature
						if args.count >= 3 then
							Result := Result + "("
							from i := 3
							until i > args.count
							loop
								a := args [i]
								Result := Result + as_named (a)
								if i < args.count then
									Result := Result + ", "
								end
								i := i + 1
							end
							Result := Result + ")"
						end
					end
				else
					Result := t.generating_type.out + ":  "
					Result := Result + "(" + as_named (t) + ")." + a_feature
					c := args.count
					if args.count >= 2 then
						Result := Result + " ("
						from i := 2
						until i > args.count
						loop
							a := args [i]
							Result := Result + as_named (a)
							if i < args.count then
								Result := Result + ", "
							end
							i := i + 1
						end
						Result := Result + ")"
					end
				end
			end
		end

	as_named (a_any: detachable ANY): STRING_8
		do
			Result := ""
			if attached {JJ_SORTABLE_SET [COMPARABLE]} a_any as set then
				Result := ""
				from set.start
				until set.is_after
				loop
					Result := Result + as_named (set.item)
					if set.index < set.count then
						Result := Result + ","
					end
					set.forth
				end
			elseif attached {STRING} a_any as s then
--				Result := Result + "%"" + s.out + "%""
				Result := Result + s.out
			elseif attached {like graph_anchor} a_any as g then
				Result := Result + as_graph_name (g)
			elseif attached {like node_anchor} a_any as n then
				Result := Result + as_node_name (n)
			elseif attached {like edge_anchor} a_any as e then
				Result := Result + as_edge_name (e)
			elseif attached {like iterator_anchor} a_any as it then
				Result := Result + as_iterator (it)
			elseif attached a_any then
				Result := Result + a_any.out
			else
				Result := "Void"
			end
		end

	as_iterator (a_iterator: like iterator_anchor): STRING_8
			-- A condensed, readable form for `a_iterator'
		do
			Result := " for " + as_graph_name (a_iterator.graph) + " "
				--			if a_iterator.is_exploring_paths then
				--				Result := Result + "is_exploring_paths"
				--			elseif a_iterator.is_traversing_edges then
				--				Result := Result + "is_traversing_edges"
				--			elseif a_iterator.is_visiting_nodes then
				--				Result := Result + "is_visiting_nodes"
				--			end
				--			Result := Result + "  from  " + as_node_name (a_iterator.root_node)
				--			Result := Result + "  via "

		end

	as_graph_name (a_graph: like graph_anchor): STRING_8
			-- A human readable identification of `a_graph'
		require
			has_graph: graphs.has_item (a_graph)
		do
			from graphs.start
			until graphs.item_for_iteration = a_graph
			loop
				graphs.forth
			end
			Result := graphs.key_for_iteration
		end

	as_node_name (a_node: like node_anchor): STRING_8
			-- A human readable idetifacation of `a_node'
		do
			from nodes.start
			until nodes.item_for_iteration = a_node
			loop
				nodes.forth
			end
			Result := nodes.key_for_iteration
		end

	as_edge_name (a_edge: like edge_anchor): STRING_8
			-- A human readable idetifacation of `a_edge'
		require
			has_edge: edges.has_item (a_edge)
		local
			c: CURSOR
		do
			c := edges.cursor
			from edges.start
			until edges.item_for_iteration = a_edge
			loop
				edges.forth
			end
			Result := edges.key_for_iteration
			edges.go_to (c)
		end

	divider (a_string: STRING_8)
			-- Print a dividing line containing `a_string'
			-- (e.g.  "----------- a_string ------------"
		local
			w, c, n, i: INTEGER_32
		do
			io.put_string ("%N%N%N")
			w := 70
			c := a_string.count
			n := (w - c) // 2
			from i := 1
			until i > n
			loop
				io.put_string ("-")
				i := i + 1
			end
			io.put_string (" " + a_string + " ")
			from i := 1
			until i > n
			loop
				io.put_string ("-")
				i := i + 1
			end
			io.put_string ("%N")
		end

feature {NONE} -- Implementation

	graph_1: like graph_anchor
			-- A graph to be tested

	graph_2: like graph_anchor
			-- Another graph to be tested

	graph_3: like graph_anchor
			-- A third graph to test

	graph_4: like graph_anchor
			-- Graph contianing nodes X, Y, and Z connected
			-- by directed edges only.

	node_a: like node_anchor attribute create Result end
	node_b: like node_anchor attribute create Result end
	node_c: like node_anchor attribute create Result end
	node_d: like node_anchor attribute create Result end
	node_e: like node_anchor attribute create Result end
	node_f: like node_anchor attribute create Result end
	node_g: like node_anchor attribute create Result end
	node_h: like node_anchor attribute create Result end
	node_i: like node_anchor attribute create Result end
	node_j: like node_anchor attribute create Result end
	node_k: like node_anchor attribute create Result end
	node_l: like node_anchor attribute create Result end
	node_m: like node_anchor attribute create Result end
	node_n: like node_anchor attribute create Result end
	node_o: like node_anchor attribute create Result end
	node_p: like node_anchor attribute create Result end
	node_q: like node_anchor attribute create Result end
	node_r: like node_anchor attribute create Result end
	node_s: like node_anchor attribute create Result end
	node_t: like node_anchor attribute create Result end
	node_u: like node_anchor attribute create Result end
	node_v: like node_anchor attribute create Result end
	node_w: like node_anchor attribute create Result end
	node_x: like node_anchor attribute create Result end
	node_y: like node_anchor attribute create Result end
	node_z: like node_anchor attribute create Result end

	graphs: HASH_TABLE [like graph_anchor, STRING_8]
			-- Pairs a string identifier to a graph for test bookkeeping

	nodes: HASH_TABLE [like node_anchor, STRING_8]
			-- Pairs a string identifier to a node for test bookkeeping

	edges: HASH_TABLE [like edge_anchor, STRING_8]
			-- Pairs a string identifier to an edge for test bookkeeping

	e_name (a_name: STRING_8): like edge_anchor
			-- The {EDGE} from `edges' with key `a_name'
		do
			Result := edges.definite_item (a_name)
		end

feature {NONE} -- Implementation

	graph_anchor: GRAPH
			-- Anchor for features using a graph.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: NODE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: EDGE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	iterator_anchor: GRAPH_ITERATOR
			-- Anchor for features using graph iterators.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	path_anchor: WALK
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
