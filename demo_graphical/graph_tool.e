note
	description: "[
			Displays a graph.
			]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	GRAPH_TOOL

inherit

	TOOL
		redefine
			create_interface_objects,
			initialize,
			add_actions
--			target,
--			set_target
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {TOOL}
			create graph_view
			create zoom_in_button
			create zoom_out_button
			zoom_in_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_zoom_in_color_buffer))
			zoom_in_button.set_tooltip ("Zoom In")
			zoom_out_button.set_pixmap (create {EV_PIXMAP}.make_with_pixel_buffer (Icon_zoom_out_color_buffer))
			zoom_out_button.set_tooltip ("Zoom Out")
		end

	initialize
			-- Build the interface for this window
		do
			Precursor {TOOL}
			build_tool_bar
			split_manager.enable_mode_changes
			split_manager.set_horizontal
			split_manager.extend (graph_view)
		end

	build_tool_bar
			-- Add buttons to `tool_bar' (from TOOL).
		do
			tool_bar.extend (zoom_in_button)
			tool_bar.extend (zoom_out_button)
		end

	add_actions
			-- Add functionality to the buttons
		do
			Precursor {TOOL}
			resize_actions.force_extend (agent on_resize)
			zoom_in_button.select_actions.extend (agent on_zoom_in)
			zoom_out_button.select_actions.extend (agent on_zoom_out)
		end

	is_vitp_tool_interface_initialized: BOOLEAN


feature -- Status report

	is_drawing_area_tool_interface_initialized: BOOLEAN_REF
			-- Have the interface items for this class been added to the `interface_table'?
		once
			create Result
		end

feature {NONE} -- Implementation (actions)

	on_resize
			-- React to a resize event
		do
			set_buttons
		end

	set_buttons
			-- Enable or disable the buttons depending on the
			-- state of the view
		do
			if graph_view.is_max_scaled then
				zoom_in_button.disable_sensitive
			else
				zoom_in_button.enable_sensitive
			end
			if graph_view.is_min_scaled then
				zoom_out_button.disable_sensitive
			else
				zoom_out_button.enable_sensitive
			end
		end

	on_set_defaults
			-- Restore the view-vector to the default settings.
		do
		end

	on_zoom_in
			-- Make the board larger
		do
			graph_view.scale_up
			graph_view.draw
			set_buttons
		end

	on_zoom_out
			-- Make the board smaller
		do
			graph_view.scale_down
			graph_view.draw
			set_buttons
		end

	Default_object: TEST_GRAPH
			--
		once
			create Result
		end

feature {NONE} -- Implementation

	zoom_in_button: EV_TOOL_BAR_BUTTON
			-- Button to make the game board larger.

	zoom_out_button: EV_TOOL_BAR_BUTTON
			-- Button to make the game board smaller.

	graph_view: GRAPH_VIEW
			-- Displays the graph as bubbles and arrows

end
