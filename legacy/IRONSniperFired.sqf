//SAFTEY FUNCTION TO ONLY RUN AFTER GLOBAL VARIABLES ARE INITIALIZED===========================
if (!isServer) exitWith {};
_GlobalVarsInitialized = missionNamespace getVariable ["IRON_globalVars", false];
waitUntil {
	sleep 0.1; _GlobalVarsInitialized = missionNamespace getVariable ["IRON_globalVars", false];
	_GlobalVarsInitialized
};																				//BY IRONSIGHT
//=============================================================================================

// null = [this] execVM "L917\Sniper\sniperCore.sqf";        // in unit init to run script
hint str _this;
_unit = _this;
_unit setCombatmode "blue";
_unit setCombatmode "yellow";
//hint "blue";
sleep 10;

//hint "red";
if (true) exitwith {_unit setCombatmode "yellow";}