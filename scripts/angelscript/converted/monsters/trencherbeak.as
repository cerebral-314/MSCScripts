#pragma context server

// Converted from monsters/trencherbeak.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_jumper.as"

[script "monsters/trencherbeak"]
class Trencherbeak : BaseMonsterNewScript, BaseJumper
{
	// Constants
	string ANIM_SEARCH = "idlelookout";
	string ANIM_ALERT1 = "roarangry";
	string ANIM_ALERT2 = "hiss";
	string ANIM_CUSTOM_FLINCH1 = "bigflinch";
	string ANIM_CUSTOM_FLINCH2 = "smallflinch";
	string ANIM_JUMP = "jumpscrape";
	float DMG_BITE = 200.0f;
	float FREQ_JUMP = 0.0f;
	string SOUND_ATTACK1 = "monsters/beak/attack1.wav";
	string SOUND_ATTACK2 = "monsters/beak/attack2.wav";
	string SOUND_STRUCK1 = "monsters/tube/TubeCritter_Hit1.wav";
	string SOUND_STRUCK2 = "monsters/tube/TuberCritter_Hit2.wav";
	string SOUND_STRUCK3 = "monsters/tube/TubeCritter_Hit3.wav";
	string SOUND_PAIN1 = "monsters/beak/pain1.wav";
	string SOUND_PAIN2 = "monsters/beak/pain2.wav";
	string SOUND_PAIN3 = "monsters/beak/suffer.wav";
	string SOUND_IDLE = "monsters/beak/roar.wav";
	string SOUND_ALERT1 = "monsters/beak/screech2.wav";
	string SOUND_ALERT2 = "monsters/beak/screech6.wav";
	string SOUND_ALERT3 = "monsters/beak/beakhiss.wav";
	string SOUND_ALERT4 = "monsters/beak/alert1.wav";
	string SOUND_ALERT5 = "monsters/beak/alert2.wav";
	string SOUND_JUMP = "monsters/birds/flap_small.wav";
	string ANIM_NPC_JUMP = "jumpscrape";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_JUMPER = false;
	float HALF_HP = 0.0f;
	float NEXT_VICTORY = 0.0f;
	bool DID_ALERT = false;
	float NEXT_JUMP = 0.0f;
	float NEXT_IDLE = 0.0f;
	float NEXT_COMBAT_JUMP = 0.0f;
	bool COMBAT_JUMP = false;
	float NEXT_CUST_FLINCH = 0.0f;
	float NEXT_HEARD_ALERT = 0.0f;
	string DEATH_GOAL = "DEATH_GOAL";
	bool MOMMY_ESCORT = false;

