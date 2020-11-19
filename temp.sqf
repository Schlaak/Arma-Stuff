 _loadCode = { 
  params["_box"]; 
  _list = (_box nearEntities 10) select {_r = _x canVehicleCargo _box; (_r select 1)}; 
  _list = _list apply {[_x distance _box, _x]}; 
  _list sort true;   _car = _list select 0 select 1; 
  player globalChat str _list; 
  player globalChat str _car; 
  _car setVehicleCargo _box ; 
 }; 
 [_this] call _loadCode;

 	_loadAvailable = {
		params["_box"];
		_list = (_box nearEntities 10) select {_r = _x canVehicleCargo _box; (_r select 1)};
		(count _list > 0) 
	};
	hint str ([_this] call _loadAvailable);


	["ace_common_displayTextStructured", ["someone is thinking of giving you items", 1.5, _target], [_target]] call CBA_fnc_targetEvent;



