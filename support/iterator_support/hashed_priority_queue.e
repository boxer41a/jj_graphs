note
	description: "[
		A priority queue (min or max depending on `is_maximum'), that
		allows membership testing as if it were a hash table.
		In other words, items sorted as a {COMPARABLE} and indexed
		by a {HASHABLE}.
		]"
	author:    "Jimmy J. Johnson"
	date:      "11/11/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	HASHED_PRIORITY_QUEUE [G -> COMPARABLE, K -> HASHABLE]

inherit

	ANY
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			-- Create an instance
		do
			create list.make (Default_size)
			create table.make (Default_size)
		end

feature -- Access

	show
			-- Display Current
		do
			print ("Table: %N")
			from table.start
			until table.after
			loop
				print ("%T" + table.item_for_iteration.out + " key = " + table.key_for_iteration.out + "%N")
				table.forth
			end
			print ("List: %N%T")
			from list.start
			until list.is_after
			loop
				print (list.item.out + " ")
				list.forth
			end
			print ("%N%N%N")
		end

	item: G
			-- The min [or max] item in the queue, depending
			-- on the value of `is_maximum'
		require
			not_empty: not is_empty
		do
			if is_max_queue then
				Result := list.i_th (list.count)
			else
				Result := list.i_th (1)
			end
		end

	count: INTEGER
			-- Number of items in Current
		do
			Result := list.count
		end

feature -- Status report

	is_max_queue: BOOLEAN
			-- Is Current a max-priority queue?
			-- (The `item' is the object with the maximum value.)

	is_empty: BOOLEAN
			-- Does Current have no items?
		do
			Result := list.is_empty
		end

	object_comparison: BOOLEAN
			-- Must search operations use `equal' rather than `='
			-- for comparing references? (Default: no, use `='.)
		do
			Result := list.object_comparison
		ensure
			definition: Result = list.object_comparison
			implication: Result implies table.object_comparison
		end

	changeable_comparison_criterion: BOOLEAN
			-- May `object_comparison' be changed?
			-- (Answer: yes by default.)
		do
			Result := True
		end

feature -- Status setting

	set_maximum
			-- Ensure Current acts as a max-priority queue
		do
			is_max_queue := true
		ensure
			is_max_priority_queue: is_max_queue
		end

	set_minimum
			-- Ensure Current acts as a min-priority queue
		do
			is_max_queue := false
		ensure
			is_min_priority_queue: not is_max_queue
		end

	compare_objects
			-- Ensure that future search operations will use `equal'
			-- rather than `=' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			list.compare_objects
			table.compare_objects
		ensure
			object_comparison
		end

	compare_references
			-- Ensure that future search operations will use `='
			-- rather than `equal' for comparing references.
		require
			changeable_comparison_criterion: changeable_comparison_criterion
		do
			list.compare_references
			table.compare_references
		ensure
			reference_comparison: not object_comparison
		end

feature -- Basic operations

	extend (a_item: like item; a_key: K)
			-- Add `a_item' to Current or replace an existing item
			-- indexed by `a_key' if `a_item' is greater than (for
			-- a `is_max_queue') or is less than (if not `is_max_queue').
		local
			it: like item
		do
--			print ("Inserting item: " + a_item.out + "  with key " + a_key.out + "%N")
			if has_key (a_key) then
				it := table.definite_item (a_key)
				check
					list_has_it: list.has (it)
				end
				if (is_max_queue and then a_item > it) or
					(not is_max_queue and then a_item < it) then
						-- remove and replace in `list'
					if is_max_queue then
						list.finish
					else
						list.start
					end
					check
						at_item: list.item = it
							-- because in table, must be in list
					end
					list.remove
					check
						not_has_item: not list.has (it)
							-- because just remove it above
					end
					list.extend (a_item)
					check
						has_item: list.has (a_item)
							-- because just put it back
					end
						-- replace item in table
					table.force (a_item, a_key)
					check
						same_count: table.count = list.count
						in_table: table.has_item (a_item)
						key_in_table: table.has_key (a_key)
						correctly_keyed: table.definite_item (a_key) = a_item
						in_list: list.has (a_item)
					end
				end
			else
				check
					same_count: table.count = list.count
				end
				check
					not_in_list: not list.has (a_item)
					not_in_table: not table.has_key (a_key)
				end
				table.extend (a_item, a_key)
				list.extend (a_item)
				check
					list_has_item: list.has (a_item)
					same_count: table.count = list.count
				end
			end
--			show
		ensure
--			has_item: list.has (a_item)
			has_key: table.has (a_key)
		end

	remove
			-- Remove the top [or bottom] item
		require
			not_empty: not is_empty
		local
			it: like item
			k: K
		do
			if is_max_queue then
				list.finish
			else
				list.start
			end
			it := list.item
			list.remove
				-- Must do sequential search of hash table
			check
				table.has_item (it)
					-- because not empty and invariant
			end
			from table.start
			until table.after or else table.item_for_iteration = it
			loop
				table.forth
			end
			k := table.key_for_iteration
			table.remove (k)
		ensure
			count_decreased: count = old count - 1
		end

feature -- Query

	has (a_item: like item): BOOLEAN
			-- Does Current contain `a_item'?
		do
			Result := list.has (a_item)
		ensure
			definition: Result implies list.has (a_item)
			implication: Result implies table.has_item (a_item)
		end

	has_key (a_key: K): BOOLEAN
			-- Does Current contain an item indexed by `a_key'?
		do
			Result := table.has (a_key)
		ensure
			definition: Result implies table.has (a_key)
			implication: Result implies list.has (table.definite_item (a_key))
		end

feature {NONE} -- Implementation

	table: HASH_TABLE [G, K]
			-- The values stored in a hash-table

	list: JJ_SORTABLE_SET [G]
			-- The values stored in order (smallest to largest)

	Default_size: INTEGER = 100
			-- Initial capacity used in `default_create'

invariant

	same_number_of_items: table.count = list.count
	same_items: across table as i all list.has (i.item) end


end
