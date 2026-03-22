require("full-border"):setup()
require("zoxide"):setup({
	update_db = false,
})
require("git"):setup({
	-- Order of status signs showing in the linemode
	order = 1500,
})

Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
