note
	description: "[
		Used as the type of a once feature in {VALUDED_NODE} in order to
		capture the last node (if any) that was found during a search.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2012, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/node_ref.e $"
	date:		"$Date: 2012-07-05 09:08:33 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 6 $"

class
	NODE_REF

create
	default_create

feature -- Access

	node: detachable NODE
			-- The node to hold on to.

feature -- Element change

	set_node (a_node: NODE)
			-- Change the `node'
		require
			node_exists: a_node /= Void
		do
			node := a_node
		end

end
