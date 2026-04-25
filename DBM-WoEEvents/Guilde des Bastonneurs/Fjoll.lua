local mod	= DBM:NewMod("WoeFjoll", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50317)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local timerBlackHole	= mod:NewTimer(7, "TimerBlackHole")
local berserkTimer		= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:StartBlackHoleTimer()
	timerBlackHole:Start()
	self:ScheduleMethod(7, "StartBlackHoleTimer")
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerBlackHole:Start(7 - delay)
	self:ScheduleMethod(7 - delay, "StartBlackHoleTimer")
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
	if self:GetCIDFromGUID(args.destGUID) == 50317 then
		clearBossBannerCache()
	end
end
