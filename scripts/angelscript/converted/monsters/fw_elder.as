#pragma context server

// Converted from monsters/fw_elder.script by msc_transpiler.
// Kharaztorant Elders
// - Very difficult to solo due to repelling attacks, but easy to take as a team due to no retaliate
// Red - Shoots guided fireball
// Blue - Shoots freezing sphere (+dmg)
// Green - Tri-shots of dizzying poison
// Yellow - Repulse Lightning
// Gray - Spinning knives force use of ranged attacks
// - I didnt finish the gray one, decided to move on, may comeback later

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/fw_elder"]
class FwElder : BaseMonsterNewScript
{
	// Constants
	int ATTACK_RANGE_MELEE = 50;
	int ATTACK_RANGE_PROJ = 512;
	float CL_RESET_FREQ = 5.0f;
	Vector3 REPEL_BEAM_VEL = Vector3();
	int MAX_BEAM_RANGE = 800;
	int BEAM_IDLE_VOL = 4;
	int DMG_FIRE_BOLT = 80;
	int DMG_POISON_BOLT = 50;
	float DOT_POISON = 20.0f;
	float DOT_FIRE = 40.0f;
	int DOT_COLD = 20;
	float DOT_SHOCK = 30.0f;
	int DMG_KNIFE = 75;
	int DMG_REPEL_BEAM = 10;
	string ANIM_WALK_NORM = "walk2handed";
	string ANIM_RUN_NORM = "run2";
	string ANIM_IDLE_NORM = "idle";
	string ANIM_HOP = "jump";
	string ANIM_JUMP = "long_jump";
	string ANIM_CRAWL = "crawl";
	string ANIM_IDLE_CRAWL = "crouch_idle";
	string ANIM_ATTACK_NORM = "ref_shoot_knife";
	string ANIM_ATTACK_CRAWL = "crouch_shoot_knife";
	string ANIM_SEARCH = "look_idle";
	string ANIM_CAST_NORM = "ref_shoot_onehanded";
	string ANIM_CAST_CRAWL = "crouch_shoot_onehanded";
	string ANIM_DEATH1 = "die_simple";
	string ANIM_DEATH2 = "die_backwards1";
	string ANIM_DEATH3 = "die_backwards";
	string ANIM_DEATH4 = "die_forwards";
	string ANIM_DEATH5 = "headshot";
	string ANIM_DEATH6 = "die_spin";
	string ANIM_DEATH7 = "gutshot";
	float FREQ_IDLE = 0.0f;
	string ATTACK_HITCHANCE = "80";
	string SOUND_JUMP1 = "voices/phlame/vs_ndrawlm_atk1.wav";
	string SOUND_JUMP2 = "voices/phlame/vs_ndrawlm_atk2.wav";
	string SOUND_JUMP3 = "voices/phlame/vs_ndrawlm_atk3.wav";
	string SOUND_SWING = "weapons/swingsmall.wav";
	string SOUND_THROW = "zombie/claw_miss1.wav";
	string SOUND_DRAW = "weapons/dagger/dagger2.wav";
	string SOUND_PARRY = "weapons/dagger/daggermetal2.wav";
	string SOUND_PAIN1 = "voices/phlame/vs_nkarlatm_hit1.wav";
	string SOUND_PAIN2 = "voices/phlame/vs_nkarlatm_hit2.wav";
	string SOUND_PAIN3 = "voices/phlame/vs_nkarlatm_hit3.wav";
	string SOUND_DEATH1 = "voices/phlame/vs_nkarlatm_dead.wav";
	string SOUND_DEATH2 = "voices/phlame/vs_nkarlatm_hit3.wav";
	string SOUND_ALERT1 = "voices/phlame/vs_nkarlatm_attk.wav";
	string SOUND_ALERT2 = "voices/phlame/vs_nkarlatm_bat1.wav";
	string SOUND_ALERT3 = "voices/phlame/vs_nkarlatm_help.wav";
	string SOUND_IDLE = "voices/phlame/vs_nkarlatm_haha.wav";
	string SOUND_WARCRY1 = "voices/phlame/vs_nkarlatm_bat2.wav";
	string SOUND_WARCRY2 = "voices/phlame/vs_nkarlatm_bat3.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_ACID1 = "bullchicken/bc_attack1.wav";
	string SOUND_ACID2 = "bullchicken/bc_attack2.wav";
	string SOUND_ACID3 = "bullchicken/bc_attack3.wav";
	string SOUND_LOST_SIGHT1 = "voices/phlame/vs_nkarlatm_attk.wav";
	string SOUND_LOST_SIGHT2 = "voices/phlame/vs_nkarlatm_bat1.wav";
	string SOUND_LOST_SIGHT3 = "voices/phlame/vs_nkarlatm_bat2.wav";
	string SOUND_LOST_SIGHT4 = "voices/phlame/vs_nkarlatm_bat3.wav";
	string SOUND_LOST_SIGHT5 = "voices/phlame/vs_nkarlatm_warn.wav";
	string SOUND_VICTORY1 = "voices/phlame/vs_nkarlatm_vict.wav";
	string SOUND_BURN = "ambience/steamburst1.wav";
	string SOUND_POISON = "bullchicken/bc_bite2.wav";
	string SOUND_FREEZE = "magic/frost_forward.wav";
	string SOUND_SHOCK = "debris/zap1.wav";
	string SOUND_BEAM_LOOP = "magic/bolt_loop.wav";
	string SOUND_BEAM_ACTIVATE = "magic/bolt_start.wav";
	string SOUND_BEAM_SHOOT = "magic/bolt_end.wav";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	string SOUND_SPELL_POISON = "bullchicken/bc_attack3.wav";
	string SOUND_SPELL_COLD = "magic/frost_reverse.wav";

