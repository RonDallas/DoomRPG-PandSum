// DOOMRPG COMPATIBILITY
// --------------------------------------------------

//Pand teleport fog fix (not spawning when reinforcements arrive)
Class PandTeleportFogRPG :
TeleportFog replaces NewTeleportFog
{

    States
    {
Spawn:
        TNT1 A 0 NoDelay A_PlaySound("Teleport/Normal",1);
        TNT1 AAAAAA 5 Light("DTFOG1")
        {
            A_SpawnItemEx("BFGLightningTrail",0,0,32,0,0,0,0,0,128);
            A_SpawnItemEx("BFGBallTrail",0,0,32,frandom(0,3),0,frandom(-3,3),random(0,360));
            //A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),0,0,32,frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-1.2); //can`t add the fancy praticles
        }
        Stop;
    }
}

//Monsters Things (damage types, drop items and etc.)

//Zombies
Class PistolZombieRPG :
PistolZombie replaces PistolZombie
{
    Default
    {
        DropItem "PistolZombieDropRPG";
    }
}

Class PistolZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGPistol",         255, 48;
        DropItem "DRPGPistolSpawner",  255, 6;
        DropItem "DRPGClipSpawner",    255, 204;
    }
}

Class LaserRifleZombieRPG :
LaserRifleZombie replaces LaserRifleZombie
{
    Default
    {
        DropItem "LaserRifleZombieDropRPG";
        DamageType "Plasma";
    }
}

Class LaserRifleZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGPlasmaRifle",         255, 48;
        DropItem "DRPGPlasmaRifleSpawner",  255, 6;
        DropItem "DRPGCellSpawner",         255, 204;
    }
}

Class PlasmaPistolZombieRPG :
PlasmaPistolZombie replaces PlasmaPistolZombie
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
        DamageType "Plasma";
    }
}

Class SpecOpsRiflemanRPG :
SpecOpsRifleman replaces SpecOpsRifleman
{
    Default
    {
        DropItem "SpecOpsRiflemanDropRPG";
        DamageType "Plasma";
    }
}

Class SpecOpsRiflemanDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGClipSpawner",    255, 208;
        DropItem "DRPGCellSpawner",    255, 48;
    }
}

Class CinderZombieRPG :
CinderZombie replaces CinderZombie
{
    Default
    {
        DropItem "PistolZombieDropRPG";
        DamageType "Fire";
    }
}

Class SeraphRPG :
Seraph replaces Seraph {}

Class LaserBorgRPG :
LaserBorg replaces LaserBorg {}
Class PelterRPG :
Pelter replaces Pelter {}
Class PistolBorgRPG :
PistolBorg replaces PistolBorg {}

//Shotgunners
Class NewShotgunguyRPG :
NewShotgunguy replaces NewShotgunguy
{
    Default
    {
        DropItem "NewShotgunguyDropRPG";
    }
}

Class NewShotgunguyDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGShotgun",         255, 48;
        DropItem "DRPGShotgunSpawner",  255, 6;
        DropItem "DRPGShellSpawner",    255, 204;
    }
}

Class AutoShotgunZombieRPG :
AutoShotgunZombie replaces AutoShotgunZombie
{
    Default
    {
        DropItem "AutoShotgunZombieDropRPG";
    }
}

Class AutoShotgunZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGCombatShotgun",           255, 48;
        DropItem "DRPGCombatShotgunSpawner",    255, 6;
        DropItem "DRPGShellSpawner",            255, 204;
        DropItem "DRPGShellBoxSpawner",         255, 48;
    }
}

Class RocketZombieRPG :
RocketZombie replaces RocketZombie
{
    Default
    {
        DropItem "RocketZombieDropRPG";
    }
}

Class RocketZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGRocketLauncher",          255, 48;
        DropItem "DRPGRocketLauncherSpawner",   255, 6;
        DropItem "DRPGRocketAmmoSpawner",       255, 204;
    }
}

Class ShotgunAdmiralRPG :
ShotgunAdmiral replaces ShotgunAdmiral
{
    Default
    {
        DropItem "ShotgunAdmiralDropRPG";
    }
}

Class ShotgunAdmiralDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGChaingun",           255, 48;
        DropItem "DRPGChaingunSpawner",    255, 6;
        DropItem "DRPGShellBoxSpawner",    255, 204;
    }
}

Class SlugShotgunZombieRPG :
SlugShotgunZombie replaces SlugShotgunZombie
{
    Default
    {
        DropItem "SlugShotgunZombieDropRPG";
    }
}

Class SlugShotgunZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGShotgun",          255, 48;
        DropItem "DRPGShotgunSpawner",   255, 6;
        DropItem "DRPGShellSpawner",     255, 204;
    }
}

Class SpecOpsShotgunnerRPG :
SpecOpsShotgunner replaces SpecOpsShotgunner
{
    Default
    {
        DropItem "SpecOpsShotgunnerDropRPG";
    }
}

Class SpecOpsShotgunnerDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGCombatShotgun",           255, 48;
        DropItem "DRPGCombatShotgunSpawner",    255, 6;
        DropItem "DRPGShellSpawner",            255, 204;
        DropItem "DRPGShellBoxSpawner",         255, 48;
    }
}

Class SuperShotgunZombieRPG :
SuperShotgunZombie replaces SuperShotgunZombie
{
    Default
    {
        DropItem "SuperShotgunZombieDropRPG";
    }
}

Class SuperShotgunZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGSuperShotgun",          255, 48;
        DropItem "DRPGSuperShotgunSpawner",   255, 6;
        DropItem "DRPGShellSpawner",          255, 204;
    }
}

Class ChaosWarriorRPG :
ChaosWarrior replaces ChaosWarrior
{
    Default
    {
        DropItem "ChaosWarriorDropRPG";
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}

Class ChaosWarriorDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGCellSpawner",          255, 208;
        DropItem "DRPGCellPackSpawner",      255, 48;
    }
}

Class ChaosWarriorProjectileDRPG :
ChaosWarriorProjectile replaces ChaosWarriorProjectile
{
    Default
    {
        Damagetype "Radiation";
    }
}

Class PyroZombieRPG :
PyroZombie replaces PyroZombie
{
    Default
    {
        DropItem "NewShotgunguyDropRPG";
    }
}

Class AbyssalCultLeaderRPG :
AbyssalCultLeader replaces AbyssalCultLeader
{
    Default
    {
        Damagetype "Shadow";
		DamageFactor "Radiation", 0.5;
		DamageFactor "Shadow", 0.5;
    }
}

Class OppressorRPG :
Oppressor replaces Oppressor {}

Class AssailantRPG :
Assailant replaces Assailant {}
Class BlasterborgRPG :
Blasterborg replaces Blasterborg {}
Class ShotgunBorgRPG :
ShotgunBorg replaces ShotgunBorg {}

//Chaingunners
Class ChaingunZombieRPG :
ChaingunZombie replaces ChaingunZombie
{
    Default
    {
        DropItem "ChaingunZombieDropRPG";
    }
}

Class ChaingunZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGChaingun",          255, 48;
        DropItem "DRPGChaingunSpawner",   255, 6;
        DropItem "DRPGClipBoxSpawner",    255, 204;
    }
}

Class AssaultGunnerRPG :
AssaultGunner replaces AssaultGunner
{
    Default
    {
        DropItem "AssaultGunnerDropRPG";
    }
}

