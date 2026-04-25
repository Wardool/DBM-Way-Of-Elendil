local mod	= DBM:NewMod("WoeKirrawk", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50307)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 57408 51587",
	"SPELL_AURA_APPLIED 57408",
	"UNIT_DIED"
)

local warnStormCloud			= mod:NewSpellAnnounce(57408, 3)
local warnLightning				= mod:NewSpellAnnounce(51587, 2)

local specWarnStormCloud		= mod:NewSpecialWarningSpell(57408, nil, nil, nil, 2, 2)
local specWarnLightning			= mod:NewSpecialWarningInterrupt(51587, "HasInterrupt", nil, nil, 1, 2)

local timerStormCloudCD			= mod:NewCDTimer(20, 57408, nil, nil, nil, 3)
local timerLightningCD			= mod:NewCDTimer(15, 51587, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local timerLightningCast		= mod:NewCastTimer(2, 51587, nil, nil, nil, 4, nil, DBM_COMMON_L.INTERRUPT_ICON)
local berserkTimer				= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerStormCloudCD:Start(3 - delay)
	timerLightningCD:Start(10 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 57408 then
		warnStormCloud:Show()
		specWarnStormCloud:Show()
		specWarnStormCloud:Play("aesoon")
		timerStormCloudCD:Start("v20-21")
	elseif args.spellId == 51587 then
		warnLightning:Show()
		specWarnLightning:Show(args.sourceName)
		specWarnLightning:Play("kickcast")
		timerLightningCast:Start()
		timerLightningCD:Start("v15-16")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 57408 then
		timerStormCloudCD:Start("v20-21")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50307 then
		clearBossBannerCache()
	end
end
