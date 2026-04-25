local mod	= DBM:NewMod("WoeSanoriak", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50302)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 29925",
	"SPELL_CAST_SUCCESS 11113 19717",
	"SPELL_AURA_APPLIED 19717",
	"UNIT_DIED"
)

local warnRainOfFire			= mod:NewSpellAnnounce(19717, 3)
local warnExplosiveWave			= mod:NewSpellAnnounce(11113, 2)
local warnFireball				= mod:NewSpellAnnounce(29925, 2)

local specWarnRainOfFire		= mod:NewSpecialWarningMove(19717, nil, nil, nil, 1, 2)
local specWarnExplosiveWave		= mod:NewSpecialWarningSpell(11113, nil, nil, nil, 2, 2)
local specWarnFireball			= mod:NewSpecialWarningInterrupt(29925, "HasInterrupt", nil, nil, 1, 2)

local timerRainOfFireCD			= mod:NewCDTimer(12.5, 19717, nil, nil, nil, 3)
local timerExplosiveWaveCD		= mod:NewCDTimer(22.5, 11113, nil, nil, nil, 2)
local timerFireballCD			= mod:NewCDTimer(17.5, 29925, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerFireballCast			= mod:NewCastTimer(2, 29925, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local berserkTimer				= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerRainOfFireCD:Start(5)
	timerExplosiveWaveCD:Start(15)
	timerFireballCD:Start(10)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 29925 then
		warnFireball:Show()
		specWarnFireball:Show(args.sourceName)
		specWarnFireball:Play("kickcast")
		timerFireballCast:Start()
		timerFireballCD:Start("v15-20")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 19717 then
		warnRainOfFire:Show()
		timerRainOfFireCD:Start("v10-15")
	elseif args.spellId == 11113 then
		warnExplosiveWave:Show()
		specWarnExplosiveWave:Show()
		specWarnExplosiveWave:Play("watchstep")
		timerExplosiveWaveCD:Start("v20-25")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 19717 and args:IsPlayer() then
		specWarnRainOfFire:Show()
		specWarnRainOfFire:Play("runaway")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50302 then
		clearBossBannerCache()
	end
end
