local mod	= DBM:NewMod("WoeSombreInvocateur", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604250001")
mod:SetCreatureID(50345)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEvents(
	"SPELL_AURA_APPLIED 50161"
)

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local specWarnGhostLight	= mod:NewSpecialWarning("SpecWarnGhostLight", nil, nil, nil, 2, 2)
local berserkTimer			= mod:NewBerserkTimer(180)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(180 - delay)
	specWarnGhostLight:Show()
	specWarnGhostLight:Play("justrun")
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 50161 and self:GetCIDFromGUID(args.destGUID) == 50345 and not self:IsInCombat() then
		DBM:StartCombat(self, 0, "SPELL_AURA_APPLIED 50161")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50345 then
		clearBossBannerCache()
	end
end
