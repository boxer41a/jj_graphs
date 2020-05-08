note
	description: "[
		An edge that can be used in a {VALUED_LABELED_TREE}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision:  $"

class
	VALUED_LABELED_TREE_EDGE [V, L]

inherit

	VALUED_LABELED_EDGE [V, L]
		redefine
			node_anchor,
			iterator_anchor
		end

	VALUED_TREE_EDGE [V]
		redefine
			node_anchor,
			iterator_anchor
		end

	LABELED_TREE_EDGE [L]
		redefine
			node_anchor,
			iterator_anchor
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_TREE_NODE [V, L]
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

	iterator_anchor: VALUED_LABELED_TREE_ITERATOR [V, L]
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