	// Variables declared by included files, with the value they start with in this script
	Trencherbeak()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
		SOUND_DEATH = "monsters/beak/die1.wav";
	}

	// unnamed block (first think)
	void Trencherbeak_FirstThink()
	{
		ANIM_ATTACK = "bite"; // frame_bite x4
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";

		ANIM_DEATH = "dietwitch";
	}

	// unnamed block (first think)
	void Trencherbeak_FirstThink2()
	{
		NPC_GIVE_EXP = 400.0f;

		ATTACK_MOVERANGE = 40.0f;
		MOVE_RANGE = "40";
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 90.0f;
		NPC_JUMPER = true;
	}

	// game_dodamage
	string Trencherbeak_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;
		float rndRl = Random(-200, 200);
		AddVelocity(target, RelativeVelocity(Vector3(rndRl, 110, 120)));
		return result;
	}

	// game_damaged
	string Trencherbeak_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		PlayRandomSound(1, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);

		if (!(GameTime() > NEXT_CUST_FLINCH))
			return result;
		NEXT_CUST_FLINCH = GameTime() + 5.0f;
		OnNpcatkSuspendAi("1.5");
		PlayRandomSound(2, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
		PlayAnim("critical", "ANIM_CUSTOM_FLINCH");
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Trencherbeak");
		SetModel("monsters/beak.mdl");
		SetWidth(32);
		SetHeight(32);
		SetRace("wildanimal");
		SetHealth(500);
		SetHearingSensitivity(8);
		CallEventDelayed(2.0f, "finalize_me");

		SetRoam(true);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;
		if (I_R_FROZEN)
			return;
		if (NPCATK_TARGET == "unset" && GameTime() > NEXT_IDLE)
		{
			NEXT_IDLE = GameTime() + Random(5, 15);
			PlaySound(0, 10, SOUND_IDLE);
			PlayAnim("once", ANIM_SEARCH);
		}

		if (NPCATK_TARGET == "unset")
			return;
		if (!(GameTime() > NEXT_COMBAT_JUMP))
			return;
		NEXT_COMBAT_JUMP = GameTime() + FREQ_JUMP;
		COMBAT_JUMP = true;
		PlayAnim("critical", ANIM_JUMP);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_VICTORY))
			return;
		NEXT_VICTORY = GameTime() + 15.0f;
		PlayAnim("critical", "eating");
		OnNpcatkSuspendRoam(2.0f);
		PlaySound(0, 10, "monsters/beak/eating.wav");
		DID_ALERT = false;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Trencherbeak_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Trencherbeak_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_ALERT)
			return;
		OnNpcatkSuspendRoam(2.0f);
		SetMoveDest(NPCATK_TARGET, 9999);
		DID_ALERT = true;

		NEXT_JUMP = GameTime() + FREQ_JUMP;

		int rndAlert = RandomInt(1, 2);

		if (rndAlert == 1)
		{
			PlayAnim("critical", ANIM_ALERT1);
			PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3, SOUND_ALERT4, SOUND_ALERT5);
		}

		if (rndAlert == 2)
		{
			PlayAnim("critical", ANIM_ALERT2);
			PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3, SOUND_ALERT4, SOUND_ALERT5);
		}
	}

	// npcatk_jump
	void OnNpcatkJump(float verticalDifference = 0.0f)
	{
		BaseJumper_OnNpcatkJump(verticalDifference); // monsters/base_jumper
		COMBAT_JUMP = false;
		NEXT_COMBAT_JUMP = GameTime() + FREQ_JUMP;
	}

	// finalize_me
	void OnFinalizeMe()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// frame_jump_boost
	void OnFrameJumpBoost()
	{
		PlaySound(0, 10, SOUND_JUMP);
		if (!COMBAT_JUMP)
			return;
		int rndLr = RandomInt(1, 2);
		if (rndLr == 1)
			rndLr = -200;
		if (rndLr == 2)
			rndLr = 200;
		float rndVadj = Random(200, 300);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLr, 150, rndVadj)));
		COMBAT_JUMP = false;
	}

	// set_hunt_on_spawn
	// external
	void OnSetHuntOnSpawn()
	{
		DID_ALERT = true;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3, SOUND_ALERT4, SOUND_ALERT5);
		SetVar("PLAYER_LIST", GetActivePlayers());
		string sortList = SortEntities("PLAYER_LIST", "range");
		OnNpcatkSettarget(GetToken(sortList, 0));
	}

	// frame_bite_start
	void OnFrameBiteStart()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
	}

	// frame_bite
	void OnFrameBite()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "80%", "pierce");
	}

	// npc_heard_player
	void OnNpcHeardPlayer()
	{
		if (NPCATK_TARGET != "unset")
			return;
		if (!(GameTime() > NEXT_HEARD_ALERT))
			return;
		NEXT_HEARD_ALERT = GameTime() + 10.0f;
		PlayAnim("critical", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3, SOUND_ALERT4, SOUND_ALERT5);
	}

	// ext_mommy_died
	void OnExtMommyDied(string deathPosition = "")
	{
		if (!MOMMY_ESCORT)
			return;
		OnNpcatkSuspendAi();
		DEATH_GOAL = deathPosition;
		PlayAnim("break");
		PlayAnim(ANIM_RUN);
		SetMoveDest(DEATH_GOAL, 32);
		OnDeathGoalLoop();
	}

	// death_goal_loop
	void OnDeathGoalLoop()
	{
		SetRoam(true);
		SUSPEND_AI = true; // in case revoked
		CallEventDelayed(2.0f, "death_goal_loop");
		SetMoveDest(DEATH_GOAL, 32);
	}

	// set_mommy_escort
	void OnSetMommyEscort()
	{
		MOMMY_ESCORT = true;
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
		Precache("monsters/beak.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Trencherbeak_FirstThink();
		Trencherbeak_FirstThink2();
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
		if (name == "death_goal_loop") { OnDeathGoalLoop(); return true; }
		if (name == "ext_mommy_died") { OnExtMommyDied(Param(params, 0)); return true; }
		if (name == "finalize_me") { OnFinalizeMe(); return true; }
		if (name == "frame_bite") { OnFrameBite(); return true; }
		if (name == "frame_bite_start") { OnFrameBiteStart(); return true; }
		if (name == "frame_jump_boost") { OnFrameJumpBoost(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_heard_player") { OnNpcHeardPlayer(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_jump") { OnNpcatkJump(Float(Param(params, 0))); return true; }
		if (name == "set_hunt_on_spawn") { OnSetHuntOnSpawn(); return true; }
		if (name == "set_mommy_escort") { OnSetMommyEscort(); return true; }
		return BaseJumper_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
