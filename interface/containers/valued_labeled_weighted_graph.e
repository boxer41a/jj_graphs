note
	description: "[
		A an {GRAPH} where each node has a `value' and each
		edge is labeled with a `label' and has a `cost'.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_LABELED_WEIGHTED_GRAPH [V, L, C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	VALUED_LABELED_GRAPH [V, L]
		export
			{NONE}
				connect,
				connect_directed
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	VALUED_WEIGHTED_GRAPH [V, C]
		undefine
			default_create
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	LABELED_WEIGHTED_GRAPH [L, C]
		undefine
			default_create,
			notify_node_changed
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make_with_capacity

feature -- Access

	iterator: VALUED_LABELED_WEIGHTED_GRAPH_ITERATOR [V, L, C]
			-- Create an iterator for accessing the nodes and edges in Current.
			-- Anchor for graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_WEIGHTED_NODE [V, L, C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: VALUED_LABELED_WEIGHTED_EDGE [V, L, C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
