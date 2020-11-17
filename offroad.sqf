/**
Made by Schlaak
edited by ir0nsight
*/
/**
	following code is local, needs to be run clientside.
 */
if (hasInterface) then //check if running machine == player
{	//NOTE: only running on client from here 
	//---------------------check for already running instances------start
	private allowRun = player getVariable ["offRoadRunning",false];
	if (!allowRun) exitWith { //only continue if skript isnt already running
		debugLog "offroadSkript already running.";
	};
	player setVariable ["offRoadRunning",true,false]; //prevent other instances from intialising
	//---------------------check for already running instances------end

	//params to run loop with:
	_surfacearray = ["#SurfRoadDirt","#SurfRoadConcrete","#SurfRoadTarmac","#concrete","#dirtrunway","#road","#road_exp","#concrete_exp","#GdtConcrete","#GdtSoil","#GdtConcrete","#GdtConcrete","#GdtDirt","concrete_out","concrete_inside","#concrete_in_exp","#concrete_hall_exp","#GdtGrassShort","#GdtAsphalt","#UTCONCRETE "];
	private _kill = false; //create breakout var
	private _skip = false; //create ignore var. 
	
	//LOOP START
	while {!_kill} do
	{
		_kill = missionNamespace getVariable ["killOffroad",false]; 
		_skip = missionNamespace getVariable ["skipOffroad",false]; 
		if (!_skip) then {
			
			if ( (vehicle player) isKindOf "car" ) then
			{
				waituntil { //TODO: suspends complete skript in loop with no timeout till condition is met.
					!(isOnRoad (vehicle player)) && !((surfaceType getpos player) in _surfacearray) && (vehicle player != player) &&((speed (vehicle player) >= 3) OR (speed (vehicle player) < -3)) && (vehicle player) isKindOf "car" 
				};
				enableCamShake true;
				_camshakepower = 0.15 * speed (vehicle player);
				_camshakefreq = speed (vehicle player) / 7.5;
				addCamShake [_camshakepower, 8, _camshakefreq];
			};
		};
		sleep 2;
	}; //LOOP END
};



