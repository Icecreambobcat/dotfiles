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

	-- macOS 27-inspired frost with distinct Tokyo Night control surfaces
	glass = {
		-- Dark capsules remain distinct from the lighter blurred bar.
		bg = 0x901b1d2b,
		bg_alt = 0xaf2c3048,

		-- Soft lit rims retain separation; selection gets a brighter edge.
		border_on = 0x84c0caf5,
		border_off = 0x589199ba,
	},

	bar = {
		-- Let the blurred backdrop show between the stronger capsules.
		bg = 0x801a1b26,
		border = 0x409199ba,
	},

	popup = {
		-- Lighter storm tint preserves backdrop colour under stronger blur.
		bg = 0xc024283b,
		bg_alt = 0xd024283b,
		border = 0x609199ba,
		separator = 0x309199ba,
	},

	with_alpha = function(color, alpha)
		if alpha > 1.0 or alpha < 0.0 then
			return color
		end
		return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
	end,
}
