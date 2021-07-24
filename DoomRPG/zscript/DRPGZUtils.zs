class DRPGZInputHandler : EventHandler
{
    override bool InputProcess(InputEvent e)
    {
        // Supported Bindings
        static const string drpgBindings[] =
        {
            "+forward",
            "+back",
            "+moveleft",
            "+moveright",
            "+crouch",
            "+speed",
            "+use",
            "+attack",
            "+altattack",
            "+zoom",
            "+jump",
            "+user1",
            "+user2"
        };

        // Values for ACS
        static const int drpgBindingValues[] =
        {
            BT_FORWARD,
            BT_BACK,
            BT_MOVELEFT,
            BT_MOVERIGHT,
            BT_CROUCH,
            BT_SPEED,
            BT_USE,
            BT_ATTACK,
            BT_ALTATTACK,
            BT_ZOOM,
            BT_JUMP,
            BT_USER1,
            BT_USER2
        };

        // Data
        string keyCurrent = "";
        int keySupported = 0;
        bool KeyDown;

        // This input code is for singleplayer only due to desync caused by CallACS(?)
        if (multiplayer)
            return false;

        // KeyDown detection
        if 			(e.Type == e.Type_KeyDown)
            KeyDown = true;
        else if (e.Type == e.Type_KeyUp)
            KeyDown = false;
        else
            return false;

        // Get bindings
        keyCurrent = Bindings.GetBinding(e.KeyScan);

        // Check bindings
        for (int i = 0; i < drpgBindings.size(); i++)
            if (keyCurrent == drpgBindings[i])
                keySupported = drpgBindingValues[i];

        // Check joystick left stick for menu navigation if no bindings are detected
        if (keyCurrent == "")
            switch(e.KeyScan)
            {
            case e.Key_Pad_LThumb_Up:
            {
                keySupported = drpgBindingValues[0];
            }
            break;
            case e.Key_Pad_LThumb_Down:
            {
                keySupported = drpgBindingValues[1];
            }
            break;
            case e.Key_Pad_LThumb_Left:
            {
                keySupported = drpgBindingValues[2];
            }
            break;
            case e.Key_Pad_LThumb_Right:
            {
                keySupported = drpgBindingValues[3];
            }
            break;
            }

        // Only update ACS if key is supported
        if (KeySupported > 0)
            CallACS("UpdateInput", keySupported, KeyDown, CVar.GetCVar("drpg_menu_repetition", players[consoleplayer]).GetBool());

        return false;
    }
}

