note
	description: "[
		A node in a {B_TREE} which holds items of type G.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	B_TREE_NODE [G -> COMPARABLE]

inherit

	VALUED_TREE_NODE [B_TREE_ARRAY [G]]
		rename
			count as edge_count
		redefine
			make_with_order,
			make_with_graph,
--			make_out_edges,
			wipe_out,
			is_empty,
			is_less,
			edges,
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
create
--	default_create,				-- no value, default capacities from like `graph_anchor'
--	make_with_order,			-- no_value, capacities from `a_order'
	make_with_graph,			-- no value, capacities from `a_graph'
--	make_with_value,			-- capacities from like `graph_anchor'
--	make_with_value_and_order,	-- capacities from `order'
	make_with_value_and_graph	-- capacities from `a_graph'

feature {NONE} -- Initialization

	make_with_order (a_order: INTEGER)
			-- Create a node which can initially contain `a_order' number
			-- outgoing edges.
		do
			Precursor (a_order)
			create items.make (a_order - 1)
			items.set_ordered
		end

	make_with_graph (a_graph: like graph_anchor)
			-- Create an instance that is in `a_graph'
			-- Use value from `a_graph' to determine capacity of Current
		do
			tree := a_graph
			Precursor (a_graph)
		ensure then
			tree_assigned: tree = a_graph
		end

--	make_out_edges
--			-- Create `out_edges'
--		do
--			Precursor
--			check attached out_edges as o then
--				o.set_ordered
--			end
--		end