	// Variables (an unset .script variable reads as its own name)
	int PASS_FREEZE_DMG = 0;
	float PASS_FREEZE_DUR = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float CUR_BOLT = 0.0f;
	int OVERRIDE_TYPE = 0;
	int RND_ELDER_TYPE = 0;
	int JUMP_AWAY_CHANCE = 0;
	bool DRAW_ON_SIGHT = false;
	string ELDER_TYPE = "ELDER_TYPE";
	int WEAPON_IDX = 0;
	float FREQ_SPELL = 0.0f;
	string EFFECT_SCRIPT = "EFFECT_SCRIPT";
	string EFFECT_DUR = "EFFECT_DUR";
	float EFFECT_DMG = 0.0f;
	string SOUND_EFFECT = "SOUND_EFFECT";
	bool BLADE_DRAWN = false;
	float NEXT_LEAP = 0.0f;
	float NEXT_APPLYEFFECT_SOUND = 0.0f;
	bool BLADE_ATTACK = false;
	bool DID_AID_ALERT = false;
	float NEXT_SEARCH = 0.0f;
	bool DID_WARCRY = false;
	float NEXT_SPELL = 0.0f;
	bool FLEE_CHECK_DELAY = false;
	float G_LAST_VICTORY = 0.0f;

	// unnamed block (first think)
	void FwElder_FirstThink()
	{
		CAN_RETALIATE = "0";
		NPC_RANGED = "1";

		PASS_FREEZE_DMG = 50;
		PASS_FREEZE_DUR = 5.0f;

		// base
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "ref_shoot_knife"; // { event 500 5 "attack_knife" }
		ANIM_DEATH = "die_simple";
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 170.0f;
		ATTACK_MOVERANGE = 512.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 100.0f;
		NPC_GIVE_EXP = 1250.0f; // since they require teamwork
	}

	// unnamed block (timer)
	void FwElder_Timer()
	{
		CallEventDelayed(FREQ_IDLE, "FwElder_Timer");
		// dbg idle sound
		if (NPCATK_TARGET != "unset")
			return;
		AS_ATTACKING = GameTime();
		PlayAnim("once", ANIM_SEARCH);
		PlaySound(0, 10, SOUND_IDLE);
	}

	// game_damaged
	string FwElder_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		PlayRandomSound(2, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);

		if (!(RangeTo(attacker) < 256.0f))
			return result;

		int rnd100 = RandomInt(1, 100);
		DebugPrint(Text(rnd100) + " vs " + Text(JUMP_AWAY_CHANCE));

