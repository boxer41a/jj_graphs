note
	description: "[
		Iterator for traversing a GRAPH.

		A GRAPH_ITERATOR is used to traverse a JJ_GRAPH by moving along edges
		from one node to another in a prescribed pattern such as pre-order, post-order,
		breadth-first, etc by starting at a `root_node' and continuing to traverse edges
		to visit nodes until there are no more edges.

		The status setting features provide several options for the manner in which the
		graph will be traversed.

		Edges and nodes that are not "visible" to the graph (i.e. added to `nodes' and
		`edges' using `extend_node' or `extend_edge') will not normally be traversed or
		visited.  This allows one graph to contain the same nodes as another but the
		traversals can produce different results.
		However, this can be overriden by feature `inspect_reachables' which makes all
		edges of all the nodes traversable whether or not they are "in" the graph.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/graphs_618/trunk/graphs/interface/iterators/graph_iterator.e $"
	date:		"$Date: 2012-07-05 00:31:27 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 13 $"

class
	GRAPH_ITERATOR

inherit

	TRAVERSAL_POLICIES
		redefine
			default_create
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	default_create
			-- *Initialize* an iterator for traversing any {GRAPH} after `set_root_node' is called.
			-- The iterator will visit nodes that are reachable from the `root_node', as
			-- this iterator is not associated with any graph.
		do
			create pending_paths.make (Default_size)
			create explored_paths.make (Default_size)
			explored_paths.compare_objects
			see_reachables
			inspect_relations
			visit_nodes
			set_breadth_first
			is_after := True
		ensure then
			will_visit_nodes: is_visiting_nodes
			will_visit_reachable_nodes: is_seeing_reachables
			will_visit_ALL_reachable_nodes: is_inspecting_relations
			will_visit_breadth_first: is_breadth_first
			is_after: is_after
		end

	make (a_graph: like graph_anchor)
			-- Create a cursor to traverse the node/edges in `a_graph'
			-- If the `root_node' is in `a_graph' then use it; otherwise, for Current
			-- to be usable, `set_root_node' must be called.
			-- The traversal will visit nodes that are in `a_graph'.
		require
			graph_exists: a_graph /= Void
		do
			default_create
			graph_imp := a_graph
			see_visibles
			if has_root_node and then not graph.has_node (root_node) then
				root_node_imp := Void
			end
		ensure
			is_after: is_after
			will_visit_nodes: is_visiting_nodes
			will_visit_visible_nodes: not is_seeing_reachables
			will_visit_ALL_visible_nodes: is_inspecting_relations
			will_visit_breadth_first: is_breadth_first
			is_before: root_node_imp /= Void implies is_before
			graph_was_set: graph = a_graph
		end

feature -- Access

	graph: like graph_anchor
			-- The graph to be traversed.
		require
			has_graph: has_graph
		do
			check attached graph_imp as g then
				Result := g
			end
		end

	root_node: like node_anchor
			-- The node to use as the root for traversals.
		require
			has_root_node: has_root_node
		do
			check attached root_node_imp as n then
				Result := n
			end
		end

	node: like node_anchor
			-- The node at the current position
		require
			not_off: not is_off
		do
			Result := path.last_node
		end

	edge: like edge_anchor
			-- The last edge traversed to get to `node'
		require
			not_alpha_beta_sorted: not is_alphabetical
			not_off: not is_off
			not_at_root: not is_at_root
		do
			Result := path.last_edge
		end

	path: like path_anchor
			-- Path walked to get to current `node'.
		require
			not_off: not is_off
		do
			Result := explored_paths.last
		end

	reachable_nodes: JJ_ARRAYED_SET [like node_anchor]
			-- All the "visible" nodes that can be reached from the `root_node'
			-- given the current traversal settings.
		local
			it: like Current
			n: like node_anchor
		do
			create Result.make (100)
				-- In order to not disrupt the state of Current we make
				-- a new iterator and start over from the start.
			it := Current.twin
			from it.start
			until it.is_after
			loop
				n := it.node
				Result.extend (n)
				it.forth
			end
		end

feature -- Element change

	set_graph (a_graph: like graph)
			-- Change `graph' to `a_graph'.
			-- If `is_inspecting_reachables' and `a_graph' is different from `graph',
			-- any traversal in progess will be wiped out.
		require
			graph_exists: a_graph /= Void
		do
			if not is_seeing_reachables and then graph /= a_graph then
				initialize_traversal_structures
-- fix me:  Do I really want to discard the traversal just because the graph changed?
			end
			graph_imp := a_graph
		ensure
			graph_was_set: graph = a_graph
		end

	set_root_node (a_node: like node_anchor)
			-- Change the `root_node' to `a_node'.
		require
			node_exists: a_node /= Void
		do
			root_node_imp := a_node
		ensure
			root_was_set: root_node = a_node
		end

feature -- Measurement

	level: INTEGER
			-- Level (or depth) of the current node away from the `root_node'.
			-- The `root_node' is at `level' number 1.
		require
			not_off: not is_off
		do
			Result := path.edge_count + 1
		ensure
			result_large_enough: Result >= 0
		end



feature -- Status report

	has_graph: BOOLEAN
			-- Is Current iterating over a particular graph?
		do
			Result := graph_imp /= Void
		end

	has_root_node: BOOLEAN
			-- Has a `root_node' been designated with `set_root_node'?
		do
			Result := root_node_imp /= Void
		end

	is_empty: BOOLEAN
			-- Can this iterator be considered to be empty?
		do
			if not has_root_node then
				Result := True
			elseif is_seeing_reachables then
				Result := False
			elseif has_graph and then graph.has_node (root_node) then
				Result := False
			else
				Result := True
			end
		end

	is_off: BOOLEAN
			-- Is the cursor before of after the structure?
		do
			Result := is_before or is_after
		ensure
			definition: Result implies is_before or is_after
		end

	is_before: BOOLEAN
			-- Is the cursor before the first node?

	is_after: BOOLEAN
			-- Is the cursor after the last node?

	is_at_root: BOOLEAN
			-- Is the cursor at the root node?
		do
			Result := not is_off and then path.last_node = root_node
		end

	validate_paths
			-- Go through all the paths deleting any that contain a disconnected edge.
			-- An edge could become disconnected if a graph removes or disconnects a
			-- node; the edge could still be in a path in the iterator, though.
		local
			p: like path_anchor
			i: INTEGER
		do
			if is_validate_mode then
				from i := 1
				until i > explored_paths.count
				loop
					p := explored_paths.i_th (i)
					if is_bad_path (p) then
						explored_paths.prune (p)
					else
						i := i + 1
					end
				end
			else
					-- Assume all paths are good.
			end
		end

