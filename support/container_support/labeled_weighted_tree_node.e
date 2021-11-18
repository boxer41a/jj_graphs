note
	description: "[
		An node that can be used in a {LABELED_WEIGHTED_TREE}
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	LABELED_WEIGHTED_TREE_NODE [L, C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	LABELED_WEIGHTED_NODE [L, C]
		undefine
			make_with_order
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	LABELED_TREE_NODE [L]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	WEIGHTED_TREE_NODE [C]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
	default_create,		-- Same as {NODE} because the label and weight
	make_with_order,	-- only applies to edges not the node
	make_with_graph

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: LABELED_WEIGHTED_TREE [L, C]
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

	node_anchor: LABELED_WEIGHTED_TREE_NODE [L, C]
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

	edge_anchor: LABELED_WEIGHTED_TREE_EDGE [L, C]
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

	iterator_anchor: LABELED_WEIGHTED_TREE_ITERATOR [L, C]
			-- Anchor for features using iterators.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

end
