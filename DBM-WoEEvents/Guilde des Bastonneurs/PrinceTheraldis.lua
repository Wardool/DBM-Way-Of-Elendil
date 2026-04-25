local mod	= DBM:NewMod("WoePrinceTheraldis", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240002")
mod:SetCreatureID(50338)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 24021",
	"SPELL_AURA_REFRESH 24021",
	"UNIT_DIED"
)

local specWarnGreenOrbs	= mod:NewSpecialWarning("SpecWarnGreenOrbsKite", nil, nil, nil, 2, 2)
local timerCarapace		= mod:NewBuffActiveTimer(8, 24021, nil, nil, nil, 5)
local berserkTimer		= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	specWarnGreenOrbs:Show()
	specWarnGreenOrbs:Play("targetyou")
end

function mod:OnCombatEnd()
	timerCarapace:Stop()
	clearBossBannerCache()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 24021 and args:IsPlayer() then
		timerCarapace:Start()
	end
end

mod.SPELL_AURA_REFRESH = mod.SPELL_AURA_APPLIED

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50338 then
		clearBossBannerCache()
	end
end