Class AssaultGunnerDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGBattleRifle",          255, 48;
        DropItem "DRPGBattleRifleSpawner",   255, 6;
        DropItem "DRPGClipBoxSpawner",       255, 204;
    }
}

Class NailborgCommandoRPG :
NailborgCommando replaces NailborgCommando
{
    Default
    {
        DropItem "NailborgCommandoDropRPG";
    }
}

Class NailborgCommandoDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGChaingun",          255, 48;
        DropItem "DRPGChaingunSpawner",   255, 6;
        DropItem "DRPGClipBoxSpawner",    255, 204;
    }
}

Class SpecOpsGunnerRPG :
SpecOpsGunner replaces SpecOpsGunner
{
    Default
    {
        DropItem "SpecOpsGunnerDropRPG";
    }
}

Class SpecOpsGunnerDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGBattleRifle",         255, 48;
        DropItem "DRPGBattleRifleSpawner",  255, 6;
        DropItem "DRPGClipBoxSpawner",      255, 204;
    }
}

Class SpecOpsLieutenantRPG :
SpecOpsLieutenant replaces SpecOpsLieutenant
{
    Default
    {
        DropItem "SpecOpsLieutenantDropRPG";
    }
}

Class SpecOpsLieutenantDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGChaingun",           255, 48;
        DropItem "DRPGChaingunSpawner",    255, 6;
        DropItem "DRPGClipBoxSpawner",     255, 128;
        DropItem "DRPGRocketAmmoSpawner",  255, 128;
    }
}

Class ChaosDeathmarkRPG :
ChaosDeathmark replaces ChaosDeathmark
{
    Default
    {
        DropItem "ChaosDeathmarkDropRPG";
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}

Class ChaosDeathmarkDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGCellSpawner",          255, 208;
        DropItem "DRPGCellPackSpawner",      255, 48;
    }
}

Class DeathmarkPuffDRPG :
DeathmarkPuff replaces DeathmarkPuff
{
    Default
    {
        DamageType "Radiation";
    }
}

Class PlasmaRifleZombieRPG :
PlasmaRifleZombie replaces PlasmaRifleZombie
{
    Default
    {
        DropItem "PlasmaRifleZombieDropRPG";
        DamageType "Plasma";
    }
}

Class PlasmaRifleZombieDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGPlasmaRifle",         255, 48;
        DropItem "DRPGPlasmaRifleSpawner",  255, 6;
        DropItem "DRPGCellSpawner",         255, 204;
    }
}

Class BFG10kWarriorRPG :
BFG10kWarrior replaces BFG10kWarrior
{
    Default
    {
        DropItem "BFG10kWarriorDropRPG";
        DamageType "Plasma";
    }
}

Class BFG10kWarriorDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGBFG9000",          255, 48;
        DropItem "DRPGBFG9000Spawner",   255, 6;
        DropItem "DRPGCellPackSpawner",  255, 204;
    }
}

Class BFGCommandoRPG :
BFGCommando replaces BFGCommando
{
    Default
    {
        DropItem "BFGCommandoDropRPG";
        DamageType "Plasma";
    }
}

Class BFGCommandoDropRPG :
RandomSpawner
{
    Default
    {
        DropItem "DRPGBFG9000",          255, 48;
        DropItem "DRPGBFG9000Spawner",   255, 6;
        DropItem "DRPGCellPackSpawner",  255, 204;
    }
}

Class ScourgeZombieRPG :
ScourgeZombie replaces ScourgeZombie
{
    Default
    {
        DropItem "PlasmaRifleZombieDropRPG";
        DamageType "Slime";
        DamageFactor "Slime", 0.3;
    }
}
Class ScourgeProjectileDRPG :
ScourgeProjectile replaces ScourgeProjectile
{
    Default
    {
        DamageType "Slime";
    }
}

Class InfernalCommandoRPG :
InfernalCommando replaces InfernalCommando
{
    Default
    {
        DropItem "BFGCommandoDropRPG";
        DamageType "Fire";
    }
}

Class BlazegunnerRPG :
Blazegunner replaces Blazegunner {}

Class ElectroborgRPG :
Electroborg replaces Electroborg {}

Class NailborgRPG :
Nailborg replaces Nailborg {}

Class NailborgAdmiralRPG :
NailborgAdmiral replaces NailborgAdmiral {}

//DreadDivision

Class DreadDivision_BreacherRPG :
DreadDivision_Breacher replaces DreadDivision_Breacher {}

Class DreadDivision_EnforcerRPG :
DreadDivision_Enforcer replaces DreadDivision_Enforcer {}

Class DreadDivision_MarksmanRPG :
DreadDivision_Marksman replaces DreadDivision_Marksman {}

Class DreadDivision_PatrolRPG :
DreadDivision_Patrol replaces DreadDivision_Patrol {}

Class DreadDivision_JuggernautRPG :
DreadDivision_Juggernaut replaces DreadDivision_Juggernaut {}

//Imps
Class DarkImpRPG :
DarkImp replaces DarkImp {}
Class DevilRPG :
Devil replaces Devil {}
Class CyberImpRPG :
CyberImp replaces CyberImp {}
Class NewImpRPG :
NewImp replaces NewImp {}
Class PhaseImpRPG :
PhaseImp replaces PhaseImp {}
Class ScoundrelRPG :
Scoundrel replaces Scoundrel {}
Class BrimstoneImpRPG :
BrimstoneImp replaces BrimstoneImp {}

Class ChaosImpRPG :
ChaosImp replaces ChaosImp
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}

Class PlaguelingRPG :
Plagueling replaces Plagueling
{
    Default
    {
        DamageType "Slime";
        DamageFactor "Slime", 0.3;
    }
}
Class PlaguelingBallDRPG :
PlaguelingBall replaces PlaguelingBall
{
    Default
    {
        DamageType "Slime";
    }
}
Class PlaguelingPoisonPodDRPG :
PlaguelingPoisonPod replaces PlaguelingPoisonPod
{
    Default
    {
        DamageType "Slime";
    }
}

Class AbyssalSavageRPG :
AbyssalSavage replaces AbyssalSavage
{
    Default
    {
        DamageType "Shadow";
        DamageFactor "Shadow", 0;
    }
}
Class AbyssalSavageBallRPG :
AbyssalSavageBall replaces AbyssalSavageBall
{
    Default
    {
        DamageType "Shadow";
        DamageType "Fire";
    }
}
Class AbyssalSavageDarkBallRPG :
AbyssalSavageDarkBall replaces AbyssalSavageDarkBall
{
    Default
    {
        DamageType "Shadow";
    }

    States
    {
Spawn:
        ABI1 AABB 1 Bright
        {
            A_SpawnItemEx("AbyssalGhostProj",0,0,0,frandom(-1,1),frandom(-1,1),frandom(-1,1),0,SXF_TRANSFERSPRITEFRAME|SXF_TRANSFERSCALE);
            A_SpawnItemEx("AbyssalSavageDarkBallTrail",0,0,0,frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5),0,SXF_TRANSFERRENDERSTYLE);
            A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(8,16),frandom(4,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,0),0,frandom(0,3),0,0,-0.03,1,-1,-0.6);
        }
        Loop;
