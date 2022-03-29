//drone buatan org luar cuma gw fix(TsumuX)



//drone
new Drones[MAX_PLAYERS];
new PlayerBody[MAX_PLAYERS];

public Onplayerconnet(playerid)
{
    SetPVarInt(playerid, "DroneSpawned", 0);
 	SetPVarFloat(playerid, "OldPosX", 0);
	SetPVarFloat(playerid, "OldPosY", 0);
	SetPVarFloat(playerid, "OldPosZ", 0);
	return 1;
}

public OnPlayerDeath(playerid)
{
    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 )
	{
    	SetPVarInt( playerid, "DroneSpawned", 0 );
    	DestroyVehicle( Drones[playerid] );
    	SendClientMessage(playerid, COLOR_LIME, "INFO{FFFFFF}Drone anda otomatis kembali ke inventori anda." );
	}
	return 1;
}

public OnPlayerDisconnect(playerid)
{
    DestroyVehicle(Drones[playerid]);
    return 1;
}

public OnPlayerEnterVehicle(playerid)
{
    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 ) return SendClientMessage(playerid, COLOR_RED, "ERROR{FFFFFF}:aksi ini tidak bisa dilakukan");
	return 1;
}
//CMD
CMD:drone(playerid, params[])
{
	new str[128];
 	if( sscanf( params, "s", str ) ) return SendClientMessage( playerid, COLOR_LIME, "GUNAKAN{FFFFFF}: /drone 1[spawn] 2[simpan] 3[ledakan]" );

  	if( strcmp( str, "1" ) == 0 )
	  {
  	    if( GetPVarInt( playerid, "DroneSpawned" ) == 0 )
		  {
  	        new Float:Health;
  	        GetPlayerHealth( playerid, Health );

  	        if(Health != 0)
			  {
	  	        new Float:PosX, Float:PosY, Float:PosZ;
	  	        new Float:PlayerFacingAngle;
	  	        GetPlayerFacingAngle(playerid, PlayerFacingAngle);
	  	        GetPlayerPos( playerid, PosX, PosY, PosZ );
	            SetPVarFloat( playerid, "OldPosX", PosX );
				SetPVarFloat( playerid, "OldPosY", PosY );
				SetPVarFloat( playerid, "OldPosZ", PosZ );
				SetPVarInt(playerid, "UserSkin", GetPlayerSkin(playerid));
		 	    SetPVarInt( playerid, "DroneSpawned", 1 );
		 	    SendClientMessage( playerid, COLOR_LIME, "INFO{FFFFFF}:anda mengeluarkan drone." );
		 	    Drones[playerid] = CreateVehicle( 465, PosX, PosY, PosZ + 20, 0, 0, 0, 0, -1 );
		 	    GameTextForPlayer(playerid,"~g~Drone~w~Cam", 5000, 1);
		 	    SetPlayerChatBubble(playerid, "menggunakan drone",COLOR_NEWS,15.0,10000);
		 	    PutPlayerInVehicle( playerid, Drones[playerid], 0 );
		 	    Fuell[Drones[playerid]] = MAX_VEHICLE_FUEL;
		 	    SetVehicleParamsEx(Drones[playerid], VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
				GetVehicleParamsEx(Drones[playerid], engine, lights, alarm, doors, bonnet, boot, objective);
				PlayerBody[playerid] = CreateActor(GetPVarInt(playerid, "UserSkin"), PosX, PosY, PosZ, PlayerFacingAngle);

			}
	  	}
		  else
		  {
	  	    SendClientMessage( playerid, COLOR_RED, "ERROR{FF0000}Anda sudah mengeluarkan drone!" );
	  	}
 	}
	 else
	 {
 	    if( strcmp( str, "3" ) == 0 )
		 {
	  	    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 )
			  {
	  	        new Float:PosX, Float:PosY, Float:PosZ;
	  	        GetVehiclePos( Drones[playerid], PosX, PosY, PosZ );

		 	    SetPVarInt( playerid, "DroneSpawned", 0 );
		 	    SendClientMessage( playerid, COLOR_LIME, "INFO{FFFFFF}:anda meledakkan drone anda." );
				DestroyVehicle( Drones[playerid] );
				DestroyActor(PlayerBody[playerid]);
				CreateExplosion( PosX, PosY, PosZ, 7, 25 );

				SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
		  	}
			  else
			   {
		  	    SendClientMessage( playerid, COLOR_RED, "ERROR{FFFFFF}:anda belum mengeluarkan drone!" );
		  	}
	 	}
		 else
		 {
	 	    if( strcmp( str, "2" ) == 0 )
			 {
			    if(!IsPlayerInRangeOfPoint(playerid, 15.0, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ))) return SendClientMessage(playerid, COLOR_RED, "ERROR{FFFFFF}:harus disekitar pemilik");
		  	    if( GetPVarInt( playerid, "DroneSpawned" ) == 1 )
				  {
			 	    SetPVarInt( playerid, "DroneSpawned", 0 );
			 	    SendClientMessage( playerid, COLOR_LIME, "INFO{FFFFFF}:anda mematikan drone anda." );
			 	    DestroyVehicle( Drones[playerid] );
			 	    DestroyActor(PlayerBody[playerid]);
			 	    SetPlayerPos(playerid, GetPVarFloat( playerid, "OldPosX" ), GetPVarFloat( playerid, "OldPosY" ), GetPVarFloat( playerid, "OldPosZ" ));
			  	}
				  else
				  {
			  	    SendClientMessage( playerid, COLOR_RED, "ERROR{FFFFFF}:anda tidak mengeluarkan drone!" );
			  	}
		 	}
	 	}
 	}
 	return 1;
}
