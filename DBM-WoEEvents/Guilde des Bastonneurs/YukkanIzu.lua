local mod	= DBM:NewMod("WoeYukkanIzu", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604240002")
mod:SetCreatureID(50335)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 40184",
	"UNIT_DIED"
)

local warnParalyzingHowl		= mod:NewSpellAnnounce(40184, 3)
local timerParalyzingHowlCD		= mod:NewCDTimer(20, 40184, nil, nil, nil, 2)
local timerParalyzingHowlCast	= mod:NewCastTimer(5, 40184, nil, nil, nil, 2)
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
	if args.spellId == 40184 then
		warnParalyzingHowl:Show()
		timerParalyzingHowlCast:Start()
		timerParalyzingHowlCD:Start("v17-24")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50335 then
		clearBossBannerCache()
	end
end
