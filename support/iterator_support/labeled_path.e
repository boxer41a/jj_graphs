note
	description: "[
		A path which holds edges of type {LABELED_EDGE}. 
		Each edge has a `label' of type E.
			]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/labeled_path.e $"
	date:		"$Date: 2013-05-20 18:44:32 -0400 (Mon, 20 May 2013) $"
	revision:	"$Revision: 12 $"


class
	LABELED_PATH [L]

inherit

	WALK
			-- A set of edges from a start node to a final node.
		redefine
			node_anchor,
			edge_anchor
		end

create
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_NODE [L]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_safe_contradiction: Result = Void
		end

	edge_anchor: LABELED_EDGE [L]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_safe_contradiction: Result = Void
		end

end
