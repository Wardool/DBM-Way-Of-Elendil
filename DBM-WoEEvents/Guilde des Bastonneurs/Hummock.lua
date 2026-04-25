local mod	= DBM:NewMod("WoeHummock", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240001")
mod:SetCreatureID(50327)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"UNIT_DIED"
)

local specWarnIceSphere	= mod:NewSpecialWarning("SpecWarnIceSphereKite", nil, nil, nil, 2, 2)
local timerNextSphere	= mod:NewTimer(5, "TimerNextSphere", nil, nil, nil, 6)
local timerIceSphere	= mod:NewTimer(11, "TimerIceSphereDur", nil, nil, nil, 6)
local berserkTimer		= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	specWarnIceSphere:Show()
	specWarnIceSphere:Play("justrun")
end

function mod:StartIceSphereDuration()
	timerIceSphere:Start()
end

function mod:OnCombatEnd()
	timerNextSphere:Stop()
	timerIceSphere:Stop()
	self:UnscheduleMethod("StartIceSphereDuration")
	clearBossBannerCache()
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50369 then
		timerNextSphere:Start()
		self:UnscheduleMethod("StartIceSphereDuration")
		self:ScheduleMethod(5, "StartIceSphereDuration")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50327 then
		clearBossBannerCache()
	end
end
