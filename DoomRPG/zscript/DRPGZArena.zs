class DRPGZArena : EventHandler
{
    private Array<int> ArenaMonsterTIDs;

    // Store Arena monster TID for tracking
    static void StoreMonsterTID(int TID)
    {
        // Get class data pointer
        DRPGZArena cData = DRPGZArena(EventHandler.Find("DRPGZArena"));

        cData.ArenaMonsterTIDs.push(TID);
    }

    // Removes all Arena monsters
    static void RemoveMonsterTIDs()
    {
        // Get class data pointer
        DRPGZArena cData = DRPGZArena(EventHandler.Find("DRPGZArena"));

        for (int i = 0; i < cData.ArenaMonsterTIDs.size(); i++)
        {
            ActorIterator AI = level.CreateActorIterator(cData.ArenaMonsterTIDs[i]);
            Actor A = AI.Next();

            // Remove actor if valid
            if (A)
            {
                A.Spawn("TeleportFog", A.Pos); // For Visual Effect
                A.Destroy();
                A.RemoveFromHash();
            }
        }

        cData.ArenaMonsterTIDs.Clear();
    }
    // Returns the amount of remaining monsters that are hostile
    static int GetAliveHostileCount()
    {
        // Get class data pointer
        DRPGZArena cData = DRPGZArena(EventHandler.Find("DRPGZArena"));

        int hostileCount = 0;

        for (int i = 0; i < cData.ArenaMonsterTIDs.size(); i++)
        {
            ActorIterator AI = level.CreateActorIterator(cData.ArenaMonsterTIDs[i]);
            Actor A = AI.Next();

            // Increment hostileCount if actor is alive and hostile
            if (A)
                if (A.Health > 0 && !A.bFRIENDLY)
                    hostileCount++;
        }

        return hostileCount;
    }
}
