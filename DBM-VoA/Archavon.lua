local mod	= DBM:NewMod("Archavon", "DBM-VoA")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20220924192907")
mod:SetCreatureID(31125)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 58663 60880",
	"SPELL_CAST_SUCCESS 58963 60895",
	"SPELL_AURA_APPLIED 58678 58941",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnShards			= mod:NewTargetNoFilterAnnounce(58678, 2)
local warnGrab				= mod:NewAnnounce("WarningGrab", 4, 53041)
local warnLeap				= mod:NewSpellAnnounce(60894, 3)
local warnStomp				= mod:NewSpellAnnounce(60880, 3)
local warnStompSoon			= mod:NewPreWarnAnnounce(60880, 5, 2)

local timerNextStomp		= mod:NewNextTimer(45, 60880, nil, nil, nil, 2)
local timerShards			= mod:NewTargetTimer(4, 58678, nil, nil, nil, 3)
local timerArchavonEnrage	= mod:NewBerserkTimer(300, nil, "ArchavonEnrage")

function mod:OnCombatStart(delay)
	timerArchavonEnrage:Start()
	timerNextStomp:Start(49.4-delay)
	warnStompSoon:Schedule(40-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(58663, 60880) then
		warnStomp:Show()
		timerNextStomp:Start()
		warnStompSoon:Schedule(40)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(58963, 60895) then
		warnLeap:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(58678, 58941) then
		warnShards:Show(args.destName)
		timerShards:Start(args.destName)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, _, _, _, target)
	if msg and msg:match(L.TankSwitch) or msg:find(L.TankSwitch) then
		warnGrab:Show(DBM:GetUnitFullName(target))
	end
end
