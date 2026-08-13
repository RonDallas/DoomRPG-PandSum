// --------------------------------------------------
// AMMO ITEMS
//

class Pand_AmmoRPG : Pand_Ammo replaces Pand_Ammo
{
  States
  {
	Spawn:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	TNT1 A 1 Pand_SetAmmoSprite();
	#### A -1;
	stop;
	DSmall:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	DAM1 AAAABBBBCCCC 1;
	loop;
	DBig:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	DAM2 AAAABBBBCCCC 1 A_SpawnItemEx("BrightSphereEffect2",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME|SXF_TRANSFERSCALE);
	loop;
	ChaosSpawn:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	CSS0 A 1 
		{
		if(Owner) return;
		A_SpawnItemEx("BrightSphereEffect2",0,0,0,0,0,0,0,SXF_TRANSFERSPRITEFRAME|SXF_TRANSFERSCALE);
		A_SpawnItemEx("ChaoticEssenceSmoke",0,0,32,frandom(-2,2),frandom(-2,2),frandom(-2,2),0,0,128);
		}
	loop;
	LoadSprites:
	CLIP A 0; AMMO A 0; SHEL A 0; SBOX A 0; ROCK A 0; BROK A 0; CELL A 0 ; CELP A 0; DAM1 ABC 0; DAM2 ABC 0; CSS0 A 0; BGXP A 0;
	}
}

// --------------------------------------------------
// Standart Ammo

class NewClipRPG : NewClip {}

class NewClipBoxRPG : NewClipBox {}

class NewShellRPG : NewShell {}

class NewShellBoxRPG : NewShellBox {}

class NewRocketAmmoRPG : NewRocketAmmo {}

class NewRocketBoxRPG : NewRocketBox {}

class NewCellRPG : NewCell {}

class NewCellPackRPG : NewCellPack {}

// --------------------------------------------------
// Half Ammo

class NewHalfClipRPG : NewClipRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up a short bullet clip.";
	Inventory.Amount 5;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		CLP2 A -1;
		Stop;
	}
}

class NewHalfClipBoxRPG : NewClipBoxRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up a small bullet box.";
	Inventory.Amount 25;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		AMOK A -1;
		Stop;
	}
}

class NewHalfShellRPG : NewShellRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up two shotgun shells.";
	Inventory.Amount 2;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		SHEL H -1;
		Stop;
	}
}

class NewHalfShellBoxRPG : NewShellBoxRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up a spare shotgun shell box.";
	Inventory.Amount 10;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		SHLK A -1;
		Stop;
	}
}

class NewHalfRocketBoxRPG : NewRocketBoxRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up a half full rocket crate.";
	Inventory.Amount 3;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		BROK H -1;
		Stop;
	}
}

class NewHalfCellRPG : NewCellRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up a weak energy cell.";
	Inventory.Amount 10;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		CELL A -1;
		Stop;
	}
}

class NewHalfCellPackRPG : NewCellPackRPG
{
	Default
	{
	Inventory.PickupMessage "You picked up a small energy cell pack.";
	Inventory.Amount 50;
	}
	
	States
	{
	Spawn:
		TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
		CELK A -1;
		Stop;
	}
}


// --------------------------------------------------
// Full Ammo

class NewClipRPGFull : NewClipRPG {}

class NewClipBoxRPGFull : NewClipBoxRPG {}

class NewShellRPGFull : NewShellRPG {}

class NewShellBoxRPGFull : NewShellBoxRPG {}

class NewRocketBoxRPGFull : NewRocketBoxRPG {}

class NewCellRPGFull : NewCellRPG {}

class NewCellPackRPGFull : NewCellPackRPG {}

// --------------------------------------------------
// Backpacks

class PandBackpackSRPG : CustomInventory
{
  Default
  {
  Height 26;
  Inventory.PickupSound "Backpack/pickup";
  Inventory.PickupMessage "Satchel with some ammo.";
  Scale 0.85;
  Tag "Backpack";
  }
  States
  {
  Spawn:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	BPAK H -1;
	Stop;
  Pickup:
		TNT1 A 0 A_GiveInventory("NewClipRPG",40);
		TNT1 A 0 A_GiveInventory("NewShellRPG",10);
		TNT1 A 0 A_GiveInventory("NewRocketAmmoRPG",2);
		TNT1 A 0 A_GiveInventory("NewCellRPG",30);
		Stop;
	}
}

