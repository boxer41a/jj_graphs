note
	description: "[
		Helper class for objects to be prioritized based on a
		cost to get to the node, used in `shortest_paths' from
		class {GRAPH_ITERATOR}.
		This is just a simple structure class for holding values.
		]"
	author: "Jimmy J Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	PATH_COST_PAIR

inherit

	COMPARABLE

create
	make,
	from_tuple

convert
	from_tuple ({TUPLE [WALK, NUMERIC]})

feature {NONE} -- Initialization

	make (a_path: like path)
			-- Set up Current with infinite cost estimated to
			-- travel the path
		do
			path := a_path
			is_infinite := true
		end

	from_tuple (a_tuple: TUPLE [path: like path; cost: like cost])
		do
			path := a_tuple.path
			cost := a_tuple.cost
			if attached cost then
				is_infinite := false
			end
		end

feature -- Status report

	is_infinite: BOOLEAN
			-- True until `cost' is set to a value

feature -- Access

	path: WALK
			-- The path

	cost: detachable NUMERIC
			-- The estimated [or projected] cost to get from Current `node'
			-- to some goal node as calculated outside this class.

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if is_infinite then
				Result := false
			elseif not is_infinite and other.is_infinite then
				Result := true
			elseif attached {COMPARABLE} cost as c and then
					attached {COMPARABLE} other as oc then
				Result := c < oc
			else
				Result := path < other.path
			end
		end

end
