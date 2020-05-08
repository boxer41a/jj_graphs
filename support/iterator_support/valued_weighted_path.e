note
	description: "[
			A path that holds edges of type {VALUED_WEIGHTED_EDGE}.  Each of the
			edges can have a `cost' of type E and the node at each end has
			`value' of type N.
			]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/valued_weighted_path.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	VALUED_WEIGHTED_PATH [N, C -> NUMERIC create default_create end]

inherit

	VALUED_PATH [N]
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

	node_anchor: VALUED_WEIGHTED_NODE [N, C]
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

	edge_anchor: VALUED_WEIGHTED_EDGE [N, C]
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