Death:
        TNT1 A 0
        {
            for(user_fx = 0; user_fx<=20; user_fx++)
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-0.75);
        }
        ABI1 CCCDDDEEEFFF 1 Bright
        {
            A_SpawnItemEx("AbyssalGhostProj",0,0,0,frandom(-1,1),frandom(-1,1),frandom(-1,1),0,SXF_TRANSFERSPRITEFRAME|SXF_TRANSFERSCALE);
            A_SetScale(Scale.X+0.08);
        }
        Stop;
    }
}
Class AbyssalSavageDarkBeamRPG :
AbyssalSavageDarkBeam replaces AbyssalSavageDarkBeam
{
    Default
    {
        DamageType "Shadow";
    }
}
Class AbyssalSavagePhaseBallRPG :
AbyssalSavagePhaseBall replaces AbyssalSavagePhaseBall
{
    Default
    {
        DamageType "Shadow";
    }
}
Class AbyssalSavageStrongBallRPG :
AbyssalSavageStrongBall replaces AbyssalSavageStrongBall //
{
    Default
    {
        DamageType "Shadow";
        DamageType "Fire";
    }

    States
    {
Spawn:
        ABI2 ABC 2 Bright
        {
            A_SpawnItemEx("BlueFireProjectileTrail2",frandom(-6,0),frandom(-6,6),frandom(-2,6),0,0,frandom(0,3),0,0,128);
            A_SpawnItemEx("AbyssalSavageBallTrail",0,0,0,frandom(-0.5,0.5),frandom(-0.5,0.5),frandom(-0.5,0.5));
            for(user_fx = 0; user_fx<2; user_fx++)
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(8,16),frandom(4,8),0,frandom(-6,0),frandom(-8,8),frandom(-8,8),frandom(-4,0),0,frandom(0,4),0,0,-0.03,1,-1,-0.6);
        }
        Loop;
Death:
        TNT1 A 0
        {
            A_Explode(40,100,0,0,60);
            A_SpawnItemEx("BlueBossDeathExplode");
            A_SpawnItemEx("BlueFireProjectileExplode");
            for(user_fx = 0; user_fx<=20; user_fx++)
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-0.75);
        }
        ABI2 DEFGH 2 Bright;
        Stop;
    }
}
Class AbyssalSavageFlareRPG :
AbyssalSavageFlare replaces AbyssalSavageFlare //
{
    Default
    {
        DamageType "Shadow";
        DamageType "Fire";
    }
    States
    {
Spawn:
        ABI3 AABB 2
        {
            A_ChangeVelocity(1,frandom(-3,3),frandom(-1,1),CVF_RELATIVE);
            A_SpawnItemEx("BlueFireProjectileTrail",frandom(-3,0),frandom(-3,3),frandom(-1,3),0,0,frandom(0,1.5),0,0,128);
            A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(8,16),frandom(4,8),0,frandom(-6,0),frandom(-3,3),frandom(-3,3),frandom(-2,0),0,frandom(0,3),0,0,-0.03,1,-1,-0.6);
        }
        Loop;
Death:
        TNT1 A 0
        {
            A_SpawnItemEx("BlueFireProjectileExplode");
            for(user_fx = 0; user_fx<=15; user_fx++)
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-0.75);
        }
        ABI3 CDEFG 3;
        Stop;
    }
}
Class AbyssalSavageDarkMeleeRPG :
AbyssalSavageDarkMelee replaces AbyssalSavageDarkMelee
{
    Default
    {
        DamageType "Shadow";
    }
}
Class AbyssalSavageMeleeRPG :
AbyssalSavageMelee replaces AbyssalSavageMelee
{
    Default
    {
        DamageType "Shadow";
        DamageType "Fire";
    }
}

Class ImpBorgRPG :
ImpBorg replaces ImpBorg {}
Class CyberDevilRPG :
CyberDevil replaces CyberDevil {}
Class DarkDevilRPG :
DarkDevil replaces DarkDevil {}
Class DarkScoundrelRPG :
DarkScoundrel replaces DarkScoundrel {}

//Pinkys
Class MagmaDemonRPG :
MagmaDemon replaces MagmaDemon {}
Class PandMaulerRPG :
PandMauler replaces PandMauler {}
Class MechDemonRPG :
MechDemon replaces MechDemon {}
Class NewDemonRPG :
NewDemon replaces NewDemon {}

Class BloodFiendRPG :
BloodFiend replaces BloodFiend
{
    Default
    {
        DamageType "Slime";
    }
}
Class BloodFiendBileDRPG :
BloodFiendBile replaces BloodFiendBile
{
    Default
    {
        DamageType "Slime";
    }
}

Class ChaosFlayerRPG :
ChaosFlayer replaces ChaosFlayer
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}
Class ChaosFlayerProjectileDRPG :
ChaosFlayerProjectile replaces ChaosFlayerProjectile
{
    Default
    {
        DamageType "Radiation";
    }
}

Class AbyssalBerserkerRPG :
AbyssalBerserker replaces AbyssalBerserker
{
    Default
    {
        DamageType "Shadow";
        DamageFactor "Shadow", 0.8;
    }
}

Class DespicableRPG :
Despicable replaces Despicable {}

Class PlagueFiendRPG :
PlagueFiend replaces PlagueFiend 
{
    Default
    {
		DamageType "Slime";
    }
}

//Spectres
Class DarkbeastRPG :
Darkbeast replaces Darkbeast {}
Class DelusionRPG :
Delusion replaces Delusion {}
Class NightmareDemonRPG :
NightmareDemon replaces NightmareDemon {}
Class NewSpectreRPG :
NewSpectre replaces NewSpectre {}
Class WretchRPG :
Wretch replaces Wretch {}
Class FacelessRPG :
Faceless replaces Faceless {}

Class TriteRPG :
Trite replaces Trite 
{
    Default
    {
		DamageType "Slime";
		DamageFactor "Slime", 0.5;
    }
}

Class ChaosOphydianRPG :
ChaosOphydian replaces ChaosOphydian
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}
Class OphydianHomingFluxDRPG :
OphydianHomingFlux replaces OphydianHomingFlux
{
    Default
    {
        DamageType "Radiation";
    }
}

//Lost Souls
Class NewLostSoulRPG :
NewLostSoul replaces NewLostSoul
{
    States
    {
Spawn:
        TNT1 A 0
        {
            A_SpawnItemEx("LostSoulFireSpawner",0,0,0,0,0,0,0,SXF_SETMASTER);
            soul_firespawned = 1;
        }
Idle:
        SKUL AB 2 A_Look();
        Goto Super::Idle;
See:
        SKUL AB 2 A_Chase();
        Goto Super::See;
    }
}

Class PhantasmRPG :
Phantasm replaces Phantasm
{
    States
    {
Spawn:
        TNT1 A 0
        {
            A_SpawnItemEx("PhantasmFireSpawner",0,0,0,0,0,0,0,SXF_SETMASTER);
            soul_firespawned = 1;
        }
Idle:
        PHNT AB 2 A_Look;
        Loop;
See:
        PHNT AB 2 A_Chase();
        Loop;
    }
}

Class SoullessDroneRPG :
SoullessDrone replaces SoullessDrone
{
    States
    {
Spawn:
        TNT1 A 0
        {
            A_SpawnItemEx("SoullessDroneEffectSpawner",0,0,0,0,0,0,0,SXF_SETMASTER);
            soul_firespawned = 1;
        }
Idle:
        DRON A 2 A_Look;
        Loop;
See:
        DRON A 2 A_Chase();
        Loop;
    }
}

