_unit = _this select 0;
_tgt = _this select 1;
sleep (random 10);

    _unit setSkill ["aimingAccuracy", 1];
    _unit setSkill ["aimingShake", 1];
    _unit setSkill ["aimingSpeed", 1];

if (isServer) then
{

	for "_i" from 1 to 60 do
	{

	_rndpos = [[[position _tgt, 50]],[]] call BIS_fnc_randomPos;

	_tmptgt = "Sign_Sphere25cm_F" createVehicleLocal _rndpos;
	_tmptgt hideObjectGlobal true;
	_unit commandSuppressiveFire  _tmptgt;
	_unit doTarget  _tmptgt;
	_unit setVehicleAmmo 0.5;

	sleep 2;
	for "_ii" from 1 to (abs (random 12)) do
		{
		_unit commandSuppressiveFire  _tmptgt;
		_unit doTarget  _tmptgt;
		_unit fireAtTarget  [_tmptgt, currentweapon _unit];
		sleep 0.15;
		_unit commandSuppressiveFire  _tmptgt;
	 	};
	 deletevehicle _tmptgt;
	 sleep 5;



	};
    _unit setSkill ["aimingAccuracy", 0.4];
    _unit setSkill ["aimingShake", 0.4];
    _unit setSkill ["aimingSpeed", 0.4];
};
