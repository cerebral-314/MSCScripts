#pragma context server

// Converted from monsters/firegiantghoul_lesser.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/firegiantghoul.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class FiregiantghoulLesser
{
	// Constants
	int MY_MAX_HP = 400;
	string MY_NAME = "Decayed Undead Firegiant";
	int FIREBALL_DAMAGE = 25;
	string ATTACK_DAMAGE = "15";
	float THROW_CHANCE = 10.0f;
	int FIN_EXP = 150;
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/firegiantghoul_lesser"]
shared class FiregiantghoulLesserScript : FiregiantghoulScript, FiregiantghoulLesser
{
	// Variables declared by included files, with the value they start with in this script
	FiregiantghoulLesserScript()
	{
		MY_MAX_HP = 400;
		MY_NAME = "Decayed Undead Firegiant";
		FIREBALL_DAMAGE = 25;
		ATTACK_DAMAGE = "15";
		THROW_CHANCE = 10.0f;
	}
}
