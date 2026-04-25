local mod	= DBM:NewMod("WoeBoulette", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50321)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local specWarnBloodOrbs	= mod:NewSpecialWarning("SpecWarnBloodOrbs", nil, nil, nil, 2, 2)
local berserkTimer		= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	specWarnBloodOrbs:Show()
	specWarnBloodOrbs:Play("targetyou")
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
	if self:GetCIDFromGUID(args.destGUID) == 50321 then
		clearBossBannerCache()
	end
end
