note
	description: "[
		An edge connecting two nodes in a {WEIGHTED_GRAPH}. 
		It adds a feature `cost' to {EDGE}.
		]"
	author: "Jimmy J. Johnson"
	license: "Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/weighted_edge.e $"
	date:		"$Date: 2014-06-08 19:44:14 -0400 (Sun, 08 Jun 2014) $"
	revision:	"$Revision: 24 $"

class
	WEIGHTED_EDGE [C -> NUMERIC create default_create end]

inherit

	EDGE
		redefine
--			default_create,
			check_nodes,
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_cost: C)
			-- Create an edge holding `a_cost'
		require
			cost_exists: a_cost /= Void
		do
			default_create
			cost_imp := a_cost
		ensure
			cost_was_set: cost = a_cost
		end

feature -- Access

	cost: C
			-- The cost of traversing this edge.
			-- Uses the `cost_agent' to calculate this if there is an agent.
		do
			if attached cost_agent as ca then
				Result := ca.item ([])
			else
				check attached cost_imp as c then
					Result := c
				end
			end
		end

feature -- Element change

	set_cost (a_cost: like cost)
			-- Change the cost of traversing this edge.
			-- Removes the `cost_agent' if there was one.
		require
			cost_exists: a_cost /= Void
		do
			cost_imp := a_cost
			cost_agent := Void
		ensure
			cost_was_set: cost = a_cost
		end

feature {NONE} -- Implementation

	check_nodes (other: like Current): BOOLEAN
			-- Is Current less than `other'?
			-- Compares the `cost' of each edge.
		do
			if Current = other then
				Result := False
			elseif equal (cost, other.cost) then
					-- Both `cost' features are equal, so compare the
					-- nodes at each end by calling precursor.
				Result := Precursor {EDGE} (other)
			else
				if attached {COMPARABLE} cost as c and
						attached {COMPARABLE} other.cost as other_c then
					Result := c < other_c
				else
					Result := Precursor {EDGE} (other)
				end
			end
		end

	cost_imp: detachable like cost
			-- Allows Void so `new_edge' can call default_create

	cost_agent: detachable FUNCTION [ANY, TUPLE, C]
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
