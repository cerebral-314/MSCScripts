#pragma context server

// Converted from monsters/dwarf_zombie_bloat.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/dwarf_zombie_bloat"]
class DwarfZombieBloat : BaseMonsterNewScript
{
	// Constants
	string ANIM_PUKE = "anim_puke";
	string ANIM_EXPLODE = "anim_death";
	float FREQ_PUKE = 0.0f;
	float FREQ_SPIT = 0.0f;
	int PUKE_RANGE = 256;
	int RAD_EXPLODE = 300;
	string SOUND_PUKE = "monsters/mummy/c_mummycom_bat1.wav";
	string SOUND_DEATH1 = "agrunt/ag_die5.wav";
	string SOUND_DEATH2 = "agrunt/ag_die4.wav";
	string SOUND_DEATH3 = "agrunt/ag_die3.wav";
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLYPAIN1 = "agrunt/ag_pain4.wav";
	string SOUND_HOLYPAIN2 = "agrunt/ag_die3.wav";
	int DMG_PROJECTILE = 300;
	int DOT_PUKE = 100;
	string DMG_SWIPE = "100";
	int DMG_EXPLODE = 2000;
	string SOUND_SPIT1 = "bullchicken/bc_attack2.wav";
	string SOUND_SPIT2 = "bullchicken/bc_attack3.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACKHIT1 = "zombie/claw_strike1.wav";
	string SOUND_ATTACKHIT2 = "zombie/claw_strike2.wav";
	string SOUND_ATTACKHIT3 = "zombie/claw_strike3.wav";
	string SOUND_IDLE1 = "agrunt/ag_idle2.wav";
	string SOUND_IDLE2 = "agrunt/ag_alert3.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle5.wav";
	string SOUND_STRUCK1 = "debris/flesh2.wav";
	string SOUND_STRUCK2 = "debris/flesh5.wav";
	string SOUND_STRUCK3 = "debris/flesh7.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain2.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain3.wav";
	string SOUND_PAIN3 = "agrunt/ag_pain5.wav";
	string SOUND_ALERT = "agrunt/ag_alert2.wav";

	// Variables (an unset .script variable reads as its own name)
	float MSC_PUSH_RESIST = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool I_AM_TURNABLE = false;
	int LIGHT_SIZE = 0;
	float NEXT_SPIT = 0.0f;
	float NEXT_PUKE = 0.0f;
	string MY_LIGHT_IDX = "MY_LIGHT_IDX";
	float NEXT_LIGHT = 0.0f;
	int DID_INTRO = 0;
	float NEXT_CONFUSED = 0.0f;
	float NEXT_IDLE_SOUND = 0.0f;
	bool DO_PROJECTILE = false;
	bool AM_PUKING = false;
	string PUKE_SCRIPT_IDX = "PUKE_SCRIPT_IDX";
	Vector3 DRIFT_ANG = Vector3();
	Vector3 MY_HEAD_POS = Vector3();
	Vector3 MY_PUKE_POS = Vector3();
	string PUKE_TARGS = "PUKE_TARGS";
	bool DID_FAKE_DEATH = false;
	bool AM_EXPLODING = false;
	float NEXT_ALLY_ALERT = 0.0f;
	CBaseEntity@ NEW_ALLY_TARGET = null;
	string NEARBY_ALLIES = "NEARBY_ALLIES";

