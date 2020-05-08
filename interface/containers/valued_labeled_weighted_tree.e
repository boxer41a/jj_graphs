note
	description: "[
		A {JJ_TREE} whose nodes contains values of type V and whose
		edges contain labels of type L and costs of type C.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/valued_labeled_weighted_tree.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	VALUED_LABELED_WEIGHTED_TREE [V, L, C -> NUMERIC create default_create end]

inherit

	VALUED_LABELED_TREE [V, L]
		undefine
			last_found_edge,
			found_edge_ref
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	VALUED_WEIGHTED_TREE [V, C]
		undefine
			last_found_edge,
			found_edge_ref
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	LABELED_WEIGHTED_TREE [L, C]
		undefine
			last_found_edge,
			found_edge_ref
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	VALUED_LABELED_WEIGHTED_GRAPH [V, L, C]
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

	iterator: VALUED_LABELED_WEIGHTED_TREE_ITERATOR [V, L, C]
			-- Create a new iterator for accessing the nodes and edges in Current.
			-- Anchor for the graph iterators.
		do
			create Result.make (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_WEIGHTED_TREE_NODE [V, L, C]
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
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
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end