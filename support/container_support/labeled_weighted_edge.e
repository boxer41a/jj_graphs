note
	description: "[
		An {EDGE} connecting two nodes.  It is marked with 
		a `label' and has `cost'.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	LABELED_WEIGHTED_EDGE [L, C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	LABELED_EDGE [L]
		rename
			make as make_with_label
		undefine
			default_create,
			cost,
			is_equal,
			is_less
		redefine
			node_anchor,
			iterator_anchor
		end


	WEIGHTED_EDGE [C]
		rename
			make as make_with_cost
		undefine
			check_nodes
		redefine
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make,
	make_with_label,	-- cost_imp remains Void
	make_with_cost		-- label_imp remains Void

feature {NONE} -- Initialization

	make (a_label: like label; a_cost: C)
			-- Create an edge marked with `a_label' and having `a_cost'.
		require
			label_exists: a_label /= Void
			cost_exists: a_cost /= Void
		do
			default_create
			set_label (a_label)
			set_cost (a_cost)
		ensure
			label_was_set: label = a_label
			cost_was_set: cost = a_cost
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_WEIGHTED_NODE [L, C]
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

	iterator_anchor: LABELED_WEIGHTED_GRAPH_ITERATOR [L, C]
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
