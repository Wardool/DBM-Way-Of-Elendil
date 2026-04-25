local mod	= DBM:NewMod("WoeBalafre", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50303)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 50335",
	"SPELL_AURA_APPLIED 33661 72219",
	"SPELL_AURA_APPLIED_DOSE 33661 72219",
	"UNIT_DIED"
)

local warnScourgeHook			= mod:NewSpellAnnounce(50335, 3)
local warnArmorCrush			= mod:NewStackAnnounce(33661, 2)
local warnGastricBloat			= mod:NewStackAnnounce(72219, 2)

local specWarnScourgeHook		= mod:NewSpecialWarningDefensive(50335, nil, nil, nil, 1, 2)
local specWarnArmorCrush		= mod:NewSpecialWarningStack(33661, nil, 5, nil, nil, 1, 6)
local specWarnGastricBloat		= mod:NewSpecialWarningStack(72219, nil, 5, nil, nil, 1, 6)

local timerScourgeHookCast		= mod:NewCastTimer(1, 50335, nil, nil, nil, 5, nil, DBM_COMMON_L.TANK_ICON)
local berserkTimer				= mod:NewBerserkTimer(119)

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
	if args.spellId == 50335 then
		warnScourgeHook:Show()
		specWarnScourgeHook:Show()
		specWarnScourgeHook:Play("defensive")
		timerScourgeHookCast:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 33661 then
		local amount = args.amount or 1
		warnArmorCrush:Show(args.destName, amount)
		if args:IsPlayer() and amount >= 5 then
			specWarnArmorCrush:Show(amount)
			specWarnArmorCrush:Play("stackhigh")
		end
	elseif args.spellId == 72219 then
		local amount = args.amount or 1
		warnGastricBloat:Show(args.destName, amount)
		if args:IsPlayer() and amount >= 6 then
			specWarnGastricBloat:Show(amount)
			specWarnGastricBloat:Play("stackhigh")
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50303 then
		clearBossBannerCache()
	end
end
