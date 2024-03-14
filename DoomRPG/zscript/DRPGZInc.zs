// -------------
// DRPGZData.zs
// -------------

// Used for storing data for X player
class dPlayerData
{
    Array<int> iItem;
    //Array<string> sItem;
}

// ---------------
// DRPGZHandler.zs
// ---------------

// Monster Flags
enum EMonsterFlags
{
    MF_BOSS         = 0x0001,
    MF_NOXP         = 0x0002,
    MF_NOSTATS      = 0x0004,
    MF_NOAURA       = 0x0008,
    MF_NOPAYKILL    = 0x0010,
    MF_NODROPS      = 0x0020,
    MF_NOHEALTHBAR  = 0x0040,
    MF_NOWEAKEN     = 0x0080,
    MF_MEGABOSS     = 0x0100,
    MF_NAMEGEN      = 0x0200,
    MF_NOAURAGEN    = 0x0400, // [KS] Separate from NoAura to tell MonsterInit that we've acquired an aura through other means.
    MF_RANKLOSS     = 0x0800
};

// --------------
// DRPGZShield.zs
// --------------

// Damage Types
const DT_NONE = -1;
const DT_NORMAL = 0;
const DT_TOXIC = 1;
const DT_RADIATION = 2;
const DT_MELEE = 3;
const DT_FIRE = 4;
const DT_PLASMA = 5;
const DT_LIGHTNING = 6;

// ---------------------------
// DRPGZData.zs - Extra WAD(s)
// ---------------------------

const MAX_WAD_LUMPS = 100;

// Position of ewActors and for detection, I suppose (I wanted pointers but oh well)
enum ewPacks
{
    EW_NONE = -1,
    EW_WS,
    EW_LX
};