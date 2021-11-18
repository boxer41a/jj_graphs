note
	description: "[
		Holds values as nodes for use in {JJ_WEIGHTED_GRAPH}.  The node holds
		edges whose cost's are of type C.
		]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	WEIGHTED_NODE [C ->{NUMERIC,
						COMPARABLE rename default_create as comparable_default_create end}
						create default_create end]
						
inherit

	NODE
		redefine
			edge_anchor,
			node_anchor,
			iterator_anchor
		end

create
	default_create,			-- Remember, the weights are on the edges,
	make_with_order,		-- so node creation is the same as for
	make_with_graph			-- plain {NODE}s.

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
