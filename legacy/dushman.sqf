//[_dude, false] execvm "scripts\US.sqf";
//heavy loadout
//[_dude, true] execvm "scripts\US.sqf";
//[_dude, true] execvm "scripts\US.sqf";
//[_dude] execvm "scripts\dushman.sqf";
if (!isserver) exitWith {};

private ["_items","_dude","_uniform"];

_dude = _this select 0;
_uniform = selectRandom ["U_Afghan01","U_Afghan01NH","U_Afghan02","U_Afghan02NH","U_Afghan03","U_Afghan03NH","U_Afghan04","U_Afghan05","U_Afghan06","U_Afghan06NH","U_Afghan01","U_Afghan01NH","U_Afghan02","U_Afghan02NH","U_Afghan03","U_Afghan03NH","U_Afghan04","U_Afghan05","U_Afghan06","U_Afghan06NH","U_Afghan01","U_Afghan01NH","U_Afghan02","U_Afghan02NH","U_Afghan03","U_Afghan03NH","U_Afghan04","U_Afghan05","U_Afghan06","U_Afghan06NH","rds_uniform_Worker3","rds_uniform_Worker4","rds_uniform_Worker2","rds_uniform_Worker1"];
_vest = selectRandom ["V_BandollierB_cbr","V_BandollierB_rgr","V_BandollierB_khk","V_BandollierB_oli","V_BandollierB_blk","V_TacChestrig_grn_F","V_TacChestrig_cbr_F","V_TacChestrig_oli_F","rhs_6sh46","rhs_6sh92","rhs_vest_commander","rhs_vest_pistol_holster","rhs_vydra_3m","rhsgref_6b23_khaki_rifleman","rhsgref_chestrig","rhsgref_alice_webbing","rhsgref_chicom","rhsgref_chicom_m88"];
_bckpck = selectRandom ["","","","","","","","","","","","","","","","","","B_Messenger_Gray_F","B_Messenger_Coyote_F","B_Messenger_Olive_F","B_Messenger_Black_F","su_backpack_rd54_bedroll_shovel","su_backpack_rd54_shovel","su_backpack_rd54_bedroll","su_backpack_rd54","rhssaf_alice_smb","rhsgref_hidf_alicepack","RD54_6B3_PK","rhs_sidor","rhs_medic_bag","B_Carryall_oli"];
_rpgpack = selectrandom ["rhs_rpg_empty"];
_rpg = selectrandom ["rhs_weap_panzerfaust60","rhs_weap_m80","rhs_weap_rpg26","rhs_weap_rpg7","rhs_weap_rpg75","rhs_weap_rshg2","rhs_weap_panzerfaust60","rhs_weap_rpg75","rhs_weap_rpg75","rhs_weap_rpg7","rhs_weap_rpg7","rhs_weap_rpg7","rhs_weap_rpg7"];
_goggles = selectrandom ["fsob_Beard01_Dark","rhs_scarf","fsob_Beard01_Dark","fsob_Beard01_Brown","G_Bandanna_tan","G_Bandanna_khk","G_Bandanna_oli","G_Bandanna_blk","G_Squares_Tinted","G_Squares"];
_helmet = selectrandom ["","","","","","","","H_ShemagOpen_khk","H_ShemagOpen_tan","H_Shemag_olive"];
_weapon = selectrandom ["rhs_weap_aks74u","rhs_weap_aks74un","rhs_weap_pm63","rhs_weap_m14","40th_weap_svd_wood","rhs_weap_Izh18","rhs_weap_m38","rhs_weap_m70b1","rhs_weap_m70ab2","rhs_weap_m1garand_sa43","rhs_weap_l1a1_wood","rhs_weap_kar98k","rhs_weap_savz58p","rhs_weap_m70b3n","rhs_weap_akms","rhs_weap_akms","rhs_weap_akms","rhs_weap_akm","rhs_weap_akm","rhs_weap_akm","rhs_weap_akm","rhs_weap_ak74","rhs_weap_ak74","rhs_weap_ak74","rhs_weap_m3a1"];
_mg = selectrandom ["rhs_weap_pkm","rhs_weap_m84"];
_mgbackpack = selectrandom ["RD54_6B3_PK","su_backpack_rd54","rhs_sidor"];

sleep (1 + (random 3));


//if (!isPlayer _dude ) then {
_items = uniformItems _dude;
sleep 0.5;
removeUniform _dude;

//_dude addWeapon "arifle_SUD_AK74";
//_dude addPrimaryWeaponItem "SUD_30Rnd_545x39_AK";
if (!(_dude getVariable ["isSetup", false])) then {
_dude setVariable ["isSetup", true];



removeAllWeapons _dude;
removeAllItems _dude;
removeAllAssignedItems _dude;
removeUniform _dude;
removeVest _dude;
removeBackpack _dude;
removeHeadgear _dude;
removeGoggles _dude;



_dude forceAddUniform _uniform;
{_dude addItemToUniform _x} foreach _items;
_dude addGoggles _goggles;
_dude addHeadgear _helmet;
_dude addvest _vest;
_case = selectrandom [0,0,0,0,0,0,1,1,1,2,2,0,0];

	switch (_case) do
	{
	case 0:
	{
		_dude addweapon _weapon;
		_dude addBackpack _bckpck;
		_magazines = getArray (configFile >> "CfgWeapons" >> primaryWeapon _dude >> "magazines");
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
	};
	case 1:
	{
		_dude addweapon _mg;
		_dude addBackpack _mgbackpack;
		_magazines = getArray (configFile >> "CfgWeapons" >> primaryWeapon _dude >> "magazines");
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);

	};
	case 2:
	{
		_dude addweapon _weapon;
		_dude addBackpack _rpgpack;
		_dude addweapon _rpg;
		_magazines = getArray (configFile >> "CfgWeapons" >> primaryWeapon _dude >> "magazines");
		_magazines2 = getArray (configFile >> "CfgWeapons" >> secondaryWeapon _dude >> "magazines");
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines2 select 0);
		_dude addmagazine (_magazines2 select 0);
		_dude addmagazine (_magazines2 select 0);
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
		_dude addmagazine (_magazines select 0);
	};
	};
};
//};
