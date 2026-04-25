local mod	= DBM:NewMod("WoeBigBaddaBoom", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50323)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 49956",
	"SPELL_AURA_APPLIED_DOSE 49956",
	"UNIT_DIED"
)

local specWarnBurningWoundSlow	= mod:NewSpecialWarning("SpecWarnBurningWoundSlowDPS", nil, nil, nil, 2, 2, nil, nil, 49956)
local specWarnBurningWoundStop	= mod:NewSpecialWarning("SpecWarnBurningWoundStopDPS", nil, nil, nil, 3, 2, nil, nil, 49956)
local berserkTimer				= mod:NewBerserkTimer(119)

mod.vb.ittaBoomDeaths = 0

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	self.vb.ittaBoomDeaths = 0
	berserkTimer:Start(119 - delay)
	self:RegisterShortTermEvents("PLAYER_TARGET_CHANGED")
	self:CheckNextBossTarget()
end

function mod:OnCombatEnd()
	self:UnregisterShortTermEvents()
	clearBossBannerCache()
end

function mod:CheckNextBossTarget()
	if self:GetCIDFromGUID(UnitGUID("target")) == 50327 then
		clearBossBannerCache()
		DBM:EndCombat(self)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 49956 and args:IsPlayer() then
		local amount = args.amount or 1
		if amount >= 4 and self:AntiSpam(1, 499564) then
			specWarnBurningWoundStop:Show()
			specWarnBurningWoundStop:Play("stopattack")
		elseif amount == 3 and self:AntiSpam(1, 499563) then
			specWarnBurningWoundSlow:Show()
			specWarnBurningWoundSlow:Play("stackhigh")
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
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 50326 then
		self.vb.ittaBoomDeaths = self.vb.ittaBoomDeaths + 1
		if self.vb.ittaBoomDeaths >= 8 then
			clearBossBannerCache()
			DBM:EndCombat(self)
		end
	elseif cid == 50323 then
		clearBossBannerCache()
	end
end

function mod:PLAYER_TARGET_CHANGED()
	self:CheckNextBossTarget()
end
