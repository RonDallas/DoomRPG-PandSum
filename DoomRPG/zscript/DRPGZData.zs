// Used for storing data for X player
class dPlayerData
{
    Array<int> iItem;
    //Array<string> sItem;
}

class DRPGZData : EventHandler
{
    // - Replacement Dynamic Arrays for ACS -
    // Mission.c
    private Array<int> PotentialTargets;
    // RPG.c
    private dPlayerData PlayerDrops[MAXPLAYERS];
    // Shop.c
    private dPlayerData AutoSell[MAXPLAYERS];
    private dPlayerData AutoStore[MAXPLAYERS];

    static int DynArrayUtils(string arrayName, int Function, int Data, int OwnerID)
    {
        // Get class data pointer
        DRPGZData cData = DRPGZData(EventHandler.Find("DRPGZData"));

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

                    break;
                }
                // Get
                case 2:
                {
                    return pData.iItem[Data];
                }
                // Return size of array
                case 3:
                {
                    return pData.iItem.size();
                }
                // Delete
                case 4:
                {
                    pData.iItem.Delete(Data);

                    break;
                }

                return 0;
            }
        }

        // - AutoSell & AutoStore Array Functions -
        if (arrayName == "Auto-Sell" || arrayName == "Auto-Store")
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
                // Add
                case 1:
                {
                    // Skip existing items
                    for (int i = 0; i < pData.iItem.size(); i++)
                        if (pData.iItem[i] == Data)
                            return 0;  

                    // Add item
                    pData.iItem.push(Data);

                    break;
                }
                // Get
                case 2:
                {
                    return pData.iItem[Data];
                }
                // Return size of array
                case 3:
                {
                    return pData.iItem.size();
                }
                // Check for Data item and delete
                case 4:
                {
                    for (int i = 0; i < pData.iItem.size(); i++)
                        if (pData.iItem[i] == Data)
                            pData.iItem.Delete(i);

                    break;
                }

                return 0;
            }
        }

        // - PotentialTargets Array Functions -
        if (arrayName == "PotentialTargets")
        {
            switch(Function)
            {
                 // Add
                 case 1:
                    cData.PotentialTargets.push(Data);
                    break;
                // Empty array check
                case 2:
                    if (cData.PotentialTargets.size() > 0)
                        return 1;
                    else
                        return 0;
                // Return random monster id
                case 3:
                    int arraySize = cData.PotentialTargets.size();
                    return cData.PotentialTargets[random(0, arraySize-1)];
                    break;
                // Clear array
                case 99:
                    cData.PotentialTargets.clear();
                    break;
            }

            return 0;
        }

        return 0;
    }
}