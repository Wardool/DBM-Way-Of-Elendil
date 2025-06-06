local mod	= DBM:NewMod("Anomalus", "DBM-Party-WotLK", 8)
local L		= mod:GetLocalizedStrings()

mod.statTypes = "normal,heroic,mythic"

mod:SetRevision("20220806222721")
mod:SetCreatureID(26763)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED 47748",
	"UNIT_HEALTH"
)

local warningRiftSoon	= mod:NewSoonAnnounce(47748, 2)
local warningRiftNow	= mod:NewSpellAnnounce(47748, 3)

local warnedRift		= false

function mod:OnCombatStart()
	warnedRift = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 47748 then
		warningRiftNow:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if UnitName(uId) == L.name then
		local h = UnitHealth(uId) / UnitHealthMax(uId)
		if (h > 0.80) or (h < 0.70 and h > 0.55) or (h < 0.45 and h > 0.30) then
			warnedRift = false
		end
		if not warnedRift then
			if (h < 0.80 and h > 0.77) or (h < 0.55 and h > 0.52) or (h < 0.30 and h > 0.27) then
				warningRiftSoon:Show()
				warnedRift = true
			end
		end
	end
end
