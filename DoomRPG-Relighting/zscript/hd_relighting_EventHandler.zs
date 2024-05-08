class hd_relighting_EventHandler : EventHandler
{
	/******************************************************************************/
	// constants
	static const int LSpecials[] = { 21, 22, 23, 24, 1, 2, 3, 4, 65, 66, 67, 68, 76, 77, 197, 198, 199, 200 }; // light specials
	// flashlight classes for mod compatibility
	static const string Flights[] = 
	{
		"bdflashlight",
		"flashlightpluslight",
		"darkdoomz_spotlight",
		"actorheadlight",
		"flashlightbeam1",
		"flashlightbeam2",
		"flashlightbeam3",
		"flashlightbeam4",
		"flashlightbeam5",
		"flashlightbeam6",
		"flashlightbeam7",
		"flashlightbeam8",
		"flashlightbeam9",
		"flashlightbeam10",
		"flashlightbeam11",
		"flashlightbeam12",
		"flashlightbeam13",
		"flashlightbeam14",
		"flashlightbeam15",
		"flashlightbeam16",
		"flashlightbeam17",
		"flashlightbeam18",
		"flashlightbeam19"
	};
	/******************************************************************************/
	// variables
	Array<color> palette, flat_color, cobj;
	Array<float> fscale;
	Array<string> lobj, flats, anim, voxel;
	Array<int> seclights, secmissiles;
	Array<hd_sectors> secs;
	double sky_light, indoor_light;
	int missile_shadows, monster_shadows, other_shadows, player_light, hd_added, num_sprites, rl_sprite_min, rl_sprite_max;
	string screentext;
	bool bplayer_shadows_on_self, bBDflashlight;
	Actor BDflashlight;
	Array<int> bled;

	/******************************************************************************/
	// override functions
	override void PlayerSpawned(PlayerEvent e)
	{
		let rl_Cvar = rl_Cvars.get();
		rl_Cvar = rl_Cvars.get();
		if (rl_CVar.rl_shader.GetBool())
		{
			// DRPG Compatibility; Prevents Shadow Aura effect from becoming white/corrupted
			PPShader.SetUniform1f("hd_shader", "rl_gamma", 0.0);

			PPShader.SetUniform1f("hd_shader", "rl_saturation", rl_Cvar.rl_saturation.GetFloat());
			PPShader.SetUniform1f("hd_shader", "rl_bleeding", rl_Cvar.rl_bleeding.GetFloat());
			PPShader.SetUniform1f("hd_shader", "rl_rg_bleeding", rl_Cvar.rl_bleeding.GetBool() ? 1 : 0);
			PPShader.SetEnabled("hd_shader", true);
		}
		else
		{
			PPShader.SetEnabled("hd_shader", false);
		}
		bplayer_shadows_on_self = rl_CVar.rl_player_shadows_on_self.GetBool();
		if (rl_Cvar.rl_player_shadows.GetBool())
		{
			players[consoleplayer].mo.A_GiveInventory("hd_shade", 1);
			Actor ptr = players[consoleplayer].mo.FindInventory("hd_shade");
			if (ptr)
			{
				ptr.PostBeginPlay();
			}
		}
		bBDflashlight = false;
	}
	override void WorldUnLoaded(WorldEvent e)
	{
		PPShader.SetEnabled("hd_shader", false);
	}
	override void WorldLineActivated(WorldEvent e)
	{
		if (e.ActivatedLine)
		{
			Line lin = e.ActivatedLine;
			if (lin.Special == 11) // door open and stay (can destroy light switch)
			{
				let it = LevelLocals.CreateSectorTagIterator(lin.Args[0]);
				int sec_num;
				sec_num = it.Next();
				if (sec_num == 0 || sec_num == -1)
				{
					sec_num = lin.BackSector.SectorNum;
				}

				Actor thing = Level.Sectors[sec_num].ThingList;
				while (thing)
				{
					string cname = thing.GetClassName();
					cname = cname.MakeLower();
					if (cname == "hd_lightswitch")
					{
						if (thing) thing.Args[0] = lin.Special;
						break;
					}
					thing = thing.snext;
				}
			}
			if (lin.Special == 228) // raise to nearest floor, reset color
			{
				let it = LevelLocals.CreateSectorTagIterator(lin.Args[0]);
				int sec_num;
				while (sec_num = it.Next())
				{
					if (sec_num == -1) break;
					Sector sec = Level.Sectors[sec_num];
					sec.SetColor(color(255,255,255));
					sec.SetAdditiveColor(Sector.Ceiling, color(0, 0, 0));
					sec.SetAdditiveColor(Sector.Floor, color(0, 0, 0));
				}
			}
			if (lin.Special == 250) // floor donut test, reset color
			{
				let it = LevelLocals.CreateSectorTagIterator(lin.Args[0]);
				int sec_num;
				while (sec_num = it.Next())
				{
					if (sec_num == -1) break;

					Sector sec = Level.Sectors[sec_num];
					for (int ii = 0; ii < sec.Lines.Size(); ii++)
					{
						Line llin = sec.Lines[ii];
						Sector back = backSector(sec, llin);
						if (back)
						{
							back.SetColor(color(255,255,255));
							back.SetAdditiveColor(Sector.Ceiling, color(0, 0, 0));
							back.SetAdditiveColor(Sector.Floor, color(0, 0, 0));
							break;
						}
					}
				}
			}
		}
	}
	override void WorldLoaded(WorldEvent e)
	{
 		let rl_Cvar = rl_Cvars.get();
		if (rl_Cvar.rl_reset.GetBool()) rl_Cvar.setDefaults();
		int FLOOR = 0, CEILING = 1;
		int startlump;
		Texman texture;
		missile_shadows = 0;
		monster_shadows = 0;
		other_shadows = 0;
		player_light = -1;
		for (int i=0; i < 2049; i++) fscale.Push(i * 0.0078125);

		/******************************************************************************/
		// analyze lumps and map data
		// find the last palette
		startlump = 0;
		int lastfound = 0;
		while (true)
		{
			int fhnd = Wads.FindLump("PLAYPAL", startlump, Wads.ANYNAMESPACE);
			if (fhnd == -1) break;
			lastfound = startlump;
			startlump = fhnd + 1;
		}
		// add palette colors
		int fhnd = Wads.FindLump("PLAYPAL", lastfound, Wads.ANYNAMESPACE);
		string flump = Wads.ReadLump(fhnd);
		for (int ii = 0; ii < 768; ii += 3) palette.Push(Color(flump.ByteAt(ii), flump.ByteAt(ii + 1), flump.ByteAt(ii + 2)));
		// add flat names
		for(int i = 0; i < Level.Sectors.Size(); i++)
		{
			Sector sec = Level.Sectors[i];
			if (sec.Lines.Size() == 0) continue;
			if (flats.Find(texture.GetName(sec.GetTexture(FLOOR))) == flats.Size()) flats.Push(texture.GetName(sec.GetTexture(FLOOR)));
			if (flats.Find(texture.GetName(sec.GetTexture(CEILING))) == flats.Size()) flats.Push(texture.GetName(sec.GetTexture(CEILING)));
		}
		// find sky colors... TO DO Hexen allows for two different skies
		// NOTE does not find sky patches e.g. TNT / Plutonia
		color sky_color = "#000000";
		while (true)
		{
			string sky = texture.GetName(Level.SkyTexture1);
			int fhnd = Wads.FindLump(sky, 0, Wads.ANYNAMESPACE);
			if (fhnd == -1) break;
			textureid textid = texture.CheckForTexture(sky, Texman.TYPE_WALLPATCH);
			int width, height;
			[width, height] = texture.GetSize(textid);
			string flump = Wads.ReadLump(fhnd);
			int bptr = 8;
			// column pointers
			for (int i = 8; i < (width * 4); i+=4) bptr++;
			// rows
			int n = 0, r = 0, g = 0, b = 0;
			while (bptr++ < flump.Length())
			{
				int row_start = flump.ByteAt(bptr++);
				if (row_start == 255) break;

				int pixel_count = flump.ByteAt(bptr++);
				int dummy_value = flump.ByteAt(bptr++);

				for (int i = 0; i < pixel_count; i++)
				{
					color temp = palette[flump.ByteAt(bptr++)];
					bool keep;
					int perceived, howred, howgreen, howblue;
					[keep, perceived, howred, howgreen, howblue] = keepthecolor(temp);
					if (keep)
					{
						r += temp.r;
						g += temp.g;
						b += temp.b;
						n++;
					}
				}
				dummy_value = flump.ByteAt(bptr++);
			}
			if (n > 0) sky_color = Color(int(clamp(r/n,0,255)), int(clamp(g/n,0,255)), int(clamp(b/n,0,255)));
			break;
		}
		// add flat colors
		for (int i = 0; i < flats.Size(); i++)
		{
			int startlump = 0;
			color c = "#000000";
			while (true)
			{
				// flat name marker for sky contains SKY in most cases
				if (flats[i].IndexOf("SKY") != -1) break;
				int fhnd = Wads.FindLump(String.Format("%s", flats[i]), startlump, Wads.ANYNAMESPACE);
				if (fhnd == -1) break;
				startlump = fhnd + 1;
				textureid textid = texture.CheckForTexture(flats[i], Texman.TYPE_FLAT);
				int width, height;
				[width, height] = texture.GetSize(textid);
				// check valid sizes
				if (width == 64 && height != 64 && height != 65 && height != 128) continue;
				if (width == 128 && height != 128) continue;
				if (width == 256 && height != 256) continue;
				string flump = Wads.ReadLump(fhnd);
				int n = 0, r = 0, g = 0, b = 0;
				for (int ii = 0; ii < flump.Length(); ii++)
				{
					color temp = palette[flump.ByteAt(ii)];
					bool keep;
					int perceived, howred, howgreen, howblue;
					[keep, perceived, howred, howgreen, howblue] = keepthecolor(temp);
					if (keep)
					{
						r += temp.r;
						g += temp.g;
						b += temp.b;
						n++;
					}
				}
				if (n > 0) c = Color(int(clamp(r/n,0,255)), int(clamp(g/n,0,255)), int(clamp(b/n,0,255)));
				break;
			}
			flat_color.Push(c);
		}
		// indoor color
		color indoor_color = "#000000";
		while (true)
		{
			int r, g, b, n;
			for (int i = 0; i < flat_color.Size(); i++)
			{
				color c = flat_color[i];
				if (c.r || c.g || c.b)
				{
					r += c.r;
					g += c.g;
					b += c.b;
					n++;
				}
			}
			if (n > 0) indoor_color = Color(int(clamp(r/n,0,255)), int(clamp(g/n,0,255)), int(clamp(b/n,0,255)));
			break;
		}
		// read all gldefs objects and colors
		Array<string> ldata,fdata,ldefs,cdata;
		Array<color> cavg;
		startlump = 0;
		ldata.Clear();
		while (true)
		{
			int fhnd = Wads.FindLump("gldefs", startlump, Wads.ANYNAMESPACE);
			if (fhnd == -1) break;
			startlump = fhnd + 1;
			fdata.Clear();
			string flump = Wads.ReadLump(fhnd);
			if (flump.IndexOf("\r\n") != -1)
			{
				flump.Replace("\r\n", " ");
			}
			else
			{
				flump.Replace("\n", " ");
			}
			flump.Replace("\t", " ");
			flump.Replace("} ", "");
			flump.Replace("{ ", "");
			flump.split(fdata, " ");
			ldata.Append(fdata);
		}
		if (ldata.Size() > 0)
		{
			// remove all empties
			int i = 0;
			while (i < ldata.Size())
			{
				if (ldata[i].length() == 0)
				{
					ldata.Delete(i);
				}
				else
				{
					i++;
				}
			}
			ldata.ShrinkToFit();
			// remove single / double entries we don't need
			i = 0;
			while (i < ldata.Size())
			{
				if (ldata[i] ~== "frame" || ldata[i] ~== "size" || ldata[i] ~== "secondarysize" || ldata[i] ~== "chance" || ldata[i] ~== "attenuate" || ldata[i] ~== "interval" || ldata[i] ~== "dontlightself") // put into an array
				{
					ldata.Delete(i + 1);
					ldata.Delete(i);
				}
				else if (ldata[i] ~== "offset")
				{
					ldata.Delete(i + 3);
					ldata.Delete(i + 2);
					ldata.Delete(i + 1);
					ldata.Delete(i);
				}
				else if (ldata[i] ~== "iwad" || ldata[i] ~== "disablefullbright" || ldata[i] ~== "brightmap" || ldata[i] ~== "sprite" || ldata[i] ~== "map") // put into an array
				{
					ldata.Delete(i);
				}
				else if (ldata[i].MakeLower().IndexOf("brightmaps") != -1)
				{
					ldata.Delete(i);
				}
				else if (ldata[i].ToDouble() > 0 && ldata[i].IndexOf(".") == -1)
				{
					ldata.Delete(i);
				}
				else if (ldata[i] == "0")
				{
					ldata.Delete(i);
				}
				else
				{
					i++;
				}
			}
			ldata.ShrinkToFit();
			// combine & delimit entries
			i = 0;
			while (i < ldata.Size())
			{
				if (ldata[i] ~== "object" || ldata[i] ~== "light")
				{
					ldata[i] = String.Format("%s|%s",ldata[i],ldata[i + 1]);
					ldata.Delete(i + 1);
				}
				else if (ldata[i] ~== "color")
				{
					ldata[i - 1] = String.Format("%s|%s|%s|%s|%s",ldata[i - 1],ldata[i],ldata[i + 1],ldata[i + 2],ldata[i + 3]);
					ldata.Delete(i + 3);
					ldata.Delete(i + 2);
					ldata.Delete(i + 1);
					ldata.Delete(i);
				}
				else
				{
					i++;
				}
			}
			ldata.ShrinkToFit();
			// remove useless entries
			i = 0;
			while (i < ldata.Size())
			{
				if (ldata[i].IndexOf("|") == -1)
				{
					ldata.Delete(i);
				}
				else
				{
					i++;
				}
			}
			ldata.ShrinkToFit();
			// append light colors
			i = 0;
			while (i < ldata.Size())
			{
				if (ldata[i].Left(6) ~== "light|" && ldata[i].IndexOf("|color|") == -1)
				{
					Array<string> sarr;
					ldata[i].Split(sarr, "|"); // sarr[i] is name of the light
					sarr[1] = String.Format("%s|",sarr[1]);
					int j = 0;
					while (j < ldata.Size())
					{
						if (ldata[j].Left(sarr[1].length()) ~== sarr[1] && ldata[j].IndexOf("|color|") != -1)
						{
							ldata[i] = String.Format("light|%s", ldata[j]);
							break;
						}
						else
						{
							j++;
						}
					}
				}
				i++;
			}
			// remove anything that isn't a light or an object
			i = 0;
			while (i < ldata.Size())
			{
				if (ldata[i].Left(6) ~== "light|" || ldata[i].Left(7) ~== "object|")
				{
					i++;
				}
				else
				{
					ldata.Delete(i);
				}
			}
			ldata.ShrinkToFit();
		}
		while (ldata.Size())
		{
			if (ldata[0].Left(7) ~== "object|" && ldata.Size() > 1)
			{
				if (ldata[1].Left(7) ~== "object|")
				{
					ldata.Delete(0);
					continue;
				}
				if (ldata[1].Left(6) ~== "light|" && ldata[1].IndexOf("|color|") != -1)
				{
					lobj.Push(ldata[0].Mid(7).MakeLower());
					Array<string> sarr;
					ldata[1].Split(sarr, "|");
					color c = color(int(255 * sarr[3].ToDouble()),int(255 * sarr[4].ToDouble()),int(255 * sarr[5].ToDouble()));

					if (c.b > c.r || c.b > c.g)
					{
						c = tint(c, 0.8);
					}
					else
					{
						c = tint(c, -0.8);
					}

					cobj.Push(c);
					while (ldata[1].Left(6) ~== "light|" && ldata[1].IndexOf("|color|") != -1)
					{
						ldata.Delete(1);
						if (ldata.Size() == 1) break;
					}
					ldata.Delete(0);
					ldata.ShrinkToFit();
				}
				else
				{
					ldata.Delete(1);
					ldata.ShrinkToFit();
				}
			}
			else
			{
				ldata.Delete(0);
				ldata.ShrinkToFit();
			}
		}
		// add animdef pic names (most are probably wall textures) - ? add texture lights to these ?
		startlump = 0;
		while (true)
		{
			int fhnd = Wads.FindLump("animdefs", startlump, Wads.ANYNAMESPACE);
			if (fhnd == -1) break;
			startlump = fhnd + 1;
			string flump = Wads.ReadLump(fhnd);
			ldata.clear();
			if (flump.IndexOf("\r\n") != -1)
			{
				flump.split(ldata, "\r\n");
			}
			else
			{
				flump.split(ldata, "\n");
			}
			for (int i = 0; i < ldata.Size(); i++)
			{
				if (ldata[i].Left(4).MakeLower() == "pic ")
				{
					Array<string> item;
					ldata[i].Split(item, " "); // one space is assumed between object and cname

					if (item.Size() > 2)
					{
						if (flats.Find(item[1]) != flats.size())
						{
							if (anim.Find(item[1]) == anim.Size()) anim.Push(item[1]);
						}
					}
				}
			}
		}
		// add voxel sprite names - these do not generate FLATSPRITE actors
		crosswalk cwalk = new ("crosswalk").init();
		startlump = 0;
		while (true)
		{
			int fhnd = Wads.FindLump("voxeldef", startlump, Wads.ANYNAMESPACE);
			if (fhnd == -1) break;
			startlump = fhnd + 1;
			string flump = Wads.ReadLump(fhnd);
			ldata.clear();
			if (flump.IndexOf("\r\n") != -1)
			{
				flump.split(ldata, "\r\n");
			}
			else
			{
				flump.split(ldata, "\n");
			}
			for (int i = 0; i < ldata.Size(); i++)
			{
				if (ldata[i].IndexOf("{") != -1) // = does not work - look at an escape character for =
				{
					Array<string> item;
					ldata[i].Split(item, " "); // one space is assumed between sprite name and =
					if (item.Size() > 1)
					{
						if (voxel.Find(item[0]) == voxel.Size() && cwalk.getswap(item[0].Left(4).MakeUpper()) == "NOTFOUND") voxel.Push(item[0].MakeLower());
					}
				}
			}
		}

		for (int i=0; i < voxel.Size(); i++) console.printf(voxel[i]);

		// get sector areas and lights
		double sky_area = 0.0;
		sky_light = 0.0;
		double indoor_area = 0.0;
		indoor_light = 0.0;
		int sky_secs = 0;
		int indoor_secs = 0;
		Array<double> secareas;
		for(int i = 0; i < Level.Sectors.Size(); i++)
		{
			secmissiles.Push(0);
			Sector sec = Level.Sectors[i];
			bool sky = (sec.GetTexture(CEILING) == SkyFlatNum);
			if (sec.Lines.Size() == 0)
			{
				seclights.Push(0); // ensure 1:1
				continue;
			}
			double area = polygonarea(sec);
			secs.Push(new ("hd_sectors").init(sec.SectorNum, area));

			seclights.Push(sec.LightLevel);

			if (sky)
			{
				sky_secs++;
				sky_area += area;
				sky_light += sec.LightLevel;
			}
			else
			{
				indoor_secs++;
				indoor_area += area;
				indoor_light += sec.LightLevel;
			}
		}
		if (sky_secs) sky_light /= sky_secs;
		if (indoor_secs) indoor_light /= indoor_secs;
		quickSort(secs, 0, secs.Size()-1);
		double max_area = rl_Cvar.rl_sector_area_max.GetInt() == 0 ? secs[0].area : rl_Cvar.rl_sector_area_max.GetInt();
		for(int i = 0; i < secs.Size(); i++)
		{
			if (secs[i].area >= rl_Cvar.rl_sector_area_min.GetInt() && secs[i].area <= max_area) secareas.Push(secs[i].area);
		}
		double skewness = secareas.Size() > 1 ? skew(secareas) : 1.0;
		double min_area = rl_Cvar.rl_sector_area_min.GetInt();
		if (secareas.Size() != 0) min_area = skewness > 1.0 ? secareas[secareas.Size() - 1] *= skewness : secareas[secareas.Size() - 1];
		int j = secareas.Size();
		for (int i = 0; i < secareas.Size(); i++)
		{
			if (secareas[i] <= min_area)
			{
				j = i;
				break;
			}
		}
		double median_area = secs[int(j * 0.5)].area;
		// get sprite heights
		rl_sprite_min = rl_Cvar.rl_sprite_max.GetInt();
		rl_sprite_max = rl_Cvar.rl_sprite_min.GetInt();
		num_sprites = 0;
		for(int i = 0; i < Level.Sectors.Size(); i++)
		{
			Sector sec = Level.Sectors[i];
			Actor thing = sec.ThingList;
			while (thing)
			{
				double sprite_height = texture.CheckRealHeight(thing.CurState.GetSpriteTexture(0));
				if (texture.GetName(thing.CurState.GetSpriteTexture(0)) == "TNT1A0") sprite_height = thing.Height;

				if (sprite_height >= rl_Cvar.rl_sprite_min.GetInt() && sprite_height <= rl_Cvar.rl_sprite_max.GetInt())
				{
					num_sprites++;
					if (sprite_height < rl_sprite_min) rl_sprite_min = sprite_height;
					if (sprite_height > rl_sprite_max) rl_sprite_max = sprite_height;
				}
				thing = thing.snext;
			}
		}
		// adjust sprite heights
		double f = 0.0;
		if (num_sprites > 1250)
		{
			f = .06;
		}
		else if (num_sprites > 1000)
		{
			f = .05;
		}
		else if (num_sprites > 750)
		{
			f = .04;
		}
		else if (num_sprites > 500)
		{
			f = .03;
		}
		rl_sprite_min += int(num_sprites * f);
		/******************************************************************************/
		// adjust sector light and color
		Array<Actor> extra_lights;
		Array<int> lights;
		Array<int> clights;
		Array<int> bleeding;
		for(int i = 0; i < secs.Size(); i++)
		{
			Sector sec = Level.Sectors[secs[i].sec];
			bool sky = (sec.GetTexture(CEILING) == SkyFlatNum);
			string ftext = texture.GetName(sec.GetTexture(FLOOR));
			string fbase = ftext.Left(ftext.Length() -1);
			if (ftext.IndexOf("_") < 3 && 
			(ftext.IndexOf("1") == ftext.Length() -1 || ftext.IndexOf("2") == ftext.Length() -1 || ftext.IndexOf("3") == ftext.Length() -1 || ftext.IndexOf("4") == ftext.Length() -1) &&
			(ftext.IndexOf("01") == -1 && ftext.IndexOf("02") == -1 && ftext.IndexOf("03") == -1 && ftext.IndexOf("04") == -1) &&
			(ftext.IndexOf("11") == -1 && ftext.IndexOf("12") == -1 && ftext.IndexOf("13") == -1 && ftext.IndexOf("14") == -1) &&
			(ftext.IndexOf("FLAT") == -1 && ftext.IndexOf("CEIL") == -1 && ftext.IndexOf("FLOOR") == -1 && ftext.IndexOf("ROCK") == -1))
			{
				Array<string> fseeks;
				fseeks.Push(String.Format("%s1",fbase));
				fseeks.Push(String.Format("%s2",fbase));
				fseeks.Push(String.Format("%s3",fbase));
				if (anim.Find(fseeks[0]) != anim.Size() && anim.Find(fseeks[1]) != anim.Size() && anim.Find(fseeks[2]) != anim.Size())
				{
					secs[i].anim = true;
				}
				else
				{
					bool b = true;
					startlump = 0;
					for (int i = 0; i < 3; i++)
					{
						int fhnd = Wads.FindLump(fseeks[i], startlump, Wads.ANYNAMESPACE);
						if (fhnd == -1)
						{
							b = false;
							break;
						}
					}
					if (b)
					{
						anim.Push(fseeks[0]);
						anim.Push(fseeks[1]);
						anim.Push(fseeks[2]);
						secs[i].anim = true;
					}
				}
			}
			// volumetric adjustment
			if (rl_Cvar.rl_vol_adj_sectors.GetBool() && !sky && !isSpecial(sec))
			{
				bool ckeep;
				int cperceived,chowred,chowgreen,chowblue;
				Color cc = flat_color[flats.Find(texture.GetName(sec.GetTexture(CEILING)))];
				[ckeep, cperceived, chowred, chowgreen, chowblue] = keepthecolor(cc);
				if (ckeep && cperceived > rl_Cvar.rl_sector_light_min.GetInt() / rl_CVar.rl_dim_min.GetFloat()) ///////////// test DIV/0
				{
					sec.LightLevel = clamp(sec.LightLevel + int(secs[i].volume / 144), 0, 255);
				}
				else
				{
					bleeding.Push(secs[i].sec);
					if (sec.LightLevel >= int(rl_Cvar.rl_sector_light_min.GetInt() / rl_CVar.rl_dim_min.GetFloat())) ///////////////// test DIV/0
					{
						sec.LightLevel = clamp(sec.LightLevel - int(secs[i].volume / 144), 
							int(sec.LightLevel * clamp(rl_CVar.rl_dim_min.GetFloat() * 1.01, rl_CVar.rl_dim_min.GetFloat(), 1.0)), 255);

						sec.SetPlaneLight(CEILING, int(sec.LightLevel * 0.1));
						sec.SetPlaneLight(FLOOR, int(sec.LightLevel * 0.1));
					}
					else
					{
						sec.LightLevel = clamp(sec.LightLevel - int(secs[i].Height / (32 * rl_CVar.rl_dim_min.GetFloat())), 0, sec.LightLevel); ///////////////// test
					}
				}
			}
			// add reflections
			if (rl_Cvar.rl_floor_reflections.GetBool() || rl_Cvar.rl_anim_reflections.GetBool())
			{
				Color fc = flat_color[flats.Find(texture.GetName(sec.GetTexture(FLOOR)))];
				bool fkeep;
				int fperceived,fhowred,fhowgreen,fhowblue;
				[fkeep, fperceived, fhowred, fhowgreen, fhowblue] = keepthecolor(fc);

				int tag_seed = CVar.FindCvar("rl_floor_seed").GetInt();
				if (anim.Find(texture.GetName(sec.GetTexture(FLOOR))) != anim.Size() && rl_Cvar.rl_anim_reflections.GetBool())
				{
					double f = fperceived < rl_CVar.rl_floor_value.GetInt() ? rl_CVar.rl_floor_value.GetInt() : fperceived;
					int r_value = int(rl_CVar.rl_floor_value.GetInt() + 1 / f * 1000);
					Sector_SetPlaneReflection(tag_seed + int(sec.GetTexture(FLOOR)), r_value, 0);
				}
				else if (rl_Cvar.rl_floor_reflections.GetBool())
				{
					if (fperceived >= rl_Cvar.rl_colored_perceived.GetInt()) // || fhowred > fhowgreen)
					{
						Sector_SetPlaneReflection(tag_seed + int(sec.GetTexture(FLOOR)), rl_CVar.rl_floor_value.GetInt(), 0);
					}
				}
			}
			// set color ceiling > floor
			if (rl_Cvar.rl_colored_sectors.GetBool())
			{
				Color fc = flat_color[flats.Find(texture.GetName(sec.GetTexture(FLOOR)))];
				Color cc = sky ? sky_color : flat_color[flats.Find(texture.GetName(sec.GetTexture(CEILING)))];
				bool fkeep;
				int fperceived,fhowred,fhowgreen,fhowblue;
				bool ckeep;
				int cperceived,chowred,chowgreen,chowblue;
				[fkeep, fperceived, fhowred, fhowgreen, fhowblue] = keepthecolor(fc);
				[ckeep, cperceived, chowred, chowgreen, chowblue] = keepthecolor(cc);
				if (sky && (cc.r + cc.g + cc.b))
				{
					if (cc.r > cc.g + cc.b)
					{
						sec.SetColor(shade(cc, cc.r / ((cc.g + cc.b) * 2)));
					}
					else
					{
						sec.SetColor(shade(cc, -0.3));
					}
					if (!isSpecial(sec) && sec.LightLevel > 0 && cperceived > sec.LightLevel) sec.LightLevel = int(sec.LightLevel * cperceived / (sec.LightLevel * 0.98));
				}
				else if (!sky && (fc.r + fc.g + fc.b + cc.r + cc.g + cc.b))
				{
					if (fkeep && !ckeep)
					{
						sec.SetColor(fc);
						sec.SetAdditiveColor(FLOOR, shade(fc, -3.0));
					}
					else if (ckeep && !fkeep)
					{
						lights.Push(secs[i].sec);
						clights.Push(secs[i].sec);
						sec.SetColor(shade(cc, 2.5));
						sec.SetAdditiveColor(CEILING, shade(fc, -3.0));
						if (!isSpecial(sec) && cperceived > 160) sec.SetPlaneLight(CEILING, int(cperceived * 0.3));
						if (!isSpecial(sec) && sec.LightLevel > 0 && cperceived > sec.LightLevel) sec.LightLevel = int(sec.LightLevel * cperceived / (sec.LightLevel * 1.0));
					}
					else if (fkeep && ckeep)
					{
						if (cperceived > fperceived && cperceived > rl_Cvar.rl_colored_perceived.GetInt())
						{
							lights.Push(secs[i].sec);
							clights.Push(secs[i].sec);
							sec.SetColor(shade(cc, 2.5));
							sec.SetAdditiveColor(CEILING, shade(fc, -3.0));
							if (!isSpecial(sec) && cperceived > 160) sec.SetPlaneLight(CEILING, int(cperceived * 0.3));
							if (!isSpecial(sec) && sec.LightLevel > 0 && cperceived > sec.LightLevel) sec.LightLevel = int(sec.LightLevel * cperceived / (sec.LightLevel * 1.0));
						}
						else if ((fhowred > chowred && fhowred > rl_Cvar.rl_colored_howred.GetInt()) || (fhowgreen > chowgreen && fhowgreen > rl_Cvar.rl_colored_howgreen.GetInt()))
						{
							sec.SetColor(shade(fc, 1.5));
							sec.SetAdditiveColor(FLOOR, shade(fc, -3.0));
						}
						else if (chowred > fhowred || chowgreen > fhowgreen)
						{
							lights.Push(secs[i].sec);
							clights.Push(secs[i].sec);
							sec.SetColor(cc);
							sec.SetAdditiveColor(CEILING, shade(fc, -3.0));
							if (!isSpecial(sec) && sec.LightLevel > 0 && cperceived > sec.LightLevel) sec.LightLevel = int(sec.LightLevel * cperceived / (sec.LightLevel * 1.0));
						}
						else if (fperceived > cperceived && fperceived > rl_Cvar.rl_colored_perceived.GetInt())
						{
							sec.SetColor(shade(fc, 1.5));
							sec.SetAdditiveColor(FLOOR, shade(fc, -3.0));
						}
					}
				}
				if (secs[i].anim)
				{
					sec.SetGlowColor(FLOOR, shade(fc, 0.8));
					sec.SetGlowHeight(FLOOR, int(fperceived));
					if (!isSpecial(sec) && fperceived > sec.LightLevel) sec.SetPlaneLight(FLOOR, int((fperceived + sec.LightLevel) * 0.5));
				}
			}
			seclights[secs[i].sec] = sec.LightLevel;
		}
		/******************************************************************************/
		// add fog snapped to grid (rare)
		if (rl_Cvar.rl_sector_fog.GetBool())
		{
			for(int i = 0; i < secs.Size(); i++)
			{
				Sector sec = Level.Sectors[secs[i].sec];
				if (sec.Lines.Size() < 3) continue;
				bool aligned = true;
				double shortest = double.infinity;
				Line slin;
				for (int ii = 0; ii < sec.Lines.Size(); ii++)
				{
					Line lin = sec.Lines[ii];
					if (lin.V1.P.x % 64 != 0 || lin.V1.P.y % 64 != 0 || lin.delta.length() % 64 != 0)
					{
						aligned = false;
						break;
					}
					if (lin.delta.length() < shortest)
					{
						shortest = lin.delta.length();
						slin = lin;
					}
				}
				if (aligned)
				{
					Color fc = flat_color[flats.Find(texture.GetName(sec.GetTexture(FLOOR)))];
					Color cc = flat_color[flats.Find(texture.GetName(sec.GetTexture(CEILING)))];
					Color c;
					if (cc.r + cc.g + cc.b)
					{
						c = cc;
					}
					else if (fc.r + fc.g + fc.b)
					{
						c = fc;
					}
					else
					{
						continue;
					}
					bool keep;
					int perceived,howred,howgreen,howblue;
					[keep, perceived, howred, howgreen, howblue] = keepthecolor(c);

					if (perceived > 192)
					{
						sec.SetFade(shade(c, -2.0));
					}
					else
					{
						sec.SetFade(shade(c, -3.0));
					}
					vector2 v2;
					if (slin.BackSector == sec) v2 = backline(slin);
					if (slin.FrontSector == sec) v2 = frontline(slin);
					Actor ptr = Actor.Spawn("hd_fogger", (v2.x, v2.y, sec.FloorPlane.ZAtPoint(v2)));
				}
			}
		}
		hd_added = 0;
		/******************************************************************************/
		// add hdlightsources, hd_lightswitches
		for(int i = 0; i < secs.Size(); i++)
		{
			Sector sec = Level.Sectors[secs[i].sec];
			if (secs[i].centerZ == 0 && rl_Cvar.rl_sectors.GetBool())
			{
				secs[i].cspot = cspot(sec);
				Actor ptr = Actor.Spawn("hd_lightswitch", (secs[i].cspot.x, secs[i].cspot.y, secs[i].floorZ));
				continue;
			}
			bool sky = (sec.GetTexture(CEILING) == SkyFlatNum);
			// smart lighting
			// adjust the minimum light to allow a light source
//			double d = 255 * rl_CVar.rl_dim_min.GetFloat(); /////////////////// look at this
			double d = rl_CVar.rl_sector_light_min.GetInt() * rl_CVar.rl_dim_min.GetFloat(); /////////////////// look at this
			bool bN = false;
			if (rl_CVar.rl_smart_lighting.GetBool())
			{
				if (sky) d = 0.35 * sky_light / rl_CVar.rl_dim_min.GetFloat();
				if (!sky && lights.Find(secs[i].sec) == lights.Size()) d = 1.1 * indoor_light / rl_CVar.rl_dim_min.GetFloat();
				if (!sky && lights.Find(secs[i].sec) != lights.Size()) d = 0.7 * indoor_light / rl_CVar.rl_dim_min.GetFloat();
				bN = int(sec.LightLevel * rl_CVar.rl_dim_min.GetFloat()) > sec.FindMinSurroundingLight(255) && (secs[i].area >= min_area && secs[i].area <= median_area);
			}
			bool bwindow = false;
			int outside;
			if (rl_CVar.rl_window_lights.GetBool())
			{
				if (!sky && sec.Lines.Size() > 3 && secs[i].area < 128)
				{
					outside = 0;
					int inside = 0;
					int raised = 0;
					for (int ii = 0; ii < sec.Lines.Size(); ii++)
					{
						Line lin = sec.Lines[ii];
						vector2 v2 = Level.Vec2Offset(lin.V1.P, lin.delta.Unit() * lin.delta.length() * 0.5);
						Sector back = backSector(sec, lin);
						if (back && lin.delta.length() >= 32)
						{
							if (sec.FloorPlane.ZAtPoint(v2) >= back.FloorPlane.ZAtPoint(v2))
							{
								if (back.GetTexture(CEILING) == SkyFlatNum)
								{
									outside++;
								}
								if (back.GetTexture(CEILING) != SkyFlatNum)
								{
									inside++;
								}
								if (sec.FloorPlane.ZAtPoint(v2) > back.FloorPlane.ZAtPoint(v2)) raised++;
								bwindow = outside + inside > 1 && raised > 0;
							}
						}
					}
				}
			}
			if (sec.LightLevel > d || lights.Find(i) != lights.Size() || bwindow || bN || (secs[i].area >= min_area && secs[i].area <= max_area))
			{
				secs[i].cspot = cspot(sec);
				secs[i].setvolume();
				secs[i].Height = sec.CeilingPlane.ZAtPoint(secs[i].cspot) - sec.FloorPlane.ZAtPoint(secs[i].cspot);
				if (bwindow)
				{
					Actor ptr = Actor.Spawn("hd_spot", (secs[i].cspot.x, secs[i].cspot.y, secs[i].floorZ + secs[i].Height * 0.5));
					if (ptr)
					{
						if (ptr.CheckProximity("hd_spot", sqrt(min_area) * 2.0, flags: CPXF_CLOSEST | CPXF_CHECKSIGHT))
						{
							ptr.Destroy();
							bwindow = false;
						}
						else
						{
							ptr.args[0] = secs[i].volume;
							ptr.args[1] = outside;
						}
					}
					continue; /////////////////// this can be cleaned up
				}
				bool b = (!sky && secs[i].area > int(skewness * 64) && secs[i].area < median_area && sec.LightLevel > clamp(d * 1.5, d, 239));
				if (rl_Cvar.rl_sector_lights.GetBool() && ((secs[i].area >= min_area && secs[i].area <= max_area) || b || bN))
				{
					Actor ptr = Actor.Spawn("hdlightsource", (secs[i].cspot.x, secs[i].cspot.y, secs[i].floorZ));
					if (ptr)
					{
						if (ptr.CheckProximity("hdlightsource", sqrt(min_area) * 2.0, flags: CPXF_CLOSEST | CPXF_CHECKSIGHT))
						{
							ptr.Destroy(); ///////////////// probably can just make this an extra
							continue;
						}
						// smart lighting
						// adjust upper clamp limit
						double r = 1.0;
						if (rl_CVar.rl_smart_lighting.GetBool())
						{
							if (sky) r = (sec.LightLevel / (sky_light + 1)) / rl_CVar.rl_dim_min.GetFloat();
							if (!sky && lights.Find(secs[i].sec) == lights.Size()) r = 0.1 * (sec.LightLevel / (indoor_light + 1)) * rl_CVar.rl_dim_min.GetFloat();
							if (!sky && lights.Find(secs[i].sec) != lights.Size()) r = 0.2 * (sec.LightLevel / (indoor_light + 1)) / rl_CVar.rl_dim_min.GetFloat();
							if (!sky) r /= ((rl_Cvar.rl_sidedef_add.GetInt() + 0.1) / (rl_Cvar.rl_sidedef_subtract.GetInt() + 0.1));
							r = clamp(r, 0.0, rl_Cvar.rl_sector_light_scale.GetFloat());
						}
						ptr.args[0] = 0;
						ptr.Scale.Y = clamp(sec.LightLevel / (d + 0.1), 0.0, r);
						ptr.Height = secs[i].Height;
						if (b || bN || secs[i].area < median_area)
						{
							extra_lights.Push(ptr);
						}
						else
						{
							lights.Push(secs[i].sec);
						}
						// smart lighting
						// add temporary lights to middle of 2-sided lines for baked lights
						if (rl_CVar.rl_smart_lighting.GetBool() && (secs[i].area >= min_area && secs[i].area <= median_area))
						{
							r /= rl_CVar.rl_dim_min.GetFloat();
							for (int ii = 0; ii < sec.Lines.Size(); ii++)
							{
								Line lin = sec.Lines[ii];
								if (lin.Flags & Line.ML_TWOSIDED && lin.delta.length() >= 128)
								{
									vector2 v2 = Level.Vec2Offset(lin.V1.P, lin.delta.Unit() * lin.delta.length() * 0.5);
									Sector back = backSector(sec, lin);
									if (!back) continue;
									double z;
									if (sec.FloorPlane.ZAtPoint(v2) >= back.FloorPlane.ZAtPoint(v2))
									{
										z = secs[i].floorZ;
									}
									else
									{
										z = back.FloorPlane.ZAtPoint(v2);
									}
									Actor pptr = Actor.Spawn("hdlightsource", (v2.x, v2.y, z));
									if (pptr)
									{
										pptr.Scale.Y = clamp(r, 0.0, rl_Cvar.rl_sector_light_scale.GetFloat());
										pptr.Scale.Y /= (rl_CVar.rl_sidedef_add.GetInt() + .01) / (rl_CVar.rl_sidedef_subtract.GetInt() + .01);
										pptr.Scale.Y *= (secs[i].Height + .01) / (32.0 * rl_CVar.rl_dim_min.GetFloat());
										pptr.Height = secs[i].Height;
										pptr.args[0] = 0;
										extra_lights.Push(pptr);
										hd_added++;
									}
								}
							}
						}
					}
				}
				else
				{
					if (bleeding.Find(secs[i].sec) == bleeding.Size()) bleeding.Push(secs[i].sec);
				}
			}
		}
		// bleed the dimness
		if (rl_Cvar.rl_dim_sectors.GetBool())
		{
			bled.Clear();
			for(int i = 0; i < bleeding.Size(); i++) bleedDimness(Level.Sectors[bleeding[i]], Level.Sectors[bleeding[i]].LightLevel);
		}
		// bleed the colors
		if (rl_CVar.rl_colored_sectors.GetBool() && rl_Cvar.rl_color_bleeding.GetBool())
		{
			// find all sectors with bleeding colors
			bleeding.Clear();
			bled.Clear();
			for(int i = 0; i < Level.Sectors.Size(); i++)
			{
				Sector sec = Level.Sectors[i];
				if (sec.Lines.Size() == 0) continue;
				color c = sec.ColorMap.LightColor;
				bool sky = sec.GetTexture(CEILING) == SkyFlatNum;
				bool keep;
				int perceived, howred, howgreen, howblue;
				[keep, perceived, howred, howgreen, howblue] = keepthecolor(c);

				if (keep && perceived > rl_Cvar.rl_colored_perceived.GetInt() && (howred > howblue || howgreen > howblue))
				{
					bleeding.Push(i);
				}
				else if (sky && (sky_color.r + sky_color.g + sky_color.b))
				{
					bleeding.Push(i);
				}
			}
			for(int i = 0; i < bleeding.Size(); i++)
			{
				Sector sec = Level.Sectors[bleeding[i]];
				color c = sec.ColorMap.LightColor;
				bleedColor(sec, c);
			}
			for(int i = 0; i < Level.Sectors.Size(); i++)
			{
				Sector sec = Level.Sectors[i];
				if (sec.Lines.Size() == 0) continue;
				for (int ii = 0; ii < sec.Lines.Size(); ii++)
				{
					Line lin = sec.Lines[ii];
					int fside = (lin.FrontSector != sec) ? Line.Back : Line.Front;
					Side wall = lin.Sidedef[fside];
					Color c = tint(sec.ColorMap.LightColor, -4.0);
					Color ctop = wall.GetAdditiveColor(Side.Top);
					Color cmid = wall.GetAdditiveColor(Side.mid);
					Color cbottom = wall.GetAdditiveColor(Side.bottom);
					if (ctop.r + ctop.g + ctop.b + cmid.r + cmid.g + cmid.b + cbottom.r + cbottom.g + cbottom.b == 0)
					{
						if (c.r != c.b || c.g != c.b)
						{
							wall.SetAdditiveColor(Side.Top, c);
							wall.SetAdditiveColor(Side.Mid, c);
							wall.SetAdditiveColor(Side.Bottom, c);

							wall.EnableAdditiveColor(Side.Top, true);
							wall.EnableAdditiveColor(Side.Mid, true);
							wall.EnableAdditiveColor(Side.Bottom, true);
						}
					}
				}
			}
		}
		if (rl_CVar.rl_texture_lights.GetBool())
		{
			int text_lights = 0;
			int min_lines = 4;
			int max_lines = 6;
			int max_limit = 32;
			int max_ratio = 1;
			if (lights.Size() > 1000)
			{
				max_lines = 4;
				max_limit = 256;
				max_ratio = 4;
			}
			if (lights.Size() > 250)
			{
				max_lines = 4;
				max_limit = 128;
				max_ratio = 3;
			}
			else if (lights.Size() > 150)
			{
				max_lines = 4;
				max_limit = 64;
				max_ratio = 2;
			}
			// add point lights to textures
			for(int i = 0; i < Level.Sectors.Size(); i++)
			{
				Sector sec = Level.Sectors[i];
				if (sec.Lines.Size() < min_lines || sec.Lines.Size() > max_lines) continue;
				if (sec.GetTexture(CEILING) != SkyFlatNum)
				{
					double min = double.infinity;
					double max = 0;
					for (int ii = 0; ii < sec.Lines.Size(); ii++)
					{
						double len = sec.Lines[ii].delta.length();
						if (len < min) min = len;
						if (len > max) max = len;
					}
					if (max > (min * max_ratio) && max > max_limit)
					{
						int two_sided = 0;
						int back_light = 0;
						for (int ii = 0; ii < sec.Lines.Size(); ii++)
						{
							Line lin = sec.Lines[ii];
							if (lin.Flags & Line.ML_TWOSIDED && lin.delta.length() > min)
							{
								Sector back = backSector(sec, lin);
								if (!back) continue;
								two_sided++;
								back_light += back.LightLevel;
								if (back_light *  rl_Cvar.rl_texture_light_factor.GetFloat() < indoor_light)
								{
									two_sided++;
									back_light += back.LightLevel;
								}
							}
						}
						if (two_sided == 0) continue;
						back_light = int(back_light / two_sided);
						int lightlevel = isSpecial(sec) ? 255 : sec.LightLevel;
						if (lightlevel > back_light * rl_Cvar.rl_texture_light_factor.GetFloat())
						{
							for (int ii = 0; ii < sec.Lines.Size(); ii++)
							{
								Line lin = sec.Lines[ii];
								if (lin.delta.length() < max && lin.delta.length() <= 64) ///////// test
								{
									vector2 v2 = Level.Vec2Offset(lin.V1.P, lin.delta.Unit() * lin.delta.length() * 0.5);
									double sec_height = ((sec.CeilingPlane.ZAtPoint(v2)-sec.FloorPlane.ZAtPoint(v2)) * 0.5);
									if (sec_height != 0)
									{
										vector2 point = frontline(lin);
										Actor ptr = Actor.Spawn("hdlightsource", (point.x, point.y, sec.FloorPlane.ZAtPoint(v2) + ((sec.CeilingPlane.ZAtPoint(v2)-sec.FloorPlane.ZAtPoint(v2)) * 0.5)));
										if (ptr)
										{
											ptr.Scale.Y = clamp(lightlevel / (back_light + 1), 0.0, 
												rl_Cvar.rl_sector_light_scale.GetFloat() * rl_Cvar.rl_dim_min.GetFloat());
											ptr.args[0] = 2;
											ptr.Height = sec.FloorPlane.ZAtPoint(v2) + (sec_height * 0.5);
											text_lights++;
										}
									}
								}
							}
						}
					}
				}
			}
		}
		// bake sidedef lights
		bleeding.clear();
		if (rl_Cvar.rl_sidedef_add.GetInt() > 0 && rl_Cvar.rl_sidedef_subtract.GetInt() > 0)
		{
			int num_sectors = Level.Sectors.Size();
			double warea_limit = (num_sectors < 500 ? min_area : median_area); //

// console.printf("before %f", warea_limit);

			warea_limit *= (rl_Cvar.rl_sidedef_subtract.GetInt()* 1.0 / rl_Cvar.rl_sidedef_add.GetInt());

// console.printf("-----------------> after %f", warea_limit);

			double seek_limit = num_sectors < 500 ? .025 : 0.1;
			Array<int> no_lights;
			if (rl_Cvar.rl_decorative_lights.GetBool())
			{
				for(int i = 0; i < Level.Sectors.Size(); i++)
				{
					Sector sec = Level.Sectors[i];
					if (sec.Lines.Size() == 0) continue;
					bool sky = (sec.GetTexture(CEILING) == SkyFlatNum);
					double warea = 0.0;
					for (int j = 0; j < secs.Size(); j++)
					{
						if (secs[j].sec == sec.SectorNum)
						{
							warea = secs[j].area;
							break;
						}
					}
					if (warea < warea_limit) continue;
					Actor thing = sec.ThingList;
					int num_lights = 0;
					while (thing)
					{
						string cname = thing.GetClassName();
						cname = cname.MakeLower();
						if (lobj.Find(cname) != lobj.Size())
						{
							if (!thing.bIsMonster && thing.bSolid && !thing.bShootable)
							{
								Color c = cobj[lobj.Find(cname)];
								bool keep;
								int perceived,howred,howgreen,howblue;
								[keep, perceived, howred, howgreen, howblue] = keepthecolor(c);
								if (keep)
								{
									Actor ptr = Actor.Spawn("hdlightsource", (thing.Pos.x, thing.Pos.y, thing.Pos.z + thing.Height));
									if (ptr)
									{
										if (ptr.CheckProximity("hdlightsource", thing.radius * 4, flags: CPXF_CLOSEST | CPXF_CHECKSIGHT))
										{
											ptr.Destroy();
										}
										else
										{
											hd_added++;
											// smart lighting
											// tweak scale according to perceived light of GLDEF color
											double r = 1.0;
											if (rl_CVar.rl_smart_lighting.GetBool())
											{
												r *= perceived / ((sec.LightLevel + 1) * rl_Cvar.rl_dim_min.GetFloat());
											}
											vector2 v2 = thing.Pos.xy;
											ptr.Scale.Y = perceived / (rl_Cvar.rl_sector_light_min.GetInt() * thing.Height / ((sec.CeilingPlane.ZAtPoint(v2) - sec.FloorPlane.ZAtPoint(v2)) * 0.5) + 1);
											ptr.Scale.Y = clamp(ptr.Scale.Y * r, 0.0, rl_Cvar.rl_sector_light_scale.GetFloat() / rl_Cvar.rl_dim_min.GetFloat()); // * 1.25);
											ptr.args[0] = 1;
											num_lights++;
										}
									}
								}
							}
						}
						thing = thing.snext;
					}
					// smart lighting
					// collect sectors without a light source
					if (num_lights == 0 && lights.Find(i) == lights.Size()) no_lights.Push(i);
				}
			}
			for(int i = 0; i < Level.Sectors.Size(); i++)
			{
				Sector sec = Level.Sectors[i];
				if (sec.Lines.Size() == 0) continue;
				double warea = 0.0;
				for (int j = 0; j < secs.Size(); j++)
				{
					if (secs[j].sec == sec.SectorNum)
					{
						warea = secs[j].area;
						break;
					}
				}
				if (warea < warea_limit) continue;
				double f = 1/(rl_Cvar.rl_sector_light_min.GetInt() * 1.0);
				int j = int((rl_Cvar.rl_shadow_distance.GetInt() * 1.0) / (rl_Cvar.rl_sector_light_min.GetInt() * 1.0) + 0.5);
				j = j < rl_Cvar.rl_sidedef_subtract.GetInt() ? j : int(rl_Cvar.rl_sidedef_subtract.GetInt() * 0.1);
				int darkness = -clamp(int(warea * f), j, rl_Cvar.rl_sidedef_subtract.GetInt());
				int total_light = 0;
				int total_shadow = 0;
				double min_light = double.infinity;
				for (int ii = 0; ii < sec.Lines.Size(); ii++)
				{
					Line lin = sec.Lines[ii];
					vector2 v2 = Level.Vec2Offset(lin.V1.P, lin.delta.Unit() * lin.delta.length() * 0.5);
					int fside = (lin.FrontSector != sec) ? Line.Back : Line.Front;
					Side wall = lin.Sidedef[fside];
					wall.flags = wall.flags | Side.WALLF_SMOOTHLIGHTING | Side.WALLF_NOFAKECONTRAST;
					// find the light
					double added_light = 0.0;
					double added_sky = 0.0;
					double min_dist = double.infinity;
					double min_sky = double.infinity;
					Actor ptr = Actor.Spawn("hdlightseeker", (v2.x, v2.y, sec.FloorPlane.ZAtPoint(v2) + ((sec.CeilingPlane.ZAtPoint(v2) - sec.FloorPlane.ZAtPoint(v2)) * 0.50)));
					if (ptr)
					{
						Actor light;
						ThinkerIterator it = ThinkerIterator.Create("hdlightsource", Thinker.STAT_DEFAULT);
						while (light = hdlightsource(it.Next()))
						{
							bool visible;
							double d;
							bool sky = light.CurSector.GetTexture(CEILING) == SkyFlatNum && sec.GetTexture(CEILING) != SkyFlatNum;
							if (!sky && rl_CVar.rl_smart_lighting.GetBool())
							{
								sky = (light.CurSector.LightLevel > rl_Cvar.rl_sector_light_min.GetInt() / rl_CVar.rl_dim_min.GetFloat()) && 
									(sec.LightLevel < rl_Cvar.rl_sector_light_min.GetInt() * rl_CVar.rl_dim_min.GetFloat());
							}
							[visible, d] = LightCheckSight(light, ptr, sky ? seek_limit : seek_limit * 4);
							if (visible && d > 128)
							{
								if (d == 0) d = 1; // avoid DIV/0
								double dlight = light.CurSector.LightLevel * light.Scale.Y / rl_CVar.rl_dim_min.GetFloat(); //////////// test
								double dinvsq = (d / 64  * d / 64);
								// 0 = sector, 1 = decorative, 2 = texture
								if (light.args[0] == 1) dlight *= 2.0;
								if (light.args[0] == 2) dlight *= 1.5;
//								if (light.args[0] == 2) dlight *= 0.25;
								// smart lighting
								// tweak intensity of outdoor (where it may be night) & decorative lights
								if (rl_CVar.rl_smart_lighting.GetBool())
								{
									double f = rl_Cvar.rl_sector_light_min.GetInt() / (light.CurSector.LightLevel + 1);
									added_light += (sky ? 0.0 : rl_CVar.rl_dim_min.GetFloat()) * dlight / dinvsq;
									added_sky += (sky ? f : 0.0) * dlight / dinvsq;
								}
								else
								{
									added_light += (sky ? 0.0 : 1.0) * dlight / dinvsq;
									added_sky += (sky ? 1.0 : 0.0) * dlight / dinvsq;
								}
							}
							else if (d < min_dist && !sky)
							{
								min_dist = d;
							}
							else if (d < min_sky && sky)
							{
								min_sky = d;
							}
						}
					}
					// add subtractive lighting for extra shade
					if (rl_CVar.rl_subtractive_lighting.GetBool() && clights.Find(sec.SectorNum) == clights.Size())
					{
						double d = rl_Cvar.rl_sidedef_add.GetInt() / rl_Cvar.rl_sidedef_subtract.GetInt() * 1.0;
						double sheight = (sec.CeilingPlane.ZAtPoint(v2) - sec.FloorPlane.ZAtPoint(v2));
						if (!(lin.Flags & Line.ML_TWOSIDED) && added_light + added_sky < d && lin.delta.length() >= 96 && sheight >= 128 && sec.LightLevel > 144)
						{
							int r = clamp(int(sheight * d * 0.02 + lin.delta.Length() * d * 0.01), 2, rl_Cvar.rl_sidedef_subtract.GetInt());
							ptr.A_AttachLight("shadow", DynamicLight.SectorLight, color(r * 2, r * 2, r * 2), r, 0, flags: DYNAMICLIGHT.LF_SUBTRACTIVE);
						}
						else
						{
							ptr.Destroy();
						}
					}
					else
					{
						ptr.Destroy();
					}
					if ((added_light + added_sky) > (rl_CVar.rl_sector_light_scale.GetFloat() / rl_CVar.rl_dim_min.GetFloat()))
					{
						// smart lighting
						// tweak intensity of added light as these sources dissipate differently
						if (rl_CVar.rl_smart_lighting.GetBool())
						{
							wall.Light = int(clamp(added_light, 0, rl_Cvar.rl_sidedef_add.GetInt() * 0.7) + 0.5);
							wall.Light += int(clamp(added_sky, 0, rl_Cvar.rl_sidedef_add.GetInt() * 1.3) + 0.5); //////////////// test
						}
						else
						{
							wall.Light = clamp(int(added_light + added_sky), 0, rl_Cvar.rl_sidedef_add.GetInt());
						}
						total_light += wall.Light;

						if (min_dist < min_light) min_light = min_dist;
						if (min_sky < min_light) min_light = min_sky;
					}
					else
					{
						// smart lighting
						// tweak darkness according to how far away light is
						if (rl_CVar.rl_smart_lighting.GetBool())
						{
							double r = 1.0;
							if (min_sky < 2048 && min_sky < min_dist)
							{
								r = clamp(min_sky / 512, 0.7, 1.0);
							}
							if (min_dist < 1024 && min_dist < min_sky)
							{
								r = clamp(min_dist / 128, 1.0, 1.1);
							}
							wall.Light = darkness * r + (added_light + added_sky);
						}
						else
						{
							wall.Light = darkness;
						}
						total_shadow += -wall.Light;
					}
				}
				if (rl_CVar.rl_smart_lighting.GetBool())
				{
					total_light += min_light < double.infinity ? min_light * 0.01 : 0.0;
					total_shadow += no_lights.Find(i) != no_lights.Size() ? sec.LightLevel * 0.10 : 0.0;
					if (total_shadow > total_light)
					{
						sec.LightLevel = clamp(sec.LightLevel - (total_shadow / (total_light + 1) * .01), sec.LightLevel * rl_CVar.rl_dim_min.GetFloat(), sec.LightLevel);
						if (bleeding.Find(i) != bleeding.Size()) bleeding.Push(i);
					}
					if (total_light > total_shadow && sec.LightLevel < rl_Cvar.rl_sector_light_min.GetInt() * rl_CVar.rl_dim_min.GetFloat())
					{
// int old_light = sec.LightLevel;

						sec.LightLevel = clamp(sec.LightLevel + (total_light / (total_shadow + 1) * .01), sec.LightLevel, rl_Cvar.rl_sector_light_min.GetInt() / rl_CVar.rl_dim_min.GetFloat());

// console.printf("sector %i ratio %f old %i new %i", sec.SectorNum, total_light / (total_shadow + 1), old_light, sec.LightLevel);

					}
					seclights[i] = sec.LightLevel;
				}
			}
		}
		// smart lighting
		// bleed the dimness again
		if (rl_CVar.rl_smart_lighting.GetBool() && rl_Cvar.rl_dim_sectors.GetBool())
		{
			bled.Clear();
			for(int i = 0; i < bleeding.Size(); i++) bleedDimness(Level.Sectors[bleeding[i]], Level.Sectors[bleeding[i]].LightLevel);
		}
		// destroy lights added for baking
		for (int i = 0; i < extra_lights.Size(); i++) if (extra_lights[i]) extra_lights[i].Destroy();
		return;
	}
	vector2 frontLine(Line lin)
	{
		vector2 v2 = Level.Vec2Offset(lin.V1.P, lin.delta.Unit() * lin.delta.length() * 0.5);
		double x = v2.x;
		double y = v2.y;
		vector2 point;
		point.x = x + 0.577350269 * (y - lin.V1.P.y);
		point.y = y + 0.577350269 * (lin.V1.P.x - x);
		return point;
	}
	vector2 backLine(Line lin)
	{
		vector2 v2 = Level.Vec2Offset(lin.V1.P, lin.delta.Unit() * lin.delta.length() * 0.5);
		double x = v2.x;
		double y = v2.y;
		vector2 point;
		point.x = x - 0.577350269 * (y - lin.V1.P.y);
		point.y = y - 0.577350269 * (lin.V1.P.x - x);
		return point;
	}
	bool, double LightCheckSight(Actor light, Actor wall, double fincr = 0.1)
	{
        if (!light || !wall) return false, double.infinity;
		int FLOOR = 0, CEILING = 1;
		// sector light that is tall as the sector
		if (light.args[0] == 1)
		{
			double incr = light.Height * fincr;
			incr = incr < 1.0 ? 1.0 : incr;
			double zz = light.Pos.z + ((light.CeilingZ - light.Pos.z) * 0.5);
			Vector3 fdelta = LevelLocals.Vec3Diff((light.Pos.x, light.Pos.y, zz), wall.Pos);
			for (double z = light.CurSector.CeilingPlane.ZAtPoint(light.Pos.xy); z > light.Pos.z; z-=incr)
			{
				Vector3 delta = LevelLocals.Vec3Diff((light.Pos.x, light.Pos.y, z), wall.Pos);
				vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );
				FLineTraceData beam;
				if (!light.LineTrace(aim.x, delta.Length(), aim.y, TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS, data: beam))
				{
					if (beam.HitLine && beam.LineSide == Line.back) return false, fdelta.Length();
					if (beam.Distance < delta.Length()) return false, fdelta.Length();
					return true, (delta.Length() == 0 ? 1 : delta.Length());
				}
			}
			return false, fdelta.Length();
		}
		else // decorative or texture light
		{
			// test correction
			Vector3 fdelta = LevelLocals.Vec3Diff((light.Pos.x, light.Pos.y, light.Pos.z + light.Height), wall.Pos);
			Vector3 delta = light.Vec3To(wall);
			delta = fdelta;
			vector2 aim = (VectorAngle(delta.x, delta.y), -VectorAngle(delta.xy.Length(), delta.z) );
			FLineTraceData beam;
			if (!light.LineTrace(aim.x, delta.Length(), aim.y, TRF_THRUBLOCK|TRF_THRUHITSCAN|TRF_THRUACTORS, data: beam))
			{
				if (beam.HitLine && beam.LineSide == Line.back) return false, fdelta.Length();
				if (beam.Distance < delta.Length()) return false, fdelta.Length();
				return true, (delta.Length() == 0 ? 1 : delta.Length());
			}
			return false, fdelta.Length();
		}
	}
	override void WorldTick()
	{
		if (players[consoleplayer].mo && bplayer_shadows_on_self)
		{
			if (player_light != players[consoleplayer].mo.CurSector.LightLevel)
			{
				player_light = players[consoleplayer].mo.CurSector.LightLevel;
				if (player_light > 144)
				{
					players[consoleplayer].mo.A_RemoveLight("shadow");
				}
				else
				{
					players[consoleplayer].mo.A_AttachLight("shadow", DynamicLight.SectorLight, color("#606060"), 2, 0,
						flags: DYNAMICLIGHT.LF_SUBTRACTIVE | DYNAMICLIGHT.LF_DONTLIGHTMAP | DYNAMICLIGHT.LF_DONTLIGHTOTHERS, (0,0,players[consoleplayer].mo.Height * 0.5));
				}
			}
		}
		if (!bBDflashlight)
		{
			for (Inventory item = players[consoleplayer].mo.inv; item != null; item = item.inv)
			{
				if (item.GetClassName() == "FlashlightOn")
				{
					let rl_Cvar = rl_Cvars.get();
					bBDflashlight = true;
					bool b;
					[b, BDflashlight] = players[consoleplayer].mo.A_SpawnItemEx("hd_light", flags: SXF_SETMASTER);
					if (BDflashlight)
					{
						BDflashlight.args[0] = 1;
						BDflashlight.master = players[consoleplayer].mo;
						BDflashlight.master.target = players[consoleplayer].mo.target;
						BDflashlight.SetOrigin((BDflashlight.Pos.X, BDflashlight.Pos.Y, BDflashlight.Pos.Z), false);
						BDflashlight.Scale.Y = rl_Cvar.rl_sector_light_size.GetFloat();
					}
					break;
				}
			}
		}
		else if (bBDflashlight)
		{
			for (Inventory item = players[consoleplayer].mo.inv; item != null; item = item.inv)
			{
				if (item.GetClassName() == "FlashlightOn")
				{
					return;
				}
			}
			BDflashlight.Destroy();
			bBDflashlight = false;
		}
	}
	override void WorldThingSpawned(WorldEvent e)
	{
		if (!e.thing) return;
		if (e.thing == players[consoleplayer].mo) return;
		if (e.thing.GetRenderStyle() == STYLE_Subtract)	PPShader.SetUniform1f("hd_shader", "rl_gamma", 0.0);
		if (e.thing.GetRenderStyle() == STYLE_Translucent)	return; // test this with Beautiful Doom
		let rl_Cvar = rl_Cvars.get();
		string cname = e.thing.GetClassName();
		cname = cname.MakeLower();
		int ilobj = lobj.Find(cname);
		Texman texture;
		bool isFlashlight = false;
		for (int i = 0; i < FLights.Size(); i++)
		{
			if (cname == FLights[i])
			{
				isFlashlight = true;
				break;
			}
		}
		if (cname.IndexOf("fake") == 0) return;
		if (cname.IndexOf("hd_") != -1 || cname == "hdlight" || cname == "hdghostmissile" || cname == "hdghostlight" || cname == "hdlightseeker") return;

		// DRPG Compatibility; Prevents large fps drops
		if (cname.IndexOf("drpg") != -1)
			return;

		int sprite_height = texture.CheckRealHeight(e.thing.CurState.GetSpriteTexture(0));
		if (texture.GetName(e.thing.CurState.GetSpriteTexture(0)) == "TNT1A0") sprite_height = e.thing.Height;
		// eliminate the obvious
		if (cname != "hdlightsource" && !isFlashlight)
		{
			if (sprite_height < rl_sprite_min || sprite_height > rl_sprite_max) return;
			if (e.thing.bMissile && !e.thing.Damage) return;
			if (!e.thing.bMissile && (e.thing.bNoClip || e.thing.bThruActors || e.thing.bNoBlockMap || e.thing.bActLikeBridge)) return;
			if (!rl_Cvar.rl_player_shadows.GetBool() && e.thing == players[consoleplayer].mo) return;
			if (!rl_Cvar.rl_missile_shadows.GetBool() && e.thing.bMissile) return;
			if (!rl_Cvar.rl_monster_shadows.GetBool() && e.thing.bIsMonster) return;
			if (!rl_Cvar.rl_pickup_shadows.GetBool() && e.thing is "Inventory") return;
			if (!rl_Cvar.rl_solid_shadows.GetBool() && e.thing.bSolid) return;
			if (!rl_Cvar.rl_gldefs_shadows.GetBool() && ilobj != lobj.Size()) return;

///////// test
			if (!rl_Cvar.rl_other_shadows.GetBool() && e.thing != players[consoleplayer].mo && !e.thing.bMissile && !e.thing.bIsMonster && !(e.thing is "Inventory") 
				&& (!e.thing.bSolid && sprite_height != 0) && ilobj == lobj.Size()) return;
			if (e.thing.bMissile && rl_Cvar.rl_missile_max_shadows.GetInt())
			{
				if (missile_shadows > rl_Cvar.rl_missile_max_shadows.GetInt()) return;
				missile_shadows++;
			}
			else if (e.thing.bIsMonster && rl_Cvar.rl_monster_max_shadows.GetInt())
			{
				if (monster_shadows > rl_Cvar.rl_monster_max_shadows.GetInt()) return;
				monster_shadows++;
			}
			else if (cname != "hdlightsource" && rl_Cvar.rl_other_max_shadows.GetInt())
			{
				if (other_shadows > rl_Cvar.rl_other_max_shadows.GetInt()) return;
				other_shadows++;
			}
			else if (ilobj == lobj.Size() && !e.thing.bCorpse && !e.thing.bMissile && !e.thing.bIsMonster && !isFlashlight && !(e.thing is "Inventory") && cname != "hdlightsource"
				&& e.thing != players[consoleplayer].mo && (!e.thing.bSolid && sprite_height == 0))
			{
				return;
			}
		}

/////////////////////////////// to do: allow for rl_other_shadows

		// give shadow inventory
		e.thing.bCastSpriteShadow = false;
		if (cname != "hdlightsource" && !isFlashlight)
		{
			if (texture.GetName(e.thing.CurState.GetSpriteTexture(0)) != "TNT1A0")
			{
				string s = texture.GetName(e.thing.CurState.GetSpriteTexture(0)).Left(5);
				if (voxel.Find(s.MakeLower()) == voxel.Size())
				{
					if (texture.GetName(e.thing.CurState.GetSpriteTexture(0)))
					{
// console.printf("------> YES %s %s %i %i", texture.GetName(e.thing.CurState.GetSpriteTexture(0)), cname, sprite_height, e.thing.Height); // Non-TNT1A0 shadow generators
						e.thing.A_GiveInventory("hd_shade", 1);
					}
				}
				else
				{
					return;
				}
			}
			else if (e.thing is "Inventory") // player
			{
				return;
			}
			else
			{
// console.printf("%s %s %i %i", texture.GetName(e.thing.CurState.GetSpriteTexture(0)), cname, sprite_height, e.thing.Height); // TNT1A0 shadow generators
				e.thing.A_GiveInventory("hd_shade", 1);
			}
		}
		else
		{
			bool b;
			Actor ptr;
			if (cname == "hdlightsource" && e.thing.Scale.Y >= rl_Cvar.rl_sector_light_scale.GetFloat() * (Level.Sectors.Size() < 500 ? 0.7 : 1.1))
			{
				[b, ptr] = e.thing.A_SpawnItemEx("hd_light", flags: SXF_SETMASTER);
				if (ptr)
				{
					ptr.master = e.thing;
					ptr.args[0] = e.thing.args[0];
					ptr.args[1] = e.thing.args[1];
					ptr.args[2] = e.thing.args[2];
					ptr.args[3] = e.thing.args[3];

					if (rl_CVar.rl_smart_lighting.GetBool())
					{
						if (e.thing.CurSector.GetTexture(Sector.Ceiling) == SkyFlatNum)
						{
							ptr.Scale.Y = rl_Cvar.rl_sector_light_scale.GetFloat() * clamp(e.thing.CurSector.LightLevel / (sky_light + 1), 0.5, rl_Cvar.rl_sector_light_scale.GetFloat() * 1.1);
						}
						else
						{
							ptr.Scale.Y = rl_Cvar.rl_sector_light_scale.GetFloat() * clamp(e.thing.CurSector.LightLevel / (indoor_light + 1), 0.5, rl_Cvar.rl_sector_light_scale.GetFloat() * 0.7);
						}
					}
					else
					{
						ptr.Scale.Y = rl_Cvar.rl_sector_light_scale.GetFloat() * clamp(e.thing.CurSector.LightLevel / 255, 0.5, 1.0);
					}
				}
			}
			else if (isFlashlight)
			{
				[b, ptr] = e.thing.A_SpawnItemEx("hd_light", flags: SXF_SETMASTER);
				if (ptr)
				{
					ptr.args[0] = 1;
					ptr.master = e.thing;
					ptr.master.target = e.thing.target;
					ptr.SetOrigin((ptr.Pos.X, ptr.Pos.Y, ptr.Pos.Z), false);
					ptr.Scale.Y = max(rl_Cvar.rl_sector_light_scale.GetFloat(),rl_Cvar.rl_monster_light_scale.GetFloat(),rl_Cvar.rl_missile_light_scale.GetFloat(),rl_Cvar.rl_other_light_scale.GetFloat()) * 2.0;
				}
			}
		}
		return;
	}
