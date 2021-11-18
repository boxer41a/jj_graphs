note
	description: "[
		A {JJ_TREE} whose nodes contain values of type V and
		whose edges contain costs of type C.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_WEIGHTED_TREE [V, C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	VALUED_TREE [V]
		rename
			has as has_value
		undefine
			default_create
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	WEIGHTED_TREE [C]
		rename
			has as has_cost
		undefine
			is_extendable_edge,
			is_connection_allowed,
			prune_node,
			prune_edge
--			difference,
--			subtract
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	VALUED_WEIGHTED_GRAPH [V, C]
		undefine
			default_in_capacity,
			prune_node,
			prune_edge,
			is_extendable_edge,
			is_connection_allowed
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make_with_capacity

feature -- Access

	iterator: VALUED_WEIGHTED_TREE_ITERATOR [V, C]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_WEIGHTED_TREE_NODE [V, C]
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

	edge_anchor: VALUED_WEIGHTED_TREE_EDGE [V, C]
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
