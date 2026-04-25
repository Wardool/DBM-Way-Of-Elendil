local mod	= DBM:NewMod("WoeIxx", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50315)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 53472",
	"UNIT_DIED"
)

local warnPound			= mod:NewSpellAnnounce(53472, 2)

local specWarnPound		= mod:NewSpecialWarning("SpecWarnPound", nil, nil, nil, 2, 2, nil, nil, 53472)

local timerPoundCD		= mod:NewCDTimer(10, 53472, nil, nil, nil, 2)
local timerPoundCast	= mod:NewCastTimer(3.2, 53472, nil, nil, nil, 2)
local berserkTimer		= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerPoundCD:Start(10 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 53472 then
		warnPound:Show()
		specWarnPound:Show()
		specWarnPound:Play("watchstep")
		timerPoundCast:Start()
		timerPoundCD:Start(10)
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50315 then
		clearBossBannerCache()
	end
end
