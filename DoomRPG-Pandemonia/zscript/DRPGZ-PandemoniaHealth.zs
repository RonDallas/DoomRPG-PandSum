//Med kits
class DRPGStimpackPand : CustomInventory
{
  Default
  {
  Inventory.PickupMessage "Stimpack (+10 Health)";
  Inventory.PickupSound "Stimpack/Pickup";
  Tag "Stimpack";
  }
    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        MSTI A -1;
        Stop;
    Pickup:
        TNT1 A 0 A_JumpIf(CallACS("CheckMedkitMax"), "PickupFail");
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 10);
        Stop;
    PickupFail:
        TNT1 A 0;
        Fail;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("UsedStimpack",0,0,20,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

class DRPGMedikitPand : CustomInventory
{
  Default
  {
  Inventory.PickupSound "Medikit/Pickup";
  Inventory.PickupMessage "Medikit (+15 Health)";
  Scale 0.85;
  Tag "Medikit";
  }
    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        MEDK F -1;
        Stop;
    Pickup:
        TNT1 A 0 A_JumpIf(CallACS("CheckMedkitMax"), "PickupFail");
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 15);
        Stop;
    PickupFail:
        TNT1 A 0;
        Fail;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("UsedMedikitRPG",0,0,20,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

Class UsedMedikitRPG : Actor
{
  Default
  {
  Scale 0.85;
  }
  States
  {
  Spawn:
	MEDK J 150;
	MEDK J 10 A_FadeOut(0.1);
	Wait;
	}
}

class DRPGLargeMedikitPand : CustomInventory
{
  Default
  {
  Inventory.PickupSound "Medikit/Pickup";
  Inventory.PickupMessage "Large Medikit (+25 Health)";
  Tag "Large Medikit";
  }
    
    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        MEDK H -1;
        Stop;
    Pickup:
        TNT1 A 0 A_JumpIf(CallACS("CheckMedkitMax"), "PickupFail");
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 25);
        Stop;
    PickupFail:
        TNT1 A 0;
        Fail;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("UsedMedikit",0,0,20,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

class DRPGXLMedikitPand : CustomInventory
{
  Default
  {
  Inventory.PickupSound "Medikit/Pickup";
  Inventory.PickupMessage "Extra Large Medikit (+50 Health)";
  Tag "Extra Large Medikit";
  }
    
    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        MEDX A -1;
        Stop;
    Pickup:
        TNT1 A 0 A_JumpIf(CallACS("CheckMedkitMax"), "PickupFail");
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 50);
        Stop;
    PickupFail:
        TNT1 A 0;
        Fail;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("XLUsedMedikitRPG",0,0,20,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

class XLUsedMedikitRPG : Actor
{
  States
  {
  Spawn:
	MEDX B 150;
	MEDX B 10 A_FadeOut(0.1);
	Wait;
	}
}

class DRPGMedPackPand : CustomInventory
{
  Default
  {
  Inventory.PickupSound "Medikit/Pickup";
  Inventory.PickupMessage "Med Pack (+75 Health)";
  Tag "Med Pack";
  }
    
    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        MEDP A -1;
        Stop;
    Pickup:
        TNT1 A 0 A_JumpIf(CallACS("CheckMedkitMax"), "PickupFail");
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 75);
        Stop;
    PickupFail:
        TNT1 A 0;
        Fail;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("UsedMedPackRPG",0,0,10,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

class UsedMedPackRPG : Actor
{
  States
  {
  Spawn:
	MEDP B 150;
	MEDP B 10 A_FadeOut(0.1);
	Wait;
	}
}

class DRPGSurgeryKitpPand : CustomInventory
{
  Default
  {
  Inventory.PickupSound "Medikit/Pickup";
  Inventory.PickupMessage "Surgery Kit (+100 Health)";
  Tag "Surgery Kit";
  }
    
    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        MEDS AB 8;
        Goto Spawn+1;
    Pickup:
        TNT1 A 0 A_JumpIf(CallACS("CheckMedkitMax"), "PickupFail");
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 100);
        Stop;
    PickupFail:
        TNT1 A 0;
        Fail;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("UsedSurgeryKitRPG",0,0,10,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

class UsedSurgeryKitRPG : Actor
{
  States
  {
  Spawn:
	MEDS C 150;
	MEDS C 10 A_FadeOut(0.1);
	Wait;
	}
}

class DRPGMedkitRefillPand : CustomInventory
{
  Default
  {
  Inventory.PickupSound "Medikit/Pickup";
  Inventory.PickupMessage "Medkit Refill";
  Tag "Medkit Refil";
  }

    States
    {
    Spawn:
        MEDK A -1;
        Stop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteAlways("AddMedkit", 0, 1000000);
        Stop;
    }
  override void DoPickupSpecial(actor toucher)
	{
	A_SpawnItemEx("UsedMedkitRefillRPG",0,0,10,random(-1,1),random(-1,1),random(0,1));
	Super.DoPickupSpecial(toucher);
	}
}

class UsedMedkitRefillRPG : Actor
{
  States
  {
  Spawn:
	MEDK B 150;
	MEDK B 10 A_FadeOut(0.1);
	Wait;
	}
}

//Soul Spheres
Class NewSoulSphereRPG : NewSoulSphere
{
  Default
  {
  Inventory.PickupSound "Soulsphere/Pickup";
  Inventory.PickupMessage "\c[j1]Soulsphere\c-! (\c[j1]+100 Health\c-)";
  PandInventory.ColorTag "[j1]"; 
  Tag "Soulsphere";
  }
  
  States
  {
  Spawn:
	SOUL AABBCCDDCCBB 3 Bright A_SpawnItemEx("SphereEffect",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME);
	Loop;
  Pickup:
    TNT1 A 0 ACS_NamedExecuteWithResult("ClearStatusEffects");
    Stop;
	}
}

Class LifeSphereRPG : LifeSphere
{
  Default
  {
  Inventory.PickupSound "Lifesphere/Pickup";
  Inventory.PickupMessage "\c[c1]Life Sphere\c-! (\c[c1]+200 Health\c-)";
  PandInventory.ColorTag "[c1]"; 
  Tag "Life Sphere";
  }
  
  States
  {
  Spawn:
	LIFE AABBCCDDCCBB 3 Bright Light("SOULSPHERE") A_SpawnItemEx("SphereEffect",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME);
	Loop;
  Pickup:
    TNT1 A 0 ACS_NamedExecuteWithResult("ClearStatusEffects");
    Stop;
	}
	
  override bool Use(bool pickup)
	{
	if(!Owner)
		return true;
	Owner.GiveBody(200,300);
	Owner.A_SetBlend("Blue",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"LightBlue");
	RemoveStatusEffects();
	return true;
	}
}

Class GreatLifeSphereRPG : LifeSphere
{
  Default
  {
  Inventory.PickupSound "Lifesphere/Pickup";
  Inventory.PickupMessage "\c[c1]Great Life Sphere\c-! (\c[c1]+300 Health\c-)";
  Translation "192 : 207 = 172 : 187", "240 : 247 = 191 : 191";
  PandInventory.ColorTag "[d4]";  
  Tag "Great Life Sphere";
  }
  
  States
  {
  Spawn:
	LIF] AABBCCDDCCBBBCDCB 3 Bright Light("Doomsphere") 
		{
			A_SpawnItemEx("SphereEffect",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME);
			A_SpawnItemEx("DRPGBlingParticle",Random(-Radius,Radius),Random(-Radius,Radius),Random(-Height + 16,Height + 8));
		}
	Loop;
  Pickup:
    TNT1 A 0 ACS_NamedExecuteWithResult("ClearStatusEffects");
    Stop;
	}
	
  override bool Use(bool pickup)
	{
	if(!Owner)
		return true;
	Owner.GiveBody(300,300);
	Owner.A_SetBlend("Red",1.0*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20,"DarkRed");
	RemoveStatusEffects();
	return true;
	}
}


//Runes (garbage code 3) (may cause preformance issues)

Class ResistanceRuneRPG : ResistanceRune replaces ResistanceRune
{

  States
  {
  Spawn:
	RURS AAABBBCCCDDDEEEFFFGGGHHH 1 A_SpawnItemEx("PowerupPhaseGhost",0,0,0,0,0,0,0,SXF_TRANSFERSCALE|SXF_TRANSFERSTENCILCOL|SXF_TRANSFERSPRITEFRAME);
	Loop;
	}

  override void GiveRuneEffect(bool alteffect)
	{
	Owner.GiveInventory("ResistanceRunePower",1);
	PandHUDMessageHandler.PlainMsg(Owner.PlayerNumber(),"BIGFONT2","\cj- \cdResistance Rune \cj-",(240,120),(480,360),time:(0.2,3,0.5),id:11);
	if(alteffect)
		{
		Owner.GiveInventory("ResistanceRunePower2",1);
		Owner.GiveInventory("ResistanceRunePowerRPG",1);
		PandHUDMessageHandler.PlainMsg(Owner.PlayerNumber(),"CONFONT","Increased maximum health by 200\nStatus effect immunity",(240,140),(480,360),0,time:(0.2,3,0.5),id:12);
		return;
		}
	PandHUDMessageHandler.PlainMsg(Owner.PlayerNumber(),"CONFONT","Incoming damage is reduced by 33%",(240,130),(480,360),time:(0.2,3,0.5),id:12);
	}
}

Mixin Class PandPowerupRPG
{
  int d;
  void PowerupTimer(name pwr, sound warnsound, color c, string txtcolor = "d")
  	{
	string s = "\c"..txtcolor..pwr.."\c- is about to wear off!";
	if(d == 105 || d == 70 || d == 35)
		{
		if(d == 105)
			Owner.A_StartSound(warnsound,20,flags:CHANF_LOCAL);
		Owner.A_SetBlend(c,0.4*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),12);
		PandHUDMessageHandler.PlainMsg(Owner.PlayerNumber(),"CONFONT",s,(240,110),(480,360),0,time:(0,0.5,0.2),id:5);
		}
  	}
}

Class ResistanceRunePowerRPG : Powerup
{
  mixin PandPowerupRPG;
  
  Default
    {
        Powerup.Duration 0x7FFFFFFF;
    }
  
  override void InitEffect()
	{
	Super.InitEffect();
	if(!Owner)
		return;
	}
  
  override void DoEffect()
	{
	Super.DoEffect();
	d = Level.time;
	if(Level.time % 35 == 0) // pref issue
		{
		if(Owner.FindInventory("ResistanceRunePower2"))
			{
			Owner.ACS_NamedExecuteAlways("AddToxicity", 0, -100);
			Owner.ACS_NamedExecuteAlways("ClearStatusEffects", 0);
			Owner.ACS_NamedExecuteAlways("ClearBurnout", 0);
			}
		else
			{
			Destroy();
			}
		}
	}
	
  override void EndEffect()
	{
	Super.EndEffect();
	}
}