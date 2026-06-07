local setmetatable, type, ipairs, tinsert = setmetatable, type, ipairs, table.insert
local strfind, strlower, strgsub = string.find, string.lower, string.gsub
local DBM, DBM_GUI = DBM, DBM_GUI

local function normalizeSearchText(text)
	if type(text) ~= "string" then
		return ""
	end
	text = strgsub(text, "|c%x%x%x%x%x%x%x%x", "")
	text = strgsub(text, "|r", "")
	text = strgsub(text, "|H.-|h(.-)|h", "%1")
	text = strgsub(text, "|h", "")
	text = strgsub(text, "|T.-|t", " ")
	text = strgsub(text, "<.->", " ")
	text = strgsub(text, "&amp;", "&")
	text = strgsub(text, "&lt;", "<")
	text = strgsub(text, "&gt;", ">")
	text = strgsub(text, "%s+", " ")
	return strlower(text)
end

local function buildFrameSearchBlob(frame)
	if not frame then
		return ""
	end
	if frame.dbmSearchBlob then
		return frame.dbmSearchBlob
	end
	local chunks, visited = {}, {}
	local function addText(text)
		if type(text) == "string" and text ~= "" then
			chunks[#chunks + 1] = text
		end
	end
	local function walk(widget)
		if type(widget) ~= "table" or visited[widget] then
			return
		end
		visited[widget] = true
		addText(widget.displayName)
		addText(widget.text)
		if widget.TitleText and widget.TitleText.GetText then
			local ok, titleText = pcall(widget.TitleText.GetText, widget.TitleText)
			if ok then
				addText(titleText)
			end
		end
		if widget.GetObjectType and widget.GetText then
			local objType = widget:GetObjectType()
			if objType == "FontString" or objType == "SimpleHTML" or objType == "EditBox" then
				local ok, objText = pcall(widget.GetText, widget)
				if ok then
					addText(objText)
				end
			end
		end
		if widget.GetRegions then
			for _, region in ipairs({ widget:GetRegions() }) do
				walk(region)
			end
		end
		if widget.GetChildren then
			for _, child in ipairs({ widget:GetChildren() }) do
				walk(child)
			end
		end
	end
	walk(frame)
	frame.dbmSearchBlob = normalizeSearchText(table.concat(chunks, " "))
	return frame.dbmSearchBlob
end

local function entryMatchesSearch(entry, searchText)
	local displayName = normalizeSearchText(entry.frame.displayName or "")
	if displayName ~= "" and strfind(displayName, searchText, 1, true) then
		return true
	end
	local panelText = buildFrameSearchBlob(entry.frame)
	return panelText ~= "" and strfind(panelText, searchText, 1, true) ~= nil
end

local function GetDepth(self, parentID, depth) -- Called internally
	depth = depth or 1
	for _, v in ipairs(self.buttons) do
		if v.frame.ID == parentID then
			if not v.parentID then
				return depth + 1
			else
				depth = depth + GetDepth(self, v.parentID, depth)
			end
		end
	end
	return depth
end

local function GetVisibleSubTabs(self, parentID, tabs)
	for _, v in ipairs(self.buttons) do
		if v.parentID == parentID then
			tinsert(tabs, v)
			if v.frame.showSub then
				GetVisibleSubTabs(self, v.frame.ID, tabs)
			end
		end
	end
end

local function SetParentHasChilds(self, parentID)
	if not parentID then
		return
	end
	for _, v in ipairs(self.buttons) do
		if v.frame.ID == parentID then
			v.frame.haschilds = true
		end
	end
end

local ListFrameButtonsPrototype = {}

function ListFrameButtonsPrototype:CreateCategory(frame, parentID)
	if type(frame) ~= "table" then
		DBM:AddMsg("Failed to create category - frame is not a table")
		return false
	end
	frame.depth = parentID and GetDepth(self, parentID) or 1
	SetParentHasChilds(self, parentID)
	tinsert(self.buttons, {
		frame		= frame,
		parentID	= parentID
	})
	return #self.buttons
end

function ListFrameButtonsPrototype:GetVisibleTabs()
	local tabs = {}
	for _, v in ipairs(self.buttons) do
		if not v.parentID then
			tinsert(tabs, v)
			if v.frame.showSub then
				GetVisibleSubTabs(self, v.frame.ID, tabs)
			end
		end
	end
	return tabs
end

function ListFrameButtonsPrototype:GetFilteredTabs(searchText)
	searchText = type(searchText) == "string" and strgsub(strgsub(searchText, "^%s+", ""), "%s+$", "") or ""
	if searchText == "" then
		return self:GetVisibleTabs()
	end
	searchText = normalizeSearchText(searchText)

	local childrenByParent = {}
	local roots = {}
	for _, entry in ipairs(self.buttons) do
		if entry.parentID then
			if not childrenByParent[entry.parentID] then
				childrenByParent[entry.parentID] = {}
			end
			tinsert(childrenByParent[entry.parentID], entry)
		else
			tinsert(roots, entry)
		end
	end

	local selfMatches = {}
	local subTreeMatches = {}
	local function scan(entry)
		local id = entry.frame.ID
		local matches = entryMatchesSearch(entry, searchText)
		selfMatches[id] = matches
		local childMatches = false
		for _, child in ipairs(childrenByParent[id] or {}) do
			if scan(child) then
				childMatches = true
			end
		end
		subTreeMatches[id] = matches or childMatches
		return subTreeMatches[id]
	end
	for _, root in ipairs(roots) do
		scan(root)
	end

	local results, added = {}, {}
	local function add(entry)
		local id = entry.frame.ID
		if not added[id] then
			added[id] = true
			tinsert(results, entry)
		end
	end

	local function emit(entry, includeAllChildren)
		local id = entry.frame.ID
		if not subTreeMatches[id] and not includeAllChildren then
			return
		end
		add(entry)
		local passIncludeAll = includeAllChildren or selfMatches[id]
		for _, child in ipairs(childrenByParent[id] or {}) do
			emit(child, passIncludeAll)
		end
	end

	for _, root in ipairs(roots) do
		emit(root, false)
	end

	return results
end

function DBM_GUI:CreateNewFauxScrollFrameList()
	local mt = setmetatable({
		buttons = {}
	}, {
		__index = ListFrameButtonsPrototype
	})
	self.tabs[#self.tabs + 1] = mt
	return mt
end

-- TODO: Should this go somewhere else?
_G["DBM_GUI_Options"] = DBM_GUI:CreateNewFauxScrollFrameList()
_G["DBM_GUI_Raids"] = DBM_GUI:CreateNewFauxScrollFrameList()
_G["DBM_GUI_Dungeons"] = DBM_GUI:CreateNewFauxScrollFrameList()
_G["DBM_GUI_Other"] = DBM_GUI:CreateNewFauxScrollFrameList()
-- Compatibility alias for old external references.
_G["DBM_GUI_Bosses"] = _G["DBM_GUI_Raids"]
