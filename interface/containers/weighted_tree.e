note
	description: "[
		A {JJ_TREE} whose edges contain costs of type C.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/weighted_tree.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	WEIGHTED_TREE [C -> NUMERIC create default_create end]

inherit

	JJ_TREE
		undefine
			default_create,
			iterator
		redefine
			node_anchor,
			edge_anchor
		end

	WEIGHTED_GRAPH [C]
		undefine
			default_in_capacity,
			is_extendable_edge,
			is_connection_allowed,
			prune_node,
			prune_edge
--			difference,
--			subtract
		redefine
			node_anchor,
			edge_anchor
		end

create
	default_create

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: WEIGHTED_TREE_NODE [C]
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

	edge_anchor: WEIGHTED_TREE_EDGE [C]
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