feature -- Basic operations

	visit_node (a_node: like node_anchor)
			-- Mark `a_node' as "visited" by Current
		require
			node_exists: a_node /= Void
		do
			a_node.visit_by (Current)
		ensure
			was_visited: was_node_visited (a_node)
			was_visited_by_current: a_node.was_visited_by (Current)
		end

	unvisit_node (a_node: like node_anchor)
			-- Ensure `a_node' has not been marked as visited
		require
			node_exists: a_node /= Void
		do
				a_node.unvisit_by (Current)
		ensure
			not_visited: not was_node_visited (a_node)
			not_visited_by_current: not a_node.was_visited_by (Current)
		end

	traverse_edge (a_edge: like edge_anchor)
			-- Mark `a_edge' as "traversed" by Current
		require
			edge_exits: a_edge /= Void
		do
			a_edge.traverse_by (Current)
		ensure
			was_traversed: was_edge_traversed (a_edge)
			was_traversed_by_current: a_edge.was_traversed_by (Current)
		end

	untraverse_edge (a_edge: like edge_anchor)
			-- Ensure that `a_edge' is not marked as traversed.
			-- Do not change the nodes that have been visited or the paths
			-- that have been traversed; because, even though we may have
			-- visited a node by traversing an edge, we may still want to
			-- unmark the edge in order to traverse it again.
		require
			edge_exists: a_edge /= Void
		local
			i: INTEGER
			p: like path_anchor
		do
			a_edge.untraverse_by (Current)
		ensure
			not_traversed: not was_edge_traversed (a_edge)
			not_traversed_by_current: not a_edge.was_traversed_by (Current)
		end

	explore_path (a_path: like path_anchor)
			-- Ensure `a_path' is marked as explored by Current
		require
			path_exists: a_path /= Void
		local
			i: INTEGER
		do
			explored_paths.extend (a_path)
		ensure
			path_was_explored: was_path_explored (a_path)
		end

	unexplore_path (a_path: like path_anchor)
			-- Ensure `a_path' is not marked as explored by Current (fix me to include ref. integ.)
			-- Does not change the visited or traversed status of
			-- any of the nodes and edges in `a_path'
		require
			path_exists: a_path /= Void
		do
			explored_paths.prune (a_path)
		ensure
			path_not_explored: not explored_paths.has (a_path)
		end

feature -- Query

	is_valid_root_node (a_node: like node_anchor): BOOLEAN
			-- Can `a_node' be used as the root for traversals?
		require
			node_exists: a_node /= Void
		do
			Result := is_seeing_reachables or else graph.has_node (a_node)
		end

	was_node_visited (a_node: like node_anchor): BOOLEAN
			-- Has Current visited `a_node' during this traversal?
		do
			validate_paths
			Result := visited_nodes.has (a_node)
		ensure
			implication: Result implies visited_nodes.has (a_node)
		end

	was_edge_traversed (a_edge: like edge_anchor): BOOLEAN
			-- Has `a_edge' been traversed during this traversal?
		do
			validate_paths
			Result := traversed_edges.has (a_edge)
		end

	was_path_explored (a_path: like path_anchor): BOOLEAN
			-- Has a path equivelant to `a_path' been explored during current traversal?
		do
			validate_paths
			Result := explored_paths.has (a_path)
		end

	is_reachable (a_node: like node_anchor): BOOLEAN
			-- Is `a_node' reachable from `root_node' by this iterator?
		require
			node_exists: a_node /= Void
		local
			it: like Current
			vn: like visited_nodes
			te: like traversed_edges
			ep: like explored_paths
			pp: like pending_paths
		do
				-- Don't deep copy the lists
			ep := explored_paths.twin
			pp := pending_paths.twin
				-- wipe_out the lists
			start
				-- Copy Current
			it := deep_twin
				-- Traverse until findind `a_node'
			from start
			until Result or else is_after
			loop
				if has_graph and then graph.object_comparison then
					Result := node ~ a_node
				else
					Result := node = a_node
				end
				forth
			end
				-- Restore Current's state
			explored_paths := ep
			pending_paths := pp
		end

	shortest_paths (a_node, a_other: like node_anchor; a_number: INTEGER): JJ_SORTABLE_ARRAY [like path_anchor]
			-- List of up to `a_number' of paths from `a_node' to `a_other'
			-- sorted from shortest path to longer ones.
		require
			node_exists: a_node /= Void
			other_node_exists: a_other /= Void
--			seeing_reachables_implication: is_seeing_reachables or else has_graph
--			not_seeing_reachables_implies_graph_has_root: not is_seeing_reachables implies graph.has_node (root_node)
--			not_seeing_reachables_implies_graph_has_node: not is_seeing_reachables implies graph.has_node (a_node)
		local
			p, new_p: like path_anchor
			heap: JJ_SORTABLE_ARRAY [like path_anchor]		-- Serves as a minimum priority heap
			n_tab: HASH_TABLE [INTEGER, like node_anchor]	-- Number of paths to the indexed node
			c: INTEGER
			n: like node_anchor
			e: like edge_anchor
			i: INTEGER
		do
			create Result.make (100)
			create heap.make (100)
			create n_tab.make (100)
			create p.make (a_node)
			heap.set_ordered
			from
				heap.extend (p)
				n_tab.force (0, p.last_node)
			until heap.is_empty or (attached n_tab.item (a_other) as oc and then oc >= a_number)
			loop
					-- Get & remove the smallest item from the `heap'
				heap.go_i_th (1)
				p := heap.item
				heap.remove
					-- Update the count for number of paths to `p's `last_node'
				n := p.last_node
				if attached n_tab.item (n) as otl_c then
					c := otl_c + 1
				else
					c := 1
				end
				n_tab.force (c, n)
					-- If destination node reached, add that path to Result
				if n = a_other then
					Result.extend (p)
				end
					-- Continue to adjacent nodes
				if c <= a_number then
					from i := 1
					until i > n.out_count
					loop
							-- Make new paths by extending `p' with each edge in turn
						e := n.i_th_child_edge (i)
						new_p := p.subpath (1, p.node_count)
						new_p.extend (e)
						if not p.is_edge_cylcic and not heap.has (p)then
							heap.extend (new_p)
						end
						i := i + 1
					end
				end
			end
		ensure
--			start_node_correct: Result.for_all (agent (a_node, a_test): BOOLEAN do end (?, a_node))
--			start_node_correct: (Result.for_all (agent {JJ_SORTABLE_ARRAY [like path_anchor]}.first = a_node))
--											 (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]) = root_node
--			last_node_correct: Result.last_node = a_node
--			start_node_correct: across Result as l_node all l_node = a_node end
--			last_node_correct: across Result as l_node all l_node = a_other end
		end

	minimal_spanning_tree: like graph
			-- A graph which is the minimal spanning tree for `graph'.
			-- In graph theory literature a MST is produced from a connected, undirected,
			-- weighted graph.  But remember that we have no "directed/undirected"
			-- graph class.  If `graph' `is_disconnected' then the nodes not reachable from
			-- Current are ignored and will not be included in the tree.  To get the nodes
			-- not included simply get the difference (`infix "-"') between `graph' and Result.
			-- If the graph does not have weighted edges then any spanning tree is minimal,
			-- because the costs for traversing any edge is one and equal to the cost of
			-- traversing any of the other edges.
		require
			graph_exists: has_graph
			directed_graph_needs_root: (not graph.is_undirected or else not is_inspecting_relations)
											 implies has_root_node
		local
			i: INTEGER
			e: like edge_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
--			dir_e_set: JJ_SORTABLE_SET [like edge_anchor]
		do
				-- Create a result "like" `graph' G.  The result type may not have a creation
				-- procedure available which will allow creation without knowing more about the
				-- type.  Therefore use a copy of Current that is cleaned out.  This is inefficient
				-- because must make a deep copy and then disconnect *all* the edges in the copy
				-- to get back to an empty graph.
			Result := graph.twin
--			Result.wipe_out
			if not graph.is_undirected or else not is_inspecting_relations then
					-- use Chu-Liu/Edmonds Algorithm
				Result.extend_node (root_node)
--	1. Discard the arcs entering the root if any; For each node other than the root, select
--		the entering arc with the smallest cost; Let the selected n-1 arcs be the set S.
--	2. If no cycle formed, G(N,S) is a MST. Otherwise, continue.
--	3. For each cycle formed, contract the nodes in the cycle into a pseudo-node (k), and modify
--		the cost of each arc which enters a node (j) in the cycle from some node (i) outside the
--		cycle according to the following equation.
--			c(i,k)=c(i,j)-(c(x(j),j)-min_{j}(c(x(j),j))
--		where c(x(j),j) is the cost of the arc in the cycle which enters j.
--	4. For each pseudo-node, select the entering arc which has the smallest modified cost;
--		replace the arc which enters the same real node in S by the new selected arc.
--	5. Go to step 2 with the contracted graph.

			else
					-- use Kruskal's algorithm
				e_set := graph.edges
				e_set.sort
				from i := 1
				until i > e_set.count
				loop
					e := e_set.i_th (i)
					if not Result.has_node (e.node_from) or else not Result.has_node (e.node_to) then
						Result.extend_edge (e)
					end
					i := i + 1
				end
			end
		end


feature -- Cursor movement

	start
			-- Move to the first item as specified by traversal_order
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		do
			initialize_traversal_structures
			inspect traversal_method
			when Breadth_first then
				breadth_first_start		-- starts at `root_node', and uses a queue
			when Pre_order, Depth_first then
				pre_order_start			-- both start at `root_node' and use a stack
			when Post_order then
				post_order_start
			when In_order then
				in_order_start
			when Bottom_up then
				bottom_up_start
			when Leaf_first then
				leaf_first_start
			when Leaves_only then
				leaves_only_start
			when Shortest_first then
				shortest_first_start
			else
			end
		ensure
			not_before: not is_before
		end

	forth
			-- Move to the next item as specified by traversal_order
		require
			not_after: not is_after
		do
--			validate_paths
			if is_empty then
				is_before := False
				is_after := True
			else
				inspect traversal_method
				when Breadth_first then
					breadth_first_forth
				when Pre_order, Depth_first then	-- depth-first is same as pre-order
					pre_order_forth
				when Post_order then
					post_order_forth
				when In_order then
					In_order_forth
				when Bottom_up then
					bottom_up_forth
				when Leaf_first then
					leaf_first_forth
				when Leaves_only then
					leaves_only_forth
				when Shortest_first then
					shortest_first_forth
				else

				end
			end
		ensure
			not_before: not is_before
			empty_implication: is_empty implies is_after
		end

	back
			-- Move to the previous item
		require
			root_exists: has_root_node
			not_before: not is_before
		local
			p: like path_anchor
		do
			validate_paths
			explored_paths.finish
			p := explored_paths.item
			explored_paths.remove
		ensure
			not_after: not is_after
		end

feature {NONE} -- Cursor movement (helper routines)

	initialize_traversal_structures
			-- Clean out all structures in preparation for new traversal
		do
			is_unstable := True
			across traversed_edges as c loop c.item.untraverse_by (Current) end
			across visited_nodes as c loop c.item.unvisit_by (Current) end
			is_unstable := False
			explored_paths.wipe_out
			pending_paths.wipe_out
		ensure
			none_visited: visited_nodes.is_empty
			none_traversed: traversed_edges.is_empty
			no_paths: explored_paths.is_empty
			none_pending: pending_paths.is_empty
		end

	traversal_set (a_node: like node_anchor): JJ_SORTABLE_SET [like edge_anchor]
			-- One of the sets from `a_node' that holds the child edges, parent
			-- edges, or all edges connecting to `a_node'.
		require
			node_exists: a_node /= Void
		do
			if is_inspecting_relations then
				Result := a_node.connections
			elseif is_inspecting_children then
				Result := a_node.connections_from
			else		-- is_inspecting_parents
				Result := a_node.connections_to
			end
		end

	is_cyclic (a_path: like path_anchor): BOOLEAN
			-- Is the path cyclic relative to the traversal policy?
		require
			path_exists: a_path /= Void
		do
			Result := (is_visiting_nodes and then a_path.is_node_cyclic) or else
						(is_traversing_edges and then a_path.is_edge_cylcic) or else
						(is_exploring_paths and then a_path.is_path_cyclic)
		end

	path_extended_to_leaf (a_path: like path_anchor): like path_anchor
			-- Starting at the last node in `a_path', increase it by adding edges
			-- until reaching a leaf node (leaf in the sense that there is an
			-- untraversed path below the last node of `a_path'.
		require
			path_exists: a_path /= Void
--			is_path_extendable: is_path_extendable (a_path)
		local
			n: like node_anchor
			e: like edge_anchor
			p: like path_anchor
			res: detachable like path_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			i: INTEGER
		do
			p := a_path.twin
			n := p.last_node
			e_set := traversal_set (n)
			from i := 1
			until i > e_set.count
			loop
				e := e_set.i_th (i)
				n := e.other_node (n)
				p.extend (e)
				if not is_cyclic (p) and then should_add_this (n, e, p) then
					res := p
					p := res.twin
					n := p.last_node
					e_set := traversal_set (n)
					i := 1
				else
					p.remove
					n := p.last_node
					i := i + 1
				end
			end
			if attached res then
				Result := res
			else
				Result := a_path
			end
		end

	should_add_this (a_node: like node_anchor; a_edge: like edge_anchor; a_path: like path_anchor): BOOLEAN
			-- Used by traversal routines to determine if `a_path' should be added to the
			-- list of explored paths.  It checks the statuses of `is_exploring_paths',
			-- `is_traversing_edges' and `is_visiting_nodes' to make sure this path/node/edge
			-- has not already been traversed/visited.  The directedness of a new edge in
			-- `a_path' is checked prior to calling this.
		require
			node_exists: a_node /= Void
			edge_exists: a_edge /= Void
			path_exists: a_path /= Void
		local
			n: like node_anchor
			e: like edge_anchor
			p: like path_anchor
		do
			e := a_edge
			n := a_node
			p := a_path
			Result :=
						-- Is `n' and `e' "visible" to the graph?
					(is_seeing_reachables or else
						(graph.has_node (n) and then graph.has_edge (e))) and then
						-- Has `p' not been explored or `e' not traversed
						-- or `n' not visited (depending on the traversal statuses)
--					((is_exploring_paths and then not was_path_explored (p)) or
							-- Do not need `was_path_explored' because we never
							-- add a path-cyclic path to `pending_paths'
					(is_exploring_paths or
					(is_traversing_edges and then not e.was_traversed_by (Current)) or
					(is_visiting_nodes and then not n.was_visited_by (Current))) and then
							-- Account for a directed edge
					(not e.is_directed or (e.is_directed and then e.node_to = n))
		end

feature -- Cursor movement (breadth-first)

	breadth_first_start
			-- Move to the first node "breadth-first" (visit nodes by `level' top down).
			--           1
			--          /|\
			--		   2 3 4
			--		  /|   |\
			--       5 6   7 8
			--      /|     |\
			--     9 10   11 12
		require
--			root_exists: has_root_node
--			has_valid_root: is_valid_root_node (root_node)
		local
			p: like path_anchor
		do
			initialize_traversal_structures
			if is_empty then
				is_before := False
				is_after := True
			else
				is_before := False
				is_after := False
				create p.make (root_node)
				pending_paths.extend (p)
				breadth_first_forth
			end
		ensure
			not_empty_implication: (not is_empty) implies node = root_node
			empty_implcation: is_empty implies (not is_before and is_after)
		end

	breadth_first_forth
			-- Move to the next item in `Breadth_first_order'.
			--           1
			--          /|\
			--		   2 3 4
			--		  /|   |\
			--       5 6   7 8
			--      /|     |\
			--     9 10   11 12
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			i: INTEGER
			n: like node_anchor
			e: like edge_anchor
			p: like path_anchor
			last_n: like node_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
		do
			if is_before then
				Breadth_first_start
			elseif pending_paths.is_empty then
				is_after := True
			else
				is_before := False
				is_after := False
				pending_paths.start
				p := pending_paths.item
				last_n := p.last_node
				pending_paths.remove
					-- Visit/traverse/explore the node/edge/path that was just
					-- obtained from the `pending_paths' queue
				explore_path (p)
				if p.edge_count > 0 then
					traverse_edge (p.last_edge)
				end
				visit_node (p.last_node)
					-- Now queue the children of `n'
				last_n := p.last_node
				e_set := traversal_set (last_n)
				from i := 1
				until i > e_set.count
				loop
					e := e_set.i_th (i)
					n := e.other_node (last_n)
					p := path.twin
					p.extend (e)
					if not is_cyclic (p) and then should_add_this (n, e, p) then
						pending_paths.extend (p)
					end
					i := i + 1
				end
			end
		ensure
			not_before: not is_before
		end

feature -- Cursor movement (pre-order/depth-first)

	pre_order_start, depth_first_start
			-- Move to the first node "pre-order" (i.e. parent first, then children).
			--           1
			--          /|\
			--		   2 7 8
			--		  /|   |\
			--       3 6   9 12
			--      /|     |\
			--     4 5    10 11
		local
			p: like path_anchor
		do
			initialize_traversal_structures
			if is_empty then
				is_before := False
				is_after := True
			else
				is_before := False
				is_after := False
				create p.make (root_node)
				pending_paths.extend (p)
				pre_order_forth
			end
		ensure
			not_empty_implication: (not is_empty) implies node = root_node
			empty_implcation: is_empty implies (not is_before and is_after)
		end

	pre_order_forth, depth_first_forth
			-- Move to the next node "pre-order" (i.e. parent first, then children)
			--           1
			--          /|\
			--		   2 7 8
			--		  /|   |\
			--       3 6   9 12
			--      /|     |\
			--     4 5    10 11
		local
			i: INTEGER
			n: like node_anchor
			e: like edge_anchor
			p: like path_anchor
			last_n: like node_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			found: BOOLEAN
		do
			if is_before then
				pre_order_start
			elseif pending_paths.is_empty then
				is_after := True
			else
				is_before := False
				is_after := False
				from pending_paths.start
				until found or pending_paths.is_empty
				loop
					p := pending_paths.item
					last_n := p.last_node
					pending_paths.remove
						-- Visit/traverse/explore the node/edge/path that was just
						-- obtained from the `pending_paths' queue, if not previously
						-- visited/traversed/explored through a subsequently added
						-- path.
					if p.edge_count = 0 then
							-- We are at root
						explore_path (p)
						visit_node (p.last_node)
						found := True
					else
							-- not at root so must ensure not visited through other path
						e := p.last_edge
						n := p.last_node
						if should_add_this (n, e, p) then
							explore_path (p)
							traverse_edge (e)
							visit_node (n)
							found := True
						end
					end
					if found then
							-- Now stack the children of `n'
						last_n := p.last_node
						e_set := traversal_set (last_n)
							-- We will add the children in order to the front
						pending_paths.start
						from i := 1
						until i > e_set.count
						loop
							e := e_set.i_th (i)
							n := e.other_node (last_n)
							p := path.twin
							p.extend (e)
							if not is_cyclic (p) and then should_add_this (n, e, p) then
									-- Add in front of the path that was first when

								pending_paths.put_left (p)
							end
							i := i + 1
						end
					end
				end
				if not found then
					is_after := True
				end
			end
		ensure
			not_before: not is_before
		end


feature -- Cursor movement (post-order)

	post_order_start
			-- Move the the first node "post-order".
			--           6
			--          /|\
			--		   4 7 11
			--		  /|   |\
			--       2 5   9 12
			--      /|     |\
			--     1 3     8 10
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			n: like node_anchor
			e: like edge_anchor
			p: like path_anchor
		do
			initialize_traversal_structures
			if is_empty then
				is_before := False
				is_after := True
			else
				is_before := False
				is_after := False
				create p.make (root_node)
				pending_paths.extend (path_extended_to_leaf (p))
				post_order_forth
			end
		ensure
			not_before: not is_before
			not_after: not is_after
		end

	post_order_forth
			-- Move to the next node "post-order" (i.e. children first, then parent)
			--           12
			--          /|\
			--		   5 6 11
			--		  /|   |\
			--       3 4   9 10
			--      /|     |\
			--     1 2     7 8
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
			not_after: not is_after
		local
			p: like path_anchor
			n: like node_anchor
			nc: INTEGER
			done: BOOLEAN
		do
			if is_before then
				post_order_start
			elseif pending_paths.is_empty then
				is_after := True
			else
				is_before := False
				is_after := False
				pending_paths.start
				p := pending_paths.item
				explore_path (p)
				if p.edge_count > 0 then
					traverse_edge (p.last_edge)
				end
				visit_node (p.last_node)
				pending_paths.remove
						-- At this point we have just visited a leaf, so
						-- now check for more paths out of the previous node.
						-- Keep going up and checking until at root.
				if p.node_count = 1 then
						-- The last path we pulled from `pending_paths' was
						-- the path to the `root_node' so we are done.
				else
						-- We are not at the root; there MAY be more leaves
						-- on paths coming out of a previous node up to and
						-- including the `root_node'.
					from p := p.twin
					until done
					loop
						p.remove
						nc := p.node_count
						p := path_extended_to_leaf (p)
						if p.node_count > nc then
								-- The path was extended
							done := True
							pending_paths.extend (p)
						elseif p.node_count = 1 then
								-- path was not extended, but we are at `root_node'
							done := True
							pending_paths.extend (p)
						else
								-- try one node higher in path
						end
					end
				end
			end
		ensure
			not_before: not is_before
		end

feature {NODE, EDGE} -- Implementation

	is_unstable: BOOLEAN
			-- Is the iterator in the process of changing state?
			-- True when visiting a node or traversing an edge (during
			-- the changes.  (Lots of coupling going on here.)

feature {GRAPH_ITERATOR} -- Implementation

	visited_nodes: JJ_ARRAYED_SET [like node_anchor]
			-- The nodes that have been visited during this traversal.
		do
			create Result.make (Default_size)
			across explored_paths as c loop Result.extend (c.item.last_node) end
		end

	traversed_edges: JJ_ARRAYED_SET [like edge_anchor]
			-- The edges that have been traversed during this traversal.
		local
			p: like path_anchor
		do
			create Result.make (Default_size)
			from explored_paths.start
			until explored_paths.is_after
			loop
				p := explored_paths.item
				if p.edge_count > 0 then
					Result.extend (p.last_edge)
				end
				explored_paths.forth
			end
		end

	explored_paths: JJ_ARRAYED_LIST [like path_anchor]
			-- The paths that have been walked during this traversal in insertion order.

	pending_paths: JJ_SORTABLE_ARRAY [like path_anchor]
			-- List of paths to be evaluated next.

feature {NONE} -- Implementation

--	queue_index: INTEGER
--			-- Set by `Breadth_first' traversal features to index the item
--			-- in `paths' to return as the "first" item in a queue; this allows
--			-- `paths' to hold on to the other item (instead of removing for the
--			-- "queue") so that `breadth_first_back' can go to the previous path.

--	rebuild_visited_nodes
--			-- Called by `validate_paths' if it discovers a bad path.
--			-- This is used to prevent recalculating the visited nodes on each step
--			-- of an iteration.
--		local
--			p: like path_anchor
--			i: INTEGER
--		do
----			validate_paths
--			visited_nodes.wipe_out
--			from i := 1
--			until i > explored_paths.count
--			loop
--				p := explored_paths.i_th (i)
--				if not is_validate_mode or else (is_validate_mode and then not is_bad_path (p)) then
--						-- A visited node is the `last_node' of a path.
--					if p.first_node /= Void then
--							-- it is not the "After marker"
--						visited_nodes.extend (p.last_node)
--					end
--					i := i + 1
--				else
--						-- it was a path we should ignore
--					explored_paths.remove
--				end
--			end
--		end

--	rebuild_traversed_edges
--			-- Called by `validate_paths' if it discovers a bad path.
--			-- This is used to prevent recalculating this on each step
--			-- of an iteration.
--		local
--			e: like edge_anchor
--			p: like path_anchor
--			i: INTEGER
--		do
----			validate_paths
--			traversed_edges.wipe_out
--			from i := 1
--			until i > explored_paths.count
--			loop
--				p := explored_paths.i_th (i)
--				if not is_validate_mode or else (is_validate_mode and then not is_bad_path (p)) then
--						-- Traverse the path
--					from i := 1
--					until i > p.edge_count
--					loop
--						e := p.i_th_edge (i)
--						traversed_edges.extend (e)
--						i := i + 1
--					end
--					i := i + 1
--				else
--						-- it was a path we should ignore and clean out
--					explored_paths.remove
--				end
--			end
--		end


--	get_child (a_path: like path_anchor): detachable like path_anchor
--			-- Go to the next non-visited child node/edge of the last_node in `a_path'
--			-- Void if there is no more children.
--		require
--			path_exists: a_path /= Void
--		local
--			n: like node_anchor
--			next_n: like node_anchor
--			next_e: like edge_anchor
--			next_p: like path_anchor
--			i: INTEGER
--		do
--			next_p := a_path.twin
--			n := next_p.last_node
--			from i := 1
--			until Result /= Void or else i > n.count
--			loop
--				next_e := n.i_th_edge (i)
--				next_n := next_e.other_node (n)
--				next_p.extend (next_e)
--				if should_add_this (next_n, next_e, next_p) then
--					Result := next_p
--				else
--					next_p.remove
--					i := i + 1
--				end
--			end
--		end

--	get_leaf (a_path: like path_anchor): detachable like path_anchor
--			-- Go all the way down a non-traversed branch until hitting what would be
--			-- a leaf based on this traversal.  In other words, the last node of the
--			-- Result will be a node in which there are no more edges/nodes to go to.
--			-- This is not the same as node.is_leaf.
--			-- Void if there are no more explorable paths.
--		require
--			path_exists: a_path /= Void
--		local
--			n: like node_anchor
--			next_n: like node_anchor
--			next_e: like edge_anchor
--			next_p: like path_anchor
--			i: INTEGER
--			p_extended: BOOLEAN
--		do
--			next_p := a_path.twin
--			n := next_p.last_node
--			from i := 1
--			until i > n.count
--			loop
--				next_e := n.i_th_edge (i)
--				if not next_p.has (next_e) then		-- prevent cycles and duplicate check
--					next_p.extend (next_e)
--					next_n := next_p.last_node
--					if should_add_this (next_n, next_e, next_p) then
--						p_extended := True
--							-- visit leafs of the `next_n'
--						n := next_n
--						i := 1
--					else
--							-- reached node/edge/path to NOT visit/traverse/explore.
--						next_p.remove
--						i := i + 1
--					end
--				else
--					i := i + 1
--				end
--			end
--			if p_extended then
--				Result := next_p
--			end
--		end

--	get_parent (a_path: like path_anchor): detachable like path_anchor
--			--
--			-- Void if there is no parent  ??
--		require
--			path_exists: a_path /= Void
--		local
--			next_n: like node_anchor
--			next_e: like edge_anchor
--			next_p: like path_anchor
--		do
--			next_p := a_path.twin
--			if not next_p.is_empty then
--				next_p.remove
--				next_n := next_p.last_node
--				if next_p.is_empty then
--					check
--						at_root: next_n = root_node
--							-- Because an empty path must start at root.
--					end
--					if not visited_nodes.has (next_n) then
--						create Result.make (next_n)
--					end
--				else
--					next_e := next_p.last_edge
--					if should_add_this (next_n, next_e, next_p) then
--						Result := next_p
--					end
--				end
--			end
--		end

--	get_sibling (a_path: like path_anchor): detachable like path_anchor
--			-- Visit the next sibling of the last_node in `a_path'.
--			-- Similar to `get_child' except a sibling cannot already be in `a_path'.
--		require
--			path_exists: a_path /= Void
----			not_root_path: not a_path.is_empty
--		local
--			n: like node_anchor
--			next_n: like node_anchor
--			next_e: like edge_anchor
--			next_p: like path_anchor
--			i: INTEGER
--			e_checked: ARRAYED_SET [like edge_anchor]
--		do
--			if not a_path.is_empty then
--				next_p := a_path.twin
--				create e_checked.make (10)
--				e_checked.extend (next_p.last_edge)
--				next_p.remove
--				n := next_p.last_node
--				from i := 1
--				until Result /= Void or else i > n.count
--				loop
--					next_e := n.i_th_edge (i)
--					next_n := next_e.other_node (n)
--					next_p.extend (next_e)
--					if not a_path.has_node (next_n) and then should_add_this (next_n, next_e, next_p) then
--						Result := next_p
--					else
--						next_p.remove
--						i := i + 1
--					end
--				end
--			end
--		end

--	get_ancestor (a_path: like path_anchor): detachable like path_anchor
--			-- try to find an ancestor node that has not been visited
--		require
--			path_exists: a_path /= Void
--		local
--			next_p: like path_anchor
--			next_e: like edge_anchor
--			next_n: like node_anchor
--			n_checked: ARRAYED_SET [like node_anchor]
--		do
--			create n_checked.make (10)
--			next_p := a_path.twin
--			if not next_p.is_empty then
--					-- Since `n' is the current node, no need to check it.
--				next_n := next_p.last_node
--				n_checked.extend (next_n)
--				from next_p.remove
--				until Result /= Void or else next_p.is_empty
--				loop
--					next_n := next_p.last_node
--					next_e := next_p.last_edge
--					if should_add_this (next_n, next_e, next_p) then
--						Result := next_p
--					else
--						next_p.remove
--					end
--				end
--			end
--			if Result = Void and then next_p.is_empty  then
--				next_n := next_p.last_node
--				if not visited_nodes.has (next_n) then
--					create Result.make (next_n)
--				end
--			end
--		end

--	get_longest (a_path: like path_anchor): like path_anchor
--			-- Get the path to the node that is fartherest away from the `root_node'.
--		require
--			path_exists: a_path /= Void
--		local

--		do
--			create Result
--		end

--	traverse_edges_in_path (a_path: like path_anchor)
--			-- Add all the edges in `a_path' to the `traversed_edges' list.
--		require
--			path_exists: a_path /= Void
--		local
--			i: INTEGER
--			e: like edge_anchor
--		do
--			from i := 1
--			until i > a_path.edge_count
--			loop
--				e := a_path.i_th_edge (i)
--				traversed_edges.extend (e)
--				i := i + 1
--			end
--		end

--	visit_nodes_in_path (a_path: like path_anchor)
--			-- Add all the nodes in `_path' to the `visited_nodes' list.
--		require
--			path_exists: a_path /= Void
--		local
--			i: INTEGER
--			n: like node_anchor
--		do
--			from i := 1
--			until i > a_path.node_count
--			loop
--				n := a_path.i_th_node (i)
--				visited_nodes.extend (n)
--				i := i + 1
--			end
--		end

	in_order_start, leaf_first_start
			-- Move the the first node "in-order".
			--           6
			--          /|\
			--		   4 7 11
			--		  /|   |\
			--       2 5   9 12
			--      /|     |\
			--     1 3     8 10
		require
			root_exists: root_node /= Void
			has_valid_root: is_valid_root_node (root_node)
		local
			root_p: detachable like path_anchor
			next_p: detachable like path_anchor
		do
--			create root_p.make (root_node)
--			next_p := get_leaf (root_p)
--			if next_p = Void then
--				explored_paths.extend (root_p)
--			else
--				explored_paths.extend (next_p)
--				traverse_edges_in_path (next_p)
--				visited_nodes.extend (next_p.last_node)
--			end
		ensure
			not_before: not is_before
			not_after: not is_after
		end


	bottom_up_start
			-- Move to the first node in `Bottom_up' order.
			--           12
			--          /| \
			--		   9 10 11
			--		  /|    |\
			--       5 6    7 8
			--      /|      |\
			--     1 2      3 4
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			p: like path_anchor
			next_p: like path_anchor
		do
--				-- Because the [first of] the longest path[s] is the start path,
--				-- the entire graph must be traversed in order to find it.  So,
--				-- might as well record this and just use a cursor to move in
--				-- the paths.  NO, must be rebuilt every access because the
--				-- graph might have changed.
--			create p.make (root_node)
--			next_p := get_longest (p)
--			if next_p /= Void then
--				explored_paths.extend (next_p)
--				traverse_edges_in_path (next_p)
--				visited_nodes.extend (next_p.last_node)
--			else
--				explored_paths.extend (p)
--			end
		ensure
			not_before: not is_before
		end

	shortest_first_start
			-- Move to the first node when traversing shortest paths first.
			-- This will be the `root_node'.
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			e: like edge_anchor
			p: like path_anchor
			i: INTEGER
		do
--			pending_paths.set_ordered
--			create p.make (root_node)
--			explored_paths.extend (p)
--			traverse_edges_in_path (p)
--			visited_nodes.extend (p.last_node)
--			from i := 1
--			until i > root_node.count
--			loop
--				e := root_node.i_th_edge (i)
--				create p.make (root_node)
--				p.extend (e)
--				pending_paths.extend (p)
--				i := i + 1
--			end
		ensure
			at_root_node: node = root_node
			not_before: not is_before
		end

	leaves_only_start
			-- Move to first node in "leaves_only" traversal order
			--           6
			--          /|\
			--		   4 7 11
			--		  /|   |\
			--       2 5   9 12
			--      /|     |\
			--     1 3     8 10
		require
			root_exists: root_node /= Void
			has_valid_root: is_valid_root_node (root_node)
		local
			root_p: detachable like path_anchor
			next_p: detachable like path_anchor
		do
--			create root_p.make (root_node)
--			next_p := get_leaf (root_p)
--			if next_p = Void then
--				explored_paths.extend (root_p)
--			else
--				explored_paths.extend (next_p)
--				traverse_edges_in_path (next_p)
--				visit_nodes_in_path (next_p)
--			end
		ensure
			not_before: not is_before
			not_after: not is_after
		end

	in_order_forth
			-- Move to next node "in-order".
			--           6
			--          /|\
			--		   4 7 11
			--		  /|   |\
			--       2 5   9 12
			--      /|     |\
			--     1 3     8 10
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
			not_after: not is_after
		local
			p: detachable like path_anchor
			next_p: detachable like path_anchor
		do
--			if is_before then
--				in_order_start
--			else
--				p := path
--				next_p := get_leaf (p)
--				if next_p = Void then
--					next_p := get_parent (p)
--					if next_p = Void then
--						next_p := get_sibling (p)
--						if next_p = Void then
--							next_p := get_ancestor (p)
--						else
--							next_p := get_leaf (next_p)
--						end
--					end
--				end
--				if next_p = Void then
--						-- Add an empty path "after marker".
--					create next_p
--					explored_paths.extend (next_p)
--				else
--					explored_paths.extend (next_p)
--					traverse_edges_in_path (next_p)
--					visited_nodes.extend (next_p.last_node)
--				end
--			end
		ensure
			not_before: not is_before
		end

	old_breadth_first_back
			-- Move back to previouse node in `breadth_first' order.
			--           1
			--          /|\
			--		   2 3 4
			--		  /|   |\
			--       5 6   7 8
			--      /|     |\
			--     9 10   11 12
		require
			not_before: not is_before
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		do
--				-- Remove the last path and decrement the `queue_index'
--			explored_paths.go_i_th (explored_paths.count)
--			explored_paths.remove
--			queue_index := queue_index - 1
		ensure
			not_after: not is_after
		end

	bottom_up_forth
			-- Move to the next node/path/edge in `Bottom_up' order.
			--           12
			--          /| \
			--		   9 10 11
			--		  /|    |\
			--       5 6    7 8
			--      /|      |\
			--     1 2      3 4
		require
			not_after: not is_after
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			root_p: like path_anchor
			next_p: like path_anchor
		do
--			if is_before then
--				bottom_up_start
--			else
--				create root_p.make (root_node)
--				next_p := get_longest (root_p)
--				if next_p = Void then
--						-- Add an empty path "after marker".
--					create next_p
--					explored_paths.extend (next_p)
--				elseif next_p.is_empty then
--						-- at root
--					explored_paths.extend (next_p)
--					traverse_edges_in_path (next_p)
--					visited_nodes.extend (next_p.last_node)
--				else
--					explored_paths.extend (next_p)
--					traverse_edges_in_path (next_p)
--					visited_nodes.extend (next_p.last_node)
--				end
--			end
		ensure
			not_before: not is_before
		end

	leaf_first_forth
			-- Move to the next node/path/edge in `Leaf_first' order.
			--           12
			--          /| \
			--		   9 4 11
			--		  /|    |\
			--       8 3    10 7
			--      /|      |\
			--     1 2      5 6
		require
			not_after: not is_after
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			p: detachable like path_anchor
			next_p: detachable like path_anchor
		do
--			if is_before then
--				leaf_first_start
--			else
--					-- get the next leaf from the parent
--				p := get_parent (explored_paths.last)
--				if p /= Void then
--					next_p := get_leaf (p)
--					if next_p = Void then
--							-- there are no more branches from root, so set
--							-- `next_p' to the root path for adding below
--						next_p := p
--					end
--				end
--				if next_p = Void then
--						-- Add an empty path "after marker".
--					create next_p
--					explored_paths.extend (next_p)
--				else
--					explored_paths.extend (next_p)
--					traverse_edges_in_path (next_p)
--					visited_nodes.extend (next_p.last_node)
--				end
--			end
		ensure
			not_before: not is_before
		end

	leaves_only_forth
			-- Move to the next node/path/edge in `leaves_first' order.
			-- This visits leaf nodes (relative to traversal) only
		require
			not_after: not is_after
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
--			is_at_leaf: explored_paths.last.last_node.is_leaf
-- Node does not know if it is a leaf FIX ME!
		local
			p: detachable like path_anchor
			next_p: detachable like path_anchor
		do
--			from post_order_forth
--			until is_after or else path.last_node.is_leaf
--			loop
--				post_order_forth
--			end
			check
				fix_me: False then
			end
		end

	shortest_first_forth
			-- Move to the next node by traversing the next shortest path.
			-- This implements Dijksta's algorithm by ...
		require
			not_after: not is_after
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			p: like path_anchor
			next_p: like path_anchor
			n: like node_anchor
			e: like edge_anchor
			i: INTEGER
			done: BOOLEAN
		do
--			if is_before then
--				shortest_first_start
--			elseif pending_paths.is_empty then
--					-- Add an after marker
--				create p
--				explored_paths.extend (p)
--			else
--					-- Find the path already in `pending_paths' which has the lowest `cost';
--					-- this will be the first one since `pending_paths' is sorted.
--				from pending_paths.start
--				until done or else pending_paths.is_after
--				loop
--					p := pending_paths.item
--					if not is_bad_path (p) and then should_add_this (p.last_node, p.last_edge, p) then
--						explored_paths.extend (p)
--						traverse_edges_in_path (p)
--						visited_nodes.extend (p.last_node)
--						n := p.last_node
--						from i := 1
--						until i > n.count
--						loop
--							e := n.i_th_edge (i)
--							next_p := p.twin
--							next_p.extend (e)
--							pending_paths.extend (next_p)
--							i := i + 1
--						end
--						done := True
--					else
--						pending_paths.remove
--					end
--				end
--			end
		end


	graph_imp: detachable like graph
			-- Allows `default_create' to leave the `graph' unassigned


	root_node_imp: detachable like node_anchor
			-- Allows `default_create' to leave `root_node' unassigned

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: GRAPH
			-- Anchor for graph types.
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
			-- Anchor for features using edges.
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

feature {NONE} -- Invariant checking

	is_bad_path (a_path: like path_anchor): BOOLEAN
			-- Is `a_path' not legitimate for the state of current?
			-- Is each edge connected and is each node in `graph' if
			-- not `is_inspecting_reachables'.
		local
			n: like node_anchor
			e: like edge_anchor
			i: INTEGER
			b: BOOLEAN
		do
			if a_path = Void then
				Result := True
			else
				b := {ISE_RUNTIME}.check_assert (False)
				if not is_seeing_reachables then
					n := a_path.first_node
					if not graph.has_node (n) then
						Result := True
					end
				end
				from i := 1
				until Result or else i > a_path.edge_count
				loop
					e := a_path.i_th_edge (i)
					if e.is_disconnected or else
						(not is_seeing_reachables and then not graph.has_edge (e)) then
						Result := True
					else
						i := i + 1
					end
				end
				b := {ISE_RUNTIME}.check_assert (b)
			end
		end

	has_void_path: BOOLEAN
			-- Does the `explored_paths' contain a Void path?
			-- Added to trap an error that was occuring during development.
		do
			from explored_paths.start
			until Result or else explored_paths.is_after
			loop
				Result := explored_paths.item = Void
				explored_paths.forth
			end
		end

invariant

	no_graph_implication: not has_graph implies is_seeing_reachables
	seeing_visibles_implication: not is_seeing_reachables implies has_graph

	is_valid_root_node: has_root_node implies (not is_seeing_reachables implies graph.has_node (root_node))

	traversal_method_large_enough: traversal_method >= Alpha_beta
	traversal_method_small_enough: traversal_method <= last_traversal_method

	explored_paths_exists: explored_paths /= Void
	pending_paths_exists: pending_paths /= Void

	at_least_one_visitation_policy_selected: is_visiting_nodes or else
												 is_traversing_edges or else
												 is_exploring_paths


	not_before_and_after: not (is_before and is_after)

	no_void_paths: not has_void_path

	visited_nodes_integrity: across visited_nodes as c all c.item.was_visited_by (Current) end
	traversed_edges_integrity: across traversed_edges as c all c.item.was_traversed_by (Current) end

end
