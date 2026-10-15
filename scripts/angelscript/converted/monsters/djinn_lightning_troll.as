#pragma context server

// Converted from monsters/djinn_lightning_troll.script by msc_transpiler.
// This is based on an older script and may have some bad conventions as a result.
// Yet another lightning Djinn by Thothie from monsters/troll_lobber
// - Tosses lightning balls with AOE, and guided lightning spheres
// - Chance of lightning DOT on strike
// - (Needs new skin and submodel)
// - (Needs proj_troll_lightning)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/djinn_lightning_troll"]
class DjinnLightningTroll : BaseMonsterNewScript
{
	// Constants
	float FREQ_GUIDED = 0.0f;
	int DMG_GUIDED = 300;
	int DOT_PUNCH = 100;
	int DMG_PUNCH = 200;
	int DMG_DBL_PUNCH = 100;
	bool LEFT_FIST_INDEX = false;
	bool RIGHT_FIST_INDEX = true;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod1.wav";
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK = "monsters/troll/trollattack.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle2.wav";
	string ANIM_PUNCH = "hit_down";
	string ANIM_DBLPUNCH = "double_punch";
	string ANIM_THROW = "throw_rock";
	int ROCK_RANGE = 800;
	int SWING_RANGE = 130;
	int MELE_RANGE = 128;
	int MELE_HITRANGE = 164;
	int AIM_RATIO = 25;
	int ATTACK_SPEED = 500;
	string ROCK_DAMAGE = "$rand(400,600)";
	string BALL_SCRIPT = "monsters/summon/guided_lball_alt";
	float BALL_DURATION = 10.0f;
	string ANIM_WARCRY = "idle2";
	string MELEE_RANGE = "200";
	int DMG_BALL = 400;

	// Variables (an unset .script variable reads as its own name)
	string FLINCH_CHANCE = "33";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	int PROJ_SHOCK_DOT = 0;
	int PROJ_SHOCK_DMG = 0;
	float COMBAT_REPOS = 0.0f;
	float NEXT_GUIDED = 0.0f;
	bool DID_WARCRY = false;
	float LAUNCH_GUIDED_COUNT = 0.0f;
	bool MELEE_STRIKE = false;
	string PUSH_VEL = "PUSH_VEL";
	bool MELEE_STIKE = false;
	string SPOT_SPEECH = "SPOT_SPEECH";

	// Variables declared by included files, with the value they start with in this script
	DjinnLightningTroll()
	{
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void DjinnLightningTroll_FirstThink()
	{
		NPC_GIVE_EXP = 3000.0f;
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 500;
		DROP_GOLD_MAX = 600;
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fall";
		ANIM_ATTACK = "throw_rock"; // this varies, needs to be a var
		ATTACK_RANGE = 800.0f;
		ATTACK_HITRANGE = 200.0f;
		MOVE_RANGE = "400";
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "33";
		FLINCH_ANIM = "flinch2";
		FLINCH_DELAY = "2.0";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		PROJ_SHOCK_DOT = 100;
		PROJ_SHOCK_DMG = 400;
	}

	// cycle_up
	void DjinnLightningTroll_OnCycleUp(string reason = "")
	{
		NEXT_GUIDED = GameTime() + FREQ_GUIDED;

		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_WARCRY);
		DID_WARCRY = true;
	}

