note
	description: "[
		An {EDGE} connecting two nodes where each node has a `value'
		of type V and the edge is marked with a `label' of type L.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/valued_labeled_edge.e $"
	date:		"$Date: 2013-01-13 08:58:55 -0500 (Sun, 13 Jan 2013) $"
	revision:	"$Revision: 9 $"

class
	VALUED_LABELED_EDGE [V, L]

inherit

	VALUED_EDGE [V]
		undefine
			is_equal,
			is_less,
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

	LABELED_EDGE [L]
		redefine
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make

feature {NONE} -- Anchors (for covariant redefinitions)

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
