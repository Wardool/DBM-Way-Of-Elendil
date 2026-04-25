local mod	= DBM:NewMod("WoeCrochet", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50318)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 53400",
	"UNIT_DIED"
)

local timerAcidCloudCD	= mod:NewCDTimer(6, 53400, nil, nil, nil, 3)
local specWarnAcidCloud	= mod:NewSpecialWarningRun(53400, nil, nil, nil, 2, 2)
local berserkTimer		= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerAcidCloudCD:Start(5 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 53400 then
		specWarnAcidCloud:Show()
		specWarnAcidCloud:Play("runout")
		timerAcidCloudCD:Start(6)
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50318 then
		clearBossBannerCache()
	end
end
