note
	description: "[
			A {GRAPH} where each node contain NO data and each
			edge has a `label' and a `cost'
			]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	LABELED_WEIGHTED_GRAPH [L, C -> NUMERIC create default_create end]

inherit

	LABELED_GRAPH [L]
		rename
			has as has_label
		undefine
			iterator,
			node_anchor,
			edge_anchor
		end

	WEIGHTED_GRAPH [C]
		rename
			has as has_cost
		undefine
			iterator,
			last_found_edge,
			found_edge_ref,
			node_anchor,
			edge_anchor
		end

create
	default_create

feature -- Access

	iterator: LABELED_WEIGHTED_GRAPH_ITERATOR [L, C]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_WEIGHTED_NODE [L, C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: LABELED_WEIGHTED_EDGE [L, C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
