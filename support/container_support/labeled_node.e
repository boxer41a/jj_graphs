note
	description: "[
		Used as nodes at the ends of a {LABELED_EDGE} for use in a {LABELED_GRAPH}.
		The edge connecting these nodes has a `label' of type L.
		]"
	author: 	"Jimmy J. Johnson"
	license: 	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/labeled_node.e $"
	date:		"$Date: 2014-06-07 00:02:29 -0400 (Sat, 07 Jun 2014) $"
	revision:	"$Revision: 22 $"

class
	LABELED_NODE [L]

inherit

	NODE
		redefine
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
	default_create,		-- Same as {NODE} because the label only
	make_with_order,	-- applies to edges not the node
	make_with_graph

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_NODE [L]
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

	edge_anchor: LABELED_EDGE [L]
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

	iterator_anchor: LABELED_GRAPH_ITERATOR [L]
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
