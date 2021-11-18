note
	description: "[
		A {JJ_SORTABLE_FIXED_ARRAY} intended for use in a {B_TREE}, holding
		a node's values in sorted order, with the added benefit that it is
		a COMPARABLE.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	B_TREE_ARRAY [G -> COMPARABLE]

inherit

	JJ_SORTABLE_FIXED_ARRAY [G]
		undefine
			copy,
			is_equal
		end

	COMPARABLE

create
	make,
	make_filled

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if is_empty and other.is_empty then
				Result := false
			elseif is_empty and not other.is_empty then
				Result := true
			elseif not is_empty and other.is_empty then
				Result := false
			elseif not is_empty and not other.is_empty then
				check
					not_overlaps_other: not overlaps (other)
					not_other_overlaps: not other.overlaps (Current)
				end
				Result := last <= other.last
			else
				check
					should_not_happen: false
						-- because we check all cases above
				end
			end
		end

	overlaps (other: like Current): BOOLEAN
			-- Does Current have values that would place some before or after `other'
			-- while placing some of its values inside `other'
			-- In other words, it is not before, after, or fully contained in `other'
		require
			other_exists: other /= Void
		do
			Result := (first < other.first and last > other.first and last <= other.last) or
						(first >= other.first and first < other.last and last > other.last)
		end

invariant

	is_inserting_sorted: is_inserting_ordered
	is_sorted: is_sorted

end
