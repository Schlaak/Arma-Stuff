// by ALIAS

nul = [unit_name,trigger_distance,sound,chase_players] execvm "Scripts\kam.sqf";

unit				- string, is the name of the kamikaze unit
trigger_distance	- number, distance from targeted player at which the kamikaze will blow himself up
sound				- boolean, if is true a random sound from a given array is played, if is false kamikaze will not shout
chase_players		- boolean, if true the kamikaze unit will chase players, otherwise will be pasive and blow himself up when a random player is in its proximity

// >>>> Example 1
nul = [this,50,true,true] execvm "Scripts\kam.sqf";

- kamikaze will blow up at 50 meters from target
- kamikaze will yell
- Kamikaze will chase players


// >>>> Example 2
nul = [this,50,false,false] execvm "Scripts\kam.sqf";

- kamikaze will blow up at 50 meters from target
- kamikaze will NOT yell
- Kamikaze will NOT chase players



// SPAWNING A CUSTOM NUMBER OF KAMIKAZE AT A GIVEN MARKER POSITION
null = [MARKER_name,kamikaze_number,sound,chase_players,trigger_distance]  execvm "Scripts\kam_group.sqf";

>> Example
null = ["spawn_me",10,true,true,10] execvm "Scripts\kam_group.sqf";