Class PandWraithRPG :
PandWraith replaces PandWraith
{
    States
    {
Spawn:
        TNT1 A 0
        {
            A_SpawnItemEx("WraithEffectSpawner",0,0,0,0,0,0,0,SXF_SETMASTER);
            soul_firespawned = 1;
        }
Idle:
        WRTH ABCD 2 A_Look;
        Loop;
See:
        WRTH ABCD 2
        {
            A_Chase();
            if(A_Jump(2,"Null"))
            {
                return ResolveState("GoPhase");
            }
            return ResolveState(null);
        }
        Loop;
    }
}

Class ChaosUmbraRPG :
ChaosUmbra replaces ChaosUmbra
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.2;
    }
    States
    {
Idle:
        CHMB A 2 A_Look();
        Loop;
See:
        TNT1 A 0 A_WeaveInit();
        CHMB A 2 A_UmbraChase();
        Wait;
Dash:
        TNT1 A 0
        {
            bNOPAIN = true;
            ThrustThing(Angle*256/360+randompick(64,192),16,0,0);
        }
        CHMB AAAAAAAAAAAAAAA 1 A_SpawnItemEx("GenericPhaseGhost",0,0,0,0,0,0,0,SXF_TRANSFERSCALE|SXF_TRANSFERSTENCILCOL|SXF_TRANSFERSPRITEFRAME);
        TNT1 A 0
        {
            bNOPAIN = false;
            A_Stop();
        }
        Goto See;
    }
}

Class ElectrosoulRPG :
Electrosoul replaces Electrosoul
{
    States
    {
Spawn:
        TNT1 A 0
        {
            A_SpawnItemEx("ElectrosoulEffectSpawner",0,0,0,0,0,0,0,SXF_SETMASTER);
            soul_firespawned = 1;
        }
Idle:
        ELSL A 2 A_Look;
        Loop;
See:
        ELSL A 2 A_Chase();
        Loop;
    }
}

Class CacophyteRPG :
Cacophyte replaces Cacophyte {}
Class NetherlingRPG :
Netherling replaces Netherling {}

//Revevants
Class DarkRevenantRPG :
DarkRevenant replaces DarkRevenant {}
Class MissileRevenantRPG :
MissileRevenant replaces MissileRevenant {}
Class NewRevenantRPG :
NewRevenant replaces NewRevenant {}
Class ApollyonRPG :
Apollyon replaces Apollyon {}

Class PestilenceRPG :
Pestilence replaces Pestilence
{
    Default
    {
        DamageType "Slime";
        DamageFactor "Slime", 0.3;
    }
}

Class PandSentinelRPG :
PandSentinel replaces PandSentinel
{
    Default
    {
        DropItem "DRPGShellSpawner", 128;
        DropItem "DRPGRocketAmmoSpawner", 128;
    }
}

Class SentryRPG :
Sentry replaces Sentry
{
    Default
    {
        DropItem "DRPGShellSpawner";
    }
}

Class ChaosHollowRPG :
ChaosHollow replaces ChaosHollow
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
        DamageFactor "Radiation", 0.3;
    }
}
Class HollowBallDRPG :
HollowBall replaces HollowBall
{
    Default
    {
        DamageType "Radiation";
    }
}
Class HollowSkullBallDRPG :
HollowSkullBall replaces HollowSkullBall
{
    Default
    {
        DamageType "Radiation";
    }
}

Class AncientGladiatorRPG :
AncientGladiator replaces AncientGladiator
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;

    }
}
Class DropsAncientGladiatorRPG :
DropsAncientGladiator replaces DropsAncientGladiator
{
    Default
    {
        DropItem "DRPGHealthDropper", 256, 1;
        DropItem "DRPGBlueArmorRandomizer", 265, 5;
    }
}
Class GladiatorFireMissileDRPG :
GladiatorFireMissile replaces GladiatorFireMissile
{
    Default
    {
        DamageType "Fire";
    }
}

//Cacos
Class AgathodemonRPG :
Agathodemon replaces Agathodemon {}
Class AbaddonRPG :
Abaddon replaces Abaddon {}

Class CacobotRPG :
Cacobot replaces Cacobot
{
    Default
    {
        DropItem "DRPGCellSpawner";
        DropItem "DRPGCellSpawner", 32;
    }
}

Class NewCacodemonRPG :
NewCacodemon replaces NewCacodemon {}
Class CrackodemonRPG :
Crackodemon replaces Crackodemon {}
Class DarkCacodemonRPG :
DarkCacodemon replaces DarkCacodemon {}

Class CacodemonBall2DRPG1 :
PandProjectile
{
    Default
    {
        Radius 6;
        Height 8;
        Speed 15;
        FastSpeed 30;
        DamageFunction 20;
        Damagetype "Electric";
        Renderstyle "Add";
        PandProjectile.ParticleColors "FFD7BB", "FFA35B", "FF3F3F", "9F009B";
        SeeSound "Cacodemon/Ball";
        DeathSound "Cacodemon/BExplode";
        Decal "CacoScorch";
    }

    States
    {
Spawn:
        BAL2 AABB 2 Bright
        {
            A_SpawnItemEx("LightningProjectileTrail",frandom(-3,3),frandom(-3,3),frandom(-3,3),frandom(-2,2),frandom(-1,1),frandom(-1,1));
            A_SpawnItemEx("RedPlasmaLightningTrail",0,0,0,0,0,0,0,0,192);
            for(user_fx = 0; user_fx<=3; user_fx++)
            {
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(7,15),frandom(6,8),0,frandom(-6,0),frandom(-6,6),frandom(-6,6),frandom(-2,2),frandom(-1,1),frandom(-1,1),0,0,0,1,-1,-1);
            }
        }
        Loop;
Death:
        TNT1 A 0
        {
            A_SpawnItemEx("LightningProjectileExplode");
            for(user_fx = 0; user_fx<=30; user_fx++)
            {
                A_SpawnParticle(GetParticleColor(),SPF_FULLBRIGHT|SPF_RELATIVE,random(10,17),frandom(12,14),random(0,360),frandom(0,6),0,frandom(-6,6),frandom(0,6),0,frandom(-6,6),0,0,0,1,-1,-1.2);
            }
        }
        BAL2 CDE 4 Bright;
        Stop;
    }
}
Class CacobotBallDRPG :
CacodemonBall2DRPG1 replaces CacobotBall {}

Class WitherdemonRPG :
Witherdemon replaces Witherdemon
{
    Default
    {
        DamageType "Slime";
    }
}
Class WitherdemonBallDRPG :
WitherdemonBall replaces WitherdemonBall
{
    Default
    {
        DamageType "Slime";
    }
}

Class WitherdemonEyeProjectileDRPG :
WitherdemonBallDRPG replaces WitherdemonEyeProjectile {}
Class WitherdemonEyeProjectile2DRPG :
WitherdemonEyeProjectileDRPG replaces WitherdemonEyeProjectile2 {}
Class WitherdemonCometDRPG :
PlaguelingPoisonPodDRPG replaces WitherdemonComet {}

Class ChaosStalkerRPG :
ChaosStalker replaces ChaosStalker
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}

Class NethersystRPG :
Nethersyst replaces Nethersyst {}

Class SlomnibusRPG :
Slomnibus replaces Slomnibus {}

