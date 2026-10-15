#pragma context server

// Converted from monsters/swamp_tube.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/swamp_tube"]
class SwampTube : BaseMonsterNewScript
{
	// Constants
	string ANIM_CUSTOM_FLINCH = "flinch";
	string ANIM_ALERT = "arming";
	string ANIM_ATTACK_QUICK = "qkfire";
	string ANIM_MORTAR_READY = "arming";
	string ANIM_MORTAR = "shoot";
	float DMG_GLOB = 400.0f;
	int DOT_GLOB = 100;
	int DMG_NEEDLE = 150;
	string SOUND_SHOOT = "monsters/tube/tube_fire_new.wav";
	string SOUND_MOURN1 = "monsters/tube/tube_mourn1.wav";
	string SOUND_MOURN2 = "monsters/tube/tube_mourn2.wav";
	string SOUND_MOURN3 = "monsters/tube/tube_mourn3.wav";
	string SOUND_IDLE1 = "monsters/tube/Tube_Idle.wav";
	string SOUND_IDLE2 = "monsters/tube/Tube_Idle2.wav";
	string SOUND_IDLE3 = "monsters/tube/Tube_Idle3.wav";
	string SOUND_ALERT1 = "monsters/tube/tube_gtfo.wav";
	string SOUND_ALERT2 = "monsters/tube/Tube_SeePlayer.wav";
	string SOUND_STRUCK1 = "monsters/tube/TubeCritter_Hit1.wav";
	string SOUND_STRUCK2 = "monsters/tube/TuberCritter_Hit2.wav";
	string SOUND_STRUCK3 = "monsters/tube/TubeCritter_Hit3.wav";
	string SOUND_PAIN = "monstrs/tube/Tube_Flinch.wav";
	string SOUND_DEATH1 = "monsters/tube/die1.wav";
	string SOUND_DEATH2 = "monsters/tube/Tube_DieBack.wav";
	string SOUND_DEATH3 = "monsters/tube/Tube_DieSimple.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float FREQ_MORTAR = 0.0f;
	bool NPC_IS_RANGED = false;
	string NPC_ALT_SOUND_DEATH = "NPC_ALT_SOUND_DEATH";
	float RUN_STEP = 0.0f;
	float HALF_HP = 0.0f;
	float NEXT_IDLE = 0.0f;
	float NEXT_MORTAR = 0.0f;
	float NEXT_REPOS = 0.0f;
	float NEXT_RETREAT = 0.0f;
	float NEXT_VICTORY = 0.0f;
	bool DID_ALERT = false;
	float NEXT_CUST_FLINCH = 0.0f;
	float NEXT_HEARD_ALERT = 0.0f;
	bool MORTAR_READY = false;
	float MORTAR_ANG = 0.0f;
	bool MORTAR_ACTIVE = false;
	string BLOB_ORG = "BLOB_ORG";
	Vector3 NEEDLE_AIM_POS = Vector3();
	Vector3 NEEDLE_ANGLES = Vector3();
	bool AM_SUMMONED = false;
	string MY_MASTER = "MY_MASTER";
	string DEATH_GOAL = "DEATH_GOAL";

	// Variables declared by included files, with the value they start with in this script
	SwampTube()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void SwampTube_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";

