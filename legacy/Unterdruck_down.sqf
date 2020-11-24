//Generelle Infos: Einheit wird automatisch durch script ausgetattet (ausser rucksack) und hat begrenzt Munition (kann im Gurtanzahl var iable eingestell werden). Einheit ist gedacht für stationäres MG nest im Wald bis 400 m sichtweite. Schiesst nur bei direktem Sichtkontakt, erste salve geht normalerweise in den Boden. Die einheit bewegt sich nciht und spottet bei direktem sichtkontakt den gegner instant, beschiesst auch sofort. Hört sich overpowered an, allerdings schiesst die MG einheit extrem ungezielt und als "MG nest" soll sie ja auch überwachen, das instant spotten bei sichtkontakt ist also vollkommen realisitsch (ausser für ghillies vllt). Einheit sollte nicht alleine sondern mit 2-3 weiteren standard KIs platziert werden (muss aber nicht). Kann nur auf vorplatzierte Einheiten aus dem editor angewendet werden, ZEUS unterstützung kommt vllt in der zukunft
//befehl für einheiten init: null = [this] execVM "IRON\unterdruck_down.sqf";
_unit = _this select 0;
_unit setVariable ["lambs_danger_disableAI",true];
_unit setunitpos "down";
_unit setCombatMode "blue";
_unit disableAI "path";
(group _unit)  setBehaviour "stealth";
_orgGroupSize = count units group _unit;
//=========wait until enemy in engagmement zone==========

	_UnitsInMarker = 0;
	waitUntil {
		_count = 0;
		_UnitsInMarker = allUnits inAreaArray "engage" select {side _x == WesT};
		_count = count _UnitsInMarker;
		//hint str _UnitsInMarker;
		sleep 5;
		_count > 0;
	};
	_UnitsInMarker = 0;
	_count = 0;



(group _unit)  setBehaviour "combat";
_unit setunitpos "middle";
//_unit sideChat "Script gestartet, Loadout wird erstellt";
//Stellt einheit auf "Nicht feuern", damit nicht vanilla gefeuert wird sondern nur durch geskriptetes forceWeaponFire
//_unit setCombatMode "BLUE";
//_unit disableAI "path";

_unit setSkill ["aimingAccuracy",0.5];
_unit setSkill ["aimingshake",0.5];

_Gurtlaenge = selectRandom [50,100,150,200];
_Gurtanzahl = 10;

_gun = currentWeapon _unit;	//gets gun
//_reloadTime = (getNumber (configFile >> "Cfgweapons" >> _gun >> "FullAuto" >> "reloadTime"));
_reloadTime = 0.02;
//___________________________________



//__________________________________

/*
sleep 2;
for "_i" from 0 to 500 do {
[_unit, _gun] call BIS_fnc_fire;
sleep _reloadTime;
_count = _unit ammo _gun;
//hint str _count;
};
sleep 10;
//hint "vorbei";
*/
//_____________________________


_SchussCounter = 0; //Zählt Schüsse um realistisches Nachladen zu ermöglichen
_GurtCounter = 0; //Zählt Munitions Gurte um maximale Munitionsmenge festzulegen, unabhängig vom Schützeninventar
_geladen = false;
_zielgueltig = false;
_ZielControl = 0;
_magazineClass = currentMagazine _unit;
_Schnarch = 5;
_cosmin = 2;


_lastDowntime = time;	//empty variable for later use


