// All functions here return zero unless noted otherwise

class DRPGZDataSt : StaticEventHandler
{
    // - Replacement Dynamic Arrays for ACS -
    // Mission.c
    private Array<int> PotentialTargets;

    static int DynArrayUtils(string arrayName, int Function, int Data)
    {
        // Get class data pointer
        DRPGZDataSt cData = DRPGZDataSt(StaticEventHandler.Find("DRPGZDataSt"));
        int rValue = 0;

        // - PotentialTargets Array Functions -
        if (arrayName == "PotentialTargets")
        {
            switch(Function)
            {
            // Add
            case 1:
            {
                cData.PotentialTargets.push(Data);
            }
            break;
            // Empty array check; returns 1 if array is populated
            case 2:
            {
                if (cData.PotentialTargets.size() > 0)
                    rValue = 1;
            }
            break;
            // Return random monster id
            case 3:
            {
                int arraySize = cData.PotentialTargets.size();
                rValue = cData.PotentialTargets[random(0, arraySize-1)];
            }
            break;
            // Clear array
            case 99:
            {
                cData.PotentialTargets.clear();
            }
            break;
            }
        }

        return rValue;
    }
}

class DRPGZData : EventHandler
{
    // - Replacement Dynamic Arrays for ACS -
    // RPG.c
    private dPlayerData PlayerDrops[MAXPLAYERS];
    // Shop.c
    private dPlayerData AutoSell[MAXPLAYERS];
    private dPlayerData AutoStore[MAXPLAYERS];

    static int DynArrayUtils(string arrayName, int Function, int Data, int OwnerID)
    {
        // Get class data pointer
        DRPGZData cData = DRPGZData(EventHandler.Find("DRPGZData"));
        int rValue = 0;

        // - PlayerDrops Array Functions -
        if (arrayName == "PlayerDrops")
        {
            // Init PlayerDrops playerData array
            if (!cData.PlayerDrops[OwnerID])
                cData.PlayerDrops[OwnerID] = new('dPlayerData');

            // Direct pointer to playerData
            let pData = cData.PlayerDrops[OwnerID];

            switch(Function)
            {
            // Add
            case 1:
            {
                // Add item
                pData.iItem.push(Data);
            }
            break;
            // Get
            case 2:
            {
                rValue = pData.iItem[Data];
            }
            break;
            // Return size of array
            case 3:
            {
                rValue = pData.iItem.size();
            }
            break;
            // Delete
            case 4:
            {
                pData.iItem.Delete(Data);
            }
            break;
            }
        }
        // - AutoSell & AutoStore Array Functions -
        else if (arrayName == "Auto-Sell" || arrayName == "Auto-Store")
        {
            // 0 = AutoSell
            // 1 = AutoStore
            int pDataSelection;

            // Determine which array to work with
            if (arrayName == "Auto-Sell")
                pDataSelection = 0;
            else
                pDataSelection = 1;

            // Init AutoSell playerData array
            if (!cData.AutoSell[OwnerID])
                cData.AutoSell[OwnerID] = new('dPlayerData');
            // Init AutoStore playerData array
            if (!cData.AutoStore[OwnerID])
                cData.AutoStore[OwnerID] = new('dPlayerData');

            // Direct pointer to playerData
            let pData = pDataSelection ? cData.AutoSell[OwnerID] : cData.AutoStore[OwnerID];

            switch(Function)
            {
            // Add; returns 1 if item already exists
            case 1:
            {
                // Skip existing items
                for (int i = 0; i < pData.iItem.size(); i++)
                    if (pData.iItem[i] == Data)
                        rValue = 1;

                // Add item
                if (rValue == 0)
                    pData.iItem.push(Data);
            }
            break;
            // Get
            case 2:
            {
                rValue = pData.iItem[Data];
            }
            break;
            // Return size of array
            case 3:
            {
                rValue = pData.iItem.size();
            }
            break;
            // Check for Data item and delete; returns 1 if requested item is deleted
            case 4:
            {
                for (int i = 0; i < pData.iItem.size(); i++)
                    if (pData.iItem[i] == Data)
                    {
                        pData.iItem.Delete(i);
                        rValue = 1;
                    }
            }
            break;
            }
        }

        return rValue;
    }
}

class DRPGZExtraWADs : EventHandler
{
    // Copied lumps stored here
    private Array<string> ewLumps;

    static string ExtraWADTools(int Function, int Data)
    {
        // Used for detection
        static const string ewActors[] =
        {
            "DRPGWadSmooshActive"
        };

        // WadSmoosh WAD Lumps
        static const string wsLumps[] =
        {
            // Uses PK3 path
            "/MAPS/E1M1.WAD",
            "/MAPS/E5M1.WAD",
            "/MAPS/E6M1.WAD",
            "/MAPS/MAP01.WAD",
            "/MAPS/PL_MAP01.WAD",
            "/MAPS/TN_MAP01.WAD",
            "/MAPS/NV_MAP01.WAD",
            "/MAPS/ML_MAP01.WAD"
        };

        // Get class data pointer
        DRPGZExtraWADs cData = DRPGZExtraWADs(EventHandler.Find("DRPGZExtraWADs"));

        string rValue = "";
        // Position of ewActors and for detection, I suppose (I wanted pointers but oh well)
        int ewPack = EW_NONE;

        // ------
        // Part 1
        // ------
        // Detect Extra WAD
        // ----------------
        for (int i = 0; i < AllActorClasses.size(); i++)
        {
            // ---- WadSmoosh ----
            if (AllActorClasses[i].GetClassName() == ewActors[EW_WS])
            {
                ewPack = EW_WS;
                break;
            }
        }

        // ------
        // Part 2
        // ------
        // Detect lumps only if an Extra WAD exists
        // ----------------------------------------
        if (ewPack != EW_NONE)
        {
            // ------
            // Part 3
            // ----------------------------------------------------
            // Copy detected lumps into a separate array for Part 4
            // ----------------------------------------------------
            if (cData.ewLumps.size() == 0)
            {
                // ---- WadSmoosh ----
                if (ewPack == EW_WS)
                    for (int i = 0; i < wsLumps.size(); i++)
                        cData.ewLumps.push(wsLumps[i]);
            }

            // ------
            // Part 4
            // ----------------------------------------------------------
            // Sift through copied lumps to detect existing lumps for ACS
            // ----------------------------------------------------------
            switch (Function)
            {
            // Process valid lump for return
            case 1:
            {
                string Lump;

                // ACS relies on -1 and -2 to stop
                // -1 = WAD not detected
                // -2 = No more WADs

                // End of copied lumps
                if (Data >= cData.ewLumps.size())
                {
                    rValue = "-2";
                    break;
                }

                // Get copied lump
                Lump = cData.ewLumps[Data];

                // Check if lump exists (mainly for WadSmoosh but good to have)
                if (WADS.CheckNumForFullName(Lump) == -1)
                    rValue = "-1";
                else
                {
                    // Snip path
                    Lump.remove(0, 6);
                    // Snip extension
                    Lump.remove((Lump.Length()-4), 4);
                    // Done
                    rValue = Lump;
                }
            }
            break;
            // Delete array; no longer needed
            case 2:
            {
                cData.ewLumps.clear();
            }
            break;
            }
        }
        else // No Extra WADs detected
            rValue = "-2";

        return rValue;
    }
}
