note
	description: "[
			A graph whose edges contain data of type E.
			]"
	author: "Jimmy J. Johnson"
	license: "Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	WEIGHTED_GRAPH [C -> NUMERIC create default_create end]

inherit

	GRAPH
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create

feature -- Access

	iterator: WEIGHTED_GRAPH_ITERATOR [C]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature -- Element change

	connect_nodes_weighted (a_node, a_other_node: like node_anchor; a_cost: C)
			-- Make sure graph contains the two nodes and connect them
			-- by creating an edge with `a_cost'.  The new edge can be
			-- accessed through `last_new_edge'.
		require
			node_exists: a_node /= Void
			other_exists: a_other_node /= Void
			cost_exists: a_cost /= Void
			is_connection_allowed: is_connection_allowed (a_node, a_other_node)
		do
			connect_nodes (a_node, a_other_node)
			a_node.last_new_edge.set_cost (a_cost)
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			edge_inserted: has_edge (a_node.last_new_edge)
			proper_from_connection_made: a_node.last_new_edge.originates_at (a_node)
			proper_to_connection_made: a_node.last_new_edge.terminates_at (a_other_node)
			cost_was_set: a_node.last_new_edge.cost = a_cost
		end

	connect_nodes_weighted_directed (a_node, a_other_node: like node_anchor; a_cost: C)
			-- Make sure graph contains the two nodes and connect them
			-- by creating a directed edge with `a_cost'.  The new edge can be
			-- accessed through `last_new_edge'.
		require
			node_exists: a_node /= Void
			other_exists: a_other_node /= Void
			cost_exists: a_cost /= Void
			is_connection_allowed: is_connection_allowed (a_node, a_other_node)
		do
			connect_nodes_weighted (a_node, a_other_node, a_cost)
			a_node.last_new_edge.set_directed
		ensure
			node_inserted: has_node (a_node)
			other_node_inserted: has_node (a_other_node)
			edge_inserted: has_edge (a_node.last_new_edge)
			proper_from_connection_made: a_node.last_new_edge.originates_at (a_node)
			proper_to_connection_made: a_node.last_new_edge.terminates_at (a_other_node)
			cost_was_set: a_node.last_new_edge.cost = a_cost
			new_edge_is_directed: a_node.last_new_edge.is_directed
		end

feature -- Query

	has (a_cost: C): BOOLEAN
			-- Does Current have an edge containing `a_cost'?
			-- If True, the edge can be obtained from `last_found_egde'
		require
			cost_exists: a_cost /= Void
		local
			i: INTEGER
			e: like edge_anchor
		do
			if attached edges_imp as ei then
				from i := 1
				until i > ei.count
				loop
					e := ei.i_th (i)
					if object_comparison then
						if equal (e.cost, a_cost) then
							Result := True
							found_edge_ref.set_edge (e)
						end
					else
						if a_cost = e.cost then
							Result := True
							found_edge_ref.set_edge (e)
						end
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	last_found_edge: like edge_anchor
			-- The last edge found with a call to `has'
		require
			edge_ref_has_a_edge: found_edge_ref.edge /= Void
		do
			check attached {like edge_anchor} found_edge_ref.edge as e then
				Result := e
			end
		end

	found_edge_ref: EDGE_REF
			-- Holds the edge that was found by the last call to `has'
		once
			create Result
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: WEIGHTED_NODE [C]
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

	edge_anchor: WEIGHTED_EDGE [C]
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

end
