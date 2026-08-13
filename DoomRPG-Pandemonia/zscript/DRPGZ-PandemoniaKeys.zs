class DRPGBlueCardPand : BlueCard
{
    Default 
	{ 
	Inventory.PickupSound "Keycard/Pickup";
    Inventory.PickupMessage "You got a \cyblue\c- key card!";
	Inventory.Icon "STKEYS0";
	Species "BlueCard";
	Tag "Blue Keycard";
	+INVENTORY.NOSCREENFLASH;
	+BRIGHT;
	}
  States
  {
  Spawn:
	TNT1 A 0;
  SpawnLoop:
	BKEY ABCDEFGHIJKL 4;
	loop;
  }
}

class DRPGYellowCardPand : YellowCard
{
    Default 
	{ 
	Inventory.PickupSound "Keycard/Pickup";
	Inventory.PickupMessage "You got a \ckyellow\c- key card!";
	Inventory.Icon "STKEYS1";
	Species "YellowCard";
	Tag "Yellow Keycard";
	+INVENTORY.NOSCREENFLASH;
	+BRIGHT;
	}
  States
  {
  Spawn:
	TNT1 A 0;
  SpawnLoop:
	YKEY ABCDEFGHIJKL 4;
	loop;
  }
}

class DRPGRedCardPand : RedCard
{
    Default 
	{ 
	Inventory.PickupSound "Keycard/Pickup";
	Inventory.PickupMessage "You got a \crred\c- key card!";
	Inventory.Icon "STKEYS2";
	Species "RedCard";
	Tag "Red Keycard";
	+INVENTORY.NOSCREENFLASH;
	+BRIGHT;
	}
  States
  {
  Spawn:
	TNT1 A 0;
  SpawnLoop:
	RKEY ABCDEFGHIJKL 4;
	loop;
  }
}

class DRPGBlueSkullPand : BlueSkull
{
    Default 
	{ 
	Inventory.PickupSound "SkullKey/Pickup";
	Inventory.PickupMessage "You got a \cyblue\c- skull key!";
	Inventory.Icon "STKEYS3";
	Species "BlueSkull";
	Tag "Blue Skull Key";
	+INVENTORY.NOSCREENFLASH;
	+BRIGHT;
	}
  States
  {
  Spawn:
	TNT1 A 0;
  SpawnLoop:
	BSKY ABCDEFGH 4;
	loop;
  }
}

class DRPGYellowSkullPand : YellowSkull
{
    Default 
	{ 
	Inventory.PickupSound "SkullKey/Pickup";
	Inventory.PickupMessage "You got a \ckyellow\c- skull key!";
	Inventory.Icon "STKEYS4";
	Species "YellowSkull";
	Tag "Yellow Skull Key";
	+INVENTORY.NOSCREENFLASH;
	+BRIGHT;
	}
  States
  {
  Spawn:
	TNT1 A 0;
  SpawnLoop:
	YSKY ABCDEFGH 4;
	loop;
  }
}

class DRPGRedSkullPand : RedSkull
{
    Default 
	{ 
	Inventory.PickupSound "SkullKey/Pickup";
	Inventory.PickupMessage "You got a \crred\c- skull key!";
	Inventory.Icon "STKEYS5";
	Species "RedSkull";
	Tag "Red Skull Key";
	+INVENTORY.NOSCREENFLASH;
	+BRIGHT;
	}
  States
  {
  Spawn:
	TNT1 A 0;
  SpawnLoop:
	RSKY ABCDEFGH 4;
	loop;
  }
}
