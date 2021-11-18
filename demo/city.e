note
	description: "[
			Type with which to test the graphs cluster.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

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