class DRPGZUtilities
{
    static int GetLevelSectorCount()
    {
        return level.Sectors.Size();
    }
    static bool CheckActorInMap(int TID)
    {
        ActorIterator AI = ActorIterator.Create(TID);
        Actor A = AI.Next();
        if (A)
            return level.IsPointInMap(A.Pos);
        else
            return false;
    }
    static play void ForceRespawn(int PlayerNum)
    {
        let player = Players[PlayerNum].mo.player;
        if (player)
        {
            player.cls = NULL;
            player.playerstate = PST_REBORN;
            if (player.mo.special1 > 2)
            {
                player.mo.special1 = 0;
            }
        }
    }
    static bool CheckForBadMap()
    {
        // Maps that have compatibility issues with DRPG
        static const string BadMaps[] =
        {
            "E1M8", // Phobos Anomaly; Tags: 666 (Floor_LowerToLowest)
            "E2M8", // Tower of Babel; Tags: None, level ends
            "E3M8", // Dis; Tags: None, level ends
            "E4M6", // Against Thee Wickedly; Tags: 666 (Door_Open)
            "E4M8", // Unto the Cruel; Tags: 666 (Floor_LowerToLowest)
            "MAP07", // Dead Simple; Tags: 666 (Floor_LowerToLowest), 667 (Floor_RaiseByTexture)
            "LEVEL07" // Baron's Banquet; Tags: 666 (Floor_LowerToLowest), 667 (Floor_RaiseByTexture)
        };

        // Check for bad map
        for (int i = 0; i < BadMaps.size(); i++)
            if (level.MapName == BadMaps[i])
                return true;

        // Good map
        return false;
    }
    static void SetHUDPreset(int Preset)
    {
        // !! If you are reading this and wish to add a preset, please remember the size of your "values" array must match drpgHUDCVars or the game will abort

        // All CVars except Character data
        static const string drpgHUDCVars[] =
        {
            "drpg_hud_height", "drpg_hud_width", "drpg_stats_y", "drpg_stats_x", "drpg_skill_y", "drpg_skill_x", "drpg_stateffect_y", "drpg_stateffect_x", "drpg_credits_y", "drpg_credits_x", "drpg_combo_y", "drpg_combo_x", "drpg_stim_y", "drpg_stim_x", "drpg_aug_y", "drpg_aug_x", "drpg_mission_x", "drpg_mission_y", "drpg_auratimer_x", "drpg_auratimer_y", "drpg_powerup_y", "drpg_powerup_x", "drpg_event_y", "drpg_event_x", "drpg_drla_y", "drpg_drla_x", "drpg_ld_y", "drpg_ld_x", "drpg_coopview_y", "drpg_coopview_x", "drpg_multiplayer_y", "drpg_multiplayer_x", "drpg_turret_y", "drpg_turret_x"
        };
        // Wide preset values
        static const int drpgHUD_Wide[] =
        {
            480, 680, 295, 645, 460, 490, 100, -100, 15, -70, 300, -100, 100, 640, 415, 700, 320, 420, -50, 415, 30, 660, 15, 235, 30, 500, 20, 335, 0, 0, 8, 80, 285, -75
        };

        // Preset options:
        // 1 = Default
        // 2 = Wide

        // Default
        if 			(Preset == 1)
        {
            // Reset HUD CVars
            for (int i = 0; i < drpgHUDCVars.size(); i++)
                CVar.GetCVar(drpgHUDCVars[i], players[consoleplayer]).ResetToDefault();
        }
        // Wide
        else if (Preset == 2)
        {
            // Set HUD CVars
            for (int i = 0; i < drpgHUDCVars.size(); i++)
                CVar.GetCVar(drpgHUDCVars[i], players[consoleplayer]).SetInt(drpgHUD_Wide[i]);
        }
    }

