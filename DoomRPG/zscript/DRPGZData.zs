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

class DRPGZExtraWad : EventHandler
{
    // Copied lumps stored here
    private Array<string> ewLumps;

    static string ExtraWadTools(int Function, int Data)
    {
        // Used for detection
        static const string ewActors[] =
        {
            "DRPGWadSmooshActive",
            "DRPGLexiconActive"
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

        // Lexicon WAD Lumps
        // Lumps Source: https://github.com/WNC12k/DoomRPG-Rebalance/blob/master/DoomRPG/scripts/Map.c#L3710
        static const string lxLumps[] =
        {
            // Uses PK3 path
            "/MAPS/VR.WAD:HUB",
            "/MAPS/AA101.WAD",
            "/MAPS/AAA01.WAD",
            "/MAPS/AAA02.WAD",
            "/MAPS/AV01.WAD",
            "/MAPS/BX101.WAD",
            "/MAPS/CC101.WAD",
            "/MAPS/CC201.WAD",
            "/MAPS/CC301.WAD",
            "/MAPS/CC401.WAD",
            "/MAPS/CHX01.WAD",
            "/MAPS/COC01.WAD",
            "/MAPS/CS01.WAD",
            "/MAPS/CS201.WAD",
            "/MAPS/CW101.WAD",
            "/MAPS/DC01.WAD",
            "/MAPS/DIB01.WAD",
            "/MAPS/DKE01.WAD",
            "/MAPS/DU101.WAD",
            "/MAPS/DV01.WAD",
            "/MAPS/DV201.WAD",
            "/MAPS/EP101.WAD",
            "/MAPS/EP201.WAD",
            "/MAPS/EST01.WAD",
            "/MAPS/EYE01.WAD",
            "/MAPS/FSW01.WAD",
            "/MAPS/GD01.WAD",
            "/MAPS/HC01.WAD",
            "/MAPS/HLB01.WAD",
            "/MAPS/HP101.WAD",
            "/MAPS/HP103.WAD",
            "/MAPS/HPH.WAD",
            "/MAPS/HR01.WAD",
            "/MAPS/HR201.WAD",
            "/MAPS/INT01.WAD",
            "/MAPS/KS01.WAD",
            "/MAPS/KSS01.WAD",
            "/MAPS/MAY01.WAD",
            "/MAPS/MOC01.WAD",
            "/MAPS/MOM01.WAD",
            "/MAPS/NG101.WAD",
            "/MAPS/NG201.WAD",
            "/MAPS/NV101.WAD",
            "/MAPS/PIZ01.WAD",
            "/MAPS/RDX01.WAD",
            "/MAPS/SC201.WAD",
            "/MAPS/SD601.WAD",
            "/MAPS/SD701.WAD",
            "/MAPS/SDE01.WAD",
            "/MAPS/SF201.WAD",
            "/MAPS/SF301.WAD",
            "/MAPS/SL20.WAD",
            "/MAPS/SLU01.WAD",
            "/MAPS/SND01.WAD",
            "/MAPS/SOD01.WAD",
            "/MAPS/SW101.WAD",
            "/MAPS/TAT01.WAD",
            "/MAPS/TSP01.WAD",
            "/MAPS/TSP201.WAD",
            "/MAPS/TT101.WAD",
            "/MAPS/TT201.WAD",
            "/MAPS/TT301.WAD",
            "/MAPS/TU01.WAD",
            "/MAPS/USC01.WAD",
            "/MAPS/UHR01.WAD",
            "/MAPS/VAL01.WAD",
            "/MAPS/VAN01.WAD",
            "/MAPS/WID01.WAD",
            "/MAPS/WOS01.WAD",
            "/MAPS/ZTH01.WAD",
            "/MAPS/ZOF01.WAD"
        };

        // Get class data pointer
        DRPGZExtraWad cData = DRPGZExtraWad(EventHandler.Find("DRPGZExtraWad"));

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
            // ---- Lexicon ----
            if (AllActorClasses[i].GetClassName() == ewActors[EW_LX])
            {
                ewPack = EW_LX;
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

                // ---- Lexicon ----
                if (ewPack == EW_LX)
                    for (int i = 0; i < lxLumps.size(); i++)
                        cData.ewLumps.push(lxLumps[i]);
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

                // Get Lump
                Lump = cData.ewLumps[Data];

                // Check if lump exists (mainly for WadSmoosh but good to have)
                // Hub gets through so ACS can detect it
                if (WADS.CheckNumForFullName((Lump)) == -1 && Lump.RightIndexOf(":HUB") == -1)
                    rValue = "-1";
                else
                {
                    // Snip path
                    Lump.Remove(Lump.IndexOf("/MAPS/"), 6);
                    // Snip extension
                    Lump.Remove(Lump.RightIndexOf(".WAD"), 4);

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
        else // No Extra WAD(s) detected
            rValue = "-2";

        return rValue;
    }
}