	// game_dodamage
	string DjinnLightningTroll_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (MELEE_STRIKE && Exists(target) && RelationshipOf(target, ENT_ME) == "enemy" && RangeTo(target) < ATTACK_HITRANGE)
		{
			AddVelocity(target, Vec(PUSH_VEL));
			if (RandomInt(1, 4) == 1)
			{
				ApplyEffect(target, "effects/dot_lightning", 5.0f, self, DOT_PUNCH);
				Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, 1, 1);
			}
		}
		MELEE_STRIKE = false;
		return result;
	}

	// warcry
	// called by model idle2 @ frame 28
	void DjinnLightningTroll_OnWarcry()
	{
		PlaySound(2, 10, SOUND_IDLE);
	}

	// game_damaged_other
	string DjinnLightningTroll_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (EntityId(target) != HUNT_LASTTARGET)
			return result;
		if (!(damage > 1.0f))
			return result;

		COMBAT_REPOS = 0.0f;
		return result;
	}

	// warcry
	// This didn't work out due to client side model vanishing too easily
	// { spawn_guided_ball1
	// setvard BALL1_ORG $get(ent_me,svbonepos,LEFT_FIST_INDEX)
	// setvard BALL1_ACTIVE 1
	// setvard BALL1_EXPIRE game.time
	// add BALL1_EXPIRE BALL_DURATION
	// //pick a target
	// local NEARBY_TARGETS $get_tsphere(enemy,2048)
	// if ( NEARBY_TARGETS isnot none )
	// {
	// token.scramble NEARBY_TARGETS
	// setvard BALL1_TARGET $get_token(NEARBY_TARGETS,0)
	// if !$get(BALL1_TARGET,isalive)
	// setvard BALL1_TARGET NPCATK_TARGET
	// }
	// local TARG_ORG $get(BALL1_TARGET,origin)
	// local ANG_TO_TARG $angles3d(BALL1_ORG,TARG_ORG)
	// vectorset ANG_TO_TARG x $neg($vec.x(ANG_TO_TARG))
	// clientevent new all BALL_CL_SCRIPT BALL1_ORG ANG_TO_TARG BALL_DURATION
	// setvard BALL1_CL_IDX game.script.last_sent_id
	// callevent ball1_guided_loop
	// }
	// { ball1_guided_loop
	// if BALL1_ACTIVE
	// callevent 0.25 ball1_guided_loop
	// local TARG_ORG $get(BALL1_TARGET,origin)
	// vectoradd TARG_ORG $relpos($vec(0,90,0),$vec(0,48,0)) //little to the left/right so balls don't merge
	// if ( !$get(BALL1_TARGET,isplayer) ) vectoradd TARG_ORG z $get(BALL1_TARGET,height) //aim for the heads of monsters
	// local OLD_ORG BALL1_ORG //developer
	// //calculate angles, update, and estimate next position
	// local ANG_TO_TARG $angles3d(BALL1_ORG,TARG_ORG)
	// vectorset ANG_TO_TARG x $neg($vec.x(ANG_TO_TARG))
	// clientevent update all BALL1_CL_IDX svr_update_vec ANG_TO_TARG
	// vectoradd BALL1_ORG $relvel(ANG_TO_TARG,$vec(0,30,0))
	// //check for wall
	// local TRACE_START OLD_ORG
	// local TRACE_END BALL1_ORG
	// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
	// if ( TRACE_LINE isnot TRACE_END ) setvard BALL1_EXPIRE game.time
	// //visible debug trace
	// if ( G_DEVELOPER_MODE )
	// {
	// local BEAM_START OLD_ORG
	// local BEAM_END BALL1_ORG
	// effect beam point lgtning.spr 30 BEAM_START BEAM_END (255,0,255) 255 0 1.0
	// }
	// if ( game.time >= BALL1_EXPIRE )
	// {
	// local EXIT_SUB 1
	// setvard BALL1_ACTIVE 0
	// clientevent update all BALL1_CL_IDX ball_explode
	// setvard BALL1_TOKENS $get_tsphere(enemy,64,BALL1_ORG)
	// xdodamage BALL1_ORG 128 DMG_BALL 0 ent_me ent_me none lightning_effect
	// if BALL1_TOKENS isnot none
	// calleventloop $get_token_amt(BALL1_TOKENS) ball_affect_targets
	// }
	// if !EXIT_SUB
	// //scan
	// setvard BALL1_TOKENS $get_tsphere(enemy,64,BALL1_ORG)
	// if BALL1_TOKENS isnot none
	// //hit nme
	// setvard BALL1_ACTIVE 0
	// clientevent update all BALL1_CL_IDX ball_explode
	// calleventloop $get_token_amt(BALL1_TOKENS) ball_affect_targets
	// xdodamage BALL1_ORG 128 DMG_BALL 0 ent_me ent_me none lightning_effect
	// }
	// { spawn_guided_ball2
	// setvard BALL2_ORG $get(ent_me,svbonepos,LEFT_FIST_INDEX)
	// setvard BALL2_ACTIVE 1
	// setvard BALL2_EXPIRE game.time
	// add BALL2_EXPIRE BALL_DURATION
	// //pick a target
	// local NEARBY_TARGETS $get_tsphere(enemy,2048)
	// if ( NEARBY_TARGETS isnot none )
	// {
	// token.scramble NEARBY_TARGETS
	// setvard BALL2_TARGET $get_token(NEARBY_TARGETS,0)
	// if !$get(BALL2_TARGET,isalive)
	// setvard BALL2_TARGET NPCATK_TARGET
	// }
	// local TARG_ORG $get(BALL2_TARGET,origin)
	// local ANG_TO_TARG $angles3d(BALL2_ORG,TARG_ORG)
	// vectorset ANG_TO_TARG x $neg($vec.x(ANG_TO_TARG))
	// clientevent new all BALL_CL_SCRIPT BALL2_ORG ANG_TO_TARG BALL_DURATION
	// setvard BALL2_CL_IDX game.script.last_sent_id
	// callevent ball2_guided_loop
	// }
	// { ball2_guided_loop
	// if BALL2_ACTIVE
	// callevent 0.25 ball2_guided_loop
	// local TARG_ORG $get(BALL2_TARGET,origin)
	// vectoradd TARG_ORG $relpos($vec(0,270,0),$vec(0,48,0)) //little to the left/right so balls don't merge
	// if ( !$get(BALL2_TARGET,isplayer) ) vectoradd TARG_ORG z $get(BALL2_TARGET,height) //aim for the heads of monsters
	// local OLD_ORG BALL2_ORG //developer
	// //calculate angles, update, and estimate next position
	// local ANG_TO_TARG $angles3d(BALL2_ORG,TARG_ORG)
	// vectorset ANG_TO_TARG x $neg($vec.x(ANG_TO_TARG))
	// clientevent update all BALL2_CL_IDX svr_update_vec ANG_TO_TARG
	// vectoradd BALL2_ORG $relvel(ANG_TO_TARG,$vec(0,30,0))
	// //visible debug trace
	// if ( G_DEVELOPER_MODE )
	// {
	// local BEAM_START OLD_ORG
	// local BEAM_END BALL2_ORG
	// effect beam point lgtning.spr 30 BEAM_START BEAM_END (255,0,0) 255 0 1.0
	// }
	// //check for wall
	// local TRACE_START OLD_ORG
	// local TRACE_END BALL2_ORG
	// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
	// if ( TRACE_LINE isnot TRACE_END ) setvard BALL2_EXPIRE game.time
	// if ( game.time > BALL2_EXPIRE )
	// {
	// local EXIT_SUB 1
	// setvard BALL2_ACTIVE 0
	// clientevent update all BALL2_CL_IDX ball_explode
	// setvard BALL2_TOKENS $get_tsphere(enemy,64,BALL2_ORG)
	// xdodamage BALL2_ORG 128 DMG_BALL 0 ent_me ent_me none lightning_effect
	// if BALL2_TOKENS isnot none
	// calleventloop $get_token_amt(BALL2_TOKENS) ball_affect_targets
	// }
	// if !EXIT_SUB
	// //scan
	// setvard BALL2_TOKENS $get_tsphere(enemy,64,BALL2_ORG)
	// if BALL2_TOKENS isnot none
	// //hit nme
	// setvard BALL2_ACTIVE 0
	// clientevent update all BALL2_CL_IDX ball_explode
	// calleventloop $get_token_amt(BALL2_TOKENS) ball_affect_targets
	// xdodamage BALL2_ORG 128 DMG_BALL 0 ent_me ent_me none lightning_effect
	// }
	// called by model idle2 @ frame 28
	void DjinnLightningTroll_OnWarcry_2()
	{
		PlaySound(2, 10, SOUND_IDLE);
	}

	// unnamed block (timer)
	void DjinnLightningTroll_Timer()
	{
		CallEventDelayed(15.0f, "DjinnLightningTroll_Timer");
		// freshen glow
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 0), 128, 14.9f);
	}

	// cycle_up
	void DjinnLightningTroll_OnCycleUp_2(string reason = "")
	{
		if (SPOT_SPEECH == "SPOT_SPEECH")
			return;
		SayText(SPOT_SPEECH);
		SPOT_SPEECH = "SPOT_SPEECH";
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(BALL_SCRIPT);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, DjinnLightningTroll_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(6000);
		SetWidth(100);
		SetHeight(125);
		SetRace("orc");
		SetName("Shadahar Lightning Djinn");
		SetRoam(true);
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("poison", 1.2f);
		SetDamageTaken("acid", 2);
		SetDamageTaken("lightning", 0);
		SetModel("monsters/troll_shad.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(10);

		COMBAT_REPOS = 0.0f;

		CallEventDelayed(10.0f, "random_idle");

		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 0), 128, 15.0f);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (NPCATK_TARGET == "none")
			return;
		if (!CanSee(NPCATK_TARGET))
			return;

		if (!(GameTime() > NEXT_GUIDED))
			return;
		if (!CanSee(NPCATK_TARGET))
			return;
		LAUNCH_GUIDED_COUNT = 2.0f;
		NEXT_GUIDED = GameTime() + FREQ_GUIDED;
		PlayAnim("critical", "double_punch_slow");
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		// //dbg temp validating $get(PARAM1,name)
		if (!CanSee(target))
			return;
		ANIM_ATTACK = ANIM_DBLPUNCH;
		ATTACK_RANGE = SWING_RANGE;
		if (RangeTo(target) <= ROCK_RANGE && RangeTo(target) > ATTACK_RANGE)
		{
			AS_ATTACKING = GameTime() + 10.0f;
			PlayAnim("once", ANIM_THROW);
		}
		if (RangeTo(target) < ATTACK_RANGE)
			ANIM_ATTACK = ANIM_DBLPUNCH;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_WARCRY = false;
		if (CanSee("player"))
			return;
		PlayAnim("critical", "idle2");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnLightningTroll_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		DjinnLightningTroll_OnCycleUp(reason);
		DjinnLightningTroll_OnCycleUp_2(reason);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		if (RangeTo(NPCATK_TARGET) > Float(MELEE_RANGE))
		{
			ANIM_ATTACK = "rock_throw";
		}
		else
		{
			int rndMelee = RandomInt(1, 2);
			if (rndMelee == 1)
				ANIM_ATTACK = "hit_down";
			if (rndMelee == 2)
				ANIM_ATTACK = "double_punch";
		}
	}

	// rock_pickup
	void OnRockPickup()
	{
		SetModelBody(1, 1); // show rock
	}

	// rock_throw
	void OnRockThrow()
	{
		Vector3 mePos = OriginOf(ENT_ME);
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(HUNT_LASTTARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		float finAttackSpeed = ATTACK_SPEED;
		float aimAngle = Divide(RangeTo(HUNT_LASTTARGET), AIM_RATIO); // Aim up a bit
		if (targetZDifference > 200.0f)
		{
			// target higher, increase speed based on how much and reduce angle adj
			targetZDifference = Divide(targetZDifference, 2.0f);
			aimAngle = Divide(aimAngle, 2.0f);
			finAttackSpeed += targetZDifference;
		}
		SetAngle("add_view.x", aimAngle);

		// this hits if you use HUNT_LASTTARGET instead of <view>, but its a straight throw, doesn't look kewl
		// local SPEED_ADJ $get(HUNT_LASTTARGET,range)
		// multiply SPEED_ADJ 4
		// add FIN_ATTACK_SPEED SPEED_ADJ
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_troll_lightning", RelativePosition(Vector3(0, 0, 33)), "none", finAttackSpeed, ROCK_DAMAGE, 0.75f, "none");
		COMBAT_REPOS += 1.0f;

		// dbg temp  @ $get(HUNT_LASTTARGET,name) ( repos COMBAT_REPOS angle AIM_ANGLE speed FIN_ATTACK_SPEED zdiff TARGET_Z_DIFFERENCE )
		SetModelBody(1, 0); // Hide Rock

		// missing a lot, reposition
		if (!(COMBAT_REPOS > 4.0f))
			return;
		COMBAT_REPOS = 0.0f;
		OnChickenRun(5.0f);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlaySound(2, 5, SOUND_PAIN);
		if (RangeTo(ENT_LASTSTRUCK) < MELE_RANGE)
			ANIM_ATTACK = ANIM_DBLPUNCH;
	}

	// stomp_1
	// called by model run @ frame 10 (newer June 27,2006+ model only)
	void OnStomp1()
	{
		PlaySound(2, 8, SOUND_WALK1);
	}

	// stomp_2
	// called by model run @ frame 30 (newer June 27,2006+ model only)
	void OnStomp2()
	{
		PlaySound(2, 8, SOUND_WALK2);
	}

	// random_idle
	void OnRandomIdle()
	{
		CallEventDelayed(10.0f, "random_idle");
		if (IS_HUNTING)
			return;
		if (CanSee("enemy"))
			return;
		if (IS_FLEEING)
			return;
		int animSelect = RandomInt(0, 3);
		if (animSelect == 0)
			ANIM_IDLE = "idle0";
		if (animSelect == 1)
			ANIM_IDLE = "idle1";
		if (animSelect == 2)
			ANIM_IDLE = "idle2";
		if (animSelect == 3)
			ANIM_IDLE = "idle3";
		PlayAnim("once", ANIM_IDLE);
	}

	// warcry
	void OnWarcry()
	{
		DjinnLightningTroll_OnWarcry();
		DjinnLightningTroll_OnWarcry_2();
	}

	// attack_1
	// called by model double_punch @ frame 13 and 26
	void OnAttack12()
	{
		MELEE_STRIKE = true;

		SetModelBody(1, 0); // hide rock

		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 300, 110)));
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_DBL_PUNCH, "75%", "blunt");

		PlaySound(2, 10, SOUND_ATTACK);

		if (!(LAUNCH_GUIDED_COUNT >= 1.0f))
			return;
		if (LAUNCH_GUIDED_COUNT == 1.0f)
			OnSpawnGuidedBall1();
		if (LAUNCH_GUIDED_COUNT == 2.0f)
			OnSpawnGuidedBall2();
		LAUNCH_GUIDED_COUNT -= 1.0f;
	}

	// attack_2
	// called by model hit_down @ frame 20
	void OnAttack22()
	{
		MELEE_STIKE = true;

		SetModelBody(1, 0); // hide rock
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 600, 110)));

		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_PUNCH, "75%", "blunt");
		PlaySound(2, 10, SOUND_ATTACK);
	}

	// spawn_guided_ball1
	void OnSpawnGuidedBall1()
	{
		CreateNpc(BALL_SCRIPT, AttachmentPositionOf(ENT_ME, LEFT_FIST_INDEX), self, DMG_BALL, 256, 20.0f);
	}

	// spawn_guided_ball2
	void OnSpawnGuidedBall2()
	{
		CreateNpc(BALL_SCRIPT, AttachmentPositionOf(ENT_ME, RIGHT_FIST_INDEX), self, DMG_BALL, 256, 20.0f);
	}

	// set_sorcpal_djinn1
	void OnSetSorcpalDjinn1()
	{
		SetSayTextRange(2048);
		SPOT_SPEECH = "You say smash? ME SMASH!!";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/troll_shad.mdl");
		CallEventDelayed(15.0f, "DjinnLightningTroll_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnLightningTroll_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "random_idle") { OnRandomIdle(); return true; }
		if (name == "rock_pickup") { OnRockPickup(); return true; }
		if (name == "rock_throw") { OnRockThrow(); return true; }
		if (name == "set_sorcpal_djinn1") { OnSetSorcpalDjinn1(); return true; }
		if (name == "spawn_guided_ball1") { OnSpawnGuidedBall1(); return true; }
		if (name == "spawn_guided_ball2") { OnSpawnGuidedBall2(); return true; }
		if (name == "stomp_1") { OnStomp1(); return true; }
		if (name == "stomp_2") { OnStomp2(); return true; }
		if (name == "warcry") { OnWarcry(); return true; }
		if (name == "DjinnLightningTroll_Timer") { DjinnLightningTroll_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