Class HadesRavagerRPG :
HadesRavager replaces HadesRavager
{
    Default
    {
        DamageFactor "Radiation", 0.8;
    }
}

Class AbyssalNecrodemonRPG : AbyssalNecrodemon replaces AbyssalNecrodemon
{
 Default
  {
  DamageFactor "Shadow", 0.6;
  }
}

//Arachnotrons
Class ArachknightRPG :
Arachknight replaces Arachknight
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
    }
}

Class NewArachnotronRPG :
NewArachnotron replaces NewArachnotron {}
Class ArachnoscorcherRPG :
Arachnoscorcher replaces Arachnoscorcher {}
Class DarkArachnotronRPG :
DarkArachnotron replaces DarkArachnotron {}

Class DefilerRPG :
Defiler replaces Defiler
{
    Default
    {
        DamageType "Slime";
		DamageFactor "Slime", 0.5;
    }
}

Class AugmentedArachnotronRPG :
AugmentedArachnotron replaces AugmentedArachnotron
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
    }
}

Class NailgunArachnotronRPG :
NailgunArachnotron replaces NailgunArachnotron
{
    Default
    {
        DropItem "DRPGClipSpawner", 128;
    }
}

Class WidowRPG :
Widow replaces Widow
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
    }
}

Class ChaosObserverRPG :
ChaosObserver replaces ChaosObserver
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}
Class ObserverFluxDRPG :
ObserverFlux replaces ObserverFlux
{
    Default
    {
        DamageType "Radiation";
    }
}

Class DemolitronRPG :
Demolitron replaces Demolitron
{
    Default
    {
        DropItem "DRPGCellSpawner", 255;
        DropItem "DRPGClipSpawner", 180;
    }
}

//PainElementals
Class HadesElementalRPG :
HadesElemental replaces HadesElemental {}
Class NewPainElementalRPG :
NewPainElemental replaces NewPainElemental {}
Class PlasmaticElementalRPG :
PlasmaticElemental replaces PlasmaticElemental {}
Class GenodemonRPG :
Genodemon replaces Genodemon {}

Class ChaosBeholderRPG :
ChaosBeholder replaces ChaosBeholder
{
    Default
    {
        DropItem "DRPGCellSpawner", 128;
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}
Class BeholderHomingBallDRPG :
ChaosWarriorProjectileDRPG replaces BeholderHomingBall {}
Class BeholderMegaBallDRPG :
BeholderMegaBall replaces BeholderMegaBall
{
    Default
    {
        DamageType "Radiation";
    }
}
Class BeholderStormBoltDRPG :
BeholderStormBolt replaces BeholderStormBolt
{
    Default
    {
        DamageType "Radiation";
    }
}

Class DarkElementalRPG :
DarkElemental replaces DarkElemental
{
    Default
    {
        DamageType "Slime";
    }
}
Class DarkElementalBileDRPG :
BloodFiendBileDRPG replaces DarkElementalBile {}

Class HadesBallDRPG :
CacodemonBall2DRPG1 replaces HadesBall {}
Class HadesBoltDRPG :
HadesBallDRPG replaces HadesBolt {}
Class HadesBoltSmallDRPG :
HadesBallDRPG replaces HadesBoltSmall {}
Class HadesSphereDRPG :
HadesSphere replaces HadesSphere
{
    Default
    {
        Damagetype "Electric";
    }
}

Class AutomatonElementalRPG :
AutomatonElemental replaces AutomatonElemental
{
    Default
    {
        DropItem "DRPGCellSpawner", 180;
    }
}
Class AutomatonElementalBombDRPG :
AutomatonElementalBomb replaces AutomatonElementalBomb
{
    Default
    {
        DamageType "Fire";
    }
}

//Mancubuses
Class CorpulentRPG :
Corpulent replaces Corpulent
{
    Default
    {
        DropItem "DRPGCellSpawner";
    }
}

Class HectebusRPG :
Hectebus replaces Hectebus {}
Class MafibusRPG :
Mafibus replaces Mafibus {}
Class MancubusRPG :
Mancubus replaces Mancubus {}
Class MaxibusRPG :
Maxibus replaces Maxibus {}

Class TankubusRPG :
Tankubus replaces Tankubus {}

Class ChaosPylonRPG :
ChaosPylon replaces ChaosPylon
{
    Default
    {
        DropItem "DRPGCellSpawner", 200;
        DamageFactor "Radiation", 0.3;
    }
}

//Knights
Class CyberHellKnightRPG :
CyberHellKnight replaces CyberHellKnight
{
    Default
    {
        DropItem "DRPGRocketAmmoSpawner";
    }
}

Class CyberHellViscountRPG :
CyberHellViscount replaces CyberHellViscount
{
    Default
    {
        DropItem "DRPGPlasmaRifle", 32;
        DropItem "DRPGCellPackSpawner", 224;
    }
}

Class NewHellKnightRPG :
NewHellKnight replaces NewHellKnight {}
Class HellViscountRPG :
HellViscount replaces HellViscount {}
Class HellWardenRPG :
HellWarden replaces HellWarden {}
Class InfernobleRPG :
Infernoble replaces Infernoble {}
Class LesserCardinalRPG :
LesserCardinal replaces LesserCardinal {}

Class AbyssalIfritRPG :
AbyssalIfrit replaces AbyssalIfrit
{
    Default
    {
        DamageType "Shadow";
		DamageFactor "Shadow", 0.5;
    }
}

Class HellPrinceAschRPG :
HellPrinceAsch replaces HellPrinceAsch
{
    Default
    {
        DamageFactor "Radiation", 0.5;
    }
}

Class DropsHellPrinceRPG :
DropsHellPrince replaces DropsHellPrince
{
    Default
    {
        DropItem "DRPGHealthDropper", 256, 1;
        DropItem "DRPGBlueArmorRandomizer", 256, 1;
    }
}

//Barons
Class AfritRPG :
Afrit replaces Afrit {}
Class ArchonOfHellRPG :
ArchonOfHell replaces ArchonOfHell {}
Class NewBaronOfHellRPG :
NewBaronOfHell replaces NewBaronOfHell {}
Class BruiserDemonRPG :
BruiserDemon replaces BruiserDemon {}

Class CyberBaronRPG :
CyberBaron replaces CyberBaron
{
    Default
    {
        DropItem "DRPGRocketAmmoSpawner", 128, 1;
		DropItem "DRPGRocketAmmoSpawner", 128, 1;
		DropItem "DRPGRocketAmmoSpawner", 128, 1;
    }
}

Class CyberwardenRPG :
Cyberwarden replaces Cyberwarden
{
    Default
    {
        DropItem "DRPGRocketLauncher", 32;
        DropItem "DRPGRocketAmmoSpawner", 192;
        DropItem "DRPGRocketBoxSpawner", 32;
    }
}

Class CybruiserRPG :
Cybruiser replaces Cybruiser
{
    Default
    {
        DropItem "DRPGRocketLauncher", 32;
        DropItem "DRPGRocketAmmoSpawner", 224;
    }
}

Class DarkCybruiserRPG :
DarkCybruiser replaces DarkCybruiser
{
    Default
    {
        DropItem "DRPGPlasmaRifle", 32;
        DropItem "DRPGCellSpawner", 192;
        DropItem "DRPGCellPackSpawner", 32;
    }
}

Class PyrobruiserRPG :
Pyrobruiser replaces Pyrobruiser
{
    Default
    {
        DropItem "DRPGRocketLauncher", 32;
        DropItem "DRPGRocketAmmoSpawner", 192;
        DropItem "DRPGRocketBoxSpawner", 32;
    }
}

Class CydestructorRPG :
Cydestructor replaces Cydestructor
{
    Default
    {
        DropItem "DRPGRocketLauncher", 32;
        DropItem "DRPGRocketAmmoSpawner", 192;
        DropItem "DRPGRocketBoxSpawner", 32;
        DropItem "DRPGBlueArmorRandomizer", 128;
    }
}

Class HecticBossRPG : HecticBoss replaces HecticBoss
{
 Default
  {
  DamageFactor "Shadow", 0.8;
  }
}

Class FearBossRPG : FearBoss replaces FearBoss
{
 Default
  {
  DamageFactor "Shadow", 0.8;
  }
}

Class AbyssalDesecratorRPG : AbyssalDesecrator replaces AbyssalDesecrator
{
 Default
  {
  DamageFactor "Shadow", 0.6;
  }
}

//Viles
Class NewArchvileRPG :
NewArchvile replaces NewArchvile {}
Class DarkVileRPG :
DarkVile replaces DarkVile {}
Class DiabolistRPG :
Diabolist replaces Diabolist {}
Class DistortionistRPG :
Distortionist replaces Distortionist
{
    Default
    {
        DropItem "DRPGCellSpawner";
    }
}

Class IllusionistRPG :
Illusionist replaces Illusionist {}

Class InfernalistRPG :
Infernalist replaces Infernalist
{
    Default
    {
        DropItem "DRPGCellSpawner";
    }
}

Class MachinaRPG :
Machina replaces Machina {}

Class PulsedemonRPG :
Pulsedemon replaces Pulsedemon
{
 Default
  {
  DamageFactor "Shadow", 0.4;
  }
}

Class CryptekRPG :
Cryptek replaces Cryptek
{
    Default
    {
        DropItem "DRPGCellSpawner";
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}
Class CryptekEnergyBallDRPG :
CryptekEnergyBall replaces CryptekEnergyBall
{
    Default
    {
        DamageType "Radiation";
    }
}
Class CryptekBigEnergyBallDRPG :
CryptekEnergyBallDRPG replaces CryptekBigEnergyBall {}
Class CryptekElectricFieldDRPG :
CryptekElectricField replaces CryptekElectricField
{
    Default
    {
        DamageType "Radiation";
    }
}

//Patch
Class Epic2AlienRPG :
Epic2Alien replaces Epic2Alien
{
    Default
    {
        DropItem "DRPGClipSpawner";
    }
}

Class Scythe2AfritRPG :
Scythe2Afrit replaces Scythe2Afrit {}
Class Scythe2MarineRPG :
Scythe2Marine replaces Scythe2Marine
{
    Default
    {
        DropItem "DRPGCellSpawner";
    }
}

Class NDCP2GuyRPG :
NDCP2Guy replaces NDCP2Guy {}

//Cybies
Class AnnihilatorRPG :
Annihilator replaces Annihilator
{
    Default
    {
        DropItem "DRPGRocketBoxSpawner";
        DropItem "DRPGRocketBoxSpawner", 32;
    }
}

Class NewCyberdemonRPG :
NewCyberdemon replaces NewCyberdemon {}
//Class HellfireAvatarRPG : HellfireAvatar replaces HellfireAvatar {} //Not implemented

Class DarkCardinalRPG :
DarkCardinal replaces DarkCardinal
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGCellPackSpawner", 32;
    }
}

