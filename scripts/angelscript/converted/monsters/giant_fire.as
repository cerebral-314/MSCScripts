#pragma context server

// Converted from monsters/giant_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_patrol_radius.as"

[script "monsters/giant_fire"]
class GiantFire : BaseMonsterNewScript, BasePatrolRadius
{
	// Constants
	string ANIM_IDLE_AGRO = "creadyl_idle2";
	string ANIM_IDLE_NORM = "creadyr_idle1";
	string ANIM_WARCRY = "ctaunt_alert";
	string ANIM_ATTACK_NORM = "ca1slashl";
	string ANIM_ATTACK_NEAR = "ccloseh_attack";
	string ANIM_ATTACK_FAR = "creach";
	string ANIM_ATTACK_STOMP = "cclosel_stomp";
	string CUSTOM_ANIM_FLINCH = "cdamagel_flinch1";
	int BPATROL_MOVEPROX = 90;
	float FREQ_STOMP = 0.0f;
	float FREQ_REACH_SWING = 0.0f;
	int RANGE_NEAR = 80;
	int RANGE_NORM = 100;
	int RANGE_FAR = 160;
	int RANGE_MAX = 245;
	int ATK_RAD = 196;
	bool NPC_NO_VADJ = true;
	int DMG_SWING = 200;
	int DMG_STOMP = 300;
	int DMG_DOT = 50;
	int DMG_DOT2 = 150;
	string SOUND_WARCRY1 = "monsters/earth/c_elemerth_bat1.wav";
	string SOUND_WARCRY2 = "monsters/earth/c_elemerth_bat2.wav";
	string SOUND_ATTACK1 = "monsters/earth/c_elemerth_atk1.wav";
	string SOUND_ATTACK2 = "monsters/earth/c_elemerth_atk2.wav";
	string SOUND_ATTACK3 = "monsters/earth/c_elemerth_atk3.wav";
	string SOUND_SWING = "weapons/swinghuge.wav";
	string SOUND_STOMP = "monsters/earth/c_elemerth_slct.wav";
	string SOUND_STRUCK1 = "weapons/axemetal1.wav";
	string SOUND_STRUCK2 = "weapons/axemetal2.wav";
	string SOUND_STRUCK3 = "debris/concrete1.wav";
	string SOUND_PAIN1 = "monsters/earth/c_elemerth_hit1.wav";
	string SOUND_PAIN2 = "monsters/earth/c_elemerth_hit2.wav";
	int MY_HEIGHT = 256;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float RUN_STEP_COUNT = 0.0f;
	string WEAPON_TYPE = "WEAPON_TYPE";
	float HALF_HP = 0.0f;
	float NEXT_RAGE = 0.0f;
	int DID_INTRO = 0;
	float NEXT_STOMP = 0.0f;
	float NEXT_CL_LIGHT = 0.0f;
	bool DOING_STOMP = false;
	bool DOING_REACH_SWING = false;
	string BPATROL_RAD = "BPATROL_RAD";
	bool BPATROL_ACTIVE = false;
	Vector3 STOMP_POINT = Vector3();
	float NEXT_REACH_SWING = 0.0f;
	float NEXT_CUSTOM_FLINCH = 0.0f;
	bool NERF_PUSH = false;

	// Variables declared by included files, with the value they start with in this script
	GiantFire()
	{
		ANIM_WALK = "cwalk";
		ANIM_IDLE = "creadyr_idle1";
		SOUND_DEATH = "monsters/earth/c_elemerth_dead.wav";
	}

	// unnamed block (first think)
	void GiantFire_FirstThink()
	{
		ANIM_WALK = "cwalk"; // frame_walk_step
		ANIM_IDLE = "creadyr_idle1";
		ANIM_RUN = "crun"; // frame_run_step
		ANIM_ATTACK = "ca1slashl";
		ANIM_DEATH = "ckdbck_death_p1";
	}

