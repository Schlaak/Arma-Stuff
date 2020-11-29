//Info: this code only works in singleplayer as it uses local variables as "player".
playSound3D ["A3\dubbing_f\modules\supports\artillery_request.ogg", player];
sleep 5;
//Detecting if player has laser
_laser = laserTarget vehicle player;

If (isNull _laser) exitWith {systemChat "use laser designator"};
playSound3D ["A3\dubbing_f\modules\supports\artillery_acknowledged.ogg", player];

sleep 5;
playSound3D ["A3\dubbing_f\modules\supports\artillery_accomplished.ogg", player];
systemChat "CRUISE MISSILE INBOUND...KEEP LASER ON TARGET!!!";
west reportRemoteTarget [_laser, 3600];  
_laser confirmSensorTarget [west, true];  
if (isNil "VLS" || {isNull VLS}) exitWith {systemChat "no vertical launch system found."};

0 = VLS fireAtTarget [_laser, "weapon_vls_01"]; 