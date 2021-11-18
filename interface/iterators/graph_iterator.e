note
	description: "[
		Iterator for traversing a GRAPH.

		A GRAPH_ITERATOR is used to traverse a {GRAPH} by moving along edges
		from one node to another using a particular traversal method (e.g.
		breadth-first, depth-first, pre-order, etc) by starting at a `root_node'.

		Traversal policies determine how traversals treat nodes, edges, or paths.
		For example, when `is_visiting_nodes' the iterator will pass through a
		node only once, but when `is_traversing_edges' or `is_exploring_paths' a
		node may be visited several times.

		Edges and nodes connected using the features from {EDGE} or {NODE}
		instead of connection features from {GRAPH} are not "visible" to the
		graph and will not normally be traversed or visited.  This allows one
		graph to contain the same nodes as another graph, but the traversals
		can produce different results.  This normal mode of ignoring non-visible
		nodes or edges is overridden by feature `inspect_reachables', making all
		reachable nodes visible to the iterator whether or not they are in the
		graph.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	GRAPH_ITERATOR

inherit

	SHARED
		undefine
			default_create,
			is_equal,
			copy
		end

	TRAVERSAL_POLICIES
		redefine
			default_create
		end

	HASHABLE
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
			hash_code := uuid_generator.generate_uuid.hash_code
			create frontier
--				-- `frontier' holds {PATH} objects which are twinned before
--				-- placement into a container, hense object comparison.
--			frontier.compare_objects
			create pending_paths.make (Default_size)
			create visited_graphs.make (Default_size)
			create visited_nodes.make (Default_size)
			create traversed_edges.make (Default_size)
			create explored_paths.make (Default_size)
			explored_paths.compare_objects
			see_reachables
			inspect_relations
			visit_nodes
			set_breadth_first
			go_before
		ensure then
			will_visit_nodes: is_visiting_nodes
			will_visit_reachable_nodes: is_seeing_reachables
			will_visit_ALL_reachable_nodes: is_inspecting_relations
			will_visit_breadth_first: is_breadth_first
			is_before: is_before
			not_after: not is_after
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
			set_graph (a_graph)
			see_visibles
			if not a_graph.is_empty then
				set_root_node (a_graph.nodes_imp [1])
			end
		ensure
			will_visit_nodes: is_visiting_nodes
			will_visit_visible_nodes: not is_seeing_reachables
			will_visit_ALL_visible_nodes: is_inspecting_relations
			will_visit_breadth_first: is_breadth_first
			is_before: root_node_imp /= Void implies is_before
			graph_was_set: graph = a_graph
			is_before: is_before
			not_after: not is_after
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code from a {RANDOM} value in `default_create'.

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
			not_off: not is_off
			not_at_root: not is_at_root or is_shortest_first
		do
			Result := path.last_edge
		end

	path: like path_anchor
			-- Path walked to get to current `node'.
		require
			not_off: not is_off
		do
