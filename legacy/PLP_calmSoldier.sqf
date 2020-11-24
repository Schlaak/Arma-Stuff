/*
	Author: POLPOX

	Description:
	Adds calm animation for some units which they cancel when under fire.
	You can force abort animation with variable "PLP_calmSoldier_abort"

_nil = [Unit,option name,[Equipments name, weapon, nvg], react] execvm "scripts\PLP_CalmSoldier.sqf";
_nil = [this,"STAND",["Vest", true, false], false] execvm "scripts\PLP_CalmSoldier.sqf";
_nil = [this,"BRIEFING",["Vest", true, false], true] execvm "scripts\PLP_CalmSoldier.sqf";


_nil = [this,"STAND",["NO_TOUCH", true, false], false] execvm "scripts\PLP_CalmSoldier.sqf";
_nil = [this,"TALK",["NO_TOUCH", true, false], false] execvm "scripts\PLP_CalmSoldier.sqf";


_nil = [this,"REPAIR_KNEEL_2",["NO_TOUCH", false, false], true] execvm "scripts\PLP_CalmSoldier.sqf"
	Parameter(s):
		0: OBJECT - unit
		1: STRING - mode
		>"STAND" - Standing
		>"STAND_RIFLE" - Standing, with rifle
		>"STAND_TABLE" - Standing, hands on table
		>"HANDS_BACK" - Standing, hands on back
		>"LEAN" - Standing, lean on wall with rifle
		>"PATROL" - Standing, patrolling with rifle
		>"BRIEFING" - Standing, hands on knee
		>"TALK" - Standing, hands move
		>"EASE" - Standing, ease
		>"EXERCISE_PUSH" - Exercising, push up
		>"EXERCISE_KNEE" - Exercising, knee bend
		>"REPAIR_KNEEL_1" - Kneeling repair#1
		>"REPAIR_KNEEL_2" - Kneeling repair#2
		>"REPAIR_PRONE_1" - Repairing on one's back#1
		>"REPAIR_PRONE_2" - Repairing on one's back#2
		>"REPAIR_STAND" - Standing assembly
		>"SIT" - On chair
		>"SIT_RIFLE" - On ground, with rifle
		>"SIT_LOW" - On ground
		>"SIT_LOW_SAD" - On ground, sad
		>"SIT_HIGH" - On high ground
		>"SIT_TABLE" - On chair, hands on table
		>"TREAT_WOUND" - Treating wounds
		>"WOUND_1" - Wounding#1, they don't react for enemy
		>"WOUND_2" - Wounding#2, they don't react for enemy
		>"SHOOTING_STAND" - Shooting, stand
		>"SHOOTING_KNEEL" - Shooting, kneel
		>"SHOOTING_PRONE" - Shooting, prone
		>"SHOOTING_STANDK" - Shooting, stand first, they will change to kneel
		>"SHOOTING_KNEELS" - Shooting, kneel first, they will change to stand
		>"DEAD" - Dead state
		2: ARRAY - (optional)
			0: STRING - (optional) equipments
			>"NONE" - None equipments
			>"VEST" - Vest only
			>"HAT" - Hat only
			>"FULL" - Vest, Hat
			>"NO_TOUCH" - No change
			>"DEFAULT" - They vary with change equipments (default)
			1: STRING or BOOLEAN - weapons
			>"NONE" - No weapons
			>"RIFLE" - No change
			>"DEFAULT" - They vary with change weapons (default)
			>true - Has weapon
			>false - No weapon
			2: BOOLEAN - (optional) has nv goggles (default:true)
		3: BOOLEAN - The unit cannot react? (optional, default:false)

	Returns:
	None
*/

/*	INIT	*/

_unit = [_this,0,objNull,[objNull]] call BIS_fnc_param ;
_move = [_this,1,"STAND",[""]] call BIS_fnc_param ;

