local mod	= DBM:NewMod("WoeUck", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50314)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68989",
	"SPELL_CAST_SUCCESS 70341 69021",
	"SPELL_DAMAGE 70346",
	"UNIT_DIED"
)

local warnPoisonNova			= mod:NewSpellAnnounce(68989, 3)
local warnPuddle				= mod:NewSpellAnnounce(70341, 2)
local warnKick					= mod:NewSpellAnnounce(69021, 2)

local specWarnPoisonNova		= mod:NewSpecialWarningRun(68989, nil, nil, nil, 2, 2)
local specWarnPuddleRun		= mod:NewSpecialWarningRun(70341, nil, nil, nil, 2, 2)
local specWarnPuddle			= mod:NewSpecialWarningMove(70346, nil, nil, nil, 1, 2)

local timerPoisonNovaCD			= mod:NewCDTimer(24, 68989, nil, nil, nil, 3)
local timerPoisonNovaCast		= mod:NewCastTimer(5, 68989, nil, nil, nil, 2)
local timerPuddleCD				= mod:NewCDTimer(11, 70341, nil, nil, nil, 2)
local timerKickCD				= mod:NewCDTimer(16, 69021, nil, nil, nil, 2)
local berserkTimer				= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerPuddleCD:Start(5 - delay)
	timerKickCD:Start(10 - delay)
	timerPoisonNovaCD:Start(12 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 68989 then
		warnPoisonNova:Show()
		specWarnPoisonNova:Show()
		specWarnPoisonNova:Play("justrun")
		timerPoisonNovaCast:Start()
		timerPoisonNovaCD:Start("v23-25")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 70341 then
		warnPuddle:Show()
		specWarnPuddleRun:Show()
		specWarnPuddleRun:Play("runout")
		timerPuddleCD:Start("v10-15")
	elseif args.spellId == 69021 then
		warnKick:Show()
		timerKickCD:Start("v14-18")
	end
end

function mod:SPELL_DAMAGE(args)
	if args.spellId == 70346 and args:IsPlayer() and self:AntiSpam(1.5, 1) then
		specWarnPuddle:Show()
		specWarnPuddle:Play("watchfeet")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50314 then
		clearBossBannerCache()
	end
end