feature -- Access

	tree: like graph_anchor
			-- The one tree in which Current belongs

	maximum_count: INTEGER
			-- The maximum number of item Current can contain (i.e. one less
			-- than the `out_capacity' (the maximum number of out-going edges.
		do
			Result := out_capacity - 1
		ensure
			definition: Result = out_capacity - 1
		end

	minimum_count: INTEGER
			-- The minimum number of items allowed for each internal node.
			-- All nodes except the root must be at least half full.
		do
			Result := (maximum_count // 2) + (maximum_count \\ 2)
		end

	item_count: INTEGER
			-- The number of items in Current
		do
			Result := items.count
		end

	parent_edge: like edge_anchor
			-- The one edge to a parent node
		require
			not_root: not is_root
		do
			Result := in_edges.first
		end

	parent_node: like node_anchor
			-- The node that is the parent for Current
		require
			not_root: not is_root
		do
			Result := in_edges.first.other_node (Current)
		end

	i_th (a_index: INTEGER): like item_anchor
			-- The i_th item in the node
		require
			not_empty: not is_empty
			index_small_enough: a_index <= item_count
			index_big_enough: a_index >= 1
		do
			Result := items.i_th (a_index)
		end

--	value: like value_anchor
--			-- The item in the node to which the cursor points, not really useful here
--		do
--			Result := values.item
--		end

feature -- Status report

	is_full: BOOLEAN
			-- Is the node full?
		do
			Result := items.is_full
		end

	is_empty: BOOLEAN
			-- Does Current contain no items?
		do
			Result := items.is_empty
		end

feature -- Query

	has (a_item: like item_anchor): BOOLEAN
			-- Does Current containt `a_item'
		do
			Result := items.has (a_item)
		end

	seek_node (a_item: like item_anchor): TUPLE [node: like node_anchor; is_found: BOOLEAN]
			-- A tuple containing the leaf node at or below Current in which `a_item'
			-- should reside and a flag, `is_found', that is true if the item was
			-- actually in the node
		local
			n: like node_anchor
			tup: TUPLE [position: INTEGER; is_found: BOOLEAN]
		do
			tup := items.seek_position (a_item)
			if is_leaf then
				Result := [Current, tup.is_found]
			else
				Result := i_th_node (tup.position).seek_node (a_item)
			end
		end

feature -- Basic operations

	extend (a_item: like item_anchor)
			-- Add `a_item' to the node `items'
			-- Can only extend items at a leaf.
		require
			item_exists: a_item /= Void
			at_leaf: is_leaf
		do
			if not is_full then
				items.extend (a_item)
			else
				push_in (a_item)
			end
		ensure
			has_item: has (a_item)
		end

	wipe_out
			-- Remove all items and edges from Current
		do
			Precursor
			items.wipe_out
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if Current = other then
					-- They are the same node (reference equality)
			else

			end
		end

feature {B_TREE_NODE} -- Implementation

	push_in (a_item: like item_anchor)
			-- Push the item into Current when Current `is_full'
			-- This may precipitate a split, push-up, and modification of the
			-- one {B_TREE} in which Current resides
		require
			is_full: is_full
			is_leaf: is_leaf
		local
			p: like node_anchor
			tup: like split
			b, bp: BOOLEAN
		do
			if is_root then
					-- make a new root node
				create p.make_with_graph (tree)
			else
				p := parent_node
			end
--			b := mark_unstable (false)
--			bp := p.mark_unstable (false)
			tup := split (a_item)
			tree.connect_nodes (p, Current)
			p.push_up (tup.median, tup.new_node)
--			b := mark_unstable (b)
--			bp := mark_unstable (bp)
		ensure
			is_stable: not is_unstable
		end

	split (a_item: like item_anchor): TUPLE [median: like item_anchor; new_node: like Current]
			-- Split Current placing the last half of the items into a `new_node'
			-- Return a new `median' value along with the `new_node'
			-- If Current is not a leaf node it will not have enough children nodes,
			-- hence it is marks as `is_unstable'.
		require
			is_full: is_full
		local
			b, nb: BOOLEAN
			comp_v, v: like item_anchor
			new_n: like node_anchor
			n: detachable like node_anchor
			i: INTEGER
		do
			b := mark_unstable (false)
				-- `num' represents the number of items to place in the new node
			create new_n.make_with_graph (tree)
			nb := new_n.mark_unstable (true)
			comp_v := a_item
			from i := 0
			until i >= minimum_count
			loop
					-- We always remove the last item from Current, placing it
					-- into the new node, accounting for `a_item' as we go;
					-- `a_item' may belong in Current or the new node.
					-- We also move one more edge to satisfy the invariant for
					-- the new node.
				if not is_leaf then
						-- Move the edge to the new node using the `tree' to connect it
					n := i_th_node (edge_count)
					tree.disconnect_nodes (Current, n)
					tree.connect_nodes (new_n, n)
				end
					-- Now move the item ...
				v := i_th (item_count)
						-- ... by removing item from Current or use `a_item'
				if comp_v > v then
					new_n.extend (comp_v)
					comp_v := v
				else
					items.go_i_th (item_count)
					items.remove
						-- ... and inserting into the new node
					new_n.extend (v)
				end
				i := i + 1
			end
					-- Now move one more edge if not `is_leaf'
			if not is_leaf then
						-- Move the edge to the new node using the `tree' to connect it
				n := i_th_node (edge_count)
				tree.disconnect_nodes (Current, n)
				tree.connect_nodes (new_n, n)
			end
			nb := new_n.mark_unstable (nb)
				-- Now find the median, removing it from Current if necessary
			v := i_th (item_count)
			if v = comp_v then
				items.go_i_th (item_count)
				items.remove
			end
			Result := [comp_v, new_n]
		ensure
			up_node_is_stable: not Result.new_node.is_unstable
			current_marked_unstable: is_unstable
		end

	push_up (a_item: like item_anchor; a_node: like node_anchor)
			-- Insert `a_item' into Current and make `a_node' a child
			-- This may require Current to split, pushing an item up further.
		require
			not_leaf: not is_leaf
		local
			b: BOOLEAN
			tup: like split
			p: like parent_node
		do
			b := mark_unstable (true)
			if not is_full then
				items.extend (a_item)
				tree.connect_nodes (Current, a_node)
			else
				if is_root then
						-- make a new root node
					create p.make_with_graph (tree)
				else
					p := parent_node
				end
				tup := split (a_item)
				p.push_up (tup.median, tup.new_node)
			end
			b := mark_unstable (b)
		ensure
			mark_restored: is_marked_unstable = old is_marked_unstable
		end

feature {NONE} -- Implementation

	items: JJ_SORTABLE_FIXED_SET [like item_anchor]
			-- The node holds a set of values instead of just one.

--	values_imp: like value
			-- Holds the items, which becomes the value for the `item' in Current

	edges: JJ_SORTABLE_FIXED_SET [like edge_anchor]
			-- The edges terminating or originating at Current
			-- Using three sets (`edges', `in_edges', and `out_edges') for the
			-- edges uses more storage and slightly complicates insertions
			-- and deletions, but other feature are greatly simplified.

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

	graph_anchor: B_TREE [G]
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

	iterator_anchor: B_TREE_ITERATOR [G]
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

invariant

	items_exists: items /= Void
	items_are_sorted: items.is_sorted
	edges_are_sorted: attached out_edges as o implies o.is_sorted

--	in_only_one_graph: graphs.count <= 1
--	one_parent_only: in_edges.count <= 1

	at_least_half_full: (not is_root) implies (item_count >= minimum_count)
	one_more_edge_than_item: (not is_leaf and not is_root) implies edge_count = item_count + 1

	empty_implies_is_root: is_empty implies is_root
	empty_implies_is_leaf: is_empty implies is_leaf

end
