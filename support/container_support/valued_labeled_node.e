note
	description: "[
		A {NONE} which contains data of type V and is connected to
		other nodes with edges that are marked with `labels' of type L.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_LABELED_NODE [V, L]

inherit

	VALUED_NODE [V]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	LABELED_NODE [L]
		undefine
			is_empty,
			is_less,
			is_equal
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
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

	graph_anchor: VALUED_LABELED_GRAPH [V, L]
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

	node_anchor: VALUED_LABELED_NODE [V, L]
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

	edge_anchor: VALUED_LABELED_EDGE [V, L]
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

	iterator_anchor: VALUED_LABELED_GRAPH_ITERATOR [V, L]
			-- Anchor for features using iterators.
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
