// [this, east] execvm "scripts\meldung.sqf";


// sidechat + sideradio auf remote exec
//
//
if (!isserver) exitwith {};


_unit = group (_this select 0);
_TL = leader _unit;

_side = _this select 1;
if (isserver) then
{

while {true} do
	{

	sleep 10;

	/*
	_groupsize = (count ((units _unit) select {alive _x}));
	switch (_groupsize) do
	{
		case (<5):
		{

		};
		case (>5):
		{

		};
		default
		{

		};
	};
	*/

	_enemies = _TL nearTargets 500;
	_enemies = _enemies select {(_unit knowsAbout (_x select 4)) > 0 && _x select 2 == _side};
	if (count _enemies > 3) then {


	[_TL, (format ["%1 für %4, Feindkontakt bei %2 nahe %3",(groupId _unit), (mapGridPosition _TL),( text nearestLocation [player, "namevillage"]),(groupid HQ_west)])] remoteExec ["sideChat", -2];
	_msg = selectrandom ["Dfeind1","Dfeind2","Dfeind3","Dfeind4"];
	[_TL, _msg] remoteExec ["sideRadio", -2];
	//(leader _unit) sideRadio _msg;
	//[leader _unit, _msg, "sideradio"] call BIS_fnc_sayMessage;
	sleep 300;
	};


	};
};