local mod	= DBM:NewMod("WoeMilhouse", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50328, 50329)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 70127",
	"SPELL_AURA_APPLIED_DOSE 70127",
	"UNIT_DIED"
)

local specWarnMysticBarrage	= mod:NewSpecialWarning("SpecWarnMysticBarrageSwitch", nil, nil, nil, 2, 2, nil, nil, 70127)
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

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 70127 and args:IsPlayer() and self:AntiSpam(2, 70127) then
		specWarnMysticBarrage:Show()
		specWarnMysticBarrage:Play("targetchange")
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50328 then
		clearBossBannerCache()
	end
end
