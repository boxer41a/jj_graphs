note
	description: "[
			A {GRAPH} whose nodes contain data of type V.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_GRAPH [V]

inherit

	GRAPH
		redefine
			default_create,
			iterator,
			notify_node_changed,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make_with_capacity

feature {NONE} -- Initialization

	default_create
			-- Create an instance.
			-- Redefined to make `node's a sortable set
		do
			Precursor
			nodes_imp.set_ordered
		end

feature -- Access

	iterator: VALUED_GRAPH_ITERATOR [V]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

	last_node: like node_anchor
			-- The last node that was created in a call to `extend'
		require
			node_was_created_by_current: has_a_last_node
		do
			check attached last_node_imp as n then
				Result := n
			end
		end

feature -- Element change

	connect (a_value, a_other_value: like value_anchor)
			-- Find the first two nodes that have values `a_value' and
			-- `a_other_value', (or create new nodes if they are not in the
			-- graph) connecting them with a new edge.  The new edge can
			-- be accessed through `last_new_edge'.
		require
			value_1_exists: a_value /= Void
			value_2_exists: a_other_value /= Void
			connection_allowed: is_valued_connection_allowed (a_value, a_other_value)
		local
			n1, n2: like node_anchor
		do
			if has (a_value) then
				n1 := last_node
			else
				create n1.make_with_value_and_graph (a_value, Current)
				if object_comparison then
					n1.compare_objects
				end
			end
			if has (a_other_value) then
				n2 := last_node
			else
				create n2.make_with_value_and_graph (a_other_value, Current)
				if object_comparison then
					n2.compare_objects
				end
			end
			connect_nodes (n1, n2)
		ensure
			value_1_node_in_graph: has (a_value)
			value_2_node_in_graph: has (a_other_value)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.node_from.value ~ a_value
			proper_to_connection_made: last_new_edge.node_to.value ~ a_other_value
		end

	connect_directed (a_value, a_other_value: like value_anchor)
			-- Find the first two nodes that have values `a_value' and
			-- `a_other_value', (or create new nodes if they are not in the
			-- graph) connecting them with a new edge.  The new edge can
			-- be accessed through `last_new_edge'.
			-- The new edge will be `is_directed'.
		require
			value_1_exists: a_value /= Void
			value_2_exists: a_other_value /= Void
			connection_allowed: is_valued_connection_allowed (a_value, a_other_value)
		local
			e: like edge_anchor
		do
			connect (a_value, a_other_value)
			e := last_new_edge
			check
				edge_exists: e /= Void
					-- because `new_edge' was called creating the correct type.
			end
			e.set_directed
		ensure
			value_1_node_in_graph: has (a_value)
			value_2_node_in_graph: has (a_other_value)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.node_from.value ~ a_value
			proper_to_connection_made: last_new_edge.node_to.value ~ a_other_value
			new_edge_is_directed: last_new_edge.is_directed
		end

	extend (a_value: like value_anchor)
			-- Make sure `a_value' is in a node within Current.
		require
			value_exists: a_value /= Void
		local
			n: like node_anchor
		do
			if not has (a_value) then
				create n.make_with_value_and_graph (a_value, Current)
--				if is_ordered then
--					n.set_ordered
--				end
				if object_comparison then
					n.compare_objects
				end
				extend_node (n)
--				last_node := n
			end
		ensure
			has_value: has (a_value)
		end

	prune (a_value: like value_anchor)
			-- Remove all nodes containing `a_value'.
		require
			value_exists: a_value /= Void
		local
			n: like node_anchor
		do
			from nodes_imp.start
			until nodes_imp.is_after
			loop
				n := nodes_imp.item
				if equal (n.value, a_value) and then has_node (n) then
					prune_node (n)
				end
				nodes_imp.forth
			end
		ensure
			not_in_Current: not has (a_value)
		end

feature -- Query

	has (a_value: like value_anchor): BOOLEAN
			-- Does Current have a node containing `a_value'?
			-- If True, the node can be obtained from `last_found_node'.
		require
			value_exists: a_value /= Void
		local
			n: like node_anchor
			i: INTEGER
		do
			from i := 1
			until Result or else i > nodes_imp.count
			loop
				n := nodes_imp.i_th (i)
				if object_comparison then
					if a_value ~ n.value then
						Result := True
						last_node_imp := n
					end
				else
					if a_value = n.value then
						Result := True
						last_node_imp := n
					end
				end
				i := i + 1
			end
		end

	has_a_last_node: BOOLEAN
			-- Has Current created a node [in `connect']?
		do
			Result := last_node_imp /= Void
		end

	find_valued_node (a_value: like value_anchor): detachable like node_anchor
			-- The first node whose `value' is the same as `a_value' (object or
			-- reference equality).  Result is Void if a node containing `a_value'
			-- is not in the graph.
		require
			value_exists: a_value /= Void
		local
			n: like node_anchor
			i: INTEGER
		do
			from i := 1
			until Result /= Void or else i > nodes_imp.count
			loop
				n := nodes_imp.i_th (i)
				if object_comparison then
					if a_value ~ n.value then
						Result := n
					end
				else
					if a_value = n.value then
						Result := n
					end
				end
				i := i + 1
			end
		end

	is_valued_connection_allowed (a_value, a_other_value: like value_anchor): BOOLEAN
			-- Is it okay to create a link between nodes containing `a_value'
			-- and `a_other_value'?  These nodes may already exit in Current.
		require
			value_1_exists: a_value /= Void
			value_2_exists: a_other_value /= Void
		local
			n1, n2: like node_anchor
		do
			Result := True
			if has (a_value) then
				n1 := last_node
				if has (a_other_value) then
					n2 := last_node
					Result := is_connection_allowed (n1, n2)
				end
			end
		end

feature {NODE} -- Implementation

	notify_node_changed (a_node: like node_anchor)
			-- Called by `a_node' to inform Current that `a_node' changed
			-- Refefine to react to this change.
		do
			nodes_imp.sort
				-- It may be faster to delete the insert the node
--			nodes_imp.prune (a_node)
--			nodes_imp.extend (a_node)
			notify_dirty
		end

feature {NONE} -- Implementation

	last_node_imp: detachable like node_anchor
			-- When `connect' creates a new node it is placed here.

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_NODE [V]
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

	edge_anchor: VALUED_EDGE [V]
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

	value_anchor: V
			-- Anchor for features using the `value' in the node.
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

invariant

	nodes_are_sorted: nodes_imp.is_sorted

end
