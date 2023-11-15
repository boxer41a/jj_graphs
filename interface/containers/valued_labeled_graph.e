 note
	description: "[
			A graph whose nodes contain data of type N and whose edges are
			marked with a `label' of type E.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_LABELED_GRAPH [V, L]

inherit

	VALUED_GRAPH [V]
		rename
			has as has_value
		export
			{NONE}
				connect,
				connect_directed
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

	LABELED_GRAPH [L]
		rename
			has as has_label
		undefine
			default_create,
			notify_node_changed
		redefine
			iterator,
			node_anchor,
			edge_anchor
		end

create
	default_create,
	make_with_capacity

feature -- Access

	iterator: VALUED_LABELED_GRAPH_ITERATOR [V, L]
			-- Create an iterator for accessing the nodes and edges in Current.
			-- Anchor for graph iterators.
		do
			create Result.make (Current)
		end

feature -- Element change

	connect_valued_labeled (a_value_1, a_value_2: like value_anchor; a_label: L)
			-- Find the first two nodes that have values `a_value_1' and
			-- `a_value_2', (or create new nodes if they are not in the
			-- graph) connecting them with a new edge having `a_label'.
			-- The new edge can be accessed through `last_new_edge'.
		require
			value_1_exists: a_value_1 /= Void
			value_2_exists: a_value_2 /= Void
			label_exists: a_label /= Void
		local
			e: like edge_anchor
		do
			connect (a_value_1, a_value_2)
			e := last_new_edge
			e.set_label (a_label)
		ensure
			value_1_node_in_graph: has_value (a_value_1)
			value_2_node_in_graph: has_value (a_value_2)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.node_from.value ~ a_value_1
			proper_to_connection_made: last_new_edge.node_to.value ~ a_value_2
			label_was_set: last_new_edge.label = a_label
		end

	connect_valued_labeled_directed (a_value_1, a_value_2: like value_anchor; a_label: L)
			-- Find the first two nodes that have values `a_value_1' and
			-- `a_value_2', (or create new nodes if they are not in the
			-- graph) connecting them with a new directed edge having `a_label'.
			-- The new edge can be accessed through `last_new_edge'.
		require
			value_1_exists: a_value_1 /= Void
			value_2_exists: a_value_2 /= Void
			label_exists: a_label /= Void
		local
			e: like edge_anchor
		do
			connect_valued_labeled (a_value_1, a_value_2, a_label)
			e := last_new_edge
			e.set_directed
		ensure
			value_1_node_in_graph: has_value (a_value_1)
			value_2_node_in_graph: has_value (a_value_2)
			new_edge_in_graph: has_edge (last_new_edge)
			proper_from_connection_made: last_new_edge.node_from.value ~ a_value_1
			proper_to_connection_made: last_new_edge.node_to.value ~ a_value_2
			label_was_set: last_new_edge.label = a_label
			new_edge_is_directed: last_new_edge.is_directed
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: VALUED_LABELED_NODE [V, L]
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

	edge_anchor: VALUED_LABELED_EDGE [V, L]
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

end
