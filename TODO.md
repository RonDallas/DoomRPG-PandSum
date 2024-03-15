Quick Stuff
===

General
===
- Re-check all default settings, see how they feel, etc
- Powerup icon animations on the HUD that use ANIMDEFS are no longer working for some reason//[alien] is this considered done
- Add combo stuff to rank payout level section//[alien] is this considered done
- Clean up the crate hacking interface a bit (use IDs, prevent overlaps, etc)//[alien] is this considered done
- Rework the way auras drop items; in particular, use the Inventory Transfer flag to make enemies drop backpacks
- Add more CVARs to customize the loot generator (how it calculates max items in particular, player level, player luck, map number, combinations, etc)
- Add a ticker/notice display for different events (shop special item changes, rolling events, reinforcement spawns, etc)

DRLA
===
- DRLA HUD needs it's drawing order reviewed to make sure nothing is overlapping with each other
- Double-check all DRLA icons, sprites, info and etc in the ItemData
- DRLA ammo counters for synthfire weapons are reversed on the HUD
- Double-check that all DRLA assembly tokens are actually saved with the charsave system
- Investigate the Death's Gazes artifact stunning power pissing off marines and other Outpost appliances when it's already got a check not to
- Add immunity to megabosses from the Death's Gaze death stunlock
- Add a DRLA only corrupted player event, fuck you die // [alien] is this the thing where you steall from the base
- Add Utility skills similar to DRLA's skulls
  - Ditto for recall phase device (mark/recall system)

Events
===
- Sinstorm's demon spawn cubes spawn monsters inside of walls and each other, which frankly looks silly as hell// [alien] spawning inside of each other is a default since monsters only telefrag on map 30
- Event object spawning (Power column, Radiation Neutralizer) needs to be randomized so that it doesn't consistently spawn in awkward places

Brightmaps
===
- Turret parts crate
- UAC supply crate

Sounds
===
- Many skill usage sounds are placeholders and need replacing
- Status effect hit and avoid sounds are also placeholders
- Add ambient stingers for when the music is off, just to fuck with you :D

QoL
===


Bugs
===
- Modpack save/load is broken
- Infinite ammo related buffs are broken
- Furious Fusion stops working every time you sell a weapon? // [SW] This item doesn't appear to exist.
- Look into summons always attacking the Force Wall object // [SW] Couldn't reproduce.
- Nuclear bomb event HUD not removed on next map if you escape rather than defuse // [SW] Couldn't reproduce.
- Co-op PIP is still not working properly

New Augmentation System
===
- Upgrading effects will have different benefits depending on the effect type
  - Static effects offer a few levels and change fairly drastically between upgrades
  - Scaled effects have a max level of 100 and scale their bonus slowly
  - Optimized effects have 10? levels which decrease the battery usage, but don't modify the effect at all
- Slot upgrades can only be used on a single category, which will increase the maximum effects you can have active in the specified category by 1
- Some effects will only discharge battery when used or triggered, while others discharge passively while active

New Shield System
===
To be rewritten into a more randomized parts system which is easier to handle and maintain, details later//[alien] is this considered done

Sprinting/Dodging System
===
- This can utilize DRLA's existing stamina system, don't really see any point in having such a system in vanilla where the enemies are much less varied and agile// [alien] the stamina bar does not display properly which is problematic for using berserk

Rewrites/Reorganization
===
- GUI System, Finish the GUI library and move all menu and related things to using it
- Arena System to support separate arena maps and their own self-contained scripting// [alien] is this considered done

Lexicon and Compendium
===
- integrate all meaningful dehacked enemies into doomrpg's stat system
  - going down is missing its dehacked stuff
  - further refinement of sunder hive mother and other elements
- add missing maps to:
  - back to saturn x ep1
  - sunder
  - the original 1994 maps that where turned up from the 1994 tu
- better support for non lexicon, compendium, or wadsmosh wads
- wads that need support even if the above can not be found
  - doom 404
  - back to saturn x ep2
  - tnt: revolution
  - plutonia  2
