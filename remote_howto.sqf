myfunction = {
	params ["_a","_b"];
	hint (_a + "| " + _b);
};

["hi","ahuuu"] remoteExec ["myfunction", 0]; //0 global, 2 server, -2 getClientState

