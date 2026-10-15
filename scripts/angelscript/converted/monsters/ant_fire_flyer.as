#pragma context server

// Converted from monsters/ant_fire_flyer.script by msc_transpiler.
// idea: workers non-agro, follow set_leader

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_jumper.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/ant_fire_flyer"]
class AntFireFlyer : BaseMonsterNewScript, BaseJumper, BasePropelled
{
	// Constants
	string ANIM_HOVER = "anim_hover";
	string ANIM_2HOVER = "anim_2hover";
	string ANIM_LAND = "anim_land";
	string ANIM_HOVER_BREATH = "anim_hover_breath";
	string ANIM_HOVER_BITE = "anim_hover_shoot";
	string ANIM_WALK1 = "walk";
	string ANIM_WALK2 = "walk2";
	string ANIM_ATTACK1 = "attack";
	string ANIM_ATTACK2 = "attack2";
	float FREQ_BREATH = 0.0f;
	float FREQ_BUZZ = 4.45f;
	float FREQ_DODGE = 1.0f;
	float DMG_BITE = 50.0f;
	float DOT_FIRE = 10.0f;
	string SOUND_FLY_LOOP = "monsters/beetle/fly1_noloop.wav";
	string SOUND_PAIN1 = "monsters/beetle/pain1.wav";
	string SOUND_PAIN2 = "monsters/beetle/pain2.wav";
	string SOUND_STRUCK1 = "monsters/beetle/shell_impact1.wav";
	string SOUND_STRUCK2 = "monsters/beetle/shell_impact2.wav";
	string SOUND_STRUCK3 = "monsters/beetle/shell_impact3.wav";
	string SOUND_STRUCK4 = "monsters/beetle/shell_impact4.wav";
	string SOUND_ATTACK1 = "monsters/beetle/attack_single1.wav";
	string SOUND_ATTACK2 = "monsters/beetle/attack_single2.wav";
	string SOUND_ATTACK3 = "monsters/beetle/attack_single3.wav";
	string SOUND_BREATH = "monsters/goblin/sps_fogfire.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_JUMPER = false;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	int DID_INTRO = 0;
	bool ANT_AM_FLYING = false;
	float NEXT_BREATH = 0.0f;
	bool NPC_PROPELL_SUSPEND = false;
	float NEXT_BUZZ_SOUND = 0.0f;
	string BREATH_TARG = "BREATH_TARG";
	string BREATH_ON = "BREATH_ON";
	string CL_BREATH_IDX = "CL_BREATH_IDX";
	Vector3 SCAN_POINT = Vector3();
	string BREATH_TARGETS = "BREATH_TARGETS";
	float NEXT_DODGE = 0.0f;
	float DODGE_IDX = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	AntFireFlyer()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_DEATH = "anim_hover_death";
		NPC_ALLY_RESPONSE_RANGE = 1024.0f;
		SOUND_DEATH = "monsters/beetle/pain2.wav";
	}

	// unnamed block (first think)
	void AntFireFlyer_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack"; // frame_attack
		ANIM_RUN = "walk";
		ANIM_DEATH = "anim_hover_death";
		NPC_JUMPER = true;

		NPC_GIVE_EXP = 150.0f;

		NPC_ALLY_RESPONSE_RANGE = 1024.0f; // larger response range than hp would suggest for better swarming

		ATTACK_MOVERANGE = 192.0f;
		MOVE_RANGE = "192";

		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;

		NPC_HACKED_MOVE_SPEED = 0.0f;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string AntFireFlyer_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool isDot = false;
		int rndLr = 0;
		string result = "";
		if (!ANT_AM_FLYING)
			return result;
		if (!(damage < HealthOf(ENT_ME)))
			return result;
		if (Contains(damageType, "effect"))
			isDot = true;
		if (isDot)
			return result;
		if (!(GameTime() > NEXT_DODGE))
			return result;
		NEXT_DODGE = GameTime() + FREQ_DODGE;
		DODGE_IDX += 1.0f;
		if (DODGE_IDX == 1.0f)
			rndLr = 400;
		if (DODGE_IDX == 2.0f)
		{
			rndLr = -400;
			DODGE_IDX = 0.0f;
		}

		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLr, -200, 0)));
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (Truthy(BREATH_ON))
			OnFrameBreathEnd();
		ANIM_DEATH = "die";
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlaySound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_PAIN1, SOUND_PAIN2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Elite Fire Ant Warrior");
		SetModel("monsters/ant_size2.mdl");
		SetWidth(32);
		SetHeight(64);
		SetBlood("green");
		SetRace("ant_red");
		SetHealth(500);
		SetDamageTaken("pierce", 1.25f);
		SetRoam(false);
		SetHearingSensitivity(5);

		SetModelBody(1, 1);

		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("fire", 0.5f);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
		if (NPCATK_TARGET == "unset")
			return;
		if (ANT_AM_FLYING)
		{
			NPC_PROPELL_SUSPEND = false;
			if (NPC_HACKED_MOVE_SPEED < 300.0f)
			{
				if (RangeTo(NPCATK_TARGET) > ATTACK_MOVERANGE)
					NPC_HACKED_MOVE_SPEED += 10.0f;
				else if (RangeTo(NPCATK_TARGET) <= ATTACK_MOVERANGE && NPC_HACKED_MOVE_SPEED > 0.0f)
					NPC_HACKED_MOVE_SPEED -= 1.0f;
			}

			if (GameTime() > NEXT_BUZZ_SOUND)
			{
				NEXT_BUZZ_SOUND = GameTime() + FREQ_BUZZ;
				ServerPlaySound(2, 10, SOUND_FLY_LOOP);
			}
			ANIM_ATTACK = ANIM_HOVER_BITE;

			if (GameTime() > NEXT_BREATH && RangeTo(NPCATK_TARGET) < 256.0f)
			{
				NEXT_BREATH = GameTime() + FREQ_BREATH;
				PlayAnim("critical", "anim_hover_breath");
			}
		}
		else
		{
			NPC_PROPELL_SUSPEND = true;
			NPC_HACKED_MOVE_SPEED = 0.0f;
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		ANT_AM_FLYING = false;
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle";

		PlayAnim("critical", ANIM_LAND);
		DID_INTRO = 0;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, AntFireFlyer_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO != 0)
			return;
		SetMoveAnim(ANIM_HOVER);
		SetIdleAnim(ANIM_HOVER);
		ANIM_WALK = ANIM_HOVER;
		ANIM_RUN = ANIM_HOVER;
		ANIM_IDLE = ANIM_HOVER;
		PlayAnim("critical", ANIM_2HOVER);
		DID_INTRO = 1;
		ANT_AM_FLYING = true;
		NEXT_BREATH = GameTime() + 3.0f;
		NPC_PROPELL_SUSPEND = true;
		NPC_HACKED_MOVE_SPEED = 0.0f;
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		BasePropelled_OnGameStopmoving(); // monsters/base_propelled
		NPC_HACKED_MOVE_SPEED = 0.0f;
	}

	// frame_breath_start
	void OnFrameBreathStart()
	{
		SetAnimMoveSpeed(0);
		NPC_PROPELL_SUSPEND = true;
		NPC_HACKED_MOVE_SPEED = 0.0f;
		NPC_JUMPER = false;
		SetMoveDest(BREATH_TARG, 9999);
		BREATH_TARG = NPCATK_TARGET;
		// playanim critical ANIM_HOVER_BREATH
		// callevent npcatk_suspend_movement ANIM_HOVER_BREATH 5.0
		OnNpcatkSuspendAi("3.0");
		BREATH_ON = "1";
		PlaySound(0, 10, SOUND_BREATH);
		ClientEvent("new", "all", "monsters/ant_fire_cl", IndexOf(ENT_ME), 5.0f, 0.5f);
		CL_BREATH_IDX = LastClientScriptId();
		SCAN_POINT = RelativePosition(Vector3(0, 64, 32));
		OnBreathLoop();
	}

	// breath_loop
	void OnBreathLoop()
	{
		if (!Truthy(BREATH_ON))
			return;
		SetMoveDest(SCAN_POINT, 9999);
		CallEventDelayed(0.5f, "breath_loop");
		BREATH_TARGETS = LegacyFunction("get_tsphere", "enemy", 196, SCAN_POINT);
		// dbg breath_loop $get_token_amt(BREATH_TARGETS) SCAN_POINT BREATH_TARGETS
		if (BREATH_TARGETS == "none")
			return;
		int count = GetTokenCount(BREATH_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBreathAffectTargets();
		}
	}

	// breath_affect_targets
	void OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BREATH_TARGETS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		// dbg breath_affect_targets $get(CUR_TARG,name) rng $get(CUR_TARG,range) hasfire $get(CUR_TARG,haseffect,DOT_fire) incone $within_cone2D(TARG_ORG,game.monster.origin,game.monster.angles,30)
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 1))
			return;
		if (!(RangeTo(curTarg) < 384.0f))
			return;

		Vector3 traceStart = AttachmentPositionOf(ENT_ME, 0);
		string traceEnd = Text(targOrg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			return;

		if (!HasEffect(curTarg, "DOT_fire"))
			ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_FIRE);

		// push closer targets harder
		float pushRatio = RangeTo(curTarg);
		if (pushRatio < 256.0f)
		{
			pushRatio = Divide(pushRatio, 256.0f);
			pushRatio = Ratio(pushRatio, 2000, 200);
		}
		else
		{
			pushRatio = 200.0f;
		}

		AddVelocity(curTarg, RelativeVelocity(Vector3(0, pushRatio, 110)));
	}

	// frame_breath_end
	void OnFrameBreathEnd()
	{
		NPC_PROPELL_SUSPEND = false;
		NPC_JUMPER = true;
		BREATH_ON = "0";
		OnNpcatkResumeAi();
		ClientEvent("update", "all", CL_BREATH_IDX, "end_fx");
	}

	// frame_shoot
	// this is actually the bite attack
	void OnFrameShoot()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "90%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (HasEffect(target, "DOT_fire"))
			return;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
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

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ant_size2.mdl");
		Precache("monsters/beetle/fly1_noloop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AntFireFlyer_FirstThink();
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
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "frame_breath_end") { OnFrameBreathEnd(); return true; }
		if (name == "frame_breath_start") { OnFrameBreathStart(); return true; }
		if (name == "frame_shoot") { OnFrameShoot(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return BaseJumper_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
