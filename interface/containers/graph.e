note
	description: "[
		Graphs implemented as a container of nodes and edges.

		Nodes should normally be connected using feature `connect', but
		connections can also be made from the NODE features or features
		from the EDGE classes themselves.

		Nodes/edges added to the graph using features `connect', `extend',
		etc. will be "visible" (i.e. "in") the graph; nodes connected using
		the connection features from {NODE} or {EDGE} (e.g. features `adopt',
		`disown', `connect', etc.) will not be "visible" to the graph.  These
		features allow direct manipulation of nodes and/or edges without
		affecting a particular graph.

		To traverse the nodes/edges in a graph, use the {GRAPH_ITERATOR}
		classes, or better, use feature `iterator' to return an iterator of
		the correct type connected to the current graph.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	GRAPH

inherit

	SHARED
		undefine
			default_create,
			is_equal,
			copy
		end

	HASHABLE
		redefine
			default_create,
			copy,
			is_equal
		end

create
	default_create,
	make_with_capacity

feature {NONE} -- Initialization

	default_create
			-- Create an instance
		do
			hash_code := uuid_generator.generate_uuid.hash_code
			create iterators.make (Default_size)
			create nodes_imp.make (Default_size)
			create edges_imp.make (Default_size)
--			nodes_imp.set_ordered
--			edges_imp.set_ordered
			initial_in_capacity := Default_in_capacity
			initial_out_capacity := Default_out_capacity
		ensure then
			in_capacity_set: initial_in_capacity = Default_in_capacity
			out_capacity_set: initial_out_capacity = Default_out_capacity
		end

	make_with_capacity (a_capacity: INTEGER)
			-- Initialize current setting `initial_out_capacity'
		require
			out_capacity_big_enough: a_capacity >= 4
		do
			default_create
			initial_out_capacity := a_capacity
		ensure
			in_capacity_set: initial_in_capacity = Default_in_capacity
			out_capacity_set: initial_out_capacity = a_capacity
		end

feature -- Access

	hash_code: INTEGER
			-- Hash code from a {RANDOM} value in `default_create'.

	nodes: JJ_SORTABLE_SET [like node_anchor]
			-- A copy of the list containing all the nodes in Current
		do
			Result := nodes_imp.twin
		end

	edges: JJ_SORTABLE_SET [like edge_anchor]
			-- A copy of the list containing all the edges in Current
		do
			Result := edges_imp.twin
		end

	iterator: GRAPH_ITERATOR
			-- Create a new iterator for accessing the nodes and
			-- edges in Current.
			-- Anchor for graph iterators.
		do
			create Result.make (Current)
			extend_iterator (Result)
		end

	last_new_edge: like edge_anchor
			-- Last edge that was created when two nodes were connected.
			-- This is a convenience so a connection can be made followed
			-- by manipulation of the new edge.
		attribute
			create Result
		end

feature -- Measurement

	Default_in_capacity: INTEGER
			-- The number of edges that nodes created in Current
			-- can initially contain by default
		once
			Result := 5
		end

	Default_out_capacity: INTEGER
			-- The number of edges that nodes created in Current
			-- can initially contain by default
		once
			Result := 5
		end

	initial_in_capacity: INTEGER
			-- The number of in-coming edges that nodes created in Current
			-- can initially contain

	initial_out_capacity: INTEGER
			-- The number of out-going edges that nodes created in Current
			-- can initially contain.  (Set in `make_with_order')

	node_count: INTEGER
			-- The number of nodes in Current.
		do
			Result := nodes_imp.count
		end

	edge_count: INTEGER
			-- The number of edges in Current.
		do
			Result := edges_imp.count
		end

feature -- Element change

	extend_node (a_node: like node_anchor)
			-- Put `a_node' into the graph.
		require
			node_exists: a_node /= Void
			valid_node: is_extendable_node (a_node)
		local
			b: BOOLEAN
		do
--			b := mark_unstable (true)
			nodes_imp.extend (a_node)
			if not a_node.is_in_graph (Current) then
				a_node.join_graph (Current)
				notify_dirty
			end
--			b := mark_unstable (b)
		ensure
			node_inserted: has_node (a_node)
			node_joined_graph: a_node.is_in_graph (Current)
--			mark_restored: is_marked_unstable = old is_marked_unstable
		end

	extend_edge (a_edge: like edge_anchor)
			-- Make sure `a_edge' (and its two nodes) is visible to (i.e. "in")
			-- the graph.  Normally, only `a_edge' and its two nodes will be
			-- visible; other edges in those two nodes are not automatically
			-- added to the graph.
			-- To add all connections reachable through either of the two node
			-- of `a_edge', pick one of the two nodes and use `deep_extend_node'.
		require
			edge_exists: a_edge /= Void
			is_extendable_edge: is_extendable_edge (a_edge)
		local
			b: BOOLEAN
		do