_array = [_this,2,[],[[]]] call BIS_fnc_param ;
_equip = [_array,0,"DEFAULT",[""]] call BIS_fnc_param ;
_weapon = [_array,1,"DEFAULT",["",true]] call BIS_fnc_param ;
_nvgoggle = [_array,2,false,[true]] call BIS_fnc_param ;
_noReact = [_this,3,false,[true]] call BIS_fnc_param ;

_EHs = [] ;

if (!_nvGoggle) then {
	{_unit unAssignItem _x ; _unit removeItem _x} forEach ["NVGoggles","NVGoggles_OPFOR","NVGoggles_INDEP"] ;
} ;

switch _weapon do {
	case "NONE" : {removeAllWeapons _unit} ;
	case "RIFLE" : {} ;
	case "DEFAULT" : {} ;
	case true : {_weapon = "RIFLE"} ;
	case false : {removeAllWeapons _unit ; _weapon = "NONE"} ;
} ;

_equip_none = {
	removeGoggles _this ;
	removeVest _this ;
	removeHeadgear _this ;
	removeBackpack _this ;
} ;
_equip_vest = {
	removeGoggles _this ;
	removeHeadgear _this ;
	removeBackpack _this ;
} ;
_equip_hat = {
	removeGoggles _this ;
	removeVest _this ;
	removeBackpack _this ;
} ;
_equip_full = {
	removeGoggles _this ;
} ;

switch _equip do {
	case "NONE" : {
		_unit call _equip_none ;
	} ;
	case "VEST" : {
		_unit call _equip_vest ;
	} ;
	case "HAT" : {
		_unit call _equip_hat ;
	} ;
	case "FULL" : {
		_unit call _equip_full ;
	} ;
	case "DEFAULT" : {
	} ;
	case "NO_TOUCH" : {
	} ;
} ;

