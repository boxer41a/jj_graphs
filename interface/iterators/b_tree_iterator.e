note
	description: "Summary description for {B_TREE_ITERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	B_TREE_ITERATOR [G -> COMPARABLE]

inherit

	VALUED_TREE_ITERATOR [B_TREE_ARRAY [G]]
		redefine
			graph_anchor,
			node_anchor,
			edge_anchor,
			path_anchor
		end

feature {NONE} -- Anchors (for covariant redefinitions)

	graph_anchor: B_TREE [G]
			-- Anchor for graph types.
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

	node_anchor: B_TREE_NODE [G]
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
		ensure then
			void_result: Result = Void
		end

	edge_anchor: B_TREE_EDGE [G]
			-- Anchor for features using edges.
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

	path_anchor: B_TREE_PATH [G]
			-- Anchor for features using paths.
			-- Not to be called; just used to anchor types.
			-- Declared a feature to avoid adding an attribute.
		require else
			not_callable: False
		do
			check
				do_not_call: False then
					-- Because give no info; simply used as anchor.
			end
		ensure then
			void_result: Result = Void
		end

end
