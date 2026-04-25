local L

L = DBM:GetModLocalization("WoeArenaController")
L:SetGeneralLocalization({
	name = "WoE Arena Controller"
})

L:SetWarningLocalization({
	WarnNextBoss = "Next boss: %s (15 sec)"
})

L:SetTimerLocalization({
	TimerNextBoss = "Next boss: %s"
})

L:SetOptionLocalization({
	WarnNextBoss = "Show warning for next boss spawn",
	TimerNextBoss = "Show timer for next boss spawn (15 sec)"
})

L = DBM:GetModLocalization("WoeHuretripe")
L:SetGeneralLocalization({
	name = "Huretripe"
})

L = DBM:GetModLocalization("WoeSanoriak")
L:SetGeneralLocalization({
	name = "Sanoriak"
})

L = DBM:GetModLocalization("WoeBalafre")
L:SetGeneralLocalization({
	name = "Balafre"
})

L = DBM:GetModLocalization("WoeAkama")
L:SetGeneralLocalization({
	name = "Akama"
})

L = DBM:GetModLocalization("WoeGivre")
L:SetGeneralLocalization({
	name = "Givre"
})

L = DBM:GetModLocalization("WoeKirrawk")
L:SetGeneralLocalization({
	name = "Kirrawk"
})

L = DBM:GetModLocalization("WoeChen")
L:SetGeneralLocalization({
	name = "Chen Stormstout"
})

L = DBM:GetModLocalization("WoeKulaka")
L:SetGeneralLocalization({
	name = "King Kulaka"
})

L = DBM:GetModLocalization("WoeBlat")
L:SetGeneralLocalization({
	name = "Blat"
})

L = DBM:GetModLocalization("WoeUck")
L:SetGeneralLocalization({
	name = "Uck"
})

L = DBM:GetModLocalization("WoeIxx")
L:SetGeneralLocalization({
	name = "Ixx"
})

L:SetWarningLocalization({
	SpecWarnPound = "Marteler: move behind the boss!"
})

L:SetOptionLocalization({
	SpecWarnPound = "Show special warning to move behind the boss for $spell:53472"
})

L = DBM:GetModLocalization("WoeMazhareen")
L:SetGeneralLocalization({
	name = "Mazhareen"
})

L:SetWarningLocalization({
	SpecWarnEnrageDefensive = "10 Enrage stacks: use a defensive cooldown!"
})

L:SetOptionLocalization({
	SpecWarnEnrageDefensive = "Show special warning at 10 Enrage stacks to use a defensive cooldown"
})

L = DBM:GetModLocalization("WoeFjoll")
L:SetGeneralLocalization({
	name = "Fjoll"
})

L:SetTimerLocalization({
	TimerBlackHole = "Black Hole"
})

L:SetOptionLocalization({
	TimerBlackHole = "Show repeating timer for Black Hole"
})

L = DBM:GetModLocalization("WoeCrochet")
L:SetGeneralLocalization({
	name = "Crochet"
})

L = DBM:GetModLocalization("WoeDominika")
L:SetGeneralLocalization({
	name = "Dominika the Illusionist"
})

L = DBM:GetModLocalization("WoeBoulette")
L:SetGeneralLocalization({
	name = "Boulette"
})

L:SetWarningLocalization({
	SpecWarnBloodOrbs = "Take the Blood Orb stacks!"
})

L:SetOptionLocalization({
	SpecWarnBloodOrbs = "Show special warning on pull to take Blood Orb stacks"
})

L = DBM:GetModLocalization("WoeBigBaddaBoom")
L:SetGeneralLocalization({
	name = "Big Badda Boom"
})

L:SetWarningLocalization({
	SpecWarnBurningWoundSlowDPS = "3 Burning Wound stacks: slow DPS!",
	SpecWarnBurningWoundStopDPS = "4 Burning Wound stacks: STOP DPS!"
})

L:SetOptionLocalization({
	SpecWarnBurningWoundSlowDPS = "Show special warning at 3 stacks of $spell:49956 to slow DPS",
	SpecWarnBurningWoundStopDPS = "Show special warning at 4 stacks of $spell:49956 to stop DPS"
})

L = DBM:GetModLocalization("WoeHummock")
L:SetGeneralLocalization({
	name = "Hummock"
})

L:SetWarningLocalization({
	SpecWarnIceSphereKite = "Kite the Ice Sphere at all costs!"
})

L:SetTimerLocalization({
	TimerNextSphere = "Next Sphere",
	TimerIceSphereDur = "Ice Sphere"
})

