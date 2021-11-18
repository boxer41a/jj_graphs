note
	description: "[
		Iterator for a {VALUED_GRAPH}
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	VALUED_GRAPH_ITERATOR [V]

inherit

	GRAPH_ITERATOR
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

create
	default_create,
	make

feature -- Access

	value: V
			-- The value in the currently visited node.
		require
			not_off: not is_off
		do
			Result := node.value
		end

feature -- Element change

	set_root (a_value: V)
			-- Set the root node to the first node containing `a_value'
		require
			value_exists: a_value /= Void
			graph_exists: graph /= Void
			has_value: graph.has (a_value)
		do
			check attached graph.find_valued_node (a_value) as n then
				set_root_node (n)
			end
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: VALUED_GRAPH [V]
			-- Anchor for graph types.
			-- Not to be called; just used to anchor types.
			-- Declared as a feature to avoid adding an attribute.
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
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

	path_anchor: VALUED_PATH [V]
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		end

end
