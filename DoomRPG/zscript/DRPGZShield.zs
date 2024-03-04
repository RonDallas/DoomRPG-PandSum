// Damage Types
const DT_NONE = -1;
const DT_NORMAL = 0;
const DT_TOXIC = 1;
const DT_RADIATION = 2;
const DT_MELEE = 3;
const DT_FIRE = 4;
const DT_PLASMA = 5;
const DT_LIGHTNING = 6;

class DRPGZShieldDamageHandler : Inventory
{
    override void AbsorbDamage(int damage, Name damageType, out int newdamage)
    {
        int dmgType;

        if (damageType == "Slime")
            dmgType = DT_TOXIC;
        else if (damageType == "Radiation")
            dmgType = DT_RADIATION;
        else if (damageType == "Melee")
            dmgType = DT_MELEE;
        else if (damageType == "Fire")
            dmgType = DT_FIRE;
        else if (damageType == "Plasma")
            dmgType = DT_PLASMA;
        else if (damageType == "Electric")
            dmgType = DT_LIGHTNING;
        else
            dmgType = DT_NORMAL;

        owner.ACS_ScriptCall("SetDamageType", dmgType);

        newdamage = owner.ACS_ScriptCall("ShieldDamage", damage);
    }
}
