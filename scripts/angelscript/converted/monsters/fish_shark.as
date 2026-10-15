#pragma context server

// Converted from monsters/fish_shark.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Shark

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_fish2.as"

[script "monsters/fish_shark"]
class FishShark : BaseMonsterScript, BasePropelled, BaseFish2
{
	// Constants
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
	float ATK_DMG_LOW = 5.0f;
	float ATK_DMG_HIGH = 10.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	float ATTACK_MOVERANGE = 0.0f;
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	FishShark()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "swim";
		ANIM_RUN = "thrust";
		SOUND_DEATH = "ichy/ichy_die2.wav";
	}

	// unnamed block (first think)
	void FishShark_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "swim";
		ANIM_RUN = "thrust";
		ANIM_DEATH = "die1";
		ANIM_FLINCH = "bgflinch";

		ATTACK_MOVERANGE = 60.0f;
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;

		CAN_HEAR = "1";
		HUNT_AGRO = "1";
		CAN_FLINCH = "1"; // Flinch when hit
		FLINCH_ANIM = "15%";
		FLINCH_CHANCE = "90%"; // 15
		FLINCH_DELAY = "4"; // base_npc_attack - Time until next allowed flinch
		NPC_HACKED_MOVE_SPEED = 250.0f; // base_propelled

		NPC_GIVE_EXP = 12.0f;
	}

	// game_damaged_other
	string FishShark_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		Vector3 pushVel = Vector3(0, 0, 0);
		if (ANIM_ATTACK == ANIM_ATK_BIG)
			pushVel = RelativeVelocity(Vector3(0, 200, 0));
		else if (ANIM_ATTACK == ANIM_ATK_LEFT)
			pushVel = RelativeVelocity(Vector3(-100, 100, 0));
		else if (ANIM_ATTACK == ANIM_ATK_RIGHT)
			pushVel = RelativeVelocity(Vector3(100, 100, 0));
		AddVelocity(ENT_LASTSTRUCKBYME, pushVel); // Push the player a bit
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, FishShark_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		if (!((IsInWater(target) ? 1 : 0) < 1))
			return;
		OnNpcatkClearTargets("targ_not_in_water");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(50);
		// ov 360
		SetWidth(64);
		SetHeight(32);
		SetName("Shark");
		SetHearingSensitivity(10);
		SetRoam(true);
		SetRace("wildanimal");

		SetModel("monsters/shark1.mdl");
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

	// frame_attack
	// Deal damage
	void OnFrameAttack()
	{
		PlayRandomSound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_ATTACK1, SOUND_ATTACK2);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, Random(ATK_DMG_LOW, ATK_DMG_HIGH), ATTACK_HITCHANCE);
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlayAnim("critical", ANIM_FLINCH);
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
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFish2_OnGameSpawn(playerRace, playerGender); // monsters/base_fish2
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFish2_OnNpcatkHunt(); // monsters/base_fish2
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/shark1.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FishShark_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
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
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseFish2_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
