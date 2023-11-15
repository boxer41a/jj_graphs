note
	description: "[
			A graph whose edges contain data of type E.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	WEIGHTED_GRAPH [C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

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
		local
			e: like edge_anchor
		do
--			connect_nodes (a_node, a_other_node)
--			a_node.last_new_edge.set_cost (a_cost)
				-- The two line above, though more elegant, will not work.  The
				-- cost of the edge must be assigned before extending that edge
				-- into the graph because `has_edge' from {GRAPH} will see an
				-- edge cost of one and mistake the edge for some other.
				-- So, this feature just mimics `connect_nodes' from {GRAPH}
				-- inserting a line to set the cost before putting the edge
				-- into the graph.
			create e
			e.set_cost (a_cost)
			e.connect (a_node, a_other_node)
			extend_edge (e)
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
			from i := 1
			until i > edges_imp.count
			loop
				e := edges_imp.i_th (i)
				if object_comparison then
					if equal (e.cost, a_cost) then
						Result := True
						last_new_edge := e
					end
				else
					if a_cost = e.cost then
						Result := True
						last_new_edge := e
					end
				end
				i := i + 1
			end
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
