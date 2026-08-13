// DRPG TO PANDEMONIA

//Fake? Pand effects
Class RPGFancyPower : PandPowerupGiver //Fake Pandemonia invul power
{
  Default
  {
  Powerup.Color "00 00 00", 0.0;
  Powerup.Type "RPGPandFancyInvul";
  +INVENTORY.AUTOACTIVATE;
  +INVENTORY.ALWAYSPICKUP;
  +INVENTORY.PERSISTENTPOWER;
  Tag "\cdInvul";
  }
}

Class RPGPandFancyInvul : PowerInvulnerable //Fake Pandemonia invul effect
{

  override void InitEffect()
	{
	Super.InitEffect();
	if(!Owner)
		return;
	Owner.A_AttachLightDef("PowerInvuln","InvulnActive");
	}

  override void DoEffect()
	{
	Super.DoEffect();
	Owner.A_SpawnItemEx("GreenRailgunParticle",random(-20,20),random(-20,20),random(0,64),frandom(-3,3),frandom(-3,3),frandom(-3,3),0,0,128);
	Owner.A_SpawnParticle("Green",SPF_FULLBRIGHT,35,2,0,random(-30,30),random(-30,30),random(0,64),frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(0,3),0,0,0,1,-1,-0.1);
	}

  override void EndEffect()
	{
	Super.EndEffect();
  	if(Owner)
	  	Owner.A_RemoveLight("PowerInvuln");
	}
}


//Invulnerability
class DRPGInvulnerabilitySpherePand : NewInvulSphere
{
  Default
  {
  Inventory.PickupSound "Invuln/Pickup";
  Inventory.PickupMessage "\c[z1]Invulnerability\c-!";
  PandInventory.ColorTag "[z1]"; 
  Tag "Invulnerability Sphere";
  -COUNTITEM;
  }
    
    States
    {
    Spawn:
		TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
		PINV AABBCCDD 3 Bright A_SpawnItemEx("SphereEffect",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME);
		Loop;
	}
	
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_SetBlend("Green",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"DarkGreen");
		Owner.A_GiveInventory("DRPGInvulnerabilityPower", 1);
		Owner.A_GiveInventory("RPGFancyPower", 1);
		return true;
		}
	else
		return false;
	}

}

//Invulnerability Charge
class DRPGInvulnerabilityChargePand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "You picked up an invulnerability charge.";
  Inventory.PickupSound "powerups/protect";
  Inventory.UseSound "powerups/protect";
  Inventory.Icon "CRG2";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Grants reflective invulnerability for 30 seconds.";
  +INVENTORY.INVBAR;
  +FLOORCLIP;
  PandInventory.ColorTag "[09]";
  Tag "Invulnerability Charge";
  Species "PInv_Main";
  }

override string Pand_ItemInfo()
{
let minfo =
"Invulnerability Charge - Grants reflective invulnerability for 30 seconds.";
return minfo;
}
	
    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
        CRG2 ABC 3 Bright;
        Goto Spawn+1;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }

  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_SetBlend("Green",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"DarkGreen");
		Owner.A_GiveInventory("DRPGInvulnerabilityChargePower", 1);
		Owner.A_GiveInventory("RPGFancyPower", 1);
		return true;
		}
	else
		return false;
	}

}


Class DRPGBlurSpherePand : NewBlurSphere
{
  Default
  {
  Inventory.PickupSound "Invis/Pickup";
  Inventory.PickupMessage "\c[o7]Partial Invisibility\c-!";
  +VISIBILITYPULSE;
  PandInventory.ColorTag "[o7]"; 
  Tag "Partial Invisibility";
  }
  States
  {
  Spawn:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
	PINS AABBCCDD 3 Bright A_SpawnItemEx("SphereEffect",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME);
	Loop;
	}
	
  override bool Use(bool pickup)
	{
	if(!Owner)
		return true;
	Owner.A_SetBlend("Red",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"DarkBlue");
	Owner.GiveInventory("DRPGInvisibilityPower",1);
	return true;
	}
}

//Invisibility Charge
class DRPGInvisibilityChargePand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "You picked up an invisibility charge.";
  Inventory.PickupSound "powerups/invis";
  Inventory.UseSound "powerups/invis";
  Inventory.Icon "CRG1";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Bestows complete invisibility for 60 seconds.";
  +INVENTORY.INVBAR;
  +FLOORCLIP;
  PandInventory.ColorTag "[34]";
  Tag "Invisibility Charge";
  Species "PInv_Main";
  }

