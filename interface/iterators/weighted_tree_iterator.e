note
	description: "[
		Iterator for a {WEIGHTED_TREE}
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	WEIGHTED_TREE_ITERATOR [C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	TREE_ITERATOR
		undefine
			path_anchor
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor
--			path_anchor
		end

	WEIGHTED_GRAPH_ITERATOR [C]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: WEIGHTED_TREE [C]
			-- Anchor for graph types.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: WEIGHTED_TREE_NODE [C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: WEIGHTED_TREE_EDGE [C]
			-- Anchor for features using edges.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	path_anchor: WEIGHTED_TREE_PATH [C]
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