	// Variables declared by included files, with the value they start with in this script
	DwarfZombieBloat()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle";
		ANIM_DEATH = "none";
		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 120.0f;
	}

	// unnamed block (first think)
	void DwarfZombieBloat_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle";
		ANIM_DEATH = "none"; // custom

		MSC_PUSH_RESIST = 0.25f; // "weighted"

		NPC_GIVE_EXP = 400.0f;

		ANIM_ATTACK = "attack"; // frame_attack

		ATTACK_RANGE = 90.0f;
		ATTACK_HITRANGE = 120.0f;

		I_AM_TURNABLE = true;
	}

	// explode_dodamage
	string DwarfZombieBloat_OnExplodeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		ApplyEffect(target, "effects/dot_poison_blind", 8.0f, self, DOT_PUKE);
		if (!(GameTime() > NEXT_ALLY_ALERT))
			return result;
		OnSetAllyTargets(target);
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string DwarfZombieBloat_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		int doPain = 0;
		string result = "";

		if (!Contains(damageType, "effect"))
			doPain = RandomInt(1, 3);

		if (doPain == 1)
		{
			float rndSnd = Random(1, 3);
			if (rndSnd == 1.0f)
				PlaySound(0, 10, SOUND_PAIN1, 0.5f, RandomInt(50, 75));
			if (rndSnd == 2.0f)
				PlaySound(0, 10, SOUND_PAIN2, 0.5f, RandomInt(50, 75));
			if (rndSnd == 3.0f)
				PlaySound(0, 10, SOUND_PAIN3, 0.5f, RandomInt(50, 75));
		}
		else
		{
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		}
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		if (DID_FAKE_DEATH)
			return;
		DID_FAKE_DEATH = true;

		// reinit light for sequence
		ClientEvent("update", "all", MY_LIGHT_IDX, "remove_light");
		ClientEvent("new", "all", "monsters/dwarf_zombie_bloat_light_cl", IndexOf(ENT_ME), Vector3(0, 255, 0), LIGHT_SIZE, 30.0f);
		MY_LIGHT_IDX = LastClientScriptId();

		if (AM_PUKING)
		{
			// cancel puke sequence
			ClientEvent("update", "all", PUKE_SCRIPT_IDX, "end_puke");
			PlaySound(2, 0, SOUND_PUKE);
		}

		ClearEffects();
		SetAlive(true);
		SetInvincible(true);
		OnNpcatkSuspendMovement(ANIM_EXPLODE);
		OnNpcatkSuspendAi();
		PlayAnim("critical", ANIM_EXPLODE);
		PlaySound(0, 10, SOUND_DEATH1, 0.8f, 75);
		DID_FAKE_DEATH = true;
		AM_EXPLODING = true;
		CallEventDelayed(0.1f, "light_flicker");
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
		LIGHT_SIZE = 64;
		ClientEvent("new", "all", "monsters/dwarf_zombie_bloat_light_cl", IndexOf(ENT_ME), Vector3(0, 255, 0), LIGHT_SIZE, 30.0f);
		MY_LIGHT_IDX = LastClientScriptId();
		NEXT_LIGHT = GameTime() + 15.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Bloated Dwarven Zombie");

		SetModel("monsters/dwarf_bloat.mdl");
		SetWidth(48);
		SetHeight(96);

		SetRace("undead");
		SetBlood("green");
		SetHealth(2000);
		SetRoam(true);
		SetHearingSensitivity(5);

		SetDamageTaken("poison", 0);
		IS_BLOODLESS = true;

		// slightly different resistance than standard undead
		SetDamageTaken("pierce", 1.5f);
		SetDamageTaken("blunt", 0.75f);
		SetDamageTaken("holy", 2.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("lightning", 1);
		SetDamageTaken("acid", 0.75f);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		LIGHT_SIZE = 64;

		NEXT_SPIT = GameTime() + FREQ_SPIT;
		NEXT_PUKE = GameTime() + FREQ_PUKE;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;

		if (AM_EXPLODING)
			return;
		if (!IsAlive(ENT_ME))
			return;

		float gameTime = GameTime();

		if (gameTime > NEXT_LIGHT)
		{
			ClientEvent("new", "all", "monsters/dwarf_zombie_bloat_light_cl", IndexOf(ENT_ME), Vector3(0, 255, 0), LIGHT_SIZE, 15.0f);
			MY_LIGHT_IDX = LastClientScriptId();
			NEXT_LIGHT = gameTime + 15.0f;
		}

		if (SUSPEND_AI)
			return;
		if (AM_PUKING)
			return;

		if (gameTime > NEXT_IDLE_SOUND)
		{
			NEXT_IDLE_SOUND = gameTime + Random(5, 15);
			int rndSound = RandomInt(1, 3);
			if (rndSound == 1)
				PlaySound(0, 10, SOUND_IDLE1, 0.8f, 75);
			if (rndSound == 2)
				PlaySound(0, 10, SOUND_IDLE2, 0.8f, 75);
			if (rndSound == 3)
				PlaySound(0, 10, SOUND_IDLE3, 0.8f, 75);
		}

		if (NPCATK_TARGET == "none")
			return;

		if (gameTime > NEXT_SPIT && RangeTo(NPCATK_TARGET) > 256.0f && NPC_CANSEE_TARGET)
		{
			DO_PROJECTILE = true;
			NEXT_SPIT = gameTime + FREQ_SPIT;
			AS_ATTACKING = GameTime() + 5.0f;
			PlayAnim("once", ANIM_ATTACK);
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!(RangeTo(NPCATK_TARGET) < 256.0f))
			return;
		if (!(gameTime > NEXT_PUKE))
			return;
		NEXT_PUKE = gameTime + FREQ_PUKE;
		AS_ATTACKING = GameTime() + 15.0f;
		OnDoPuke();
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_CONFUSED))
			return;
		NEXT_CONFUSED = GameTime() + 20.0f;
		PlayAnim("critical", ANIM_IDLE);
		PlaySound(0, 10, SOUND_IDLE1, 0.8f, 75);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_CONFUSED))
			return;
		NEXT_CONFUSED = GameTime() + 20.0f;
		PlayAnim("critical", ANIM_IDLE);
		PlaySound(0, 10, SOUND_IDLE2, 0.8f, 75);
		DID_INTRO = 0;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, DwarfZombieBloat_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		PlayAnim("critical", ANIM_IDLE);
		PlaySound(0, 10, SOUND_ALERT, 0.8f, 75);

		NEXT_SPIT = GameTime() + FREQ_SPIT;
		NEXT_PUKE = GameTime() + FREQ_PUKE;

		// restart light
		LIGHT_SIZE = 64;
		ClientEvent("update", "all", MY_LIGHT_IDX, "remove_light");
		ClientEvent("new", "all", "monsters/dwarf_zombie_bloat_light_cl", IndexOf(ENT_ME), Vector3(0, 255, 0), LIGHT_SIZE, 30.0f);
		MY_LIGHT_IDX = LastClientScriptId();
		NEXT_LIGHT = GameTime() + 15.0f;
	}

	// frame_attack
	void OnFrameAttack()
	{
		if (DO_PROJECTILE)
		{
			PlayRandomSound(0, 10, SOUND_SPIT1, SOUND_SPIT2);
			DO_PROJECTILE = false;
			PlaySound(0);
			TossProjectile("proj_poison_spit2", AttachmentPositionOf(ENT_ME, 0), NPCATK_TARGET, 250, DMG_PROJECTILE, 2, "none");
			Effect("glow", ENT_LASTPROJECTILE, Vector3(0, 255, 0), 64, -1, 0);
		}
		else
		{
			DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, "80%", ENT_ME, ENT_ME, "none", "blunt", "dmgevent:swipe");
		}
	}

	// swipe_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) DmgType DmgAmt
	void OnSwipeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_ATTACKHIT1, SOUND_ATTACKHIT2, SOUND_ATTACKHIT3);
			AddVelocity(NPCATK_TARGET, Vector3(-25, 150, 110));
		}
		else
		{
			PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		}
	}

	// do_puke
	void OnDoPuke()
	{
		AM_PUKING = true;
		OnNpcatkSuspendAi();
		CAN_FLINCH = "0";
		OnNpcatkSuspendMovement(ANIM_PUKE);
		PlayAnim("critical", ANIM_PUKE);
		PlaySound(2, 10, SOUND_PUKE, 0.8f, 85);
		LIGHT_SIZE = PUKE_RANGE;
		ClientEvent("update", "all", MY_LIGHT_IDX, "light_grow", PUKE_RANGE, 0.5f);
	}

	// frame_puke_start
	void OnFramePukeStart()
	{
		ClientEvent("new", "all", "monsters/dwarf_zombie_bloat_cl", IndexOf(ENT_ME));
		PUKE_SCRIPT_IDX = LastClientScriptId();
		DRIFT_ANG = AnglesOf(ENT_ME);
		OnPukeScanLoop();
	}

	// puke_scan_loop
	void OnPukeScanLoop()
	{
		if (!AM_PUKING)
			return;
		CallEventDelayed(0.25f, "puke_scan_loop");
		DRIFT_ANG = AnglesOf(ENT_ME);
		MY_HEAD_POS = AttachmentPositionOf(ENT_ME, 0);
		MY_PUKE_POS = AttachmentPositionOf(ENT_ME, 1);
		PUKE_TARGS = FindInSphere("enemy", PUKE_RANGE);
		if (PUKE_TARGS == "none")
			return;
		int count = GetTokenCount(PUKE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPukeAffectTargets();
		}
	}

	// puke_affect_targets
	void OnPukeAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(PUKE_TARGS, loopIteration));
		Vector3 curTargOrg = OriginOf(curTarg);
		if (!WithinCone2D(curTargOrg, MY_HEAD_POS, DRIFT_ANG, 30))
			return;
		// check if blocked
		Vector3 traceStart = MY_HEAD_POS;
		string traceEnd = Text(curTargOrg);
		string traceLine = LegacyFunction("get_traceline", MY_HEAD_POS, curTargOrg, "worldonly");
		if (traceLine != traceEnd)
			return;
		ApplyEffect(curTarg, "effects/dot_poison_blind", 5.0f, self, DOT_PUKE);

		if (!(GameTime() > NEXT_ALLY_ALERT))
			return;
		OnSetAllyTargets(curTarg);
	}

	// frame_puke_finish
	// switched this in favor of a system where puke angles are determined by two attachments
	// { frame_puke_drift_left
	// dbg anim.current_frame
	// clientevent update all PUKE_SCRIPT_IDX ext_drift_left
	// setvard PUKE_DRIFT_DIR -1
	// }
	// { frame_puke_drift_right
	// dbg anim.current_frame
	// clientevent update all PUKE_SCRIPT_IDX ext_drift_right
	// setvard PUKE_DRIFT_DIR 1
	// }
	void OnFramePukeFinish()
	{
		ClientEvent("update", "all", PUKE_SCRIPT_IDX, "end_puke");
		AM_PUKING = false;
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();

		LIGHT_SIZE = 64;
		ClientEvent("update", "all", MY_LIGHT_IDX, "light_shrink", 64, 1);
	}

	// light_flicker
	void OnLightFlicker()
	{
		ClientEvent("update", "all", MY_LIGHT_IDX, "light_flicker");
	}

	// frame_death_buckle1
	void OnFrameDeathBuckle1()
	{
		// gurgle sound, flicker light
		PlaySound(0, 10, SOUND_DEATH2, 0.8f, 75);
		ClientEvent("update", "all", MY_LIGHT_IDX, "light_grow", 512, 2);
	}

	// frame_death_buckle2
	void OnFrameDeathBuckle2()
	{
		// gurgle sound, light grows to 512
		PlaySound(0, 10, SOUND_DEATH3, 0.8f, 75);
		LIGHT_SIZE = 512;
	}

	// frame_death_explode
	void OnFrameDeathExplode()
	{
		// explode here
		ClientEvent("new", "all", "effects/sfx_acid_splash", OriginOf(ENT_ME), 512);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), RAD_EXPLODE, DMG_EXPLODE, 0.1f, ENT_ME, ENT_ME, "none", "poison_effect", "dmgevent:explode");
	}

	string OnExplodeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return DwarfZombieBloat_OnExplodeDodamage(hit, target, start, end, damageType, damageText); } // explode_dodamage

	// frame_death_done
	void OnFrameDeathDone()
	{
		SetInvincible(false);
		SetOrigin(ENT_ME, Vector3(20000, -20000, 20000));
		OnNpcSuicide();
	}

	// set_ally_targets
	// <target>
	void OnSetAllyTargets(CBaseEntity@ target = null)
	{
		// causes all enemies to target first guy puked on
		NEXT_ALLY_ALERT = GameTime() + 15.0f;

		@NEW_ALLY_TARGET = target;
		NEARBY_ALLIES = FindInSphere("ally", 1024);
		if (NEARBY_ALLIES == "none")
			return;
		int count = GetTokenCount(NEARBY_ALLIES);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSetAlliesTargetLoop();
		}
	}

	// set_allies_target_loop
	void OnSetAlliesTargetLoop()
	{
		CBaseEntity@ curAlly = FindEntity(GetToken(NEARBY_ALLIES, loopIteration));
		CallExternal(curAlly, "npcatk_settarget", @NEW_ALLY_TARGET);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("bloodspray.spr");
		Precache("monsters/dwarf_bloat.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfZombieBloat_FirstThink();
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
		if (name == "do_puke") { OnDoPuke(); return true; }
		if (name == "explode_dodamage") { Return(OnExplodeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "frame_death_buckle1") { OnFrameDeathBuckle1(); return true; }
		if (name == "frame_death_buckle2") { OnFrameDeathBuckle2(); return true; }
		if (name == "frame_death_done") { OnFrameDeathDone(); return true; }
		if (name == "frame_death_explode") { OnFrameDeathExplode(); return true; }
		if (name == "frame_puke_finish") { OnFramePukeFinish(); return true; }
		if (name == "frame_puke_start") { OnFramePukeStart(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "light_flicker") { OnLightFlicker(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "puke_affect_targets") { OnPukeAffectTargets(); return true; }
		if (name == "puke_scan_loop") { OnPukeScanLoop(); return true; }
		if (name == "set_allies_target_loop") { OnSetAlliesTargetLoop(); return true; }
		if (name == "set_ally_targets") { OnSetAllyTargets(EntityParam(params, 0)); return true; }
		if (name == "swipe_dodamage") { OnSwipeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
