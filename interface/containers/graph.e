note
	description: "[
		Graphs implemented as a container of nodes and edges.
		
		Nodes should normally be connected using feature `connect', but
		connections can also be made from the NODE features or features 
		from the EDGE classes themselves.
		
--		Nodes/edges added to the graph using features `connect', `extend', etc.
--		will be "visible" (i.e. "in") the graph; nodes connected using the features 
--		from the NODE classes (i.e. features `adopt', etc.) will not be
--		"visible" to the graph.  This allows nodes to be manipulated directly or
--		nodes to be added to other graphs without affecting this graph.

		To traverse the nodes/edges in a graph, use the {GRAPH_ITERATOR} classes
		or better, use feature `iterator' to return an iterator of the correct type.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/graphs_618/trunk/graphs/interface/containers/graph.e $"
	date:		"$Date: 2012-07-05 00:31:27 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 13 $"

class
	GRAPH

inherit

	IDENTIFIED
		redefine
			default_create
		end

	HASHABLE			-- Used in conjuction with {IDENTIFIED}.`object_id' above
		undefine
			is_equal,
			copy
		redefine
			default_create
		end

create
	default_create,
	make_with_capacity

feature {NONE} -- Initialization

	default_create
			-- Create an instance
		do
--			create nodes_imp.make (Default_size)
--			create edges_imp.make (Default_size)
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
			-- Hash code value
		do
			Result := object_id
		end

	iterator: GRAPH_ITERATOR
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for graph iterators.
		do
			create Result.make (Current)
		end

	nodes: JJ_SORTABLE_SET [like node_anchor]
			-- All the nodes "in" Current.  If `is_tree_mode' then this is all
			-- the nodes reachable from the `root_node'; if not a tree then it
			-- is simply an alias for `nodes_imp', the implementation set of all
			-- nodes in Current.
		do
			if attached nodes_imp as ni then
				Result := ni
			else
				create Result.make (0)
			end
		end

	edges: JJ_SORTABLE_SET [like edge_anchor]
			-- All the edges "in" Current.  If `is_tree_mode' then this is all
			-- the edges traversable from the `root_node'; if not a tree then it
			-- is simply an allias for `edges_imp', the implementation set of all
			-- edges in Current.
		do
			if attached edges_imp as ei then
				Result := ei
			else
				create Result.make (0)
			end
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
			Result := nodes.count
		end

	edge_count: INTEGER
			-- The number of edges in Current.
		do
			Result := edges.count
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
			if not attached nodes_imp then
				create nodes_imp.make (default_size)
			end
			check attached nodes_imp as ni then
				ni.extend (a_node)
			end
			if not a_node.is_in_graph (Current) then
				a_node.join_graph (Current)
			end
--			b := mark_unstable (b)
		ensure
			node_inserted: has_node (a_node)
			node_joined_graph: a_node.is_in_graph (Current)
--			mark_restored: is_marked_unstable = old is_marked_unstable
		end

	extend_edge (a_edge: like edge_anchor)
			-- Make sure `a_edge' (and its two nodes) is visible to (i.e. "in")
			-- the graph.  Normally, only `a_edge' and its two nodes will be visible;
			-- other edges in those two nodes are not automatically added to the
			-- graph.
			-- To add all connections reachable through either of the two node of `a_edge',
			-- pick one of the two nodes and use `deep_extend_node'.
		require
			edge_exists: a_edge /= Void
			is_extendable_edge: is_extendable_edge (a_edge)
		local
			b: BOOLEAN
		do
--			b := mark_unstable (true)
			extend_node (a_edge.node_from)
			extend_node (a_edge.node_to)
			if not attached edges_imp then
				create edges_imp.make (Default_size)
			end
			check attached edges_imp as ei then
				ei.extend (a_edge)
			end
			if not a_edge.is_in_graph (Current) then
				a_edge.join_graph (Current)
			end
--			a_edge.node_from.place_in_graph (Current)
--			a_edge.node_to.place_in_graph (Current)
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
					-- Remove the node and all edges from the `nodes' and `edges'.
			if attached edges_imp as ei then
				e_set := a_node.connections
				from i := 1
				until i > e_set.count
				loop
					e := e_set.i_th (i)
					ei.prune (e)
					i := i + 1
				end
			end
			if attached nodes_imp as ni then
				ni.prune (a_node)
			end
			if a_node.is_in_graph (Current) then
				a_node.prune_graph (Current)
			end
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
			check attached edges_imp as ei then
				ei.prune (a_edge)
			end
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
		end

	connect_nodes (a_node, a_other_node: like node_anchor)
			-- Make a connection between the two nodes, ensuring both nodes
			-- are visible to (i.e. "in") the graph.  The newly created edge
			-- connecting the two nodes can be accessed through `last_new_edge'.
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
			io.put_string ("Enter GRAPH.connect_nodes %N")
			a_node.adopt (a_other_node)
			extend_edge (a_node.last_new_edge)
				-- Remember that {NODE}.`last_new_edge' was "set" during the above call
				-- call to `adopt' which called `new_edge'.  The graph needs to hold
				-- on to this last created edge as well.
			edge_ref.set_edge (a_node.last_new_edge)
				-- It is now accessable in {GRAPH}.last_new_edge
			if is_ordered then
				if not a_node.is_ordered then
					a_node.set_ordered
				end
				if not a_other_node.is_ordered then
					a_other_node.set_ordered
				end
			end
			io.put_string ("Exit GRAPH.connect_nodes %N")
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.originates_at (a_node)
			proper_to_connection_made: last_new_edge.terminates_at (a_other_node)
		end

	connect_nodes_directed (a_node, a_other_node: like node_anchor)
			-- Make a directed connection between the two nodes, ensuring both nodes
			-- are reachable (i.e. in the graph).  The new edge can be accessed
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
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.originates_at (a_node)
			proper_to_connection_made: last_new_edge.terminates_at (a_other_node)
			new_edge_is_directed: last_new_edge.is_directed
		end

	disconnect_nodes (a_node, a_other_node: like node_anchor)
			-- Remove any connections between the two nodes.
		require
			node_exists: a_node /= Void
			other_node_exists: a_other_node /= Void
			has_node: has_node (a_node)
			has_other_node: has_node (a_other_node)
			owns_node: has_node (a_node)
			owns_other_node: has_node (a_other_node)
		do
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
		ensure
			not_connected: not a_node.has_node (a_other_node)
			other_not_connected: not a_other_node.has_node (a_node)
			still_in_graph: has_node (a_node)
			other_still_in_graph: has_node (a_other_node)
		end

	wipe_out
			-- Remove all nodes and edges from Current.  Do not change the nodes and edges.
		do
			nodes_imp := Void
			edges_imp := Void
		end

feature -- Status report

	is_undirected: BOOLEAN
			-- Does Current contain no edges for which `is_directed' is true.
		local
			i: INTEGER
			e: like edge_anchor
		do
			from i := 1
			until Result or else i > edges.count
			loop
				e := edges.i_th (i)
				Result := e.is_directed
				i := i + 1
			end
			Result := not Result
		end

	is_empty: BOOLEAN
			-- Is the graph empty?
		do
			Result := not attached nodes_imp
		ensure
			empty_implication: Result implies nodes_imp = Void and edges_imp = Void
		end

	is_ordered: BOOLEAN
			-- Are nodes added to graph based on an ordered relation to other nodes?

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
						nodes.there_exists (agent {like node_anchor}.is_unstable) or
						edges.there_exists (agent {like edge_anchor}.is_unstable)
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
			if attached nodes_imp as ni then
				from i := 1
				until i > ni.count
				loop
					n := ni.i_th (i)
					n.set_ordered		-- also sorts any edges already in `n'.
					i := i + 1
				end
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
			is_ordered := True
			if attached nodes_imp as ni then
				from i := 1
				until i > ni.count
				loop
					n := ni.i_th (i)
					n.set_unordered
					i := i + 1
				end
			end
		ensure then
			not_ordered: not is_ordered
		end

	mark_unstable (a_mark: BOOLEAN): BOOLEAN
			-- Set `is_marked_unstable' to `a_mark' and return the old `is_marked_unstable'
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
			if attached nodes_imp as ni then
				ni.sort
				from i := 1
				until i > ni.count
				loop
					n := ni.i_th (i)
					n.sort
					i := i + 1
				end
			end
			if attached edges_imp as ei then
				ei.sort
			end
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
--			-- The number of edges connected to `a_node' which are visible to Current
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
--			-- The number of edges going into `a_node' which are also visible to Current
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
--			-- The number of edges going out of `a_node' which are also visible to Current
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
			-- Can always put a node into the graph, even a tree, because
			-- we just end up with a disconnected graph or a forest.
		do
			Result := true
		end

	is_extendable_edge (a_edge: like edge_anchor): BOOLEAN
			-- Can `a_edge' be extended into Current?
			-- True if `a_edge' is not Void and not `is_unstable' and not already in Current.
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
			Result := nodes.has (a_node)
		end

	has_edge (a_edge: like edge_anchor): BOOLEAN
			-- Does Current graph contain `a_edge'?
		do
			Result := edges.has (a_edge)
		end


feature -- Constants

	Default_size: INTEGER = 100
			-- The default number of nodes and edges Current can initially contain.

feature {NONE} -- Implementation (invariant checking)

	has_edge_but_not_its_nodes: BOOLEAN
			-- Does Current contain any edge, but not the nodes
			-- on the end of the edge?
			-- Should always be False
		local
			e: like edge_anchor
		do
			from edges.start
			until edges.exhausted or Result
			loop
				e := edges.item
				Result := not has_node (e.node_from) or not has_node (e.node_to)
				edges.forth
			end
		end

feature {GRAPH} -- Implementation

	nodes_imp: detachable JJ_SORTABLE_SET [like node_anchor]
			-- All the nodes visible to (i.e. "in") the Current graph.
			-- Nodes can be modified directly, changing the visibility of nodes in
			-- relation to the Current graph, but the intended method of
			-- adding or deleting nodes is by using one of the "element change"
			-- features of this class.
			-- This feature could have been hidden, but that just moves the aliasing
			-- problem back one level; node and edges could be obtained from a copy
			-- and then changed, still invalidating the graph properties.
			-- A deep_twin could have been used but then those copies could not
			-- really be considered to be "in" the graph.

	edges_imp: detachable JJ_SORTABLE_SET [like edge_anchor]
			-- All the edges visible to (i.e. "in") the Current graph.
			-- Edges can be added and deleted from `edges' changing their
			-- visiblility to the Current graph, but the intended method of
			-- adding or deleting edges is by using one of the "element change"
			-- features of this class.
			-- This feature could have been hidden, but that just moves the aliasing
			-- problem back one level; node and edges could be obtained from a copy
			-- and then changed, still invalidating the graph properties.
			-- A deep_twin could have been used but then those copies could not
			-- really be considered to be in the graph.

	last_new_edge: like edge_anchor
			-- Last edge that was created when two nodes were connected.
			-- This is a convenience so a connection can be made followed
			-- by manipulation of the new edge.
		require
			edge_ref_has_an_edge: edge_ref.edge /= Void
		do
			check attached {like edge_anchor} edge_ref.edge as e then
				Result := e
			end
		end

	edge_ref: EDGE_REF
			-- Holds a reference to the last created edge.
			-- Once feature used to prevent adding an attribute.
		once ("OBJECT")
			create Result
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

invariant

--	nodes_exists: nodes /= Void
--	edges_exists: edges /= Void
	edge_in_graph_implication: not has_edge_but_not_its_nodes

--	edge_in_graph_implication: not is_unstable implies
--			across edges as e all has_node (e.item.node_from) and has_node (e.item.node_to) end

--	graph_node_integrity: nodes_imp.for_all (agent {like node_anchor}.is_in_graph (Current))

end
