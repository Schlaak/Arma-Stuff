_handle = [] spawn {
	player globalChat "starting";
	//list of gun sounds
	_listShots = [
		"A3\Sounds_F\weapons\HMG\HMG_gun.wss",
		"A3\Sounds_F\weapons\M4\m4_st_1.wss"
	];
	_listRare = [
		"A3\Sounds_F\weapons\Explosion\explosion_antitank_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_shell_1.wss",
		"A3\Sounds_F\weapons\Explosion\expl_big_1.wss"
	];
	_start = time - 1;
	_duration = 60;
	player globalChat "time =  " + str _start;
	_i = 0;
	while {_i < 10} do {
		_i = _i + 1;
		player globalChat str _i;
		//fire salvo
		_sound = selectRandom _listShots;
		_salvo = _sound spawn {
			for "_i" from 0 to random 10 do {
				playSound3D [_this, target]; // play sound
				sleep random [0.02,0.2,0.5];
			};
		};

		sleep random [1,5,10];
		if (random 100 < 10) then {
			playSound3D [selectRandom _listRare, target]; // boom	
		}
	}
}
