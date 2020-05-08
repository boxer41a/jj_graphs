note
	description: "[
			An edge representing a connection between two nodes of
			type {NODE}, for use in a {GRAPH}.
			]"
	author: 	"Jimmy J. Johnson"
	license: 	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: jjj $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/edge.e $"
	date:		"$Date: 2014-08-18 22:48:48 -0400 (Mon, 18 Aug 2014) $"
	revision:	"$Revision: 25 $"

class
	EDGE

inherit

	COMPARABLE
		redefine
			default_create
		end

create
	default_create,
	connect

feature {NONE} -- Default_create

	default_create
			-- Initialize Current
		do
			create traversers.make (5)
			create graphs.make (10)
		end

feature -- Access

	node_from: like node_anchor
			-- Node at one end of edge and anchor for nodes at each end of the edge
		do
			check attached node_from_imp as nf then
				Result := nf
			end
		end

	node_to: like node_anchor
			-- Node at other end of edge and anchor for class.
		do
			check attached node_to_imp as nt then
				Result := nt
			end
		end

	other_node (a_node: like node_anchor): like node_anchor
			-- The node at the opposite end of Current from `a_node'.
			-- Could be `a_node' if Current is cyclic.
		require
			is_connected: is_connected
			good_connection: originates_at (a_node) or else terminates_at (a_node)
		do
			if a_node = node_from then
				Result := node_to
			else
				Result := node_from
			end
		end

feature -- Element change

	connect (a_node_from, a_node_to: like node_anchor)
			-- Sets up a connection between the two nodes after
			-- removing any existing connections.
		require
			node_from_exists: a_node_from /= Void
			node_to_exists: a_node_to /= Void
--			in_same_graph: a_node_from.graph = a_node_to.graph
		do
			io.put_string ("Enter EDGE.connect %N")
			default_create
			connect_node_from (a_node_from)
			connect_node_to (a_node_to)
			if not a_node_from.has_edge (Current) then
				a_node_from.extend_edge (Current)
			end
			if not a_node_to.has_edge (Current) then
				a_node_to.extend_edge (Current)
			end
			io.put_string ("Exit EDGE.connect %N")
		ensure
			connections_made: originates_at (a_node_from) and terminates_at (a_node_to)
			symetrical_connections: a_node_from.has_edge (Current) and a_node_to.has_edge (Current)
			correct_nodes: a_node_from.has_edge_to (a_node_to) and a_node_to.has_edge_from (a_node_from)
		end

	connect_node_from (a_node: like node_anchor)
			-- Make `node_from' reference `a_node'.
		require
			node_exists: a_node /= Void
		do
			if attached node_from_imp as nf then
				nf.prune_edge (Current)
			end
			node_from_imp := a_node
			if not is_unstable then
				a_node.extend_edge (Current)
			end
		ensure
			connection_made: originates_at (a_node)
			symetrical_connection: not is_unstable implies a_node.has_edge (Current)
		end

	connect_node_to (a_node: like node_anchor)
			-- Make `node_to' reference `a_node'
		require
			node_exists: a_node /= Void
		do
			if attached node_to_imp as nt then
				nt.prune_edge (Current)
			end
			node_to_imp := a_node
			if not is_unstable then
				a_node.extend_edge (Current)
			end
		ensure
			connection_made: terminates_at (a_node)
			symetrical_connection: not is_unstable implies a_node.has_edge (Current)
		end

	disconnect
			-- Remove the nodes from the ends of the edge.
			-- Also, removes the edge from the two nodes.
		require
			is_connected: is_connected
		do
			if attached node_from_imp as nf and then nf.has_edge (Current) then
				nf.prune_edge (Current)
			end
			if attached node_to_imp as nt and then nt.has_edge (Current) then
				nt.prune_edge (Current)
			end
			node_from_imp := Void
			node_to_imp := Void
		ensure
			is_disconnected: is_disconnected
		end

feature -- Status report

	is_connected: BOOLEAN
			-- True if both ends of edge is connected to a node.
		do
			Result := node_from_imp /= Void and node_to_imp /= Void
		end

	is_disconnected: BOOLEAN
			-- True if both ends of edge is not connected to a node.
		do
			Result := node_from_imp = Void and node_to_imp = Void
		end

	is_unstable: BOOLEAN
			-- Is the edge in an unstable state?  That is, does the
			-- edge have a node at one end but not the other?
		do
			Result := not (is_connected or is_disconnected)
		end

	is_directed: BOOLEAN
			-- Is the edge directed?  Can the edge only be traversed in
			-- one direction, from the `node_from' to `node_to'?

	is_cyclic: BOOLEAN
			-- Does this edge start and end at the same node?
		do
			Result := is_connected and then node_from = node_to
		ensure
			definition: Result = (is_connected and then node_from = node_to)
		end

