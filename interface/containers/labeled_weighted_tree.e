note
	description: "[
		A {JJ_TREE} whose edges contain labels of type L and costs of type C.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/labeled_weighted_tree.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	LABELED_WEIGHTED_TREE [L, C -> NUMERIC create default_create end]

inherit

	LABELED_TREE [L]
		rename
			has as has_label
		undefine
			default_create,
			last_found_edge,
			found_edge_ref
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	WEIGHTED_TREE [C]
		rename
			has as has_cost
		undefine
			last_found_edge,
			found_edge_ref
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	LABELED_WEIGHTED_GRAPH [L, C]
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

	iterator: LABELED_WEIGHTED_TREE_ITERATOR [L, C]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_WEIGHTED_TREE_NODE [L, C]
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

	edge_anchor: LABELED_WEIGHTED_TREE_EDGE [L, C]
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
