class DRPGZChar : EventHandler
{
    // Level Data (move into struct?)
    private int CurrentWAD;
    private string LevelLump;
    private int LevelNum;

    static bool LoadLevelData(int PlayerNum)
    {
        // Get class data pointer
        DRPGZChar cData = DRPGZChar(EventHandler.Find("DRPGZChar"));
        int rValue = false;

        // Example: !CW0!LLMAP01!LN0
        // Markers: !CW , !LL , !LN
        // CurrentWAD , LumpName/LevelLump , LevelNum
        string levelData = CVar.GetCVar("drpg_char_data_level", Players[PlayerNum]).GetString();

        // ----- Parser ----- //
        if (levelData != "")
        {
            string rStr;

            // CurrentWAD
            int llMarkerPos = levelData.IndexOf("!LL");
            rStr = levelData.Mid(0 + 3, llMarkerPos - 3);
            cData.CurrentWAD = rStr.ToInt();

            // LumpName/LevelLump
            int lnMarkerPos = levelData.IndexOf("!LN");
            cData.LevelLump = levelData.Mid(llMarkerPos + 3, (lnMarkerPos - 3 - llMarkerPos));

            // LevelNum
            rStr = levelData.Mid(lnMarkerPos + 3, (levelData.length() - 3 - lnMarkerPos));
            cData.LevelNum = rStr.ToInt();

            rValue = true;
        }

        return rValue;
    }

    static int GetSavedCurrentWAD()
    {
        // Get class data pointer
        DRPGZChar cData = DRPGZChar(EventHandler.Find("DRPGZChar"));

        return cData.CurrentWAD;
    }
    static string GetSavedLevelLump()
    {
        // Get class data pointer
        DRPGZChar cData = DRPGZChar(EventHandler.Find("DRPGZChar"));

        return cData.LevelLump;
    }
    static int GetSavedLevelNum()
    {
        // Get class data pointer
        DRPGZChar cData = DRPGZChar(EventHandler.Find("DRPGZChar"));

        return cData.LevelNum;
    }
    static void ClearRetrievedLevelData()
    {
        // Get class data pointer
        DRPGZChar cData = DRPGZChar(EventHandler.Find("DRPGZChar"));

        cData.CurrentWAD = 0;
        cData.LevelLump = "";
        cData.LevelNum = 0;

        return;
    }
}
