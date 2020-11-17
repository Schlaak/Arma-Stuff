/**
Made by Schlaak
edited by ir0nsight
*/
if (hasInterface) then
{
	_surfacearray = ["#SurfRoadDirt","#SurfRoadConcrete","#SurfRoadTarmac","#concrete","#dirtrunway","#road","#road_exp","#concrete_exp","#GdtConcrete","#GdtSoil","#GdtConcrete","#GdtConcrete","#GdtDirt","concrete_out","concrete_inside","#concrete_in_exp","#concrete_hall_exp","#GdtGrassShort","#GdtAsphalt","#UTCONCRETE "];
	while {true} do
	{
		sleep 2;
		if ( (vehicle player) isKindOf "car" ) then
		{


		waituntil {!(isOnRoad (vehicle player)) && !((surfaceType getpos player) in _surfacearray) && (vehicle player != player) &&((speed (vehicle player) >= 3) OR (speed (vehicle player) < -3)) && (vehicle player) isKindOf "car" };
		enableCamShake true;
		_camshakepower = 0.15 * speed (vehicle player);
		_camshakefreq = speed (vehicle player) / 7.5;
		addCamShake [_camshakepower, 8, _camshakefreq];
		};
	};
};



