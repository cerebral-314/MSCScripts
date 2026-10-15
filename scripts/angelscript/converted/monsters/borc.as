#pragma context server

// Converted from monsters/borc.script by msc_transpiler.
// The Primitive Borsh, lost Orc tribe gone Feral

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_jumper.as"

[script "monsters/borc"]
class Borc : BaseMonsterNewScript, BaseJumper
{
	// Constants
	string ANIM_LOOK = "anim_borsh_idle_look";
	string ANIM_NPC_JUMP = "anim_borsh_jump";
	string ANIM_MIGHTY_BLOW = "anim_borsh_dashattack1";
	string ANIM_DASH_ATTACK = "anim_borsh_dashattack2";
	bool NPC_JUMPER = true;
	bool BJUMPER_CUSTOM_BOOST = true;
	bool BJUMPER_NO_FORWARD = true;
	int BJUMPER_FACTOR = 4;
	int DMG_PUNCH_STRONG = 500;
	int DMG_PUNCH_WEAK = 200;
	int ATTACK_REACH = 64;
	float FREQ_MIGHTY_BLOW = 0.0f;
	string SOUND_MIGHTY1 = "monsters/orc/attack1.wav";
	string SOUND_MIGHTY2 = "monsters/orc/attack3.wav";
	string SOUND_ATTACK = "monsters/orc/attack2.wav";
	string SOUND_ALERT = "monsters/orc/battlecry.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "monsters/orc/zo_alert10.wav";
	string SOUND_PAIN2 = "voices/orc/hit2.wav";
	string SOUND_PAIN3 = "voices/orc/hit3.wav";
	string SOUND_PAIN4 = "voices/orc/hit.wav";
	string SOUND_NPC_JUMP = "monsters/orc/attack1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float MSC_PUSH_RESIST = 0.0f;
	float HALF_HEALTH = 0.0f;
	string QUART_HEALTH = "QUART_HEALTH";
	float NEXT_LOOK = 0.0f;
	bool DID_ALERT = false;
	float NEXT_MIGHTY_BLOW = 0.0f;
	bool HUNDERSWAMP_BORC = false;

	// Variables declared by included files, with the value they start with in this script
	Borc()
	{
		ANIM_IDLE = "anim_borsh_idle_norm";
		ANIM_WALK = "anim_borsh_walk";
		SOUND_DEATH = "voices/orc/die2.wav";
	}

	// unnamed block (first think)
	void Borc_FirstThink()
	{
		ANIM_IDLE = "anim_borsh_idle_norm";
		ANIM_WALK = "anim_borsh_walk";
		ANIM_RUN = "anim_borsh_run";
		ANIM_ATTACK = "anim_borsh_dashattack2";
		ANIM_DEATH = "anim_borsh_death";
	}

