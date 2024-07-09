note
	description: "[
		Implementation of a B-tree
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	B_TREE [G -> COMPARABLE]

inherit

	VALUED_TREE [B_TREE_ARRAY [G]]
		rename
			is_empty as jj_tree_is_empty,
			wipe_out as jj_tree_wipe_out,
			extend as valued_tree_extend
		export
			{NONE}
				jj_tree_wipe_out
		redefine
			default_create,
			changeable_comparison_criterion,
--			extend,
			node_anchor,
			edge_anchor,
			value_anchor
		end

create
	default_create,
	make_with_capacity

feature {NONE} -- Initialization

	default_create
			-- Initializ Current with nodes containing `default_out_capacity' number of edges
		local
			n: like node_anchor
		do
			Precursor
			create n.make_with_graph (Current)
		end

feature -- Access

--	minimum_out_capacity: INTEGER
--			-- The minimum number of out-going edges allowed when creating nodes
--		do
--			Result := {B_TREE_NODE [G]}.minimum_out_capacity
--		end

feature -- Status setting

	changeable_comparison_criterion: BOOLEAN
			-- May object_comparison be changed?
			-- Yes, if Current `is_empty', because if not
			-- the ordering may become invalidated.
		do
			Result := is_empty
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Does Current contain no items?
		do
			Result := root_node.value.is_empty
		end

feature -- Basic operations

	extend (a_item: like item_anchor)
			-- Add `a_item' to the tree
		require
			item_exists: a_item /= Void
		local
			n: like node_anchor
		do
			n := root_node.seek_node (a_item).node
			check
				found_a_leaf_node: n.is_leaf
					-- because that is what `seek_node' is supposed to do
			end
			n.extend (a_item)
		end

	show
			-- Display the tree for testing
		local
			q: LINKED_QUEUE [like node_anchor]
			n: like node_anchor
			i: INTEGER
			v: like item_anchor
		do
			create q.make
			q.extend (root_node)
			from q.extend (root_node)
			until q.is_empty
			loop
				n := q.item
				q.remove
					-- Indent based on node's level in tree
				from i := 1
				until i > n.ancestor_connections.count
				loop
					io.put_string ("%T")
					i := i + 1
				end
					-- Output the items in the node
				from i := 1
				until i > n.item_count
				loop
					v := n.i_th (i)
					io.put_string (v.out)
					if i < n.item_count then
						io.put_string (", ")
					end
					i := i + 1
				end
					-- Add children nodes to the queue
				io.new_line
				from i := 1
				until i > n.out_count
				loop
					q.extend (n.i_th_child_node (i))
					i := i + 1
				end
			end
		end

feature {B_TREE_NODE} -- Implementation

--	first_node_imp: detachable like first_node
--			-- To get around Void-safety issue of an attribute needing
--			-- Current during creation

	new_node: like node_anchor
			-- Create a new empty node as a leaf
		do
			create Result.make_with_graph (Current)
		end

	new_leaf_node: like node_anchor
			-- Create a new empty node as a leaf
		do
			create Result.make_with_graph (Current)
		end


feature {NONE} -- Anchors (for covariant redefinitions)

	item_anchor: G
			-- Anchor for features using the items in the tree.
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

	node_anchor: B_TREE_NODE [G]
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

	edge_anchor: B_TREE_EDGE [G]
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

--	value_anchor: G
	value_anchor: B_TREE_ARRAY [G]
			-- Anchor for features using the items in the node.
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

invariant

	has_root_node: not jj_tree_is_empty

end
