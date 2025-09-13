local mod	= DBM:NewMod("Auriaya", "DBM-Ulduar")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20221031104000")

mod:SetCreatureID(33515)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 64678 64389 64386 64688 64422",
	"SPELL_AURA_APPLIED 64396 64455",
	"SPELL_DAMAGE 64459 64675",
	"SPELL_MISSED 64459 64675",
	"UNIT_DIED"
)

local warnSwarm			= mod:NewTargetAnnounce(64396, 2)
local warnFearSoon		= mod:NewSoonAnnounce(64386, 1)
local warnCatDied		= mod:NewAnnounce("WarnCatDied", 3, 64455, nil, nil, nil, 64455)
local warnCatDiedOne	= mod:NewAnnounce("WarnCatDiedOne", 3, 64455, nil, nil, nil, 64455)

local specWarnFear		= mod:NewSpecialWarningSpell(64386, nil, nil, nil, 2, 2)
local specWarnBlast		= mod:NewSpecialWarningInterrupt(64389, "HasInterrupt", nil, 2, 1, 2)
local specWarnVoid		= mod:NewSpecialWarningMove(64675, nil, nil, nil, 1, 2)
local specWarnSonic		= mod:NewSpecialWarningMoveTo(64688, nil, nil, nil, 2, 2)

local enrageTimer		= mod:NewBerserkTimer(600)
local timerDefender		= mod:NewNextCountTimer(30, 64447, nil, nil, nil, 1) -- First timer is time for boss spellcast, afterwards is time to revive
local timerFear			= mod:NewCastTimer(64386, nil, nil, nil, 4)
local timerFearCD		= mod:NewCDTimer(27.7, 64386, nil, nil, nil, 4, nil, nil, false) -- Prevent timer from going negativ, Timers are too much random after the 1st fear. // pull:37.94, 73.42, 43.00 // pull:37.94, 79.31, 82.34 //
local timerSwarmCD		= mod:NewCDTimer(31.8, 64396, nil, nil, nil, 1, nil, nil, true)
local timerSonicCD		= mod:NewCDTimer(26, 64688, nil, nil, nil, 2, nil, DBM_COMMON_L.DEADLY_ICON, false) -- pull:47.95, 24.09, 26.71, 30.02, 25.32, 25.50 // pull:47.95, 24.18, 54.55 //
local timerSonic		= mod:NewCastTimer(64688, nil, nil, nil, 2)

mod:GroupSpells(64447, 64455) -- Activate Feral Defender, Feral Essence

mod.vb.catLives = 9

function mod:OnCombatStart(delay)
	self.vb.catLives = 9
	enrageTimer:Start(-delay)
	timerFearCD:Start(37.90-delay)
	timerSonicCD:Start(47.9-delay)
	timerDefender:Start(59.9-delay, self.vb.catLives)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(64678, 64389) then -- Sentinel Blast
		specWarnBlast:Show(args.sourceName)
		specWarnBlast:Play("kickcast")
	elseif args.spellId == 64386 then -- Terrifying Screech
		specWarnFear:Show()
		specWarnFear:Play("fearsoon")
		timerFear:Start()
		timerFearCD:Schedule(2)
		--warnFearSoon:Schedule(34)
	elseif args:IsSpellID(64688, 64422) then --Sonic Screech
		specWarnSonic:Show(TANK)
		specWarnSonic:Play("gathershare")
		timerSonic:Start()
		timerSonicCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 64396 then -- Guardian Swarm
		warnSwarm:Show(args.destName)
		timerSwarmCD:Start()
	elseif spellId == 64455 then -- Feral Essence
		DBM.BossHealth:AddBoss(34035, L.Defender:format(9))
	end
end

function mod:SPELL_DAMAGE(_, _, _, destGUID, _, _, spellId)
	if (spellId == 64459 or spellId == 64675) and destGUID == UnitGUID("player") and self:AntiSpam(3) then -- Feral Defender Void Zone
		specWarnVoid:Show()
		specWarnVoid:Play("runaway")
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 34035 then
		self.vb.catLives = self.vb.catLives - 1
		if self.vb.catLives > 0 then
			timerDefender:Start(nil, self.vb.catLives)
			if self.vb.catLives == 1 then
				warnCatDiedOne:Show()
			else
				warnCatDied:Show(self.vb.catLives)
			end
			if self.Options.HealthFrame then
				DBM.BossHealth:RemoveBoss(34035)
				DBM.BossHealth:AddBoss(34035, L.Defender:format(self.vb.catLives))
			end
		else
			if self.Options.HealthFrame then
				DBM.BossHealth:RemoveBoss(34035)
			end
		end
	end
end