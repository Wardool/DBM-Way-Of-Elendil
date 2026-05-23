local GetGuildInfo = GetGuildInfo
local rebornGuildName = "R E B O R N"

local function getMainFrameIconTexture()
	local guildName = GetGuildInfo("player")
	if guildName == rebornGuildName then
		return "Interface\\AddOns\\DBM-GUI\\textures\\woe.blp"
	end
	return "Interface\\AddOns\\DBM-GUI\\textures\\dbm_airhorn.blp"
end

local function refreshMainFrameIcon()
	local frame = _G["DBM_GUI_OptionsFrame"]
	if frame and frame.DBMSkinIcon then
		frame.DBMSkinIcon:SetTexture(getMainFrameIconTexture())
	end
end

local function setCorner(corner, point, relativeTo, x, y, width, height)
	corner:ClearAllPoints()
	corner:SetPoint(point, relativeTo, x, y)
	corner:SetSize(width, height)
end

local function setEdge(edge, point1, relativeTo1, point2, relativeTo2, width, height)
	edge:ClearAllPoints()
	edge:SetSize(width, height)
	edge:SetPoint(point1, relativeTo1, point2, 0, 0)
	edge:SetPoint(point2, relativeTo2, point1, 0, 0)
end

local function updateNineSlice(frame)
	local nineSlice = frame.DBMSkinNineSlice
	if not nineSlice then
		return
	end

	setCorner(nineSlice.TopLeftCorner, "TOPLEFT", nineSlice, -13, 16, 75, 75)
	setCorner(nineSlice.TopRightCorner, "TOPRIGHT", nineSlice, 4, 16, 75, 75)
	setCorner(nineSlice.BottomLeftCorner, "BOTTOMLEFT", nineSlice, -13, -3, 32, 32)
	setCorner(nineSlice.BottomRightCorner, "BOTTOMRIGHT", nineSlice, 4, -3, 32, 32)

	setEdge(nineSlice.TopEdge, "TOPLEFT", nineSlice.TopLeftCorner, "TOPRIGHT", nineSlice.TopRightCorner, 32, 75)
	setEdge(nineSlice.BottomEdge, "BOTTOMLEFT", nineSlice.BottomLeftCorner, "BOTTOMRIGHT", nineSlice.BottomRightCorner, 32, 32)
	setEdge(nineSlice.LeftEdge, "TOPLEFT", nineSlice.TopLeftCorner, "BOTTOMLEFT", nineSlice.BottomLeftCorner, 75, 8)
	setEdge(nineSlice.RightEdge, "TOPLEFT", nineSlice.TopRightCorner, "BOTTOMLEFT", nineSlice.BottomRightCorner, 75, 8)
end

local function applyMainFrameSkin(frame)
	if not frame or frame.DBMSkinApplied then
		return
	end
	frame.DBMSkinApplied = true

	-- Remove default DBM backdrop, keep existing behavior/layout.
	frame:SetBackdrop(nil)

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UI-Background-Rock")
	bg:SetHorizTile(true)
	bg:SetVertTile(true)
	bg:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -21)
	bg:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -2, 2)
	bg:SetVertexColor(0.5882, 0.6275, 0.6706, 0.8)
	frame.DBMSkinBg = bg

	local topStreaks = frame:CreateTexture(nil, "BORDER")
	topStreaks:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameHorizontal")
	topStreaks:SetSize(256, 43)
	topStreaks:SetPoint("TOPLEFT", frame, "TOPLEFT", 6, -21)
	topStreaks:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -21)
	topStreaks:SetHorizTile(true)
	topStreaks:SetTexCoord(0, 1, 0.0078125, 0.34375)
	frame.DBMSkinTopStreaks = topStreaks

	-- Top-left icon (WoE)
	local icon = frame:CreateTexture(nil, "ARTWORK")
	icon:SetTexture(getMainFrameIconTexture())
	icon:SetSize(62, 62)
	icon:SetPoint("TOPLEFT", frame, "TOPLEFT", -5, 7)
	frame.DBMSkinIcon = icon

	local nineSlice = CreateFrame("Frame", nil, frame)
	nineSlice:SetAllPoints(frame)
	nineSlice:SetFrameLevel(frame:GetFrameLevel())
	frame.DBMSkinNineSlice = nineSlice

	local topLeft = nineSlice:CreateTexture(nil, "OVERLAY")
	topLeft:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetal2x")
	topLeft:SetTexCoord(0.00195312, 0.294922, 0.298828, 0.591797)
	nineSlice.TopLeftCorner = topLeft

	local topRight = nineSlice:CreateTexture(nil, "OVERLAY")
	topRight:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetal2x")
	topRight:SetTexCoord(0.298828, 0.591797, 0.00195312, 0.294922)
	nineSlice.TopRightCorner = topRight

	local bottomLeft = nineSlice:CreateTexture(nil, "OVERLAY")
	bottomLeft:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetal2x")
	bottomLeft:SetTexCoord(0.298828, 0.423828, 0.298828, 0.423828)
	nineSlice.BottomLeftCorner = bottomLeft

	local bottomRight = nineSlice:CreateTexture(nil, "OVERLAY")
	bottomRight:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetal2x")
	bottomRight:SetTexCoord(0.427734, 0.552734, 0.298828, 0.423828)
	nineSlice.BottomRightCorner = bottomRight

	local topEdge = nineSlice:CreateTexture(nil, "OVERLAY")
	topEdge:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetalHorizontal2x")
	topEdge:SetHorizTile(true)
	topEdge:SetTexCoord(0, 1, 0.00390625, 0.589844)
	nineSlice.TopEdge = topEdge

	local bottomEdge = nineSlice:CreateTexture(nil, "OVERLAY")
	bottomEdge:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetalHorizontal2x")
	bottomEdge:SetHorizTile(true)
	bottomEdge:SetTexCoord(0, 0.5, 0.597656, 0.847656)
	nineSlice.BottomEdge = bottomEdge

	local leftEdge = nineSlice:CreateTexture(nil, "OVERLAY")
	leftEdge:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetalVertical2x")
	leftEdge:SetVertTile(true)
	leftEdge:SetTexCoord(0.00195312, 0.294922, 0, 1)
	nineSlice.LeftEdge = leftEdge

	local rightEdge = nineSlice:CreateTexture(nil, "OVERLAY")
	rightEdge:SetTexture("Interface\\AddOns\\DBM-GUI\\textures\\UIFrameMetalVertical2x")
	rightEdge:SetVertTile(true)
	rightEdge:SetTexCoord(0.298828, 0.591797, 0, 1)
	nineSlice.RightEdge = rightEdge

	updateNineSlice(frame)
	frame:HookScript("OnSizeChanged", function(self)
		updateNineSlice(self)
	end)
end

local optionsFrame = _G["DBM_GUI_OptionsFrame"]
if optionsFrame then
	applyMainFrameSkin(optionsFrame)
	refreshMainFrameIcon()
end

local refreshFrame = CreateFrame("Frame")
refreshFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
refreshFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
refreshFrame:SetScript("OnEvent", function()
	refreshMainFrameIcon()
end)
