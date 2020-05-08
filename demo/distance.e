note
	description: "[
			Type with which to test the graphs cluster.
			]"
	author:		"Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/demo/distance.e $"
	date:		"$Date: 2012-07-05 09:08:33 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 6 $"

class
	DISTANCE

inherit

	INTEGER_REF
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize Current
		do
			units := "Miles"
		end

feature -- Access

	units: STRING
			-- The units in which `value' is measured

end
