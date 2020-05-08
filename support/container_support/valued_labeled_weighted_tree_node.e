note
	description: "[
		An edge in a tree connecting two nodes where the nodes contain a `value',
		and the edge has a cost and a label
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL:  $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	VALUED_LABELED_WEIGHTED_TREE_NODE [V, L, C -> NUMERIC create default_create end]

inherit

	VALUED_LABELED_TREE_NODE [V, L]
		redefine
			node_anchor,
			edge_anchor,
			graph_anchor,
			iterator_anchor
		end

	VALUED_WEIGHTED_TREE_NODE [V, C]
		redefine
			node_anchor,
			edge_anchor,
			graph_anchor,
			iterator_anchor
		end

	LABELED_WEIGHTED_TREE_NODE [L, C]
		undefine
			is_empty,
			is_less
		redefine
			node_anchor,
			edge_anchor,
			graph_anchor,
			iterator_anchor
		end

	VALUED_LABELED_WEIGHTED_NODE [V, L, C]
		undefine
			make_with_order
		redefine
			node_anchor,
			edge_anchor,
			graph_anchor,
			iterator_anchor
		end

create
	default_create,				-- no value, default capacities from like `graph_anchor'
	make_with_order,			-- no_value, capacities from `a_order'
	make_with_graph,			-- no value, capacities fronm `a_graph'
	make_with_value,			-- capacities from like `graph_anchor'
	make_with_value_and_order,	-- capacities from `order'
	make_with_value_and_graph	-- capacities from `a_graph'

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: VALUED_LABELED_WEIGHTED_TREE [V, L, C]
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

	node_anchor: VALUED_LABELED_WEIGHTED_TREE_NODE [V, L, C]
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

	edge_anchor: VALUED_LABELED_WEIGHTED_TREE_EDGE [V, L, C]
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

	iterator_anchor: VALUED_LABELED_WEIGHTED_TREE_ITERATOR [V, L, C]
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