	// unnamed block (first think)
	void GiantFire_FirstThink2()
	{
		ATTACK_MOVERANGE = 80.0f;
		MOVE_RANGE = "80";

		NPC_GIVE_EXP = 4000.0f;

		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 320.0f;

		NPC_MUST_SEE_TARGET = "0"; // aoe attacks, doesn't need to see target
	}

	// game_damaged
	string GiantFire_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";
		if (Contains(damageType, "effect")) // no sound for DOT (annoying)
			exitSub = true;
		if (exitSub)
			return result;

		PlayRandomSound(1, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		if (!(HealthOf(ENT_ME) < 0.0f))
			return result;
		if (!(GameTime() > NEXT_CUSTOM_FLINCH))
			return result;
		PlayAnim("critical", "ANIM_CUSTOM_FLINCH");
		PlayRandomSound(2, 10, SOUND_PAIN1, SOUND_PAIN2);
		NEXT_CUSTOM_FLINCH = GameTime() + Random(20, 30);
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BasePatrolRadius_OnNpcSpawn(npc); // monsters/base_patrol_radius
		SetName("Fire Giant Construct");
		SetModel("monsters/giant_fire.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHeight(256);
		SetWidth(125);
		SetHearingSensitivity(4);

		PlayAnim("critical", ANIM_IDLE);

		SetHealth(10000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("holy", 1); // is construct

		SetRace("demon");

		RUN_STEP_COUNT = 0.0f;

		SetRoam(true);

		CallEventDelayed(0.5f, "pick_weapon");

		CallEventDelayed(2.0f, "npc_finalize");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BasePatrolRadius_OnNpcatkHunt(); // monsters/base_patrol_radius

		if (NPCATK_TARGET == "unset")
			SetIdleAnim(ANIM_IDLE_NORM);

		// dbg opatrol BPATROL_OUTSIDE_RANGE
		if (NPCATK_TARGET == "unset")
			return;
		SetIdleAnim(ANIM_IDLE_AGRO);
		float targRange = RangeTo(NPCATK_TARGET);

		if (GameTime() > NEXT_CL_LIGHT)
		{
			ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 128, 0), 128, 30.0f);
			NEXT_CL_LIGHT = GameTime() + 30.0f;
		}

		if (GameTime() > NEXT_STOMP && targRange <= RANGE_NORM)
		{
			ANIM_ATTACK = ANIM_ATTACK_STOMP;
			ATTACK_RANGE = RANGE_NORM;
			ATTACK_HITRANGE = RANGE_NORM;
			DOING_STOMP = true;
		}

		if (targRange > RANGE_FAR && targRange <= RANGE_MAX && GameTime() > NEXT_REACH_SWING)
		{
			ANIM_ATTACK = ANIM_ATTACK_FAR;
			ATTACK_RANGE = RANGE_FAR;
			ATTACK_HITRANGE = RANGE_FAR;
			DOING_REACH_SWING = true;
		}

		if (targRange > RANGE_NEAR && !DOING_REACH_SWING && !DOING_STOMP)
		{
			ANIM_ATTACK = ANIM_ATTACK_NORM;
			ATTACK_RANGE = RANGE_NORM;
			ATTACK_HITRANGE = RANGE_NORM;
		}

		if (targRange <= RANGE_NEAR && !DOING_REACH_SWING && !DOING_STOMP)
		{
			ANIM_ATTACK = ANIM_ATTACK_NEAR;
			ATTACK_RANGE = RANGE_NEAR;
			ATTACK_HITRANGE = RANGE_NEAR;
		}

		ATTACK_HITRANGE += MY_HEIGHT;
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		BasePatrolRadius_OnNpcatkClearTargets(reason); // monsters/base_patrol_radius
		NEXT_RAGE = GameTime() + Random(20, 30);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GiantFire_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	// { npc_post_spawn
	// setvard BPATROL_ACTIVE 1 //*** set zero when done
	// setvard BPATROL_RAD 256 //*** remove when done
	// }
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (DID_INTRO != 0 && GameTime() > NEXT_RAGE)
		{
			SetMoveDest(NPCATK_TARGET, 9999);
			OnNpcatkSuspendAi("1.0");
			PlayAnim("critical", ANIM_WARCRY);
			PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2);
			NEXT_RAGE = GameTime() + Random(120, 240);
		}

