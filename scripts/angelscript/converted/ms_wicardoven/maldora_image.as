#pragma context server

// Converted from ms_wicardoven/maldora_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "ms_wicardoven/maldora_image"]
class MaldoraImage : BaseMonsterNewScript
{
	// Constants
	string ANIM_LEAP = "long_jump";
	string ANIM_WAND = "ref_shoot_crowbar";
	float SPELL_FREQ = 7.0f;
	float DMG_WAND = 0.0f;
	float LEAP_FREQ = 2.0f;
	string MONSTER_MODEL = "monsters/maldora.mdl";
	bool I_AM_TURNABLE = false;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MY_MASTER = "MY_MASTER";
	string FIRST_TARGET = "FIRST_TARGET";
	string SLIDE_DIR = "SLIDE_DIR";
	string UBER_MODE = "UBER_MODE";
	bool SLIDE_COUNT = false;
	bool LEAP_DELAY = false;

	// Variables declared by included files, with the value they start with in this script
	MaldoraImage()
	{
		ANIM_IDLE = "idle";
		ANIM_RUN = "run2";
		ANIM_WALK = "walk2handed";
		SOUND_DEATH = "null.wav";
	}

	// unnamed block (first think)
	void MaldoraImage_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "treadwater";
		ANIM_RUN = "run2";
		ANIM_WALK = "walk2handed";
		ANIM_DEATH = "die_backwards1";

		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_dodamage
	string MaldoraImage_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (RandomInt(1, 5) != 1)
			return result;
		ApplyEffect(target, "effects/debuff_stun", 3.0f, self);
		return result;
	}

	// maldoraf_died
	void MaldoraImage_OnMaldorafDied(CBaseEntity@ killer = null)
	{
		CallEventDelayed(1.0f, "check_owner");
	}

	// maldoraf_died
	void MaldoraImage_OnMaldorafDied_2(CBaseEntity@ killer = null)
	{
		if (EntityId(killer) != MY_MASTER)
			return;
		DeleteEntity(ENT_ME);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		int randDeath = RandomInt(1, 7);
		if (randDeath == 1)
			ANIM_DEATH = "die_simple";
		if (randDeath == 2)
			ANIM_DEATH = "die_backwards1";
		if (randDeath == 3)
			ANIM_DEATH = "die_backwards";
		if (randDeath == 4)
			ANIM_DEATH = "die_forwards";
		if (randDeath == 5)
			ANIM_DEATH = "headshot";
		if (randDeath == 6)
			ANIM_DEATH = "die_spin";
		if (randDeath == 7)
			ANIM_DEATH = "gutshot";
	}

	// game_dynamically_created
	// PARAM1=Owner PARAM2=Enemy PARAM3=slide PARAM4=uber
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		OnNpcatkSuspendAi();

		MY_MASTER = creatorValue1;
		FIRST_TARGET = creatorValue2;
		SLIDE_DIR = damage;
		UBER_MODE = skill;
		SetSolid("none");

		DebugPrint("game_dynamically_created " + creatorValue1 + " " + creatorValue2 + " " + damage + " " + skill);

		if (Float(UBER_MODE) == 1.0f)
		{
			NPC_GIVE_EXP *= 10.0f;
			SetHealth(800);
			SetDamageMultiplier(3);
			DebugPrint("game_dynamically_created Uber mode activated");
		}

		SLIDE_COUNT = false;
		CallEventDelayed(0.1f, "slide_in");

		CallEventDelayed(2.0f, "npcatk_resume_ai");
		CallEventDelayed(2.1f, "set_target");

		CallEventDelayed(4.0f, "flank_loop");

		CallEventDelayed(120.0f, "me_expire");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Image of Maldora");
		SetHealth(200);
		SetRace("demon");
		SetWidth(32);
		SetHeight(86);

		SetBlood("none");

		NPC_GIVE_EXP = 60.0f;

		SetRoam(true);

		SetHearingSensitivity(10);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);

		SetDamageTaken("holy", 3);

		SetModel(MONSTER_MODEL);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "skin", 5);

		OnResetProps();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		Vector3 masterOrg = OriginOf(MY_MASTER);
		if (!(Distance(MyOrigin(), masterOrg) < 64.0f))
			return;
		OnLeapAway(MY_MASTER);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MaldoraImage_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!(RangeTo(target) > 100.0f))
			return;
		OnLeapAt(NPCATK_TARGET);
	}

	// slide_in
	void OnSlideIn()
	{
		Vector3 leapTarg = RelativePosition(Vector3(0, Float(SLIDE_DIR), 0), Vector3(0, 1000, 0));
		OnLeapAt(Text(leapTarg));
	}

	// set_target
	void OnSetTarget(string target = "")
	{
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		OnNpcatkSettarget(FIRST_TARGET);
	}

	// leap_at
	// PARAM1 TARGET
	void OnLeapAt(string target = "")
	{
		if (LEAP_DELAY)
			return;
		LEAP_DELAY = true;
		CallEventDelayed(LEAP_FREQ, "reset_leap_delay");

		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(target, MOVE_RANGE);
		CallEventDelayed(0.1f, "leap_at2");
	}

	// leap_at2
	void OnLeapAt2()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 50)));
	}

	// reset_leap_delay
	void OnResetLeapDelay()
	{
		LEAP_DELAY = false;
	}

	// npc_death
	void OnNpcDeath()
	{
		SetProp(ENT_ME, "renderamt", 80);
		CallExternal(MY_MASTER, "image_died");
	}

	// reset_props
	void OnResetProps()
	{
		CallEventDelayed(5.3f, "reset_props");

		if (!Truthy(Eval("game.monster.isalive")))
			return;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// leap_away
	// dude to flee
	void OnLeapAway(string target = "")
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(target, 800, "flee");
		CallEventDelayed(0.1f, "leap_away2");
	}

	// leap_away2
	void OnLeapAway2()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// thrash_strike
	void OnThrashStrike()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_WAND), "80%", "blunt");
	}

	// flank_loop
	void OnFlankLoop()
	{
		CallEventDelayed(4.0f, "flank_loop");

		if (!(RangeTo(NPCATK_TARGET) < ATTACK_RANGE))
			return;
		if (RandomInt(1, 2) != 1)
			return;
		Vector3 destPos = OriginOf(NPCATK_TARGET);
		int rndAng = RandomInt(0, 359);
		destPos += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, ATTACK_RANGE, 0));
		OnLeapAt(Text(destPos));
	}

	// maldora_died
	void OnMaldoraDied()
	{
		DeleteEntity(ENT_ME);
	}

	// maldoraf_died
	void OnMaldorafDied(CBaseEntity@ killer = null)
	{
		MaldoraImage_OnMaldorafDied(killer);
		MaldoraImage_OnMaldorafDied_2(killer);
	}

	// check_owner
	void OnCheckOwner()
	{
		if (IsAlive(MY_MASTER))
			return;
		DeleteEntity(ENT_ME);
	}

	// me_expire
	void OnMeExpire()
	{
		SetProp(ENT_ME, "renderamt", 0);
		CallExternal(MY_MASTER, "image_died");
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// maldora_final_died
	void OnMaldoraFinalDied(CBaseEntity@ killer = null)
	{
		if (EntityId(killer) != MY_MASTER)
			return;
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnLeapFreq() {} // LEAP_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/maldora.mdl");
		CallEventDelayed(5.3f, "reset_props");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MaldoraImage_FirstThink();
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
		if (name == "check_owner") { OnCheckOwner(); return true; }
		if (name == "flank_loop") { OnFlankLoop(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "leap_at") { OnLeapAt(Param(params, 0)); return true; }
		if (name == "leap_at2") { OnLeapAt2(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_away2") { OnLeapAway2(); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "maldora_died") { OnMaldoraDied(); return true; }
		if (name == "maldora_final_died") { OnMaldoraFinalDied(EntityParam(params, 0)); return true; }
		if (name == "maldoraf_died") { OnMaldorafDied(EntityParam(params, 0)); return true; }
		if (name == "me_expire") { OnMeExpire(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "reset_leap_delay") { OnResetLeapDelay(); return true; }
		if (name == "reset_props") { OnResetProps(); return true; }
		if (name == "set_target") { OnSetTarget(Param(params, 0)); return true; }
		if (name == "slide_in") { OnSlideIn(); return true; }
		if (name == "thrash_strike") { OnThrashStrike(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
