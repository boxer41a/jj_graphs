note
	description: "[
		An {EDGE} connecting two nodes where each node has a `value'
	 	and the edge has a `cost'.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/valued_weighted_edge.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	VALUED_WEIGHTED_EDGE [V, C -> NUMERIC create default_create end]

inherit

	VALUED_EDGE [V]
		undefine
			default_create,
			is_equal,
			is_less
		redefine
			node_anchor,
			iterator_anchor
		end

	WEIGHTED_EDGE [C]
		undefine
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make

feature {NONE} -- Anchors (for covariant redefinitions)

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