		if (DID_INTRO != 0)
			return;

		// if ( $lcase(game.map.name) equals shender_east )
		// {
		// setvard SHENDER_MAP 1
		// callexternal players ext_play_music_me 2.5 phlamesintro.mp3
		// }
		SetMoveDest(NPCATK_TARGET, 9999);
		OnNpcatkSuspendAi("1.0");
		PlayAnim("critical", ANIM_WARCRY);
		PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2);
		NEXT_RAGE = GameTime() + Random(120, 240);

		DID_INTRO = 1;
		NEXT_STOMP = GameTime() + FREQ_STOMP;

		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 128, 0), 128, 30.0f);
	}

	// pick_weapon
	void OnPickWeapon()
	{
		if (WEAPON_TYPE == "WEAPON_TYPE")
		{
			WEAPON_TYPE = RandomInt(0, 2);
			SetModelBody(1, Int(WEAPON_TYPE));
		}
	}

	// set_weapon_dblud
	void OnSetWeaponDblud()
	{
		WEAPON_TYPE = "0";
		SetModelBody(1, Int(WEAPON_TYPE));
	}

	// set_weapon_earthbreak
	void OnSetWeaponEarthbreak()
	{
		WEAPON_TYPE = "1";
		SetModelBody(1, Int(WEAPON_TYPE));
	}

	// set_weapon_firebreak
	void OnSetWeaponFirebreak()
	{
		WEAPON_TYPE = "2";
		SetModelBody(1, Int(WEAPON_TYPE));
	}

	// set_weapon_shockbreak
	void OnSetWeaponShockbreak()
	{
		WEAPON_TYPE = "3";
		SetModelBody(1, Int(WEAPON_TYPE));
	}

	// npc_finalize
	void OnNpcFinalize()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// frame_walk_step
	void OnFrameWalkStep()
	{
		OnFrameRunStep();
	}

	// frame_run_step
	void OnFrameRunStep()
	{
		RUN_STEP_COUNT += 1.0f;
		if (RUN_STEP_COUNT == 1.0f)
			PlaySound(0, 10, "monsters/troll/step1.wav");
		if (RUN_STEP_COUNT == 2.0f)
		{
			PlaySound(0, 10, "monsters/troll/step2.wav");
			RUN_STEP_COUNT = 0.0f;
		}
	}

	// set_patrol
	// <radius> - addparam
	void OnSetPatrol(string radius = "")
	{
		BPATROL_RAD = radius;
		BPATROL_ACTIVE = true;
	}

	// frame_melee_strike
	void OnFrameMeleeStrike()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlaySound(2, 10, SOUND_SWING);
		Vector3 impactPoint = RelativePosition(Vector3(0, RANGE_NORM, 32));
		impactPoint.z = GroundHeight(impactPoint);
		impactPoint.z += 32.0f;
		float dmgSwing = DMG_SWING;
		if (Float(WEAPON_TYPE) == 1.0f)
			dmgSwing *= 1.5f;
		DoDamageEx(impactPoint, ATK_RAD, dmgSwing, 0.1f, ENT_ME, ENT_ME, "none", "dark", "dmgevent:normswing");
	}

	// normswing_dodamage
	void OnNormswingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		float rndLr = Random(-50, -10);
		float rndFb = Random(0, 100);
		Vector3 pushVel = RelativeVelocity(Vector3(rndLr, rndFb, 10));
		if (Float(WEAPON_TYPE) == 0.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT);
		if (Float(WEAPON_TYPE) == 2.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT2);
		if (Float(WEAPON_TYPE) == 3.0f)
			ApplyEffect(target, "effects/dot_lightning", 5, self, DMG_DOT2);
	}

	// frame_melee_strike2
	void OnFrameMeleeStrike2()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlaySound(2, 10, SOUND_SWING);

		Vector3 impactPoint = RelativePosition(Vector3(0, 0, 32));
		impactPoint.z = GroundHeight(impactPoint);
		impactPoint.z += 32.0f;

		float dmgSwing = DMG_SWING;
		if (Float(WEAPON_TYPE) == 1.0f)
			dmgSwing *= 1.5f;

		DoDamageEx(impactPoint, ATK_RAD, dmgSwing, 0.1f, ENT_ME, ENT_ME, "none", "blunt", "dmgevent:closeswing");
	}

	// closeswing_dodamage
	void OnCloseswingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		float rndLr = Random(-50, 50);
		float rndFb = Random(0, 50);
		Vector3 pushVel = RelativeVelocity(Vector3(rndLr, rndFb, 10));
		AddVelocity(target, pushVel);
		if (Float(WEAPON_TYPE) == 0.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT);
		if (Float(WEAPON_TYPE) == 2.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT2);
		if (Float(WEAPON_TYPE) == 3.0f)
			ApplyEffect(target, "effects/dot_lightning", 5, self, DMG_DOT2);
	}

	// frame_stomp
	void OnFrameStomp()
	{
		PlaySound(0, 10, SOUND_STOMP);
		STOMP_POINT = RelativePosition(Vector3(0, RANGE_NORM, 32));
		DoDamageEx(STOMP_POINT, 256, DMG_STOMP, 0.2f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:stomp");
		STOMP_POINT.z = GroundHeight(STOMP_POINT);
		if (Float(WEAPON_TYPE) == 0.0f)
			ClientEvent("new", "all", "effects/sfx_fire_burst", STOMP_POINT, 256, 0, Vector3(255, 0, 0));
		if (Float(WEAPON_TYPE) == 1.0f)
			ClientEvent("new", "all", "effects/sfx_stun_burst", STOMP_POINT, 256, 0, 0);
		if (Float(WEAPON_TYPE) == 2.0f)
			ClientEvent("new", "all", "effects/sfx_fire_burst", STOMP_POINT, 256, 1, Vector3(255, 128, 0));
		if (Float(WEAPON_TYPE) == 3.0f)
			ClientEvent("new", "all", "effects/sfx_shock_burst", STOMP_POINT, 256, 1, Vector3(255, 255, 0));
		NEXT_STOMP = GameTime() + FREQ_STOMP;
		ANIM_ATTACK = ANIM_ATTACK_NORM;
		ATTACK_RANGE = RANGE_NORM;
		ATTACK_HITRANGE = RANGE_NORM;
		DOING_STOMP = false;
	}

	// stomp_dodamage
	void OnStompDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		int exitSub = 0;
		int velFb;

		if (!hit)
			return;

		if (IsPlayer(target) && !IsOnGround(target))
			exitSub = 0;
		if (exitSub != 0)
			return;
		if (Float(WEAPON_TYPE) != 1.0f)
			ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		else
			ApplyEffect(target, "effects/debuff_stun", 10.0f, self);

		if (Float(WEAPON_TYPE) == 0.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT);
		if (Float(WEAPON_TYPE) == 2.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT2);
		if (Float(WEAPON_TYPE) == 3.0f)
			ApplyEffect(target, "effects/dot_lightning", 5, self, DMG_DOT2);

		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = STOMP_POINT;
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		if (NERF_PUSH)
			velFb = 300;
		else
			velFb = 500;
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, velFb, 110)));
	}

	// frame_reach_attack
	void OnFrameReachAttack()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlaySound(2, 10, SOUND_SWING);
		Vector3 impactPoint = RelativePosition(Vector3(0, RANGE_FAR, 32));
		impactPoint.z = GroundHeight(impactPoint);
		impactPoint.z += 32.0f;
		DoDamageEx(impactPoint, ATK_RAD, DMG_SWING, 0.1f, ENT_ME, ENT_ME, "none", "dark", "dmgevent:reachswing");
		string impactPointValue = Text(impactPoint);
		impactPointValue = Text(WithZ(Vec(impactPointValue), GroundHeight(impactPoint)));
		if (Float(WEAPON_TYPE) == 0.0f)
			ClientEvent("new", "all", "effects/sfx_fire_burst", impactPointValue, ATK_RAD, 0, Vector3(255, 0, 0));
		if (Float(WEAPON_TYPE) == 1.0f)
			ClientEvent("new", "all", "effects/sfx_stun_burst", impactPointValue, ATK_RAD, 0, 0);
		if (Float(WEAPON_TYPE) == 2.0f)
			ClientEvent("new", "all", "effects/sfx_fire_burst", impactPointValue, ATK_RAD, 1, Vector3(255, 128, 0));
		if (Float(WEAPON_TYPE) == 3.0f)
			ClientEvent("new", "all", "effects/sfx_shock_burst", impactPointValue, ATK_RAD, 1, Vector3(255, 255, 0));

		NEXT_REACH_SWING = GameTime() + FREQ_REACH_SWING;
		DOING_REACH_SWING = false;
		ANIM_ATTACK = ANIM_ATTACK_NORM;
		ATTACK_RANGE = RANGE_NORM;
		ATTACK_HITRANGE = RANGE_NORM;
	}

	// reachswing_dodamage
	void OnReachswingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		float rndFb = Random(0, -150);
		Vector3 pushVel = RelativeVelocity(Vector3(0, rndFb, 110));
		AddVelocity(target, pushVel);

		if (Float(WEAPON_TYPE) == 0.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT);
		if (Float(WEAPON_TYPE) == 1.0f)
			ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		if (Float(WEAPON_TYPE) == 2.0f)
			ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT2);
		if (Float(WEAPON_TYPE) == 3.0f)
			ApplyEffect(target, "effects/dot_lightning", 5, self, DMG_DOT2);
	}

	// set_nerf_push
	void OnSetNerfPush()
	{
		NERF_PUSH = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BasePatrolRadius_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_patrol_radius
	}

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BasePatrolRadius_OnNpcSelectattack(); // monsters/base_patrol_radius
	}

	// npc_targetvalidate
	void OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		BaseMonsterShared_OnNpcTargetvalidate(target); // monsters/base_monster_shared
		BasePatrolRadius_OnNpcTargetvalidate(target); // monsters/base_patrol_radius
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_fire.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GiantFire_FirstThink();
		GiantFire_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BasePatrolRadius_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "closeswing_dodamage") { OnCloseswingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "frame_melee_strike") { OnFrameMeleeStrike(); return true; }
		if (name == "frame_melee_strike2") { OnFrameMeleeStrike2(); return true; }
		if (name == "frame_reach_attack") { OnFrameReachAttack(); return true; }
		if (name == "frame_run_step") { OnFrameRunStep(); return true; }
		if (name == "frame_stomp") { OnFrameStomp(); return true; }
		if (name == "frame_walk_step") { OnFrameWalkStep(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "normswing_dodamage") { OnNormswingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "npc_finalize") { OnNpcFinalize(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_weapon") { OnPickWeapon(); return true; }
		if (name == "reachswing_dodamage") { OnReachswingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "set_nerf_push") { OnSetNerfPush(); return true; }
		if (name == "set_patrol") { OnSetPatrol(Param(params, 0)); return true; }
		if (name == "set_weapon_dblud") { OnSetWeaponDblud(); return true; }
		if (name == "set_weapon_earthbreak") { OnSetWeaponEarthbreak(); return true; }
		if (name == "set_weapon_firebreak") { OnSetWeaponFirebreak(); return true; }
		if (name == "set_weapon_shockbreak") { OnSetWeaponShockbreak(); return true; }
		if (name == "stomp_dodamage") { OnStompDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BasePatrolRadius_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
