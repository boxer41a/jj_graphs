note
	description: "[
		Root class for nodes used in graphs and trees.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2014, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/node.e $"
	date:		"$Date: 2014-08-18 22:48:48 -0400 (Mon, 18 Aug 2014) $"
	revision:	"$Revision: 25 $"

class
	NODE

inherit

	IDENTIFIED			-- `object_id' used by {GRAPH_ITERATOR}.`shortest_paths'
		undefine
			is_equal,
			copy
		redefine
			default_create
		end

	HASHABLE			-- Used in conjuction with {IDENTIFIED}.`object_id' above
		undefine
			is_equal,
			copy
		redefine
			default_create
		end

	COMPARABLE
		redefine
			default_create
		end

	CONTAINER [EDGE]
			-- A node inherits container properties but is implemented
			-- using a client relation through feature `edges'.
		rename
			has as has_edge,
			linear_representation as connections
		undefine
			is_equal,
			copy
		redefine
			default_create
		end

create
	default_create,
	make_with_order,
	make_with_graph

feature {NONE} -- Initialization

	default_create
			-- Creat a node that is not in any graph
		local
			g: like graph_anchor
		do
			create g
			create visitors.make (1)
			make_with_order (g.Default_out_capacity)
		end

	make_with_order (a_order: INTEGER)
			-- Create a node that is not in any graph, that initially has
			-- capacity for `a_order' in and out-going edges.	
		require
			order_big_enough: a_order >= 5
		do
			internal_node_order := a_order
			create visitors.make (1)
			create in_edges.make (a_order)
			create edges.make (2 * a_order)
			create graphs.make (10)
		ensure
			order_set: internal_node_order = a_order
			out_edges_void_until_needed: out_edges = Void
			assume_one_iterator: visitors.capacity = 1
		end

	make_with_graph (a_graph: like graph_anchor)
			-- Create an instance that is in `a_graph'
			-- Use value from `a_graph' to determine capacity of Current
		do
			create visitors.make (1)
			make_with_order (a_graph.initial_out_capacity)
			join_graph (a_graph)
		ensure
			out_edges_void_until_needed: out_edges = Void	-- ?
			assume_one_iterator: visitors.capacity = 1
			in_capacity_dictated_by_graph: in_edges.capacity >= a_graph.initial_in_capacity
		end

feature -- Access

	internal_node_order: INTEGER
			-- Used to determine the capacity of the `out_edges' if there
			-- is no `graph' from which to make the determination.
			-- Set by `make_with_order'

	hash_code: INTEGER
			-- Hash code value
		do
			Result := object_id
		end

