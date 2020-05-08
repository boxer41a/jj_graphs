note
	description: "[
			A {JJ_TREE} whose nodes contain data of type V.
			]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/valued_tree.e $"
	date:		"$Date: 2014-01-29 09:01:31 -0500 (Wed, 29 Jan 2014) $"
	revision:	"$Revision: 19 $"

class
	VALUED_TREE [V]

inherit

	JJ_TREE
		undefine
			default_create,
			iterator
		redefine
			node_anchor,
			edge_anchor
		end

	VALUED_GRAPH [V]
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
	default_create,
	make_with_capacity

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_TREE_NODE [V]
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

	edge_anchor: VALUED_TREE_EDGE [V]
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