class PandBackpackMRPG : CustomInventory
{
  Default
  {
  Height 26;
  Inventory.PickupSound "Backpack/pickup";
  Inventory.PickupMessage "Ammunition Backpack";
  Scale 0.85;
  Tag "Backpack";
  }
  States
  {
  Spawn:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	BPAK A -1;
	Stop;
  Pickup:
		TNT1 A 0 A_GiveInventory("NewClipRPG",100);
		TNT1 A 0 A_GiveInventory("NewShellRPG",25);
		TNT1 A 0 A_GiveInventory("NewRocketAmmoRPG",5);
		TNT1 A 0 A_GiveInventory("NewCellRPG",75);
		Stop;
	}
}

class PandBackpackBRPG : CustomInventory
{
  Default
  {
  Height 26;
  Inventory.PickupSound "Backpack/pickup";
  Inventory.PickupMessage "Big golden backpack loaded with ammo.";
  Scale 0.85;
  Tag "Backpack";
  }
  States
  {
  Spawn:
	TNT1 A 0 ACS_NamedExecuteAlways("ItemInit",0);
	BPAK I 6 Bright;
	BPAK I 1 Bright A_SpawnItemEx("DRPGBlingParticle",Random(-Radius,Radius),Random(-Radius,Radius),Random(-Height + 16,Height + 8));
	Goto Spawn+1;
  Pickup:
		TNT1 A 0 A_GiveInventory("NewClipRPG",200);
		TNT1 A 0 A_GiveInventory("NewShellRPG",50);
		TNT1 A 0 A_GiveInventory("NewRocketAmmoRPG",10);
		TNT1 A 0 A_GiveInventory("NewCellRPG",150);
		Stop;
	}
}
/*

actor DRPGBigBackpack : DRPGBackpack
{
	Inventory.PickupMessage "You picked up a big golden backpack loaded with ammo."
	Inventory.PickupSound "items/pack"
	
	States
	{
	Spawn:
		TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit",0)
		GPAK A 6 Bright
		GPAK A 1 Bright A_SpawnItemEx("DRPGBlingParticle",Random(-Radius,Radius),Random(-Radius,Radius),Random(-Height + 16,Height + 8))
		Goto Spawn+1
	Pickup:
		TNT1 A 0 A_GiveInventory("Clip",200)
		TNT1 A 0 A_GiveInventory("Shell",50)
		TNT1 A 0 A_GiveInventory("RocketAmmo",10)
		TNT1 A 0 A_GiveInventory("Cell",150)
		Stop
	}
}
/*
// --------------------------------------------------
// Stolen Ammo Tokens

actor DRPGStolenClip : CustomInventory
{
	Inventory.PickupMessage "You picked up a stolen bullet clip."
	Inventory.PickupSound "items/clip"
	
	States
	{
	Spawn:
		TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit",0)
		CLIP A -1
		Stop
	Pickup:
		TNT1 A 0 A_GiveInventory("Clip",10)
		Stop
	}
}

actor DRPGStolenShell : CustomInventory
{
	Inventory.PickupMessage "You picked up stolen four shotgun shells."
	Inventory.PickupSound "items/shell"
	
	States
	{
	Spawn:
		TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit",0)
		SHEL A -1
		Stop
	Pickup:
		TNT1 A 0 A_GiveInventory("Shell",4)
		Stop
	}
}

actor DRPGStolenRocketAmmo : CustomInventory
{
	Inventory.PickupMessage "You picked up a stolen rocket."
	Inventory.PickupSound "items/rocket"
	
	States
	{
	Spawn:
		TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit",0)
		ROCK A -1
		Stop
	Pickup:
		TNT1 A 0 A_GiveInventory("RocketAmmo",1)
		Stop
	}
}

actor DRPGStolenCell : CustomInventory
{
	Inventory.PickupMessage "You picked up a stolen energy cell."
	Inventory.PickupSound "items/cell"
	
	States
	{
	Spawn:
		TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit",0)
		CELL A -1
		Stop
	Pickup:
		TNT1 A 0 A_GiveInventory("Cell",20)
		Stop
	}
}
