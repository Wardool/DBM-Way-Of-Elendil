local mod	= DBM:NewMod("WoeArenaController", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230002")
mod.noStatistics = true

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnNextBoss	= mod:NewAnnounce("WarnNextBoss", 2)
local timerNextBoss	= mod:NewTimer(15, "TimerNextBoss")

function mod:OnInitialize()
	self.Options.WarnNextBoss = true
	self.Options.TimerNextBoss = true
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	local nextBoss = msg:match("^(.-) appara.-dans 15 secondes")
	if not nextBoss then
		nextBoss = msg:match("^([^!]+)!$")
	end
	if not nextBoss or nextBoss == "" then
		return
	end
	warnNextBoss:Show(nextBoss)
	timerNextBoss:Start(nextBoss)
end
