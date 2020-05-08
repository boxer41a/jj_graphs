note
	description: "[
		A {GRAPH} that acts as a rooted tree.
		The tree can only be built by adding onto nodes that are already in the tree.
		In other words, the tree grows down by connecting a node as a child to a
		node that is already in the tree or up by connecting a parent to the one root 
		node in the tree.  Nodes or edges can be removed, which will remove all descendent
		nodes as well.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2013, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/interface/containers/jj_tree.e $"
	date:		"$Date: 2014-06-07 00:02:29 -0400 (Sat, 07 Jun 2014) $"
	revision:	"$Revision: 22 $"

class
	JJ_TREE

inherit

	GRAPH
--		export
--			{JJ_TREE}
--				extend_node,
--				deep_extend_node
		redefine
			Default_in_capacity,
			is_extendable_edge,
			is_connection_allowed,
			prune_node,
			prune_edge,
--			difference,
--			subtract,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make_with_capacity

feature -- Access

	root_node: like node_anchor
			-- The one node in Current that has no parent
		require
			not_empty: not is_empty
		do
				-- Pick any node and go up
			from Result := nodes.i_th (1)
			until Result.is_root
			loop
				check attached Result.parent as p then
					Result := p
				end
			end
		end

feature -- Measurement

	Default_in_capacity: INTEGER = 1
			-- The number of edges that nodes created in Current
			-- can initially contain by default

feature -- Basic operations

	extend_root_node (a_node: like node_anchor)
			-- Add `a_node' as the `root_node' of Current, but only if Current is empty
			-- This allows a tree with only one node; other nodes must be added
			-- using the `connect_nodes' or `extend_edge' features.
		require
			is_empty: is_empty
		do
			extend_node (a_node)
		end

	prune_node (a_node: like node_anchor)
			-- Remove `a_node' and its edges from the tree.
			-- This will also remove all the descendents.
		local
			e_set: JJ_SORTABLE_SET [like edge_anchor]
			e: like edge_anchor
		do
			if is_root (a_node) then
				wipe_out
			elseif has_node (a_node) then
					nodes.prune (a_node)
					e_set := a_node.descendant_connections
					from e_set.start
					until e_set.exhausted
					loop
						e := e_set.item
						nodes.prune (e.node_to)
						nodes.prune (e.node_from)
						edges.prune (e)
						e_set.forth
					end
				edges.prune (parent_edge (a_node))
			end
		end

	prune_edge (a_edge: like edge_anchor)
			-- Remove `a_edge' and nodes below this edge from the tree.
		do
			prune_node (a_edge.node_to)
		end

--	subtract (other: like Current)
--			-- Remove all the nodes and edges in `other' from Current.
--		do
--			from other.nodes_imp.start
--			until other.nodes_imp.exhausted
--			loop
--				prune_node (other.nodes_imp.item)
--				other.nodes_imp.forth
--			end
--		end

--	difference alias "-" (other: like Current): like Current
--			-- A graph consisting of Current minus all the nodes and edges in `other'
--		do
--			Result := deep_twin
--			Result.subtract (other)
--		end

