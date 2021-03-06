note
	description: "[
		A {JJ_TREE} whose nodes contain values of type V and
		whose edges contain labels of type L.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/valued_labeled_tree.e $"
	date:		"$Date: 2014-06-07 00:02:29 -0400 (Sat, 07 Jun 2014) $"
	revision:	"$Revision: 22 $"

class
	VALUED_LABELED_TREE [V, L]

inherit

	VALUED_TREE [V]
		rename
			has as has_value
		undefine
			default_create
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	LABELED_TREE [L]
		rename
			has as has_label
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	VALUED_LABELED_GRAPH [V, L]
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
	default_create,
	make_with_capacity

feature -- Access

	iterator: VALUED_LABELED_TREE_ITERATOR [V, L]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_TREE_NODE [V, L]
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

	edge_anchor: VALUED_LABELED_TREE_EDGE [V, L]
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
