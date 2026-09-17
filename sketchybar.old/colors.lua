return {
	black = 0xff414868,
	white = 0xffc0caf5,
	red = 0xfff7768e,
	green = 0xff9ece6a,
	cyan = 0xff7dcfff,
	blue = 0xff7aa2f7,
	yellow = 0xffe0af68,
	orange = 0xffff9e64,
	magenta = 0xffbb9af7,
	grey = 0xff565f89,
	transparent = 0x00000000,

	-- Tokyo Night base colours
	bg1 = 0xff1a1b26,
	bg2 = 0xff24283b,

	-- some custom colours
	lgrey = 0xff9199ba,

	-- Liquid Glass palette
	glass = {
		bg = 0x8011111a,
		bg_alt = 0xc0181927,

		border_on = 0x60c0caf5,
		border_off = 0x60414868,
	},

	bar = {
		bg = 0x601a1b26,
		border = 0x40c0caf5,
	},

	popup = {
		bg = 0xc0181927,
		border = 0x60c0caf5,
	},

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
