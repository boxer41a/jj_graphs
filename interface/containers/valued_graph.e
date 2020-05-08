note
	description: "[
			A {GRAPH} whose nodes contain data of type V.
			]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/graphs_618/trunk/graphs/interface/containers/valued_graph.e $"
	date:		"$Date: 2012-07-05 00:31:27 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 13 $"

class
	VALUED_GRAPH [V]

inherit

	GRAPH
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make_with_capacity

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
			io.put_string ("enter VALUED_GRAPH.connect %N")
			if has (a_value) then
				n1 := last_found_node
			else
				create n1.make_with_value_and_graph (a_value, Current)
				if is_ordered then
					n1.set_ordered
				end
				if object_comparison then
					n1.compare_objects
				end
			end
			if has (a_other_value) then
				n2 := last_found_node
			else
				create n2.make_with_value_and_graph (a_other_value, Current)
				if is_ordered then
					n2.set_ordered
				end
				if object_comparison then
					n2.compare_objects
				end
			end
			io.put_string ("GRAPH.connect before calling `connect_nodes' %N")
			connect_nodes (n1, n2)
			io.put_string ("Exit VALUED_GRAPH.connect %N")
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
				if is_ordered then
					n.set_ordered
				end
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
			if attached nodes_imp as ni then
				from ni.start
				until ni.is_after
				loop
					n := ni.item
					if equal (n.value, a_value) and then has_node (n) then
						prune_node (n)
					end
					ni.forth
				end
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
			if attached nodes_imp as ni then
				from i := 1
				until Result or else i > ni.count
				loop
					n := ni.i_th (i)
					if object_comparison then
						if a_value ~ n.value then
							Result := True
							found_node_ref.set_node (n)
						end
					else
						if a_value = n.value then
							Result := True
							found_node_ref.set_node (n)
						end
					end
					i := i + 1
				end
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
			if attached nodes_imp as ni then
				from i := 1
				until Result /= Void or else i > ni.count
				loop
					n := ni.i_th (i)
					if object_comparison then
						if equal (a_value, n.value) then
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
				n1 := last_found_node
				if has (a_other_value) then
					n2 := last_found_node
					Result := is_connection_allowed (n1, n2)
				end
			end
		end

feature {NONE} -- Implementation

	last_found_node: like node_anchor
			-- The last node found with a call to `has'
		require
			node_ref_has_a_node: found_node_ref.node /= Void
		do
			check attached {like node_anchor} found_node_ref.node as n then
				Result := n
			end
		end

	last_node_imp: detachable like node_anchor
			-- When `connect' creates a new node it is placed here.

	found_node_ref: NODE_REF
			-- Holds the node that was found by the last call to `has'
		once
			create Result
		end

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

end
