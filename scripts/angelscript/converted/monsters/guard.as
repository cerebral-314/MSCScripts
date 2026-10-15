#pragma context server

// Converted from monsters/guard.script by msc_transpiler.
// Guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/guard"]
class MonstersGuard : BaseMonsterScript
{
	// Variables (an unset .script variable reads as its own name)
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_PAIN2 = "player/armhit1.wav";
	string SOUND_ATTACK1 = "npc/prepdie1.wav";
	string SOUND_ATTACK2 = "monsters/sludge/null.wav";
	string SOUND_ATTACK3 = "monsters/sludge/null.wav";
	string ATTACK_HITCHANCE = "80%";
	int GORE_DAMAGE = 9;
	int FLEE_HEALTH = 10;
	string FLEE_CHANCE = "25%";
	string MY_ENEMY = "0";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;

	// Variables declared by included files, with the value they start with in this script
	MonstersGuard()
	{
		SOUND_DEATH = "player/stomachhit1.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void MonstersGuard_FirstThink()
	{
		SOUND_PAIN = "player/chesthit1.wav";
		SOUND_PAIN2 = "player/armhit1.wav";
		SOUND_ATTACK1 = "npc/prepdie1.wav";
		SOUND_ATTACK2 = "monsters/sludge/null.wav";
		SOUND_ATTACK3 = "monsters/sludge/null.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 140.0f;
		ATTACK_HITCHANCE = "80%";
		GORE_DAMAGE = 9;
		FLEE_HEALTH = 10;
		FLEE_CHANCE = "25%";
		IS_FLEEING = false;
		MY_ENEMY = "0";
		DROP_GOLD = RandomInt(0, 1);
		DROP_GOLD_MIN = 1;
		DROP_GOLD_MAX = 20;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(100);
		// ov 120
		SetWidth(32);
		SetHeight(72);
		SetRace("rogue");
		SetName("Renegade Guard");
		SetRoam(true);
		SetHearingSensitivity(4);
		SetDamageTaken("all", 0.8f);
		SetSkillLevel(35);
		SetModel("npc/guard1.mdl");

		SetIdleAnim("idle1");
		SetMoveAnim("walk");
	}

	// attack_1
	void OnAttack12()
	{
		// Deal damage
		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, GORE_DAMAGE, ATTACK_HITCHANCE);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		MonstersGuard_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