Class DarkCyberdemonRPG :
DarkCyberdemon replaces DarkCyberdemon
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGCellPackSpawner", 32;
    }
}

Class EradicatorRPG :
Eradicator replaces Eradicator
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGCellPackSpawner", 32;
    }
}

Class PlamexisRPG :
Plamexis replaces Plamexis
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGCellPackSpawner", 32;
    }
}

Class TerminatorRPG :
Terminator replaces Terminator
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGCellPackSpawner", 32;
    }
}

Class DreamweaverRPG :
Dreamweaver replaces Dreamweaver //I dreamt about a fucking blue Terminator, one year later and it's in Pandemonia now
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGCellPackSpawner", 32;
        DamageFactor "Fire", 1.5;
    }
}

Class ChaosEcclesiarchRPG :
ChaosEcclesiarch replaces ChaosEcclesiarch
{
    Default
    {
        DropItem "DRPGCellPackSpawner", 256, 100;
        DropItem "DRPGCellSpawner", 128, 20;
        DropItem "DRPGBFG9000Spawner", 256;
        DropItem "DRPGSoulSphereRandomizer", 200;
        DamageFactor "Radiation", 0.3;
        DamageFactor "Fire", 0.8;
        DamageType "Radiation";
    }
}

Class HellfireAvatarRPG :
HellfireAvatar replaces HellfireAvatar {}

Class PandHeresiarchRPG :
PandHeresiarch replaces PandHeresiarch {}

Class HunterCyberdemonRPG :
HunterCyberdemon replaces HunterCyberdemon {}

//Masterminds
Class ArachnophyteRPG :
Arachnophyte replaces Arachnophyte
{
    Default
    {
        DropItem "DRPGClipBoxSpawner", 128;
        DropItem "DRPGCellPackSpawner", 128;
    }
}

Class DemolisherRPG :
Demolisher replaces Demolisher
{
    Default
    {
        DropItem "DRPGCellPackSpawner", 128;
    }
}

Class NewSpiderMastermindRPG :
NewSpiderMastermind replaces NewSpiderMastermind {}
Class SpiderMastersparkRPG :
SpiderMasterspark replaces SpiderMasterspark
{
    Default
    {
        DropItem "DRPGCellPackSpawner", 128;
    }
}

Class DarkMastermindRPG :
DarkMastermind replaces DarkMastermind
{
    Default
    {
        DropItem "DRPGCellPackSpawner", 200;
    }
}

Class ConflagratorRPG :
Conflagrator replaces Conflagrator {}

Class CerebralWarMachineRPG :
CerebralWarMachine replaces CerebralWarMachine {}

Class SacrosanctOverseerRPG :
SacrosanctOverseer replaces SacrosanctOverseer
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.2;
    }
}

Class ChaosMonolithRPG :
ChaosMonolith replaces ChaosMonolith
{
    Default
    {
        DropItem "DRPGCellPackSpawner";
        DropItem "DRPGBFG9000Spawner", 256;
        DropItem "DRPGSoulSphereRandomizer", 100;
        DamageType "Radiation";
        DamageFactor "Radiation", 0.3;
    }
}
Class MonolithHomingBFGDRPG :
MonolithHomingBFG replaces MonolithHomingBFG
{
    Default
    {
        DamageType "Radiation";
    }
}
Class MonolithHomingBFG2DRPG :
MonolithHomingBFGDRPG replaces MonolithHomingBFG2 {}
Class MonolithFluxBallDRPG :
MonolithFluxBall replaces MonolithFluxBall
{
    Default
    {
        DamageType "Radiation";
    }
}
Class MonolithHomingFluxDRPG :
MonolithFluxBallDRPG replaces MonolithHomingFlux {}

