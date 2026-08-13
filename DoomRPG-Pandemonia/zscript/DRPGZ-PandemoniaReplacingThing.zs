class Pand_ReplacerHandlerRPG : EventHandler
{
  override void CheckReplacement(ReplaceEvent a)
	{
	let g = PandGlobalVariables.Get();
	
		switch(a.Replacee.GetClassName())
		{
		//Player
		case 'DRPGDoomPlayer'	: a.Replacement = 'DustPlayerRPG'; break;
		
		//Ammo (normal)
		case 'DRPGClip'	: a.Replacement = 'NewClipRPG'; break;
		case 'DRPGClipBox'	: a.Replacement = 'NewClipBoxRPG'; break;
		case 'DRPGShell'	: a.Replacement = 'NewShellRPG'; break;
		case 'DRPGShellBox'	: a.Replacement = 'NewShellBoxRPG'; break;
		case 'DRPGRocketAmmo'	: a.Replacement = 'NewRocketAmmoRPG'; break;
		case 'DRPGRocketBox'	: a.Replacement = 'NewRocketBoxRPG'; break;
		case 'DRPGCell'	: a.Replacement = 'NewCellRPG'; break;
		case 'DRPGCellPack'	: a.Replacement = 'NewCellPackRPG'; break;
		
		//Ammo (half)
		case 'DRPGClipHalf'	: a.Replacement = 'NewHalfClipRPG'; break;
		case 'DRPGClipBoxHalf'	: a.Replacement = 'NewHalfClipBoxRPG'; break;
		case 'DRPGShellHalf'	: a.Replacement = 'NewHalfShellRPG'; break;
		case 'DRPGShellBoxHalf'	: a.Replacement = 'NewHalfShellBoxRPG'; break;
		case 'DRPGRocketBoxHalf'	: a.Replacement = 'NewHalfRocketBoxRPG'; break;
		case 'DRPGCellHalf'	: a.Replacement = 'NewHalfCellRPG'; break;
		case 'DRPGCellPackHalf'	: a.Replacement = 'NewHalfCellPackRPG'; break;
		
		//Ammo (full)
		case 'DRPGClipFull'	: a.Replacement = 'NewClipRPGFull'; break;
		case 'DRPGClipBoxFull'	: a.Replacement = 'NewClipBoxRPGFull'; break;
		case 'DRPGShellFull'	: a.Replacement = 'NewShellRPGFull'; break;
		case 'DRPGShellBoxFull'	: a.Replacement = 'NewShellBoxRPGFull'; break;
		case 'DRPGRocketBoxFull'	: a.Replacement = 'NewRocketBoxRPGFull'; break;
		case 'DRPGCellFull'	: a.Replacement = 'NewCellRPGFull'; break;
		case 'DRPGCellPackFull'	: a.Replacement = 'NewHalfCellPackRPG'; break;
		
		//Backpacks
		case 'DRPGSmallBackpack'	: a.Replacement = 'PandBackpackSRPG'; break;
		case 'DRPGBackpack'	: a.Replacement = 'PandBackpackMRPG'; break;
		case 'DRPGBigBackpack'	: a.Replacement = 'PandBackpackBRPG'; break;
		
		//Armor
		case 'DRPGGreenArmorRandomizer'	: a.Replacement = 'GreenArmorSpawner'; break;
		case 'DRPGBlueArmorRandomizer'	: a.Replacement = 'BlueArmorSpawner'; break;
		
		case 'DRPGShopArmorRandomizer'	: a.Replacement = 'GreenArmorSpawner'; break; //shop display randomizer
		case 'DRPGArmorBonus'	: a.Replacement = 'HelmetSpawner'; break;
		
		//Event
		case 'DRPGThermonuclearBombPickupPand'	: a.Replacement = 'DRPGThermonuclearBombPickupPand'; break; //Termonuclear Bomb event
		
		//Health
		case 'DRPGStimpack'	: a.Replacement = 'DRPGStimpackPand'; break;
		case 'DRPGMedikit'	: a.Replacement = 'DRPGMedikitPand'; break;
		case 'DRPGLargeMedikit'	: a.Replacement = 'DRPGLargeMedikitPand'; break;
		case 'DRPGXLMedikit'	: a.Replacement = 'DRPGXLMedikitPand'; break;
		case 'DRPGMedPack'	: a.Replacement = 'DRPGMedPackPand'; break;
		case 'DRPGSurgeryKit'	: a.Replacement = 'DRPGSurgeryKitpPand'; break;
		case 'DRPGMedkitRefill'	: a.Replacement = 'DRPGMedkitRefillPand'; break;
		
		case 'DRPGHealthBonus'	: a.Replacement = 'VialSpawner'; break;
		
		//SoulSpheres
		case 'DRPGSoulsphere'	: a.Replacement = 'NewSoulSphereRPG'; break;
		case 'DRPGSoulsphere2'	: a.Replacement = 'LifeSphereRPG'; break;
		case 'DRPGSoulsphere3'	: a.Replacement = 'GreatLifeSphereRPG'; break;
		case 'Salvationsphere'	: a.Replacement = 'DRPGLife'; break; //DRPG have that already
		case 'ReincarnationSphere'	: a.Replacement = 'DRPG3Up'; break; //doesn`t work, so is replaced
		
		//Keys
		case 'DRPGBlueCard'	: a.Replacement = 'DRPGBlueCardPand'; break;
		case 'DRPGYellowCard'	: a.Replacement = 'DRPGYellowCardPand'; break;
		case 'DRPGRedCard'	: a.Replacement = 'DRPGRedCardPand'; break;
		case 'DRPGBlueSkull'	: a.Replacement = 'DRPGBlueSkullPand'; break;
		case 'DRPGYellowSkull'	: a.Replacement = 'DRPGYellowSkullPand'; break;
		case 'DRPGRedSkull'	: a.Replacement = 'DRPGRedSkullPand'; break;
		
		//Powerups
		case 'DRPGInvulnerabilitySphere'	: a.Replacement = 'DRPGInvulnerabilitySpherePand'; break;
		case 'DRPGInvulnerabilityCharge'	: a.Replacement = 'DRPGInvulnerabilityChargePand'; break;
		case 'DRPGBlurSphere'	: a.Replacement = 'DRPGBlurSpherePand'; break;
		case 'DRPGInvisibilityCharge'	: a.Replacement = 'DRPGInvisibilityChargePand'; break;
		case 'DRPGTimeSphere'	: a.Replacement = 'DRPGTimeSpherePand'; break;
		case 'DRPGRegenSphere'	: a.Replacement = 'DRPGRegenSpherePand'; break;
		case 'DRPGRadSuit'	: a.Replacement = 'DRPGRadSuitPand'; break;
		case 'DRPGInfrared'	: a.Replacement = 'DRPGInfraredPand'; break;
		case 'DRPGAllMap'	: a.Replacement = 'DRPGAllMapPand'; break;
		case 'DRPGBerserk'	: a.Replacement = 'DRPGBerserkPand'; break;
		
		//Immunity Crystals
		case 'DRPGImmunityCrystalMelee'	: a.Replacement = 'DRPGImmunityCrystalMeleePand'; break;
		case 'DRPGImmunityCrystalBullet'	: a.Replacement = 'DRPGImmunityCrystalBulletPand'; break;
		case 'DRPGImmunityCrystalFire'	: a.Replacement = 'DRPGImmunityCrystalFirePand'; break;
		case 'DRPGImmunityCrystalLightning'	: a.Replacement = 'DRPGImmunityCrystalLightningPand'; break;
		case 'DRPGImmunityCrystalToxic'	: a.Replacement = 'DRPGImmunityCrystalToxicPand'; break;
		case 'DRPGImmunityCrystalRadiation'	: a.Replacement = 'DRPGImmunityCrystalRadiationPand'; break;
		
		//Randomizers
		case 'DRPGPowerupDropper'	: a.Replacement = 'DRPGPowerupDropperPand'; break;
		case 'DRPGBlurSphereRandomizer'	: a.Replacement = 'DRPGBlurSphereRandomizerPand'; break;
		case 'DRPGShopArmorRandomizer'	: a.Replacement = 'DRPGShopArmorRandomizerPand'; break;
		case 'DRPGShopMiscRandomizer'	: a.Replacement = 'DRPGShopMiscRandomizerPand'; break;
		
		//Shields
		case 'DRPGShieldAdaptiveToxicResist'	: a.Replacement = 'DRPGShieldAdaptiveToxicResistPand'; break;
		
		//Stims
		case 'DRPGStimDetox'	: a.Replacement = 'DRPGStimDetoxPand'; break;
		
		case 'FieldKit'	: a.Replacement = 'DRPGStimDetoxPand'; break;
		
		//Weapons
		case 'DRPGChainsaw'	: a.Replacement = 'DustChainsaw'; break;
		case 'DRPGPistol'	: a.Replacement = 'DustPistol'; break;
		case 'DRPGShotgun'	: a.Replacement = 'DustShotgun'; break;
		case 'DRPGSuperShotgun'	: a.Replacement = 'DustSuperShotgun'; break;
		case 'DRPGChaingun'	: a.Replacement = 'DustAssaultRifle'; break;
		case 'DRPGRocketLauncher'	: a.Replacement = 'DustRocketLauncher'; break;
		case 'DRPGPlasmaRifle'	: a.Replacement = 'DustPlasmaRifle'; break;
		case 'DRPGBFG9000'	: a.Replacement = 'DustBFG9000'; break;
		}
	}
}