    static void ResetToDefaults()
    {
        // All CVars except Character data
        static const string drpgCVars[] =
        {
            "drpg_scalexp", "drpg_scalecomboxp", "drpg_xp_curve", "drpg_xp_health_awareness", "drpg_xp_summon_percent", "drpg_monster_level_cap", "drpg_monster_stat_cap", "drpg_monster_levels", "drpg_monster_level_weight", "drpg_monster_map_weight", "drpg_monster_random_min_mult", "drpg_monster_random_max_mult", "drpg_aura_curve", "drpg_monster_specialize", "drpg_monster_shadows", "drpg_monster_vitality_effect", "drpg_monster_vitality_boost", "drpg_monster_red_missileevenmore", "drpg_monster_red_missilemore", "drpg_monster_red_nofear", "drpg_monster_red_retaliation", "drpg_monster_green_dontblast", "drpg_monster_green_dontrip", "drpg_monster_green_nopain", "drpg_monster_green_noradiusdmg", "drpg_monster_green_reflective", "drpg_monster_green_shieldreflect", "drpg_monster_white_bright", "drpg_monster_white_lookallaround", "drpg_monster_white_masslevel", "drpg_monster_white_noinfighting", "drpg_monster_white_notarget", "drpg_monster_white_notargetswitch", "drpg_monster_pink_dontdrain", "drpg_monster_pink_resurrect", "drpg_monster_blue_epdrain", "drpg_monster_blue_notimefreeze", "drpg_monster_blue_seeinvisible", "drpg_monster_purple_massheal", "drpg_monster_orange_alwaysfast", "drpg_monster_orange_jumpdown", "drpg_monster_orange_notelestomp", "drpg_monster_orange_quicktoretaliate", "drpg_monster_orange_teleport", "drpg_monster_darkblue_ammodrain", "drpg_monster_yellow_moneydrain", "drpg_skill_costscale", "drpg_skill_keepauras", "drpg_skill_costcooldown", "drpg_shield_reset", "drpg_levelup_heal", "drpg_toxicity_penalties", "drpg_mission_monsterkillscount", "drpg_invulnerability_plus", "drpg_combo_damage", "drpg_monster_mapweight", "drpg_monster_population", "drpg_monster_limit", "drpg_monster_adaptive_spawns", "drpg_aurasteal_rate", "drpg_aurasteal_amount", "drpg_aura_removeondeath", "drpg_minibosses", "drpg_reinforcements", "drpg_loot_system", "drpg_lootgen_factor", "drpg_loot_rcm", "drpg_loot_crate_spc", "drpg_uac_premium", "drpg_mapevent_chance", "drpg_mapevent_eventtime", "drpg_default_par_seconds", "drpg_mapevent_megaboss", "drpg_mapevent_toxichazard", "drpg_mapevent_nuclearbomb", "drpg_mapevent_lowpower", "drpg_mapevent_allauras", "drpg_mapevent_onemonster", "drpg_mapevent_hellunleashed", "drpg_mapevent_harmonizedauras", "drpg_mapevent_teleportcracks", "drpg_mapevent_doomsday", "drpg_mapevent_acidrain", "drpg_mapevent_darkzone", "drpg_mapevent_feedingfrenzy", "drpg_mapevent_overmind", "drpg_mapevent_rainbows", "drpg_mapevent_skill_hell", "drpg_mapevent_skill_armageddon", "drpg_mapevent_sinstorm", "drpg_module_spawnfactor", "drpg_module_levelfactor", "drpg_module_statfactor", "drpg_module_skillfactor", "drpg_hard_stat_cap", "drpg_soft_stat_cap_mult", "drpg_auto_spend", "drpg_auto_spend_pref", "drpg_stat_weaponspeed", "drpg_maxspeed", "drpg_maxjump", "drpg_inv_capacity", "drpg_overdrive_limit", "drpg_levelup_natural", "drpg_allow_spec", "drpg_character_spec", "drpg_strength_scalexp", "drpg_defense_scalexp", "drpg_vitality_scalexp", "drpg_energy_scalexp", "drpg_regeneration_scalexp", "drpg_agility_scalexp", "drpg_capacity_scalexp", "drpg_luck_scalexp", "drpg_auto_heal", "drpg_auto_heal_percent", "drpg_auto_heal_order", "drpg_popoffs", "drpg_damagenumbers", "drpg_damagenumbers_fade", "drpg_modulenumbers", "drpg_damagenumbers_hud", "drpg_healthbars", "drpg_healthbars_plain", "drpg_healthbars_names", "drpg_healthbars_width", "drpg_healthbars_height", "drpg_healthbars_x", "drpg_healthbars_y", "drpg_stim_time_multiplier", "drpg_multi_takexp", "drpg_multi_takexp_percent", "drpg_multi_dropcredits", "drpg_multi_dropcredits_percent", "drpg_multi_dropinv", "drpg_multi_restoreep", "drpg_multi_restoreammo", "drpg_multi_sharecredits", "drpg_multi_revives", "drpg_shoptype", "drpg_shopspecial_type", "drpg_shopspecial_category", "drpg_shopspecial_time", "drpg_shopspecial_min", "drpg_shopspecial_max", "drpg_shopspecial_discount", "drpg_pickup_behavior", "drpg_autosell_lockerfallback", "drpg_turret_aggression", "drpg_turret_movespeed", "drpg_turret_playerdist", "drpg_turret_enemydist", "drpg_turret_pursuittime", "drpg_turret_telewaittime", "drpg_menudim", "drpg_menuhelp", "drpg_menu_hideskills", "drpg_menu_width", "drpg_menu_height", "drpg_menu_background_border", "drpg_menu_repetition", "drpg_hud_preview", "drpg_hud_width", "drpg_hud_height", "drpg_stats_x", "drpg_stats_y", "drpg_skill_x", "drpg_skill_y", "drpg_stateffect_x", "drpg_stateffect_y", "drpg_credits_x", "drpg_credits_y", "drpg_combo_x", "drpg_combo_y", "drpg_stim_x", "drpg_stim_y", "drpg_aug_x", "drpg_aug_y", "drpg_mission_x", "drpg_mission_y", "drpg_auratimer_x", "drpg_auratimer_y", "drpg_powerup_x", "drpg_powerup_y", "drpg_event_x", "drpg_event_y", "drpg_drla_x", "drpg_drla_y", "drpg_ld_x", "drpg_ld_y", "drpg_coopview_x", "drpg_coopview_y", "drpg_multiplayer_hud", "drpg_multiplayer_x", "drpg_multiplayer_y", "drpg_turret_x", "drpg_turret_y", "drpg_skill_wheelspeed", "drpg_stats_alwaysshow", "drpg_aug_alwaysshow", "drpg_drla_hud_staminabar", "drpg_debug", "drpg_debug_gui", "drpg_debug_drla", "drpg_tips", "drpg_regen_movement", "drpg_move_aug_battery_regen", "drpg_autosave", "drpg_monster_dropdist", "drpg_transport_on_new_map", "drpg_shotguns", "drpg_augs_autoreactivate", "drpg_give_quickinventory", "drpg_toaster", "drpg_simple_auras", "drpg_auras_drawdistance", "drpg_popoffs_drawdistance", "drpg_virtual_credits", "drpg_startmap", "drpg_addstartmap", "drpg_start_credits", "drpg_start_modules", "drpg_start_turretparts", "drpg_start_level", "drpg_start_rank", "drpg_start_strength", "drpg_start_defense", "drpg_start_vitality", "drpg_start_energy", "drpg_start_regeneration", "drpg_start_agility", "drpg_start_capacity", "drpg_start_luck", "drpg_start_weapon_pistol", "drpg_start_weapon_shotgun", "drpg_start_weapon_ssg", "drpg_start_weapon_chaingun", "drpg_start_weapon_rocketlauncher", "drpg_start_weapon_plasmarifle", "drpg_start_weapon_bfg", "drpg_start_weapon_chainsaw", "drpg_start_ammo_bullet", "drpg_start_ammo_shell", "drpg_start_ammo_rocket", "drpg_start_ammo_cell", "drpg_start_armor", "drpg_start_medkit", "drpg_start_aug_amount", "drpg_start_aug_canisters", "drpg_start_aug_upgrades", "drpg_start_aug_slots", "drpg_start_shield_type", "drpg_start_shield_type_acc", "drpg_start_shield_amount_body", "drpg_start_shield_amount_battery", "drpg_start_shield_amount_capacitor", "drpg_start_shield_amount_acc", "drpg_start_stim_injectors", "drpg_start_stim_vials", "drpg_start_stim_boosters", "drpg_start_stim_powerups", "drpg_start_bonus_goldchips", "drpg_start_bonus_platchips", "drpg_start_bonus_shopcard", "drpg_start_drla_weapon_type", "drpg_start_drla_weapon_amount", "drpg_start_drla_armor", "drpg_start_drla_boots", "drpg_start_drla_modpacks", "drpg_start_drla_modpacks_amount", "drpg_skillwheel_category_1", "drpg_skillwheel_index_1", "drpg_skillwheel_category_2", "drpg_skillwheel_index_2", "drpg_skillwheel_category_3", "drpg_skillwheel_index_3", "drpg_skillwheel_category_4", "drpg_skillwheel_index_4", "drpg_skillwheel_category_5", "drpg_skillwheel_index_5", "drpg_skillwheel_category_6", "drpg_skillwheel_index_6", "drpg_skillwheel_category_7", "drpg_skillwheel_index_7", "drpg_skillwheel_category_8", "drpg_skillwheel_index_8"
        };

        // Reset all CVars
        for (int i = 0; i < drpgCVars.size(); i++)
            CVar.FindCVar(drpgCVars[i]).ResetToDefault();
    }
}