note
	description: "[
		Iterator for a {VALUED_GRAPH}
		]"
	date: "18 Apr 08"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	WEIGHTED_GRAPH_ITERATOR [C -> NUMERIC create default_create end]

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

	cost: C
			-- The `cost' in the last traversed edge.
		require
			not_alpha_beta_sorted: not is_alphabetical
			not_off: not is_off
			not_at_root: not is_at_root
		do
			Result := edge.cost
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: WEIGHTED_GRAPH [C]
			-- Anchor for graph types.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: WEIGHTED_NODE [C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: WEIGHTED_EDGE [C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	path_anchor: WEIGHTED_PATH [C]
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