feature -- Status setting

	set_directed
			-- Make the edge a "directed" edge by making `is_directed' True.
		do
			is_directed := True
		ensure
			is_directed: is_directed
		end

	set_undirected
			-- Make the edge "undirected" by making `is_directed' False.
		do
			is_directed := False
		ensure
			not_is_directed: not is_directed
		end

	join_graph (a_graph: like graph_anchor)
			-- Ensure Current is in `a_graph'
		require
			graph_exist: a_graph /= Void
		do
			if not graphs.has (a_graph.object_id) then
				graphs.extend (a_graph, a_graph.object_id)
			end
			if not a_graph.has_edge (Current) then
				a_graph.extend_edge (Current)
			end
		ensure
			joined_graph: graphs.has (a_graph.object_id)
			graph_has_edge: a_graph.has_edge (Current)
		end

feature -- Query

	originates_at (a_node: like node_anchor): BOOLEAN
			-- Does the edge start at `a_node'?
		do
			Result := node_from = a_node
		end

	terminates_at (a_node: like node_anchor): BOOLEAN
			-- Does the edge end at `a_node'?
		do
			Result := node_to = a_node
		end

	has_connection (a_node: like node_anchor): BOOLEAN
			-- Does this edge connect to `a_node'?
			-- Can you traverse the edge from Current to `a_node'?
		do
			Result := terminates_at (a_node) or originates_at (a_node)
		end

	was_traversed_by (a_iterator: like iterator_anchor): BOOLEAN
			-- Has Current been traversed by `a_iterator'
		require
			iterator_exists: a_iterator /= Void
		do
			Result := traversers.has (a_iterator)
		end

	is_in_graph (a_graph: like graph_anchor): BOOLEAN
			-- Is Current in `a_graph' and therefore visible to traversals?
		do
			Result := graphs.has (a_graph.object_id)
		end

feature -- Comparison

		is_less alias "<" (other: like Current): BOOLEAN
			-- Is Current less than other?
		do
			if Current = other then
					-- They are the same edge (reference equality)
					-- Defaults to False.
			else
					-- Must check if the edges are connected (i.e. do they
					-- each have nodes at both ends?  See `is_connected'.)
					-- The normal state of an edge is to have a node at each
					-- end, but the order of creation or destruction could
					-- temporarily disrupt this state.  (See class invariant.)
				if is_connected and other.is_connected then
						-- Both edges are connected to two nodes.
						-- Therefore, proceed to check the values in the edges.
					Result := check_nodes (other)
				elseif is_connected and not other.is_connected then
						-- One or both of the ends of the other edge is not
						-- connected to a node, so the other edge goes to
						-- infinity.  Therefore, `Current' must be < `other'.
					Result := True
				elseif not is_connected and other.is_connected then
						-- One or both of the ends of the current edge is not
						-- connected to a node, so the other edge goes to
						-- infinity.  Therefore, `other' is < `Current'.
						-- Defaults to False (i.e. not less than).
				else
						-- Both are NOT connected and therefore both are infinite.
						-- Defaults to False (i.e. not less than).
				end
			end
		end

feature {NONE} -- Implementation

	check_nodes (other: like Current): BOOLEAN
				-- When checking the nodes (`node_from' and then `node_to') of
				-- Current and `other', is the nodes of Current less than
				-- the nodes of `other'?
				-- Used by `is_less'.
		require
			other_exists: other /= Void
			current_is_connected: is_connected
			other_is_connected: other.is_connected
		do
			Result := node_from < other.node_from or else
					(equal (node_from, other.node_from) and node_to < other.node_to)
		end

feature {GRAPH_ITERATOR} -- Implementation

	traversers: JJ_ARRAYED_SET [like iterator_anchor]
			-- Iterators that have traversed Current

	traverse_by (a_iterator: like iterator_anchor)
			-- Have Current record that it has been traversed by `a_iterator'
		require
			iterator_exists: a_iterator /= Void
		do
			traversers.extend (a_iterator)
		ensure
			was_traversed: was_traversed_by (a_iterator)
			referential_integrity: not a_iterator.is_unstable implies
										a_iterator.was_edge_traversed (Current)
		end

	untraverse_by (a_iterator: like iterator_anchor)
			-- Ensure Current is not marked as having been
			-- traversed by `a_iterator'
		require
			iterator_exists: a_iterator /= Void
		do
			traversers.prune (a_iterator)
		ensure
			not_traversed: not was_traversed_by (a_iterator)
			referential_integrity: not a_iterator.is_unstable implies
										not a_iterator.was_edge_traversed (Current)
		end


feature {NONE} -- Implementation

	node_from_imp: detachable like node_anchor
			-- Implementation for `node_from' to allow detachable

	node_to_imp: detachable like node_anchor
			-- Implementaion for `node_to' to allow detachable

	graphs: HASH_TABLE [like graph_anchor, INTEGER]
			-- Teh graphs in which CUrrent resides, indexed
			-- by their `object_id' (from IDENTIFIED)

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

	iterator_anchor: GRAPH_ITERATOR
			-- Anchor for features using iterators.
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

invariant

	unstable_definition: is_unstable implies
						((node_from_imp = Void and node_to_imp /= Void) or else
						(node_from_imp /= Void and node_to_imp = Void))
	stable_definition: not is_unstable implies
						((node_from_imp /= Void and node_to_imp /= Void) or else
						(node_from_imp = Void and node_to_imp = Void))

		-- The next invariant says, "If Current has a stable node at each end, then
		-- each of those nodes has Current as an edge.  Furthermore, if Current
		-- `is_directed' then the `node_from' must have Current in its out-going
		-- edge set and not in its incoming edge set.  Conversely for the `node_to'.
		-- If Current is not directed then the nodes place Current into both the
		-- outgoing and income edge sets.  (See {NODE}.)

 	is_directed_implication: (is_connected and
 							not node_from.is_unstable and not node_to.is_unstable) implies
 								(is_directed implies
									(node_from.has_out_edge (Current) and
									node_to.has_in_edge (Current)))

 	not_is_directed_implication: (is_connected and
 							not node_from.is_unstable and not node_to.is_unstable) implies
 								(not is_directed implies
								(node_from.has_out_edge (Current) and
								node_from.has_in_edge (Current) and
								node_to.has_out_edge (Current) and
								node_to.has_in_edge (Current)))

	edge_iterator_integrity: across traversers as c all
					(not c.item.is_unstable implies c.item.was_edge_traversed (Current)) end


end
