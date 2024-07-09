note
	description: "[
		An ordered collection of edges beginning at a `start_node'.
		Edges can only be added and removed from the end.
		This is to be used with a {GRAPH}.
		]"
	author:		"Jimmy J. Johnson"
	date:		"8/21/1"

class
	WALK

inherit

	SHARED
		undefine
			default_create,
			is_equal,
			copy
		end

	HASHABLE
		undefine
			is_equal,
			copy
		redefine
			default_create
		end

	COMPARABLE
		redefine
			default_create,
			copy	,			-- Required (called by `twin')
			is_equal
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	default_create
			-- Create an instance that `is_empty'
		do
			hash_code := uuid_generator.generate_uuid.hash_code
			create path_imp.make (Default_size)
--			create explorers.make (1)
		ensure then
			is_empty: is_empty
		end

	make (a_node: like node_anchor)
			-- Create an instance where `first_node' is `a_node'
			-- and having zero edges.
		require
			node_exists: a_node /= Void
		do
			default_create
			set_first_node (a_node)
		ensure
			not_empty: not is_empty
			first_node_set: first_node = a_node
		end

feature -- Access

	hash_code: INTEGER
			-- Assigned in `default_create

	frozen cost: like recomputed_cost
			-- The price of exploring Current
			-- The default returns the number of edges
			-- Redefine `recompute_cost' assigning result to `cost_imp'
			-- to change symantics of this feature.
		do
				-- Memoize the calculation
			if is_dirty then
				Result := recomputed_cost
				set_clean
			else
				Result := cost_imp
			end
		end

	last_edge: like edge_anchor
			-- The last edge.
		require
			has_edges: edge_count >= 1
		do
			Result := path_imp.last
		end

	first_node: like node_anchor
			-- Node at which this path starts.
		require
			not_empty: not is_empty
		do
			check attached first_node_imp as n then
				Result := n
			end
		end

	last_node: like node_anchor
			-- The last node in the path.
		do
			Result := i_th_node (node_count)
		ensure
			result_exists: Result /= Void
		end

	i_th_node (a_index: INTEGER): like node_anchor
			-- Get the i-th node in the path
		require
			valid_index: is_valid_node_index (a_index)
		local
			i: INTEGER

			e, prev_e: detachable like edge_anchor
		do
			if a_index = 1 then
				Result := first_node
			elseif a_index = 2 then
				Result := i_th_edge (1).other_node (first_node)
			else
				i := a_index - 1
				e := i_th_edge (i)
				prev_e := i_th_edge (i - 1)
				if not prev_e.has_connection (e.node_to) then
					Result := e.node_to
				elseif not prev_e.has_connection (e.node_from) then
					Result := e.node_from
				else
					Result := e.other_node (i_th_node (a_index - 1))
				end
			end
		end

	i_th_edge (a_index: INTEGER): like edge_anchor
			-- Get the i-th edge in the path
		require
			not_empty: edge_count >= 1
			valid_index: is_valid_edge_index (a_index)
		do
			Result := path_imp.i_th (a_index)
		end

	subpath (a_start_index, a_end_index: INTEGER): like Current
			-- A new path starting at the `a_start_index'th node going to
			-- the `a_end_index'th node.  (Includes the edges between the
			-- two nodes.)
		require
			valid_start_index: is_valid_node_index (a_start_index)
			valid_end_index: is_valid_node_index (a_end_index)
			valid_index_relationship: a_start_index <= a_end_index
		local
			i: INTEGER
		do
			create Result.make (i_th_node (a_start_index))
			from i := a_start_index
			until i > a_end_index - 1 		-- There is one less edge than nodes
			loop
				check
					valid_edge_index: is_valid_edge_index (i)
						-- Because of precondition and minus one above
				end
				Result.extend (i_th_edge (i))
				i := i + 1
			end
		ensure
			correct_start_node: Result.first_node = i_th_node (a_start_index)
			correct_final_node: Result.last_node = i_th_node (a_end_index)
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Are there no edges in Current?
		do
			Result := not attached first_node_imp
		ensure
			empty_implication: Result implies not attached first_node_imp
			no_node_implication: Result implies path_imp.is_empty
		end

	is_dirty: BOOLEAN
			-- Has Current changed since the `cost' was last calculated? 	

	is_invalid: BOOLEAN
			-- Has Current been mark as not usable?
			-- Happens if notified by an {EDGE} that the edge no
			-- longer connected to two nodes.

	is_node_cyclic: BOOLEAN
			-- Does Current contain a cycle where a node is visited
			-- more than once?
		local
			s: LINKED_SET [like node_anchor]
			n: like node_anchor
			i: INTEGER
		do
			create s.make
			from i := 1
			until Result or else i > node_count
			loop
				n := i_th_node (i)
				if s.has (n) then
					Result := True
				else
					s.extend (n)
				end
				i := i + 1
			end
		end

	is_edge_cylcic: BOOLEAN
			-- Does Current contain a cycle where an edge
			-- is traversed more than once?
		local
			s: LINKED_SET [like edge_anchor]
			e: like edge_anchor
			i: INTEGER
		do
			create s.make
			from i := 1
			until Result or else i > edge_count
			loop
				e := i_th_edge (i)
				if s.has (e) then
					Result := True
				else
					s.extend (e)
				end
				i := i + 1
			end
		end

	is_path_cyclic: BOOLEAN
			-- Does Current contain a `subpath' that is
			-- explored more than once?
		local
			i: INTEGER				-- count the number of edges added
			len: INTEGER			-- length in edges of subpaths being compared
			max_len: INTEGER	 	-- maximum length allowed for those subpaths
			s, s2: like subpath		-- the subpaths (portion of Current) to be checked

	-- no must check edges not node; because there may be a path containing the same
	-- nodes reached via different edges.
		do
			if edge_count > 0 then
				max_len := (edge_count // 2) + (edge_count \\ 1)
				from len := max_len
				until Result or len < 1		-- cyclic path must have at least 1 edge
				loop
					from i := 1
					until Result or i + 2 * len - 1 > edge_count
					loop
						s := subpath (i, len)
						s2 := subpath (i + len, len)
if len = 1 then
--	io.put_string ("----------------------------------------------------------%N")
--	io.put_string ("PATH.is_path_cyclic -- s = ")
--	show
--	io.put_string ("PATH.is_path_cyclic -- s = ")
--	s.show
--	io.put_string ("PATH.is_path_cyclic -- s2 = ")
--	s2.show
--	if i = 1 and len = 1 then
		do_nothing
--	end
end
						check
							same_lengths: s.node_count = s2.node_count
								-- because of above steps using `len'
						end
						Result := s ~ s2
						i := i + 1
					end
					len := len - 1
				end
				if not Result then
						-- Is an edge traversed twice in a row in the same direction?
					from i := 2
					until Result or i > edge_count
					loop
						if i_th_edge (i) = i_th_edge (i - 1) then
--	io.put_string ("----------------------------------------------------------%N")
--	io.put_string ("PATH.is_path_cyclic -- Current =  ")
--	show
	if i = 1 and len = 1 then
		do_nothing
	end
							if i_th_node (i) = i_th_node (i - 1) then
								do_nothing
							end
						end
						Result := i_th_edge (i) = i_th_edge (i - 1) and
									i_th_node (i) = i_th_node (i - 1)
						i := i + 1
					end
				end
			end
		end

	show
			-- display the path
		local
			i: INTEGER
		do
			from i := 1
			until i > node_count
			loop
				if i > 1 then
					check attached {VALUED_NODE [STRING]} i_th_node (i - 1) as n then
						io.put_string (n.value)
					end
				end
				check attached {VALUED_NODE [STRING]} i_th_node (i) as n then
					io.put_string (n.value)
				end
				io.put_string (" ")
				i := i + 1
			end
			check attached {VALUED_NODE [STRING]} last_node as n then
				io.put_string (n.value)
			end
			check attached {WEIGHTED_PATH [INTEGER]} Current as p then
				io.put_string ("  ")
				io.put_string (p.cost.out)
			end
			io.new_line
		end

feature -- Status setting

	set_dirty
			-- Mark Current as dirty, so the `cost' can be
			-- recalculated if necessary.
		do
			is_dirty := true
		end

	set_clean
			-- Mark Current as not `is_dirty'
		do
			is_dirty := false
		end

	set_invalid
			-- Mark Current as not usable.
			-- Set when an edge is disconnected
			-- Once `is_invalid' Current cannot be set valid again.
		do
			is_invalid := true
		end

feature -- Query

	is_valid_node_index (a_index: INTEGER): BOOLEAN
			-- Is `a_index' valid for searching for a node?
		do
			Result := a_index >= 1 and a_index <= node_count
		end

	is_valid_edge_index (a_index: INTEGER): BOOLEAN
			-- Is `a_index' valid for searching for an edge?
		do
			Result := a_index >= 1 and a_index <= path_imp.count
		end

	has (a_edge: like edge_anchor): BOOLEAN
			-- Does Current contain `a_edge'?
		do
			Result := path_imp.has (a_edge)
		end

	is_valid_edge (a_edge: like edge_anchor): BOOLEAN
			-- Can `a_edge' be added to Current?
			-- This is used by `extend' to make sure the edge connects correctly.
			-- This is done in a check statement, not a precondition, because `extend'
			-- has been redefined and cannot stregthen the precondition.
		do
			if a_edge /= Void then
--				if a_edge.is_directed then
--					Result := a_edge.originates_at (last_node)
--				else
					Result := a_edge.has_connection (last_node)
--				end
			end
		end

	is_wrong_way_edge (a_index: INTEGER): BOOLEAN
			-- Is the edge indexed by `a_index' going in the wrong direction?
			-- Some graph traversals ignore the directivedness of an edge,
			-- so it is possible to traverse a one-way edge in the opposite
			-- directions.
		require
			valid_edge_index: is_valid_edge_index (a_index)
		local
			e: like edge_anchor
			n: like node_anchor
		do
			e := i_th_edge (a_index)
			n := i_th_node (a_index)
			Result := e.is_directed and not e.originates_at (n)
		end

	has_node (a_node: like node_anchor): BOOLEAN
			-- Does the path contain `a_node'?
		require
			node_exists: a_node /= Void
		local
			i: INTEGER
			e: EDGE
		do
			if a_node = first_node then
				Result := True
			else
				from i := 1
				until Result or else i > edge_count
				loop
					e := i_th_edge (i)
					Result := e.has_connection (a_node)
					i := i + 1
				end
			end
		end

--	was_explored_by (a_iterator: like iterator_anchor): BOOLEAN
--			-- Has Current been explored by `a_iterator'?
--		do
--			Result := attached explorers.item (a_iterator.hash_code) as w and then
--					 attached w.item
--		end

feature -- Measurement

	node_count: INTEGER
			-- The number of node visits along path
			-- (A node could be visited more than once.)
		do
			Result := path_imp.count + 1
		ensure
			at_least_has_first_node: Result >= 1
		end

	edge_count: INTEGER
			-- Number of edges in the path
		do
			Result := path_imp.count
		end

feature -- Element change

	set_first_node (a_node: like node_anchor)
			-- Change the `first node' and remove all edges.
			-- Removes any edges from the list, because the edges must
			-- progress in order and there is no guarantee that `a_node'
			-- has a connection to the first one in the list.
		do
			path_imp.wipe_out
			first_node_imp := a_node
			set_dirty
		ensure
			first_node_assigned: first_node = a_node
			has_no_edges: edge_count = 0
		end

	extend (a_edge: like edge_anchor)
			-- Add `a_edge' to the end of the path.
		require
			valid_edge: is_valid_edge (a_edge)
		do
			path_imp.extend (a_edge)
			if not a_edge.is_in_path (Current) then
				a_edge.join_path (Current)
			end
			set_dirty
		end

--	append (other: like Current) is
--			-- Add `other' path to the end of current.
--		require
--			other_exists: other /= Void
--		do
----			check
----				joining_allowed: equal (other.first_node, last_node)
----			end
----			Precursor {JJ_ARRAYED_STACK} (other)
--			path_imp.append (other)
--		end

	remove
			-- Remove the last edge for the path
		require
			not_empty: edge_count >= 1
		do
			path_imp.remove
		end

	wipe_out
			-- Create a path from `first_node' with no edges.
		do
			path_imp.wipe_out
		end

feature -- Duplication

	copy (other: like Current)
			-- Update current object using fields of object attached
			-- to `other', so as to yield equal objects.
			-- Redefined to make slightly more than a copy, but less than deep_copy.
			-- Simular to {STRING}.copy, because this feature copies the list elements
			-- but not a deep copy of those list elements.
		local
			i: INTEGER
		do
			make (other.first_node)
			from i := 1
			until i > other.edge_count
			loop
				extend (other.i_th_edge (i))
				i := i + 1
			end
			if other.is_invalid then
				set_invalid
			end
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Redefined to follow `copy'
		do
			if other = Current then
				Result := True
			else
				Result := first_node = other.first_node and
						path_imp ~ other.path_imp and
						is_invalid = other.is_invalid
			end
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
			-- True if number of edges less than other.  If equal then
			-- check each node in the path.
		do
			if is_empty and other.is_empty then
				Result := false
			elseif is_empty and not other.is_empty then
				Result := false
			elseif not is_empty and other.is_empty then
				Result := true
			elseif attached {COMPARABLE} cost as c and attached {COMPARABLE} other.cost as oc then
				if c ~ oc then
					Result := check_nodes (other)
				else
					Result := c < oc
				end
			else
				Result := check_nodes (other)
			end
		end

	check_nodes (other: like Current): BOOLEAN
			-- Called by `is_less' when the `cost' of Current or
			-- `other' are not {COMPARABLE} in which case this
			-- feature compares the nodes at each end of Current.
		require
			not_empty: not is_empty
			other_not_empty: not other.is_empty
			not_comparables: (attached {COMPARABLE} cost as c and then
							attached {COMPARABLE} other.cost as oc and then c ~ oc) or else
							(not attached {COMPARABLE} cost or
							not attached {COMPARABLE} other.cost)
		local
			e1: like edge_anchor
			e2: like edge_anchor
			done: BOOLEAN
			i: INTEGER
		do
			if edge_count < other.edge_count then
				Result := True
			elseif edge_count = other.edge_count then
					-- check the `first_node' in each path
				if first_node < other.first_node then
					Result := True
				elseif equal (first_node, other.first_node) then
						-- check the edges until find a pair that is not equal
					from i := 1
					until done or else i > edge_count
					loop
						e1 := i_th_edge (i)
						e2 := other.i_th_edge (i)
						if e1 < e2 then
							Result := True
							done := True
						elseif e1 > e2 then
							done := True
						else
							i := i + 1
						end
					end
				end
			end
		end

feature {GRAPH_ITERATOR} -- Implementation

--	explorers: HASH_TABLE [WEAK_REFERENCE [like iterator_anchor], INTEGER]
--			-- Iterators that have explored Current

--	explore_by (a_iterator: like iterator_anchor)
--			-- Have Current record that it has been explored by `a_iterator'
--		local
--			w: WEAK_REFERENCE [like iterator_anchor]
--		do
--			create w.put (a_iterator)
--			explorers.extend (w, a_iterator.hash_code)
--		ensure
--			was_explored: was_explored_by (a_iterator)
--			referential_integrity: a_iterator.was_path_explored (Current)
--		end

--	unexplore_by (a_iterator: like iterator_anchor)
--			-- Remove `a_iterator' from `explorers'
--			-- Also clean Void references from the table.
--		do
--			explorers.remove (a_iterator.hash_code)
--		ensure
--			not_has_key: not explorers.has_key (a_iterator.hash_code)
--			not_was_explored: not was_explored_by (a_iterator)
--			referential_integrity: not a_iterator.is_unstable implies
--										not a_iterator.was_path_explored (Current)
--		end

feature {WALK} -- Implementation

	path_imp: JJ_ARRAYED_STACK [like edge_anchor]
			-- Implementation holding the edges in this path
			-- Selectively exported to {WALK} for `is_equal'.

feature {NONE} -- Implementation

	Default_size: INTEGER = 10
			-- Default number of edges a path can hold.

	first_node_imp: detachable like node_anchor
			-- Implementation for the `first_node'

	has_inconsistent_edge: BOOLEAN
			-- Does current have an edge that does not connect in the proper
			-- order from `first_node' to the end?
		local
			e: like edge_anchor
			i: INTEGER
		do
			from i := 1
			until not Result or else i > edge_count
			loop
				e := i_th_edge (i)
				Result := is_valid_edge (e)
				i := i + 1
			end
		end

	recomputed_cost: NUMERIC
			-- Calculate the `cost', memoizing the result
			-- in `cost_imp'.
		do
			Result := edge_count
			cost_imp := Result
		end

	cost_imp: like recomputed_cost
			-- Holds the cost calculated in `recompute_cost'
			-- and anchor for `cost'
		attribute
			Result := recomputed_cost
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: NODE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_result: Result = Void
		end

	edge_anchor: EDGE
			-- Anchor for features using nodes.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_result: Result = Void
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

	all_edges_valid: not has_inconsistent_edge

end