		ANIM_ATTACK = "qkfire"; // frame_shoot_needle
	}

	// unnamed block (first think)
	void SwampTube_FirstThink2()
	{
		NPC_GIVE_EXP = 750.0f;

		FREQ_MORTAR = 10.0f;

		NPC_IS_RANGED = true;
		ATTACK_RANGE = 2048.0f;
		ATTACK_HITRANGE = 2048.0f;
		ATTACK_MOVERANGE = 768.0f;
		MOVE_RANGE = "768";
		NPC_ALT_SOUND_DEATH = "monsters/tube/die1.wav";
	}

	// game_damaged
	string SwampTube_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		PlayRandomSound(1, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);

		if (HealthOf(ENT_ME) < HALF_HP && GameTime() > NEXT_CUST_FLINCH)
		{
			NEXT_CUST_FLINCH = GameTime() + 10.0f;
			OnNpcatkSuspendAi("1.5");
			PlaySound(2, 10, SOUND_PAIN);
			PlayAnim("critical", ANIM_CUSTOM_FLINCH);
		}
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
		int rndDeath = RandomInt(1, 3);
		if (rndDeath == 1)
			NPC_ALT_SOUND_DEATH = SOUND_DEATH1;
		if (rndDeath == 2)
			NPC_ALT_SOUND_DEATH = SOUND_DEATH2;
		if (rndDeath == 3)
			NPC_ALT_SOUND_DEATH = SOUND_DEATH3;

		if (!AM_SUMMONED)
			return;
		CallExternal(MY_MASTER, "ext_tube_died");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		AM_SUMMONED = true;
		MY_MASTER = creatorValue1;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Oodle-Beak");
		SetRace("wildanimal");
		SetModel("monsters/tube.mdl");
		SetWidth(32);
		SetHeight(64);
		SetHealth(2000);
		SetDamageTaken("fire", 1.5f);
		SetHearingSensitivity(4);
		SetRoam(true);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		CallEventDelayed(2.0f, "finalize_me");
		RUN_STEP = 0.0f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;
		if (NPCATK_TARGET == "unset" && GameTime() > NEXT_IDLE)
		{
			NEXT_IDLE = GameTime() + Random(5, 10);
			int rndIdle = RandomInt(1, 4);
			if (rndIdle >= 1 && rndIdle <= 3)
			{
				PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
				if (rndIdle == 1)
				{
					if (!NPC_IS_TURRET)
						OnNpcatkSuspendRoam(2.0f);
					PlayAnim("critical", "eating#idle");
				}

				if (rndIdle == 2)
				{
					if (!NPC_IS_TURRET)
						OnNpcatkSuspendRoam(2.0f);
					PlayAnim("critical", "eating#hiss");
				}
			}
			if (rndIdle == 4)
			{
				PlayAnim("critical", "mourn");
				if (!NPC_IS_TURRET)
					OnNpcatkSuspendRoam(2.0f);
				PlayRandomSound(0, 10, SOUND_MOURN1, SOUND_MOURN2, SOUND_MOURN3);
			}
		}

		if (NPCATK_TARGET == "unset")
			return;
		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;
		if (I_R_FROZEN)
			return;

		if (GameTime() > NEXT_MORTAR && CanSee("enemy"))
		{
			NEXT_MORTAR = GameTime() + 20.0f; // reset when mortar done
			OnDoMortar();
			exitSub = true;
		}
		if (exitSub)
			return;
		if (NPC_IS_TURRET)
			return;

		if (GameTime() > NEXT_REPOS)
		{
			NEXT_REPOS = GameTime() + 15.0f;
			float lastAttack = AS_ATTACKING + 5.0f;
			if (GameTime() < lastAttack && RangeTo(NPCATK_TARGET) > 128.0f)
			{
				SetMoveSpeed(4);
				OnChickenRun(3.0f);
				CallEventDelayed(3.0f, "normal_speed");
			}
		}

		if (MORTAR_ACTIVE)
			return;
		if (MORTAR_READY)
			return;
		if (!(RangeTo(NPCATK_TARGET) < 128.0f))
			return;
		if (!(GameTime() > NEXT_RETREAT))
			return;
		NEXT_RETREAT = GameTime() + Random(5, 10);
		// manual flee, because regular is being screwy
		OnDoManualFlee();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_VICTORY))
			return;
		NEXT_VICTORY = GameTime() + 15.0f;
		PlayAnim("critical", "mourn");
		if (!NPC_IS_TURRET)
			OnNpcatkSuspendRoam(2.0f);
		PlayRandomSound(0, 10, SOUND_MOURN1, SOUND_MOURN2, SOUND_MOURN3);
		DID_ALERT = false;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SwampTube_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_ALERT)
			return;
		if (!NPC_IS_TURRET)
			OnNpcatkSuspendRoam(2.0f);
		SetMoveDest(NPCATK_TARGET, 9999);
		DID_ALERT = true;

		NEXT_REPOS = GameTime() + 15.0f;

		if (!NPC_IS_TURRET)
			NEXT_MORTAR = GameTime() + FREQ_MORTAR;

		if (Float(GetVar("G_ALERT_CYCLE")) == 1.0f)
		{
			PlayAnim("critical", ANIM_ALERT);
			PlaySound(0, 10, SOUND_ALERT1);
		}

		if (Float(GetVar("G_ALERT_CYCLE")) == 2.0f)
		{
			PlayAnim("critical", "dropped");
			PlaySound(0, 10, SOUND_ALERT2);
		}

		if (Float(GetVar("G_ALERT_CYCLE")) == 3.0f)
		{
			PlayAnim("critical", "mourn");
			PlayRandomSound(0, 10, SOUND_MOURN1, SOUND_MOURN2, SOUND_MOURN3);
		}

		if (Float(GetVar("G_ALERT_CYCLE")) == 3.0f)
			SetGlobal("G_ALERT_CYCLE", 0);
	}

	// finalize_me
	void OnFinalizeMe()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// normal_speed
	void OnNormalSpeed()
	{
		SetMoveSpeed(1);
	}

	// do_manual_flee
	void OnDoManualFlee()
	{
		OnNpcatkSuspendAi("3.0");
		SetMoveDest(NPCATK_TARGET, 1024, "flee");
		SetMoveSpeed(4);
		CallEventDelayed(3.0f, "end_manual_flee");
	}

	// end_manual_flee
	void OnEndManualFlee()
	{
		OnNpcatkResumeAi();
		SetMoveSpeed(1);
	}

	// npc_set_turret
	void OnNpcSetTurret()
	{
		FREQ_MORTAR = 5.0f;
	}

	// frame_step
	void OnFrameStep()
	{
		RUN_STEP += 1.0f;
		if (RUN_STEP == 1.0f)
		{
			PlaySound(0, 5, "monsters/tube/Tube_Footstep_Left1.wav");
		}
		else
		{
			PlaySound(0, 5, "monsters/tube/Tube_Footstep_Right1.wav");
			RUN_STEP = 0.0f;
		}
	}

	// npc_heard_player
	void OnNpcHeardPlayer()
	{
		if (NPCATK_TARGET != "unset")
			return;
		if (!(GameTime() > NEXT_HEARD_ALERT))
			return;
		NEXT_HEARD_ALERT = GameTime() + 10.0f;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// do_mortar
	void OnDoMortar()
	{
		DebugPrint("do_mortar");
		MORTAR_READY = true;
		PlaySound(0, 10, "monsters/tube/Tube_Arming.wav");
		OnNpcatkSuspendAi("3.0");
		PlayAnim("critical", ANIM_MORTAR_READY);
		SetMoveDest(NPCATK_TARGET, 9999);
		CallEventDelayed(1.0f, "do_mortar2");
	}

	// do_mortar2
	void OnDoMortar2()
	{
		OnNpcatkSuspendMovement(ANIM_MORTAR);
		PlayAnim("critical", ANIM_MORTAR);
		MORTAR_ANG = AnglesOf(ENT_ME).y - 30.0f;
		if (MORTAR_ANG < 0.0f)
			MORTAR_ANG += 359.0f;
		MORTAR_ACTIVE = true;
		CallEventDelayed(2.0f, "mortar_end");
		OnMortarLoop();
	}

	// mortar_loop
	void OnMortarLoop()
	{
		if (!MORTAR_ACTIVE)
			return;
		CallEventDelayed(0.1f, "mortar_loop");
		MORTAR_ANG += 2.0f;
		if (MORTAR_ANG > 359.0f)
			MORTAR_ANG -= 359.0f;
		Vector3 facePos = MyOrigin() + RelativePosition(Vector3(0, MORTAR_ANG, 0), Vector3(0, 500, 0));
		SetMoveDest(facePos, 9999);
	}

	// mortar_end
	void OnMortarEnd()
	{
		MORTAR_ACTIVE = false;
		MORTAR_READY = false;
		OnNpcatkResumeMovement();
		NEXT_MORTAR = GameTime() + FREQ_MORTAR;
	}

	// frame_shoot_blob
	void OnFrameShootBlob()
	{
		PlaySound(0, 10, "bullchicken/bc_attack2.wav");

		float targDistRatio = RangeTo(NPCATK_TARGET);
		if (targDistRatio > 1200.0f)
			targDistRatio = 1200.0f;
		targDistRatio = Divide(targDistRatio, 1200.0f);
		float attackSpeed = Ratio(targDistRatio, 150, 550) * Random(0.8f, 1.2f);
		float angleAdj = Ratio(targDistRatio, 25, 45);
		SetAngle("add_view.pitch", angleAdj);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_glob_dynamic", RelativePosition(Vector3(-10, 32, 32)), "none", attackSpeed, 0, 0.1f, "none");
	}

	// ext_glob_landed
	// <origin> - from items/proj_glob_dynamic
	void OnExtGlobLanded(string origin = "")
	{
		BLOB_ORG = origin;
		DoDamageEx(origin, 96, DMG_GLOB, 0.2f, ENT_ME, ENT_ME, "none", "acid_effect", "dmgevent:glob");
	}

	// glob_dodamage
	void OnGlobDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		Vector3 targOrg = OriginOf(target);
		float blobDist = Divide(Distance(Vec(BLOB_ORG), targOrg), 64.0f);
		float blobDistRatio = 1.0f - blobDist;
		float blindDuration = Ratio(blobDistRatio, 2, 6); // blind 2-6 seconds based on how direct the hit was
		DebugPrint("glob_dodamage " + Text(blindDuration));
		ApplyEffect(target, "effects/dot_poison_blind", blindDuration, self, DOT_GLOB);
	}

	// frame_aim_needle
	void OnFrameAimNeedle()
	{
		NEEDLE_AIM_POS = OriginOf(NPCATK_TARGET);
	}

	// frame_shoot_needle
	void OnFrameShootNeedle()
	{
		NEEDLE_AIM_POS = OriginOf(NPCATK_TARGET);
		PlaySound(0, 10, SOUND_SHOOT);
		Vector3 traceStart = AttachmentPositionOf(ENT_ME, 0);
		Vector3 traceEnd = NEEDLE_AIM_POS;
		NEEDLE_ANGLES = Angles3DTo(traceStart, NEEDLE_AIM_POS);
		NEEDLE_ANGLES.x = -NEEDLE_ANGLES.x;
		ClientEvent("new", "all", "monsters/swamp_tube_cl", IndexOf(ENT_ME), NEEDLE_ANGLES);
		CallEventDelayed(0.1f, "do_needle_damage");
	}

	// do_needle_damage
	void OnDoNeedleDamage()
	{
		Vector3 traceStart = AttachmentPositionOf(ENT_ME, 0);
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(NEEDLE_ANGLES, Vector3(0, 2048, 0)));

		DoDamageEx(traceStart, traceEnd, DMG_NEEDLE, "100%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:needle");
	}

	// needle_dodamage
	void OnNeedleDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		NEXT_REPOS = GameTime() + 15.0f;
	}

	// ext_mommy_died
	void OnExtMommyDied(string deathPosition = "")
	{
		if (!AM_SUMMONED)
			return;
		OnNpcatkSuspendAi();
		DEATH_GOAL = deathPosition;
		SetMoveSpeed(3);
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

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("monsters/tube.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SwampTube_FirstThink();
		SwampTube_FirstThink2();
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
		if (name == "do_manual_flee") { OnDoManualFlee(); return true; }
		if (name == "do_mortar") { OnDoMortar(); return true; }
		if (name == "do_mortar2") { OnDoMortar2(); return true; }
		if (name == "do_needle_damage") { OnDoNeedleDamage(); return true; }
		if (name == "end_manual_flee") { OnEndManualFlee(); return true; }
		if (name == "ext_glob_landed") { OnExtGlobLanded(Param(params, 0)); return true; }
		if (name == "ext_mommy_died") { OnExtMommyDied(Param(params, 0)); return true; }
		if (name == "finalize_me") { OnFinalizeMe(); return true; }
		if (name == "frame_aim_needle") { OnFrameAimNeedle(); return true; }
		if (name == "frame_shoot_blob") { OnFrameShootBlob(); return true; }
		if (name == "frame_shoot_needle") { OnFrameShootNeedle(); return true; }
		if (name == "frame_step") { OnFrameStep(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "glob_dodamage") { OnGlobDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "mortar_end") { OnMortarEnd(); return true; }
		if (name == "mortar_loop") { OnMortarLoop(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "needle_dodamage") { OnNeedleDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "normal_speed") { OnNormalSpeed(); return true; }
		if (name == "npc_heard_player") { OnNpcHeardPlayer(); return true; }
		if (name == "npc_set_turret") { OnNpcSetTurret(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
