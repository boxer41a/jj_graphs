note
	description: "[
		An edge that can be used in a {LABELED_TREE}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision:  $"

class
	LABELED_TREE_EDGE [L]

inherit

	TREE_EDGE
		redefine
			node_anchor,
			iterator_anchor
		end

	LABELED_EDGE [L]
		redefine
			node_anchor,
			iterator_anchor
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_TREE_NODE [L]
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

	iterator_anchor: LABELED_TREE_ITERATOR [L]
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
