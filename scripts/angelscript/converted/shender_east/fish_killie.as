#pragma context server

// Converted from shender_east/fish_killie.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_fish2.as"

[script "shender_east/fish_killie"]
class ShenderEastFishKillie : BaseMonsterNewScript, BasePropelled, BaseFish2
{
	// Constants
	bool NPC_EXTRA_VALIDATIONS = true;
	bool DELETE_ON_DEATH = true;
	string ANIM_ATK_BIG = "srattack1";
	string ANIM_ATK_RIGHT = "bite_r";
	string ANIM_ATK_LEFT = "bite_l";
	string SOUND_IDLE1 = "ichy/ichy_idle1.wav";
	string SOUND_IDLE2 = "ichy/ichy_idle2.wav";
	string SOUND_ATTACK1 = "ichy/ichy_bite1.wav";
	string SOUND_ATTACK2 = "ichy/ichy_bite2.wav";
	string SOUND_STRUCK1 = "ichy/ichy_pain2.wav";
	string SOUND_STRUCK2 = "ichy/ichy_pain3.wav";
	string SOUND_STRUCK3 = "ichy/ichy_pain5.wav";
	string SOUND_STRUCK4 = "ichy/ichy_pain3.wav";
	string SOUND_STRUCK5 = "ichy/ichy_pain5.wav";
	string ATTACK_HITCHANCE = "75%";
	float ATK_DMG_LOW = 200.0f;
	float ATK_DMG_HIGH = 500.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string PLAYER_LIST = "PLAYER_LIST";

	// Variables declared by included files, with the value they start with in this script
	ShenderEastFishKillie()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "swim";
		ANIM_RUN = "thrust";
		SOUND_DEATH = "ichy/ichy_die2.wav";
	}

	// unnamed block (first think)
	void ShenderEastFishKillie_FirstThink()
	{
		PLAYING_DEAD = "1"; // so summons don't target
		ANIM_IDLE = "idle";
		ANIM_WALK = "swim";
		ANIM_RUN = "thrust";
		ANIM_DEATH = "die1";
		ANIM_FLINCH = "bgflinch";

		ATTACK_MOVERANGE = 64.0f;
		ATTACK_RANGE = 120.0f;
		ATTACK_HITRANGE = 180.0f;

		NPC_HACKED_MOVE_SPEED = 250.0f; // base_propelled

		NPC_GIVE_EXP = 1000.0f;
	}

	// game_damaged_other
	string ShenderEastFishKillie_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		// insta-kill (no XP loss, if you survive the damage, but boots you out of dreamland)
		Effect("screenfade", @target, 5, 1, Vector3(255, 0, 0), 255);
		string spawnName = GetQuestData(target, "d");
		LegacyCommand("tospawn", @target, spawnName);
		NPCATK_TARGET = "unset";
		return result;
	}

	// unnamed block (timer)
	void ShenderEastFishKillie_Timer()
	{
		CallEventDelayed(1.0f, "ShenderEastFishKillie_Timer");
		// check for players in water
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnWaterCheck();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}

		if (NPCATK_TARGET != "unset")
			return;
		if (!(Distance(MyOrigin(), Vec(NPC_HOME_LOC)) > 512.0f))
			return;
		OnNpcatkSetmovedest(NPC_HOME_LOC, "32");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, ShenderEastFishKillie_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetHealth(2000);
		SetWidth(64);
		SetHeight(32);
		SetName("Nightmare Orca");
		SetHearingSensitivity(10);
		SetRoam(true);
		SetRace("demon");
		SetInvincible(true);
		SetNoPush(true);

		SetModel("monsters/killie.mdl");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFish2_OnNpcatkHunt(); // monsters/base_fish2
		if (NPCATK_TARGET == "unset")
			return;
		if ((IsInWater(NPCATK_TARGET) ? 1 : 0) == 0)
			NPCATK_TARGET = "unset";
	}

	// npc_selectattack
	// Switch up my attack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		int nextAttack = RandomInt(0, 2);
		if (nextAttack == 0)
			ANIM_ATTACK = ANIM_ATK_BIG;
		else if (nextAttack == 1)
			ANIM_ATTACK = ANIM_ATK_LEFT;
		else if (nextAttack == 2)
			ANIM_ATTACK = ANIM_ATK_RIGHT;
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared

		// only attack players, only those in water
		if (!IsPlayer(NPCATK_TARGET))
			NPCATK_TARGET = "unset";
		if ((IsInWater(NPCATK_TARGET) ? 1 : 0) < 1)
			NPCATK_TARGET = "unset";
	}

	// frame_attack
	// Deal damage
	void OnFrameAttack()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, Random(ATK_DMG_LOW, ATK_DMG_HIGH), ATTACK_HITCHANCE);
	}

	// water_check
	void OnWaterCheck()
	{
		if (NPCATK_TARGET != "unset")
			return;
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (!((IsInWater(curTarg) ? 1 : 0) > 0))
			return;
		OnNpcatkSettarget(curTarg);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFish2_OnGameSpawn(playerRace, playerGender); // monsters/base_fish2
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/killie.mdl");
		CallEventDelayed(1.0f, "ShenderEastFishKillie_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShenderEastFishKillie_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFish2_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "water_check") { OnWaterCheck(); return true; }
		if (name == "ShenderEastFishKillie_Timer") { ShenderEastFishKillie_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseFish2_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
