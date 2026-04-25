local mod	= DBM:NewMod("WoeHoxoos", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50340)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local specWarnHalionKite	= mod:NewSpecialWarning("SpecWarnHalionKite", nil, nil, nil, 2, 2)
local berserkTimer			= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	specWarnHalionKite:Show()
	specWarnHalionKite:Play("justrun")
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
	if self:GetCIDFromGUID(args.destGUID) == 50340 then
		clearBossBannerCache()
	end
end
