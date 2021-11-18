note
	description: "[
		Objects shared by many classes in the graphs cluster.
		]"
	author:    "Jimmy J. Johnson"
	date:      "11/11/21"
	copyright: "Copyright (c) 2021, Jimmy J. Johnson"
	license:   "Eiffel Forum v2 (http://www.eiffel.com/licensing/forum.txt)"

class
	SHARED

feature -- Access

	uuid_generator: UUID_GENERATOR
			-- To make unique IDs for graph-related objects
		once
			create Result
		end
		
end