override string Pand_ItemInfo()
{
let minfo =
"Invisibility Charge - Bestows complete invisibility for 60 seconds.";
return minfo;
}
	
    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
        CRG1 ABC 3 Bright;
        Goto Spawn+1;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }

  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_SetBlend("Red",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"DarkBlue");
		Owner.A_GiveInventory("DRPGInvisibilityChargePower", 1);
		return true;
		}
	else
		return false;
	}

}


// Time Sphere
class DRPGTimeSpherePand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "You picked up a Time Sphere.";
  Inventory.PickupSound "powerups/time";
  Inventory.Icon "TIME";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Stops time for 15 seconds.";
  +INVENTORY.INVBAR;
  +FLOATBOB;
  Scale 0.75;
  PandInventory.ColorTag "[80]";
  Tag "Time Sphere";
  Species "PInv_Other";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Time Sphere - stops time for 15 seconds.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
        TIME ABCDCB 4 bright;
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		A_SpawnItemEx("DRPGTimeFreezerSound");
		Owner.A_GiveInventory("DRPGTimeFreezer", 1);
		return true;
		}
	else
		return false;
	}
}

// Regeneration Sphere
class DRPGRegenSpherePand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "You picked up a Regeneration Sphere.";
  Inventory.PickupSound "powerups/regen";
  Inventory.UseSound "powerups/regen";
  Inventory.Icon "REGN";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Regenerates HP and EP rapidly.";
  +INVENTORY.INVBAR;
  +FLOATBOB;
  PandInventory.ColorTag "[J8]";
  Tag "Regeneration Sphere";
  Species "PInv_Other";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Regeneration Sphere - regenerates HP and EP rapidly.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
        REGN ABCDCB 4 Bright;
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.ACS_NamedExecute("RegenBoost", 0);
		return true;
		}
	else
		return false;
	}
}


// Radiation Suit
class DRPGRadSuitPand : PandInventory
{
  Default
  {
  Height 46;
  Inventory.PickupMessage "Radiation Shielding Suit.";
  Inventory.PickupSound "Suit/Pickup";
  Inventory.UseSound "Suit/Pickup";
  Inventory.Icon "SUITB0";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Protects against damaging environments for 60 seconds.";
  +INVENTORY.INVBAR;
  PandInventory.ColorTag "[A2]";
  Tag "Radiation Shielding Suit";
  Species "PInv_Main";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Radiation Shielding Suit - protects against damaging environments for 60 seconds.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
        SUIT A -1 Bright;
        Stop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_GiveInventory("DRPGRadSuitPower", 1);
		Owner.A_GiveInventory("PandNormalRadsuitGiver", 1);
		return true;
		}
	else
		return false;
	}
}


// IR Goggles
class DRPGInfraredPand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "Light Amplification Goggles!";
  Inventory.PickupSound "Light/Pickup";
  Inventory.UseSound "Light/Pickup";
  Inventory.Icon "PVIS";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Enables night vision for 120 seconds.";
  +INVENTORY.INVBAR;
  -COUNTITEM;
  PandInventory.ColorTag "[C1]";
  Tag "Light Amplification Goggles";
  Species "PInv_Main";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Light Amplification Goggles - enables night vision for 120 seconds.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
		PVIS AB 6 Bright;
		Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_GiveInventory("DRPGInfraredPower", 1);
		Owner.A_SetBlend("White",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"White");
		return true;
		}
	else
		return false;
	}
}


// Computer Area Map
class DRPGAllMapPand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "Computer Area Map!";
  Inventory.PickupSound "Map/Pickup";
  Inventory.UseSound "Map/Pickup";
  Inventory.Icon "PMAA";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Reveals auto map until map leave.";
  -INVENTORY.AUTOACTIVATE;
  -INVENTORY.ALWAYSPICKUP;
  +INVENTORY.FANCYPICKUPSOUND;
  +INVENTORY.INVBAR;
  -COUNTITEM;
  PandInventory.ColorTag "[62]";
  Tag "Computer Area Map";
  Species "PInv_Main";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Computer Area Map - reveals auto map until map leave.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
		PMA0 A 30;
		PMA0 BCDE 5 Bright;
		Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_GiveInventory("DRPGAllMapRevealer", 1);
		return true;
		}
	else
		return false;
	}
}

