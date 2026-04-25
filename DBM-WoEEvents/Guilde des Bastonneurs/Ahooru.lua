local mod	= DBM:NewMod("WoeAhooru", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604250001")
mod:SetCreatureID(50355)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 40733"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 68011",
	"SPELL_AURA_REMOVED 73326",
	"UNIT_DIED"
)

local specWarnHolyLight		= mod:NewSpecialWarningInterrupt(68011, nil, nil, nil, 2, 2)
local specWarnKillValkyr	= mod:NewSpecialWarning("SpecWarnKillValkyr", nil, nil, nil, 2, 2, nil, nil, 73326)
local warnValkyrRemaining	= mod:NewAnnounce("WarnValkyrRemaining", 2, 73326)
local berserkTimer			= mod:NewBerserkTimer(180)

mod.vb.valkyrCount = 0

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	self.vb.valkyrCount = 0
	berserkTimer:Start(180 - delay)
	specWarnKillValkyr:Show()
	specWarnKillValkyr:Play("killmob")
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 40733 and self:GetCIDFromGUID(args.destGUID) == 50355 and not self:IsInCombat() then
		DBM:StartCombat(self, 0, "SPELL_AURA_APPLIED 40733")
	end
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 68011 then
		specWarnHolyLight:Show(args.sourceName)
		specWarnHolyLight:Play("kickcast")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 73326 then
		local cid = self:GetCIDFromGUID(args.destGUID)
		if (cid == 50363 or cid == 50419) and self.vb.valkyrCount < 3 then
			self.vb.valkyrCount = self.vb.valkyrCount + 1
			warnValkyrRemaining:Show(3 - self.vb.valkyrCount)
		end
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50355 then
		clearBossBannerCache()
	end
end
