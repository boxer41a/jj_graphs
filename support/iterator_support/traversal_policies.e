note
	description: "[
		Decomposition of some functions and data structures for
		use by {GRAPH_ITERATOR}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2013, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/traversal_policies.e $"
	date:		"$Date: 2013-01-13 08:58:55 -0500 (Sun, 13 Jan 2013) $"
	revision:	"$Revision: 9 $"

deferred class
	TRAVERSAL_POLICIES

feature -- Initializetion

	initialize_traversal
			-- Perform requred initialization, if any, when
			-- a traversal method changes.
		deferred
		end

feature -- Traversal policies

	set_validate_mode
			-- Make Current assume that the `graph' can change during
			-- an iteration cycle, possibly invalidating one or more of the paths
			-- in `explored_paths' and therefore must check each path for validity.
			-- This can induce slow iterations.
		do
			is_validate_mode := True
		ensure
			safe_mode_was_set: is_validate_mode
		end

	set_unsafe_mode
			-- Make Current assume that the `graph' will NOT change during
			-- an iteration cycle and all paths explored so far are still
			-- valid.  If in this mode it is possible to encounter an edge
			-- that `is_disconnected' when looking at the `expored_paths'.
			-- Also, an explored path could become invalid without crashing
			-- if not `is_inspecting_reachables' and one of its nodes or edges
			-- is deleted from the `graph'.
		do
			is_validate_mode := False
		ensure
			unsafe_mode_was_set: not is_validate_mode
		end

	explore_paths
			-- Make traversal explore all posible paths.
			-- May traverse edges more than once.
			-- And may visit nodes more than once.
			-- See also `traverse_edges' and `visit_nodes'
		do
			is_exploring_paths := True
			is_traversing_edges := False
			is_visiting_nodes := False
		ensure
			is_expoloring_paths: is_exploring_paths
			not_traversing_edges: not is_traversing_edges
			not_visiting_nodes: not is_visiting_nodes
		end

	traverse_edges
			-- Make sure all edges will be traversed once.
			-- May visit nodes more than once.
			-- Some paths may go unexplored.
			-- See also `explore_paths' and `visit_nodes'
		do
			is_exploring_paths := False
			is_traversing_edges := True
			is_visiting_nodes := False
		ensure
			not_expoloring_paths: not is_exploring_paths
			is_traversing_edges: is_traversing_edges
			not_visiting_nodes: not is_visiting_nodes
		end

	visit_nodes
			-- Make sure all nodes will be visited once and only once.
			-- Some edges may go untraversed.
			-- Some paths may go unexplored.
			-- See also `traverse_edges' and `explore_paths'
		do
			is_exploring_paths := False
			is_traversing_edges := False
			is_visiting_nodes := True
		ensure
			not_expoloring_paths: not is_exploring_paths
			not_traversing_edges: not is_traversing_edges
			is_visiting_nodes: is_visiting_nodes
		end

	inspect_children
			-- Make sure traversal will be along edges leaving nodes.
			-- Opposite of `inspect_parents'.
		do
			is_inspecting_children := True
			is_inspecting_parents := False
		ensure
			is_inspecting_children: is_inspecting_children
			not_inspecting_parents: not is_inspecting_parents
		end

	inspect_parents
			-- Make sure traversal will be along edges entering nodes.
			-- Opposite of `inspect_children'.
			-- Edges for which `is_directed' (from EDGE) is True will only be
			-- traversed in one direction.  This feature is used to override
			-- the direction "implied" by the `node_from' and `node_to' of EDGE;
			-- but not to override the direction of a "directed" edge.
		do
			is_inspecting_children := False
			is_inspecting_parents := True
		ensure
			not_inspecting_children: not is_inspecting_children
			not_inspecting_parents: is_inspecting_parents
		end

	inspect_relations
			-- Make sure traversal will be along any edge no matter its direction.
			-- Both `inspect_children' and `inspect_parents'.
			-- Edges for which `is_directed' (from EDGE) is True will only be
			-- traversed in one direction.  This feature is used to override
			-- the direction "implied" by the `node_from' and `node_to' of EDGE;
			-- but not to override the direction of a "directed" edge.
		do
			is_inspecting_children := True
			is_inspecting_parents := True
		ensure
			is_inspecting_children: is_inspecting_children
			is_inspecting_parents: is_inspecting_parents
		end

	see_reachables
			-- Make it possible for traversals to visit nodes or edges that
			-- are reachable from the `root_node' wheather or not they are "visible"
			-- to (or in other words "in") the `graph'.
			-- This makes it possible to create a GRAPH, set the `root_node' node
			-- and do sorts without first putting each node and edge into
			-- the graph itself.
			-- Opposite of `see_visibles'.
		do
			is_seeing_reachables := True
		ensure
			is_seeing_reachable: is_seeing_reachables
		end

	see_visibles
			-- Make it possible for traversals to visit only thoses nodes
			-- or traverse those edges that are actually "visible" (in other
			-- words "in") the `graph'.
			-- Some nodes may be reachable from the `root_node' but will not show
			-- up in the traversal.
			-- Opposite of `see_reachables'.
		require
--			graph_exists: has_graph
		do
			is_seeing_reachables := False
		ensure
			not_seeing_reachable: not is_seeing_reachables
		end

feature -- Traversal policy status report

	is_validate_mode: BOOLEAN
			-- Is Current being as safe as possible?
			-- When true, Current must assume that the `graph' can change during
			-- an iteration cycle, possibly invalidating one or more of the paths
			-- in `explored_paths' and therefore must check each path for validity.
			-- This can induce slow iterations.

	is_exploring_paths: BOOLEAN
			-- Will all posible paths be explored?
			-- May traverse edges more than once.
			-- And may visit nodes more than once.

	is_traversing_edges: BOOLEAN
			-- Will all the edges be traversed once?
			-- May visit nodes more than once.
			-- Some paths may go unexplored.

	is_visiting_nodes: BOOLEAN
			-- Will all nodes be visited once?
			-- Some edges may go untraversed.
			-- Some paths may go unexplored.

	is_inspecting_children: BOOLEAN
			-- Is traversal along the edges leaving nodes?

	is_inspecting_parents: BOOLEAN
			-- Is traverse along edges coming into nodes?

	is_inspecting_relations: BOOLEAN
			-- Is traversal in both directions regardless of direction of edges?
			-- Is the graph undirected?
		do
			Result := is_inspecting_children and is_inspecting_parents
		end

	is_seeing_reachables: BOOLEAN
			-- Is a traversal able to visit a node or edge that is "reachable" from
			-- the root_node wheather it is "visible" (in other words "in") the graph or not.
			-- See `inspect_visibles' and `inspect_reachables'

