/**
Made by Schlaak
edited by ir0nsight
*/
/**
	following code is local, needs to be run clientside.
 */
if (hasInterface) then //check if running machine == player
{	//NOTE: only running on client from here 
	hint "offroad running";

	//---------------------check for already running instances------start
	private _allowRun = true;
	//(player getVariable ["offRoadRunning",false]);
	if (!_allowRun) exitWith { //only continue if skript isnt already running
		debugLog "offroadSkript already running.";
	};
	player setVariable ["offRoadRunning",true,false]; //prevent other instances from intialising
	//---------------------check for already running instances------end

	//params to run loop with:
	_surfacearray = ["#SurfRoadDirt","#SurfRoadConcrete","#SurfRoadTarmac","#concrete","#dirtrunway","#road","#road_exp","#concrete_exp","#GdtConcrete","#GdtSoil","#GdtConcrete","#GdtConcrete","#GdtDirt","concrete_out","concrete_inside","#concrete_in_exp","#concrete_hall_exp","#GdtGrassShort","#GdtAsphalt","#UTCONCRETE "];
	private _kill = false; //create breakout var
	private _skip = false; //create ignore var. 
	
	//----------------------------CBA SETTINGS Init--------------START
	[ //cba settings params
		"offroad_enable", //display name
		"CHECKBOX", //GUI type
		"enable/disable offroad camera shake script", //tooltip
		"offroad script", //category
		true,	//default value
		true, 	//isglobal (same setting for everyone)
		{
			missionNamespace setVariable ["skipOffroad",(!_this),false]; //update variable on player
			hint ("cba setting changed to " + str (missionNamespace getVariable ["skipOffroad","undefined"]));
		}, //execute on change
		false //requires restart
	] call CBA_fnc_addSetting;
	//----------------------------CBA SETTINGS Init--------------END

	private _enableCamShake = false;
	private _i = 0;
	private _isoffroad = false;
	//LOOP START
	while {!_kill} do
	{
		_kill = missionNamespace getVariable ["killOffroad",false]; 
		_skip = missionNamespace getVariable ["skipOffroad",false]; 
		if (!_skip) then {
			_isoffroad = ((vehicle player) isKindOf "car" && !(isOnRoad (vehicle player)) && !((surfaceType getpos player) in _surfacearray) && (vehicle player != player) &&((speed (vehicle player) >= 3) OR (speed (vehicle player) < -3)) && (vehicle player) isKindOf "car" );
			if (_isoffroad) then {
				_enableCamShake = true;
				_camshakepower = 1 * 0.15 * speed (vehicle player);
				_camshakefreq = 1.5 * speed (vehicle player) / 7.5;
				enableCamShake true;	
			//	addCamShake [_camshakepower, 8, _camshakefreq];	
				addCamShake [5, 3, 10];	
				hint ("off road: " + str _camshakepower + "|" + str _camshakefreq);			
			} else {
				resetCamShake;
				hint "on road";
			}
		} else {
			enableCamShake false; //TODO does this conflict with other wobble mods?
		};
		_i = _i + 1;
		sleep 2;
	}; //LOOP END
};