{_unit disableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"] ;

/*	MOVES	*/

switch _move do {

	/*	STANDS	*/
	case "STAND" : {
		switch (round random 2) do {
			case 0 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubStandingUA_move1",
					"HubStandingUA_move2",
					"HubStandingUA_idle1",
					"HubStandingUA_idle2",
					"HubStandingUA_idle3"
				]] ;
			} ;
			case 1 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubStandingUB_move1",
					"HubStandingUB_idle1",
					"HubStandingUB_idle2",
					"HubStandingUB_idle3"
				]] ;
			} ;
			case 2 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubStandingUC_move1",
					"HubStandingUC_move2",
					"HubStandingUC_idle1",
					"HubStandingUC_idle2",
					"HubStandingUC_idle3"
				]] ;
			} ;
		} ;
		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;
	case "STAND_RIFLE" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"HubStanding_idle1",
			"HubStanding_idle2",
			"HubStanding_idle3"
		]] ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSlowWrflDnon"] ;
	} ;
	case "PATROL" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_patrolling1",
			"InBaseMoves_patrolling2"
		]] ;
		if (_equip == "DEFAULT") then {_unit call _equip_full} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSlowWrflDnon"] ;
	} ;
	case "BRIEFING" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"HubBriefing_lookAround1",
			"HubBriefing_lookAround2",
			"HubBriefing_scratch",
			"HubBriefing_stretch",
			"HubBriefing_loop"
		]] ;
		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;
	case "TALK" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"acts_StandingSpeakingUnarmed"
		]] ;
		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;
	case "HANDS_BACK" : {
		switch (round random 1) do {
			case 0 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"InBaseMoves_HandsBehindBack1",
					"InBaseMoves_HandsBehindBack2"
				]] ;
			} ;
			case 1 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"UnaErcPoslechVelitele1",
					"UnaErcPoslechVelitele2",
					"UnaErcPoslechVelitele3",
					"UnaErcPoslechVelitele4"
				]] ;
			} ;
		} ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;

	/*	STANDS SPECIAL	*/
	case "LEAN" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_Lean1"
		]] ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSlowWrflDnon"] ;
		_unit setVariable ["PLP_calmSoldier_dir",-45] ;
	} ;
	case "STAND_TABLE" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_table1"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;
	case "EASE" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"AmovPercMstpSnonWnonDnon_Ease"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		//_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon_EaseOut"] ;
	} ;

	/*	EXERCISE	*/
	case "EXERCISE_KNEE" ;
	case "EXERCISE_PUSH" : {
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;
		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_move == "EXERCISE_KNEE") then {
			_unit setVariable ["PLP_calmSoldier_Animations",[
				"AmovPercMstpSnonWnonDnon_exercisekneeBendA"
			]] ;
		} ;
		if (_move == "EXERCISE_PUSH") then {
			_unit setVariable ["PLP_calmSoldier_Animations",[
				"AmovPercMstpSnonWnonDnon_exercisePushup"
			]] ;
		} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;

	/*	SITS	*/
	case "SIT" : {
		switch (round random 5) do {
			case 0 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingChairA_move1",
					"HubSittingChairA_idle1",
					"HubSittingChairA_idle2",
					"HubSittingChairA_idle3"
				]] ;
			} ;
			case 1 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingChairB_move1",
					"HubSittingChairB_idle1",
					"HubSittingChairB_idle2",
					"HubSittingChairB_idle3"
				]] ;
			} ;
			case 2 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingChairC_move1",
					"HubSittingChairC_idle1",
					"HubSittingChairC_idle2",
					"HubSittingChairC_idle3"
				]] ;
			} ;
			case 3 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingChairUA_move1",
					"HubSittingChairUA_idle1",
					"HubSittingChairUA_idle2",
					"HubSittingChairUA_idle3"
				]] ;
			} ;
			case 4 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingChairUB_move1",
					"HubSittingChairUB_idle1",
					"HubSittingChairUB_idle2",
					"HubSittingChairUB_idle3"
				]] ;
			} ;
			case 5 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingChairUC_move1",
					"HubSittingChairUC_idle1",
					"HubSittingChairUC_idle2",
					"HubSittingChairUC_idle3"
				]] ;
			} ;
		} ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AcrgPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_getOutLow"] ;
	} ;
	case "SIT_LOW" : {
		switch (round random 5) do {
			case 0 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"passenger_flatground_crosslegs"
				]] ;
			} ;
			case 1 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"passenger_flatground_generic01"
				]] ;
			} ;
			case 2 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"passenger_flatground_generic02"
				]] ;
			} ;
			case 3 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"passenger_flatground_generic03"
				]] ;
			} ;
			case 4 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"passenger_flatground_generic04"
				]] ;
			} ;
			case 5 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"passenger_flatground_generic05"
				]] ;
			} ;
		} ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AcrgPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_getOutLow"] ;
	} ;
	case "SIT_LOW_SAD" : {
		switch (round random 1) do {
			case 0 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"c5efe_HonzaLoop"
				]] ;
			} ;
			case 1 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"c5efe_MichalLoop"
				]] ;
			} ;
		} ;
		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AcrgPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_getOutLow"] ;
		_unit setVariable ["PLP_calmSoldier_dir",180] ;
	} ;
	case "SIT_HIGH" : {
		switch (round random 1) do {
			case 0 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingHighB_idle1",
					"HubSittingHighB_idle2",
					"HubSittingHighB_idle3"
				]] ;
			} ;
			case 1 : {
				_unit setVariable ["PLP_calmSoldier_Animations",[
					"HubSittingHighA_idle1"
				]] ;
				_unit setVariable ["PLP_calmSoldier_dir",135] ;
			} ;
		} ;

		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AcrgPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_getOutLow"] ;
	} ;
	case "SIT_TABLE" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"HubSittingAtTableU_idle1",
			"HubSittingAtTableU_idle2",
			"HubSittingAtTableU_idle3"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AcrgPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_getOutLow"] ;
	} ;
	case "SIT_RIFLE" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_SittingRifle1",
			"InBaseMoves_SittingRifle2"
		]] ;

		if (_equip == "DEFAULT") then {_unit call _equip_none} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AcrgPknlMstpSnonWnonDnon_AmovPercMstpSnonWnonDnon_getOutLow"] ;
	} ;
	/*	SPECIAL	*/
	/*	REPAIR	*/
	case "REPAIR_KNEEL_1" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"Acts_carFixingWheel"
		]] ;

		_unit say3D "Acts_carFixingWheel" ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;

		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPknlMstpSnonWnonDnon"] ;

		_animDoneSoundEH = _unit addEventHandler ["AnimDone",{if ((_this select 1) == "Acts_carFixingWheel") then {(_this select 0) say3D "Acts_carFixingWheel"}}] ;
		_EHs = _EHs + [["AnimDone",_animDoneSoundEH]] ;
	} ;
	case "REPAIR_KNEEL_2" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_repairVehicleKnl"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
	} ;
	case "REPAIR_PRONE_1" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_repairVehiclePne"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
	} ;
	case "REPAIR_PRONE_2" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"HubFixingVehicleProne_idle1"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
		_unit setVariable ["PLP_calmSoldier_dir",180] ;
	} ;
	case "REPAIR_STAND" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"InBaseMoves_assemblingVehicleErc"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSnonWnonDnon"] ;
	} ;
	/*	WOUNDS	*/
	case "WOUND_1" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"Acts_LyingWounded_loop1",
			"Acts_LyingWounded_loop2",
			"Acts_LyingWounded_loop3"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;

		_unit switchMove ((_unit getVariable "PLP_calmSoldier_Animations") call BIS_fnc_selectRandom) ;
		_animDoneEH = _unit addEventHandler ["AnimDone",{
			(_this select 0) switchMove (((_this select 0) getVariable "PLP_calmSoldier_Animations") call BIS_fnc_selectRandom) ;
		}] ;
		_EHs = _EHs + [["AnimDone",_animDoneEH]] ;
		_unit setVariable ["PLP_calmSoldier_dir",180] ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AinjPpneMstpSnonWrflDnon"] ;
	} ;
	case "WOUND_2" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"acts_InjuredAngryRifle01",
			"acts_InjuredCoughRifle02",
			"acts_InjuredSpeakingRifle01",
			"acts_InjuredLyingRifle01",
			"acts_InjuredLookingRifle01",
			"acts_InjuredLookingRifle02",
			"acts_InjuredLookingRifle03",
			"acts_InjuredLookingRifle04",
			"acts_InjuredLookingRifle05"
		]] ;

		if (_weapon == "DEFAULT") then {removeAllWeapons _unit} ;
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;

		_unit switchMove ((_unit getVariable "PLP_calmSoldier_Animations") call BIS_fnc_selectRandom) ;
		_animDoneEH = _unit addEventHandler ["AnimDone",{
			(_this select 0) switchMove (((_this select 0) getVariable "PLP_calmSoldier_Animations") call BIS_fnc_selectRandom) ;
		}] ;
		_EHs = _EHs + [["AnimDone",_animDoneEH]] ;
		_unit setVariable ["PLP_calmSoldier_dir",180] ;
		_unit setVariable ["PLP_calmSoldier_AbortAnimation","AinjPpneMstpSnonWrflDnon"] ;
		_animChangedEH = _unit addEventHandler ["AnimChanged",{
			 playSound3D ["A3\Sounds_F\characters\cutscenes\" + (_this select 1) + ".wss",_this select 0];
		}] ;
		_EHs = _EHs + [["AnimChanged",_animChangedEH]] ;
	} ;
	case "TREAT_WOUND" : {
		_unit setVariable ["PLP_calmSoldier_Animations",[
			"Acts_TreatingWounded01",
			"Acts_TreatingWounded02",
			"Acts_TreatingWounded03",
			"Acts_TreatingWounded04",
			"Acts_TreatingWounded05",
			"Acts_TreatingWounded06"
		]] ;

		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
	} ;

	/*	DEAD	*/
	case "DEAD" : {
		if (true) exitWith {
			if (_equip == "DEFAULT") then {_unit call _equip_full} ;

			_unit switchMove ([
				"KIA_gunner_standup01",
				"KIA_gunner_static_low01",
				"KIA_passenger_boat_holdleft",
				"KIA_passenger_injured_medevac_truck01",
				"KIA_passenger_injured_medevac_truck02",
				"KIA_passenger_injured_medevac_truck03"
			] call BIS_fnc_selectRandom) ;

			_unit setDamage 1 ;
		} ;
	} ;

	/*	SHOOTING	*/
	case "SHOOTING_STAND" ;
	case "SHOOTING_KNEEL" ;
	case "SHOOTING_PRONE" ;
	case "SHOOTING_STANDK" ;
	case "SHOOTING_KNEELS" : {
		if (_equip == "DEFAULT") then {_unit call _equip_vest} ;
		_baseAnim = "" ;
		_calmAnim = [] ;
		_animChangedFireEH = 0 ;
		if (_move in ["SHOOTING_STAND","SHOOTING_KNEEL","SHOOTING_PRONE"]) then {
			if (_move == "SHOOTING_STAND") then {
				_baseAnim = "HubShootingRangeStand_shoot" ;
				_calmAnim = ["HubShootingRangeStand_move1","HubShootingRangeStand_move2","HubShootingRangeStand_move3","HubShootingRangeStand_move4"] ;
				_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSrasWrflDnon"] ;
				_animChangedFireEH = _unit addEventHandler ["AnimDone",{
					(_this select 0) switchMove "HubShootingRangeStand_shoot" ;
				}] ;
			} ;
			if (_move == "SHOOTING_KNEEL") then {
				_baseAnim = "HubShootingRangeKneel_shoot" ;
				_calmAnim = ["HubShootingRangeKneel_move1","HubShootingRangeKneel_move2","HubShootingRangeKneel_move3"] ;
				_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPknlMstpSrasWrflDnon"] ;
				_animChangedFireEH = _unit addEventHandler ["AnimDone",{
					(_this select 0) switchMove "HubShootingRangeKneel_shoot" ;
				}] ;
			} ;
			if (_move == "SHOOTING_PRONE") then {
				_baseAnim = "HubShootingRangeProne_shoot" ;
				_calmAnim = ["HubShootingRangeProne_move1","HubShootingRangeProne_move2","HubShootingRangeProne_move3"] ;
				_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPpneMstpSrasWrflDnon"] ;
				_animChangedFireEH = _unit addEventHandler ["AnimDone",{
					(_this select 0) switchMove "HubShootingRangeProne_shoot" ;
				}] ;
			} ;
			_EHs = _EHs + [["AnimDone",_animChangedFireEH]] ;
			_unit switchMove _baseAnim ;
			[_unit,_noReact] spawn {
				_unit = _this select 0 ;
				_noReact = _this select 1 ;
				waitUntil {(((_unit getVariable ["PLP_calmSoldier_abort",false]) or (behaviour _unit == "COMBAT")) and !_noReact) or !alive _unit} ;
				_unit setVariable ["PLP_calmSoldier_abort",true] ;
			} ;
			while {!(_unit getVariable ["PLP_calmSoldier_abort",false])} do {
				waitUntil {animationState _unit == _baseAnim} ;
				if ((_unit getVariable ["PLP_calmSoldier_abort",false])) exitWith {} ;
				for "_i" from 0 to (8 + random 10) do {
					waitUntil {_unit ammo currentWeapon _unit != 0} ;
					if ((_unit getVariable ["PLP_calmSoldier_abort",false])) exitWith {} ;
					sleep (0.1 + random 3) ;
					_unit forceWeaponFire [currentWeapon _unit,"Single"] ;
				} ;
				if ((_unit getVariable ["PLP_calmSoldier_abort",false])) exitWith {} ;
				_unit switchMove (_calmAnim call BIS_fnc_selectRandom) ;
			} ;
		} ;
		if (_move in ["SHOOTING_STANDK","SHOOTING_KNEELS"]) then {
			if (_move == "SHOOTING_STANDK") then {
				_baseAnim = "HubShootingRangeStand_shoot" ;
				_calmAnim = ["HubShootingRangeStand_move1","HubShootingRangeStand_move2","HubShootingRangeStand_move3","HubShootingRangeStand_move4"] ;
				_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSrasWrflDnon"] ;
			} ;
			if (_move == "SHOOTING_KNEELS") then {
				_baseAnim = "HubShootingRangeKneel_shoot" ;
				_calmAnim = ["HubShootingRangeKneel_move1","HubShootingRangeKneel_move2","HubShootingRangeKneel_move3"] ;
				_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPknlMstpSrasWrflDnon"] ;
			} ;
			_animChangedFireEH = _unit addEventHandler ["AnimDone",{
				(_this select 0) switchMove ((_this select 0) getVariable "PLP_calmSoldier_Firing_Base") ;
			}] ;
			_unit setVariable ["PLP_calmSoldier_Firing_Base",_baseAnim] ;
			_EHs = _EHs + [["AnimDone",_animChangedFireEH]] ;
			_unit switchMove _baseAnim ;
			[_unit,_noReact] spawn {
				_unit = _this select 0 ;
				_noReact = _this select 1 ;
				waitUntil {(((_unit getVariable ["PLP_calmSoldier_abort",false]) or (behaviour _unit == "COMBAT")) and !_noReact) or !alive _unit} ;
				_unit setVariable ["PLP_calmSoldier_abort",true] ;
			} ;
			while {!(_unit getVariable ["PLP_calmSoldier_abort",false])} do {
				for "_i" from 0 to (1 + random 5) do {
					waitUntil {toUpper (animationState _unit) == toUpper (_unit getVariable "PLP_calmSoldier_Firing_Base")} ;
					if ((_unit getVariable ["PLP_calmSoldier_abort",false])) exitWith {} ;
					for "_e" from 0 to (8 + random 10) do {
						waitUntil {_unit ammo currentWeapon _unit != 0} ;
						if ((_unit getVariable ["PLP_calmSoldier_abort",false])) exitWith {} ;
						sleep (0.1 + random 3) ;
						_unit forceWeaponFire [currentWeapon _unit,"Single"] ;
					} ;
					if ((_unit getVariable ["PLP_calmSoldier_abort",false])) exitWith {} ;
					_unit switchMove (_calmAnim call BIS_fnc_selectRandom) ;
				} ;
				if (_baseAnim == "HubShootingRangeStand_shoot") then {
					_baseAnim = "HubShootingRangeKneel_shoot" ;
					_calmAnim = ["HubShootingRangeKneel_move1","HubShootingRangeKneel_move2","HubShootingRangeKneel_move3"] ;
					_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPknlMstpSrasWrflDnon"] ;
					_unit switchMove "HubShootingRangeStand_HubShootingRangeKneel" ;
				} else {
					_baseAnim = "HubShootingRangeStand_shoot" ;
					_calmAnim = ["HubShootingRangeStand_move1","HubShootingRangeStand_move2","HubShootingRangeStand_move3","HubShootingRangeStand_move4"] ;
					_unit setVariable ["PLP_calmSoldier_AbortAnimation","AmovPercMstpSrasWrflDnon"] ;
					_unit switchMove "HubShootingRangeKneel_HubShootingRangeStand" ;
				} ;
				_unit setVariable ["PLP_calmSoldier_Firing_Base",_baseAnim] ;
			} ;
		} ;
	} ;

	default {if (true) exitWith {hint format ["%1 is not usable value!",_move]}} ;

} ;