feature -- Access

	graph_count: INTEGER
			-- Number of graphs to which Current is visible
		do
			Result := graphs.count
		end

	in_capacity: INTEGER
			-- The number of in-coming edges Current can contain (without resizing)
		do
			Result := in_edges.capacity
		end

	out_capacity: INTEGER
			-- The number of out-going edges Current can contain (without resizing)
		do
			if attached out_edges as oe then
				Result := oe.capacity
			end
		end

	i_th_edge (a_index: INTEGER): like edge_anchor
			-- The child edge connected to Current at the `a_index'th position.
		require
			valid_index: valid_edge_index (a_index)
		do
			Result := edges.i_th (a_index)
		end

	i_th_node (a_index: INTEGER): like node_anchor
			-- The node at the other end of `a_index'th edge.
		require
			valid_edge_index: valid_edge_index (a_index)
		do
			Result := i_th_edge (a_index).other_node (Current)
		ensure
			result_exists: Result /= Void
		end

	i_th_parent_edge (a_index: INTEGER): like edge_anchor
			-- The `a_index'th edge coming into Current
		require
			valid_parent_edge_index: valid_parent_edge_index (a_index)
		do
			Result := in_edges.i_th (a_index)
		end

	i_th_parent_node (a_index: INTEGER): like node_anchor
			-- The parent node at the other end of `a_index'th edge
		require
			valid_parent_edge_index: valid_parent_edge_index (a_index)
		do
			Result := i_th_parent_edge (a_index).other_node (Current)
		end

	i_th_child_edge (a_index: INTEGER): like edge_anchor
			-- The `a_index'th edge leaving Current
		require
			valid_child_edge_index: valid_child_edge_index (a_index)
		do
			check attached out_edges as o then
				Result := o.i_th (a_index)
			end
		end

	i_th_child_node (a_index: INTEGER): like node_anchor
			-- The child node at the other end of `a_index'th edge
		require
			valid_child_edge_index: valid_child_edge_index (a_index)
		do
			check attached out_edges as o then
				Result := o.i_th (a_index).other_node (Current)
			end
		end

	connections: JJ_SORTABLE_SET [like edge_anchor]
			-- A set of all the incoming and outgoing edges.
		do
			Result := edges.twin
		end

	connections_from: JJ_SORTABLE_SET [like edge_anchor]
			-- Set of all outgoing edges
		do
			if attached out_edges as o then
				Result := o.twin
			else
				create Result.make (0)
			end
		end

	connections_to: JJ_SORTABLE_SET [like edge_anchor]
			-- Set of all incoming edges
		do
			Result := in_edges.twin
		end

	related_connections: JJ_SORTABLE_SET [like edge_anchor]
			-- All the edges reachable from Current.
			-- The ancestor, descendent, and cousin edges.
		local
			a_set: like relations
		do
			create Result.make (out_capacity)
			a_set := ancestors
			from a_set.start
			until a_set.is_after
			loop
				Result.merge (a_set.item.descendant_connections)
				a_set.forth
			end
		end

	ancestor_connections: JJ_SORTABLE_SET [like edge_anchor]
			-- All the edges "upward" from Current.
			-- The ancestor edges.
		local
			n: like node_anchor
			e: like edge_anchor
			q: LINKED_QUEUE [like edge_anchor]
			c: like connections
		do
			create Result.make (out_capacity)
			create q.make
				-- put all immediate incoming connections into the queue
			c := connections_to
			from c.start
			until c.is_after
			loop
				q.extend (c.item)
				c.forth
			end
				-- process the edges in the queue until it is empty
			from
			until q.is_empty
			loop
				e := q.item
					-- get the first edge
				if not Result.has (e) then
					Result.extend (e)
						-- now add the connections from the two nodes to the queue
					n := e.node_to
					c := n.connections_to
					from c.start
					until c.exhausted
					loop
						e := c.item
						if not Result.has (e) then
							q.extend (c.item)
						end
						c.forth
					end
				end
				q.remove
			end
		end

	descendant_connections: JJ_SORTABLE_SET [like edge_anchor]
			-- All the edges "downward" from Current.
			-- The descendent edges.
		local
			n: like node_anchor
			n_set: like descendants
			i: INTEGER
		do
			Result := connections_from
			n_set := descendants
			from i := 1
			until i > n_set.count
			loop
				n := n_set.i_th (i)
				Result.merge (n.connections_from)
				i := i + 1
			end
		end

	find_connection (a_node: like node_anchor): detachable like edge_anchor
			-- Get the first edge, if any, that connects Current to `a_node';
			-- Void if there is no edge to `a_node'.
		require
			node_exists: a_node /= Void
		local
			i: INTEGER
			e: like edge_anchor
		do
			from i := 1
			until Result /= Void or else i > count
			loop
				e := i_th_edge (i)
				if e.terminates_at (a_node) then
					Result := e
				end
				i := i + 1
			end
		end

	children: JJ_SORTABLE_SET [like node_anchor]
			-- All the immediate descendents of `Current' node.
		local
			i: INTEGER
			e: like edge_anchor
		do
			create Result.make (out_count)
			from i := 1
			until i > out_count
			loop
				e := i_th_child_edge (i)
				Result.extend (e.other_node (Current))
				Result.finish
				i := i + 1
			end
		end

	parents: JJ_SORTABLE_SET [like node_anchor]
			-- All the (immediate) parent nodes of `Current'
		local
			i: INTEGER
			e: like edge_anchor
		do
			create Result.make (out_capacity)
			from i := 1
			until i > in_count
			loop
				e := in_edges.i_th (i)
				Result.extend (e.other_node (Current))
				i := i + 1
			end
		end

	relations: JJ_SORTABLE_SET [like node_anchor]
			-- All the parents, children, cousins, aunts, etc. of `Current'.
			-- All the nodes reachable from Current.
		local
			a_set: like relations
		do
			create Result.make (out_capacity)
			a_set := ancestors
			from a_set.start
			until a_set.is_after
			loop
				Result.merge (a_set.item.descendants)
				a_set.forth
			end
		end

	ancestors: JJ_SORTABLE_SET [like node_anchor]
			-- List of ancestor nodes
		local
			q: LINKED_QUEUE [like node_anchor]
			ps: like parents
			n: like node_anchor
		do
			create Result.make (out_capacity)
			create q.make
			from q.extend (Current)
			until q.is_empty
			loop
				n := q.item
				q.remove
				if not Result.has (n) then
					Result.extend (n)
					ps := n.parents
					from ps.start
					until ps.exhausted
					loop
						q.extend (ps.item)
						ps.forth
					end
				end
			end
		end

	descendants: JJ_SORTABLE_SET [like node_anchor]
			-- List of descendant nodes
		local
			q: LINKED_QUEUE [like node_anchor]
			ps: like parents
			n: like node_anchor
		do
			create Result.make (out_capacity)
			create q.make
			from q.extend (Current)
			until q.is_empty
			loop
				n := q.item
				q.remove
				if not Result.has (n) then
					Result.extend (n)
					ps := n.children
					from ps.start
					until ps.exhausted
					loop
						q.extend (ps.item)
						ps.forth
					end
				end
			end
		end

feature -- Basic operations

	adopt (a_child: like node_anchor)
			-- Add a connection (EDGE) from Current to `a_child'.
		require
			child_exists: a_child /= Void
			can_adopt: can_adopt (a_child)
		local
			b: BOOLEAN
		do
			io.put_string ("Enter NODE.adopt %N")
			b := mark_unstable (true)
			new_edge.connect (Current, a_child)
			b := mark_unstable (b)
			io.put_string ("Exit NODE.adopt %N")
		ensure
			mark_unchanged: is_marked_unstable = old is_marked_unstable
			connection_exists: has_node (a_child)
			connection_to_exists: has_edge_to (a_child)
			count_increased: count = old count + 1
			out_count_increased: out_count = old out_count + 1