L:SetOptionLocalization({
	SpecWarnIceSphereKite = "Show special warning on pull to kite the Ice Sphere",
	TimerNextSphere = "Show 5 sec timer before next sphere",
	TimerIceSphereDur = "Show 11 sec Ice Sphere timer 5 sec after a sphere dies"
})

L = DBM:GetModLocalization("WoeGnomesLepreux")
L:SetGeneralLocalization({
	name = "Leper Gnome Group"
})

L = DBM:GetModLocalization("WoeMilhouse")
L:SetGeneralLocalization({
	name = "Milhouse Manastorm"
})

L:SetWarningLocalization({
	SpecWarnMysticBarrageSwitch = "Mystic Barrage: switch target!"
})

L:SetOptionLocalization({
	SpecWarnMysticBarrageSwitch = "Show special warning when $spell:70127 is on you"
})

L = DBM:GetModLocalization("WoeYukkanIzu")
L:SetGeneralLocalization({
	name = "Yukkan Izu"
})

L = DBM:GetModLocalization("WoeProboskus")
L:SetGeneralLocalization({
	name = "Proboskus"
})

L:SetWarningLocalization({
	SpecWarnFrostPillarRun = "Frost Pillar: run away!"
})

L:SetTimerLocalization({
	TimerFrostPillarCD = "Frost Pillar"
})

L:SetOptionLocalization({
	SpecWarnFrostPillarRun = "Show special warning to run from Frost Pillar",
	TimerFrostPillarCD = "Show timer for Frost Pillar"
})

L = DBM:GetModLocalization("WoePrinceTheraldis")
L:SetGeneralLocalization({
	name = "Prince Theraldis"
})

L:SetWarningLocalization({
	SpecWarnGreenOrbsKite = "Take green orbs while kiting the boss"
})

L:SetTimerLocalization({
	TimerCarapacePlayer = "Carapace on >%s<"
})

L:SetOptionLocalization({
	SpecWarnGreenOrbsKite = "Show pull warning to take green orbs while kiting the boss",
	TimerCarapacePlayer = "Show 8 sec timer on player affected by Carapace"
})

L = DBM:GetModLocalization("WoeHoxoos")
L:SetGeneralLocalization({
	name = "Hoxoos"
})

L:SetWarningLocalization({
	SpecWarnHalionKite = "Halion like, kite the boss along edges between 2 orbs"
})

L:SetOptionLocalization({
	SpecWarnHalionKite = "Show pull warning for Halion-like kite pathing"
})

L = DBM:GetModLocalization("WoeMaxBoBouloche")
L:SetGeneralLocalization({
	name = "Max and Bo Bouloche"
})

L = DBM:GetModLocalization("WoeSombreInvocateur")
L:SetGeneralLocalization({
	name = "Dark Summoner"
})

L:SetWarningLocalization({
	SpecWarnGhostLight = "Kite the ghosts into the light."
})

L:SetOptionLocalization({
	SpecWarnGhostLight = "Show pull warning to kite ghosts into the light"
})

L = DBM:GetModLocalization("WoeCombatron")
L:SetGeneralLocalization({
	name = "Combatron"
})

L:SetWarningLocalization({
	SpecWarnNoAOE = "NO AOE, KILL 2 MINES MAXIMUM."
})

L:SetOptionLocalization({
	SpecWarnNoAOE = "Show pull warning to avoid AOE and limit mine kills"
})

L = DBM:GetModLocalization("WoeAhooru")
L:SetGeneralLocalization({
	name = "Ahoo'ru"
})

L:SetWarningLocalization({
	SpecWarnKillValkyr = "Kill 3 val'kyr before DPSing the boss.",
	WarnValkyrRemaining = "Val'kyr remaining: %d"
})

L:SetOptionLocalization({
	SpecWarnKillValkyr = "Show pull warning to kill 3 val'kyr before DPSing the boss",
	WarnValkyrRemaining = "Show remaining val'kyr count"
})

L = DBM:GetModLocalization("WoeKreator")
L:SetGeneralLocalization({
	name = "Avatar of Kreator"
})

L:SetWarningLocalization({
	SpecWarnRageWipe = "Go wype"
})

L:SetTimerLocalization({
	TimerMeteor = "Meteor",
	TimerInstantDeath = "Instant death"
})

L:SetOptionLocalization({
	SpecWarnRageWipe = "Show warning when the boss gains $spell:66776",
	TimerMeteor = "Show Meteor timer after $spell:65129",
	TimerInstantDeath = "Show Instant death timer at Phase 3 start"
})
