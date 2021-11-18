note
	description: "[
			Type with which to test the graphs cluster.
			]"
	author:    "Jimmy J. Johnson"
	date:      "10/27/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

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