--			in_count_unchanged_unless_cyclic: (a_child /= Current) implies (in_count = old in_count)
			last_new_edge_originates_at_current: last_new_edge.originates_at (Current)
			last_new_edge_terminates_at_a_child: last_new_edge.terminates_at (a_child)
		end

	disown (a_child: like node_anchor)
			-- Ensure there are no connections (EDGEs) from Current to `a_child'.
			-- Opposite of `adopt'.  Removes all edges to `a_child'.
		require
			child_exists: a_child /= Void
		local
			i: INTEGER
			e: EDGE
			b: BOOLEAN
		do
			from i := 1
			until i > count
			loop
				e := i_th_edge (i)
				if e.terminates_at (a_child) then
					b := mark_unstable (true)
					e.disconnect
					b := mark_unstable (b)
				end
				i := i + 1
			end
		ensure
			mark_unchanged: is_marked_unstable = old is_marked_unstable
			not_has_this_child: not has_node (a_child)
		end

	frozen deep_adopt (a_child: like node_anchor)
			-- Adopt `a_child' into Current and into all of the `ancestors' of Current.
			-- In other words, make `a_child' and all its `descendents'
			-- become descendents of Current and all `ancestors'.
		require
			child_exists: a_child /= Void
			can_adopt_children: can_adopt (a_child)
			ancestors_can_adopt: ancestors.for_all (agent {like node_anchor}.can_adopt (a_child))
--			descendents_are_adoptable: (a_child.descendants).for_all (agent {like node_anchor}.is_adoptable)
		local
			a: LINEAR [like node_anchor]
			cd: LINEAR [like node_anchor]
		do
			adopt (a_child)
			a := ancestors
			cd := a_child.descendants
			from a.start
			until a.exhausted
			loop
				a.item.adopt (a_child)
				from cd.start
				until cd.exhausted
				loop
					a.item.adopt (cd.item)
					cd.forth
				end
				a.forth
			end
		ensure
				-- fix/check these post-conditions (too complex?)
			connection_exists: has_node (a_child)
			connection_to_exists: has_edge_to (a_child)
			child_adopted_by_all: ancestors.for_all (agent {like node_anchor}.has_node (a_child))
			child_has_connection_to_all: (a_child.descendants).for_all (agent {like node_anchor}.has_edge_from (Current))
		end

	frozen deep_disown (a_child: like node_anchor)
			-- Make sure neither `a_child' or any of its descendants are
			-- descendants of `Current' or of any descendent of `Current'.
			-- Opposite of `deep_adopt'.
		require
			child_exists: a_child /= Void
		local
			d: LINEAR [like node_anchor]
			cd: LINEAR [like node_anchor]
		do
				-- `Current' disowns `a_child' first
			disown (a_child)
			d := descendants
			cd := a_child.descendants
			from d.start
			until d.exhausted
			loop
					-- Each descendant of `Current' disowns `a_child'
				d.item.disown (a_child)
				from cd.start
				until cd.exhausted
				loop
						-- Each descendant also disowns all descendants of `a_child'
					d.item.disown (cd.item)
					cd.forth
				end
				d.forth
			end
		end

	frozen embrace (a_parent: like node_anchor)
			-- Make `Current' a child of `a_parent' by
			-- creating an edge.  Equivalent
			-- to `a_parent' adopting `Current'.
		require
			parent_exists: a_parent /= Void
			parent_can_adopt: a_parent.can_adopt (Current)
		do
			a_parent.adopt (Current)
		end

	frozen deep_embrace (a_parent: like node_anchor)
			-- Make `Current' and all its descendents children
			-- of `a_parent' and all parent's ancestors.
			-- Equivelant to `a_parent' `deep_adopt'ing Current.
		require
			parent_exists: a_parent /= Void
			parent_can_adopt: a_parent.can_adopt (Current)
