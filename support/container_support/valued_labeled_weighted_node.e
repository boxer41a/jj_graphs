note
	description: "[
		A {NODE} which contains a `value' and is connected to
		other nodes where the edges are marked with a `label'
		and have a `cost'.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/valued_labeled_weighted_node.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	VALUED_LABELED_WEIGHTED_NODE [V, L, C -> NUMERIC create default_create end]

inherit

	VALUED_LABELED_NODE [V, L]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	VALUED_WEIGHTED_NODE [V, C]
		undefine
			is_less
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	LABELED_WEIGHTED_NODE [L, C]
		undefine
			is_empty,
			is_less,
			is_equal,
			is_sorted,
			sort
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
create
	default_create,				-- Same creation routines as for
	make_with_order,			-- {VALUED_NODE}, because the weight
	make_with_graph,				-- is on the edges, not the node.
	make_with_value,
	make_with_value_and_order,
	make_with_value_and_graph


feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: VALUED_LABELED_WEIGHTED_GRAPH [V, L, C]
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

	node_anchor: VALUED_LABELED_WEIGHTED_NODE [V, L, C]
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

	edge_anchor: VALUED_LABELED_WEIGHTED_EDGE [V, L, C]
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

	iterator_anchor: VALUED_LABELED_WEIGHTED_GRAPH_ITERATOR [V, L, C]
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