/*	EXECUTE	*/

_unit switchMove ((_unit getVariable "PLP_calmSoldier_Animations") call BIS_fnc_selectRandom) ;
_animChangedEH = _unit addEventHandler ["AnimDone",{
	(_this select 0) switchMove (((_this select 0) getVariable "PLP_calmSoldier_Animations") call BIS_fnc_selectRandom) ;
}] ;
_EHs = _EHs + [["AnimDone",_animChangedEH]] ;

_unit setDir (getDir _unit + (_unit getVariable ["PLP_calmSoldier_Dir",0])) ;

if (_move in ["WOUND_1","WOUND_2"]) exitWith {
	_unit spawn {
		while {alive _this} do {
			sleep (1+random 3) ;
			_this say3D ([
				"WoundedGuyA_01",
				"WoundedGuyA_02",
				"WoundedGuyA_03",
				"WoundedGuyA_04",
				"WoundedGuyA_05",
				"WoundedGuyA_06",
				"WoundedGuyA_07",
				"WoundedGuyA_08",
				"WoundedGuyB_01",
				"WoundedGuyB_02",
				"WoundedGuyB_03",
				"WoundedGuyB_04",
				"WoundedGuyB_05",
				"WoundedGuyB_06",
				"WoundedGuyB_07",
				"WoundedGuyB_08",
				"WoundedGuyC_01",
				"WoundedGuyC_02",
				"WoundedGuyC_03",
				"WoundedGuyC_04",
				"WoundedGuyC_05"
			] call BIS_fnc_selectRandom) ;
		} ;
	} ;
	waitUntil {!alive _unit} ;
	{_unit removeEventHandler _x} forEach _EHs ;
	_unit switchMove "Acts_LyingWounded_loop" ;
} ;