-- Fix me
-- Make this not use explored_paths; instead keep only one path
-- If an invalid path is encountered go up toward root until
-- finding a valid path.
-- What happens if we go off?  Can't return Void.
--
-- How about as precondition `has_valid_path' checking a detachable
-- `path_imp' attribute?
--
-- This should be the only place where we need to check `is_valid_path'.
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
				initialize_traversal
-- fix me:  Do I really want to discard the traversal just because the graph changed?
			end
			graph_imp := a_graph
				-- Let the `graph' know to track Current in its `iterators'
			graph.extend_iterator (Current)
			visited_graphs.extend (graph, graph.hash_code)
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

	is_validating_paths: BOOLEAN
			-- Should Current check paths for validity (e.g. an {EDGE}
			-- that `is_disconnected'.) A path could become invalid
			-- if a graph removes an edge while a traversal is mid-
			-- graph.

	is_dirty: BOOLEAN
			-- Has Current been notified that a graph being traversed
			-- has changed since the current iteration cycle started?

feature -- Status setting

	set_dirty
			-- Make `is_dirty' true, meaning any past traversal steps
			-- may now be invalid for some reason (e.g. a graph changed)
		do
			is_dirty := true
		end

	set_clean
			-- Make `is_dirty' false
			-- Called in `start'
		do
			is_dirty := false
		end

	validate_paths
			-- Make Current check each path as it is accessed
			-- to insure there are no disconnnected edges.
			-- See `is_validating_paths'
		do
			is_validating_paths := true
		ensure
			is_validating_paths: is_validating_paths
		end

	accept_paths
			-- Make Current not check a path when accessed,
			-- assuming the path is valid.
			-- See `is_validating_paths'
		do
			is_validating_paths := false
		ensure
			not_validating_paths: not is_validating_paths
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
--			validate_paths
			Result := visited_nodes.has (a_node)
		ensure
			implication: Result implies visited_nodes.has (a_node)
		end

	was_edge_traversed (a_edge: like edge_anchor): BOOLEAN
			-- Has `a_edge' been traversed during this traversal?
		do
--			validate_paths
			Result := traversed_edges.has (a_edge)
		end

	was_path_explored (a_path: like path_anchor): BOOLEAN
			-- Has a path equivelant to `a_path' been explored during current traversal?
		do
--			validate_paths
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
				-- Traverse until finding `a_node'
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

	shortest_path (a_node: like node_anchor;
				a_heuristic: FUNCTION [TUPLE [like node_anchor, like node_anchor],
									 like path_anchor.cost]): like path_anchor
			-- The shortest path, if any, from the `root_node' to `a_node',
			-- using `a_hueristic' in an A* search.  If there is no path
			-- between the nodes, the resulting path will be `is_empty'.
		local
			q: HASHED_PRIORITY_QUEUE [PATH_COST_PAIR, like node_anchor]
			last_p, p: like path_anchor
			n, root_n, last_n: like node_anchor
			e: like edge_anchor
			last_e: detachable like edge_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			i: INTEGER
			est: like path_anchor.cost
			n_set: HASH_TABLE [like node_anchor, like node_anchor]
		do
			create q
			create n_set.make (100)
			last_p := root_path
			if not last_p.is_empty then
					-- Add root node (with zero cost) to frontier set `q'.
					-- Continue getting shortest projected path from `q' until
					-- finding `a_node' or there are no more paths.
					-- Use only some of the traversal policies (such as
					-- `is_seeing_reachable', `inspecting_children', etc.)
					-- because some (such as `is_exploring_paths') do not make
					-- sense in this context.
				root_n := last_p.last_node
				from last_n := last_p.last_node
				until last_n = a_node or else q.is_empty
				loop
						-- Add child edges to the `q'
					if last_p.edge_count > 0 then
						last_e := last_p.last_edge
					end
					e_set := traversal_set (last_n)
					from i := 1
					until i > e_set.count
					loop
						e := e_set.i_th (i)
						if e /= last_e then
							n := e.other_node (last_n)
							if not n_set.has (n) then
								p := last_p.twin
								last_p.extend (e)
									-- Why do I need all these attachment checks?
									-- Why does it not compile without them?
								if attached a_heuristic as h then
									check attached {like path_anchor.cost} a_heuristic.item ([n, a_node]) as otl_est then
										est := otl_est
									end
								else
									est := p.cost.zero
								end
								q.extend ([p, p.cost + est], n)
							end
								-- Get the minimum path from `q'
							check attached {like path_anchor} q.item.path as otl_p then
								last_p := otl_p
							end
							last_n := last_p.last_node
							n_set.extend (last_n, last_n)
						end
						i := i + 1
					end
				end
			end
			if last_p.last_node = a_node then
				Result := last_p
			else
				create Result	-- an empty path
			end
		end

--	shortest_paths (a_node, a_other: like node_anchor; a_number: INTEGER): JJ_SORTABLE_ARRAY [like path_anchor]
--			-- List of up to `a_number' of paths from `a_node' to `a_other'
--			-- sorted from shortest path to longer ones.
--		require
----			seeing_reachables_implication: is_seeing_reachables or else has_graph
----			not_seeing_reachables_implies_graph_has_root: not is_seeing_reachables implies graph.has_node (root_node)
----			not_seeing_reachables_implies_graph_has_node: not is_seeing_reachables implies graph.has_node (a_node)
--		local
--			p, new_p: like path_anchor
--			heap: JJ_SORTABLE_ARRAY [like path_anchor]		-- Serves as a minimum priority heap
--			n_tab: HASH_TABLE [INTEGER, like node_anchor]	-- Number of paths to the indexed node
--			c: INTEGER
--			n: like node_anchor
--			e: like edge_anchor
--			i: INTEGER
--		do
--			create Result.make (100)
--			create heap.make (100)
--			create n_tab.make (100)
--			create p.make (a_node)
--			heap.set_ordered
--			from
--				heap.extend (p)
--				n_tab.force (0, p.last_node)
--			until heap.is_empty or (attached n_tab.item (a_other) as oc and then oc >= a_number)
--			loop
--					-- Get & remove the smallest item from the `heap'
--				heap.go_i_th (1)
--				p := heap.item
--				heap.remove
--					-- Update the count for number of paths to `p's `last_node'
--				n := p.last_node
--				if attached n_tab.item (n) as otl_c then
--					c := otl_c + 1
--				else
--					c := 1
--				end
--				n_tab.force (c, n)
--					-- If destination node reached, add that path to Result
--				if n = a_other then
--					Result.extend (p)
--				end
--					-- Continue to adjacent nodes
--				if c <= a_number then
--					from i := 1
--					until i > n.out_count
--					loop
--							-- Make new paths by extending `p' with each edge in turn
--						e := n.i_th_child_edge (i)
--						new_p := p.subpath (1, p.node_count)
--						new_p.extend (e)
--						if not p.is_edge_cylcic and not heap.has (p)then
--							heap.extend (new_p)
--						end
--						i := i + 1
--					end
--				end
--			end
--		ensure
----			start_node_correct: Result.for_all (agent (a_node, a_test): BOOLEAN do end (?, a_node))
----			start_node_correct: (Result.for_all (agent {JJ_SORTABLE_ARRAY [like path_anchor]}.first = a_node))
----											 (test: FUNCTION [ANY, TUPLE [G], BOOLEAN]) = root_node
----			last_node_correct: Result.last_node = a_node
----			start_node_correct: across Result as l_node all l_node = a_node end
----			last_node_correct: across Result as l_node all l_node = a_other end
--		end

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
				e_set := graph.edges_imp
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
			initialize_traversal
			inspect traversal_method
			when Shortest_first then
				shortest_first_start
			when Breadth_first then
				breadth_first_start
			when Pre_order, Depth_first then
				pre_order_start
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
			else
				check
					should_not_happen: false
						-- because the above are all the traversal methods
				end
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
--			validate_paths
			explored_paths.finish
			p := explored_paths.item
			explored_paths.remove
		ensure
			not_after: not is_after
		end

feature -- Cursor movement

	shortest_first_start
			-- Move to the first node when traversing shortest paths first.
		require
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			p: like path_anchor
		do
			initialize_traversal
			go_before
			p := root_path
			if p.is_empty then
				go_after
			else
				explore_path (p)
				go_on
				prioritize_children (p)
			end
		ensure
			not_before: not is_before
		end

	breadth_first_start
			-- Move to the first `node' in breadth-first order.
			-- This `node' will be the `root_node' if it exists, and it
			-- is in `graph'.  The `node' will also be the `root_node'
			-- it exists and `is_seeing_reachables'.  If not `has_root_node'
			-- the the `node' will the the first node in the `graph' if
			-- the `graph' is not empty.
			-- Otherwise `is_after'.
		local
			new_p: like path_anchor
		do
			initialize_traversal
			go_before
			new_p := root_path
			if new_p.is_empty then
				go_after
			else
					-- Explore the path and queue children
				explore_path (new_p)
				go_on
				stack_children (new_p, false)		-- no queue children
			end
		ensure
			is_empty_implies_after: graph.is_empty implies is_after
			no_root_implication: not graph.is_empty and not has_root_node implies node = graph.nodes_imp.i_th (1)
			has_root_implication: not graph.is_empty and has_root_node and then
									(is_seeing_reachables or else graph.has_node (root_node)) implies is_at_root
		end

	depth_first_start, pre_order_start
			-- Move to the first node depth-first order (i.e. parent
			-- first, then children).  Same as pre-order.
			--           1
			--          /|\
			--		   2 7 8
			--		  /|   |\
			--       3 6   9 12
			--      /|     |\
			--     4 5    10 11
		local
			new_p: like path_anchor
		do
			initialize_traversal
			go_before
			new_p := root_path
			if new_p.is_empty then
				go_after
			else
					-- Explore the path and queue children
				explore_path (new_p)
				go_on
				stack_children (new_p, true)
			end
		ensure
			is_empty_implies_after: graph.is_empty implies is_after
			no_root_implication: not graph.is_empty and not has_root_node implies node = graph.nodes_imp.i_th (1)
			has_root_implication: not graph.is_empty and has_root_node and then
									(is_seeing_reachables or else graph.has_node (root_node)) implies is_at_root
--			not_empty_implication: (not is_empty) implies node = root_node
		end

	post_order_start, in_order_start
			-- Move the the first node -- post-order (children
			-- first, then parent)
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
			new_p: like path_anchor
		do
			initialize_traversal
			go_before
--			new_p := next_leaf_path
			new_p := root_path
			if new_p.is_empty then
				go_after
			else
				new_p := go_down (new_p, 1)
				if attached new_p as p2 then
					explore_path (p2)
					go_on
				else
					go_after
				end
			end
		ensure
			not_before: not is_before
		end

feature -- Cursor movement

	shortest_first_forth
			-- Move to the next node by traversing the next shortest path.
			-- This implements Dijksta's algorithm by ...
			-- Does not work if any costs are negative.
		require
			not_after: not is_after
			root_exists: has_root_node
			has_valid_root: is_valid_root_node (root_node)
		local
			p: like path_anchor
		do
			if frontier.is_empty then
				go_after
			else
				p := frontier.item
				frontier.remove
				explore_path (p)
				prioritize_children (p)
			end
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
		local
			next_p: like path_anchor
		do
			if is_before then
				start
			elseif pending_paths.is_empty then
				is_after := True
			else
				check
					not_off: not is_off
						-- because not `is_before' and a path is pending
				end
				next_p := next_path
				if attached next_p as p then
					explore_path (p)
					stack_children (p, false) -- no queue children
				else
					is_after := true
				end
			end
		ensure
			not_before: not is_before
		end

	depth_first_forth, pre_order_forth
			-- Move to the next node in depth-first order (i.e. parent
			-- first, then children).  Same as pre-order.
			--           1
			--          /|\
			--		   2 7 8
			--		  /|   |\
			--       3 6   9 12
			--      /|     |\
			--     4 5    10 11
		local
			next_p: detachable like path_anchor
		do
			if is_before then
				start
			elseif pending_paths.is_empty then
				is_after := True
			else
				check
					not_off: not is_off
						-- because not `is_before' and a path is pending
				end
				next_p := next_path
				if attached next_p as p then
					explore_path (p)
					stack_children (p, true)
				else
					is_after := true
				end
			end
		ensure
			not_before: not is_before
		end

	post_order_forth
			-- Move to the next node in post-order (i.e. children
			-- first, then parent)
			--           12
			--          /|\
			--		   5 6 11
			--		  /|   |\
			--       3 4   9 10
			--      /|     |\
			--     1 2     7 8
		require
			not_after: not is_after
		local
			next_p: like path_anchor
			n: like node_anchor
			e: like edge_anchor
			e_set:JJ_SORTABLE_SET [like edge_anchor]
			tup: TUPLE [position: INTEGER; was_found: BOOLEAN]
			i: INTEGER
		do
			if is_before then
--				post_order_start
				start
			else
				next_p := path
				next_p := go_down (next_p, 1)
				if attached next_p as p then
					explore_path (p)
					go_on
				else
					next_p := path
					if next_p.edge_count >= 1 then
						e := next_p.last_edge
						n := next_p.last_node
						e_set := traversal_set (n)
						tup := e_set.seek_position (e)
						i := tup.position + 1
					else
						i := 2
					end
					next_p := go_up_down (next_p, i)
					if attached next_p as p2 then
						explore_path (p2)
						go_on
					else
						go_after
					end
				end
			end
		ensure
			not_before: not is_before
		end

	in_order_forth
			-- Move to next node "in-order".  Visit left n/2 children,
			-- then the parent, the the right n/2 children.
			--           6
			--          /|\
			--		   4 7 11
			--		  /|   |\
			--       2 5   9 12
			--      /|     |\
			--     1 3     8 10
		require
			not_after: not is_after
		local
			n: like node_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			cur_p, p2: like path_anchor
			p3: like path_anchor
			found_p: like path_anchor
		do
			if is_before then
--				in_order_start
				start
			else
				cur_p := path
				if attached cur_p as p then
					if p.edge_count = 0 then
						if was_node_visited (p.last_node) then
								-- Attempt down on right children
							e_set := traversal_set (p.last_node)
							p2 := go_down (p, e_set.count // 2 + 1)
							if attached p2 then
								found_p := p2
							else
								go_after
							end
						else
							found_p := p
						end
					else
							-- attempt right sibling on left half of edges
						n := p.last_node
						e_set := traversal_set (n)
						p2 := go_right (p, e_set.count // 2)
						if attached p2 then
							found_p := p2
						else
								-- Attempt go up to parent node
							p2 := go_up (p)
							if attached p2 as p4 then
								if not was_node_visited (p4.last_node) then
									found_p := p4
								end
							else
									-- Attempt down on right edges
								p2 := go_down (p, e_set.count // 2 + 1)
								if attached p2 then
									found_p := p2
								else
										-- Attempt up then down on right half of edges
									p2 := go_up_down (p, e_set.count // 2 + 1)
									if attached p2 then
										found_p := p2
									else
											-- Go up to parent's parent then down left
										from p2 := go_up (p)
										until found_p /= Void or else p2 = Void
										loop
											if attached p2 then
												p3 := go_up_down (p2, 1)
												if attached p3 then
													found_p := p3
												else
													p2 := go_up (p2)
												end
											end
										end
									end
								end
		 					end
						end
					end
				end
				if attached found_p then
					explore_path (found_p)
					go_on
				else
					go_after
				end
			end

--			explore_path....

		ensure
			not_before: not is_before
		end

feature {NONE} -- Cursor movement (helper routines)

	is_cyclic (a_path: like path_anchor): BOOLEAN
			-- Is the path cyclic relative to the traversal policy?
		require
			path_exists: a_path /= Void
		do
			Result := (is_visiting_nodes and then a_path.is_node_cyclic) or else
						(is_traversing_edges and then a_path.is_edge_cylcic) or else
						(is_exploring_paths and then a_path.is_path_cyclic)
		end

	should_add_this (a_node: like node_anchor; a_edge: like edge_anchor; a_path: like path_anchor): BOOLEAN
			-- Used by traversal routines to determine if `a_path' should be added to the
			-- list of explored paths.  It checks the statuses of `is_exploring_paths',
			-- `is_traversing_edges' and `is_visiting_nodes' to make sure this path/node/edge
			-- has not already been traversed/visited.
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

	initialize_traversal
			-- Clean out all structures in preparation for new traversal
		do
			is_unstable := True
			across traversed_edges as c loop c.item.untraverse_by (Current) end
			across visited_nodes as c loop c.item.unvisit_by (Current) end
			is_unstable := False
			pending_paths.wipe_out
			explored_paths.wipe_out
			traversed_edges.wipe_out
			visited_nodes.wipe_out
		ensure then
			none_visited: visited_nodes.is_empty
			none_traversed: traversed_edges.is_empty
			no_paths: explored_paths.is_empty
			none_pending: pending_paths.is_empty
		end

	root_path: like path_anchor
			-- Find the path that starts at the proper root node or
			-- `go_after' if there is no valid node, returning an
			-- empty path
		do
			create Result
			if has_graph then
				if has_root_node then
					if is_seeing_reachables or else graph.has_node (root_node) then
						Result.set_first_node (root_node)
					end
				else
					if not graph.is_empty then
						Result.set_first_node (graph.nodes_imp.i_th (1))
					end
				end
			else		-- not has_graph
				if has_root_node and then is_seeing_reachables then
					Result.set_first_node (root_node)
				end
			end
		ensure
-- fix me
		end

	next_path: detachable like path_anchor
			-- Find the next path from `pending_paths' to explore
			-- if any.
		local
			p: like path_anchor
			e: like edge_anchor
			n: like node_anchor
			found: BOOLEAN
		do
-- fix me to remove need for `pending_paths' and add support for
-- checking if graph is dirty.
			from pending_paths.start
			until found or else pending_paths.is_empty
			loop
				p := pending_paths.item
				pending_paths.remove
				check
					not_at_root: p.edge_count > 0
						-- because cannot have started `is_before'
				end
				n := p.last_node
				e := p.last_edge
				if not is_cyclic (p) and then should_add_this (n, e, p) then
					found := true
				end
			end
			if found then
				Result := p
			end
		end

	go_before
			-- Ensure `is_before'
		do
			is_before := true
			is_after := false
		ensure
			is_before: is_before
			not_after: not is_after
		end

	go_after
			-- Ensure `is_before'
		do
			is_before := false
			is_after := true
		ensure
			not_before: not is_before
			is_after: is_after
		end

	go_on
			-- Ensure not `is_before' and not `is_after'
		require
			path_exists: not explored_paths.is_empty
		do
			is_before := false
			is_after := false
		ensure
			not_before: not is_before
			not_after: not is_after
		end

	go_up (a_path: like path_anchor): detachable like path_anchor
			-- The path created by removing the last edge from `a_path'
			-- or Void if there are no edges in `a_path'
		do
			if a_path.edge_count >= 1 then
				Result := a_path.twin
				Result.remove
			end
		end

	go_down (a_path: like path_anchor; a_index: INTEGER): detachable like path_anchor
			-- Attempt to extend `a_path' with an edge starting at `a_index'
			-- then continue down, ignoring the incoming edge, to a leaf node
			-- (i.e. a node with no more edges or nodes that have not be
			-- visited or traversed), or Void if there are no children
		local
			i: INTEGER
			n, prev_n: like node_anchor
			e: like edge_anchor
			incoming_e: detachable like edge_anchor
			p: like path_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
		do
			p := a_path.twin
			n := p.last_node
			e_set := traversal_set (n)
			from i := a_index
			until i > e_set.count
			loop
				prev_n := n
				e := e_set.i_th (i)
				n := e.other_node (n)
--				p := a_path.twin
				if p.edge_count >= 1 then
					incoming_e := p.last_edge
				else
					incoming_e := Void
				end
				if e = incoming_e then
						-- ignore this edge coming from the parent
					n := prev_n
					i := i + 1
				else
					p.extend (e)
					if not is_cyclic (p) and then should_add_this (n, e, p) then
	--				if should_add_this (n, e, p) then
						Result := p
	--					p := p.twin
						n := p.last_node
						e_set := traversal_set (n)
						i := 1
					else
						p.remove
						n := prev_n
						i := i + 1
					end
				end
			end
		end

	go_up_down (a_path: like path_anchor; a_index: INTEGER): detachable like path_anchor
			-- Go up parent edge and attempt to come back down to another
			-- child node.
		local
			p, p3: detachable like path_anchor
			n: like node_anchor
		do
			from p := a_path.twin
			until attached Result or else p = Void
			loop
				p := go_up (a_path)
				if attached p as p2 then
					p3 := go_down (p2, a_index)
					if attached p3 as p4 then
						Result := p4
					else
						Result := p2
					end
				end
			end
			if attached Result and then Result.edge_count = 0 then
					-- We've gone all the way up to the root
				n := Result.last_node
				if was_node_visited (n) then
					Result := Void
				end
			end
		end

	go_right (a_path: like path_anchor; a_index: INTEGER): detachable like path_anchor
			-- Attempt to find a sibling to the right of the last node
			-- but don't look beyond the edge at `a_index'.
			-- Void if not found.
		require
			not_off: not is_off
		local
			p: like path_anchor
			e, incoming_e: like edge_anchor
			n, parent_n: like node_anchor
			e_set:JJ_SORTABLE_SET [like edge_anchor]
			tup: TUPLE [position: INTEGER; was_found: BOOLEAN]
			i: INTEGER
			found: BOOLEAN
		do
			p := a_path.twin
			if p.edge_count >= 1 then
				e := p.last_edge
				p.remove
				parent_n := p.last_node
				e_set := traversal_set (parent_n)
				if p.edge_count >= 1 then
					incoming_e := p.last_edge
				end
				tup := e_set.seek_position (e)
				from i := tup.position
				until found or i > e_set.count or i > a_index
				loop
					e := e_set.i_th (i)
					if e = incoming_e then
						i := i + 1
					else
						n := e.other_node (parent_n)
						p.extend (e)
						if not is_cyclic (p) and then should_add_this (n, e, p) then
							Result := p
						else
							p.remove
						end
					end
					i := i + 1
				end
			end
		end

	stack_children (a_path: like path_anchor; is_stacking: BOOLEAN)
			-- Stack or queue into `pending_paths (depending on is_stacking')
			-- the children of the `last_node' of `a_path'
		local
			p: like path_anchor
			n, last_n: like node_anchor
			e: like edge_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			i: INTEGER
		do
			last_n := a_path.last_node
			e_set := traversal_set (last_n)
			from i := 1
			until i > e_set.count
			loop
				e := e_set.i_th (i)
				n := e.other_node (last_n)
				p := a_path.twin
				p.extend (e)
				if not is_cyclic (p) and then should_add_this (n, e, p) then
						-- `pending_paths' is an array
					if is_stacking then
						pending_paths.start		-- move this line out of loop?
						pending_paths.put_left (p)
					else
						pending_paths.extend (p)
					end
				end
				i := i + 1
			end
		end

	prioritize_children (a_path: like path_anchor)
			-- Add the children of the last node of path to the queue
		local
			last_n: like node_anchor
			last_e: detachable like edge
			n: like node_anchor
			e: like edge_anchor
			p: like path_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			i: INTEGER
		do
			last_n := a_path.last_node
			if a_path.edge_count > 0 then
				last_e := a_path.last_edge
			end
			e_set := traversal_set (last_n)
			from i :=1
			until i > e_set.count
			loop
				e := e_set.i_th (i)
				if e /= last_e then	-- Ignores incoming edge
					n := e.other_node (last_n)
					p := a_path.twin
					p.extend (e)
					if not is_cyclic (p) and then should_add_this (n, e, p) then
						frontier.extend (p, n)
					end
				end
				i := i + 1
			end
		end

feature {NODE, EDGE, WALK} -- Implementation

	is_unstable: BOOLEAN
			-- Is the iterator in the process of changing state?
			-- True when visiting a node or traversing an edge (during
			-- the changes.  (Lots of coupling going on here.)

feature {NONE} -- Implementation

	is_valid_path (a_path: like path_anchor): BOOLEAN
			-- Is `a_path' still continuous from the root to the last node?
			-- The path could become disconnected due to changes in an edge
			-- or node due to manipulations in the graph.
			-- Simply returns true if not `is_validating_paths' in order to
			-- not take a performance hit when the user knows that the
			-- graphs being traversed will not change during traversals.
		do
			Result := is_validating_paths and then a_path.is_invalid
		end


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
--			-- Go to the next non-visited child node/edge of the last_node
--			-- in `a_path'.  Void if there are no more children.
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
--			-- Go all the way down a non-traversed branch until hitting
--			-- what would be a leaf based on this traversal.  In other
--			-- words, the last node of the Result will be a node in
--			-- which there are no more edges/nodes to which to go.
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

	leaf_first_start
			-- Move to the first node "in-order".
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
			p: detachable like path_anchor
		do
			initialize_traversal
-- fix me
			if is_empty then
				is_before := False
				is_after := True
			else
				is_before := False
				is_after := False
				create p.make (root_node)
--				pending_paths.extend (next_leaf_path)
				post_order_forth
			end
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


feature {NONE} -- Implementation

	graph_imp: detachable like graph
			-- Allows `default_create' to leave the `graph' unassigned

	root_node_imp: detachable like node_anchor
			-- Allows `default_create' to leave `root_node' unassigned

	visited_graphs: HASH_TABLE [like graph, INTEGER]
			-- All the graphs that Current could have gone into.
			-- Possible to be more that just `graph' if `is_seeing_reachables'
			-- and a visited node belongs to another graph

	visited_nodes: JJ_ARRAYED_SET [like node_anchor]
			-- The nodes that have been visited during this traversal.
			-- Extended in feature `explore_path';
			-- reset in `initialize_traversal'

	traversed_edges: JJ_ARRAYED_SET [like edge_anchor]
			-- The edges that have been traversed during this traversal.
			-- Extended in feature `explore_path';
			-- reset in `initialize_traversal'

	explored_paths: JJ_ARRAYED_LIST [like path_anchor]
			-- The paths that have been walked during this traversal
			-- in traversal order.

	pending_paths: JJ_SORTABLE_ARRAY [like path_anchor]
			-- List of paths to be evaluated next.

	frontier: HASHED_PRIORITY_QUEUE [like path_anchor, like node_anchor]
			-- Priority queue used in shortest-first traversals,
			-- sorted on the cost to explore a path and indexed
			-- by the last node of a path.

	explore_path (a_path: like path_anchor)
			-- Explore `a_path', visit its `last_node', and traverse
			-- its `last_edge'
		require
			not_empty: not a_path.is_empty
		do
			explored_paths.extend (a_path)
			visit_node (a_path.last_node)
			if a_path.edge_count >= 1 then
				traverse_edge (a_path.last_edge)
			end
		ensure
			was_expored: was_path_explored (a_path)
			was_visited: was_node_visited (a_path.last_node)
			was_visited_by_current: a_path.last_node.was_visited_by (Current)
			was_traversed: a_path.edge_count >= 1 implies was_edge_traversed (a_path.last_edge)
			was_traversed_by_current: a_path.edge_count >= 1 implies a_path.last_edge.was_traversed_by (Current)
		end

	visit_node (a_node: like node_anchor)
			-- Mark `a_node' as visited
		do
			visited_nodes.extend (a_node)
			a_node.visit_by (Current)
		ensure
			was_visited: was_node_visited (a_node)
			visited_by_current: a_node.was_visited_by (Current)
		end

	traverse_edge (a_edge: like edge_anchor)
			-- Mark `a_edge' as traversed
		do
			traversed_edges.extend (a_edge)
			a_edge.traverse_by (Current)
		ensure
			was_traversed: was_edge_traversed (a_edge)
			traversed_by_current: a_edge.was_traversed_by (Current)
		end

	unexplore_path (a_path: like path_anchor)
			-- Ensure `a_path' is not marked as explored by Current
			-- Does not change the visited or traversed status of
			-- any of the nodes and edges in `a_path'
		require
			path_exists: a_path /= Void
		do
			explored_paths.prune (a_path)
--			a_path.unexplore_by (Current)
		ensure
			not_explored: not explored_paths.has (a_path)
--			not_explored_by_current: not a_path.was_explored_by (Current)
		end

	unvisit_node (a_node: like node_anchor)
			-- Ensure `a_node' has not been marked as visited
		do
				a_node.unvisit_by (Current)
				visited_nodes.prune (a_node)
		ensure
			not_visited: not was_node_visited (a_node)
			not_visited_by_current: not a_node.was_visited_by (Current)
		end

	untraverse_edge (a_edge: like edge_anchor)
			-- Ensure that `a_edge' is not marked as traversed.
			-- Do not change the nodes that have been visited or the paths
			-- that have been traversed; because, even though we may have
			-- visited a node by traversing an edge, we may still want to
			-- unmark the edge in order to traverse it again.
		do
			a_edge.untraverse_by (Current)
			traversed_edges.prune (a_edge)
		ensure
			not_traversed: not was_edge_traversed (a_edge)
			not_traversed_by_current: not a_edge.was_traversed_by (Current)
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

invariant

	hash_code_assigned: hash_code /= 0

	has_visitation_policy: is_visiting_nodes or else
							is_traversing_edges or else
							is_exploring_paths

	not_before_and_after: not (is_before and is_after)
	is_before_implication: is_before implies not is_after
	is_after_implication: is_after implies not is_before
	not_off_implication: not is_off implies (not is_after and not is_before)


	visited_nodes_integrity: across visited_nodes as c all c.item.was_visited_by (Current) end
	traversed_edges_integrity: across traversed_edges as c all c.item.was_traversed_by (Current) end

end
