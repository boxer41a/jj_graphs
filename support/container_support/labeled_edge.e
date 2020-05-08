note
	description: "[
		A an edge connecting two nodes in a {LABELED_GRAPH}. 
		It adds a feature `label' to {EDGE}.
		]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/labeled_edge.e $"
	date:		"$Date: 2013-01-13 08:58:55 -0500 (Sun, 13 Jan 2013) $"
	revision:	"$Revision: 9 $"

class
	LABELED_EDGE [L]

inherit

	EDGE
		redefine
			node_anchor,
			iterator_anchor
		end

create
	default_create,
	make

feature {NONE} -- Initialization

	make (a_label: like label)
			-- Create an edge marked with `a_label'
		require
			label_exists: a_label /= Void
		do
			default_create
			label_imp := a_label
		ensure
			label_was_set: label = a_label
		end

feature -- Access

	label: L
			-- The label to place on this edge.
		do
			check attached label_imp as lab then
				Result := lab
			end
		end

feature -- Element change

	set_label (a_label: like label)
			-- Change the `label'.
		require
			label_exists: a_label /= Void
		do
			label_imp := a_label
		ensure
			label_was_set: label = a_label
		end

feature {NONE} -- Implementation

	label_imp: detachable like label
			-- Allows Void so `new_edge' can call default_create

feature {NONE} -- Anchors (for covariant redefinitions)

	node_anchor: LABELED_NODE [L]
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

	iterator_anchor: LABELED_GRAPH_ITERATOR [L]
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
