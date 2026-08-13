13.08.2026 (initial) v.0.1

New:
- Added support 2.6.6 Dusted Pandemonia
- Bigfont updated to not look bad.

Knowing bugs:
- Pandemonia HUD doesent render.
- Pandemonia 2.6.6 have wrong key lump order, so they may show up in wrong color in HUD.
- Resistance rune is goofy and run acs scripts every second if 2 of them active. Rune code is in DRPGZ-PandemoniaHealth.zs.
- Reincarnation Sphere doesnt work and replaced with 3-Up (salvation sphere has ben replaced with 1-Up).

Knowing issues (my opinion):
- Bigfont are not really visible for some people.

- Pandemonia monster spawn events and pursuer bosses is separate thing from DRPG
- Pursuer bosses can appear on the arena maps
- Pursuer bosses count maps that player enters again (except Outpost, i think) (they don`t appear there, because Dusted coded that)
- Monsters HP in default hpbar is not that visible with SMALLFNT (don`t know how to fix it - replacing a class is not work) (SMALLFNT need for Pandemonia in events names)

DRPG Scripts changes:
- Outpost.c:
	-Changed keys check to be compatable with Pandemonia.


Credits:
All from Dusted Pandemonia, so those credits are valid.