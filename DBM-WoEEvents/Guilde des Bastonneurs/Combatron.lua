local mod	= DBM:NewMod("WoeCombatron", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604250001")
mod:SetCreatureID(50348)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEvents(
	"PLAYER_TARGET_CHANGED"
)

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local specWarnNoAOE			= mod:NewSpecialWarning("SpecWarnNoAOE", nil, nil, nil, 2, 2)
local berserkTimer			= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:PLAYER_TARGET_CHANGED()
	if self:IsInCombat() then
		return
	end
	local cid = self:GetCIDFromGUID(UnitGUID("target"))
	if cid and cid >= 50349 and cid <= 50354 then
		DBM:StartCombat(self, 0, "Combatron mine targeted")
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	specWarnNoAOE:Show()
	specWarnNoAOE:Play("careful")
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50348 then
		clearBossBannerCache()
	end
end