_retreat = 0;
waitUntil {
		_unit setunitpos "middle";
		_unit disableAI "path";
		(group _unit) setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
		(group _unit)  setBehaviour "combat";
		_unit setCombatMode "blue";
		_unit setUnitRecoilCoefficient 0.1;
	//hint str currentwaypoint group _unit;
/*	if (count waypoints group _unit == currentwaypoint group _unit) then	//keine aktiven waypoints
	{
		_unit setunitpos "middle";
		_unit disableAI "path";
		(group _unit) setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
		(group _unit)  setBehaviour "combat";
		_unit setCombatMode "RED";
	}
	else
	{
		(group _unit) setVariable ["Vcm_Disable",false]; //This command will disable Vcom AI on a group entirely.
		_unit setunitpos "up";
		_unit enableAI "path";
		(group _unit)  setBehaviour "aware";
		(group _unit) setSpeedMode "full";
		_unit setCombatMode "BLUE";
	};
*/
	_randomDowntime = random 10;
	if ((time > _lastDowntime + 15) AND (_randomDowntime < 1)) then {
		//hint str "Staying down";
		_lastDowntime = time;
		_unit setunitpos "down";
		sleep 5;
	};
	//hint str (_randomDowntime > 1);
	if (_unit ammo primaryWeapon _unit > 0) then //Waffe geladen, Ziele verfügbar ? wird geprüft
	{

		//_unit sideChat "Waffe geladen, prüfe verfügbare Ziele";
			_enemySides = [side _unit] call BIS_fnc_enemySides;
			_radius = 800;
			_nearEnemies = allUnits select {_x distance _unit < _radius AND side _x in _enemySides};
			_ZielControl = count _nearEnemies;
			//_unit sideChat format ["%1",_ZielControl];
			if (_ZielControl >= 1) then //Kontrolliert ob Ziele gefunden wurden, nur dann wird _Ziel ausgewählt
			{
				_Schnarch = 0.2;
				_Ziel = "";	//empty target
				{	//check visibilty for all Targets until one returns true
					_ziel = _x;
					_vecTar = getPosASL _Ziel vectorDiff getPosASL _unit;
					_weaponVectorDir = _unit weaponDirection currentWeapon _unit;
					_cos = acos (_vecTar vectorCos _weaponVectorDir);
					_vector = [_unit, _Ziel] call BIS_fnc_dirTo;
					_cansee = [objNull, "VIEW"] checkVisibility [eyePos _unit, eyePos _ziel];

					_insSurface = lineIntersectssurfaces [eyepos _unit, eyePos _Ziel, _unit, _Ziel, false,1,"VIEW","FIRE",true];//gibt aus: Oberflächen die zwischen _Ziel und Schütze sind
					_countINSSurface = count _insSurface; //ist > 0 wenn Oberflächen zwischen Schütze und _Ziel
					_distance = _unit distance _ziel;
					_randomDist = random [100,200,400] / _distance;
					_unit globalChat format ["Sichtbarkeit: %1, Entfernung: %2, Oberflächen: %3, Zufall: %4",_cansee, _distance, _countINSSurface,_randomDist];
					if (_ziel isKindOf "helicopter") then {_cosMin = 15;} else {_cosMin = 5};

					if (_cansee > 0.3 && _cos < _cosMin && _countINSSurface < 1 && (_randomDist >= 0.5)) exitwith //Sichtkontakt besteht, Feuer wird ausgelöst
					{
						_unit reveal _Ziel;
						_unit doWatch (getpos _ziel);
						_unit doTarget _ziel;

						//Schiessbefehl
						_bursts = selectRandom [3];
						_handle = _unit doFIre _Ziel;
						for "_i" from 0 to _bursts do
						{
							_burstLength = selectRandom [10];
							for "_i" from 0 to _burstLength do //wird pro gelöstem Schuss einmal durchgeführt
							{
								scopeName "Schuss";
								_vecTar = getPosASL _Ziel vectorDiff getPosASL _unit;
								_weaponVectorDir = _unit weaponDirection currentWeapon _unit;
								_cos = acos (_vecTar vectorCos _weaponVectorDir);
								_vector = [_unit, _Ziel] call BIS_fnc_dirTo;
								_cansee = [objNull, "VIEW"] checkVisibility [eyePos _unit, eyePos _ziel];
								_unit doTarget _ziel;
								if (_cansee > 0.1 && _cos < _cosMin && _countINSSurface < 1) then
								{
									_currentWeapon = currentWeapon _unit;
									_weaponModes = getArray (configFile/"CfgWeapons"/_currentWeapon/"modes");
									_desiredWeapon = _weaponModes select 0;

									[_unit, _gun] call BIS_fnc_fire;
									sleep _reloadTime;
									_SchussCounter = _SchussCounter +1;
									//_unit sideChat format ["%1",_SchussCounter];
									_count = _unit ammo primaryWeapon _unit;
									//hint str _count;
								};
							};
							sleep 0.3;
						};
					};
					sleep 0.1;
				} forEach _nearEnemies;

				//__________________________________

			}
			else	//no targets found nearby
			{
				_Schnarch = 5;
			};

	}
	else //Nachladescript -> lädt nach
	{
		_unit setunitpos "down";
		_unit setCombatMode "BLUE";
		sleep 1;
		//_unit say3D "russian1";
		//_unit sideChat "MG lädt, Gurt:";
		//_unit sideChat format ["%1",_GurtCounter];
		_unit addItemToBackpack _magazineClass;
		_unit addItemToVest _magazineClass;
		reload _unit;
		sleep 3;
		_unit setVehicleAmmo 1; //ammo in mag gets instantly set to full
	};
sleep _Schnarch;

	_UnitsInMarkerX = allUnits inAreaArray "retreat" select {side _x == WesT};
	_countX = count _UnitsInMarkerX;
	_retreat = 0;

	//=============Group combat strength
	_currentGroupSize = count units group _unit;
	_minGroupSize = _orgGroupSize / 2;
	//hint format ["Group at %1 of %2 members at time %3",_currentGroupSize,_orgGroupSize,round time];
	if (
	    _countX > 0	    OR	    _currentGroupSize < _minGroupSize
	    ) then {
		_retreat = 1;

	} else {
		_retreat = 0;
	};
	//hint str _retreat;
	_retreat == 1;
};

sleep 10;


_wp =group _unit addWaypoint [getMarkerPos "retreatPoint", 0];
_unit setunitpos "up";
_unit enableAI "path";
(group _unit) setVariable ["Vcm_Disable",true]; //This command will disable Vcom AI on a group entirely.
(group _unit)  setBehaviour "careless";
_unit setCombatMode "blue";
