note
	description: "[
		Main window for VITP
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2010, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	GRAPH_MAIN_WINDOW

inherit

	JJ_MAIN_WINDOW
		redefine
			create_interface_objects,
			initialize,
--			initialize_interface,
			add_actions,
			target_imp,
			set_target,
			draw
		end

create
	default_create

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {JJ_MAIN_WINDOW}
			create graph_tool
			create text_tool
			create command_tool_bar
			create reset_button.make_with_text ("Reset")
		end

	initialize
			-- Set up the window
		do
			build_commands_tool_bar
			Precursor {JJ_MAIN_WINDOW}
			split_manager.enable_mode_changes
			split_manager.set_horizontal
			split_manager.extend (text_tool)
			split_manager.extend (graph_tool)
			tool_bar_box.extend (create {EV_HORIZONTAL_SEPARATOR})
			tool_bar_box.extend (command_tool_bar)
			tool_bar_box.extend (create {EV_HORIZONTAL_SEPARATOR})
			tool_bar_box.extend (create {EV_HORIZONTAL_SEPARATOR})
			tool_bar_box.disable_item_expand (command_tool_bar)
--			set_target (vitp_game)
			set_size (800, 600)
			set_position (1000, 200)
		end

	add_actions
			-- Assign actions to the buttons
		do
			Precursor {JJ_MAIN_WINDOW}
				-- OBJECT actions
--			reset_button.select_actions.extend (agent on_reset)
		end

	build_commands_tool_bar
			-- Create and populate the `command_tool_bar'.
		do
			command_tool_bar.extend (reset_button)
			command_tool_bar.disable_item_expand (reset_button)
		end

feature -- Element change

	set_target (a_target: like target)
			-- Change the target
		do
			Precursor {JJ_MAIN_WINDOW} (a_target)
			graph_tool.set_target (target)
			text_tool.set_target (target)
		end

feature -- Basic operations

	draw
			--
		do
			Precursor {JJ_MAIN_WINDOW}
		end

feature {NONE} -- Implementation (actions)


feature {NONE} -- Implementation


	graph_tool: GRAPH_TOOL
			-- Drawing will be done here.

	text_tool: TEXT_VIEW
			-- Displays textual information

	command_tool_bar: EV_HORIZONTAL_BOX
			-- Holds buttons for testing movement of the object such as move,
			-- set speed, attitide, etc.

	reset_button: EV_BUTTON
			-- Returns widgets to the box

	target_imp: detachable TEST_GRAPH


end
