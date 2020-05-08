note
	description: "[
		An edge in a {B_TREE} where each node contains an arrary holding values of type N
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	B_TREE_EDGE [G -> COMPARABLE]

inherit

	VALUED_TREE_EDGE [B_TREE_ARRAY [G]]
		redefine
			node_anchor
		end

create
	default_create,
	connect

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: B_TREE_NODE [G]
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
