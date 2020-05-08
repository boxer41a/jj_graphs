note
	description: "[
		An ordered collection of nodes and edges representing a
		path through a {VALUED_LABLED_WEIGHTED_TREE}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	VALUED_LABELED_WEIGHTED_TREE_ITERATOR [V, L, C -> NUMERIC create default_create end]

inherit

	VALUED_LABELED_TREE_ITERATOR [V, L]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

	VALUED_WEIGHTED_TREE_ITERATOR [V, C]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

	LABELED_WEIGHTED_TREE_ITERATOR [L, C]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

	VALUED_LABELED_WEIGHTED_GRAPH_ITERATOR [V, L, C]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

create
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: VALUED_LABELED_WEIGHTED_TREE [V, L, C]
			-- Anchor for graph types.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: VALUED_LABELED_WEIGHTED_TREE_NODE [V, L, C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: VALUED_LABELED_WEIGHTED_TREE_EDGE [V, L, C]
			-- Anchor for features using edges.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	path_anchor: VALUED_LABELED_WEIGHTED_TREE_PATH [V, L, C]
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


