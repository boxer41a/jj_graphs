note
	description: "[
		A {NODE} which contains data of type V and is connected to
		other nodes with edges that have cost values of type C.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/valued_weighted_node.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	VALUED_WEIGHTED_NODE [V, C -> NUMERIC create default_create end]

inherit

	VALUED_NODE [V]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

	WEIGHTED_NODE [C]
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
	default_create,				-- Same creation routines as for
	make_with_order,			-- {VALUED_NODE}, because the weight
	make_with_graph,				-- is on the edges, not the node.
	make_with_value,
	make_with_value_and_order,
	make_with_value_and_graph

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: VALUED_WEIGHTED_GRAPH [V, C]
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

	node_anchor: VALUED_WEIGHTED_NODE [V, C]
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

	edge_anchor: VALUED_WEIGHTED_EDGE [V, C]
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

	iterator_anchor: VALUED_WEIGHTED_GRAPH_ITERATOR [V, C]
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
