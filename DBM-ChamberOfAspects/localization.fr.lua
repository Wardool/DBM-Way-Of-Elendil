if GetLocale() ~= "frFR" then return end

local L

----------------------------
--  The Obsidian Sanctum  --
----------------------------
--  Shadron  --
---------------
L = DBM:GetModLocalization("Shadron")

L:SetGeneralLocalization({
	name = "Obscuron"
})

L:SetMiscLocalization({
	YellShadronPull	= "Je n'ai peur de rien ! Et surtout pas de vous !",
})

----------------
--  Tenebron  --
----------------
L = DBM:GetModLocalization("Tenebron")

L:SetGeneralLocalization({
	name = "Ténébron"
})

L:SetMiscLocalization({
	YellTenebronPull	= "Vous n'avez pas votre place ici ! Votre place... est parmi les disparus !",
})

----------------
--  Vesperon  --
----------------
L = DBM:GetModLocalization("Vesperon")

L:SetGeneralLocalization({
	name = "Vespéron"
})

L:SetMiscLocalization({
	YellVesperonPull	= "Vous n'êtes pas une menace, êtres inférieurs ! Faites de votre mieux !",
})

------------------
--  Sartharion  --
------------------
L = DBM:GetModLocalization("Sartharion")

L:SetGeneralLocalization({
	name = "Sartharion"
})

L:SetWarningLocalization({
	WarningTenebron			= "Ténébron Arrive",
	WarningShadron			= "Obscuron Arrive",
	WarningVesperon			= "Vespéron Arrive",
	WarningFireWall			= "Tsunami de flammes !",
	WarningWhelpsSoon		= "Bientôt des petits de Tenebron",
	WarningPortalSoon		= "Bientôt le portail de Shadron",
	WarningReflectSoon		= "Vesperon Réfléchir bientôt",
	WarningVesperonPortal	= "Portail de Vespéron",
	WarningTenebronPortal	= "Portail de Ténébron",
	WarningShadronPortal	= "Portail d'Obscuron"
})

L:SetTimerLocalization({
	TimerTenebron			= "Ténébron Arrive",
	TimerShadron			= "Obscuron Arrive",
	TimerVesperon			= "Vespéron Arrive",
	TimerTenebronWhelps		= "Dragonnets de Ténébron",
	TimerShadronPortal		= "Portail Shadron",
	TimerVesperonPortal		= "Portail Vesperon",
	TimerVesperonPortal2	= "Portail Vesperon 2"
})

L:SetOptionLocalization({
	AnnounceFails			= "Affiche les joueurs qui n'ont pas évité les zones de vide / Tsunamis de flammes (Nécessite l'activation des annonces et être promu ou leader)",
	TimerTenebron			= "Montre le timer pour Ténébron",
	TimerShadron			= "Montre le timer pour Obscuron",
	TimerVesperon			= "Montre le timer pour Vespéron",
	TimerTenebronWhelps		= "Montrer la minuterie pour les dragonnets Tenebron",
	TimerShadronPortal		= "Afficher la minuterie pour le portail Shadron",
	TimerVesperonPortal		= "Montrer la minuterie pour Vesperon Portal",
	TimerVesperonPortal2	= "Montrer la minuterie pour Vesperon Portal 2",
	WarningFireWall			= "Montre une alerte spéciale pour les Tsunamis de flammes",
	WarningTenebron			= "Montre le timer avant que Ténébron arrive",
	WarningShadron			= "Montre le timer avant qu'Obscuron arrive",
	WarningVesperon			= "Montre le timer avant que Vespéron arrive",
	WarningWhelpsSoon		= "Annoncer les dragonnets Tenebron bientôt",
	WarningPortalSoon		= "Annoncer le portail Shadron bientôt",
	WarningReflectSoon		= "Annonce Vesperon Reflect bientôt",
	WarningTenebronPortal	= "Montre une alerte spéciale pour les portails de Ténébron",
	WarningShadronPortal	= "Montre une alerte spéciale pour les portails d'Obscuron",
	WarningVesperonPortal	= "Montre une alerte spéciale pour les portails de Vespéron"
})

