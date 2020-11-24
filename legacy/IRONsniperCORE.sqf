//=============================================================================================
// By Ir0nsight, a great coder!

//null = [this] execVM "scripts\IRONsniperCore.sqf";        // in unit init to run script

//hint "sniper script started";



_unit = _this select 0;
_unit disableAI "PATH";
_unit setUnitPos "down";
_unit setSkill ["spotDistance", 1];
_unit setSkill ["spotTime",1];
//_unit dowatch (this getrelpos [150,0]);
//This command will disable Vcom AI on a group entirely.


while {alive _unit} do {
	   _Dtargets = [];

		_enemySides = [side _unit] call BIS_fnc_enemySides;
		_radius = 2000;
		_nearEnemies = allUnits select {_x distance _unit < _radius AND side _x in _enemySides};
	{_unit reveal _x;_Dtargets pushBack _x} foreach _nearEnemies;
	   _Tcount = count _Dtargets;
	   hint format ["Ziele: %1, Zeit: %2",_nearEnemies,time];
	   UIsleep 3;
	   //hint "sniper choose new target";
	   if (_Tcount >= 1) then {
	   _targetSniper = (selectRandom _Dtargets);
	   _unit dotarget _targetSniper;
	   _unit commandFire _targetSniper;
	   _unit doFire _targetSniper;
	   _unit fireAtTarget  [_targetSniper, currentweapon _unit];
	   uisleep 8 + (random 20);
	   //hint str _targetSniper;
	   };


	   uisleep 8;
	   _unit setVehicleAmmo 1;

	if (count waypoints group _unit == currentwaypoint group _unit) then    //keine aktiven waypoints
		{
			_unit setunitpos "down";
			_unit disableAI "path";

			(group _unit)  setBehaviour "combat";
		}
	else
		{

			_unit setunitpos "middle";
			_unit enableAI "path";
			(group _unit)  setBehaviour "careless";
			(group _unit) setSpeedMode "full";

		};
	};