		if (rnd100 < JUMP_AWAY_CHANCE && GameTime() > NEXT_LEAP)
		{
			NEXT_LEAP = GameTime() + 10.0f;
			DebugPrint("leap away!");
			OnLeapAway(EntityId(attacker));
		}
		return result;
	}

	// game_dodamage
	string FwElder_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (BLADE_ATTACK && ELDER_TYPE != "dark" && RelationshipOf(target, ENT_ME) == "enemy")
		{
			if (GameTime() > NEXT_APPLYEFFECT_SOUND)
			{
				NEXT_APPLYEFFECT_SOUND = GameTime() + Float(EFFECT_DUR);
				PlaySound(0, 10, SOUND_EFFECT);
			}
			ApplyEffect(target, EFFECT_SCRIPT, EFFECT_DUR, self, EFFECT_DMG);
		}
		BLADE_ATTACK = false;
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

		int rndDeath = RandomInt(1, 7);
		if (rndDeath == 1)
			ANIM_DEATH = ANIM_DEATH1;
		if (rndDeath == 2)
			ANIM_DEATH = ANIM_DEATH2;
		if (rndDeath == 3)
			ANIM_DEATH = ANIM_DEATH3;
		if (rndDeath == 4)
			ANIM_DEATH = ANIM_DEATH4;
		if (rndDeath == 5)
			ANIM_DEATH = ANIM_DEATH5;
		if (rndDeath == 6)
			ANIM_DEATH = ANIM_DEATH6;
		if (rndDeath == 7)
			ANIM_DEATH = ANIM_DEATH7;

		PlayRandomSound(0, 10, SOUND_DEATH1, SOUND_DEATH2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Phlame Elder");
		SetModel("monsters/fire_alcolyte.mdl");
		SetModelBody(1, 1);
		SetModelBody(2, 1);
		SetProp(ENT_ME, "skin", 1);
		SetHealth(RandomInt(2000, 4000));
		SetBlood("red");
		CUR_BOLT = 0.0f;

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);

		SetIdleAnim("idle");
		SetMoveAnim("walk2handed");

		SetRace("demon");
		SetWidth(32);
		SetHeight(72);
		SetRoam(true);
		SetHearingSensitivity(4);

		CallEventDelayed(0.01f, "setup_elder");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (NPCATK_TARGET == "unset")
			return;
		if (!NPC_CANSEE_TARGET)
			return;

		if (ELDER_TYPE == "fire" && GameTime() > NEXT_SPELL)
		{
			NEXT_SPELL = GameTime() + FREQ_SPELL;
			OnDoSpell();
		}
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (CanSee("enemy"))
			return;
		if (!(GameTime() > NEXT_SEARCH))
			return;
		NEXT_SEARCH = GameTime() + 20.0f;
		PlayRandomSound(0, 10, SOUND_LOST_SIGHT1, SOUND_LOST_SIGHT2, SOUND_LOST_SIGHT3, SOUND_LOST_SIGHT4, SOUND_LOST_SIGHT5);
		PlayAnim("once", ANIM_SEARCH);
		AS_ATTACKING = GameTime();
	}

	// my_target_died
	// { reset_cl
	// //clientevent remove all CL_IDX
	// setvard NEXT_CL_RESET game.time
	// add NEXT_CL_RESET CL_RESET_FREQ
	// clientevent persist all monsters/k_elder_cl $get(ent_me,index) lightning 1
	// setvard CL_IDX game.script.last_sent_id
	// if LIGHTNING_ON
	// local TARG_HEIGHT $get(NPCATK_TARGET,height)
	// divide TARG_HEIGHT 2
	// clientevent update all CL_IDX beam_on $get(NPCATK_TARGET,index) TARG_HEIGHT
	// dbg Reset CL CL_IDX
	// }
	// {
	// repeatdelay CL_RESET_FREQ
	// if BLADE_DRAWN
	// clientevent update all CL_IDX end_effect
	// callevent 0.1 reset_cl
	// }
	// {
	// repeatdelay CL_RESET_FREQ
	// if BLADE_DRAWN
	// clientevent update all 1 ke_setup $get(ent_me,index) lightning 1 LIGHTNING_ON $get(NPCATK_TARGET,index)
	// }
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DebugPrint("my_target_died");
		if (!(GameTime() > G_LAST_VICTORY))
			return;
		G_LAST_VICTORY = GameTime() + 30.0f;
		PlaySound(0, 10, SOUND_VICTORY1);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, FwElder_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	// called every think cycle target is in melee range
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		if (!BLADE_DRAWN)
			OnDrawBlade();

		if (Truthy(ScriptVarOf(NPCATK_TARGET, "I_R_FROZEN")))
			return;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, FwElder_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		PlayAnim("critical", ANIM_CAST_NORM);
		PlaySound(0, 10, SOUND_PARRY);
	}

	// npc_targetsighted
	// called every think frame a target is seen
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			PlayRandomSound(0, 10, SOUND_WARCRY1, SOUND_WARCRY2);
			if (DRAW_ON_SIGHT)
				CallEventDelayed(0.1f, "draw_blade");
		}
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/k_elder_cl");
	}

	// set_type
	// { game_dynamically_created //for testing, don't intend to summon
	// if ( PARAM1 startswith 'PARAM' ) local EXIT_SUB 1
	// if !EXIT_SUB
	// setvard OVERRIDE_TYPE PARAM1
	// dbg Overriding Type: OVERRIDE_TYPE
	// }
	// for params
	void OnSetType(string arrowScript = "", string bundleSize = "")
	{
		OVERRIDE_TYPE = 2;
	}

	// type_fire
	void OnTypeFire()
	{
		OVERRIDE_TYPE = 2;
	}

	// setup_elder
	void OnSetupElder()
	{
		RND_ELDER_TYPE = 2;

		SetDamageTaken("holy", 0.5f); // lil more evil than the acolyte

		if (RND_ELDER_TYPE == 2)
		{
			JUMP_AWAY_CHANCE = 20;
			DRAW_ON_SIGHT = false;
			ELDER_TYPE = "fire";
			WEAPON_IDX = 2;
			FREQ_SPELL = 1.0f;
			EFFECT_SCRIPT = "effects/dot_poison";
			EFFECT_DUR = "5";
			EFFECT_DMG = DOT_FIRE;
			SOUND_EFFECT = SOUND_BURN;
		}
	}

	// draw_blade
	void OnDrawBlade()
	{
		BLADE_DRAWN = true;
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_CAST_NORM);
		CallEventDelayed(0.2f, "draw_blade2");
	}

	// draw_blade2
	void OnDrawBlade2()
	{
		SetModelBody(2, WEAPON_IDX);
		PlaySound(0, 10, SOUND_DRAW);
	}

	// lknife_sound
	void OnLknifeSound()
	{
		PlaySound(0, 10, SOUND_BEAM_ACTIVATE);
	}

	// leap_away
	void OnLeapAway(string target = "")
	{
		OnNpcatkSuspendAi("1.0");
		SetMoveDest(target, 1024, "flee");
		AS_ATTACKING = GameTime();
		PlayRandomSound(0, 10, SOUND_JUMP1, SOUND_JUMP2, SOUND_JUMP3);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		PlayAnim("critical", ANIM_JUMP);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 75)));
	}

	// attack_knife
	// anim event
	void OnAttackKnife()
	{
		PlaySound(0, 5, SOUND_SWING);
		BLADE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_KNIFE), ATTACK_HITCHANCE, "pierce");
	}

	// npc_aiding_ally
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		// dbg npc_aiding_ally $get(NPC_ALLY_TO_AID,name)
		CallExternal(NPC_ALLY_TO_AID, "being_aided");
	}

	// being_aided
	void OnBeingAided()
	{
		// dbg being_aided
		if (!CanSee(NPCATK_TARGET))
			return;
		if (DID_AID_ALERT)
			return;
		DID_AID_ALERT = true;
		PlayRandomSound(0, 10, SOUND_ALERT1, SOUND_ALERT2, SOUND_ALERT3);
	}

	// do_spell
	void OnDoSpell()
	{
		if (ELDER_TYPE == "fire")
		{
			PlayAnim("critical", ANIM_CAST_NORM);
			CUR_BOLT += 1.0f;
			if (CUR_BOLT == 1.0f)
			{
				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
				TossProjectile("proj_fire_xolt", RelativePosition(Vector3(0, 0, 26)), NPCATK_TARGET, 400, DMG_FIRE_BOLT, 2, "none");
			}
			else
			{
				PlayRandomSound(0, 10, SOUND_ACID1, SOUND_ACID2, SOUND_ACID3);
				TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 0, 26)), NPCATK_TARGET, 400, DMG_FIRE_BOLT, 2, "none");
				CUR_BOLT = 0.0f;
			}
		}
	}

	// reset_flee_check_delay
	void OnResetFleeCheckDelay()
	{
		FLEE_CHECK_DELAY = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fire_alcolyte.mdl");
		CallEventDelayed(FREQ_IDLE, "FwElder_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FwElder_FirstThink();
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
		if (name == "attack_knife") { OnAttackKnife(); return true; }
		if (name == "being_aided") { OnBeingAided(); return true; }
		if (name == "do_spell") { OnDoSpell(); return true; }
		if (name == "draw_blade") { OnDrawBlade(); return true; }
		if (name == "draw_blade2") { OnDrawBlade2(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "lknife_sound") { OnLknifeSound(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_aiding_ally") { OnNpcAidingAlly(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "reset_flee_check_delay") { OnResetFleeCheckDelay(); return true; }
		if (name == "set_type") { OnSetType(Param(params, 0), Param(params, 1)); return true; }
		if (name == "setup_elder") { OnSetupElder(); return true; }
		if (name == "type_fire") { OnTypeFire(); return true; }
		if (name == "FwElder_Timer") { FwElder_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