L:SetMiscLocalization({
	YellSarthPull	= "Ces œufs sont sous ma responsabilité. Je vous ferai brûler avant de vous laisser y toucher !",
	Wall			= "lave qui entoure",
	Portal			= "commence à incanter un portail",
	NameTenebron	= "Ténébron",
	NameShadron		= "Obscuron",
	NameVesperon	= "Vespéron",
	FireWallOn		= "Tsunamis de flammes: %s",
	VoidZoneOn		= "Zone de vide : %s",
	VoidZones		= "Zones de vide ratées (cet essai): %s",
	FireWalls		= "Tsunamis de flammes ratés (cet essai): %s"
})

------------------------
--  The Ruby Sanctum  --
------------------------
--  Baltharus the Warborn  --
-----------------------------
L = DBM:GetModLocalization("Baltharus")

L:SetGeneralLocalization({
	name = "Baltharus l'Enfant de la guerre"
})

L:SetWarningLocalization({
	WarningSplitSoon	= "Séparation bientôt!"
})

L:SetOptionLocalization({
	WarningSplitSoon	= "Montre une pré-alerte pour la séparation",
})

-------------------------
--  Saviana Ragefire  --
-------------------------
L = DBM:GetModLocalization("Saviana")

L:SetGeneralLocalization({
	name = "Saviana Ragefeu"
})

--------------------------
--  General Zarithrian  --
--------------------------
L = DBM:GetModLocalization("Zarithrian")

L:SetGeneralLocalization({
	name = "Général Zarithrian"
})

L:SetWarningLocalization({
	WarnAdds	= "Nouveaux adds",
	warnCleaveArmor	= "%s sur >%s< (%s)"		-- Cleave Armor on >args.destName< (args.amount)
})

L:SetTimerLocalization({
	TimerAdds	= "Nouveaux adds",
	AddsArrive	= "Les adds arrivent dans"
})

L:SetOptionLocalization({
	WarnAdds		= "Annonce les nouveaux adds",
	TimerAdds		= "Afficher le timer pour les nouveaux adds",
	CancelBuff		= "Supprimer $spell:10278 et $spell:642 s'il est utilisé pour supprimer $spell:74367",
	AddsArrive		= "Afficher le timer pour l'arrivée des adds (8s)",
	warnCleaveArmor	= DBM_CORE_L.AUTO_ANNOUNCE_OPTIONS.spell:format(74367, GetSpellInfo(74367) or "unknown")
})

L:SetMiscLocalization({
	SummonMinions	= "Serviteurs, réduisez-les en cendres !"
})

-------------------------------------
--  Halion the Twilight Destroyer  --
-------------------------------------
L = DBM:GetModLocalization("Halion")

L:SetGeneralLocalization({
	name = "Halion le destructeur du Crépuscule"
})

L:SetWarningLocalization({
	TwilightCutterCast	= "Tranchant crépusculaire dans : 5 sec",
	StopDPS				= "Stoppez le DPS !"
})

L:SetOptionLocalization({
	StopDPS					= "Afficher une alerte pour arrêter le DPS sur Halion pendant la phase 3 pour la corporéité (L'alerte ne s'affiche que pour les dps)",
	TwilightCutterCast		= "Afficher une alerte lorsque $spell:77844 est en cours",
	AnnounceAlternatePhase	= "Montre une alerte/timer pour la phase dans laquelle vous n'êtes pas",
	SetIconOnConsumption	= "Placer des icones sur les cibles de $spell:74562 ou $spell:74792"
})

L:SetMiscLocalization({
	Halion					= "Halion",
	PhysicalRealm			= "Royaume matériel",
	MeteorCast				= "Les cieux s'embrasent !",
	Phase2					= "Vous ne trouverez que souffrance au royaume du Crépuscule ! Entrez si vous l'osez !",
	Phase3					= "Je suis la lumière et l'ombre ! Tremblez, mortels, devant le héraut d'Aile de mort !",
	twilightcutter			= "Méfiez-vous de l'ombre !",
	Kill					= "Savourez bien cette victoire, mortels, car ce sera votre dernière. Ce monde brûlera au retour du maître !"
})
