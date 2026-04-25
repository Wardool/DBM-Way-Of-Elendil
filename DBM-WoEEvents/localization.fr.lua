if GetLocale() ~= "frFR" then return end
local L

L = DBM:GetModLocalization("WoeArenaController")
L:SetGeneralLocalization({
	name = "Contrôleur Arène WoE"
})

L:SetWarningLocalization({
	WarnNextBoss = "Prochain boss : %s (15 sec)"
})

L:SetTimerLocalization({
	TimerNextBoss = "Prochain boss : %s"
})

L:SetOptionLocalization({
	WarnNextBoss = "Afficher une annonce du prochain boss",
	TimerNextBoss = "Afficher le timer du prochain boss (15 sec)"
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
	name = "Balafré"
})

L = DBM:GetModLocalization("WoeAkama")
L:SetGeneralLocalization({
	name = "Akama"
})

L = DBM:GetModLocalization("WoeGivre")
L:SetGeneralLocalization({
	name = "Givré"
})

L = DBM:GetModLocalization("WoeKirrawk")
L:SetGeneralLocalization({
	name = "Kirrawk"
})

L = DBM:GetModLocalization("WoeChen")
L:SetGeneralLocalization({
	name = "Chen Brune d'Orage"
})

L = DBM:GetModLocalization("WoeKulaka")
L:SetGeneralLocalization({
	name = "Roi Kulaka"
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
	SpecWarnPound = "Marteler : allez dans le dos du boss !"
})

L:SetOptionLocalization({
	SpecWarnPound = "Afficher une alerte spéciale pour aller dans le dos du boss pour $spell:53472"
})

L = DBM:GetModLocalization("WoeMazhareen")
L:SetGeneralLocalization({
	name = "Mazhareen"
})

L:SetWarningLocalization({
	SpecWarnEnrageDefensive = "10 stacks d'Enrager : utilisez un CD défensif !"
})

L:SetOptionLocalization({
	SpecWarnEnrageDefensive = "Afficher une alerte spéciale à 10 stacks d'Enrager pour utiliser un CD défensif"
})

L = DBM:GetModLocalization("WoeFjoll")
L:SetGeneralLocalization({
	name = "Fjoll"
})

L:SetTimerLocalization({
	TimerBlackHole = "Trou noir"
})

L:SetOptionLocalization({
	TimerBlackHole = "Afficher le timer répétitif de Trou noir"
})

L = DBM:GetModLocalization("WoeCrochet")
L:SetGeneralLocalization({
	name = "Crochet"
})

L = DBM:GetModLocalization("WoeDominika")
L:SetGeneralLocalization({
	name = "Dominika l'illusionniste"
})

L = DBM:GetModLocalization("WoeBoulette")
L:SetGeneralLocalization({
	name = "Boulette"
})

L:SetWarningLocalization({
	SpecWarnBloodOrbs = "Prenez les stacks d'orbes sanguinaires !"
})

L:SetOptionLocalization({
	SpecWarnBloodOrbs = "Afficher une alerte au pull pour prendre les stacks d'orbes sanguinaires"
})

L = DBM:GetModLocalization("WoeBigBaddaBoom")
L:SetGeneralLocalization({
	name = "Big Badda Boom"
})

L:SetWarningLocalization({
	SpecWarnBurningWoundSlowDPS = "3 stacks de Plaie brûlante : ralentissez le DPS !",
	SpecWarnBurningWoundStopDPS = "4 stacks de Plaie brûlante : STOP DPS !"
})

L:SetOptionLocalization({
	SpecWarnBurningWoundSlowDPS = "Afficher une alerte spéciale à 3 stacks de $spell:49956 pour ralentir le DPS",
	SpecWarnBurningWoundStopDPS = "Afficher une alerte spéciale à 4 stacks de $spell:49956 pour stopper le DPS"
})

L = DBM:GetModLocalization("WoeHummock")
L:SetGeneralLocalization({
	name = "Hummock"
})

L:SetWarningLocalization({
	SpecWarnIceSphereKite = "Kitez la sphère de glace à tout prix !"
})

L:SetTimerLocalization({
	TimerNextSphere = "Prochaine sphère",
	TimerIceSphereDur = "Sphère de glace"
})

L:SetOptionLocalization({
	SpecWarnIceSphereKite = "Afficher une alerte au pull pour kiter la sphère de glace",
	TimerNextSphere = "Afficher le timer de 5 sec avant la prochaine sphère",
	TimerIceSphereDur = "Afficher un timer de 11 sec pour la sphère de glace 5 sec après la mort d'une sphère"
})

