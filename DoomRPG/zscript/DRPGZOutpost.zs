// Sings Zscript (Many thanks JSO_x for help))

class OutpostSign: Actor {

    Default	{
	Radius 16;
	Height 16;
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	}

	bool dynlight;

    override void Tick() {

        if (CVar.GetCVar("drpg_toaster").GetBool() == true) {

			Super.Tick(); // Specifically here this call is not necessary and in general will slow down a little bit, but the bad habits of the lack of treatment of the parent method do not want to instill in anyone.

			bool isVisibleToAnyPlayer = false;

			for ( int i = 0; i < MAXPLAYERS; i++ ) {
				PlayerInfo pl = players[ i ];

				if ( !playeringame[ i ] || !pl || !pl.mo )
					continue;
		
				if ( pl.mo.CheckSight( self ) || pl.mo.Distance2D( self ) < 1024) {
					isVisibleToAnyPlayer = true;
					break;
				}
			}

			if ( isVisibleToAnyPlayer ) {
				if ( !dynlight ) {
					SetStateLabel( "SpawnDL" );
					dynlight = true;
				}
			} else if ( dynlight ) {
					SetStateLabel( "SpawnNoDL" );
				dynlight = false;
			}
		}
		else
		{
			SetStateLabel( "SpawnDL" );
			dynlight = true;
		}
	}

    States {
	Spawn:
		OMRK A 0;
	SpawnNoDL:
        OMRK A -1;
        Stop;
      SpawnDL:
        OMRK A -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignMissionBBS2: OutpostSign {

    States {
	Spawn:
		OMRK A 0;
	SpawnNoDL:
        OMRK A -1;
        Stop;
      SpawnDL:
        OMRK A -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignShopS2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 1.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK B 0;
	 SpawnNoDL:
        OMRK B -1;
        Stop;
       SpawnDL:
        OMRK B -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignTransporter2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    override void Tick() {

        if (CVar.GetCVar("drpg_toaster").GetBool() == true) {

			Super.Tick(); // Specifically here this call is not necessary and in general will slow down a little bit, but the bad habits of the lack of treatment of the parent method do not want to instill in anyone.

			bool isVisibleToAnyPlayer = false;

			for ( int i = 0; i < MAXPLAYERS; i++ ) {
				PlayerInfo pl = players[ i ];

				if ( !playeringame[ i ] || !pl || !pl.mo )
					continue;
		
				if ( pl.mo.CheckSight( self ) || pl.mo.Distance2D( self ) < 3072) {
					isVisibleToAnyPlayer = true;
					break;
				}
			}

			if ( isVisibleToAnyPlayer ) {
				if ( !dynlight ) {
					SetStateLabel( "SpawnDL" );
					dynlight = true;
				}
			} else if ( dynlight ) {
					SetStateLabel( "SpawnNoDL" );
				dynlight = false;
			}
		}
		else
		{
			SetStateLabel( "SpawnDL" );
			dynlight = true;
		}
	}

    States {
	Spawn:
		OMRK C 0;
    SpawnNoDL:
        OMRK C -1;
        Stop;
      SpawnDL:
        OMRK C -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignSkillComputer2: OutpostSign {

    States {
	Spawn:
		OMRK D 0;
    SpawnNoDL:
        OMRK D -1;
        Stop;
      SpawnDL:
        OMRK D -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignRechargePads2: OutpostSign {

    States {
	Spawn:
		OMRK G 0;
    SpawnNoDL:
        OMRK G -1;
        Stop;
      SpawnDL:
        OMRK G -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignEastArea2: OutpostSign {

    States {
	Spawn:
		OMRK F 0;
    SpawnNoDL:
        OMRK F -1;
        Stop;
      SpawnDL:
        OMRK F -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignItemRoulette2: OutpostSign {

    States {
	Spawn:
		OMRK H 0;
    SpawnNoDL:
        OMRK H -1;
        Stop;
      SpawnDL:
        OMRK H -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignArena2: OutpostSign {

    States {
	Spawn:
		OMRK E 0;
    SpawnNoDL:
        OMRK E -1;
        Stop;
      SpawnDL:
        OMRK E -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignArenaFar2: OutpostSign {

    States {
	Spawn:
		OMRK E 0;
    SpawnNoDL:
        OMRK E -1;
        Stop;
      SpawnDL:
        OMRK E -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignArenaWS2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK I 0;
    SpawnNoDL:
        OMRK I -1;
        Stop;
      SpawnDL:
        OMRK I -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignArenaStart2: OutpostSign {

    States {
	Spawn:
		OMRK J 0;
    SpawnNoDL:
        OMRK J -1;
        Stop;
      SpawnDL:
        OMRK J -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignArenaReady2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK K 0;
    SpawnNoDL:
        OMRK K -1;
        Stop;
      SpawnDL:
        OMRK K -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignShootingRange2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK M 0;
    SpawnNoDL:
        OMRK M -1;
        Stop;
      SpawnDL:
        OMRK M -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignSale2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK N 0;
    SpawnNoDL:
        OMRK N -1;
        Stop;
      SpawnDL:
        OMRK N -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignSurgeonCapsule2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK O 0;
    SpawnNoDL:
        OMRK O -1;
        Stop;
      SpawnDL:
        OMRK O -1 Light("OUTPOSTSIGN");
        Stop;
    }
}

class OutpostSignDisassemblingDevice2: OutpostSign {

    Default	{
	+SpawnCeiling;
    +NoGravity;
    +WALLSPRITE;
	Scale 0.5;
	Radius 16;
	Height 16;
	}

    States {
	Spawn:
		OMRK P 0;
    SpawnNoDL:
        OMRK P -1;
        Stop;
      SpawnDL:
        OMRK P -1 Light("OUTPOSTSIGN");
        Stop;
    }
}