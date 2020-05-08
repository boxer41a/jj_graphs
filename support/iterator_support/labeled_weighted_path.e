note
	description: "[
			A path that holds edges of type {LABELED_WEIGHTED_EDGE}.  Each of the
			edges has a `label' of type E and can have a `cost' of type C.
			]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/labeled_weighted_path.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	LABELED_WEIGHTED_PATH [E, C -> NUMERIC create default_create end]

inherit

	LABELED_PATH [E]
		undefine
			is_less
		redefine
			node_anchor,
			edge_anchor
		end

	WEIGHTED_PATH [C]
		redefine
			node_anchor,
			edge_anchor
		end

create
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_WEIGHTED_NODE [E, C]
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

	edge_anchor: LABELED_WEIGHTED_EDGE [E, C]
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
