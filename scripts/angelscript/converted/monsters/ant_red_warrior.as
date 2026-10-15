#pragma context server

// Converted from monsters/ant_red_warrior.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ant_red_warrior"]
class AntRedWarrior : BaseMonsterNewScript
{
	// Constants
	string ANIM_WALK1 = "walk";
	string ANIM_WALK2 = "walk2";
	string ANIM_ATTACK1 = "attack";
	string ANIM_ATTACK2 = "attack2";
	float FREQ_SWITCH_ANIM = 0.0f;
	float DMG_BITE = 50.0f;
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_ATTACK1 = "monsters/spider/spiderhiss2.wav";
	string SOUND_ATTACK2 = "monsters/spider/spiderhiss.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NEXT_SWITCH_ANIM = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	AntRedWarrior()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		NPC_ALLY_RESPONSE_RANGE = 1024.0f;
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
	}

	// unnamed block (first think)
	void AntRedWarrior_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack"; // frame_attack
		ANIM_RUN = "walk";
		ANIM_DEATH = "die";
	}

	// unnamed block (first think)
	void AntRedWarrior_FirstThink2()
	{
		NPC_GIVE_EXP = 100.0f;

		NPC_ALLY_RESPONSE_RANGE = 1024.0f; // larger response range than hp would suggest for better swarming

		ATTACK_RANGE = 32.0f;
		MOVE_RANGE = "16";
		ATTACK_MOVERANGE = 16.0f;
		ATTACK_HITRANGE = 64.0f;
	}

	// unnamed block (timer)
	void AntRedWarrior_Timer()
	{
		CallEventDelayed(3.6f, "AntRedWarrior_Timer");
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(4, 5, SOUND_IDLE1);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ServerPlaySound(4, 0, SOUND_IDLE1);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		if (RandomInt(1, 2) == 1)
			ANIM_ATTACK = ANIM_ATTACK1;
		else
			ANIM_ATTACK = ANIM_ATTACK2;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(2, 10, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SND_STRUCK1, SND_STRUCK2, SND_STRUCK3, SOUND_PAIN, SOUND_PAIN);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Giant Ant");
		SetModel("monsters/ant_size1.mdl");
		SetWidth(32);
		SetHeight(16);
		SetRace("ant_red");
		SetHealth(200);
		SetDamageTaken("pierce", 1.25f);
		SetRoam(true);
		SetHearingSensitivity(5);

		// movespeed's too slow, and I ain't redoing the anims again! ><
		SetAnimMoveSpeed(2);
		SetMoveSpeed(2);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (!(GameTime() > NEXT_SWITCH_ANIM))
			return;
		NEXT_SWITCH_ANIM = GameTime() + FREQ_SWITCH_ANIM;

		if (RandomInt(1, 2) == 1)
		{
			ANIM_RUN = ANIM_WALK1;
			ANIM_WALK = ANIM_WALK1;
			SetMoveAnim(ANIM_RUN);
		}
		else
		{
			ANIM_RUN = ANIM_WALK2;
			ANIM_WALK = ANIM_WALK2;
			SetMoveAnim(ANIM_RUN);
		}
	}

	// frame_attack
	void OnFrameAttack()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, "none", "none", "none", "none");
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "90%", "pierce");

		if (RandomInt(1, 2) == 1)
			ANIM_ATTACK = ANIM_ATTACK1;
		else
			ANIM_ATTACK = ANIM_ATTACK2;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ant_size1.mdl");
		Precache("monsters/spider/spideridle.wav");
		CallEventDelayed(3.6f, "AntRedWarrior_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AntRedWarrior_FirstThink();
		AntRedWarrior_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "AntRedWarrior_Timer") { AntRedWarrior_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
