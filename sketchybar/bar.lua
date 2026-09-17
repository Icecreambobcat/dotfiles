local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
	height = 40,
	color = colors.bar.bg,
	border_width = 1,
	border_color = colors.bar.border,
	padding_right = 0,
	padding_left = 0,
	corner_radius = 16,
	y_offset = 6,
	margin = 4,
	blur_radius = 48,
})
