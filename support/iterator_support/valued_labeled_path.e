note
	description: "[
			A path that holds edges of type {WEIGHTED_VALUED_EDGE}  Each of the
			edges can have a `cost' of type E and the node at each end has 
			`value' of type N.
			]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/valued_labeled_path.e $"
	date:		"$Date: 2013-01-14 16:24:51 -0500 (Mon, 14 Jan 2013) $"
	revision:	"$Revision: 10 $"

class
	VALUED_LABELED_PATH [N, E]

inherit

	VALUED_PATH [N]
		undefine
			is_less
		redefine
			node_anchor,
			edge_anchor
		end

	LABELED_PATH [E]
		redefine
			node_anchor,
			edge_anchor
		end

create
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_NODE [N, E]
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

	edge_anchor: VALUED_LABELED_EDGE [N, E]
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
