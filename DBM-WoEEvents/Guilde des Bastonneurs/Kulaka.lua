local mod	= DBM:NewMod("WoeKulaka", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50311)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 71022",
	"SPELL_CAST_SUCCESS 43317",
	"UNIT_DIED"
)

local warnHaste					= mod:NewSpellAnnounce(43317, 2)

local specWarnDisturbingCry		= mod:NewSpecialWarningCast(71022, "Caster", nil, nil, 1, 2)

local timerDisturbingCryCD		= mod:NewCDTimer(10, 71022, nil, "Caster", nil, 4)
local timerHasteCD				= mod:NewCDTimer(17, 43317, nil, nil, nil, 2)
local berserkTimer				= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerDisturbingCryCD:Start(5 - delay)
	timerHasteCD:Start(5 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 71022 then
		specWarnDisturbingCry:Show()
		specWarnDisturbingCry:Play("stopcast")
		timerDisturbingCryCD:Start("v10-11")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 43317 then
		warnHaste:Show()
		timerHasteCD:Start("v15-19")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50311 then
		clearBossBannerCache()
	end
end
