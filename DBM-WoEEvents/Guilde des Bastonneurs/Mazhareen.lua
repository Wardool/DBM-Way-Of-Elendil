local mod	= DBM:NewMod("WoeMazhareen", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50316)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 59707",
	"SPELL_AURA_APPLIED 59707",
	"SPELL_AURA_APPLIED_DOSE 59707",
	"UNIT_DIED"
)

mod.vb.defensiveWarned = false

local warnEnrage			= mod:NewStackAnnounce(59707, 2)

local specWarnEnrageDef		= mod:NewSpecialWarning("SpecWarnEnrageDefensive", nil, nil, nil, 2, 2, nil, nil, 59707)

local timerEnrageCD			= mod:NewCDTimer(2.1, 59707, nil, nil, nil, 2)
local berserkTimer			= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	self.vb.defensiveWarned = false
	berserkTimer:Start(119 - delay)
	timerEnrageCD:Start(2 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 59707 then
		timerEnrageCD:Start("v2-3")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 59707 then
		local amount = args.amount or 1
		warnEnrage:Show(args.destName, amount)
		if amount >= 10 and not self.vb.defensiveWarned then
			self.vb.defensiveWarned = true
			specWarnEnrageDef:Show()
			specWarnEnrageDef:Play("defensive")
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
	if self:GetCIDFromGUID(args.destGUID) == 50316 then
		clearBossBannerCache()
	end
end
