#pragma context server

// Converted from monsters/rogue.script by msc_transpiler.
// Default rogue

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/rogue"]
class Rogue : BaseMonsterScript
{
	// Constants
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "player/armhit1.wav";
	string SOUND_STRUCK3 = "player/leghit1.wav";
	string SOUND_PAIN = "player/chesthit1.wav";
	string SOUND_ATTACK1 = "player/jab1.wav";
	string SOUND_ATTACK2 = "player/jab2.wav";
	string ATTACK1_DAMAGE = "4";
	string ATTACK_ACCURACY = "60%";
	string RETALIATE_CHANGETARGET_CHANCE = "25%";

	// Variables (an unset .script variable reads as its own name)
	string FLINCH_CHANCE = "FLINCH_CHANCE";

	// Variables declared by included files, with the value they start with in this script
	Rogue()
	{
		SOUND_DEATH = "player/stomachhit1.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Rogue_FirstThink()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		MOVE_RANGE = "64"; // Stop approaching if already this close
		ATTACK_RANGE = 100.0f; // Start attacking at this range
		ATTACK_HITRANGE = 130.0f; // Actual attack range
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		FLINCH_CHANCE = "12"; // Chances of flinching: 1 out of FLINCH_CHANCE
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(RandomInt(90, 200));
		// ov 120
		SetWidth(32);
		SetHeight(85);
		SetRace("rogue");
		SetName("Rogue");
		SetGold(RandomInt(10, 90));
		SetHearingSensitivity(3);
		SetRoam(true);
		NPC_GIVE_EXP = 28.0f;
		SetModel("npc/rogue.mdl");
		SetIdleAnim("aim_stance_normal");
		SetMoveAnim("aim_stance_normal");
	}

	// attack_1
	void OnAttack12()
	{
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK1_DAMAGE, ATTACK_ACCURACY);
		OnAttackstrike();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(2, 5, SOUND_PAIN, SOUND_PAIN, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		OnFlinch();
		OnRetaliate();
	}

	// npc_death
	void OnNpcDeath()
	{
		PlaySound(2, 5, SOUND_DEATH);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnAttackstrike() {} // attackstrike
	void OnFlinch() {} // flinch
	void OnRetaliate() {} // retaliate

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/rogue.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Rogue_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
