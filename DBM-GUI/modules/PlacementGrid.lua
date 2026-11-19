local L = DBM_GUI_L
local step = 32
local grid
local markers, lines = {}, {}

local function drawGrid()
	local width, height = grid:GetWidth(), grid:GetHeight()
	local count = 0
	local function line(x, y, w, h)
		count = count + 1
		local texture = lines[count]
		if not texture then
			texture = grid:CreateTexture(nil, "BORDER")
			lines[count] = texture
		end
		texture:SetTexture(1, 1, 1, (x == 0 and y == 0) and 0.55 or 0.18)
		texture:SetSize(w, h)
		texture:SetPoint("CENTER", grid, "CENTER", x, y)
		texture:Show()
	end
	local columns, rows = math.floor(width / (2 * step)), math.floor(height / (2 * step))
	for i = -columns, columns do line(i * step, 0, 1, height) end
	for i = -rows, rows do line(0, i * step, width, 1) end
	for i = count + 1, #lines do lines[i]:Hide() end
end

local function drag(marker)
	local scale = grid:GetEffectiveScale()
	local x, y = GetCursorPosition()
	x = x / scale - marker.offsetX
	y = y / scale - marker.offsetY
	if not IsAltKeyDown() then
		x = math.floor(x / step + 0.5) * step
		y = math.floor(y / step + 0.5) * step
	end
	marker:ClearAllPoints()
	marker:SetPoint(marker.anchor, grid, "CENTER", x, y)
end

local function startDrag(marker)
	GameTooltip:Hide()
	local x, y = marker.pin:GetCenter()
	local cx, cy = grid:GetCenter()
	local mouseX, mouseY = GetCursorPosition()
	local scale = grid:GetEffectiveScale()
	marker.offsetX = mouseX / scale - (x - cx)
	marker.offsetY = mouseY / scale - (y - cy)
	marker:SetScript("OnUpdate", drag)
end

local function stopDrag(marker)
	if not marker:GetScript("OnUpdate") then return end
	marker:SetScript("OnUpdate", nil)
	drag(marker)
	local x, y = marker.pin:GetCenter()
	local ox, oy = marker:GetParent():GetCenter()
	local options = marker.owner.Options
	options[marker.xKey], options[marker.yKey] = x - ox, y - oy
	marker:SetPoint(marker.anchor, marker:GetParent(), "CENTER", x - ox, y - oy)
	if marker.owner == DBT then
		DBT:Rearrange()
	else
		DBM:RepositionFrames()
	end
end