--			b := mark_unstable (true)
			extend_node (a_edge.node_from)
			extend_node (a_edge.node_to)
			edges_imp.extend (a_edge)
			if not a_edge.is_in_graph (Current) then
				a_edge.join_graph (Current)
				notify_dirty
			end
--			b := mark_unstable (b)
		ensure then
--			mark_restored: is_marked_unstable = old is_marked_unstable
			first_node_inserted: has_node (a_edge.node_from)
			second_node_inserted: has_node (a_edge.node_to)
			edge_inserted: has_edge (a_edge)
		end

	prune_node (a_node: like node_anchor)
			-- Remove `a_node' and its edges from the graph.
			-- The node and its edges remain unchanged they just become
			-- invisible to the graph.
		require
			node_exists: a_node /= Void
			is_prunable_node: has_node (a_node)
		local
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			e: like edge_anchor
			i: INTEGER
		do
				-- Remove the node and all edges from the `nodes_imp' and `edges_imp'.
			e_set := a_node.connections
			from i := 1
			until i > e_set.count
			loop
				e := e_set.i_th (i)
				edges_imp.prune (e)
				i := i + 1
			end
			nodes_imp.prune (a_node)
			if a_node.is_in_graph (Current) then
				a_node.leave_graph (Current)
			end
			notify_dirty
		ensure
			node_removed: not has_node (a_node)
			node_left_graph: not a_node.is_in_graph (Current)
		end

	prune_edge (a_edge: like edge_anchor)
			-- Remove `a_edge' from the graph.  The nodes at each
			-- end of the edge will still be visible to the graph,
			-- and `a_edge' will still be connected to its two nodes;
			-- (`A_edge' and its nodes may be in another graph.)
		require
			edge_exists: a_edge /= Void
			owns_edge: has_edge (a_edge)
			is_prunable_edge: has_edge (a_edge)
		do
			edges_imp.prune (a_edge)
			if a_edge.is_in_graph (Current) then
				a_edge.leave_graph (Current)
			end
			notify_dirty
		ensure
			edge_removed: not has_edge (a_edge)
		end

	deep_extend_node (a_node: like node_anchor)
			-- Add `a_node' and all its edges to the Current graph.
		require
			node_exists: a_node /= Void
			is_extendable_node: is_extendable_node (a_node)
				-- Is the next precondition right?  or too restrictive?
--			descendents_extendable: a_node.related_connections.for_all (agent is_extendable_edge)
		local
			e: like edge_anchor
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			i: INTEGER
		do
			e_set := a_node.related_connections
			from i := 1
			until i > e_set.count
			loop
				e := e_set.i_th (i)
				if not has_edge (e) then
					extend_edge (e)
				end
				i := i + 1
			end
			notify_dirty
		end

	connect_nodes (a_node, a_other_node: like node_anchor)
			-- Make a connection between the two nodes, ensuring both nodes
			-- are visible to (i.e. "in") the graph.  The newly created edge
			-- connecting the two nodes can be accessed through `last_new_edge'.
			-- Side effect: if Current `is_ordered' then the two nodes will be
			-- ordered after this call.
		require
			node_can_adopt_child: a_node.can_adopt (a_other_node)
			can_add_node: is_extendable_node (a_node)
			can_add_other_node: is_extendable_node (a_other_node)
			allowable_connection: is_connection_allowed (a_node, a_other_node)
		do
			a_node.adopt (a_other_node)
			extend_edge (a_node.last_new_edge)
				-- Remember that {NODE}.`last_new_edge' was "set" during the
				-- above call call to `adopt' which called `new_edge'.  The
				-- graph needs to hold on to this last created edge as well.
			last_new_edge := a_node.last_new_edge
				-- It is now accessable in {GRAPH}.last_new_edge
			if is_ordered then
				if not a_node.is_ordered then
					a_node.set_ordered
				end
				if not a_other_node.is_ordered then
					a_other_node.set_ordered
				end
			end
			notify_dirty
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.originates_at (a_node)
			proper_to_connection_made: last_new_edge.terminates_at (a_other_node)
		end

	connect_nodes_directed (a_node, a_other_node: like node_anchor)
			-- Make a directed connection between the two nodes, ensuring both
			-- nodes are visible (i.e. in the graph).  Access the new node
			-- through `last_new_edge'.
			-- Side effect: if Current `is_ordered' then the two nodes will be
			-- ordered after this call.
		require
			node_exists: a_node /= Void
			other_exists: a_other_node /= Void
			node_can_adopt_child: a_node.can_adopt (a_other_node)
			can_add_node: is_extendable_node (a_node)
			can_add_other_node: is_extendable_node (a_other_node)
			allowable_connection: is_connection_allowed (a_node, a_other_node)
		do
			connect_nodes (a_node, a_other_node)
			last_new_edge.set_directed	-- reminder: `last_new_edge' assigned in `connect_nodes'
			notify_dirty
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.originates_at (a_node)
			proper_to_connection_made: last_new_edge.terminates_at (a_other_node)
			new_edge_is_directed: last_new_edge.is_directed
		end

	disconnect_nodes (a_node, a_other_node: like node_anchor)
			-- Remove any connections between the two nodes
		require
			has_node: has_node (a_node)
			has_other_node: has_node (a_other_node)
		do
				-- Loop, because there could be multiple connections
			from
			until not a_node.has_node (a_other_node)
			loop
				check attached a_node.find_connection (a_other_node) as e then
						-- because a_node.has_node (a_other_node) from above
					e.disconnect
					prune_edge (e)
				end
			end
			check
				other_node_not_connected: not a_other_node.has_node (a_node)
					-- because of node/edge symetry and all edges between
					-- the two nodes were disconnected.
			end
			notify_dirty
		ensure
			not_connected: not a_node.has_node (a_other_node)
			other_not_connected: not a_other_node.has_node (a_node)
			still_in_graph: has_node (a_node)
			other_still_in_graph: has_node (a_other_node)
		end

	wipe_out
			-- Remove all nodes and edges from Current.
			-- Do not change the nodes and edges.
		do
			nodes_imp.wipe_out
			edges_imp.wipe_out
			notify_dirty
		end

feature -- Status report

	is_undirected: BOOLEAN
			-- Does Current contain no edges for which `is_directed' is true.
		local
			i: INTEGER
			e: like edge_anchor
		do
			from i := 1
			until Result or else i > edges_imp.count
			loop
				e := edges_imp.i_th (i)
				Result := e.is_directed
				i := i + 1
			end
			Result := not Result
		end

	is_empty: BOOLEAN
			-- Is the graph empty?
		do
			Result := nodes_imp.is_empty
		ensure
			empty_implication: Result implies nodes_imp.is_empty and edges_imp.is_empty
		end

	is_ordered: BOOLEAN
			-- Are nodes added to graph based on an ordered relation
			-- to other nodes?

	object_comparison: BOOLEAN
			-- Must search operations use `equal' rather than `='
			-- for comparing references? (Default: no, use `='.)

	changeable_comparison_criterion: BOOLEAN
			-- May `object_comparison' be changed?
			-- (Answer: yes by default.)
		do
			Result := True
		end

	is_marked_unstable: BOOLEAN
			-- Is Current marked as unstable?

	is_unstable: BOOLEAN
			-- Is Current unstable [because it `is_marked_unstable' or
			-- any of its nodes or edges is unstable
		do
			Result := is_marked_unstable or
						nodes_imp.there_exists (agent {like node_anchor}.is_unstable) or
						edges_imp.there_exists (agent {like edge_anchor}.is_unstable)
		end

feature -- Status setting

	compare_objects
			-- Ensure that future search operations will use `equal'
			-- rather than `=' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			object_comparison := True
		ensure
			object_comparison
		end

	compare_references
			-- Ensure that future search operations will use `='
			-- rather than `equal' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			object_comparison := False
		ensure
			reference_comparison: not object_comparison
		end

	set_ordered
			-- Make future connections between nodes be inserted based
			-- on an ordered relation between the nodes and/or edges.
			-- This has a side affect and will cause `connect_nodes' to
			-- have a side affect as well.  Each node in Current will be
			-- sorted and will now insert edges in order.  Also, any nodes
			-- connected with Current will be sorted and add edges in order.
		local
			n: like node_anchor
			i: INTEGER
		do
			is_ordered := True
			from i := 1
			until i > nodes_imp.count
			loop
				n := nodes_imp.i_th (i)
				n.set_ordered		-- sorts any edges already in `n'.
				i := i + 1
			end
		ensure then
			is_ordered: is_ordered
		end

	set_unordered
			-- Make future connections (edges) between nodes be inserted
			-- into the nodes after the last edge.
			-- This changes all nodes connected to Current.
		local
			n: like node_anchor
			i: INTEGER
		do
			is_ordered := false
			from i := 1
			until i > nodes_imp.count
			loop
				n := nodes_imp.i_th (i)
				n.set_unordered
				i := i + 1
			end
		ensure then
			not_ordered: not is_ordered
		end

	mark_unstable (a_mark: BOOLEAN): BOOLEAN
			-- Set `is_marked_unstable' to `a_mark' returning the old value
		do
			Result := is_marked_unstable
			is_marked_unstable := a_mark
		ensure
			definition: is_marked_unstable = a_mark
			valid_result: Result = old is_marked_unstable
		end

feature -- Basic operations

	sort
			-- Sort the edges in each node in Current graph.
		local
			n: like node_anchor
			i: INTEGER
		do
			nodes_imp.sort
			from i := 1
			until i > nodes_imp.count
			loop
				n := nodes_imp.i_th (i)
				n.sort
				i := i + 1
			end
			edges_imp.sort
			notify_dirty
		end

--	subtract (other: like Current)
--			-- Remove all the nodes and edges in `other' from Current.
--		require
--			other_exists: other /= Void
--		do
--			nodes_imp.subtract (other.nodes_imp)
--			edges_imp.subtract (other.edges_imp)
--		end

--	difference alias "-" (other: like Current): like Current
--			-- A graph consisting of Current minus all the nodes and edges in `other'
--		require
--			graph_exists: other /= Void
--		do
--				-- Feature `deep_twin' is an expensive operation, but
--				-- how else to account for attributes of descendants?
--			Result := deep_twin
--			Result.wipe_out
--			from nodes.start
--			until nodes.exhausted
--			loop
--				if not other.has_node (nodes.item) then
--					Result.extend_node (nodes.item)
--				end
--				nodes.forth
--			end
--			from edges.start
--			until edges.exhausted
--			loop
--				if not other.has_edge (edges.item) then
--					Result.extend_edge (edges.item)
--				end
--				edges.forth
--			end
--		end

feature -- Query

--	edge_count_for_node (a_node: like node_anchor): INTEGER
--			-- The number of visible edges connected to `a_node'
--		require
--			node_exists: a_node /= Void
--		local
--			i: INTEGER
--		do
--			from i := 1
--			until i > a_node.count
--			loop
--				if edges_imp.has (a_node.i_th_edge (i)) then
--					Result := Result + 1
--				end
--				i := i + 1
--			end
--		ensure
--			result_small_enough: Result <= a_node.count
--		end

--	in_edge_count (a_node: like node_anchor): INTEGER
--			-- The number of visible edges going into `a_node'
--		require
--			node_exists: a_node /= Void
--		local
--			i: INTEGER
--		do
--			from i := 1
--			until i > a_node.in_count
--			loop
--				if edges_imp.has (a_node.i_th_edge (i)) then
--					Result := Result + 1
--				end
--				i := i + 1
--			end
--		ensure
--			result_small_enough: Result <= a_node.in_count
--		end

--	out_edge_count (a_node: like node_anchor): INTEGER
--			-- The number of visible edges going out of `a_node'
--		require
--			node_exists: a_node /= Void
--		local
--			i: INTEGER
--		do
--			from i := 1
--			until i > a_node.out_count
--			loop
--				if edges_imp.has (a_node.i_th_edge (i)) then
--					Result := Result + 1
--				end
--				i := i + 1
--			end
--		ensure
--			result_small_enough: Result <= a_node.out_count
--		end

	is_extendable_node (a_node: like node_anchor): BOOLEAN
			-- Can `a_node' be put into and manipulated by Current?
			-- Always true for a graph.
		do
			Result := true
		end

	is_extendable_edge (a_edge: like edge_anchor): BOOLEAN
			-- Can `a_edge' be extended into Current?
			-- True if `a_edge' is not Void and not `is_unstable' and
			-- not already in Current.
		do
			Result := not a_edge.is_unstable and then
					not has_edge (a_edge)
		end

	is_connection_allowed (a_node, a_other_node: like node_anchor): BOOLEAN
			-- Is Current allowed to make a connection between the two nodes?
		do
			Result := is_extendable_node (a_node) and then is_extendable_node (a_other_node)
		end

--	is_prunable_node (a_node: like node_anchor): BOOLEAN
--			-- Can `a_node' be removed from Current?
--		do
--			Result := has_node (a_node)
--		end

--	is_prunable_edge (a_edge: like edge_anchor): BOOLEAN
--			-- Can `a_node' be remove from Current?
--		do
--			Result := has_edge (a_edge)
--		end

	has_node (a_node: like node_anchor): BOOLEAN
			-- Does Current contain `a_node'?
		do
			Result := nodes_imp.has (a_node)
		end

	has_edge (a_edge: like edge_anchor): BOOLEAN
			-- Does Current graph contain `a_edge'?
		do
			Result := edges_imp.has (a_edge)
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
			--| `object_id' is not taken into consideration
		local
			hc: INTEGER
		do
			hc := hash_code
			hash_code := other.hash_code
			Result := standard_is_equal (other)
			hash_code := hc
		end

feature -- Duplication

	copy (other: like Current)
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
			--| `hash_code' will return a different value for the two
			--| objects
		local
			hc: INTEGER
		do
			if other /= Current then
				hc := hash_code
				standard_copy (other)
				hash_code := hc
			end
		end

feature -- Constants

	Default_size: INTEGER = 100
			-- The default number of nodes and edges Current can
			-- initially contain.

feature {GRAPH_ITERATOR} -- Implementation

	 nodes_imp: like nodes
			-- All the nodes visible to (i.e. "in") the Current graph.
			-- This list should not be modified directly, changing the visibility
			-- of nodes in relation to the Current graph.  Use one of the
			-- "element change" features of this class instead.

	edges_imp: like edges
			-- All the edges visible to (i.e. "in") the Current graph.
			-- This list should not be modified directly, changing the visibility
			-- of nodes in relation to the Current graph.  Use one of the
			-- "element change" features of this class instead.

	extend_iterator (a_iterator: like iterator)
			-- Add `a_iterator' to `iterators'
		local
			w: WEAK_REFERENCE [like iterator]
		do
			create w.put (a_iterator)
			iterators.extend (w, a_iterator.hash_code)
		end

	notify_dirty
			-- Inform each iterator traversing Current that Current
			-- may have changed.
		local
			w: WEAK_REFERENCE [like iterator]
			marks: LINKED_SET [INTEGER]
		do
			create marks.make
			from iterators.start
			until iterators.after
			loop
				w := iterators.item_for_iteration
				if attached w.item as it then
					it.set_dirty
				else
						-- Save key to Void item for removal later, so
						-- the iteration is not messed up.
					marks.extend (iterators.key_for_iteration)
				end
				iterators.forth
			end
				-- Now remove Void items
			from marks.start
			until marks.after
			loop
				iterators.remove (marks.item)
				marks.forth
			end
		end

	has_iterator (a_code: INTEGER): BOOLEAN
			-- Does Current have a reference to a {GRAPH_ITERATOR}
			-- that is indexed by `a_code'
		do
			Result := attached iterators.item (a_code) as wr and then
						attached wr.item
		end

feature {NONE} -- Implementation

	iterators: HASH_TABLE [WEAK_REFERENCE [like iterator], INTEGER]
			-- Keeps track of each iterator to inform them when
			-- Current changes.

feature {NONE} -- Implementation (invariant checking)

	has_edge_but_not_its_nodes: BOOLEAN
			-- Does Current contain any edge, but not the nodes
			-- on the end of the edge?
			-- Should always be False
		local
			e: like edge_anchor
		do
			from edges_imp.start
			until edges_imp.exhausted or Result
			loop
				e := edges_imp.item
				Result := not has_node (e.node_from) or not has_node (e.node_to)
				edges_imp.forth
			end
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: NODE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- because gives no info; simply used as anchor.
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
					-- because gives no info; simply used as anchor.
			end
		end

invariant

	hash_code_assigned: hash_code /= 0
--	nodes_sorted: nodes_imp.is_inserting_ordered
--	edges_sorted: edges_imp.is_inserting_ordered

	edge_in_graph_implication: not has_edge_but_not_its_nodes

--	edge_in_graph_implication: not is_unstable implies
--			across edges as e all has_node (e.item.node_from) and has_node (e.item.node_to) end

--	graph_node_integrity: nodes_imp.for_all (agent {like node_anchor}.is_in_graph (Current))

end
