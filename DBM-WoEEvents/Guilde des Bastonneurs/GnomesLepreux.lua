local mod	= DBM:NewMod("WoeGnomesLepreux", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50330, 50331, 50332, 50333, 50334)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local berserkTimer = mod:NewBerserkTimer(119)

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

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 50330 or cid == 50331 or cid == 50332 or cid == 50333 or cid == 50334 then
		clearBossBannerCache()
	end
end