/*	ABORT	*/
waitUntil {(((_unit getVariable ["PLP_calmSoldier_abort",false]) or (behaviour _unit == "COMBAT")) and !_noReact) or !alive _unit} ;
_unit setVariable ["PLP_calmSoldier_abort",true] ;
if (alive _unit) then {
	sleep random 0.25 ;
} ;

{_unit enableAI _x} forEach ["ANIM", "AUTOTARGET", "FSM", "MOVE", "TARGET"] ;
{_unit removeEventHandler _x} forEach _EHs ;
_unit setDir (getDir _unit - (_unit getVariable ["PLP_calmSoldier_Dir",0])) ;

switch _move do {
	case "REPAIR_KNEEL_2" ;
	case "REPAIR_PRONE_1" ;
	case "REPAIR_PRONE_2" : {
		_head = (_unit selectionPosition "Head" select 2) ;
		if (_head < 0.3) then {			//Prone
			_unit switchMove "AinjPpneMstpSnonWrflDnon" ;
				if (alive _unit) then {
				_unit playMoveNow "AmovPpneMstpSnonWnonDnon" ;
			} ;
		} ;
		if (_head > 0.3 and _head < 0.8) then {	//Kneel
			_unit switchMove "AmovPknlMstpSnonWnonDnon" ;
		} ;
		if (_head > 0.8) then {			//Stand
			_unit switchMove "AmovPercMstpSnonWnonDnon" ;
		} ;
	} ;
	case "TREAT_WOUND" : {
		if (alive _unit and primaryWeapon _unit != "") then {
			_unit switchMove "Acts_TreatingWounded_Out" ;
		} else {
			_unit switchMove "Acts_TreatingWounded_Loop" ;
		} ;
	} ;
	case "EASE" : {
		if (alive _unit) then {
			_unit switchMove "AmovPercMstpSnonWnonDnon_EaseOut"
		} ;
	} ;
	case "STAND" ;
	case "BRIEFING" ;
	case "TALK" ;
	case "LEAN" ;
	case "SIT" ;
	case "SIT_TABLE" ;
	case "SIT_HIGH" ;
	case "SIT_TABLE" ;
	case "SHOOTING_STAND" ;
	case "SHOOTING_KNEEL" ;
	case "SHOOTING_PRONE" ;
	case "SHOOTING_STANDK" ;
	case "SHOOTING_KNEELS" ; {
		_unit switchMove (_unit getVariable "PLP_calmSoldier_AbortAnimation") ;
	} ;
	case "STAND_RIFLE" ;
	case "SIT_LOW" : {
		if (alive _unit) then {
			_unit switchMove (_unit getVariable "PLP_calmSoldier_AbortAnimation") ;
		} ;
	} ;
	default {
	} ;
} ;