	// unnamed block (first think)
	void Borc_FirstThink2()
	{
		MSC_PUSH_RESIST = 0.75f; // "weighted"

		NPC_GIVE_EXP = 1000.0f;

		ATTACK_RANGE = 96.0f;
		ATTACK_HITRANGE = 128.0f; // this is a rare case, where we're going to want a hitrange less than attack range, but the base won't allow it
		ATTACK_MOVERANGE = 80.0f;
		MOVE_RANGE = "80"; // not sure if we still need this double define
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (!HUNDERSWAMP_BORC)
			return;
		if (RandomInt(1, 2) != 1)
			return;
		CreateNpc("chests/hunderswamp1_borc", RelativePosition(Vector3(0, 0, 0)));
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self, 2);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		float myHp = HealthOf(ENT_ME);
		if (myHp > HALF_HEALTH)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1);
		if (myHp <= HALF_HEALTH && myHp > Float(QUART_HEALTH))
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN2, SOUND_PAIN1);
		if (myHp <= Float(QUART_HEALTH)) {}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Feral Borsh");
		SetModel("monsters/borsh.mdl");
		SetWidth(64);
		SetHeight(64);
		SetHealth(4000);
		SetRace("orc");
		SetRoam(true);
		SetHearingSensitivity(2);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);

		SetModelBody(1, RandomInt(0, 1)); // random hat

		CallEventDelayed(2.0f, "finalize_npc");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
		if (NPCATK_TARGET != "unset")
			return;
		if (!(GameTime() > NEXT_LOOK))
			return;
		NEXT_LOOK = GameTime() + Random(10, 20);
		DebugPrint("npcatk_hunt look");
		PlayAnim("once", ANIM_LOOK);
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		DebugPrint("npcatk_lost_sight");
		if (!(GameTime() > NEXT_LOOK))
			return;
		NEXT_LOOK = GameTime() + 15.0f;
		PlayAnim("once", ANIM_LOOK);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		// dbg npc_selectattack game.time vs. NEXT_MIGHTY_BLOW
		if (!(GameTime() > NEXT_MIGHTY_BLOW))
			return;
		NEXT_MIGHTY_BLOW = GameTime() + 200.0f; // will reset after does blow
		ANIM_ATTACK = ANIM_MIGHTY_BLOW;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_ALERT)
			return;
		DID_ALERT = true;
		// thread display goes here
		NEXT_MIGHTY_BLOW = GameTime() + FREQ_MIGHTY_BLOW;
	}

	// finalize_npc
	void OnFinalizeNpc()
	{
		float maxHp = MaxHealthOf(ENT_ME);
		HALF_HEALTH = maxHp * 0.5f;
		QUART_HEALTH = Text(maxHp);
		HALF_HEALTH *= 0.25f;
	}

	// frame_jump_boost
	void OnFrameJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, FWD_NPC_JUMP_STR, NPC_UP_JUMP_STR)));
	}

	// frame_jump_land
	void OnFrameJumpLand()
	{
		OnNpcatkResumeAi();
	}

	// frame_attack_dash2a
	void OnFrameAttackDash2a()
	{
		LegacyCommand("svplayrandomsound", 0, 10, SOUND_MIGHTY1, SOUND_MIGHTY2); // using svplaysound as attacking on the move
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_PUNCH_STRONG, "80%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:strong_punch");
	}

	// frame_attack_dash2b
	void OnFrameAttackDash2b()
	{
		ServerPlaySound(0, 10, SOUND_ATTACK); // using svplaysound as attacking on the move
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_PUNCH_WEAK, "80%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:weak_punch");
	}

	// frame_mighty_blow
	void OnFrameMightyBlow()
	{
		ServerPlaySound(0, 10, "voices/orc/attack3.wav");
		NEXT_MIGHTY_BLOW = GameTime() + FREQ_MIGHTY_BLOW;
		ANIM_ATTACK = ANIM_DASH_ATTACK;
		DoDamageEx(NPCATK_TARGET, ATTACK_REACH, DMG_PUNCH_STRONG, "90%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:mighty_blow");
	}

	// strong_punch_dodamage
	void OnStrongPunchDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 350, 180)));
		if (RandomInt(1, 3) != 1)
			return;
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
	}

	// weak_punch_dodamage
	void OnWeakPunchDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 110, 110)));
	}

	// mighty_blow_dodamage
	void OnMightyBlowDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 300, 400)));
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
	}

	// frame_run_land
	void OnFrameRunLand()
	{
		PlayRandomSound(0, 10, "common/bodydrop1.wav", "common/bodydrop2.wav", "common/bodydrop3.wav", "common/bodydrop4.wav");
	}

	// set_hunderswamp_north_borc
	void OnSetHunderswampNorthBorc()
	{
		DebugPrint("set_hunderswamp_north_borc");
		HUNDERSWAMP_BORC = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/borsh.mdl");
		Precache("monsters/orc/attack1.wav");
		Precache("monsters/orc/attack3.wav");
		Precache("monsters/orc/attack2.wav");
		Precache("voices/orc/attack3.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Borc_FirstThink();
		Borc_FirstThink2();
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
		if (name == "finalize_npc") { OnFinalizeNpc(); return true; }
		if (name == "frame_attack_dash2a") { OnFrameAttackDash2a(); return true; }
		if (name == "frame_attack_dash2b") { OnFrameAttackDash2b(); return true; }
		if (name == "frame_jump_boost") { OnFrameJumpBoost(); return true; }
		if (name == "frame_jump_land") { OnFrameJumpLand(); return true; }
		if (name == "frame_mighty_blow") { OnFrameMightyBlow(); return true; }
		if (name == "frame_run_land") { OnFrameRunLand(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "mighty_blow_dodamage") { OnMightyBlowDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "set_hunderswamp_north_borc") { OnSetHunderswampNorthBorc(); return true; }
		if (name == "strong_punch_dodamage") { OnStrongPunchDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "weak_punch_dodamage") { OnWeakPunchDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BaseJumper_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
