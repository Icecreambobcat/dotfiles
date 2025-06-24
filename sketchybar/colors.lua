return {
	black = 0xff181825,
	white = 0xffcdd6f4,
	red = 0xfff38ba8,
	green = 0xffa6e3a1,
  cyan = 0xff94e2d5,
	blue = 0xff89b4fa,
	yellow = 0xfff9e2af,
	orange = 0xfffab387,
	magenta = 0xfff5c2e7,
	grey = 0xff7f849c,
	transparent = 0x00000000,

	bar = {
		bg = 0xc4181825,
		border = 0xff6c7086,
	},
	popup = {
		bg = 0xc4181825,
		border = 0xff6c7086,
	},
	bg1 = 0xff1e1e2e,
	bg2 = 0xff313244,

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
