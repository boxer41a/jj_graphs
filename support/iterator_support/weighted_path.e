note
	description: "[
		A path which holds edges of type {WEIGHTED_EDGE}. 
		Each edge has a `cost' of type C.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	WEIGHTED_PATH [C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	WALK
		redefine
			recomputed_cost,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make

feature {NONE} -- Implementation

	recomputed_cost: C
			-- Calculate the `cost', memoizing the result
			-- in `cost_imp'
		local
			i: INTEGER
			e: like edge_anchor
			num: like cost
		do
			if edge_count = 0 then
				create num
				Result := num.zero
			else
				e := i_th_edge (1)
				num := e.cost
				from
					i := 1
					Result := num.zero
				until i > edge_count
				loop
					e := i_th_edge (i)
					num := e.cost
					Result := Result + num
					i := i + 1
				end
			end
			cost_imp := Result
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: WEIGHTED_NODE [C]
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

	edge_anchor: WEIGHTED_EDGE [C]
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

end