feature -- Query

	is_extendable_edge (a_edge: like edge_anchor): BOOLEAN
			-- Can `a_edge' be extended into Current?
			-- True if `a_edge' is not Void and not `is_unstable' and not already in Current.
			-- Also, one and only one of the nodes must already be in the tree, and
			-- the one in the tree must maintain an in_count <= 1.
		do
			Result := Precursor (a_edge) and
					is_connection_allowed (a_edge.node_from, a_edge.node_to)
		end

	is_connection_allowed (a_node, a_other_node: like node_anchor): BOOLEAN
			-- Is Current allowed to make a connection between the two nodes?
			-- False if `a_other_node' (the node with the incoming edge) is already
			-- in the tree and adding this connection will make it have two parents.
		do
			Result := Precursor (a_node, a_other_node) and a_node /= a_other_node
			Result := Result and (has_node (a_node) or has_node (a_other_node)) and
					a_other_node.in_count = 0
		end

	children_edges (a_node: like node_anchor): JJ_SORTABLE_SET [like edge_anchor]
			-- The edges leaving `a_node' that are "in" Current
		require
			node_exists: a_node /= Void
		local
			e: like edge_anchor
			i: INTEGER
		do
			create Result.make (a_node.out_capacity)
			from i := 1
			until i > a_node.out_count
			loop
				e := a_node.i_th_child_edge (i)
				if has_edge (e) then
					Result.extend (e)
				end
				i := i + 1
			end
		ensure
			contains_nodes_edge_implication: Result.count > 0 implies has_node (a_node)
		end

	parent_edge (a_node: like node_anchor): like edge_anchor
			-- The one edge coming into `a_node' that is "in" Current
		require
			has_node: has_node (a_node)
			not_a_root: not is_root (a_node)
		local
			i: INTEGER
			e: detachable like edge_anchor
		do
			from i := 1
			until attached e
			loop
				e := a_node.i_th_parent_edge (i)
				if has_edge (e) then
					Result := e
				end
				i := i + 1
			end
			check attached e as r then
				Result := r
			end
		ensure
			result_exists: Result /= Void
		end

	parent (a_node: like node_anchor): like node_anchor
			-- The node at the end of the `parent_edge'
		require
			has_node: has_node (a_node)
			not_a_root: not is_root (a_node)
		do
			Result := parent_edge (a_node).other_node (a_node)
		end

	children (a_node: like node_anchor): JJ_SORTABLE_SET [like node_anchor]
			-- The immediate descendents of `a_node' that are "in" Current
		require
			node_exists: a_node /= Void
		local
			n: like node_anchor
			i: INTEGER
		do
			create Result.make (a_node.out_capacity)
			from i := 1
			until i > a_node.out_count
			loop
				n := a_node.i_th_child_node (i)
				if has_node (n) then
					Result.extend (n)
				end
				i := i + 1
			end
		end

	ancestors (a_node: like node_anchor): JJ_SORTABLE_SET [like node_anchor]
			-- All the ancestors of `a_node' that are "in" Current,
			-- not including `a_node'
		require
			node_exists: a_node /= Void
		local
			n: like node_anchor
		do
			create Result.make (a_node.out_capacity)
			if has_node (a_node) then
				from n := a_node
				until is_root (n)
				loop
					n := parent (n)
					check
						no_cycle_allowed: not Result.has (n)
							-- because of invariant
					end
					Result.extend (n)
				end
			end
		ensure
			node_is_root_implication: is_root (a_node) implies Result.is_empty
		end

	descendants (a_node: like node_anchor): JJ_SORTABLE_SET [like node_anchor]
			-- The descendent nodes of `a_node' that are "in" Current
		require
			node_exists: a_node /= Void
		local
			q: LINKED_SET [like node_anchor]
			n: like node_anchor
		do
			create Result.make (a_node.out_capacity)
			create q.make
			from q.merge (children (a_node))
			until q.is_empty
			loop
				q.go_i_th (1)
				n := q.item
				q.remove
				Result.extend (n)
				q.merge (children (n))
			end
		end

	is_root (a_node: like node_anchor): BOOLEAN
			-- Is `a_node' the root and in Current?
			-- If none of the edges coming into `a_node' are in Current, then
			-- from Current's viewpoint, `a_node' is the root.
		require
			node_exists: a_node /= Void
		local
			i: INTEGER
			e: like edge_anchor
		do
			if has_node (a_node) then
				Result := True
				from i := 1
				until i > a_node.in_count or not Result
				loop
					e := a_node.i_th_parent_edge (i)
					if has_edge (e) then
						Result := False
					end
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation (invariant checking)

	any_node_has_two_parents: BOOLEAN
			-- Does any node in `nodes' have more than one incoming
			-- edge that is visible to Current?
			-- Should always be False
		local
			i, c: INTEGER
			n: like node_anchor
		do
			from nodes.start
			until nodes.exhausted or Result
			loop
				c := 0
				n := nodes.item
				from i := 1
				until i > n.in_count or Result
				loop
					if has_edge (n.i_th_parent_edge (i)) then
						c := c + 1
						Result := c > 1
					end
					i := i + 1
				end
				nodes.forth
			end
		end

	has_cycle: BOOLEAN
			-- Does Current contain a cycle?
			-- It should not
		local
			ns: like nodes
			n: like node_anchor
			checked: LINKED_SET [like node_anchor]
			ancests: LINKED_SET [like node_anchor]
		do
			create checked.make
			create ancests.make
			ns := nodes
			from ns.start
			until ns.is_after or Result
			loop
				n := nodes.item
				if not checked.has (n) then
					checked.extend (n)
					from ancests.wipe_out
					until is_root (n) or Result
					loop
						n := parent (n)
						Result := ancests.has (n)
						ancests.extend (n)
					end
				end
				ns.forth
			end
		end

	has_multiple_roots: BOOLEAN
			-- Does Current have more than one node that does not have a parent?
		local
			i: INTEGER
			c: INTEGER
			ns: like nodes
		do
			ns := nodes
			from ns.start
			until ns.is_after or c > 1
			loop
				if ns.item.in_count = 1 then
					c := c + 1
				end
				ns.forth
			end
		end

feature {NONE} -- Anchors (for covariant redefinitions)

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

	leaf_node_anchor: TREE_NODE
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

--	iterator_anchor: TREE_ITERATOR
--			-- Anchor for features using iterators.
--			-- Not to be called; just used to anchor types.
--			-- Declared as a feature to avoid adding an attribute.
--		require else
--			not_callable: False
--		do
--			check
--				do_not_call: False then
--					-- Because gives no info; simply used as anchor.
--			end
--		end


invariant

	initial_in_capacity_constant: initial_in_capacity = 1

	only_one_root: not has_multiple_roots
	only_one_parent_per_node: not any_node_has_two_parents
	no_cycles: not has_cycle


end
