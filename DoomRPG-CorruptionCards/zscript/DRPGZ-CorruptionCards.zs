// DOOMRPG COMPATIBILITY
// --------------------------------------------------

// Calling the ACS MonsterInit script for monsters
class CCards_MonsterInit : EventHandler
{
    override void WorldThingSpawned(WorldEvent e)
    {
        if (e.Thing && e.Thing.bIsMonster)
        {
            // Monsters that cannot be defined via Decorate are handled here
            static const string CCMonsters[] =
            {
                "CCards_Actor_Maestro",
                "CCards_Actor_Shark",
                "CCards_Actor_Santa",
                "CCards_Actor_PilotedMech",
                "CCards_Actor_AllyMarine",
                "CCards_Actor_PossessedMarine",
                "CCards_Actor_Werewolf",
                "CCards_SpookySkeleton"
            };

            static const string CCBosses[] =
            {
                "CCards_Actor_TheAncientOne",
                "CCards_Actor_Bane"
            };

            for (int i = 0; i < CCMonsters.size(); i++)
                if (e.Thing.GetClassName() == CCMonsters[i])
                    e.Thing.ACS_ScriptCall("MonsterInit", 0);

            for (int i = 0; i < CCBosses.size(); i++)
                if (e.Thing.GetClassName() == CCBosses[i])
                    e.Thing.ACS_ScriptCall("MonsterInit", MF_BOSS);
        }
    }
}

