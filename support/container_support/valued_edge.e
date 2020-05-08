note
	description: "[
			An {EDGE} connecting nodes in a {GRAPH}.  The nodes
			connected by this type edge contain data of type V.
			]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/valued_edge.e $"
	date:		"$Date: 2012-07-05 09:08:33 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 6 $"

class
	VALUED_EDGE [V]

inherit

	EDGE
		redefine
			node_anchor
		end

create
	default_create,
	connect

feature {NONE} -- Anchors (for covariant redefinitions)

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

end
