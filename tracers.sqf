_handle = [] spawn {
	_addLight = {
		params ["_tracerBullet","_range_trace"];
			_li_tracer = "#lightpoint" createVehicleLocal (getPos _tracerBullet);
			_li_tracer setLightAmbient[0, 1, 1];
			_li_tracer setLightColor[1, 1, 0];
			_li_tracer lightAttachObject [_tracerBullet, [0,0,0]];
			_li_tracer setLightDayLight true;	
			_li_tracer setLightUseFlare true;
			_li_tracer setLightFlareSize 0.5;
			_li_tracer setLightFlareMaxDistance 5000;	
			_li_tracer setLightIntensity 1000;
			_li_tracer setLightAttenuation [2,4,4,0,9,10];
			_h = [_li_tracer] spawn {
				params ["_light"];
				sleep 5;
				deleteVehicle _light;
			}
	};
	hint "fire";
	sleep 2;
	for "_i" from 0 to 5 + random 10 do {
		_dir = [random [-1,0,1],random [-1,0,1],1];
		_dir = vectorNormalized _dir;
		//_dir = _dir vectorMultiply 900;
		for "_i" from 0 to random 30 do { //1 salvo
			//_dir = _dir vectorAdd [random [-5,0,5],random [-5,0,5],0];
		//	_bullet = "ACE_580x42_Ball_Tracer_Red" createVehicle ((position player) vectorAdd [0,0,2]);
			_bullet = "ACE_580x42_Ball_Tracer_Red" createVehicle ((position player) vectorAdd [0,0,10]);
			//_bullet =  createSimpleObject ["ACE_580x42_Ball_Tracer_Red",((position player) vectorAdd [0,0,2])];
			_dir = _dir vectorAdd [0,0.01,0];
			_bullet setVelocity (_dir vectorMultiply 900);
			[_bullet,2] call _addLight;
			sleep 0.01;
		};
		sleep random 1;
	};

	hint "done";
}
