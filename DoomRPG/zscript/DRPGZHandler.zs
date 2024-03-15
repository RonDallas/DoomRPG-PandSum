class DRPGZHandler : EventHandler
{
    // Replaces exits with ACS_Execute which calls DRPG's map exit script instead
    override void WorldLoaded(WorldEvent e)
    {
        CallACS("SetDebugMode");

        // Iterate through all lines in the current map to find exits to replace
        for (int i = 0; i < level.Lines.Size(); i++)
        {
            Line l = level.Lines[i];
            int s = l.special;
            // Exit_Normal
            switch (s)
            {
            case 243:
            {
                // 80 = ACS_Execute
                l.special = 80;
                l.args[0] = 30000;
                l.args[1] = 0;
                l.args[2] = 0;
                l.args[3] = 0;
                l.args[4] = 0;
                // Must be repeatable for DRPG things
                l.flags |= Line.ML_REPEAT_SPECIAL;
            }
            break;
            // Exit_Secret
            case 244:
            {
                // 80 = ACS_Execute
                l.special = 80;
                l.args[0] = 30000;
                l.args[1] = 0;
                l.args[2] = 1;
                l.args[3] = 0;
                l.args[4] = 0;
                // Must be repeatable for DRPG things
                l.flags |= Line.ML_REPEAT_SPECIAL;
            }
            break;
            // Teleport_NewMap
            case 74:
            {
                // Save args
                int map = l.args[0];
                int pos = l.args[1];
                int face = l.args[2];
                // 80 = ACS_Execute
                l.special = 80;
                l.args[0] = 30001;
                l.args[1] = 0;
                l.args[2] = map;
                l.args[3] = pos;
                l.args[4] = face;
                // Must be repeatable for DRPG things
                l.flags |= Line.ML_REPEAT_SPECIAL;
            }
            break;
            }
        }

        // Iterate through all sectors in the current map to find secrets and add crate to the center
        for (int i = 0; i < Level.Sectors.Size(); ++i)
        {
            Sector CurrSec = level.Sectors[i];
            secplane Floor = CurrSec.floorplane;
            secplane Ceiling = CurrSec.ceilingplane;
            int CeilingZ = int(Ceiling.ZAtPoint((CurrSec.CenterSpot.x, CurrSec.CenterSpot.y)));
            int FloorZ = int(Floor.ZAtPoint((CurrSec.CenterSpot.x, CurrSec.CenterSpot.y)));
            int CenterHeight = CeilingZ - FloorZ;
            vector3 SpawnPos = (CurrSec.CenterSpot.x + random(-16, 16), CurrSec.CenterSpot.y + random(-16, 16), Floor.ZAtPoint(CurrSec.CenterSpot));

            // Spawn Crate in a secret with a certain chance, only if secret's sector is not a door (looking at you, Doom 1)
            if (CurrSec.IsSecret() && CenterHeight > 0)
            {
                Actor.Spawn("DRPGSecretSpawner", SpawnPos);
            }
        }
    }

    override void WorldThingDamaged(WorldEvent e)
    {
        if (e.Thing.Player)
        {
            int DamageSourceTID = 0;
            if (e.DamageSource)
                DamageSourceTID = e.DamageSource.TID;

            e.Thing.ACS_ScriptCall("PlayerDamage", DamageSourceTID, e.Damage);
        }

        if (e.Thing && e.DamageSource && e.Thing.bIsMonster)
        {
            int Damage = e.Damage;
            if (e.Thing.Health < 0)
            {
                Damage += e.Thing.Health;
            }
            e.Thing.ACS_ScriptCall("MonsterDamaged", e.DamageSource.TID, Damage);
        }
    }

    override void WorldThingRevived(WorldEvent e)
    {
        if (e.Thing && e.Thing.bIsMonster)
            e.Thing.ACS_ScriptCall("MonsterRevive");
    }

    override void WorldThingSpawned(WorldEvent e)
    {
        if (e.Thing && e.Thing.bIsMonster)
        {
            // Monsters that cannot be defined via Decorate are handled here
            static const string RLMonsters[] =
            {
                // CORRUPTED PLAYERS
                "RLCorruptedMarine1",
                "RLCorruptedScout1",
                "RLCorruptedTechnician1",
                "RLCorruptedRenegade1",
                "RLCorruptedDemolitionist1",

                // DRLAX (Roguelike Arsenal Extended) classes
                "RLCorruptedMechanoid1",
                "RLCorruptedPhaseSisters1",
                "RLCorruptedNomad1",
                "RLCorruptedSarge1",
                "RLCorruptedNanoManiac1",
                "RLCorruptedTrespasser1",
                "RLCorruptedBunker1"
            };
            static const string RLMBosses[] =
            {
                "RLDarkMarty",
                "RLArtifactGuardian" // This may need corrected
            };

            for (int i = 0; i < RLMonsters.size(); i++)
                if (e.Thing.GetClassName() == RLMonsters[i])
                    e.Thing.ACS_ScriptCall("MonsterInit", 0);

            for (int i = 0; i < RLMBosses.size(); i++)
                if (e.Thing.GetClassName() == RLMBosses[i])
                    e.Thing.ACS_ScriptCall("MonsterInit", MF_BOSS);
        }
    }

    override void WorldThingDied(WorldEvent e)
    {
        if (e.Thing && !e.Thing.Player)
        {
            if(!e.Thing.bIsMonster)
            {
                // Kinsie Metaprops - Tech
                static const string PropTech[] =
                {
                    "MetaTechLamp",
                    "MetaTechLamp2",
                    "MetaColumn",
                    "MetaTechPillar"
                };

                // Kinsie Metaprops - Gore plus MetaHeadOnAStick
                static const string PropGore[] =
                {
                    "MetaBloodyTwitch",
                    "MetaDeadStick",
                    "MetaLiveStick",
                    "MetaMeat2",
                    "MetaMeat3",
                    "MetaMeat4",
                    "MetaMeat5",
                    "MetaHangBNoBrain",
                    "MetaHangNoGuts",
                    "MetaHangTLookingDown",
                    "MetaHangTLookingUp",
                    "MetaHangTNoBrain",
                    "MetaHangTSkull",
                    "MetaHeadOnAStick"
                };

                // DRLA - Barrels
                static const string PropBarrels[] =
                {
                    "RLVanillaExplosiveBarrel",
                    "RLExplosiveBarrel",
                    "RLAcidBarrel",
                    "RLNapalmBarrel",
                    "RLTechBarrel",
                    "RLNuclearBarrel"
                };

                // Kinsie Metaprops - Hell except MetaHeadOnAStick
                /*
                 * turned off because couldn't think of item pool for this
                 * todo: add something funny and/or cool if Player destroys MetaBigTree or MetaTorchTree with a Chainsaw
                 * (drop new item Wood Log? new associated quest? one-time perk/achievement award?)
                 */
                /*static const string PropEtc[] =
                {
                    "MetaBigTree",
                    "MetaTorchTree",
                    "MetaCandelabra",
                    "MetaEvilEye"
                };*/

                int propType;

                for (int i = 0; i < PropTech.size(); i++)
                {
                    if(propType)
                        break;
                    if (e.Thing.GetClassName() == PropTech[i])
                        propType = 1;
                }

                if(!propType)
                {
                    for (int i = 0; i < PropGore.size(); i++)
                    {
                        if(propType)
                            break;
                        if (e.Thing.GetClassName() == PropGore[i])
                            propType = 2;
                    }
                }

                if(!propType)
                {
                    for (int i = 0; i < PropBarrels.size(); i++)
                    {
                        if(propType)
                            break;
                        if (e.Thing.GetClassName() == PropBarrels[i])
                            propType = 3;
                    }
                }

                /*
                if(!propType) {
                    for (int i = 0; i < PropEtc.size(); i++) {
                        if(propType)
                            break;
                        if (e.Thing.GetClassName() == PropEtc[i])
                            propType = 4;
                    }
                }
                */

                // drop credits only if couldn't find Actor class in arrays

                e.Thing.ACS_ScriptCall("PropDeathCheck", propType);
            }
            else
                e.Thing.ACS_ScriptCall("MonsterDeathCheck");
        }
    }
}
