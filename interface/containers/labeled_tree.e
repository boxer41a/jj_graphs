note
	description: "[
		A {JJ_TREE} whose edges contain labels of type L.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/labeled_tree.e $"
	date:		"$Date: 2014-01-29 09:01:31 -0500 (Wed, 29 Jan 2014) $"
	revision:	"$Revision: 19 $"

class
	LABELED_TREE [L]

inherit

	JJ_TREE
		undefine
			default_create
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	LABELED_GRAPH [L]
		undefine
			default_in_capacity,
			is_extendable_edge,
			is_connection_allowed,
			prune_node,
			prune_edge
--			difference,
--			subtract
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create

feature -- Access

	iterator: LABELED_TREE_ITERATOR [L]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_TREE_NODE [L]
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

	edge_anchor: LABELED_TREE_EDGE [L]
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
