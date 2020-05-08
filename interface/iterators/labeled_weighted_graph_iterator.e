note
	description: "[
		An iterator for traversing a {LABELED_WEIGHTED_GRAPH}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/graphs_618/trunk/graphs/interface/iterators/labeled_weighted_graph_iterator.e $"
	date:		"$Date: 2012-07-05 00:31:27 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 13 $"

class
	LABELED_WEIGHTED_GRAPH_ITERATOR [L, C -> NUMERIC create default_create end]

inherit

	LABELED_GRAPH_ITERATOR [L]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

	WEIGHTED_GRAPH_ITERATOR [C]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

create
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: LABELED_WEIGHTED_GRAPH [L, C]
			-- Anchor for graph types.
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

	node_anchor: LABELED_WEIGHTED_NODE [L, C]
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

	edge_anchor: LABELED_WEIGHTED_EDGE [L, C]
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

	path_anchor: LABELED_WEIGHTED_PATH [L, C]
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_safe_contradiction: Result = Void
		end

end
