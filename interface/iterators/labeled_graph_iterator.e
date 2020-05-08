note
	description: "[
		Iterator for a {LABELED_GRAPH}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/graphs_618/trunk/graphs/interface/iterators/labeled_graph_iterator.e $"
	date:		"$Date: 2012-07-05 00:31:27 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 13 $"

class
	LABELED_GRAPH_ITERATOR [L]

inherit

	GRAPH_ITERATOR
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

create
	make

feature -- Access

	label: L
			-- The `label' in the last traversed edge.
		require
			not_alpha_beta_sorted: not is_alphabetical
			not_off: not is_off
			not_at_root: not is_at_root
		do
			Result := edge.label
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: LABELED_GRAPH [L]
			-- Anchor for graph types.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: LABELED_NODE [L]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
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
		end

	path_anchor: LABELED_PATH [L]
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
