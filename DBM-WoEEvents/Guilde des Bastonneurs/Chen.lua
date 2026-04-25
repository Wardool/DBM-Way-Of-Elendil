local mod	= DBM:NewMod("WoeChen", "DBM-WoEEvents", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("202604230001")
mod:SetCreatureID(50309)
mod:SetReCombatTime(10)

mod:RegisterCombat("combat")
mod:DisableRegenDetection()

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 43185 14822 65129",
	"SPELL_DAMAGE 65129",
	"UNIT_DIED"
)

local warnHealingPotion			= mod:NewSpellAnnounce(43185, 3)
local warnDrunkenRage			= mod:NewSpellAnnounce(14822, 2)
local warnBarrelExplosion		= mod:NewSpellAnnounce(65129, 2)

local specWarnBarrelExplosion	= mod:NewSpecialWarningMove(65129, nil, nil, nil, 1, 2)

local timerHealingPotionCD		= mod:NewCDTimer(25, 43185, nil, nil, nil, 3)
local timerDrunkenRageCD		= mod:NewCDTimer(25, 14822, nil, nil, nil, 2)
local timerBarrelCD				= mod:NewCDTimer(10, 65129, nil, nil, nil, 2)
local berserkTimer				= mod:NewBerserkTimer(119)

local function clearBossBannerCache()
	if BossBanner and BossBanner.ClearEncounterCache then
		BossBanner:ClearEncounterCache()
	end
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(119 - delay)
	timerHealingPotionCD:Start(10 - delay)
	timerDrunkenRageCD:Start(11 - delay)
	timerBarrelCD:Start(14 - delay)
end

function mod:OnCombatEnd()
	clearBossBannerCache()
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 43185 then
		warnHealingPotion:Show()
		timerHealingPotionCD:Start("v25-26")
	elseif args.spellId == 14822 then
		warnDrunkenRage:Show()
		timerDrunkenRageCD:Start("v25-26")
	elseif args.spellId == 65129 then
		warnBarrelExplosion:Show()
		timerBarrelCD:Start(10)
	end
end

function mod:SPELL_DAMAGE(args)
	if args.spellId == 65129 and args:IsPlayer() and self:AntiSpam(2, 1) then
		specWarnBarrelExplosion:Show()
		specWarnBarrelExplosion:Play("watchfeet")
	end
end

function mod:UNIT_DIED(args)
	local playerGUID = UnitGUID("player")
	if playerGUID and args.destGUID == playerGUID then
		DBM:EndCombat(self, true, nil, "Player died")
		return
	end
	if self:GetCIDFromGUID(args.destGUID) == 50309 then
		clearBossBannerCache()
	end
end