Class MonolithDeployerRPG :
MonolithDeployer replaces MonolithDeployer
{
    actor a;
    int spawnchance;
    States
    {
Spawn:
        TNT1 A 1 NoDelay
        {
            A_Warp(AAPTR_DEFAULT,0,0,-1000);
            A_SpawnItemEx("MonolithDeployerEffectSpawner");
            A_StartSound("Monolith/Spawn",1);
            MonolithEnemySpawn();
        }
        Stop;
    }
    void MonolithEnemySpawn()
    {
        spawnchance = random(1,55);
        if(spawnchance <= 10)
        {
            for(int i = 0; i<4; i++)
                SpawnChaosEnemy("ChaosWarriorRPG",1);
        }
        else if(spawnchance <= 20)
        {
            for(int i = 0; i<3; i++)
                SpawnChaosEnemy("ChaosImpRPG",1);
        }
        else if(spawnchance <= 30)
        {
            for(int i = 0; i<3; i++)
                SpawnChaosEnemy("ChaosDeathmarkRPG",1);
        }
        else if(spawnchance <= 35)
        {
            for(int i = 0; i<2; i++)
                SpawnChaosEnemy("ChaosFlayerRPG",1);
        }
        else if(spawnchance <= 40)
        {
            for(int i = 0; i<2; i++)
                SpawnChaosEnemy("ChaosOphydianRPG",1);
        }
        else if(spawnchance <= 45)
        {
            for(int i = 0; i<2; i++)
                SpawnChaosEnemy("ChaosHollowRPG",1);
        }
        else if(spawnchance <= 49)
            SpawnChaosEnemy("ChaosStalkerRPG");
        else if(spawnchance <= 51)
            SpawnChaosEnemy("ChaosPylonRPG");
        else if(spawnchance <= 53)
            SpawnChaosEnemy("ChaosObserverRPG");
        else if(spawnchance <= 54)
            SpawnChaosEnemy("ChaosBeholderRPG");
        else if(spawnchance <= 55)
            SpawnChaosEnemy("CryptekRPG");
    }
  void SpawnChaosEnemy(name enemy, bool shouldthrust = 0)
	{
	a = Spawn(enemy,self.pos);
	if(PandMonster(a)) PandMonster(a).bNOAUGMENTS = true;
	a.A_SetAngle(random(0,360));
	if(shouldthrust)
		a.Thrust(random(2,6),a.angle);
	a.master = master;
	a.Species = "Chaos";
	a.ClearCounters();
	master.GiveInventory("MonolithSpawnCount",1);
	}
}

Class MonolithEnemySpawnerRPG :
MonolithEnemySpawner replaces MonolithEnemySpawner
{
    Default
    {
        DropItem "ChaosWarriorRPG", 256, 10;
        DropItem "ChaosDeathmarkRPG", 256, 10;
        DropItem "ChaosImpRPG", 256, 10;
        DropItem "ChaosHollowRPG", 256, 5;
        DropItem "ChaosObserverRPG", 256, 3;
        DropItem "ChaosBeholderRPG", 256, 1;
        DropItem "CryptekRPG", 256, 1;
    }
}

//SpecialsBosses

Class MyrkuraDRPG :
Myrkura replaces Myrkura {}
Class GeneralRoasterockRPG :
GeneralRoasterock replaces GeneralRoasterock {}

Class RedEvangelistRPG :
RedEvangelist replaces RedEvangelist {}
Class YellowEvangelistRPG :
YellowEvangelist replaces YellowEvangelist {}
Class BlueEvangelistRPG :
BlueEvangelist replaces BlueEvangelist {}


//RandomSpawner of the Chaos event i think
Class ChaosRandomSpawnerRPG :
ChaosRandomSpawner replaces ChaosRandomSpawner
{
    override void PostSpawn(Actor spawned)
    {
        if(spawned && spawned is "PandMonster")
        {
            let spawnspec = PandMonster(spawned).spec2;
            if(spawned.Health <= 300 && spawnspec == "Chaos")
            {
                for(int i = 0; i<2; i++)
                    SpawnChaosEnemy(spawned.GetClassName(),1);
            }
            else if(spawned.Health < 1000 && spawnspec == "Chaos")
            {
                SpawnChaosEnemy(spawned.GetClassName(),1);
            }
            else if(spawned.Health >= 1000 && random(1,4) == 1 && spawnspec == "Chaos")
            {
                MonolithEnemySpawn();
            }
        }
    }

    void MonolithEnemySpawn()
    {
        int spawnchance = random(1,50);
        if(spawnchance <= 10)
        {
            for(int i = 0; i<4; i++)
                SpawnChaosEnemy("ChaosWarriorRPG",1);
        }
        else if(spawnchance <= 20)
        {
            for(int i = 0; i<3; i++)
                SpawnChaosEnemy("ChaosImpRPG",1);
        }
        else if(spawnchance <= 30)
        {
            for(int i = 0; i<3; i++)
                SpawnChaosEnemy("ChaosDeathmarkRPG",1);
        }
        else if(spawnchance <= 35)
        {
            for(int i = 0; i<2; i++)
                SpawnChaosEnemy("ChaosFlayerRPG",1);
        }
        else if(spawnchance <= 40)
        {
            for(int i = 0; i<2; i++)
                SpawnChaosEnemy("ChaosOphydianRPG",1);
        }
        else if(spawnchance <= 45)
        {
            for(int i = 0; i<2; i++)
                SpawnChaosEnemy("ChaosHollowRPG",1);
        }
        else if(spawnchance <= 49)
            SpawnChaosEnemy("ChaosStalkerRPG");
        else if(spawnchance <= 51)
            SpawnChaosEnemy("ChaosPylonRPG");
        else if(spawnchance <= 53)
            SpawnChaosEnemy("ChaosObserverRPG");
        else if(spawnchance <= 54)
            SpawnChaosEnemy("ChaosBeholderRPG");
        else if(spawnchance <= 55)
            SpawnChaosEnemy("CryptekRPG");
    }

    void SpawnChaosEnemy(name enemy, bool shouldthrust = 0)
    {
        let a = Spawn(enemy,self.pos);
        a.A_SetAngle(random(0,360));
        if(shouldthrust)
            a.Thrust(random(2,6),a.angle);
    }
}

//Nassis replacer
Class ChaosCultistRPG :
ChaosCultist replaces ChaosCultist
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.5;
    }
}

Class ChaosAcolyteRPG :
ChaosAcolyte replaces ChaosAcolyte
{
    Default
    {
        DamageType "Radiation";
        DamageFactor "Radiation", 0.5;
    }
}

