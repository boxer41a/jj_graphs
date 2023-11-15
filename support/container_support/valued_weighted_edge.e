note
	description: "[
		An {EDGE} connecting two nodes where each node has a `value'
	 	and the edge has a `cost'.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_WEIGHTED_EDGE [V, C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	VALUED_EDGE [V]
		undefine
			cost
		redefine
			node_anchor,
			iterator_anchor
		end

	WEIGHTED_EDGE [C]
		redefine
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_WEIGHTED_NODE [V, C]
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

	iterator_anchor: VALUED_WEIGHTED_GRAPH_ITERATOR [V, C]
			-- Anchor for features using iterators.
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

end
