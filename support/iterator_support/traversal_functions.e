note
	description: "[
		Decomposition of some functions and data structures for
		use by {GRAPH_ITERATOR}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2013, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/traversal_functions.e $"
	date:		"$Date: 2013-01-13 08:58:55 -0500 (Sun, 13 Jan 2013) $"
	revision:	"$Revision: 9 $"

class
	TRAVERSAL_FUNCTIONS

feature -- Basic operations



feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: GRAPH
			-- Anchor for graph types.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure
			void_result: Result = Void
		end

	node_anchor: NODE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure
			void_result: Result = Void
		end

	edge_anchor: EDGE
			-- Anchor for features using edges.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure
			void_result: Result = Void
		end

	path_anchor: PATH
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure
			void_result: Result = Void
		end

end