--			children_are_adoptable: children.for_all (agent {like node_anchor}.is_adoptable)
--			descendents_can_adopt: (a_parent.descendants).for_all (agent {like node_anchor}.can_adopt)
		do
			a_parent.deep_adopt (Current)
		end

	frozen spurn (a_parent: like node_anchor)
			-- Remove any connections from `a_parent' to `Current'
			-- (as in a child rejecting its parents).
			-- Equivelant to `a_parent' disowning `Current'.
		require
			parent_exists: a_parent /= Void
		do
			a_parent.disown (Current)
		end

	frozen deep_spurn (a_parent: like node_anchor)
			-- Remove any connections from `a_parent' to `Current'
			-- and also remove all the descendants of
			-- `Current' from all the `ancestors' of `a_parent' (as if
			-- a child and all its descendants rejected its parents and
			-- all the parent's ancestors).
			-- Equivelant to `a_parent' `deep_disown'ing `Current'.
		require
			parent_exists: a_parent /= Void
		do
			a_parent.deep_disown (Current)
		end

	wipe_out
			-- Remove all edges from Current node.  (This will also affect
			-- the nodes at the other end of the edges by removing the edge
			-- from the other node as well.)
		local
			e_set: like edges
			e: like edge_anchor
		do
				-- Disconnecting edges will change the `edge_set' so
				-- iterate over a copy of it.
			e_set := edges.deep_twin
			from e_set.start
			until e_set.is_after
			loop
				e := e_set.item
				e.disconnect
				e_set.forth
			end
		ensure
			is_empty: count = 0
		end

	sort
			-- Make sure all the edges in Current are in the proper order.
		do
			edges.sort
			in_edges.sort
			if attached out_edges as o then
				o.sort
			end
		end

feature -- Measurement

	count: INTEGER
			-- The number of edges to and from Current node.
		do
				Result := edges.count
		end

	in_count: INTEGER
			-- Number of edges ending at Current.
		do
			Result := in_edges.count
		end

	out_count: INTEGER
			-- Number of edges originating at Current.
		do
			if attached out_edges as o then
				Result := o.count
			end
		end

feature -- Status report

	is_root: BOOLEAN
			-- Can Current be considerred a root node?
			-- Yes if it has no parents.
		do
			Result := in_count = 0
		end

	is_leaf: BOOLEAN
			-- Does Current have no children?
		do
			Result := out_count = 0
		end

	is_empty: BOOLEAN
			-- Does Current not contain or represent a value?
		do
			Result := False
		end

	is_sorted: BOOLEAN
			-- Are the child edges of Current sorted?
			-- True if there are no child edges.
		do
			Result := edges.is_sorted
		end

	is_ordered: BOOLEAN
			-- Are edges being inserted in order?

	was_visited_by (a_iterator: like iterator_anchor): BOOLEAN
			-- Has Current been visited by `a_iterator'?
		require
			iterator_exists: a_iterator /= Void
		do
			Result := visitors.has (a_iterator)
		end

	is_unstable: BOOLEAN
			-- Is Current in an unstable state were some invariants do not hold?
			-- This occurs during connection and disconnection of contained edges.
		do
			Result := is_marked_unstable or edges.there_exists (agent {like edge_anchor}.is_unstable)
		end

	is_marked_unstable: BOOLEAN
			-- Are connections in a state of flux?
			-- Can occur when edges are being deleted or nodes are being unvisited.
			-- Can also be set by a client using `mark_unstable'.

feature -- Status setting

	join_graph (a_graph: like graph_anchor)
			-- Ensure Current is in `a_graph'
		require
			graph_exists: a_graph /= Void
		do
			if not graphs.has (a_graph.object_id) then
				graphs.extend (a_graph, a_graph.object_id)
			end
			if not a_graph.has_node (Current) then
				a_graph.extend_node (Current)
			end
		ensure
			joined_graph: graphs.has (a_graph.object_id)
			graph_has_node: a_graph.has_node (Current)
		end

	prune_graph (a_graph: like graph_anchor)
			-- Ensure Current is not in `a_graph'
		require
			graph_exists: a_graph /= Void
		do
			if a_graph.has_node (Current) then
				a_graph.prune_node (Current)
			end
			graphs.remove (a_graph.object_id)
		ensure
			not_has_graph: not graphs.has (a_graph.object_id)
			not_graph_has_node: not a_graph.has_node (Current)
		end

	set_ordered
			-- Sort the edges and make future insertions keep edges sorted.
		do
			sort
			edges.set_ordered
			in_edges.set_ordered
			if attached out_edges as o then
				o.set_ordered
			end
			is_ordered := True
		ensure
			is_sorted: is_sorted
			is_inserting_in_order: is_ordered
		end

	set_unordered
			-- Make future insertion put new edges at the end
		do
			edges.set_unordered
			in_edges.set_unordered
			if attached out_edges as o then
				o.set_unordered
			end
			is_ordered := False
		ensure
			not_inserting_in_order: not is_ordered
		end

	mark_unstable (a_mark: BOOLEAN): BOOLEAN
			-- Set `is_unstable' to `a_mark', returning the old value
		do
			Result := is_marked_unstable
			is_marked_unstable := a_mark
		ensure
			definition: is_marked_unstable = a_mark
			valid_result: Result = old is_marked_unstable
		end

feature -- Query

--	valid_graph_index (a_index: INTEGER): BOOLEAN
--			-- Is `a_index' a valid index into the graphs in which Current resides
--		do
--			Result := graphs.valid_index (a_index)
--		end

	valid_edge_index (a_index: INTEGER): BOOLEAN
			-- Is `a_index' a valid index into the child edges?
		do
			Result := edges.valid_index (a_index)
		end

	valid_parent_edge_index (a_index: INTEGER): BOOLEAN
			-- Is `a_index' a valid index into the incoming edges?
		do
			Result := in_edges.valid_index (a_index)
		end

	valid_child_edge_index (a_index: INTEGER): BOOLEAN
			-- Is `a_index' a valid index into the incoming edges?
		do
			if attached out_edges as o then
				Result := o.valid_index (a_index)
			end
		end

	has_edge (a_edge: like edge_anchor): BOOLEAN
			-- Does Current contain `a_edge'?
		do
			Result := edges.has (a_edge)
		end

	has_in_edge (a_edge: like edge_anchor): BOOLEAN
			-- Does Current contain `a_edge' in `in_edges'?
		do
			Result := in_edges.has (a_edge)
		end

	has_out_edge (a_edge: like edge_anchor): BOOLEAN
			-- Does Current contain `a_edge in `out_edges'?
		do
			if attached out_edges as o then
				Result := o.has (a_edge)
			end
		end

	has_node (a_node: like node_anchor): BOOLEAN
			-- Does Current have a connection to or from `a_node'?
		require
			node_exists: a_node /= Void
		local
			e: like edge_anchor
		do
			from edges.start
			until Result or else edges.is_after
			loop
				e := edges.item
				if e.has_connection (a_node) then
					Result := True
				else
					edges.forth
				end
			end
		end

	has_edge_to (a_node: like node_anchor): BOOLEAN
			-- Does Current have a conection to `a_node'?
		require
			node_exists: a_node /= Void
		local
			e: like edge_anchor
		do
			if attached out_edges as o then
				from o.start
				until Result or else o.is_after
				loop
					e := o.item
					if (e.is_directed and e.terminates_at (a_node)) or
						(not e.is_directed and e.has_connection (a_node)) then
						Result := True
					else
						o.forth
					end
				end
			end
		end

	has_edge_from (a_node: like node_anchor): BOOLEAN
			-- Does Current have a conection from `a_node'?
		require
			node_exists: a_node /= Void
		local
			e: like edge_anchor
		do
			from in_edges.start
			until Result or else in_edges.is_after
			loop
				e := in_edges.item
				if (e.is_directed and e.originates_at (a_node)) or
					(not e.is_directed and e.has_connection (a_node)) then
					Result := True
				else
					in_edges.forth
				end
			end
		end

	index_of (a_edge: like edge_anchor): INTEGER
			-- The index of `a_edge' in Current.
		require
			has_edge: has_edge (a_edge)
		local
			i: INTEGER
			found: BOOLEAN
		do
			from i := 1
			until found
			loop
					-- object comparison
				if edges.i_th (i) = a_edge then
					Result := i
					found := True
				end
				i := i + 1
			end
			check
				edge_found: found
						-- because of precondition "has_edge"
			end
		ensure
			result_large_enough: Result >= 0
			result_small_enough: Result <= count
		end

	can_adopt (other: like node_anchor): BOOLEAN
			-- Can this node become a parent of `other'?
			-- True, unless disallowed by a graph in which Current and `other' resides.
		local
			g: like graph_anchor
			i: INTEGER
		do
			Result := True
--			if graph_count > 0 and other.graph_count > 0 then
--					-- if both Current and `other' are in the same graph...
--				from i := 1
--				until i > graph_count or else not Result
--				loop
--					g := graphs.i_th (i)
--					if other.has_graph (g) then
--						Result := g.is_connection_allowed (Current, other)
--					end
--					i := i + 1
--				end
--			end
		end

	is_in_graph (a_graph: like graph_anchor): BOOLEAN
			-- Is Current visible or "in" `a_graph'?
		require
			graph_exists: a_graph /= Void
		do
			Result := graphs.has (a_graph.object_id)
		ensure
			Result implies a_graph.has_node (Current)
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if Current = other then
					-- They are the same node (reference equality)
			else
				if count > other.count then
						-- Bias nodes with more edges to the left (less).
					Result := True
				elseif count = other.count then
						-- Both nodes contain the same number of
						-- edges so check the edges themselves.
					if not is_edges_checked then
						is_edges_checked := True
						Result := check_edges (other)
						is_edges_checked := False
					end
				else
					-- defaults to false
				end
			end
		end

feature {NONE} -- Implementation

	is_edges_checked: BOOLEAN
			-- Has `check_edges' already been called from `infix "<"'?
			-- This is to prevent an infinite loop between the less than features
			-- of GRAPH and EDGE.

	check_edges (other: like node_anchor): BOOLEAN
			-- Used by `<' when `count' equals `other.count'.
			-- If find an edge in `Current' that is not the same edge
			-- as in `other' (reference equallity) then check those
			-- edges to determine which one is less than the other.
		require
			not_same_node: not (other = Current)
			call_only_if_same_degree: count = other.count
		local
			i: INTEGER
			done: BOOLEAN
		do
			from i := 1
			until done or else i > count
			loop
					-- check the edges
				Result := i_th_edge (i) < other.i_th_edge (i)
				done := True
					-- Continue until find a edge that is different, then
					-- check those two edges to determine result.
					-- No need to check for edges being not equal.
					-- The edges can not be the same edge or equal without
					-- originating and terminating at the same nodes.  If
					-- that were the case than the equality of the nodes
					-- would have already been determined and this feature
					-- would not get called.
				i := i + 1
			end
		end

feature {EDGE} -- Implementation (Basic operations)

	is_extendable_edge (a_edge: like edge_anchor): BOOLEAN
			-- Can `a_edge' be `extend'ed into Current?
		do
				-- first ensure the edge has a connection to Current
				-- and that Current doesn't already have this edge.
			Result := not a_edge.is_unstable and then a_edge.has_connection (Current)
					--and then not Current.has_edge (a_edge) -- don't need; using SETs
		end

	make_out_edges
			-- Create `out_edges'
		do
			create out_edges.make (internal_node_order)
		end

	extend_out_edge (a_edge: like edge_anchor)
			-- Ensure `a_edge' is in `out_edges'
			-- Helper routine because `out_edges' may still be Void
		require
			is_extendable_edge: is_extendable_edge (a_edge)
		do
			if not attached out_edges then
				make_out_edges
			end
			check attached out_edges as o then
				o.extend (a_edge)
			end
		end

	extend_edge (a_edge: like edge_anchor)
			-- Ensure `a_edge' is in Current
		require
			is_extendable_edge: is_extendable_edge (a_edge)
		do
			edges.extend (a_edge)
			if a_edge.is_directed then
				if a_edge.originates_at (Current) then
					extend_out_edge (a_edge)
				end
				if a_edge.terminates_at (Current) then
					in_edges.extend (a_edge)
				end
			else
				extend_out_edge (a_edge)
				in_edges.extend (a_edge)
			end
		ensure then
			has_edge: has_edge (a_edge)
			in_correct_set: edges.has (a_edge)
			terinates_here_implication: a_edge.is_directed implies
					(a_edge.terminates_at (Current) implies
					(in_edges.has (a_edge) and not (attached out_edges as o and then o.has (a_edge))))
			originates_here_implication: a_edge.is_directed implies
					(a_edge.originates_at (Current) implies
					(attached out_edges as o and then o.has (a_edge) and not in_edges.has (a_edge)))
		end

	prune_edge (a_edge: like edge_anchor)
			-- Make sure this node does not contain `a_edge'.
			-- It disconnects the nodes from the ends of `a_edge'.
		require
			edge_exists: a_edge /= Void
			has_edge: has_edge (a_edge)
		do
			edges.prune (a_edge)
			in_edges.prune (a_edge)
			if attached out_edges as o then
				o.prune (a_edge)
				if o.is_empty then
					out_edges := Void
				end
			end
			a_edge.disconnect
		ensure
			not_has_edge: not has_edge (a_edge)
			edge_not_connected: a_edge.is_disconnected
		end

feature {GRAPH} -- Implementation

	last_new_edge: like edge_anchor
			-- Last edge that was created when two nodes were connected.
			-- This is a convenience so a connection can be made followed
			-- by manipulation of the new edge.
		do
			check attached {like edge_anchor} edge_ref.edge as e then
				Result := e
			end
		end

	edge_ref: EDGE_REF
			-- Holds a reference to the last created edge created by Current
		once ("OBJECT")
			create Result
		end

--	remove_from_graph (a_graph: like graph_anchor)
--			-- Ensure Current is not in `a_graph'
--		local
--			b: BOOLEAN
--		do
--			b := mark_unstable (true)
--			graphs.prune (a_graph)
--			if a_graph.has_node (Current) then
--				a_graph.prune_node (Current)
--			end
--			b := mark_unstable (b)
--		ensure
--			no_graph: not is_in_graph
--			not_in_graph: not a_graph.has_node (Current)
--		end

feature {NONE} -- Implementation

	graphs: HASH_TABLE [like graph_anchor, INTEGER]
			-- The graphs in which Current resides indexed
			--  by their `object_id' (from IDENTIFIED)

	new_edge: like edge_anchor
			-- Creates a new edge and also makes the Result available
			-- in `last_new_edge'.
		do
			create Result
			edge_ref.set_edge (Result)
		ensure
			last_new_edge_was_set: last_new_edge = Result
		end

feature {GRAPH_ITERATOR} -- Implementation

	edges: JJ_SORTABLE_SET [like edge_anchor]
			-- The edges terminating or originating at Current
			-- Using three sets (`edges', `in_edges', and `out_edges') for the
			-- edges uses more storage and slightly complicates insertions
			-- and deletions, but other feature are greatly simplified.

	in_edges: like edges
			-- The edges terminating at Current

	out_edges: detachable like edges
			-- The edges originating at Current
			-- Leave it Void for leaf nodes of a B-tree for example

	visitors: JJ_ARRAYED_SET [like iterator_anchor]
			-- Iterators that have visited Current

	visit_by (a_iterator: like iterator_anchor)
			-- Have Current record that it has been visited by `a_iterator'
		require
			iterator_exists: a_iterator /= Void
		do
			visitors.extend (a_iterator)
		ensure
			was_visited: was_visited_by (a_iterator)
			referential_integrity: a_iterator.was_node_visited (Current)
		end

	unvisit_by (a_iterator: like iterator_anchor)
			-- Ensure
		require
			iterator_exists: a_iterator /= Void
		do
			visitors.prune (a_iterator)
		ensure
			not_was_visited: not was_visited_by (a_iterator)
			referential_integrity: not a_iterator.is_unstable implies
										not a_iterator.was_node_visited (Current)
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: GRAPH
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	node_anchor: NODE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	edge_anchor: EDGE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	iterator_anchor: GRAPH_ITERATOR
			-- Anchor for features using iterators.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because gives no info; simply used as anchor.
			end
		end

invariant

--	graphs_compares_references: not graphs.object_comparison
	edges_compares_references: not edges.object_comparison
	in_edges_compares_references: not in_edges.object_comparison
	out_edges_compares_references: attached out_edges as o implies not o.object_comparison
	out_edges_exists_implication: attached out_edges as o implies not o.is_empty

--	node_graph_integrity: graphs.for_all (agent {GRAPH}.has_node (Current))

	edges_connected_to_current: across edges as e all
			(not e.item.is_unstable and not is_unstable) implies
				e.item.has_connection (Current) end

	out_or_in_if_edges: across edges as e all
			(not e.item.is_unstable and not is_unstable) implies
				(in_edges.has (e.item) or (attached out_edges as oe and then oe.has (e.item)))
		end

	edges_has_if_out_edges_has: attached out_edges as oe implies across oe as e all
			(not e.item.is_unstable and not is_unstable) implies
				edges.has (e.item) end

	edges_has_if_in_edges_has: across in_edges as e all
			(not e.item.is_unstable and not is_unstable) implies
				edges.has (e.item) end

	set_for_undirected_implication: across edges as e all
			(not e.item.is_unstable and not is_unstable) implies
				(in_edges.has (e.item) and attached out_edges as oe and then oe.has (e.item))
		end

	set_for_directed_implication: across edges as e all
			(not e.item.is_unstable and not is_unstable) implies
				(e.item.is_directed implies
					((e.item.node_from = Current implies attached out_edges as oe and then oe.has (e.item)) and
					(e.item.node_from /= Current implies attached out_edges as oe and then not oe.has (e.item)) and
					(e.item.node_to = Current implies in_edges.has (e.item)) and
					(e.item.node_to /= Current implies not in_edges.has (e.item))))

		end

	node_iterator_integrity: across visitors as c all
					(not c.item.is_unstable implies c.item.was_node_visited (Current)) end

end
