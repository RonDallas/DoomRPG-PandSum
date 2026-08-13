//Some resistance for DRPG things

Class SacrosanctPalisadeRPG : SacrosanctPalisade replaces SacrosanctPalisade
{
  Default
  {
  Inventory.PickupSound "SacroArmor/Pickup";
  Inventory.PickupMessage "\c[j5]Sacrosanct Palisade\c-!";
  Inventory.Icon "CXRMZ0";
  StencilColor "DarkGreen";
  Armor.SavePercent 80;
  Armor.SaveAmount 350;
  DamageFactor "Chaos", 0.2;
  DamageFactor "Plasma", 0.75;
  DamageFactor "Explosive", 0.75;
  DamageFactor "Fire", 0.75;
  DamageFactor "Bullet", 0.75;
  DamageFactor "Radiation", 0.5;
  DamageFactor "Shadow", 0.8;
  PandBasicArmorPickup.CantBreak true;
  PandBasicArmorPickup.ArmorStrength 0.75;
  Tag "\c[j5]Sacrosanct Palisade";
  }
}

Class ChaoticChestplateRPG : ChaoticChestplate replaces ChaoticChestplate
{
  Default
  {
  Inventory.PickupSound "ChaosArmor/Pickup";
  Inventory.PickupMessage "\c[j5]Chaotic Chestplate\c-!";
  Inventory.Icon "CXRMY0";
  StencilColor "DarkGreen";
  Armor.SavePercent 75;
  Armor.SaveAmount 300;
  DamageFactor "Chaos", 0.3;
  DamageFactor "Explosive", 0.8;
  DamageFactor "Radiation", 0.7;
  DamageFactor "Shadow", 0.9;
  PandBasicArmorPickup.CantBreak true;
  PandBasicArmorPickup.ArmorStrength 0.65;
  Tag "\c[j5]Chaotic Chestplate";
  }
 }

Class DistortedArmorRPG : DistortedArmor replaces DistortedArmor
{
  Default
  {
  Inventory.PickupSound "StrongArmor/Pickup";
  Inventory.PickupMessage "\c[u7]Distorted Armor\c-!";
  Inventory.Icon "DSRMA0";
  Armor.SavePercent 80;
  Armor.SaveAmount 350;
  DamageFactor "Distortion", 0.15;
  DamageFactor "Bullet", 0.4;
  DamageFactor "Shadow", 0.75;
  PandBasicArmorPickup.CantBreak true;
  PandBasicArmorPickup.ArmorStrength 0.65;
  Tag "\c[u7]Distorted Armor";
  }
}

Class CyberneticArmorRPG : CyberneticArmor replaces CyberneticArmor
{
  Default
  {
  Inventory.PickupSound "CyberArmor/Pickup";
  Inventory.PickupMessage "\ccCybernetic Armor\c-!";
  Inventory.Icon "CARMA0";
  Armor.SavePercent 60;
  Armor.SaveAmount 250;
  PandBasicArmorPickup.CantBreak true;
  DamageFactor "Plasma", 0.65;
  DamageFactor "Bullet", 0.9;
  DamageFactor "Radiation", 0.8;
  Tag "\ccCybernetic Armor";
  }
}

Class FirebluArmorRPG : FirebluArmor replaces FirebluArmor
{
  Default
  {
  Inventory.PickupSound "BlueArmor/Pickup";
  Inventory.PickupMessage "\c[h3]Fireblu Armor\c-!";
  Inventory.Icon "FBRMA0";
  Armor.SavePercent 50;
  Armor.SaveAmount 666;
  DamageFactor "Normal", 0.5;
  DamageFactor "Shadow", 0.7;
  Tag "\c[h3]Fireblu Armor";
  PandBasicArmorPickup.IsRepairable false;
  }
}

Class ObsidianArmorRPG : ObsidianArmor replaces ObsidianArmor
{
  Default
  {
  Inventory.PickupSound "StrongArmor/Pickup";
  Inventory.PickupMessage "\c[e6]Obsidian Armor\c-!";
  Inventory.Icon "OBRMA0";
  Armor.SavePercent 50;
  Armor.SaveAmount 80;
  DamageFactor "Normal", 0.2;
  DamageFactor "Radiation", 0.8; //https://www.sciencedirect.com/science/article/abs/pii/S0969806X22003528
  Tag "\c[e6]Obsidian Armor";
  PandBasicArmorPickup.IsRepairable false;
  }
}