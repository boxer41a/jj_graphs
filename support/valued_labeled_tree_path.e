note
	description: "[
		An ordered collection of nodes and edges representing a
		path through a {VALUED_LABLED_TREE}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	VALUED_LABELED_TREE_PATH [V, L]

inherit

	VALUED_LABELED_PATH [V, L]
		redefine
			node_anchor,
			edge_anchor
		end

	VALUED_TREE_PATH [V]
		redefine
			node_anchor,
			edge_anchor
		end

	LABELED_TREE_PATH [L]
		redefine
			node_anchor,
			edge_anchor
		end

create
	make
	
feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_TREE_NODE [V, L]
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

	edge_anchor: VALUED_LABELED_TREE_EDGE [V, L]
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

