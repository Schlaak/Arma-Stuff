# Hide Terrain objects fix
## Problem:
Due to execution order of ARMA, modules like "hide terrain objects" are executed after editor-placed objects are spawned. 
This means a tank that is placed over a hidden house will spawn before the house is deleted, collide and be destroyed (or other funky stuff).

## Possible Solutions:
- Change execution order
  - Good luck trying to talk an arma dev into doing that
- Create a mod that suspends object creation until module was executed

## Fix by mod:
- mod running permanently suspending all objects until module execution
Problem: theres a reason that execution order first spawns vehicles and then runs modules. often modules require the objects to run.
- mod running only through creator commision for certain objects
  - Advantage: Selectively exclude some vehicles that could collide for spawning directly
  - Drawback: creator needs to know what hes doing
  - Suggestion: An editor placeable module that is synched with a vehicle or mission layer and suspends their creations 
  
 
