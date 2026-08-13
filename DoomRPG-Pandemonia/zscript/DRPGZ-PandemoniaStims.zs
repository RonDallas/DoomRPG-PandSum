class DRPGStimDetoxPand : PandInventory
{
  Default
  {
  Scale 0.5;
  Inventory.PickupMessage "You picked up a detox hypospray.";
  Inventory.PickupSound "items/stim";
  Inventory.UseSound "items/stim";
  Inventory.Icon "STIMC";
  Inventory.DefMaxAmount;
  Inventory.InterHubAmount 1000;
  PandInventory.Description "Removes all toxicity, status effects, and energy burnout.";
  +INVENTORY.INVBAR;
  PandInventory.ColorTag "[H2]";
  Tag "Detox hypospray";
  Species "PInv_Main";
  }

override string Pand_ItemInfo()
{
let minfo =
"Detox hypospray - removes all toxicity, status effects, and energy burnout.";
return minfo;
}

    States
    {
    Spawn:
        TNT1 A 0 NoDelay ACS_NamedExecuteAlways("ItemInit", 0);
        STIM C -1 Bright;
        Stop;
    Pickup:
        TNT1 A 0 ACS_NamedExecuteWithResult("CheckCapacity");
        Stop;
    }
	
  override bool Use(bool pickup)
	{
	if(CallACS("GetStimPowerupActive") == 1)
		{
		Owner.ACS_NamedExecuteAlways("TossStim", 0);
		Owner.ACS_NamedExecuteAlways("AddToxicity", 0, -100);
		Owner.ACS_NamedExecuteAlways("ClearStatusEffects", 0);
		Owner.ACS_NamedExecuteAlways("ClearBurnout", 0);
				
		array<string> shit;
		for(inventory item=Owner.inv;item!=null;item=item.inv)
			{
			if(item.GetTag() == "StatusGiver" || item.GetTag() == "StatusEffect")
				{
				shit.Push(item.GetClassName());
				}
			}
		for(int a = 0;a<shit.Size();a++)
			{
			let item = Owner.FindInventory(shit[a]);
			if(item.GetTag() == "StatusGiver")
				{
				item.DepleteOrDestroy();
				RemoveInventory(item);
				}
			else if(item.GetTag() == "StatusEffect" && Powerup(item))
				{
				Powerup(item).EffectTics = Clamp(Powerup(item).EffectTics-300,1,1000);
				}
			}
		Owner.A_SetBlend("Blue",0.7*(CVar.GetCVar("pan_blendscale",players[consoleplayer]).GetFloat()),20);
		return true;
		}
	else
		return false;
	}
	
  bool HasStatusEffect()
	{
	for(inventory item=Owner.inv;item!=null;item=item.inv)
		{
  		if(item.GetTag() == "StatusGiver" || item.GetTag() == "StatusEffect")
			{
			return true;
			}
		}
	return false;
	}

}