/******************************************************************************/
// custom functions
	vector2 cspot(Sector sec)
	{
		let rl_Cvar = rl_Cvars.get();
		switch(rl_Cvar.rl_center_algorithm.GetInt())
		{
			case 0:
				return sec.CenterSpot;
			case 1:
				return centroid(sec);
			case 2:
				return polyLabel(sec);
		}
		return polyLabel(sec);
	}
	bool isSpecial(Sector sec)
	{
		if (sec.Special == 0) return false;
		for(int i = 0; i < LSpecials.Size(); i++)
		{
			if (sec.Special == LSpecials[i]) return true;
		}
		return false;
	}
	Sector backSector(Sector sec, Line lin)
	{
		if (lin.Flags & Line.ML_TWOSIDED)
		{
			if (lin.BackSector != sec) return lin.BackSector;
			if (lin.FrontSector != sec) return lin.FrontSector;
		}
		return null;
	}
	void bleedColor(Sector sec, color c)
	{
		bool keep;
		int perceived, howred, howgreen, howblue;
		[keep, perceived, howred, howgreen, howblue] = keepthecolor(c);
		// find back sectors
		for (int ii = 0; ii < sec.Lines.Size(); ii++)
		{
			Line lin = sec.Lines[ii];
			Sector back;
			if (lin.Flags & Line.ML_TWOSIDED)
			{
				if (lin.BackSector != sec) back = lin.BackSector;
				if (lin.FrontSector != sec) back = lin.FrontSector;
				if (back && bled.Find(back.SectorNum) == bled.Size()) //  && back.GetTexture(Sector.Ceiling) != SkyFlatNum)
				{
					color bc = back.ColorMap.LightColor;
					bool bkeep;
					int bperceived, bhowred, bhowgreen, bhowblue;
					[bkeep, bperceived, bhowred, bhowgreen, bhowblue] = keepthecolor(bc);

					if (keep && (howred > bhowred || howgreen > bhowgreen))
					{
						bled.Push(back.SectorNum);
						back.SetColor(tint(c, -0.30));
						bleedColor(back, back.ColorMap.LightColor);
					}
				}
			}
		}
	}
	void bleedDimness(Sector sec, int light)
	{
		let rl_Cvar = rl_Cvars.get();
		if (sec.GetTexture(Sector.Ceiling) == SkyFlatNum || sec.LightLevel <= rl_Cvar.rl_sector_light_min.GetInt() * rl_Cvar.rl_dim_min.GetFloat() || isSpecial(sec)) return;
		Texman texture;
		// find back sectors
		for (int ii = 0; ii < sec.Lines.Size(); ii++)
		{
			Line lin = sec.Lines[ii];
			Sector back;
			if (lin.Flags & Line.ML_TWOSIDED)
			{
				if (lin.BackSector != sec) back = lin.BackSector;
				if (lin.FrontSector != sec) back = lin.FrontSector;
				if (back && bled.Find(back.SectorNum) == bled.Size())
				{
					if (sec.LightLevel < back.LightLevel && back.LightLevel < rl_Cvar.rl_sector_light_min.GetInt() && back.GetTexture(Sector.Ceiling) != SkyFlatNum && !isSpecial(back))
					{
						bool ckeep;
						int cperceived,chowred,chowgreen,chowblue;
						Color cc = flat_color[flats.Find(texture.GetName(back.GetTexture(Sector.Ceiling)))];
						[ckeep, cperceived, chowred, chowgreen, chowblue] = keepthecolor(cc);
						if (!ckeep || cperceived < 128)
						{
							bled.Push(back.SectorNum);
							int j = back.LightLevel;
							back.LightLevel = clamp(int(back.LightLevel - (sec.LightLevel * 1 - rl_Cvar.rl_dim_min.GetFloat())), 
								int(back.LightLevel * clamp(rl_CVar.rl_dim_min.GetFloat() * 1.1, rl_CVar.rl_dim_min.GetFloat(), 1.0)), 255);
							seclights[back.SectorNum] = back.LightLevel;
							bleedDimness(back, back.LightLevel);
						}
					}
				}
			}
		}
	}
	// color tests
	bool, int, int, int, int keepthecolor(Color c)
	{
		let rl_Cvar = rl_Cvars.get();
		double r = c.r;
		double g = c.g;
		double b = c.b;
		int howred = 0;
		int howgreen = 0;
		int howblue = 0;
		int perceived;
		if (g > r && g > b)
		{
			// ITU BT.601 - Digital more weight to R and B
			perceived = clamp(int(sqrt(0.299 * (c.r * c.r) + 0.587 * (c.g * c.g) + 0.114 * (c.b * c.b))), 0, 255);
		}
		else
		{
			// ITU BT.709 - HDTV standard
			perceived = clamp(int(sqrt(0.2126 * (c.r * c.r) + 0.7152 * (c.g * c.g) + 0.0722 * (c.b * c.b))), 0, 255);
		}
		if (c.r > c.g && c.r > c.b && c.r > rl_Cvar.rl_colored_howred.GetInt()) howred = clamp(int((0.587 + (255 / r)) * 100), 0, 255);
		if (c.g > c.r && c.g > c.b && c.g > rl_Cvar.rl_colored_howgreen.GetInt()) howgreen = clamp(int((0.114 + (255 / g)) * 100), 0, 255);
		if (c.b > c.r && c.b > c.g && c.b > rl_Cvar.rl_colored_howblue.GetInt()) howblue = clamp(int(255 / b * 100), 0, 255);
		return (perceived > rl_Cvar.rl_colored_perceived.GetInt() || howred || howgreen || howblue), perceived, howred, howgreen, howblue;
	}
	// math
	float mean(Array<double> darr)
	{
		double sum = 0;
		int n = darr.Size();
		for (int i = 0; i < n; i++) sum += darr[i];
		return sum / n;
	}
	float stdev(Array<double> darr)
	{
		double sum = 0;
		double m = mean(darr);
		int n = darr.Size();
		for (int i = 0; i < n; i++) sum += (darr[i] - m) * (darr[i] - m);
		return sqrt(sum / (n - 1));
	}
	float skew(Array<double> darr)
	{
		double sum = 0;
		double m = mean(darr);
		double sd = stdev(darr);
		int n = darr.Size();
		for (int i = 0; i < n; i++) sum += (darr[i] - m) * (darr[i] - m) * (darr[i] - m);
		if (n == 1 || sd == 0)
		{
			return 1.0;
		}
		else
		{
			return sum / ((n - 1) * sd * sd * sd);
		}
	}

	double shoelace(Array<double> x, Array<double> y)
	{
		double area;
		int j = x.Size() - 1;
		for (int i = 0; i < x.Size(); i++)
		{
			area += (x[j] + x[i]) * (y[j] - y[i]);
			j = i;
		}
		return abs(area / 2.0);
	}

	void nextperimeter(Sector sec, out Array<double> x, out Array<double> y, out Array<int> done)
	{
		// find lowest corner
		double xhead = double.infinity;
		double yhead = double.infinity;
		int min = -1;
		for (int i = 0; i < sec.Lines.Size(); i++)
		{
			if (done.Find(i) != done.Size()) continue;
			if (sec.Lines[i].V1.P.x < xhead && sec.Lines[i].V1.P.y < yhead)
			{

				xhead = sec.Lines[i].V1.P.x;
				yhead = sec.Lines[i].V1.P.y;
				min = i;
			}
		}
		done.Push(min);
		x.Push(xhead);
		y.Push(yhead);
		double xtail = sec.Lines[min].V2.P.x;
		double ytail = sec.Lines[min].V2.P.y;
		double vangle = VectorAngle(sec.Lines[min].delta.x, sec.Lines[min].delta.y);
		double xlast, ylast;
		// stitch the perimeter
		while (xtail != xhead || ytail != yhead)
		{
			xlast = xtail;
			ylast = ytail;
			for (int i = 0; i < sec.Lines.Size(); i++)
			{
				if (done.Find(i) != done.Size()) continue;
				Line lin = sec.Lines[i];
				// match the tail
				if (lin.V1.P.x ~== xtail && lin.V1.P.y ~== ytail)
				{
					done.Push(i);
					xtail = lin.V2.P.x;
					ytail = lin.V2.P.y;
					if (vangle ~== VectorAngle(lin.delta.x, lin.delta.y)) break;

					vangle = VectorAngle(lin.delta.x, lin.delta.y);
					x.Push(lin.V1.P.x);
					y.Push(lin.V1.P.y);

					break;
				}
				if (lin.V2.P.x ~== xtail && lin.V2.P.y ~== ytail) // line turned around
				{
					done.Push(i);
					xtail = lin.V1.P.x;
					ytail = lin.V1.P.y;
					if (vangle ~== VectorAngle(lin.delta.x, lin.delta.y)) break;

					vangle = VectorAngle(lin.delta.x, lin.delta.y);
					x.Push(lin.V2.P.x);
					y.Push(lin.V2.P.y);

					break;
				}
			}
			if (xlast == xtail && ylast == ytail) break;
		}
		return;
	}
	double polygonArea(Sector sec)
	{
		if (sec.Lines.Size() < 3) return 0.0; // map 21 of Doom 2
		Array<double> x;
		Array<double> y;
		Array<int> done;
		nextperimeter(sec, x, y, done);
		double area = shoelace(x, y);
		double inner = 0;
		while (sec.Lines.Size() > done.Size())
		{
			x.Clear();
			y.Clear();
			nextperimeter(sec, x, y, done);
			inner += shoelace(x, y);
		}
		return abs((area - inner) / 144);
	}
	vector2 polylabel(Sector sec)
	{
		// find bounding box
		double minX = double.infinity, minY = double.infinity, maxX = -double.infinity, maxY = -double.infinity;
		Array<double> vx;
		Array<double> vy;
		for (int i = 0; i < sec.Lines.Size(); i++)
		{
			Line lin = sec.Lines[i];
			double x1 = lin.V1.P.x;
			double y1 = lin.V1.P.y;
			double x2 = lin.V2.P.x;
			double y2 = lin.V2.P.y;
			bool b = false;
			for (int j = 0; j < vx.Size(); j++)
			{
				if (vx[j] ~== x1 && vy[j] ~== y1)
				{
					vx.Push(x2);
					vy.Push(y2);
					b = true;
					break;
				}
			}
			if (!b)
			{
				vx.Push(x1);
				vy.Push(y1);
			}
		}
		// check for rectangle
		Array<double> x;
		Array<double> y;
		Array<int> done;
		nextperimeter(sec, x, y, done);
		if (x.Size() == 4)
		{
			return sec.CenterSpot;
		}
		if (vx.Size() == 3)
		{
			return ((vx[0] + vx[1] + vx[2]) / 3, (vy[0] + vy[1] + vy[2]) / 3);
		}
		for (int i = 0; i < vx.Size(); i++)
		{
			if (vx[i] < minx) minx = vx[i];
			if (vx[i] > maxx) maxx = vx[i];
			if (vy[i] < miny) miny = vy[i];
			if (vy[i] > maxy) maxy = vy[i];
		}
		double polywidth = abs(maxX - minX);
		double polyheight = abs(maxY - minY);
		double cellSize = polywidth > polyheight ? polywidth : polyheight; // online this is Math.min(width, height)
		double h = cellSize * 0.5;
		double minh = cellSize * .125 < 16 ? 16 : cellSize * .125;
		double precision = minh * 0.1;
		hd_polycell pcell;
		// start with center spot
		let bestCell = new("hd_polycell").init(sec.CenterSpot.x, sec.CenterSpot.y, h, vx, vy, sec);
		// get initial cells
		Array<hd_polycell> cells;
		for (double x = MinX; x < MaxX; x += cellSize)
		{
			for (double y = MinY; y < MaxY; y += cellSize)
			{
				cells.Push(new("hd_polycell").init(x + h, y + h, h, vx, vy, sec));
			}
		}
		int j = cells.Size();
		int numProbes = cells.Size();
		while (cells.Size())
		{
			// find best cell
			double qD = 0;
			int nD = 0;
			int j = 0;
			while (j < cells.Size())
			{
				if (cells[j].D != cells[j].D) // delete nan
				{
					cells.Delete(j);
				}
				else if (cells[j].D > qD)
				{
					qD = cells[j].D;
					nD = j;
				}
				j++;
			}
			if (cells.Size() == 0) break;
			let compareCell = cells[nD];
			cells.Delete(nD);
			double d = bestCell.D;
			if (compareCell.D > bestCell.D) bestCell = compareCell;
			if (compareCell.Max - d <= precision || h < minh) continue;
			// drill down and split the cell into 4
			h = compareCell.H * 0.5;
			int i = cells.Size();
			cells.Push(new("hd_polycell").init(compareCell.x - h, compareCell.y - h, h, vx, vy, sec));
			cells.Push(new("hd_polycell").init(compareCell.x - h, compareCell.y + h, h, vx, vy, sec));
			cells.Push(new("hd_polycell").init(compareCell.x + h, compareCell.y - h, h, vx, vy, sec));
			cells.Push(new("hd_polycell").init(compareCell.x + h, compareCell.y + h, h, vx, vy, sec));
			numProbes += cells.Size() - i;
		}
		return (bestCell.X, bestCell.Y);
	}
	vector2 centroid(Sector sec)
	{
		vector2 _centroid;
		double signedArea, x0, y0, x1, y1, a;
		// get outer perimeter
		Array<double> vx;
		Array<double> vy;
		Array<int> done;
		nextperimeter(sec, vx, vy, done);
		for (int i = 0; i < vx.Size() - 1; i++)
		{
			x0 = vx[i];
			y0 = vy[i];
			x1 = vx[i + 1];
			y1 = vy[i + 1];
			a = x0 * y1 - x1 * y0;
			signedArea += a;
			_centroid.x += (x0 + x1) * a;
			_centroid.y += (y0 + y1) * a;
		}
		int i = vx.Size() - 1;
		x0 = vx[i];
		y0 = vy[i];
		x1 = vx[0];
		y1 = vy[0];
		a = x0 * y1 - x1 * y0;
		signedArea += a;
		_centroid.x += (x0 + x1) * a;
		_centroid.y += (y0 + y1) * a;
		signedArea *= 0.5;
		if (signedArea == 0)
		{
			return sec.CenterSpot;
		}
		else
		{
			_centroid.x /= (6.0 * signedArea);
			_centroid.y /= (6.0 * signedArea);
			return _centroid;
		}
	}
	// quickSort functions
	void swap(Array<hd_sectors> secs, int pos1, int pos2)
	{
		let temp = secs[pos1];
		secs[pos1] = secs[pos2];
		secs[pos2] = temp;
	}
	int partition(Array<hd_sectors> secs, int low, int high, int pivot)
	{
		int i = low;
		int j = low;
		while (i <= high)
		{
			if (secs[i].area < secs[pivot].area)
			{
				i++;
			}
			else
			{
				swap(secs, i, j);
				i++;
				j++;
			}
		}
		return j-1;
	}
	void quickSort(Array<hd_sectors> secs, int low, int high)
	{
		if (low < high)
		{
			int pivot = high;
			int pos = partition(secs, low, high, pivot);
			quickSort(secs, low, pos-1);
			quickSort(secs, pos+1, high);
		}
	}
	color shade(color c, double luma)
	{
		if (luma != 0.0)
		{
			int r, g, b;
			r = clamp(int(c.r * (1 + luma * .299)), 0, 255);
			g = clamp(int(c.g * (1 + luma * .299)), 0, 255);
			b = clamp(int(c.b * (1 + luma * .299)), 0, 255);
			return Color(r, g, b);
		}
		else
		{
			return c;
		}
	}
	color tint(color c, double luma)
	{
		if (luma != 0.0)
		{
			int r, g, b;
			if (r == g && r == b)
			{
				r = clamp(int(c.r * (1 + luma * .299)), 0, 255);
				g = clamp(int(c.g * (1 + luma * .299)), 0, 255);
				b = clamp(int(c.b * (1 + luma * .299)), 0, 255);
			}
			else
			{
				r = clamp(int(c.r * (1 + luma * .2126)), 0, 255);
				g = clamp(int(c.g * (1 + luma * .7152)), 0, 255);
				b = clamp(int(c.b * (1 + luma * .0722)), 0, 255);
			}
			return Color(r, g, b);
		}
		else
		{
			return c;
		}
	}
}

