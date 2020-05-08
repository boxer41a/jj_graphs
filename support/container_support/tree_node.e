note
	description: "[
		A {NODE} that can be used in a {TREE}
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: $"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	TREE_NODE

inherit

	NODE
		redefine
			make_with_order,
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
	default_create,
	make_with_order,
	make_with_graph

feature {NONE} -- Initialization

	make_with_order (a_order: INTEGER)
			-- Create a node that is not in any graph, that initially has
			-- capacity for `a_order' in and out-going edges.
			-- Redefined, because trees should only have one incoming edge.
		do
			Precursor (a_order)
			create in_edges.make (1)
		end

feature -- Access

	parent: like node_anchor
			-- The parent of this node
		require
			not_root: not is_root
		do
			Result := i_th_parent_node (1)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: JJ_TREE
			-- Anchor for features using graphs.
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

	node_anchor: TREE_NODE
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

	edge_anchor: TREE_EDGE
			-- Anchor for features using edges.
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

	iterator_anchor: TREE_ITERATOR
			-- Anchor for features using iterators.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

invariant

	in_capacity_of_one: in_edges.capacity = 1

end
