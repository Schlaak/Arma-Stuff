//nul = [this,true] execvm "scripts\rndAnimChatter.sqf" talk
//nul = [this,false] execvm "scripts\rndAnimChatter.sqf" notalk

if (!isServer)  exitwith {};

private ["_OBJ","_bool"];
_OBJ = _this select 0;
_bool = _this select 1;

//Animation
_anim = ["PATROL","PATROL","BRIEFING","EASE","EASE"] call BIS_fnc_selectRandom;
_equip = ["VEST","FULL","NO_TOUCH"] call BIS_fnc_selectRandom;


//"TALK",
_DoAnim = [_OBJ,_anim,[_equip, true, false], true] execvm "scripts\PLP_CalmSoldier.sqf";
_OBJ disableai "fsm";
_OBJ allowdamage false;
_OBJ enableDynamicSimulation true;


if (_bool) then
{

//chatter
while {alive _OBJ} do
{


_simulation = simulationEnabled _OBJ;
waitUntil {if !(_simulation) then {sleep 60}; _simulation = simulationEnabled _OBJ; _simulation};



_chatter = [
"rusk1",
"rusk2",
"rusk3",
"rusk4",
"rusk5",
"rusk6",
"rusk7",
"rusk8",
"rusk9",
"rusk10",
"rusk11",
"rusk12",
"rusk13",
"rusk14",
"rusk15",
"rusk16",
"rusk17",
"rusk18",
"rusk19",
"rusk20",
"rusk21",
"rusk22",
"rusk23",
"rusk24",
"rusk25",
"rusk26",
"rusk27",
"rusk28",
"rusk29",
"rusk30",
"rusk31",
"rusk32",
"rusk33",
"rusk34",
"rusk35",
"rusk36",
"rusk37",
"rusk38",
"rusk39",
"rusk40",
"rusk41",
"rusk42",
"rusk43",
"rusk44",
"rusk45",
"rusk46",
"rusk47",
"rusk48",
"rusk49",
"rusk50",
"rusk51",
"rusk52",
"rusk53",
"rusk54",
"rusk55",
"rusk56",
"rusk57",
"rusk58",
"rusk59",
"rusk60",
"rusk61",
"rusk62",
"rusk63",
"rusk64",
"rusk65",
"rusk66",
"rusk67",
"rusk68",
"rusk69",
"rusk70"] call BIS_fnc_selectRandom;


sleep 17;
[_OBJ, _chatter, 45] call CBA_fnc_globalSay3d;
sleep 12;
sleep (20 + (random 50));
};

};