// Berserk Pack
class DRPGBerserkPand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "\c[i7]Berserk pack\c-! (\c[i7]Berserk \c[m4]+100 Health\c-)";
  Inventory.PickupSound "Berserk/Pickup";
  Inventory.UseSound "Berserk/Pickup";
  Inventory.Icon "BZRKC0";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Heals fully plus increases melee damage until map leave.";
  -INVENTORY.AUTOACTIVATE;
  -INVENTORY.ALWAYSPICKUP;
  +INVENTORY.INVBAR;
  -COUNTITEM;
  PandInventory.ColorTag "[F1]";
  Tag "Berserk Pack";
  Species "PInv_Main";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Berserk Pack - heals fully plus increases melee damage until map leave.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
		BZRK A -1;
		Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_SetBlend("Red",0.6*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),50,"DarkRed");
		if (Owner.CountInv("PowerStrength") == 0)
			{
			Owner.ACS_NamedExecuteAlways("AddToxicity", 0, 10);
			Owner.ACS_NamedExecuteAlways("AMShieldCharge", 0);
			}
        Owner.ACS_NamedExecuteAlways("AddHealth", 0, 100, 100);
		Owner.A_GiveInventory("PowerStrength", 1);
		A_SpawnItemEx("UsedBerserk",0,0,20,random(-1,1),random(-1,1),random(0,1));
		return true;
		}
	else
		return false;
	}
}

// Wings
class DRPGWingsPand : PandInventory
{
  Default
  {
  Inventory.PickupMessage "Wings!";
  Inventory.PickupSound "powerups/wings";
  Inventory.UseSound "powerups/wings";
  Inventory.Icon "WINGS";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Allows flight until map leave.";
  +INVENTORY.INVBAR;
  +FLOATBOB;
  -COUNTITEM;
  PandInventory.ColorTag "[N3]";
  Tag "Wings";
  Species "PInv_Other";
  }
  
override string Pand_ItemInfo()
{
let minfo =
"Wings - allows flight until map leave.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 ACS_NamedExecuteAlways("ItemInit", 0);
		WING A -1 Bright;
		Stop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.A_SetBlend("f8c71a",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),70);
		Owner.A_GiveInventory("DRPGFlightPower", 1);
		return true;
		}
	else
		return false;
	}
}


// Megasphere
Class NewMegasphereRPG : NewMegasphere
{
  Default
  {
  RenderStyle 'Add';
  Inventory.PickupSound "Megasphere/Pickup";
  Inventory.PickupMessage "\c[g9]Megasphere\c-! (\c[m4]+200 Health and Armor\c-)";
  -COUNTITEM;
  PandInventory.ColorTag "[g9]"; 
  Tag "Megasphere";
  }
  
  States
  {
  Spawn:
	MEGA AABBCCDD 2 Bright A_SpawnItemEx("BrightSphereEffect",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME);
	Loop;
  Pickup:
    TNT1 A 0 ACS_NamedExecuteWithResult("ClearStatusEffects");
    Stop;
	}
  override bool Use(bool pickup)
	{
	if(!Owner)
		return true;
	Owner.A_GiveInventory("GreatLifeSphereRPG");
	Owner.ACS_NamedExecuteAlways("AddEP", 0, 1000000);
	Owner.ACS_NamedExecuteAlways("AddShield", 0, 1000000);
	Owner.ACS_NamedExecuteAlways("AddMedkit", 0, 1000000);
	Owner.A_SetBlend("White",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"Grey");
	Owner.TakeInventory("ArmorDropPickupCooldown",1);
	RemoveStatusEffects();
	let arm = Owner.FindInventory("PandBasicArmor");
	if(Owner.CountInv("PandBasicArmor") || (arm && PandBasicArmor(arm).cantbreak))
		{
		let playerarmor = PandBasicArmor(Owner.FindInventory("PandBasicArmor"));
		let armorname = PandBasicArmor(playerarmor).ArmorType;
		if(armorname == "ArmorBonusArmor")
			{
			RemoveArmorTraces();
			Owner.GiveInventory("CombatArmor",1);
			}
		else if(armorname == "SecurityArmor" && playerarmor.Amount >= 150)
			{
			RemoveArmorTraces();
			HybridizeArmor("HybridizedGreenBlueArmor");
			}
		else if(playerarmor.Amount < 200 && playerarmor.repairable == true)
			{
			Owner.SetInventory("PandBasicArmor",200,1);
			}
		}
	else
		Owner.GiveInventory("CombatArmor",1);
	return true;
	}
}