feature -- Traversal methods

	set_shortest_first
			-- Make Current traverse the graph in alphabetical order,
			-- following the shortest paths first.
			-- Results of previous traversals are lost.
		do
			if traversal_method /= Shortest_first then
				initialize_traversal
			end
			traversal_method := Shortest_first
		ensure
			sorting_shortest_first: traversal_method = Shortest_first
		end

	set_breadth_first
			-- Make Current traverse the graph in breadth-first order.
			-- Begin at the root node and explore all the neighboring nodes.  Then
			-- for each of those nearest nodes, it explores their unexplored
			-- neighbor nodes, and so on.
			--           1
			--          /|\
			--		   2 3 4
			--		  /|   |\
			--       5 6   7 8
			--      /|     |\
			--     9 10   11 12
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Breadth_first
		ensure
			sorting_breadth_first: traversal_method = Breadth_first
		end

	set_depth_first
			-- Make Current traverse the graph in depth-first order.  Start
			-- at the root and explore as far as possible along each branch
			-- before backtracking.
			-- (http://en.wikipedia.org/wiki/Depth-first_search)
			--           1
			--          /|\
			--		   2 7 8
			--		  /|   |\
			--       3 6   9 12
			--      /|     |\
			--     4 5    10 11
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Depth_first
		ensure
			sorting_depth_first: traversal_method = Depth_first
		end

	set_pre_order
			-- Same as `set_depth_first'.
			--           1
			--          /|\
			--		   2 7 8
			--		  /|   |\
			--       3 6   9 12
			--      /|     |\
			--     4 5    10 11
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Pre_order
		ensure
			sorting_pre_order: traversal_method = Pre_order
		end

	set_post_order
			-- Make next `sort' be in post-order
			--(i.e. visit all children then the parent)
			--           12
			--          /|\
			--		   5 6 11
			--		  /|   |\
			--       3 4   9 10
			--      /|     |\
			--     1 2     7 8
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Post_order
		ensure
			sorting_post_order: traversal_method = Post_order
		end

	set_in_order
			-- Make Current traverse the tree in `in_order' fashion.
			-- Traverse the left subtree, visit the root, traverse the
			-- right subtree, etc.  This will visit the lowest leaf, parent,
			-- remaining leaves, parent, etc.
			--           6
			--          /|\
			--		   4 7 11
			--		  /|   |\
			--       2 5   9 12
			--      /|     |\
			--     1 3     8 10
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := In_order
		ensure
			sorting_in_order: traversal_method = In_order
		end

	set_bottom_up
			-- Make Current traverse the graph from the lowest level first
			-- up to the root (i.e. visit children furtherest away from the,
			-- `root_node' first, then visit the children one level closer
			-- to the `root_node', etc.)
			--           12
			--          /| \
			--		   9 10 11
			--		  /|    |\
			--       5 6    7 8
			--      /|      |\
			--     1 2      3 4
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Bottom_up
		end

	set_leaf_first
			-- Make Current traverse the graph by moving down a branch
			-- until reaching a leaf node.  Then move to the next leaf, etc.
			--           12
			--          /|\
			--		   9 4 11
			--		  /|   |\
			--       8 3  10 7
			--      /|     |\
			--     1 2     5 6
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Leaf_first
		end

	set_leaves_only
			-- Make Current traverse the graph by moving down a branch
			-- until reaching a leaf node.  Then move to the next leaf,
			-- but visit only the leaf nodes, no internal nodes.
			--           x
			--          /|\
			--		   x 4 x
			--		  /|   |\
			--       x 3   x 7
			--      /|     |\
			--     1 2     5 6
		do
			if traversal_method = Shortest_first then
				initialize_traversal
			end
			traversal_method := Leaves_only
		end

feature -- Traversal method status report

	is_shortest_first: BOOLEAN
			-- Is `traversal_method' set to `Shortest_first'?
		do
			Result := traversal_method = Shortest_first
		end

	is_breadth_first: BOOLEAN
			-- Is `traversal_method' set to `Breadth_first'?
		do
			Result := traversal_method = Breadth_first
		end

	is_depth_first: BOOLEAN
			-- Is `traversal_method' set to `Depth_first'?
		do
			Result := traversal_method = Depth_first
		end

	is_pre_order: BOOLEAN
			-- Is `traversal_method' set to `Pre_order'?
		do
			Result := traversal_method = Pre_order
		end

	is_post_order: BOOLEAN
			-- Is `traversal_method' set to `Post_order'?
		do
			Result := traversal_method = Post_order
		end

	is_in_order: BOOLEAN
			-- Is `traversal_method' set to `In_order'?
		do
			Result := traversal_method = In_order
		end

	is_bottom_up: BOOLEAN
			-- Is `traversal_method' set to `Bottom_up'?
		do
			Result := traversal_method = Bottom_up
		end

	is_leaf_first: BOOLEAN
			-- Is `traversal_method' set to `Leaf_first'?
		do
			Result := traversal_method = Leaf_first
		end

	is_leaf_only: BOOLEAN
			-- Is `traversal_method' set to `leaves_only'?
		do
			Result := traversal_method = Leaves_only
		end

feature {NONE} -- Implementation (constants)

	Default_size: INTEGER = 100
			-- Used to initialize the size of `traversed_edges'.

	Shortest_first: INTEGER = 1
	Breadth_first: INTEGER = 2
	Depth_first: INTEGER = 3
	Pre_order: INTEGER = 4
	Post_order: INTEGER = 5
	In_order: INTEGER = 6
	Leaf_first: INTEGER = 7
	Bottom_up: INTEGER = 8
	Leaves_only: INTEGER = 9

	last_traversal_method: INTEGER
			-- The last of the above constants.
		do
			Result := Leaves_only
		end

	traversal_method: INTEGER
			-- How the graph is to be traversed.end

invariant

	traversal_method_large_enough: traversal_method >= Shortest_first
	traversal_method_small_enough: traversal_method <= last_traversal_method

end
