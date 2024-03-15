class DRPGZHUD : EventHandler
{
    // Multiplayer HUD CVars
    private transient CVar multi_hud;
    private transient CVar multi_hud_skip;
    private transient CVar multi_hud_x;
    private transient CVar multi_hud_y;
    
    // Textures
    private TextureID Tex[2];
    
    // Initialization
    override void OnRegister()
    {
        // Load CVars
        multi_hud = CVar.FindCVar('drpg_multiplayer_hud');
        multi_hud_skip = CVar.FindCVar('drpg_multiplayer_hud_skip');
        multi_hud_x = CVar.FindCVar('drpg_multiplayer_x');
        multi_hud_y = CVar.FindCVar('drpg_multiplayer_y');
        
        // Select textures
        static const string NAMES[] = {
            "MPFill", // Health
            "MPFill2" // Shield
        };
        
        // Load textures
        for (int i = 0; i < NAMES.Size(); i++)
        {
            Tex[i] = TexMan.CheckForTexture(NAMES[i], TexMan.Type_Any);
        }
    }
    
    // Render loop
    override void RenderUnderlay(RenderEvent e)
    {
        float scale = min(Screen.GetWidth() / 1920.0, Screen.GetHeight() / 1080.0);
        
        if (multiplayer && multi_hud.GetBool())
        {
            // Update CVars
            int x = multi_hud_x.GetInt() / 1920.0 * Screen.GetWidth();
            int y = multi_hud_y.GetInt() / 1080.0 * Screen.GetHeight();
            bool skip_self = multi_hud_skip.GetBool();
            int skip = 0;
            
            for (int i = 0; i < MAXPLAYERS; i++)
            {
                // Skip players who are not in the game and also self if corresponding option is enabled
                if (!playeringame[i] || (skip_self && i == consoleplayer))
                {
                    skip++;
                    continue;
                }
                
                // Calculate offset
                int offset = (i - skip) * 45;
                
                // Draw player's name in player's color
                Screen.DrawText(NewSmallFont, Font.CR_WHITE,
                    x / scale, y / scale + offset,
                    players[i].GetUserName(),
                    DTA_VirtualWidth, 1920,
                    DTA_VirtualHeight, 1080,
                    DTA_KeepRatio, true,
                    DTA_Color, Color(players[i].GetColor() | 0xFF000000));
                
                // Draw healthbar when player is alive and another one when overhealed
                if (players[i].mo.Health >= 0)
                {
                    int max = players[i].mo.GetMaxHealth();
                    
                    Screen.DrawTexture(Tex[0], false,
                        x, y + (20 + offset) * scale,
                        DTA_DestWidth, int(200 * min(float(players[i].mo.Health) / float(max), 1.0) * scale),
                        DTA_DestHeight, int(20 * scale),
                        DTA_Alpha, 0.5);
                    
                    if (players[i].mo.Health > max)
                    {
                        Screen.DrawTexture(Tex[0], false,
                            x, y + (20 + offset) * scale,
                            DTA_DestWidth, int(200 * min(float(players[i].mo.Health - max) / float(max), 1.0) * scale),
                            DTA_DestHeight, int(20 * scale),
                            DTA_Alpha, 0.5);
                    }
                }
                
                // Get shield charge and capacity when shield is enabled
                int Capacity, Charge;
                
                if (players[i].mo.FindInventory("DRPGShield"))
                {
                    Capacity = ACS_NamedExecuteWithResult("GetPlayerShieldCapacity", i);
                    Charge = ACS_NamedExecuteWithResult("GetPlayerShieldCharge", i);
                }
                
                // Draw shieldbar and shield charge/capacity when shield has some charge
                if (Charge > 0)
                {
                    Screen.DrawTexture(Tex[1], false,
                        x, y + (20 + offset) * scale,
                        DTA_DestWidth, int(200 * min(float(Charge) / float(Capacity), 1.0) * scale),
                        DTA_DestHeight, int(20 * scale),
                        DTA_Alpha, 0.5);
                    
                    Screen.DrawText(NewSmallFont, Font.CR_LIGHTBLUE,
                        x / scale + 150, y / scale + offset,
                        Charge.."/"..Capacity,
                        DTA_VirtualWidth, 1920,
                        DTA_VirtualHeight, 1080,
                        DTA_KeepRatio, true);
                }
                // Draw only health and maxhealth if shield has no charge
                else
                {
                    Screen.DrawText(NewSmallFont, Font.CR_BRICK,
                        x / scale + 150, y / scale + offset,
                        players[i].mo.Health.."/"..players[i].mo.GetMaxHealth(),
                        DTA_VirtualWidth, 1920,
                        DTA_VirtualHeight, 1080,
                        DTA_KeepRatio, true);
                }
            }
        }
    }
}
