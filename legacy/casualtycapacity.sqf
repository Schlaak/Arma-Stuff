//scriptcondition is einsatzbereit:


//fleestuff = [this,Fluchtpunkt] execvm "scripts\casualtycapacity.sqf";
if (!isserver) exitwith {};

private ["_unit","_factor","_limit","_groupcount","_pointblank","_holdwp","_Retreatwp","_fleewp","_grp"];
sleep 10;

_unit = _this select 0;
_Fluchtpunkt = _this select 1;
_grp = group _unit;

_groupcount = (count (units group _unit));


_loop = true;
_hold = FALSE;
_retreat = FALSE;




while { _loop } do
{

sleep 3;

_leadergrp = leader _grp;
_array = units group _leadergrp;
//count (_guards select {alive _x});
//_groupsize = (count (units group _leadergrp select {alive _x}););
_groupsize = (count ((units group _leadergrp) select {alive _x}));
	//systemchat format  ["%1 %2",_groupsize,_grp];

// Halten
if (_groupcount > _groupsize && !_hold && !_retreat) then {

	//systemchat format  ["%1 von %3  ---  %2 HOLD",_groupsize,_grp, _groupcount];
	_leadergrp = leader _grp;
	_coords = mapGridPosition leader _grp ; //[position leader _grp] call BIS_fnc_locationDescription;
	//leader _grp sidechat format  ["Feindkontakt und Verwundeten auf Position %2",_grp,_coords];
	[[leader _grp, format ["Feindkontakt und Verwundeten auf Position %2.",_grp,_coords,_groupsize]], "sidechat", resistance, false ,false] call BIS_fnc_MP;
	["radioalert", "playsound", true, true] call BIS_fnc_MP;
	sleep 2;


    //delete all wps
	for "_i" from count waypoints _grp - 1 to 0 step -1 do
	{
	deleteWaypoint [_grp, _i];
	};
	//-
	//[_unit] call lambs_wp_fnc_taskReset;

	_holdwp = _grp addWaypoint [position leader _grp, 0];
	_holdwp setWaypointType "HOLD";

	_hold = true;
	sleep 1;


	//systemchat format  ["%1 %2",_groupsize,_grp];
};

_groupsize = (count units _grp);

// Rückzug
if (_groupsize <= (_groupcount * 0.7) && !_retreat && _hold) then {

	//systemchat format  ["%1 von %3  ---  %2 RETREAT",_groupsize,_grp, _groupcount];
	_leadergrp = leader _grp;
	_leadergrp sideradio "causcap2";
	_leadergrp = leader _grp;
	_coords = mapGridPosition leader _grp ;//[position leader _grp] call BIS_fnc_locationDescription;
	//leader _grp sidechat format  ["Meldung: Haben schwere Verluste auf Position %2. Ziehen uns zurück!",_grp,_coords];

	[[leader _grp, format ["Meldung: Haben schwere Verluste auf Position %2. Ziehen uns zurück!",_grp,_coords,_groupsize]], "sidechat", resistance, false ,false] call BIS_fnc_MP;
	["radioHQ2", "playsound", true, true] call BIS_fnc_MP;
	sleep 2;




    //delete all wps
	for "_i" from count waypoints _grp - 1 to 0 step -1 do 	{	deleteWaypoint [_grp, _i];	};
	//-
	//[_unit] call lambs_wp_fnc_taskReset;

	[_unit, getPos _Fluchtpunkt] spawn lambs_wp_fnc_taskAssault;

	sleep 1;
	//systemchat format  ["%1 von %3  ---  %2",_groupsize,_grp, _groupcount];
	_retreat = true;
};



_groupsize = (count units _grp);

// Flucht
if (_groupsize <= (_groupcount * 0.5) && _retreat && _hold ) then {

	//systemchat format  ["%1 von %3  ---  %2 FLEE!",_groupsize,_grp, _groupcount];
	_leadergrp = leader _grp;
	leader _grp sideradio "causcap3";
	_coords = mapGridPosition leader _grp ;//[position leader _grp] call BIS_fnc_locationDescription;
	//leader _grp sidechat format  ["Wir sind im Arsch! %3 Mann verbleibend, voller Rückzug. RTB!",_grp,_coords,_groupsize];
	[[leader _grp, format ["Wir sind im Arsch! %3 Mann verbleibend, voller Rückzug. RTB!",_grp,_coords,_groupsize]], "sidechat", resistance, false ,false] call BIS_fnc_MP;

	["radioHQ2", "playsound", true, true] call BIS_fnc_MP;
	sleep 2;





    //delete all wps
	for "_i" from count waypoints _grp - 1 to 0 step -1 do
	{
	deleteWaypoint [_grp, _i];
	};
	//-
	//[_unit] call lambs_wp_fnc_taskReset;
	//[_unit] call lambs_wp_fnc_taskReset;
	[_unit, position _Fluchtpunkt, true] spawn lambs_wp_fnc_taskAssault;
    _fleewp = _grp addWaypoint [position _Fluchtpunkt, 0];

	//hint "flucht";
	_fleewp setWaypointStatements ["true", "{deleteVehicle _x} foreach units group this "];

	sleep 1;
	systemchat format  ["%1 %2",_groupsize,_grp];

    _loop = FALSE;
	/* STATEMENT */
};

};

