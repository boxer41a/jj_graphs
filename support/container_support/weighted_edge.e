note
	description: "[
		An edge connecting two nodes in a {WEIGHTED_GRAPH}. 
		It adds a feature `cost' to {EDGE}.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	WEIGHTED_EDGE [C -> {NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]

inherit

	EDGE
		redefine
			cost,
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_cost: C)
			-- Create an edge holding `a_cost'
		do
			default_create
			set_cost (a_cost)
		ensure
			cost_was_set: cost = a_cost
		end

feature -- Access

	cost: C
			-- The cost of traversing this edge.
			-- Uses the `cost_agent' to calculate this if there is an agent.
		local
			x: like cost
		do
			if attached cost_agent as ca then
				check attached ca.item ([]) as r then
					Result := r
				end
			else
				if attached cost_imp as c then
					Result := c
				else
					create x
					Result := x.one
				end
			end
		end

feature -- Element change

	set_cost (a_cost: like cost)
			-- Change the cost of traversing this edge.
			-- Removes the `cost_agent' if there was one.
		do
			cost_imp := a_cost
			cost_agent := Void
		ensure
			cost_was_set: cost = a_cost
		end

	set_cost_agent (a_function: like cost_agent)
			-- Use `a_function'to calculate the `cost'
		do
			cost_agent := a_function
		end

feature {NONE} -- Implementation

	cost_imp: detachable like cost
			-- Implementation for `cost'

	cost_agent: detachable FUNCTION [TUPLE, C]
			-- Function to calculate the `cost'

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: WEIGHTED_NODE [C]
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

	iterator_anchor: WEIGHTED_GRAPH_ITERATOR [C]
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
