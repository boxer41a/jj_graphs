note
	description: "[
			An {EDGE} connecting nodes in a {GRAPH}.  The nodes
			connected by this type edge contain data of type V.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_EDGE [V]

inherit

	EDGE
		redefine
			node_anchor
		end

create
	default_create,
	connect

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_NODE [V]
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