// Immunity Crystals
class DRPGImmunityCrystalMeleePand : PandInventory
{
Default
  {
  Health 1000;
  Height 32;
  Radius 16;
  Mass 0x7FFFFFFF;
  Inventory.PickupMessage "You picked up a melee immunity crystal.";
  Inventory.PickupSound "powerups/crystal";
  Inventory.UseSound "powerups/crystal";
  Inventory.Icon "CRYSA";
  Inventory.Amount 1;
  Inventory.MaxAmount 1;
  PandInventory.Description "Melee immunity inside crystal radius.";
  +INVENTORY.INVBAR;
  +BRIGHT;
  +THRUACTORS;
  +DONTGIB;
  +SHOOTABLE;
  +NOBLOOD;
  -SPECIAL;
  PandInventory.ColorTag "[Z5]";
  Tag "Melee Immunity Crystal";
  Species "PInv_Other";
  }
    override string Pand_ItemInfo()
	{
	let minfo =
	"Melee Immunity Crystal - melee immunity inside crystal radius..";
	return minfo;
	}
	
    States
    {
    Spawn:
		TNT1 A 0 NoDelay A_JumpIf(Abs(VelZ) <= 0.01, "FloorHit");
        CRYS A 1;
        Loop;
    FloorHit:
		TNT1 A 0 A_ChangeFlag("SPECIAL", true);
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false);
    Spawn2:
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamMelee",
            Cos((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamMelee",
            Cos((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_RadiusGive("DRPGPowerImmunityMeleePand", 512.0, RGF_PLAYERS);
        CRYS A 1 A_SpawnItemEx("DRPGImmunityCrystalPulseMelee", Random(-8, 8), Random(-8, 8), Random(-16, 8), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Death:
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("DRPGImmunityCrystalDebris", 0, 0, Height / 2, Random(-8, 8), Random(-8, 8), 8, 0, SXF_NOCHECKPOSITION);
        Stop;
    }
	
	override bool Use(bool pickup)
	{
		if (Owner.FindInventory("DRPGImmunityCrystalMeleePand"))
		{
			let thiccpotion = Spawn("DRPGImmunityCrystalMeleePand",(Owner.pos.x,Owner.pos.y,Owner.pos.z+40));
			thiccpotion.Vel3DFromAngle(10,Owner.angle,Owner.pitch);
			Owner.TakeInventory("DRPGImmunityCrystalMeleePand", 1);
			if(thiccpotion) thiccpotion.tracer = Owner;
			return true;	
		}
		return false;
	}
}

class DRPGPowerImmunityMeleePand : PowerProtection
{
	Default
	{   
	+INVENTORY.AUTOACTIVATE;
    DamageFactor "Melee", 0;
	Powerup.Duration 35;
	}
}


class DRPGImmunityCrystalBulletPand : PandInventory
{
Default
  {
  Health 1000;
  Height 32;
  Radius 16;
  Mass 0x7FFFFFFF;
  Inventory.PickupMessage "You picked up a bullet immunity crystal.";
  Inventory.PickupSound "powerups/crystal";
  Inventory.UseSound "powerups/crystal";
  Inventory.Icon "CRYSB";
  Inventory.Amount 1;
  Inventory.MaxAmount 1;
  PandInventory.Description "Bullet immunity inside crystal radius.";
  +INVENTORY.INVBAR;
  +BRIGHT;
  +THRUACTORS;
  +DONTGIB;
  +SHOOTABLE;
  +NOBLOOD;
  -SPECIAL;
  PandInventory.ColorTag "[S5]";
  Tag "Bullet Immunity Crystal";
  Species "PInv_Other";
  }
    override string Pand_ItemInfo()
	{
	let minfo =
	"Bullet Immunity Crystal - bullet immunity inside crystal radius..";
	return minfo;
	}
	
    States
    {
    Spawn:
		TNT1 A 0 NoDelay A_JumpIf(Abs(VelZ) <= 0.01, "FloorHit");
        CRYS B 1;
        Loop;
    FloorHit:
		TNT1 A 0 A_ChangeFlag("SPECIAL", true);
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false);
    Spawn2:
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamBullet",
            Cos((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamBullet",
            Cos((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_RadiusGive("DRPGPowerImmunityBulletPand", 512.0, RGF_PLAYERS);
        CRYS B 1 A_SpawnItemEx("DRPGImmunityCrystalPulseBullet", Random(-8, 8), Random(-8, 8), Random(-16, 8), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Death:
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("DRPGImmunityCrystalDebris", 0, 0, Height / 2, Random(-8, 8), Random(-8, 8), 8, 0, SXF_NOCHECKPOSITION);
        Stop;
    }
	
	override bool Use(bool pickup)
	{
		if (Owner.FindInventory("DRPGImmunityCrystalBulletPand"))
		{
			let thiccpotion = Spawn("DRPGImmunityCrystalBulletPand",(Owner.pos.x,Owner.pos.y,Owner.pos.z+40));
			thiccpotion.Vel3DFromAngle(10,Owner.angle,Owner.pitch);
			Owner.TakeInventory("DRPGImmunityCrystalBulletPand", 1);
			if(thiccpotion) thiccpotion.tracer = Owner;
			return true;	
		}
		return false;
	}
}

class DRPGPowerImmunityBulletPand : PowerProtection
{
	Default
	{   
	+INVENTORY.AUTOACTIVATE;
    DamageFactor "Bullet", 0;
	Powerup.Duration 35;
	}
}


class DRPGImmunityCrystalFirePand : PandInventory
{
Default
  {
  Health 1000;
  Height 32;
  Radius 16;
  Mass 0x7FFFFFFF;
  Inventory.PickupMessage "You picked up a fire immunity crystal.";
  Inventory.PickupSound "powerups/crystal";
  Inventory.UseSound "powerups/crystal";
  Inventory.Icon "CRYSC";
  Inventory.Amount 1;
  Inventory.MaxAmount 1;
  PandInventory.Description "Fire immunity inside crystal radius.";
  +INVENTORY.INVBAR;
  +BRIGHT;
  +THRUACTORS;
  +DONTGIB;
  +SHOOTABLE;
  +NOBLOOD;
  -SPECIAL;
  PandInventory.ColorTag "[I7]";
  Tag "Fire Immunity Crystal";
  Species "PInv_Other";
  }
    override string Pand_ItemInfo()
	{
	let minfo =
	"Fire Immunity Crystal - fire immunity inside crystal radius.";
	return minfo;
	}
	
    States
    {
    Spawn:
		TNT1 A 0 NoDelay A_JumpIf(Abs(VelZ) <= 0.01, "FloorHit");
        CRYS C 1;
        Loop;
    FloorHit:
		TNT1 A 0 A_ChangeFlag("SPECIAL", true);
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false);
    Spawn2:
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamFire",
            Cos((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamFire",
            Cos((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_RadiusGive("DRPGPowerImmunityFirePand", 512.0, RGF_PLAYERS);
        CRYS C 1 A_SpawnItemEx("DRPGImmunityCrystalPulseFire", Random(-8, 8), Random(-8, 8), Random(-16, 8), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Death:
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("DRPGImmunityCrystalDebris", 0, 0, Height / 2, Random(-8, 8), Random(-8, 8), 8, 0, SXF_NOCHECKPOSITION);
        Stop;
    }
	
	override bool Use(bool pickup)
	{
		if (Owner.FindInventory("DRPGImmunityCrystalFirePand"))
		{
			let thiccpotion = Spawn("DRPGImmunityCrystalFirePand",(Owner.pos.x,Owner.pos.y,Owner.pos.z+40));
			thiccpotion.Vel3DFromAngle(10,Owner.angle,Owner.pitch);
			Owner.TakeInventory("DRPGImmunityCrystalFirePand", 1);
			if(thiccpotion) thiccpotion.tracer = Owner;
			return true;	
		}
		return false;
	}
}

class DRPGPowerImmunityFirePand : PowerProtection
{
	Default
	{   
	+INVENTORY.AUTOACTIVATE;
    DamageFactor "Fire", 0;
	DamageFactor "Explosion", 0;
	Powerup.Duration 35;
	}
}

class DRPGImmunityCrystalLightningPand : PandInventory
{
Default
  {
  Health 1000;
  Height 32;
  Radius 16;
  Mass 0x7FFFFFFF;
  Inventory.PickupMessage "You picked up a lightning immunity crystal.";
  Inventory.PickupSound "powerups/crystal";
  Inventory.UseSound "powerups/crystal";
  Inventory.Icon "CRYSE";
  Inventory.Amount 1;
  Inventory.MaxAmount 1;
  PandInventory.Description "Lightning immunity inside crystal radius.";
  +INVENTORY.INVBAR;
  +BRIGHT;
  +THRUACTORS;
  +DONTGIB;
  +SHOOTABLE;
  +NOBLOOD;
  -SPECIAL;
  PandInventory.ColorTag "[L5]";
  Tag "Lightning Immunity Crystal";
  Species "PInv_Other";
  }
    override string Pand_ItemInfo()
	{
	let minfo =
	"Lightning Immunity Crystal - lightning immunity inside crystal radius.";
	return minfo;
	}
	
    States
    {
    Spawn:
		TNT1 A 0 NoDelay A_JumpIf(Abs(VelZ) <= 0.01, "FloorHit");
        CRYS E 1;
        Loop;
    FloorHit:
		TNT1 A 0 A_ChangeFlag("SPECIAL", true);
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false);
    Spawn2:
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamLightning",
            Cos((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamLightning",
            Cos((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_RadiusGive("DRPGPowerImmunityLightningPand", 512.0, RGF_PLAYERS);
        CRYS E 1 A_SpawnItemEx("DRPGImmunityCrystalPulseLightning", Random(-8, 8), Random(-8, 8), Random(-16, 8), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Death:
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("DRPGImmunityCrystalDebris", 0, 0, Height / 2, Random(-8, 8), Random(-8, 8), 8, 0, SXF_NOCHECKPOSITION);
        Stop;
    }
	
	override bool Use(bool pickup)
	{
		if (Owner.FindInventory("DRPGImmunityCrystalLightningPand"))
		{
			let thiccpotion = Spawn("DRPGImmunityCrystalLightningPand",(Owner.pos.x,Owner.pos.y,Owner.pos.z+40));
			thiccpotion.Vel3DFromAngle(10,Owner.angle,Owner.pitch);
			Owner.TakeInventory("DRPGImmunityCrystalLightningPand", 1);
			if(thiccpotion) thiccpotion.tracer = Owner;
			return true;	
		}
		return false;
	}
}

class DRPGPowerImmunityLightningPand : PowerProtection
{
	Default
	{   
	+INVENTORY.AUTOACTIVATE;
    DamageFactor "Electricity", 0;
    DamageFactor "Electric", 0;
    DamageFactor "Lightning", 0;
	Powerup.Duration 35;
	}
}


class DRPGImmunityCrystalToxicPand : PandInventory
{
Default
  {
  Health 1000;
  Height 32;
  Radius 16;
  Mass 0x7FFFFFFF;
  Inventory.PickupMessage "You picked up a toxic immunity crystal.";
  Inventory.PickupSound "powerups/crystal";
  Inventory.UseSound "powerups/crystal";
  Inventory.Icon "CRYSF";
  Inventory.Amount 1;
  Inventory.MaxAmount 1;
  PandInventory.Description "Toxic immunity inside crystal radius.";
  +INVENTORY.INVBAR;
  +BRIGHT;
  +THRUACTORS;
  +DONTGIB;
  +SHOOTABLE;
  +NOBLOOD;
  -SPECIAL;
  PandInventory.ColorTag "[I5]";
  Tag "Toxic Immunity Crystal";
  Species "PInv_Other";
  }
    override string Pand_ItemInfo()
	{
	let minfo =
	"Toxic Immunity Crystal - any toxic type immunity inside crystal radius.";
	return minfo;
	}
	
    States
    {
    Spawn:
		TNT1 A 0 NoDelay A_JumpIf(Abs(VelZ) <= 0.01, "FloorHit");
        CRYS F 1;
        Loop;
    FloorHit:
		TNT1 A 0 A_ChangeFlag("SPECIAL", true);
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false);
    Spawn2:
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamToxic",
            Cos((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamToxic",
            Cos((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_RadiusGive("DRPGPowerImmunityToxicPand", 512.0, RGF_PLAYERS);
        CRYS F 1 A_SpawnItemEx("DRPGImmunityCrystalPulseToxic", Random(-8, 8), Random(-8, 8), Random(-16, 8), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Death:
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("DRPGImmunityCrystalDebris", 0, 0, Height / 2, Random(-8, 8), Random(-8, 8), 8, 0, SXF_NOCHECKPOSITION);
        Stop;
    }
	
	override bool Use(bool pickup)
	{
		if (Owner.FindInventory("DRPGImmunityCrystalToxicPand"))
		{
			let thiccpotion = Spawn("DRPGImmunityCrystalToxicPand",(Owner.pos.x,Owner.pos.y,Owner.pos.z+40));
			thiccpotion.Vel3DFromAngle(10,Owner.angle,Owner.pitch);
			Owner.TakeInventory("DRPGImmunityCrystalToxicPand", 1);
			if(thiccpotion) thiccpotion.tracer = Owner;
			return true;	
		}
		return false;
	}
}

class DRPGPowerImmunityToxicPand : PowerProtection
{
	Default
	{   
	+INVENTORY.AUTOACTIVATE;
    DamageFactor "Toxicity", 0;
    DamageFactor "Slime", 0;
	DamageFactor "Poison", 0;
	DamageFactor "Plague", 0;
	Powerup.Duration 35;
	}
}

class DRPGImmunityCrystalRadiationPand : PandInventory
{
Default
  {
  Health 1000;
  Height 32;
  Radius 16;
  Mass 0x7FFFFFFF;
  Inventory.PickupMessage "You picked up a chaos-radiation fused immunity crystal.";
  Inventory.PickupSound "powerups/crystal";
  Inventory.UseSound "powerups/crystal";
  Inventory.Icon "CRYSG";
  Inventory.Amount 1;
  Inventory.MaxAmount 1;
  PandInventory.Description "Chaos and radiation immunity inside crystal radius.";
  +INVENTORY.INVBAR;
  +BRIGHT;
  +THRUACTORS;
  +DONTGIB;
  +SHOOTABLE;
  +NOBLOOD;
  -SPECIAL;
  PandInventory.ColorTag "[j5]";
  Tag "Chaos-Radiation fused Immunity Crystal";
  Species "PInv_Other";
  }
    override string Pand_ItemInfo()
	{
	let minfo =
	"Chaos-Radiation fused Immunity Crystal - chaos and radiation immunity inside crystal radius.";
	return minfo;
	}
	
    States
    {
    Spawn:
		TNT1 A 0 NoDelay A_JumpIf(Abs(VelZ) <= 0.01, "FloorHit");
        CRYS G 1;
        Loop;
    FloorHit:
		TNT1 A 0 A_ChangeFlag("SPECIAL", true);
		TNT1 A 0 A_ChangeFlag("THRUACTORS", false);
    Spawn2:
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamRadiation",
            Cos((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_SpawnItemEx("DRPGImmunityCrystalBeamRadiation",
            Cos((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            Sin((CallACS("GetTimer") / 256.0 + 17.5) * 360.0) * 512,
            0, 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        TNT1 A 0 A_RadiusGive("DRPGPowerImmunityRadiationPand", 512.0, RGF_PLAYERS);
        CRYS G 1 A_SpawnItemEx("DRPGImmunityCrystalPulseRadiation", Random(-8, 8), Random(-8, 8), Random(-16, 8), 0, 0, 0, 0, SXF_NOCHECKPOSITION);
        Loop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Death:
        TNT1 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 0 A_SpawnItemEx("DRPGImmunityCrystalDebris", 0, 0, Height / 2, Random(-8, 8), Random(-8, 8), 8, 0, SXF_NOCHECKPOSITION);
        Stop;
    }
	
	override bool Use(bool pickup)
	{
		if (Owner.FindInventory("DRPGImmunityCrystalRadiationPand"))
		{
			let thiccpotion = Spawn("DRPGImmunityCrystalRadiationPand",(Owner.pos.x,Owner.pos.y,Owner.pos.z+40));
			thiccpotion.Vel3DFromAngle(10,Owner.angle,Owner.pitch);
			Owner.TakeInventory("DRPGImmunityCrystalRadiationPand", 1);
			if(thiccpotion) thiccpotion.tracer = Owner;
			return true;	
		}
		return false;
	}
}

class DRPGPowerImmunityRadiationPand : PowerProtection
{
	Default
	{   
	+INVENTORY.AUTOACTIVATE;
    DamageFactor "Radiation", 0;
	DamageFactor "Chaos", 0;
	Powerup.Duration 35;
	}
}
// PANDEMONIA TO DRPG