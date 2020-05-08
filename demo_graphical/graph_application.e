note
	description: "Root class for testing the VITP game."
	author: "Jimmy J. Johnson"
	date: "11 Jan 10"

class
	GRAPH_APPLICATION

inherit

	JJ_APPLICATION
		redefine
			window_anchor
		end

create
	make_and_launch

feature {NONE} -- Implementation (anchors)

	window_anchor: GRAPH_MAIN_WINDOW
			-- Anchor for the type of `first_window'
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
