note
	description: "[
		An edge that can be used in a {WEIGHTED_TREE}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	LABELED_WEIGHTED_TREE_EDGE [L, C -> NUMERIC create default_create end]

inherit

	LABELED_WEIGHTED_EDGE [L, C]
		undefine
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

	LABELED_TREE_EDGE [L]
		rename
			make as make_with_label
		undefine
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

	WEIGHTED_TREE_EDGE [C]
		rename
			make as make_with_cost
		redefine
			node_anchor,
			iterator_anchor
		end

feature {NONE} -- Anchors (for covariant redefinitions)

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

	iterator_anchor: LABELED_WEIGHTED_TREE_ITERATOR [L, C]
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
