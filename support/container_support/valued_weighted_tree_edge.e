note
	description: "[
		An edge that can be used in a {VALUED_WEIGHTED_TREE}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	VALUED_WEIGHTED_TREE_EDGE [V, C -> NUMERIC create default_create end]

inherit

	VALUED_WEIGHTED_EDGE [V, C]
		undefine
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

	VALUED_TREE_EDGE [V]
		undefine
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

	WEIGHTED_TREE_EDGE [C]
		redefine
			node_anchor,
			iterator_anchor
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

	iterator_anchor: VALUED_WEIGHTED_TREE_ITERATOR [V, C]
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
