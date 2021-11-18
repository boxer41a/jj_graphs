note
	description: "[
		Root class for all the views in VITP
		]"
	author:		"Jimmy J. Johnson"
	copyright:	"Copyright 2009, Jimmy J. Johnson"
	license:	"Eiffel Forum License v2 (see forum.txt)"
	URL: 		"$URL:$"
	date:		"$Date: $"
	revision:	"$Revision: $"

class
	GRAPH_VIEW

inherit

	JJ_MODEL_WORLD_VIEW
		redefine
			create_interface_objects,
--			world,
--			target,
			draw
		end

feature {NONE} -- Initialization

	create_interface_objects
			-- Create objects to be used by `Current' in `initialize'
			-- Implemented by descendants to create attached objects
			-- in order to adhere to void-safety due to the implementation bridge pattern.
		do
			Precursor {JJ_MODEL_WORLD_VIEW}
			is_autoscroll_enabled := true
		end

feature -- Status report

	is_max_scaled: BOOLEAN
			-- Is the view at maximum magnification?
		do
			Result := world.bounding_box.width > 6 * client_width or
						world.bounding_box.height > 6 * client_height
		end

	is_min_scaled: BOOLEAN
			-- Is the view at minimum magnification?
		do
			Result := world.bounding_box.width < client_width // 2 or
						world.bounding_box.height < client_height // 2
		end

feature -- Basic operations

	draw
			-- Redraw the window
		do
--			world.wipe_out
			world.full_redraw
			Precursor {JJ_MODEL_WORLD_VIEW}
		end

	scale_up
			-- Increase to the next largest size
		require
			not_at_max_scale: not is_max_scaled
		local
			bot_gap, rt_gap: INTEGER
			top_over, lt_over: INTEGER
			ax, ay: INTEGER
		do
			world.scale (scale_factor)
			resize_if_necessary
		end

	scale_down
			-- Decrease to the next smallest size
		require
			not_at_min_scale: not is_min_scaled
		local
			bb_top, bb_left: INTEGER
			bb_bottom, bb_right: INTEGER
			ax, ay: INTEGER
			t: EV_MODEL_TRANSFORMATION
		do
			world.scale (1 / scale_factor)
			create t.make_zero
			bb_left := world.bounding_box.x
			bb_top := world.bounding_box.y
--			if bb_top > 0 then
--				ax := -bb_top
--			end
--			if bb_left > 0 then
--				ay := -bb_left
--			end
--			t.translate (ax, ay)
--			world.transform (t)
			if world.bounding_box.width < client_width or
					world.bounding_box.height < client_height then
				fit_to_screen
			end
				-- fix the scrollbars
			resize_if_necessary
		end

feature {NONE} -- Implementation

	scale_factor: DOUBLE = 1.5
			-- The amount to grow (or swrink by reciprocal)

	Default_width: INTEGER = 200
			-- The default width of `border'

	Default_height: INTEGER = 300
			-- the default width of `border'

invariant


end
