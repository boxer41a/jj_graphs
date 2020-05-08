note
	description: "[
		Used as the type of a once feature in {NODE} in order to
		capture the last edge that was created by the node.
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/support/container_support/edge_ref.e $"
	date:		"$Date: 2012-07-05 09:08:33 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 6 $"

class
	EDGE_REF

create
	default_create

feature -- Access

	edge: detachable EDGE
			-- The edge to hold on to.

feature -- Element change

	set_edge (a_edge: EDGE)
			-- Change the `edge'
		require
			edge_exists: a_edge /= Void
		do
			edge := a_edge
		end

end