local function addMarker(label, owner, prefix, offsetPrefix)
	-- The origin follows the profile's anchor point, including edge and corner anchors.
	local origin = CreateFrame("Frame", nil, grid)
	origin:SetSize(1, 1)
	local marker = CreateFrame("Button", nil, origin)
	marker:SetClampedToScreen(true)
	marker.pin = CreateFrame("Frame", nil, marker)
	marker.pin:SetSize(1, 1)
	marker:RegisterForDrag("LeftButton")
	marker:SetScript("OnDragStart", startDrag)
	marker:SetScript("OnDragStop", stopDrag)
	marker:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
		GameTooltip:SetText(label)
		GameTooltip:Show()
	end)
	marker:SetScript("OnLeave", function() GameTooltip:Hide() end)
	marker:SetScript("OnHide", function(self) self:SetScript("OnUpdate", nil) end)
	marker.owner = owner
	marker.pointKey = prefix .. "Point"
	marker.xKey = (offsetPrefix or prefix) .. "X"
	marker.yKey = (offsetPrefix or prefix) .. "Y"
	markers[#markers + 1] = marker
	return marker
end

local function addBar(label, large)
	local preview = addMarker(label, DBT, large and "HugeTimer" or "Timer")
	local dummy = DBT:CreateDummyBar(nil, nil, label)
	dummy.enlarged, dummy.dummyEnlarge = large, large
	dummy.frame:SetParent(preview)
	dummy.frame:SetPoint("CENTER", preview, "CENTER")
	dummy.frame:EnableMouse(false)
	dummy.frame:SetScript("OnHide", nil)
	preview.attachPoint = "TOP"
	local applyStyle = dummy.ApplyStyle
	function dummy:ApplyStyle()
		self.timer = self.totalTime * 0.6
		self.fadingIn = nil
		applyStyle(self)
		-- A fully transparent timer still needs a visible drag target in the editor.
		if self.frame:GetAlpha() == 0 then self.frame:SetAlpha(0.5) end
		local options = DBT.Options
		local scale = self.frame:GetScale()
		preview:SetSize(options[large and "HugeWidth" or "Width"] * scale, options[large and "HugeHeight" or "Height"] * scale)
	end
	preview.refresh = function() dummy:ApplyStyle() end
end

local function addWarning(special)
	local preview = addMarker(special and L.Panel_SpecWarnFrame or L.Tab_RaidWarning, DBM, special and "SpecialWarning" or "Warning")
	local source = special and DBMSpecialWarning1 or DBMWarning1
	local text = preview:CreateFontString(nil, "OVERLAY")
	text:SetPoint("CENTER")
	preview.attachPoint = "TOP"
	preview.refresh = function()
		local o = DBM.Options
		text:SetFont(source:GetFont())
		text:SetShadowOffset(source:GetShadowOffset())
		local spell, _, icon = GetSpellInfo(116) -- Frostbolt
		local image = icon and ("|T" .. icon .. ":0|t ") or ""
		if special then
			text:SetTextColor(unpack(o.SpecialWarningFontCol))
			text:SetText((o.SpecialWarningIcon and image or "") .. DBM_CORE_L.MOVE_SPECIAL_WARNING_TEXT)
		else
			local color = o.WarningColors[1]
			text:SetTextColor(color.r, color.g, color.b)
			text:SetText((o.WarningIconLeft and image or "") .. (spell or L.Tab_RaidWarning) .. (o.WarningIconRight and (" " .. image) or ""))
		end
		preview:SetSize(text:GetStringWidth() + 4, text:GetStringHeight() + 2)
	end
end

local function header(preview, label)
	local text = preview:CreateFontString(nil, "OVERLAY", "GameTooltipText")
	text:SetPoint("BOTTOMLEFT", preview, "TOPLEFT", 2, 1)
	text:SetText(label)
	local height = text:GetStringHeight() + 1
	preview:SetHitRectInsets(0, 0, -height, 0)
	preview:SetClampRectInsets(0, 0, height, 0)
end

local function addTextFrame(info)
	local preview = addMarker(info and L.Panel_InfoFrame or L.Panel_Range, DBM, info and "InfoFrame" or "RangeFrame")
	preview:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", tile = true, tileSize = 16})
	header(preview, info and L.Panel_InfoFrame or DBM_CORE_L.RANGECHECK_HEADER:format(10))
	local names = preview:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	names:SetPoint("TOPLEFT", 6, -6)
	names:SetJustifyH("LEFT")
	if info then
		names:SetText("Alpha\nBeta\nGamma")
		local values = preview:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		values:SetPoint("TOPRIGHT", -6, -6)
		values:SetJustifyH("RIGHT")
		values:SetText("1\n10\n25")
		preview.refresh = function()
			local o = DBM.Options
			local font = o.InfoFrameFont == "standardFont" and GameFontNormal:GetFont() or o.InfoFrameFont
			local flags = o.InfoFrameFontStyle:lower() ~= "none" and o.InfoFrameFontStyle or nil
			names:SetFont(font, o.InfoFrameFontSize, flags)
			values:SetFont(font, o.InfoFrameFontSize, flags)
			preview:SetSize(names:GetStringWidth() + values:GetStringWidth() + 20, names:GetStringHeight() + 12)
		end
	else
		names:SetText(UnitName("player"))
		preview:SetSize(128, 24)
	end
end

local function addRadar()
	local preview = addMarker(L.PlacementRadar, DBM, "RangeFrameRadar")
	preview:SetSize(128, 128)
	header(preview, DBM_CORE_L.RANGERADAR_HEADER:format(10))
	local bg = preview:CreateTexture(nil, "BACKGROUND")
	bg:SetAllPoints()
	bg:SetTexture(0, 0, 0, 0.3)
	local circle = preview:CreateTexture(nil, "ARTWORK")
	circle:SetPoint("CENTER")
	circle:SetSize(85, 85)
	circle:SetTexture("Interface\\AddOns\\DBM-Core\\textures\\radar_circle.blp")
	circle:SetVertexColor(0, 1, 0)
	local player = preview:CreateTexture(nil, "OVERLAY")
	player:SetPoint("CENTER")
	player:SetSize(32, 32)
	player:SetTexture("Interface\\Minimap\\MinimapArrow.blp")
end

local function addBossHealth()
	local preview = addMarker(L.Panel_HPFrame, DBM, "HPFrame")
	preview:SetSize(60, 10) -- Same anchor as DBM-BossHealth.
	local bar = CreateFrame("Frame", "DBM_GUI_PlacementHealth", preview, "DBMBossHealthBarTemplate")
	bar:SetFrameStrata(preview:GetFrameStrata())
	bar:EnableMouse(false)
	local status = DBM_GUI_PlacementHealthBar
	local border = DBM_GUI_PlacementHealthBarBorder
	border:EnableMouse(false)
	DBM_GUI_PlacementHealthBarIcon:Hide()
	DBM_GUI_PlacementHealthBarName:SetText(L.Panel_HPFrame)
	DBM_GUI_PlacementHealthBarTimer:SetText("75%")
	status:SetStatusBarColor(0.25, 0.75, 0)
	status:SetValue(75)
	preview.refresh = function()
		local width, up = DBM.Options.HealthFrameWidth, DBM.Options.HealthFrameGrowUp
		bar:SetWidth(width)
		status:SetWidth(width * 0.95)
		border:SetWidth(width * 0.99)
		bar:ClearAllPoints()
		bar:SetPoint(up and "BOTTOM" or "TOP", preview, up and "TOP" or "BOTTOM")
		local inset = (60 - width) / 2
		preview:SetHitRectInsets(inset, inset, up and -20 or 0, up and 0 or -20)
		preview:SetClampRectInsets(inset, -inset, up and 20 or 0, up and 0 or -20)
	end
end

local function addArrow()
	local preview = addMarker(L.PlacementArrow, DBM, "Arrow", "ArrowPos")
	preview:SetSize(56, 42)
	local arrow = preview:CreateTexture(nil, "ARTWORK")
	arrow:SetAllPoints()
	arrow:SetTexture("Interface\\AddOns\\DBM-Core\\textures\\arrows\\Arrow.blp")
	arrow:SetTexCoord(0, 56/512, 0, 42/512)
end

local function createGrid()
	grid = CreateFrame("Frame", "DBM_GUI_PlacementGrid", UIParent)
	grid:Hide()
	grid:SetAllPoints(UIParent)
	grid:SetFrameStrata("FULLSCREEN_DIALOG")
	grid:EnableMouse(true)
	table.insert(UISpecialFrames, grid:GetName())

	local shade = grid:CreateTexture(nil, "BACKGROUND")
	shade:SetAllPoints()
	shade:SetTexture(0, 0, 0, 0.5)
	local hint = grid:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	hint:SetPoint("TOP", 0, -12)
	hint:SetText(L.PlacementGridHint)
	local close = CreateFrame("Button", nil, grid, "UIPanelButtonTemplate")
	close:SetSize(100, 24)
	close:SetPoint("TOP", hint, "BOTTOM", 0, -4)
	close:SetText(CLOSE)
	close:SetScript("OnClick", function()
		grid:Hide()
		DBM_GUI_OptionsFrame:Show()
	end)

	-- Keep the smaller text frames accessible where their default positions overlap the radar.
	addRadar()
	addBar(L.PlacementSmallBars, false)
	addBar(L.PlacementLargeBars, true)
	addWarning(false)
	addWarning(true)
	addTextFrame(true)
	addTextFrame(false)
	addBossHealth()
	addArrow()

	grid:SetScript("OnShow", function()
		drawGrid()
		for _, marker in ipairs(markers) do
			local options = marker.owner.Options
			local origin = marker:GetParent()
			origin:SetPoint("CENTER", grid, options[marker.pointKey])
			if marker.refresh then marker.refresh() end
			marker.anchor = marker.attachPoint or options[marker.pointKey]
			marker.pin:SetPoint("CENTER", marker, marker.anchor)
			marker:ClearAllPoints()
			marker:SetPoint(marker.anchor, origin, "CENTER", options[marker.xKey], options[marker.yKey])
		end
	end)
	grid:SetScript("OnSizeChanged", function(self)
		if self:IsShown() then drawGrid() end
	end)
	grid:RegisterEvent("PLAYER_REGEN_DISABLED")
	grid:SetScript("OnEvent", function(self) self:Hide() end)
	DBM_GUI_OptionsFrame:HookScript("OnShow", function() grid:Hide() end)
end

function DBM_GUI:ShowPlacementGrid()
	if InCombatLockdown() then
		DBM:AddMsg(L.PlacementGridCombat)
		return
	end
	if not grid then createGrid() end
	DBM_GUI_OptionsFrame:Hide()
	grid:Show()
end
