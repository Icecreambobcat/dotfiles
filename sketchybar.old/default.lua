local settings = require("settings")
local colors = require("colors")

-- Equivalent to the --default domain
sbar.default({
	updates = "when_shown",
	icon = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Bold"],
			size = 14.0,
		},
		color = colors.white,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
		background = {
			image = {
				corner_radius = 12,
				border_width = 1,
				border_color = colors.glass.border_off,
			},
		},
	},
	label = {
		font = {
			family = settings.font.text,
			style = settings.font.style_map["Semibold"],
			size = 13.0,
		},
		color = colors.white,
		padding_left = settings.paddings,
		padding_right = settings.paddings,
	},
	background = {
		height = 28,
		corner_radius = 12,
		image = {
			corner_radius = 12,
			border_color = colors.glass.border_on,
			border_width = 1,
		},
	},
	popup = {
		background = {
			border_width = 1,
			corner_radius = 12,
			border_color = colors.popup.border,
			color = colors.popup.bg,
			shadow = { drawing = true },
		},
		blur_radius = 64,
    y_offset = 4,
	},
	padding_left = 5,
	padding_right = 5,
	scroll_texts = true,
})
