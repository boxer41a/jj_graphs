note
	description: "[
		An ordered colection of edges beginning at a `start_node'.
		Edges can only be added and	removed from the end.
		This is to be used with a {GRAPH}.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/walk.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	WALK

inherit

	COMPARABLE
		redefine
			copy	-- Required (called by `twin')
		end

			-- A LINKED_STACK inserts items in reverse order which is
			-- not intuitive to a client of path who may want to explore
			-- the edges in the path from start to finish.

--	JJ_ARRAYED_STACK [EDGE]		-- JJ_LINKED_STACK [EDGE]
--		rename
--			item as edge,
--			make as list_make
--		export
--			{NONE}
--				list_make,
--				compare_objects,
--				compare_references,
--				append,
--				put,
--				replace
--			{PATH}
--				area,
--				subarray
--			{GRAPH_ITERATOR}
--				remove
--			{ANY}
--				before
--		undefine
--			is_equal
--		redefine
--			default_create,
--			edge,
--			copy,
----			is_equal,
--			extend,
--			force,
--			append,
--			duplicate,
--			wipe_out
--		end

create
	make

feature {NONE} -- Initialization

	make (a_node: like node_anchor)
			-- Create an instance
		require
			node_exists: a_node /= Void
		do
			create path_imp.make (Default_size)
			first_node := a_node
		ensure
			first_node_set: first_node = a_node
		end

feature -- Access

	edge: like edge_anchor
			-- The edge at the current position
		require
			not_empty: not is_empty
			not_off: not is_off
		do
			Result := path_imp.item
		end

	last_edge: like edge_anchor
			-- The last edge.
		require
			not_empty: not is_empty
		do
			Result := path_imp.last
		end

	first_node: like node_anchor
			-- Node at which this path starts.

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
			n: detachable like node_anchor
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
			not_empty: not is_empty
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
			Result := path_imp.is_empty
		end

	is_off: BOOLEAN
			-- Is the cursor off the list?
		do
			Result := path_imp.off
		end

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
			elseif not is_empty then
				from i := 1
				until Result or else i > edge_count
				loop
					e := i_th_edge (i)
					Result := e.has_connection (a_node)
					i := i + 1
				end
			end
		end
feature -- Measurement

	node_count: INTEGER
			-- The number of times nodes are visited along path
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
			-- Change the first node.
			-- Also removes any edges from the list, because the edges must
			-- progress in order and there is no guarantee that `a_node'
			-- has a connection to the first one in the list.
		require
			node_exists: a_node /= Void
		do
			path_imp.wipe_out
			first_node := a_node
		end

	extend (a_edge: like edge_anchor)
			-- Add `a_edge' to the end of the path.
		require
			valid_edge: is_valid_edge (a_edge)
		do
--			check
--				valid_edge: is_valid_edge (a_edge)
--					-- This check added because could not stregthen the precondition.
--			end
--			Precursor {JJ_ARRAYED_STACK} (a_edge)
			path_imp.extend (a_edge)
		end

	force (a_edge: like edge_anchor)
			-- Add `a_edge' to the end of the path.
			-- Same as `extend'.
		require
			valid_edge: is_valid_edge (a_edge)
		do
--			check
--				valid_edge: is_valid_edge (a_edge)
--					-- This check added because could not stregthen the precondition.
--			end
			extend (a_edge)
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
			not_empty: not is_empty
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
			-- but no ta deep copy of those list elements.
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
		end

--	duplicate (n: INTEGER): like Current
--			-- New path containing the `n' latest items inserted in current.
--			-- If `n' is greater than `count', identical to current.
--		do
--			Result := Precursor {JJ_ARRAYED_STACK} (n)
--			Result.set_first_node (first_node)
--		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
			-- True if number of edges less than other.  If equal then
			-- check each node in the path.
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

feature {NONE} -- Implementation

	Default_size: INTEGER = 10
			-- Default number of edges a path can hold.

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

	path_imp: JJ_ARRAYED_STACK [like edge_anchor]
			-- Implementation holding the edges in this path

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

invariant

	all_edges_valid: not has_inconsistent_edge

end
