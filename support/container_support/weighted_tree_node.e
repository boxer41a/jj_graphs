note
	description: "[
		An node that can be used in a {WEIGHTED_TREE}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	WEIGHTED_TREE_NODE [C -> NUMERIC create default_create end]

inherit

	WEIGHTED_NODE [C]
		undefine
			make_with_order
		redefine
			make_with_order,
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	TREE_NODE
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
	default_create,		-- Same as {TREE_NODE} because the label only
	make_with_order,	-- applies to edges not the node
	make_with_graph

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: WEIGHTED_TREE [C]
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

	node_anchor: WEIGHTED_TREE_NODE [C]
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

	edge_anchor: WEIGHTED_TREE_EDGE [C]
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

	iterator_anchor: WEIGHTED_TREE_ITERATOR [C]
			-- Anchor for features using iterators.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

end
