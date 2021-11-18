note
	description: "[
		A {NODE} which contains a `value' for use in a {VALUED_GRAPH [V]}.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_NODE [V]

inherit

	NODE
		redefine
--			out,
			is_less,
			graph_anchor,
			node_anchor,
			edge_anchor,
			iterator_anchor
		end

create
	default_create,			-- no value, default capacities from like `graph_anchor'
	make_with_order,			-- no_value, capacities from `a_order'
	make_with_graph,			-- no value, capacities fronm `a_graph'
	make_with_value,			-- capacities from like `graph_anchor'
	make_with_value_and_order,	-- capacities from `order'
	make_with_value_and_graph	-- capacities from `a_graph'

feature {NONE} -- Initialization

	make_with_value (a_value: like value_anchor)
			-- Create a node with `default_out_capacity' and set `value' to `a_value'
		require
			value_exists: a_value /= Void
		local
			g: like graph_anchor
		do
			create g
			make_with_value_and_order (a_value, g.Default_out_capacity)
		ensure
			order_set: internal_node_order = (create {like graph_anchor}).default_out_capacity
			value_set: value = a_value
		end

	make_with_value_and_order (a_value: like value_anchor; a_order: INTEGER)
			-- Create a node containing `a_value' and which can initially
			-- contain `a_order' number of edges.
		require
			value_exists: a_value /= Void
			order_large_enough: a_order >= 1
		do
			value_imp := a_value
			make_with_order (a_order)
		ensure
			value_set: value = a_value
		end

	make_with_value_and_graph (a_value: like value_anchor; a_graph: like graph_anchor;)
			-- Create a node in `a_graph', containing `value', and initially
			-- having the edge capacity dictated by `a_graph'.
		require
			graph_exists: a_graph /= Void
			value_exists: a_value /= Void
		do
--			make_with_value_and_order (a_value, a_graph.initial_out_capacity)
			value_imp := a_value
			make_with_graph (a_graph)
		ensure
			is_in_graph: is_in_graph (a_graph)
			graph_has_current: a_graph.has_node (Current)
			value_set: value = a_value
		end

feature -- Access

--	out: STRING_8
--			-- TEMPORARY
--		do
--			Result := value.out
--		end

	value: attached like value_anchor
			-- The data stored in this node.
		require
			has_value: has_value
		do
			check attached value_imp as v then
				Result := v
			end
		ensure
			result_exists: Result /= Void
		end

feature -- Element change

	set_value (a_value: like value_anchor)
			-- Change `value' to `a_value'
		do
			value_imp := a_value
		ensure
			has_value: value = a_value
		end

feature -- Status report

	has_value: BOOLEAN
			-- Does Current contain a `value'?
		do
			Result := value_imp /= Void
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
			-- Checks the `value' features of each node.
		do
			if Current = other then
					-- They are the same node (reference equality)
			else
				if equal (value, other.value) then
					Result := Precursor {NODE} (other)
				else
						-- Values are not equal, so compare values, but
						-- only if both values are COMPARABLEs.
					if attached {COMPARABLE } value as v and
							attached {COMPARABLE} other.value as other_v then
						Result := v < other_v
					else
						Result := Precursor {NODE} (other)
					end
				end
			end
		end

feature {NONE} -- Implementation

	value_imp: detachable like value
			-- Allows `default_create' in void-safe mode

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: VALUED_GRAPH [V]
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

	node_anchor: VALUED_NODE [V]
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

	edge_anchor: VALUED_EDGE [V]
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

	iterator_anchor: VALUED_GRAPH_ITERATOR [V]
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

	value_anchor: V
			-- Anchor for features using the `value' in the node.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
		require
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
