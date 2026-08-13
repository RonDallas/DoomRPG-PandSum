// Map Event - Termonuclear Bomb
class DRPGThermonuclearBombPickupPand : PandCustomInventory
{
  Default
  {
    Tag "Thermonuclear Bomb";
    Inventory.MaxAmount 1;
    Inventory.InterHubAmount 1;
    Inventory.PickupMessage "You picked up a thermonuclear bomb.";
    Inventory.PickupSound "nuke/pickup";
    Inventory.Icon "NUKE";
	Species "PInv_Main";
	PandCustomInventory.Description "Biggest bumba ever (temp description)\n\n";
    PandCustomInventory.ColorTag "[X0]";
    +INVENTORY.INVBAR;
  }
override string Pand_ItemInfo()
{
let minfo = "Big bumba (temp description).";
return minfo;
}
    States
    {
    Spawn:
        TBOM C -1;
        Stop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    Use:
        TNT1 A 1 A_SpawnItemEx("DRPGThermonuclearBombDropped");
        Stop;
    }
}