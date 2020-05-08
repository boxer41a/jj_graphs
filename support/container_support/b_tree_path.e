note
	description: "[
		An ordered colection of edges beginning at a `start_node'.
		Edges can only be added and	removed from the end.
		This is to be used with a {JJ_B_TREE}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	B_TREE_PATH [G -> COMPARABLE]

inherit

	VALUED_TREE_PATH [B_TREE_ARRAY [G]]
		redefine
			node_anchor,
			edge_anchor
		end

create
	make
	
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
		ensure then
			void_result: Result = Void
		end

	edge_anchor: B_TREE_EDGE [G]
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
		ensure then
			void_result: Result = Void
		end

end
