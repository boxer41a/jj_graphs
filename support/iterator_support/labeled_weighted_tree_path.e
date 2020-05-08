note
	description: "[
		An ordered collection of nodes and edges representing a
		path through a {VALUED_WEIGHTED_TREE}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	LABELED_WEIGHTED_TREE_PATH [L, C -> NUMERIC create default_create end]

inherit

	LABELED_WEIGHTED_PATH [L, C]
		redefine
			node_anchor,
			edge_anchor
		end

	LABELED_TREE_PATH [L]
		undefine
			is_less
		redefine
			node_anchor,
			edge_anchor
		end

	WEIGHTED_TREE_PATH [C]
		redefine
			node_anchor,
			edge_anchor
		end

create
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_WEIGHTED_TREE_NODE [L, C]
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

	edge_anchor: LABELED_WEIGHTED_TREE_EDGE [L, C]
			-- Anchor for features using edges.
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
