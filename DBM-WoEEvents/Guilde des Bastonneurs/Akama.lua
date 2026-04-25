local mod	= DBM:NewMod("WoeAkama", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50304)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 41183",
	"SPELL_CAST_SUCCESS 53071 71877",
	"UNIT_DIED"
)

local warnChainLightning		= mod:NewSpellAnnounce(41183, 2)
local warnNecroticTouch			= mod:NewSpellAnnounce(71877, 3)
local warnThunderstorm			= mod:NewSpellAnnounce(53071, 3)

local specWarnChainLightning	= mod:NewSpecialWarningInterrupt(41183, "HasInterrupt", nil, nil, 1, 2)
local specWarnThunderstorm		= mod:NewSpecialWarningSpell(53071, nil, nil, nil, 2, 2)

local timerChainLightningCD		= mod:NewCDTimer(17, 41183, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerChainLightningCast	= mod:NewCastTimer(3, 41183, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerNecroticTouchCD		= mod:NewCDTimer(21, 71877, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local timerThunderstormCD		= mod:NewCDTimer(30.5, 53071, nil, nil, nil, 3)
local berserkTimer				= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerChainLightningCD:Start(5)
	timerNecroticTouchCD:Start(1)
	timerThunderstormCD:Start(15)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 41183 then
		warnChainLightning:Show()
		specWarnChainLightning:Show(args.sourceName)
		specWarnChainLightning:Play("kickcast")
		timerChainLightningCast:Start()
		timerChainLightningCD:Start("v15-18")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 71877 then
		warnNecroticTouch:Show()
		timerNecroticTouchCD:Start("v20-23")
	elseif args.spellId == 53071 then
		warnThunderstorm:Show()
		specWarnThunderstorm:Show()
		specWarnThunderstorm:Play("watchstep")
		timerThunderstormCD:Start("v30-31")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50304 then
		clearBossBannerCache()
	end
end
