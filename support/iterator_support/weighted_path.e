note
	description: "[
		A path which holds edges of type {WEIGHTED_EDGE}. 
		Each edge has a `cost' of type C.
			]"
	date: "27 Feb 03"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/iterator_support/weighted_path.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	WEIGHTED_PATH [C -> NUMERIC create default_create end]

inherit

	WALK
		redefine
			is_less,
			node_anchor,
			edge_anchor
		end

create
	make

feature -- Access

	cost: C
			-- Cost to travel the entire path.
		local
			i: INTEGER
			e: like edge_anchor
			num: like cost
		do
			if is_empty then
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
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
			-- True if the cost of Current is less than the cost of the other.
			-- If costs are equal then
		do
			if attached {COMPARABLE} cost as c and attached {COMPARABLE} other.cost as oc then
				if c ~ oc then
					Result := Precursor {WALK} (other)
				else
					Result := c < oc
				end
			else
				Result := Precursor {WALK} (other)
			end
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
