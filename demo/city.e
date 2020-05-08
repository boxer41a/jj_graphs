note
	description: "[
			Type with which to test the graphs cluster.
			]"
	author: "Jimmy J. Johnson"
	license: "Eiffel Forum License v2 (see forum.txt)"
	author:		"$Author: $"
	URL: 		"$URL: file:///F:/eiffel_repositories/jj_graphs/trunk/demo/city.e $"
	date:		"$Date: 2012-07-05 09:08:33 -0400 (Thu, 05 Jul 2012) $"
	revision:	"$Revision: 6 $"

class
	CITY

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
			-- Initialize Current
		do
			name := "Not named"
			population := 0
		end
		
feature -- Access

	name: STRING
			-- The name of the city

	population: INTEGER
			-- The number of people in the city

end
