note
	description: "[
		An edge in a {B_TREE} where each node contains an arrary holding
		values of type N
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

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