L = DBM:GetModLocalization("WoeGnomesLepreux")
L:SetGeneralLocalization({
	name = "Gnomes lépreux"
})

L = DBM:GetModLocalization("WoeMilhouse")
L:SetGeneralLocalization({
	name = "Milhouse Tempête-de-mana"
})

L:SetWarningLocalization({
	SpecWarnMysticBarrageSwitch = "Rafale mystique : changez de cible !"
})

L:SetOptionLocalization({
	SpecWarnMysticBarrageSwitch = "Afficher une alerte spéciale quand $spell:70127 est sur vous"
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
	SpecWarnFrostPillarRun = "Colonne de givre : éloignez-vous !"
})

L:SetTimerLocalization({
	TimerFrostPillarCD = "Colonne de givre"
})

L:SetOptionLocalization({
	SpecWarnFrostPillarRun = "Afficher une alerte spéciale pour s'éloigner de Colonne de givre",
	TimerFrostPillarCD = "Afficher le timer de Colonne de givre"
})

L = DBM:GetModLocalization("WoePrinceTheraldis")
L:SetGeneralLocalization({
	name = "Prince Theraldis"
})

L:SetWarningLocalization({
	SpecWarnGreenOrbsKite = "Prenez les orbes vertes tout en kitant le boss"
})

L:SetTimerLocalization({
	TimerCarapacePlayer = "Carapace sur >%s<"
})

L:SetOptionLocalization({
	SpecWarnGreenOrbsKite = "Afficher une alerte au pull pour prendre les orbes vertes en kitant le boss",
	TimerCarapacePlayer = "Afficher un timer de 8 sec sur le joueur affecté par Carapace"
})

L = DBM:GetModLocalization("WoeHoxoos")
L:SetGeneralLocalization({
	name = "Hoxoos"
})

L:SetWarningLocalization({
	SpecWarnHalionKite = "Halion like, kitez le boss sur les bords entre 2 orbes"
})

L:SetOptionLocalization({
	SpecWarnHalionKite = "Afficher une alerte au pull pour le kite Halion-like"
})

L = DBM:GetModLocalization("WoeMaxBoBouloche")
L:SetGeneralLocalization({
	name = "Max et Bo Bouloche"
})

L = DBM:GetModLocalization("WoeSombreInvocateur")
L:SetGeneralLocalization({
	name = "Sombre invocateur"
})

L:SetWarningLocalization({
	SpecWarnGhostLight = "Kitez les fantômes dans la lumière."
})

L:SetOptionLocalization({
	SpecWarnGhostLight = "Afficher une alerte au pull pour kiter les fantômes dans la lumière"
})

L = DBM:GetModLocalization("WoeCombatron")
L:SetGeneralLocalization({
	name = "Combatron"
})

L:SetWarningLocalization({
	SpecWarnNoAOE = "PAS D'AOE, TUEZ 2 MINES MAXIMUM."
})

L:SetOptionLocalization({
	SpecWarnNoAOE = "Afficher une alerte au pull pour éviter l'AOE et limiter les mines"
})

L = DBM:GetModLocalization("WoeAhooru")
L:SetGeneralLocalization({
	name = "Ahoo'ru"
})

L:SetWarningLocalization({
	SpecWarnKillValkyr = "Tuez 3 val'kyr pour DPS le boss.",
	WarnValkyrRemaining = "Val'kyr restante : %d"
})

L:SetOptionLocalization({
	SpecWarnKillValkyr = "Afficher une alerte au pull pour tuer 3 val'kyr avant de DPS le boss",
	WarnValkyrRemaining = "Afficher le nombre de val'kyr restantes"
})

L = DBM:GetModLocalization("WoeKreator")
L:SetGeneralLocalization({
	name = "Avatar de Kreator"
})

L:SetWarningLocalization({
	SpecWarnRageWipe = "Go wype"
})

L:SetTimerLocalization({
	TimerMeteor = "Météore",
	TimerInstantDeath = "Mort instantané"
})

L:SetOptionLocalization({
	SpecWarnRageWipe = "Afficher une alerte quand le boss gagne $spell:66776",
	TimerMeteor = "Afficher le timer de Météore après $spell:65129",
	TimerInstantDeath = "Afficher le timer de Mort instantané au début de la Phase 3"
})
