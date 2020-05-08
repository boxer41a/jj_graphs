note
	description: "[
		An {EDGE} connecting two nodes where the nodes contain a `value'.
		The edge is marked with a `label' and has a `cost'.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	VALUED_LABELED_WEIGHTED_TREE_EDGE [V, L, C -> NUMERIC create default_create end]

inherit

	VALUED_LABELED_TREE_EDGE [V, L]
		rename
			make as make_with_label
		undefine
			default_create,
			make_with_label,
			is_equal,
			is_less,
			check_nodes
		redefine
			iterator_anchor,
			node_anchor
		end

	VALUED_WEIGHTED_TREE_EDGE [V, C]
		rename
			make as make_with_cost
		undefine
			is_equal,
			is_less
		redefine
			iterator_anchor,
			node_anchor
		end

	LABELED_WEIGHTED_TREE_EDGE [L, C]
		undefine
			check_nodes
		redefine
			iterator_anchor,
			node_anchor
		end

	VALUED_LABELED_WEIGHTED_EDGE [V, L, C]
		undefine
			check_nodes
		redefine
			iterator_anchor,
			node_anchor
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_WEIGHTED_TREE_NODE [V, L, C]
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

	iterator_anchor: VALUED_LABELED_WEIGHTED_TREE_ITERATOR [V, L, C]
			-- Anchor for features using iterators.
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

