class DRPGPowerupDropperPand : RandomSpawner
{
    Default
    {
    DropItem "InvulSpawner", 				255,10;
    DropItem "DRPGInvulnerabilityCharge", 	255,10;
    DropItem "BlurSpawner",            		255,10;
    DropItem "DRPGInvisibilityCharge",   	255,10;
    DropItem "DRPGTimeSphere",          	255,10;
    DropItem "DRPGRegenSphere",          	255,10;
    DropItem "RadsuitSpawner",              255,10;
    DropItem "InfraredSpawner",             255,10;
    }
}

// Blur Sphere Locations
class DRPGBlurSphereRandomizerPand : RandomSpawner
{
    Default
    {
    DropItem "BlurSpawner",            		255,100;
    DropItem "DRPGTimeSphere",              255,1;
    }
}

// Shop armor display
class DRPGShopArmorRandomizerPand : RandomSpawner
{
    Default
    {
    DropItem "SecurityArmor",      			255,5;
    DropItem "CombatArmor",        			255,4;
	DropItem "BulletproofVest",        		255,4;
    DropItem "SkirmishArmor",      			255,3;
    DropItem "AdmiralArmor",         		255,2;
    DropItem "ObsidianArmor",      			255,1;
    }
}

// Other shop display items
class DRPGShopMiscRandomizerPand : RandomSpawner
{
    Default
    {
    DropItem "DRPGTurretPart",       		255,10;
	DropItem "ArmorBoost",        			255,3;
    DropItem "WeaponSupplyKit",        		255,1;
    }
}