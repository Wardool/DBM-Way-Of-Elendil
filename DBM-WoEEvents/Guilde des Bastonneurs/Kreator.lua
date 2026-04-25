local mod	= DBM:NewMod("WoeKreator", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604250001")
mod:SetCreatureID(51102)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL"
)

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 65129",
	"SPELL_AURA_APPLIED 66776",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED"
)

local specWarnRageWipe	= mod:NewSpecialWarning("SpecWarnRageWipe", nil, nil, nil, 3, 2, nil, nil, 66776)
local timerCombatStart	= mod:NewCombatTimer(40)
local timerMeteor		= mod:NewTimer(20, "TimerMeteor", 65129, nil, nil, 3)
local timerInstantDeath	= mod:NewTimer(75, "TimerInstantDeath", nil, nil, nil, 6)

mod.vb.phase = 1

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart()
	self.vb.phase = 1
	timerMeteor:Start("v15-20")
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg and msg:find("Je vois... Crois-tu réellement pouvoir vaincre le fondateur", nil, true) then
		timerCombatStart:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 65129 then
		timerMeteor:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 66776 and self:GetCIDFromGUID(args.destGUID) == 51102 and self.vb.phase < 3 then
		specWarnRageWipe:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == "Phase 2" then
		self.vb.phase = 2
		timerMeteor:Stop()
	elseif msg == "Phase 3" then
		self.vb.phase = 3
		timerMeteor:Start("v15-20")
		timerInstantDeath:Start()
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 51102 then
		clearBossBannerCache()
	end
end
