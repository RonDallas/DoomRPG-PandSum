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