// Calling the ACS MonsterInit script for monsters
class Pandemonia_MonsterInit : EventHandler
{
    override void WorldThingSpawned(WorldEvent e)
    {
        if (e.Thing && e.Thing.bIsMonster)
        {
            static const string PandemoniaMonsters[] =
            {
                "PistolZombieRPG", "PlasmaPistolZombieRPG", "LaserRifleZombieRPG", 											//Zombies
                "CinderZombieRPG", "SpecOpsRiflemanRPG", "SeraphRPG",
				"PistolBorgRPG", "PelterRPG", "LaserBorgRPG",

                "AutoShotgunZombieRPG", "ChaosWarriorRPG", "RocketZombieRPG", "ShotgunAdmiralRPG", 							//Shotgunners
                "NewShotgunguyRPG",	"SlugShotgunZombieRPG", "SpecOpsShotgunnerRPG", "SuperShotgunZombieRPG",
                "PyroZombieRPG", "AbyssalCultLeaderRPG", "OppressorRPG",
				"AssailantRPG", "BlasterborgRPG", "ShotgunBorgRPG",

                "AssaultGunnerRPG", "BFG10kWarriorRPG", "BFGCommandoRPG", "ChaingunZombieRPG", 								//Commandos
                "ChaosDeathmarkRPG", "NailborgCommandoRPG", "PlasmaRifleZombieRPG", "SpecOpsGunnerRPG",
                "SpecOpsLieutenantRPG", "ScourgeZombieRPG", "InfernalCommandoRPG", "BlazegunnerRPG",
				"ElectroborgRPG", "NailborgRPG", "NailborgAdmiralRPG",
				"DreadDivision_BreacherRPG", "DreadDivision_EnforcerRPG", "DreadDivision_MarksmanRPG",
				"DreadDivision_PatrolRPG", "DreadDivision_JuggernautRPG",

                "ChaosImpRPG",	"DarkImpRPG", "DevilRPG", "CyberImpRPG", "NewImpRPG", "PhaseImpRPG", 						//Imps
                "PlaguelingRPG", "ScoundrelRPG", "BrimstoneImpRPG", "AbyssalSavageRPG",
				"ImpBorgRPG", "CyberDevilRPG", "DarkDevilRPG", "DarkScoundrelRPG",

                "BloodFiendRPG", "ChaosFlayerRPG", "MagmaDemonRPG", "PandMaulerRPG", "MechDemonRPG", 						//Pinkys
                "NewDemonRPG", "AbyssalBerserkerRPG", "DespicableRPG", "PlagueFiendRPG",

                "ChaosOphydianRPG", "DarkbeastRPG", "DelusionRPG", "NightmareDemonRPG",	"NewSpectreRPG", 					//Spectres
                "WretchRPG", "FacelessRPG", "TriteRPG",

                "ChaosHollowRPG", "DarkRevenantRPG", "MissileRevenantRPG", "NewRevenantRPG", "PandSentinelRPG",				//Revevants
                "SentryRPG", "ApollyonRPG", "AncientGladiatorRPG", "PestilenceRPG",

                "AgathodemonRPG", "CacobotRPG", "NewCacodemonRPG", "CrackodemonRPG", "DarkCacodemonRPG",					//Cacodemons
                "WitherdemonRPG", "AbaddonRPG", "ChaosStalkerRPG", "NethersystRPG", "HadesRavagerRPG",
				"SlomnibusRPG", "AbyssalNecrodemonRPG",

                "ArachknightRPG", "NewArachnotronRPG", "AugmentedArachnotronRPG", "ChaosObserverRPG", 						//Arachnotrons
                "NailgunArachnotronRPG", "WidowRPG", "ArachnoscorcherRPG", "DarkArachnotronRPG",
                "DemolitronRPG", "DefilerRPG",

                "ChaosBeholderRPG", "DarkElementalRPG", "HadesElementalRPG", "NewPainElementalRPG", 						//Pain Elementals
                "PlasmaticElementalRPG", "AutomatonElementalRPG", "GenodemonRPG",

                "CorpulentRPG", "HectebusRPG", "MafibusRPG", "MancubusRPG", "MaxibusRPG", "TankubusRPG", 					//Mancubuses
                "ChaosPylonRPG",

                "CyberHellKnightRPG", "CyberHellViscountRPG", "NewHellKnightRPG", "HellViscountRPG", 						//Knights
                "HellWardenRPG", "InfernobleRPG", "LesserCardinalRPG", "HellPrinceAschRPG",
				"AbyssalIfritRPG",

                "AfritRPG", "ArchonOfHellRPG", "NewBaronOfHellRPG", "BruiserDemonRPG", "CyberwardenRPG", 					//Barons
                "CybruiserRPG",	"DarkCybruiserRPG", "PyrobruiserRPG", "CydestructorRPG", "HecticBossRPG",
				"FearBossRPG", "CyberBaronRPG", "AbyssalDesecratorRPG",

                "NewArchvileRPG", "CryptekRPG", "DarkVileRPG", "DiabolistRPG", "DistortionistRPG", 							//Arch-Viles
                "Illusionist", "InfernalistRPG", "MachinaRPG", "PulsedemonRPG",

                "ChaosCultistRPG", "ChaosAcolyteRPG",																		//Nazi

                "Epic2AlienRPG", "Scythe2AfritRPG", "Scythe2MarineRPG", "NDCP2Guy"											//Patch
            };

            static const string PandemoniaBosses[] =
            {
                "AnnihilatorRPG", "NewCyberdemonRPG", "DarkCardinalRPG", "DarkCyberdemonRPG", "DreamweaverRPG",				//Cyberdemons
                "EradicatorRPG", "PlamexisRPG", "TerminatorRPG", "ChaosEcclesiarchRPG", "HellfireAvatarRPG",
				"PandHeresiarchRPG", "HunterCyberdemonRPG",

                "ArachnophyteRPG", "ChaosMonolithRPG", "DemolisherRPG", "NewSpiderMastermindRPG", 							//Masterminds
                "SpiderMastersparkRPG",	"DarkMastermindRPG", "ConflagratorRPG", "SacrosanctOverseerRPG",
				"CerebralWarMachineRPG",

                "MyrkuraRPG", "GeneralRoasterockRPG", "RedEvangelistRPG", "YellowEvangelistRPG", "BlueEvangelistRPG"		//Special Bosses
            };

            static const string PandemoniaOtherThings[] =
            {
                "SayoriRPG" 																								//Other Things
            };

            static const string PandemoniaLostSouls[] =
            {
                "NewLostSoulRPG",																							//Lost Souls
                "PhantasmRPG",
                "SoullessDroneRPG",
                "PandWraithRPG",
                "ChaosUmbraRPG",
                "ElectrosoulRPG",
				"CacophyteRPG",
				"NetherlingRPG"
            };

            for (int i = 0; i < PandemoniaMonsters.size(); i++)
            {
                if (e.Thing.GetClassName() == PandemoniaMonsters[i])
                {
                    if (e.Thing.master is "ChaosMonolithRPG")
                        e.Thing.ACS_ScriptCall("MonsterInit", MF_NOXP | MF_NOAURA | MF_NODROPS);
                    else
                        e.Thing.ACS_ScriptCall("MonsterInit", 0);
                }
            }

            for (int i = 0; i < PandemoniaBosses.size(); i++)
                if (e.Thing.GetClassName() == PandemoniaBosses[i])
                    e.Thing.ACS_ScriptCall("MonsterInit", MF_BOSS);

            for (int i = 0; i < PandemoniaOtherThings.size(); i++)
                if (e.Thing.GetClassName() == PandemoniaOtherThings[i])
                    e.Thing.ACS_ScriptCall("MonsterInit", MF_NOXP | MF_NOAURA | MF_NODROPS);

            for (int i = 0; i < PandemoniaLostSouls.size(); i++)
                if (e.Thing.GetClassName() == PandemoniaLostSouls[i])
                    if (e.Thing.GetLevelSpawnTime() == 0)
                        e.Thing.ACS_ScriptCall("MonsterInit", MF_NOAURA | MF_NODROPS);
                    else
                        e.Thing.ACS_ScriptCall("MonsterInit", MF_NOXP | MF_NOAURA | MF_NODROPS);
        }
    }
}
