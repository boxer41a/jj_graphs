note
	description: "[
			A {PATH} which holds edges of type {VALUED_EDGE [V]} (edges
			whose nodes hold values of type V.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/valued_path.e $"
	date:		"$Date: 2013-05-20 18:44:32 -0400 (Mon, 20 May 2013) $"
	revision:	"$Revision: 12 $"

class
	VALUED_PATH [N]

inherit

	WALK
		redefine
			node_anchor,
			edge_anchor
		end

create
	make

feature -- Access

	last_value: N
			-- The value in the `last_node'
		do
			Result := last_node.value
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_NODE [N]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_result: Result = Void
		end

	edge_anchor: VALUED_EDGE [N]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_result: Result = Void
		end

end
