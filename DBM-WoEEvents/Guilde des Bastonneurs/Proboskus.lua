local mod	= DBM:NewMod("WoeProboskus", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240002")
mod:SetCreatureID(50337)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 64653",
	"SPELL_CAST_SUCCESS 38153",
	"UNIT_SPELLCAST_SUCCEEDED",
	"UNIT_DIED"
)

local specWarnBlizzard		= mod:NewSpecialWarningRun(64653, nil, nil, nil, 2, 2)
local specWarnFrostPillar	= mod:NewSpecialWarning("SpecWarnFrostPillarRun", nil, nil, nil, 2, 2)

local timerBlizzardCD		= mod:NewCDTimer(20, 64653, nil, nil, nil, 2)
local timerFrostPillarCD	= mod:NewTimer(10, "TimerFrostPillarCD", nil, nil, nil, 2)
local timerAcidRainCD		= mod:NewCDTimer(20, 38153, nil, nil, nil, 3)
local berserkTimer			= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 64653 then
		specWarnBlizzard:Show()
		specWarnBlizzard:Play("runout")
		timerBlizzardCD:Start("v17-20")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 38153 then
		timerAcidRainCD:Start(20)
	end
end

function mod:UNIT_SPELLCAST_SUCCEEDED(_, spellName)
	if spellName == GetSpellInfo(70704) then
		specWarnFrostPillar:Show()
		specWarnFrostPillar:Play("runout")
		timerFrostPillarCD:Start(10)
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50337 then
		clearBossBannerCache()
	end
end
