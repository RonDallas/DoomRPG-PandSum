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

class DRPGZExtraWad : StaticEventHandler
{
    // Copied lumps stored here
    private Array<string> ewLumps;
    // Position of ewActors and for detection, I suppose (I wanted pointers but oh well)
    int ewPack;

    static string WadTools(int Function, int Data)
    {
        // Used for detection
        static const string ewActors[] =
        {
            "DRPGWadSmooshActive",
            "DRPGLexiconActive",
            "DRPGCompendiumActive"
        };

        // WadSmoosh WAD Lumps
        static const string wsLumps[] =
        {
            // Uses PK3 path
            "/MAPS/E1M1.WAD",
            "/MAPS/E5M1.WAD",
            "/MAPS/E6M1.WAD",
            "/MAPS/MAP01.WAD",
            "/MAPS/NV_MAP01.WAD",
            "/MAPS/ML_MAP01.WAD",
            "/MAPS/TN_MAP01.WAD",
            "/MAPS/PL_MAP01.WAD"
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
            "/MAPS/HPH01.WAD",
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
            "/MAPS/UAC01.WAD",
            "/MAPS/UHR01.WAD",
            "/MAPS/VAL01.WAD",
            "/MAPS/VAN01.WAD",
            "/MAPS/WID01.WAD",
            "/MAPS/WOS01.WAD",
            "/MAPS/ZTH01.WAD",
            "/MAPS/ZOF01.WAD"
        };

        // Compendium WAD Lumps
        // Lumps Source: https://github.com/WNC12k/DoomRPG-Rebalance/blob/master/DoomRPG/scripts/Map.c#L3710
        static const string cmLumps[] =
        {
            // Uses PK3 path
            "/MAPS/HUBMAP.WAD:HUB",
            "/MAPS/MM101.WAD",
            "/MAPS/MM201.WAD",
            "/MAPS/REQ01.WAD",
            "/MAPS/INS01.WAD",
            "/MAPS/OBT01.WAD",
            "/MAPS/STR01.WAD",
            "/MAPS/BIO01.WAD",
            "/MAPS/DRK01.WAD",
            "/MAPS/TTP01.WAD",
            "/MAPS/PGR01.WAD",
            "/MAPS/PST01.WAD",
            "/MAPS/TVR01.WAD",
            "/MAPS/SCI01.WAD",
            "/MAPS/ICA01.WAD",
            "/MAPS/HTP01.WAD",
            "/MAPS/ABY01.WAD",
            "/MAPS/TAL01.WAD",
            "/MAPS/ALH01.WAD",
            "/MAPS/ENI01.WAD",
            "/MAPS/RLM01.WAD",
            "/MAPS/DYS01.WAD",
            "/MAPS/ETE01.WAD",
            "/MAPS/REB01.WAD",
            "/MAPS/SCY01.WAD",
            "/MAPS/COD01.WAD",
            "/MAPS/DK201.WAD",
            "/MAPS/EQU01.WAD",
            "/MAPS/MRS01.WAD",
            "/MAPS/BLR01.WAD",
            "/MAPS/OSI01.WAD",
            "/MAPS/RUI01.WAD",
            "/MAPS/NJZ01.WAD",
            "/MAPS/DAE01.WAD",
            "/MAPS/CLE01.WAD",
            "/MAPS/ASD01.WAD",
            "/MAPS/PLE01.WAD",
            "/MAPS/DCV01.WAD",
            "/MAPS/SLA01.WAD",
            "/MAPS/HFA01.WAD",
            "/MAPS/CDR01.WAD",
            "/MAPS/GAT01.WAD",
            "/MAPS/ERT01.WAD",
            "/MAPS/END01.WAD",
            "/MAPS/RES01.WAD",
            "/MAPS/ENS01.WAD",
            "/MAPS/BTK01.WAD",
            "/MAPS/CIT01.WAD",
            "/MAPS/SLP01.WAD",
            "/MAPS/DIS01.WAD",
            "/MAPS/SID01.WAD",
            "/MAPS/MAN01.WAD",
            "/MAPS/LEP01.WAD",
            "/MAPS/VFL01.WAD",
            "/MAPS/VCO01.WAD",
            "/MAPS/TW201.WAD",
            "/MAPS/NEO01.WAD",
            "/MAPS/ANN01.WAD",
            "/MAPS/99W01.WAD",
            "/MAPS/BTH01.WAD"
        };

        // Get class data pointer
        DRPGZExtraWad cData = DRPGZExtraWad(StaticEventHandler.Find("DRPGZExtraWad"));

        // Init ewPack
        if (cData.ewPack == 0)
            cData.ewPack = EW_NONE;

        // Default return value
        string rValue = "";

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
                cData.ewPack = EW_WS;
                break;
            }
            // ---- Lexicon ----
            else if (AllActorClasses[i].GetClassName() == ewActors[EW_LX])
            {
                cData.ewPack = EW_LX;
                break;
            }
            // ---- Compendium ----
            else if (AllActorClasses[i].GetClassName() == ewActors[EW_CM])
            {
                cData.ewPack = EW_CM;
                break;
            }
        }

        // ------
        // Part 2
        // ------
        // Detect lumps only if an Extra WAD exists
        // ----------------------------------------
        if (cData.ewPack != EW_NONE)
        {
            // ------
            // Part 3
            // ----------------------------------------------------
            // Copy detected lumps into a separate array for Part 4
            // ----------------------------------------------------
            if (cData.ewLumps.size() == 0)
            {
                switch(cData.ewPack)
                {
                // ---- WadSmoosh ----
                case EW_WS:
                {
                    if (cData.ewPack == EW_WS)
                        for (int i = 0; i < wsLumps.size(); i++)
                            cData.ewLumps.push(wsLumps[i]);
                }
                break;
                // ---- Lexicon ----
                case EW_LX:
                {
                    if (cData.ewPack == EW_LX)
                        for (int i = 0; i < lxLumps.size(); i++)
                            cData.ewLumps.push(lxLumps[i]);
                }
                break;
                // ---- Compendium ----
                case EW_CM:
                {
                    if (cData.ewPack == EW_CM)
                        for (int i = 0; i < cmLumps.size(); i++)
                            cData.ewLumps.push(cmLumps[i]);
                }
                break;
                }
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
                {
                    //console.printf("DEBUG: Extra WAD(s): Invalid Lump %s", Lump);
                    rValue = "-1";
                }
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
            case 99:
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

    // Names of each WAD
    static string GetNiceName(int wadNum)
    {
        // WadSmoosh Nice Names
        static const string wsNiceNames[] =
        {
            "Doom",
            "Sigil",
            "Sigil II",
            "Doom II: Hell on Earth",
            "No Rest For The Living",
            "The Master Levels",
            "TNT: Evilution",
            "The Plutonia Experiment"
        };

        // Lexicon Nice Names
        static const string lxNiceNames[] =
        {
            "Lexicon's Hub",
            "Ancient Aliens",
            "A Clear Line Drawn",
            "Hot Water Music",
            "Alien Vendetta",
            "Back to Saturn X",
            "Community Chest 1",
            "Community Chest 2",
            "Community Chest 3",
            "Community Chest 4",
            "Chillax",
            "Circle Of Caina",
            "Combat Shock",
            "Combat Shock 2",
            "Chainworm",
            "Doom Core Trilogy",
            "Drown In Blood",
            "Dark Encounters",
            "Destination Unknown",
            "Deus Vult",
            "Deus Vult 2",
            "Epic 1",
            "Epic 2",
            "Estranged",
            "The Eye",
            "Forest Swords",
            "Going Down",
            "Hellcore",
            "Hellbound",
            "Hell Pike",
            "Sens",
            "Hadephobia",
            "Hell Revealed",
            "Hell Revealed 2",
            "Interception",
            "Kamasutra",
            "Khorus Speedy Shit",
            "Mayhem 17",
            "Maps Of Chaos",
            "Monuments Of Mars",
            "New Gothic Movement",
            "New Gothic Movement 2",
            "NOVA",
            "Pizza Steve",
            "Doom 2 Redux",
            "Scythe 2",
            "Stardate 20x6",
            "Stardate 20x7",
            "Swift Death",
            "Slaughterfest 2012",
            "Slaughterfest 2013",
            "Shaitans Luck",
            "Sunlust",
            "Sunder",
            "Speed Of Doom",
            "Swim With The Whales",
            "Dark Tartarus",
            "The Spire",
            "The Spire 2",
            "Congestion",
            "CLAUSTERPHOBIA 2",
            "CLAUSTERPHOBIA 1",
            "1997 Tuneup Project",
            "UAC Ultra",
            "Unholy Realms",
            "Valiant",
            "Vanguard",
            "D2 The Way ID Did",
            "Whispers Of Satan",
            "Zone 300",
            "Zones Of Fear"
        };

        // Compendium Nice Names
        static const string cmNiceNames[] =
        {
            "Compendium's Hub",
            "Memento Mori",
            "Memento Mori II",
            "Requiem",
            "Insertion",
            "Obituary",
            "Strain",
            "Biowar",
            "The Darkening",
            "The Trooper's Playground",
            "Predition's Gate",
            "Post",
            "Revolution",
            "Scientist",
            "Icarus Alien Vanguard",
            "Hell to Pay",
            "The Abyss",
            "The Talosian Incident",
            "All Hell is Breaking Loose!",
            "Enigma",
            "Realm of Chaos",
            "Dystopia 3",
            "Eternal Doom",
            "Rebight",
            "Scythe",
            "Caverns of Darkness",
            "The Darkening 2",
            "Equinox",
            "Marsdoom",
            "Bloodrust",
            "Osiris",
            "Brotherhood of Ruin",
            "Enjay ZDoom",
            "Daedalus",
            "Cleimos",
            "Asdoom 2",
            "Pleiades",
            "Dark Covenant",
            "Slayer",
            "Hell Factory",
            "Cyberdreams",
            "The Final Gathering",
            "Earth",
            "End Game",
            "Doom Resurrection",
            "Enslavement",
            "Biotech",
            "City of Doom",
            "Project Slipgate",
            "Dissolution of Eternity",
            "Suspended in Dusk",
            "Mancubus",
            "Last Day on Earth",
            "Vile Flesh",
            "The Vilecore",
            "Twilight Zone II",
            "Neodoom",
            "Annie",
            "99 Ways to Die",
            "Back to Hell"
        };

        // Get class data pointer
        DRPGZExtraWad cData = DRPGZExtraWad(StaticEventHandler.Find("DRPGZExtraWad"));
        // Default return value
        string rValue = "";

        switch (cData.ewPack)
        {
        case EW_WS:
        {
            rValue = wsNiceNames[wadNum];
        }
        break;
        case EW_LX:
        {
            rValue = lxNiceNames[wadNum];
        }
        break;
        case EW_CM:
        {
            rValue = cmNiceNames[wadNum];
        }
        break;
        }

        return rValue;
    }
}