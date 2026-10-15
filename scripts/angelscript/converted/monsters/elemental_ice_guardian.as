#pragma context server

// Converted from monsters/elemental_ice_guardian.script by msc_transpiler.
// Ice Guardian, based on new model
// - when close to the ground, throw feeze sphere straight yaw, otherwise throw direct
// - Boss version has lightning attacks and summons
// other ice god names: Qailertetang (weather, animal), Tekkeitsertok (caribou), Sila (air), Sedna (sea - aliases: Nerrivik, Arnapkapfaaluk, Arnakuagsak, and Nuliajuk)
// boss tricks
// * ice circle (freeze circle centered on NPCATK_TARGET)
// * freezing sphere
// * ice projectile storm (client side fast ice spikes ala hoarfrost, pierce + cold_dot) [not quite the storm I envsioned, but works]
// - lightning staff (charges staff with lightning)
// - lightning beam (shock all nearby enemies)
// - guided lightning balls
// - ice spikes ala troll ball (pierce damage + cold dot)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"
#include "converted/monsters/base_propelled.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersElementalIceGuardian
{
	// Constants
	string ICE_GUARD_NAME = "Lesser Ice Guardian";
	int ICE_GUARD_HP = 3000;
	float ICE_GUARD_FIRE_VULN = 1.5f;
	int ICE_GUARD_LEVEL = 1;
	string ICE_GUARD_MODEL = "monsters/ice_guardian.mdl";
	int ICE_GUARD_WIDTH = 32;
	int ICE_GUARD_HEIGHT = 96;
	float ICE_GUARD_ICE_VULN = 0.0f;
	string GUARD_ELEMENT = "ice";
	string ICE_GUARD_DOT_EFFECT = "effects/dot_cold";
	string ANIM_ATTACK1 = "attack1";
	string ANIM_ATTACK2 = "attack2";
	string ANIM_STUN_BURST = "attack_smash";
	string ANIM_THROW = "attack_throw";
	string ANIM_PUSH = "attack_push";
	string ANIM_LUNGE = "attack_long";
	string ANIM_ICE_BALL = "release_spell";
	string ANIM_SPELL_LOOP = "spell_loop";
	string ANIM_SUMMON = "summon";
	string ANIM_ALERT = "alert";
	string ANIM_FLINCH_CUSTOM = "flinch";
	string ANIM_TAUNT = "taunt";
	string ANIM_PROJECTILE = "projectile";
	string ANIM_MULTI_PROJECTILE = "multi_projectile";
	string ANIM_DODGE = "attack_pushr";
	string ANIM_PUSHL = "attack_pushl";
	string ANIM_BREATH_START = "ccastout";
	string ANIM_BREATH_LOOP = "ccastoutlp";
	string ANIM_FAKE_DEATH = "long_death";
	string ANIM_RESSURECT = "ressurect";
	string ANIM_FAKE_DEATH_IDLE = "dead_idle";
	int SPEED_SLOW = 100;
	int SPEED_FAST = 200;
	int BFLY_VSPEED_UP = 5;
	int BFLY_VSPEED_DOWN = -50;
	int ATTACK_MOVERANGE_DEF = 50;
	int ATTACK_RANGE_DEF = 60;
	int ATTACK_HITRANGE_DEF = 75;
	int ATTACK_MOVERANGE_AGRO = 60;
	int LUNGE_RANGE_MIN = 75;
	int LUNGE_RANGE_MAX = 175;
	int LUNGE_RANGE_MAX_HITRANGE = 125;
	Vector3 STAFF_BEAM_COLOR = Vector3();
	string STAFF_ALT_EFFECT = "effects/dot_lightning";
	float FREQ_STUN_BURST = 0.0f;
	float FREQ_ICE_BALL = 0.0f;
	float FREQ_ICE_CIRCLE = 0.0f;
	float FREQ_THROW = 0.0f;
	float FREQ_STAFF_MODE_CHANGE = 20.0f;
	float FREQ_LUNGE = 5.0f;
	float FREQ_DODGE = 0.0f;
	float FREQ_FLINCH = 20.0f;
	float FREQ_CHANGE_STANCE = 20.0f;
	float FREQ_TAUNT = 20.0f;
	float FREQ_CHARGE = 20.0f;
	float FREQ_PROJECTILE = 3.0f;
	float FREQ_SHOCK_STORM = 30.0f;
	float DMG_BURST = 100.0f;
	int DMG_LUNGE = 200;
	int DMG_STAFF = 100;
	int DOT_FROST = 30;
	float DOT_SHOCK = 60.0f;
	int ICE_CIRCLE_RAD = 172;
	int ICE_CIRCLE_FXRAD = 172;
	string CL_FX_SCRIPT = "monsters/elemental_ice_guardian_cl";
	string SOUND_PROJECTILE = "magic/ice_strike.wav";
	string SOUND_STAFF_ON = "magic/elecidle.wav";
	string SOUND_SHOCK_LOOP = "magic/bolt_loop.wav";
	string SOUND_SHOCK_START = "magic/bolt_start.wav";
	string SOUND_SHOCK_HIT = "magic/bolt_end.wav";
	string SOUND_STRUCK1 = "debris/glass1.wav";
	string SOUND_STRUCK2 = "debris/glass2.wav";
	string SOUND_STRUCK3 = "debris/glass3.wav";
	string SOUND_SWIPE1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPE2 = "zombie/claw_miss2.wav";
	string SOUND_SWIPE_STRONG1 = "zombie/claw_strike1.wav";
	string SOUND_SWIPE_STRONG2 = "zombie/claw_strike2.wav";
	string SOUND_SWIPE_STRONG3 = "zombie/claw_strike3.wav";
	string SOUND_ATTACK1 = "monsters/ice_guardian/c_elemwatr_atk1.wav";
	string SOUND_ATTACK2 = "monsters/ice_guardian/c_elemwatr_atk2.wav";
	string SOUND_ATTACK3 = "monsters/ice_guardian/c_elemwatr_atk3.wav";
	string SOUND_TAUNT = "monsters/ice_guardian/c_elemwatr_bat1.wav";
	string SOUND_ALERT = "monsters/ice_guardian/c_elemwatr_slct.wav";
	string SOUND_SUMMON = "monsters/ice_guardian/c_elemwatr_bat2.wav";
	string SOUND_DODGE = "monsters/ice_guardian/c_elemwatr_slct.wav";
	string SOUND_PAIN1 = "monsters/ice_guardian/c_elemwatr_hit1.wav";
	string SOUND_PAIN2 = "monsters/ice_guardian/c_elemwatr_hit2.wav";
	string SOUND_DEATH = "monsters/ice_guardian/c_elemwatr_dead.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle_ready";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool IS_UNHOLY = true;
	float NPC_HACKED_MOVE_SPEED = 100.0f;
	bool IMMUNE_VAMPIRE = true;
	float VEL_PUSH_ATK_F = 0.0f;
	int VEL_THROW_ATK_L = 0;
	float VEL_THROW_ATK_F = 0.0f;
	float VEL_BURST_F = 0.0f;
	float VEL_FBURST_F = 0.0f;
	float VEL_BURST_U = 0.0f;
	float VEL_LONG_F = 0.0f;
	float VEL_DODGE_F = 0.0f;
	float VEL_DODGE_L = 0.0f;
	float VEL_SHOCK_F = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	float ATTACK_COUNT = 0.0f;
	string STAFF_ON = "STAFF_ON";
	float IN_STANCE = 0.0f;
	float NEXT_STANCE_CHANGE = 0.0f;
	float HALF_HP = 0.0f;
	string CL_FX_INDEX = "CL_FX_INDEX";
	float NEXT_CL_REFRESH = 0.0f;
	bool DID_WARCRY = false;
	float AS_ATTACKING = 0.0f;
	float NEXT_STUN_BURST = 0.0f;
	float NEXT_LUNGE = 0.0f;
	float NEXT_CHARGE = 0.0f;
	float NEXT_ICE_BALL = 0.0f;
	float NEXT_ICE_CIRCLE = 0.0f;
	float NEXT_STAFF_MODE_CHANGE = 0.0f;
	float NEXT_METEOR = 0.0f;
	float NEXT_TARG_CHECK = 0.0f;
	float FLIGHT_HEIGHT = 0.0f;
	bool PROJECTILE_LOOP_ON = false;
	Vector3 FIRE_CIRCLE_POS = Vector3();
	bool CIRCLE_POS_SET = false;
	string SUMMON_TYPE = "SUMMON_TYPE";
	bool METEOR_MODE = false;
	float NEXT_SHOCK_STORM = 0.0f;
	float NEXT_PROJECTILE = 0.0f;
	float PROJ_SPEED = 0.0f;
	float HIT_DELAY = 0.0f;
	int PASS_FREEZE_DMG = 0;
	float PASS_FREEZE_DUR = 0.0f;
	Vector3 BURST_POS = Vector3();
	bool MELEE_ATTACK = false;
	Vector3 BURST_START = Vector3();
	string BURST_TARGS = "BURST_TARGS";
	float NEXT_CALM = 0.0f;
	float NEXT_DODGE = 0.0f;
	CBaseEntity@ DODGE_TARGET = null;
	float NEXT_FLINCH = 0.0f;
	float NEXT_TAUNT = 0.0f;
	bool ICE_CIRCLE_ACTIVE = false;
	Vector3 ICE_CIRCLE_ORIGIN = Vector3();
	string CIRCLE_TARGS = "CIRCLE_TARGS";
	bool SHOCK_MODE = false;
	bool SHOCK_STORM_ON = false;
	CBaseEntity@ SHOCK_STORM_BEAM_ID = null;
	string SHOCK_TARGS = "SHOCK_TARGS";
	float CUR_SHOCK_TARG_IDX = 0.0f;
	string STORM_TARGS = "STORM_TARGS";
	bool BE_AGGRESSIVE = false;

	// unnamed block (first think)
	void MonstersElementalIceGuardian_FirstThink()
	{
		ANIM_IDLE = "idle_ready";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack1";

		ANIM_DEATH = "explode"; // long_death works, but this is niftier
	}

	// unnamed block (first think)
	void MonstersElementalIceGuardian_FirstThink2()
	{
		VEL_PUSH_ATK_F = 400.0f;
		VEL_THROW_ATK_L = -400;
		VEL_THROW_ATK_F = 400.0f;
		VEL_BURST_F = 500.0f;
		VEL_FBURST_F = 800.0f;
		VEL_BURST_U = 100.0f;
		VEL_LONG_F = 300.0f;
		VEL_DODGE_F = 300.0f;
		VEL_DODGE_L = 300.0f;
		VEL_SHOCK_F = 600.0f;

		if (ToLowerCase(MapName()) != "shender_east")
		{
			VEL_PUSH_ATK_F *= 1.25f;
			VEL_THROW_ATK_L = -600;
			VEL_THROW_ATK_F *= 1.25f;
			VEL_BURST_F *= 1.25f;
			VEL_FBURST_F *= 1.25f;
			VEL_BURST_U *= 1.25f;
			VEL_LONG_F *= 1.25f;
			VEL_DODGE_F *= 1.25f;
			VEL_DODGE_L *= 1.25f;
			VEL_SHOCK_F *= 1.25f;
		}

		IS_UNHOLY = true;
		NPC_HACKED_MOVE_SPEED = 100.0f;
		IMMUNE_VAMPIRE = true;

		MOVE_RANGE = "50";
		ATTACK_MOVERANGE = 50.0f;

		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 75.0f;

		// const OFS_ICE_BALL $vec(0,16,16)
		NPC_GIVE_EXP = 1000.0f;
	}

	// npc_spawn
	void MonstersElementalIceGuardian_OnNpcSpawn(string npc = "")
	{
		SetName(ICE_GUARD_NAME);
		SetHealth(ICE_GUARD_HP);
		SetRace("demon");
		SetModel(ICE_GUARD_MODEL);
		SetWidth(ICE_GUARD_WIDTH);
		SetHeight(ICE_GUARD_HEIGHT);

		SetRoam(true);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("cold", ICE_GUARD_ICE_VULN);
		SetDamageTaken("fire", ICE_GUARD_FIRE_VULN);
		SetDamageTaken("holy", 1.5f);

		SetBlood("none");

		SetHearingSensitivity(6);

		PlayAnim("once", ANIM_IDLE);

		ATTACK_COUNT = 0.0f;
		STAFF_ON = "0";

		IN_STANCE = 0.0f;
		NEXT_STANCE_CHANGE = GameTime() + 20.0f;

		CallEventDelayed(0.1f, "refresh_client_fx");
		CallEventDelayed(2.0f, "finalize_npc");
	}

	// finalize_npc
	void MonstersElementalIceGuardian_OnFinalizeNpc()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
		ATTACK_MOVERANGE = ATTACK_MOVERANGE_DEF;
		ATTACK_RANGE = ATTACK_RANGE_DEF;
		ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
	}

	// refresh_client_fx
	void MonstersElementalIceGuardian_OnRefreshClientFx()
	{
		if (!(ICE_GUARD_LEVEL > 1))
			return;
		if (!IsAlive(ENT_ME))
			return;
		if (CL_FX_INDEX != "CL_FX_INDEX")
			ClientEvent("update", "all", CL_FX_INDEX, "end_fx");
		ClientEvent("new", "all", CL_FX_SCRIPT, IndexOf(ENT_ME), STAFF_ON);
		CL_FX_INDEX = LastClientScriptId();
		NEXT_CL_REFRESH = GameTime() + 45.0f;
	}

	// game_death
	void MonstersElementalIceGuardian_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0), Vector3(0, 0, 0))); // meh, no workie
		SetGravity(1);
		// clientevent update all CL_FX_INDEX guardian_died //ends fx with delay for body decompose
		ClientEvent("update", "all", CL_FX_INDEX, "guardian_death"); // ends fx asap
		CallExternal(GetVar("GAME_MASTER"), "gm_vanish_que", self, 3.0f);

		if (SHOCK_STORM_ON)
		{
			ServerPlaySound(3, 0, SOUND_SHOCK_LOOP);
			Effect("beam", "update", @SHOCK_STORM_BEAM_ID, "brightness", 0);
		}
	}

	// game_stopmoving
	void MonstersElementalIceGuardian_OnGameStopmoving()
	{
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
	}

	// npc_targetsighted
	void MonstersElementalIceGuardian_OnNpcTargetsighted(string target = "")
	{
		if (DID_WARCRY)
			return;
		DID_WARCRY = true;

		OnRefreshClientFx();

		float gameTime = GameTime();

		int rndWarcry = RandomInt(1, 2);
		AS_ATTACKING = gameTime + 5.0f;
		SetRoam(false);
		CallEventDelayed(2.0f, "restore_roam");
		SetMoveDest(NPCATK_TARGET, 9999);
		if (rndWarcry == 1)
			PlayAnim("critical", ANIM_ALERT);
		if (rndWarcry == 2)
			PlayAnim("critical", ANIM_TAUNT);

		NEXT_STUN_BURST = gameTime + FREQ_STUN_BURST;

		NEXT_LUNGE = gameTime + 1.0f;

		// level 1 only
		NEXT_CHARGE = gameTime + FREQ_CHARGE;

		// level 2+
		NEXT_ICE_BALL = gameTime + FREQ_ICE_BALL;

		NEXT_ICE_CIRCLE = gameTime + FREQ_ICE_CIRCLE;

		// level 3
		NEXT_STAFF_MODE_CHANGE = gameTime + FREQ_STAFF_MODE_CHANGE;

		// fire level 3 only
		NEXT_METEOR = gameTime;
		NEXT_METEOR += Float(GetVar("FREQ_METEOR"));
	}

	// restore_roam
	void MonstersElementalIceGuardian_OnRestoreRoam()
	{
		SetRoam(true);
	}

	// frame_alert
	void MonstersElementalIceGuardian_OnFrameAlert()
	{
		PlaySound(0, 10, SOUND_ALERT);
	}

	// frame_taunt
	void MonstersElementalIceGuardian_OnFrameTaunt()
	{
		PlaySound(0, 10, SOUND_TAUNT);
	}

	// cycle_down
	void MonstersElementalIceGuardian_OnCycleDown()
	{
		DID_WARCRY = false;
	}

	// npcatk_hunt
	// ========================================================== MAIN CYCLE
	void MonstersElementalIceGuardian_OnNpcatkHunt()
	{
		bool exitSub = false;

		float gameTime = GameTime();

		if (NPCATK_TARGET == "unset" && gameTime > NEXT_TARG_CHECK)
		{
			NEXT_TARG_CHECK = gameTime + Random(5, 20);
			if (ToLowerCase(MapName()) == "shender_east")
			{
				Vector3 checkPoint = Vector3(0, 0, -3760);
				string checkTargs = LegacyFunction("get_tsphere", "player", 1024, checkPoint);
				if (checkTargs != "none")
				{
					checkTargs = SortEntities(checkTargs, "range");
					CBaseEntity@ newTarget = FindEntity(GetToken(checkTargs, 0));
					OnNpcatkSettarget(EntityId(newTarget));
				}
			}
		}

		if (ICE_GUARD_LEVEL > 1 && gameTime > NEXT_CL_REFRESH)
			OnRefreshClientFx();

		if (gameTime > NEXT_STANCE_CHANGE)
		{
			NEXT_STANCE_CHANGE = gameTime + 0.0f;

			IN_STANCE += 1.0f;
			if (IN_STANCE == 1.0f)
			{
				ANIM_WALK = "run";
				ANIM_RUN = "walk";
				NPC_HACKED_MOVE_SPEED = SPEED_SLOW;
			}
			else
			{
				ANIM_WALK = "walk";
				ANIM_RUN = "run";
				NPC_HACKED_MOVE_SPEED = SPEED_FAST;
				IN_STANCE = 0.0f;
			}
		}

		if (SUSPEND_AI)
			return;

		if (NPCATK_TARGET == "unset")
			return;

		float targRange = RangeTo(NPCATK_TARGET);

		if (targRange < ATTACK_HITRANGE)
		{
			// TARG_RANGE is 2D, so in case I'm right over his head
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			Vector3 myOrg = OriginOf(ENT_ME);
			float zDiff = myOrg.z - targOrg.z;
			if (zDiff > ATTACK_RANGE)
			{
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -100)));
				SetGravity(1);
			}
			else if (zDiff > 0.0f)
				SetGravity(0.5f);
		}

		// track distance from ground (since $dist doesn't handle Z coords)
		Vector3 myPos = OriginOf(ENT_ME);
		float groundHeight = GroundHeight(myPos);
		FLIGHT_HEIGHT = myPos.z;
		if (FLIGHT_HEIGHT > groundHeight)
		{
			FLIGHT_HEIGHT -= groundHeight;
		}
		else
		{
			groundHeight -= FLIGHT_HEIGHT;
			FLIGHT_HEIGHT = groundHeight;
		}

		if (ICE_GUARD_LEVEL >= 2)
		{
			if (gameTime > NEXT_CALM)
			{
				if (BE_AGGRESSIVE)
				{
					ATTACK_MOVERANGE = ATTACK_MOVERANGE_AGRO;
					NPC_HACKED_MOVE_SPEED = SPEED_FAST;
				}
				else
				{
					ATTACK_MOVERANGE = ATTACK_MOVERANGE_DEF;
				}
			}
			else
			{
				ATTACK_MOVERANGE = ATTACK_MOVERANGE_AGRO;
				NPC_HACKED_MOVE_SPEED = SPEED_FAST;
			}
		}

		if (targRange > LUNGE_RANGE_MIN && targRange < LUNGE_RANGE_MAX && gameTime > NEXT_LUNGE)
		{
			ATTACK_HITRANGE = LUNGE_RANGE_MAX_HITRANGE;
			ATTACK_RANGE = LUNGE_RANGE_MAX;
			ANIM_ATTACK = ANIM_LUNGE;
		}

		if (gameTime > NEXT_STUN_BURST && FLIGHT_HEIGHT < 30.0f)
			ANIM_ATTACK = ANIM_STUN_BURST;

		// setvard ATTACK_MOVERANGE 200
		if (gameTime > NEXT_CHARGE)
		{
			// level 1 ice guard attacks are all melee
			// flight model may result in her getting stuck at a distance, this compensates
			if (ICE_GUARD_LEVEL == 1 && targRange > 300.0f)
			{
				NEXT_CHARGE = gameTime + FREQ_CHARGE;
				PlayAnim("critical", ANIM_LUNGE);
				PROJECTILE_LOOP_ON = false;
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 0)));
			}
		}

		if (!(ICE_GUARD_LEVEL >= 2))
			return;

		if (ICE_GUARD_LEVEL == 3 && gameTime > NEXT_STAFF_MODE_CHANGE)
		{
			NEXT_STAFF_MODE_CHANGE = gameTime + FREQ_STAFF_MODE_CHANGE;
			OnStaffModeSwitch();
		}

		if (gameTime > NEXT_ICE_BALL)
		{
			if (targRange < 300.0f)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 110)));
			ATTACK_RANGE = 2048.0f;
			ATTACK_HITRANGE = 2048.0f;
			if (BE_AGGRESSIVE)
			{
				ATTACK_RANGE = 768.0f;
				ATTACK_HITRANGE = 768.0f;
			}
			ANIM_ATTACK = ANIM_ICE_BALL;
			// used by fire type only (so it can miss)
			if (!CIRCLE_POS_SET)
			{
				FIRE_CIRCLE_POS = NPC_LASTSEEN_POS;
				CIRCLE_POS_SET = true;
			}
			exitSub = true;
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_ICE_CIRCLE) {}
		if (exitSub)
			return;

		if (ICE_GUARD_LEVEL == 2 && gameTime > NEXT_PROJECTILE && CanSee(NPCATK_TARGET) && targRange > LUNGE_RANGE_MAX)
		{
			if (targRange < 300.0f)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 110)));
			ATTACK_RANGE = 2048.0f;
			ATTACK_HITRANGE = 2048.0f;
			ANIM_ATTACK = ANIM_PROJECTILE;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (ICE_GUARD_LEVEL == 3 && GUARD_ELEMENT == "ice" && gameTime > NEXT_PROJECTILE && CanSee(NPCATK_TARGET))
		{
			// m-m-m-m-multi spike
			if (targRange > LUNGE_RANGE_MAX)
			{
				if (targRange < 300.0f)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 110)));
				ATTACK_RANGE = 2048.0f;
				ATTACK_HITRANGE = 2048.0f;
				ANIM_ATTACK = ANIM_MULTI_PROJECTILE;
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_METEOR)
		{
			if (GUARD_ELEMENT == "fire")
			{
				// m-m-m-meteor
				NEXT_METEOR = gameTime;
				NEXT_METEOR += Float(GetVar("FREQ_METEOR"));
				if (targRange < 300.0f)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 110)));
				ATTACK_RANGE = 2048.0f;
				ATTACK_HITRANGE = 2048.0f;
				METEOR_MODE = true;
				ANIM_ATTACK = ANIM_ICE_BALL;
				exitSub = true;
				OnDelaySpecials();
			}
			if (!exitSub) {}
		}

		if (ICE_GUARD_LEVEL == 3 && gameTime > NEXT_SHOCK_STORM)
		{
			NEXT_SHOCK_STORM = gameTime + FREQ_SHOCK_STORM;
			if (SHOCK_MODE)
			{
				if (targRange < 300.0f && GUARD_ELEMENT == "ice")
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 110)));
				PROJECTILE_LOOP_ON = false;
				PlayAnim("critical", ANIM_SPELL_LOOP);
				OnNpcatkSuspendAi("10.0");
				OnNpcatkSuspendMovement(ANIM_SPELL_LOOP, "10.0");
				OnDoShockStorm();
				exitSub = true;
			}
		}
		if (exitSub)
			return;
	}

	// frame_multi_projectile_start
	void MonstersElementalIceGuardian_OnFrameMultiProjectileStart()
	{
		NEXT_PROJECTILE = GameTime() + FREQ_PROJECTILE;

		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = ATTACK_RANGE_DEF;
		ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
		OnDelaySpecials();

		PROJ_SPEED = 1500.0f;
		HIT_DELAY = 0.2f;

		PROJECTILE_LOOP_ON = true;
		CallEventDelayed(5.0f, "frame_multi_projectile_end"); // in case anim doesn't catch
		OnProjectileLoop();
	}

	// frame_multi_projectile_end
	void MonstersElementalIceGuardian_OnFrameMultiProjectileEnd()
	{
		if (!PROJECTILE_LOOP_ON)
			return;
		PROJECTILE_LOOP_ON = false;
	}

	// projectile_loop
	void MonstersElementalIceGuardian_OnProjectileLoop()
	{
		if (!PROJECTILE_LOOP_ON)
			return;
		OnDoProjectile();
		CallEventDelayed(0.3f, "projectile_loop");
	}

	// frame_projectile
	void MonstersElementalIceGuardian_OnFrameProjectile()
	{
		NEXT_PROJECTILE = GameTime() + FREQ_PROJECTILE;

		PROJ_SPEED = 800.0f;
		HIT_DELAY = 0.5f;

		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = ATTACK_RANGE_DEF;
		ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
		OnDelaySpecials();

		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		OnDoProjectile();
	}

	// do_projectile
	void MonstersElementalIceGuardian_OnDoProjectile(Vector3 offset = Vector3())
	{
		bool hitTarget = false;

		if (GUARD_ELEMENT == "ice")
		{
			PlaySound(0, 10, SOUND_PROJECTILE);

			Vector3 traceStart = AttachmentPositionOf(ENT_ME, 1);
			Vector3 traceEnd = OriginOf(NPCATK_TARGET);
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
			Vector3 targAng = Angles3DTo(traceStart, Vec(traceLine));
			targAng.x = -targAng.x;

			if (RangeTo(NPCATK_TARGET) < 300.0f)
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -200, 110)));

			// local TARG_ANG $get(ent_me,viewangles) //test
			// dbg frame_projectile $get(ent_me,viewangles)
			// vectorset TARG_ANG x $neg($vec.x(TARG_ANG))
			if (traceLine == Text(traceEnd))
				hitTarget = true;

			ClientEvent("update", "all", CL_FX_INDEX, "fire_projectile", targAng, traceEnd, hitTarget, PROJ_SPEED);

			if (hitTarget)
				CallEventDelayed(HIT_DELAY, "projectile_strike");
		}

		if (GUARD_ELEMENT == "fire")
		{
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_flame_jet2", RelativePosition(Vector3(0, 16, 16)), NPCATK_TARGET, 300, "DMG_SPIT", 2, "none");
			ClientEvent("update", "all", CL_FX_INDEX, "staff_glow");
		}
	}

	// projectile_strike
	void MonstersElementalIceGuardian_OnProjectileStrike()
	{
		DoDamage(NPCATK_TARGET, "direct", DMG_STAFF, "100%", ENT_ME, "pierce");

		if (ICE_GUARD_LEVEL == 2 && RandomInt(1, 3) == 1)
			ApplyEffect(NPCATK_TARGET, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);

		if (GUARD_ELEMENT == "ice" && ICE_GUARD_LEVEL == 3)
		{
			if (RandomInt(1, 5) == 1)
				ApplyEffect(NPCATK_TARGET, "effects/dot_cold_freeze", 5.0f, self, DOT_FROST);
			else
				ApplyEffect(NPCATK_TARGET, "effects/dot_cold", 5.0f, self, DOT_FROST);
		}
	}

	// frame_summon
	void MonstersElementalIceGuardian_OnFrameSummon()
	{
		NEXT_ICE_CIRCLE = GameTime() + FREQ_ICE_CIRCLE;

		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = ATTACK_RANGE_DEF;
		ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;

		if (SUMMON_TYPE == "circle" && IsAlive(NPCATK_TARGET) && CanSee(NPCATK_TARGET))
		{
			OnDoIceCircle(OriginOf(NPCATK_TARGET));
			OnDelaySpecials();
		}
	}

	// frame_spell
	void MonstersElementalIceGuardian_OnFrameSpell()
	{
		bool exitSub = false;
		// freezing sphere
		NEXT_ICE_BALL = GameTime() + FREQ_ICE_BALL;
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);

		if (METEOR_MODE)
		{
			METEOR_MODE = false;
			exitSub = true;

			Vector3 spellPos = OriginOf(NPCATK_TARGET);
			string traceStart = Text(spellPos);
			string traceEnd = Text(spellPos);
			traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, 768.0f));
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
			string meteorSpawn = Text(Vec(traceLine) + Vector3(0.0f, 0.0f, -100.0f));

			CreateNpc("monsters/summon/meteor_deployer", Vec(meteorSpawn), self, self);

			ANIM_ATTACK = "attack1";
			ATTACK_RANGE = ATTACK_RANGE_DEF;
			ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
			OnDelaySpecials();
		}
		if (exitSub)
			return;

		if (GUARD_ELEMENT == "ice")
		{
			if (FLIGHT_HEIGHT > 100.0f)
			{
				// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
				TossProjectile("proj_freezing_sphere", RelativePosition(Vector3(0, 16, 16)), NPCATK_TARGET, 100, 0, 0, "none");
			}
			else
			{
				PASS_FREEZE_DMG = DOT_FROST;
				PASS_FREEZE_DUR = 8.0f;
				SetMoveDest(NPCATK_TARGET, 9999);
				SetAngle("view.pitch", 0);
				SetAngle("view.roll", 0);
				SetAngle("view.yaw", AnglesOf(ENT_ME).y);
				TossProjectile("proj_freezing_sphere", RelativePosition(Vector3(0, 16, 16)), "none", 100, 0, 0, "none");
			}
			ANIM_ATTACK = "attack1";
			ATTACK_RANGE = ATTACK_RANGE_DEF;
			ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
			OnDelaySpecials();
		}

		if (GUARD_ELEMENT == "fire")
		{
			if (Text(FIRE_CIRCLE_POS) == "unset")
			{
				// can't see target, skip for now
				CIRCLE_POS_SET = false;
				ANIM_ATTACK = "attack1";
				ATTACK_RANGE = ATTACK_RANGE_DEF;
				ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
				OnDelaySpecials();
			}
			else
			{
				// circle of fire at last seen nme loc
				BURST_POS = FIRE_CIRCLE_POS;
				BURST_POS.z = GroundHeight(NPC_LASTSEEN_POS);
				ClientEvent("new", "all", "effects/sfx_fire_staff", BURST_POS);
				BURST_POS.z += 32.0f; // adjust up a bit for uneven terrain
				DoDamageEx(BURST_POS, 96, GetVar("DMG_FIRE_BURST"), 0.01f, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:burst");

				CIRCLE_POS_SET = false;
				ANIM_ATTACK = "attack1";
				ATTACK_RANGE = ATTACK_RANGE_DEF;
				ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
				OnDelaySpecials();
			}
		}
	}

	// burst_dodamage
	// fire variant only
	void MonstersElementalIceGuardian_OnBurstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);
		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = BURST_POS;
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, VEL_FBURST_F, 110)));
	}

	// flamejet_dodamage
	// fire variant only
	void MonstersElementalIceGuardian_OnFlamejetDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		ApplyEffect(target, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);
	}

	// frame_attack
	void MonstersElementalIceGuardian_OnFrameAttack()
	{
		PlayRandomSound(2, 5, SOUND_SWIPE1, SOUND_SWIPE2);

		MELEE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_STAFF, "90%", "slash");

		ATTACK_COUNT += 1.0f;
		float divAttackCount = Divide(ATTACK_COUNT, 2.0f);
		// alternate attacks every other frame
		DebugPrint(Text(divAttackCount) + " vs. " + Text(int(divAttackCount)) + " [ " + Text(FLIGHT_HEIGHT) + " ]");
		if (divAttackCount == int(divAttackCount))
			ANIM_ATTACK = ANIM_ATTACK1;
		else
			ANIM_ATTACK = ANIM_ATTACK2;

		// push every 5th attack, throw every 10th
		if (ATTACK_COUNT == 5.0f)
		{
			ATTACK_COUNT += 1.0f;
			ANIM_ATTACK = ANIM_PUSH;
		}

		if (ATTACK_COUNT >= 10.0f)
		{
			ATTACK_COUNT = 0.0f;
			ANIM_ATTACK = ANIM_THROW;
		}
	}

	// frame_attack_push
	void MonstersElementalIceGuardian_OnFrameAttackPush()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlayRandomSound(2, 5, SOUND_SWIPE1, SOUND_SWIPE2);
		ANIM_ATTACK = "attack1";

		MELEE_ATTACK = true;
		// dodamage NPCATK_TARGET ATTACK_HITRANGE DMG_LUNGE 100% blunt dmgevent:pushatk
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_LUNGE, "100%", ENT_ME, ENT_ME, "blunt", "none", "dmgevent:pushatk");
	}

	// pushatk_dodamage
	void MonstersElementalIceGuardian_OnPushatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (MELEE_ATTACK && hit)
		{
			if (!SHOCK_MODE)
				ApplyEffect(target, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);
			else
				ApplyEffect(target, STAFF_ALT_EFFECT, 5.0f, self, DOT_SHOCK);
		}
		MELEE_ATTACK = false;
		if (!hit)
			return;
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, VEL_PUSH_ATK_F, 110)));
	}

	// frame_attack_throw
	void MonstersElementalIceGuardian_OnFrameAttackThrow()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlayRandomSound(2, 5, SOUND_SWIPE_STRONG1, SOUND_SWIPE_STRONG2, SOUND_SWIPE_STRONG3);
		ANIM_ATTACK = "attack1";
		ATTACK_COUNT += 1.0f;

		MELEE_ATTACK = true;
		// dodamage NPCATK_TARGET ATTACK_HITRANGE DMG_LUNGE 100% blunt dmgevent:throwatk
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_LUNGE, "100%", ENT_ME, ENT_ME, "blunt", "none", "dmgevent:throwatk");
	}

	// throwatk_dodamage
	void MonstersElementalIceGuardian_OnThrowatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (MELEE_ATTACK && hit)
		{
			if (!SHOCK_MODE)
				ApplyEffect(target, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);
			else
				ApplyEffect(target, STAFF_ALT_EFFECT, 5.0f, self, DOT_SHOCK);
		}
		MELEE_ATTACK = false;
		if (!hit)
			return;
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(VEL_THROW_ATK_L, VEL_THROW_ATK_F, 200)));
		ApplyEffect("CUR_TARG", "effects/debuff_stun", 5.0f, self);
	}

	// frame_smash
	void MonstersElementalIceGuardian_OnFrameSmash()
	{
		NEXT_STUN_BURST = GameTime() + FREQ_STUN_BURST;
		OnDelaySpecials();

		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		ANIM_ATTACK = "attack1";

		BURST_START = RelativePosition(Vector3(0, 64, 0));
		ClientEvent("new", "all", "effects/sfx_stun_burst", BURST_START, 256, 0);
		BURST_TARGS = LegacyFunction("get_tsphere", "enemy", 256, BURST_START);
		if (BURST_TARGS == "none")
			return;
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurstAffectTargets();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// burst_affect_targets
	void MonstersElementalIceGuardian_OnBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		ApplyEffect(curTarg, "effects/debuff_stun", 8.0f, self);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = BURST_START;
		float newYaw = AnglesTo(myOrg, targOrg);
		DoDamageEx(curTarg, "direct", DMG_BURST, "100%", ENT_ME, ENT_ME, "none", "blunt");
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, VEL_BURST_F, VEL_BURST_U)));
	}

	// frame_long_attack
	void MonstersElementalIceGuardian_OnFrameLongAttack()
	{
		NEXT_LUNGE = GameTime() + FREQ_LUNGE;

		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		PlayRandomSound(2, 10, SOUND_SWIPE1, SOUND_SWIPE2);
		ATTACK_HITRANGE = ATTACK_HITRANGE_DEF;
		ATTACK_RANGE = ATTACK_RANGE_DEF;
		ANIM_ATTACK = "attack1";
		MELEE_ATTACK = true;
		// dodamage NPCATK_TARGET LUNGE_RANGE_MAX DMG_LUNGE 90% slash dmgevent:longatk
		DoDamageEx(NPCATK_TARGET, LUNGE_RANGE_MAX, DMG_LUNGE, "90%", ENT_ME, ENT_ME, "slash", "none", "dmgevent:longatk");
	}

	// longatk_dodamage
	void MonstersElementalIceGuardian_OnLongatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (MELEE_ATTACK && hit)
		{
			if (!SHOCK_MODE)
				ApplyEffect(target, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);
			else
				ApplyEffect(target, STAFF_ALT_EFFECT, 5.0f, self, DOT_SHOCK);
		}
		MELEE_ATTACK = false;
		if (!hit)
			return;
		float rndRl = Random(-200, 100);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(rndRl, VEL_LONG_F, 110)));
	}

	// game_dodamage
	string MonstersElementalIceGuardian_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (MELEE_ATTACK && hit)
		{
			if (!SHOCK_MODE)
				ApplyEffect(target, ICE_GUARD_DOT_EFFECT, 5.0f, self, DOT_FROST);
			else
				ApplyEffect(target, STAFF_ALT_EFFECT, 5.0f, self, DOT_SHOCK);
		}
		MELEE_ATTACK = false;
		return result;
	}

	// delay_specials
	void MonstersElementalIceGuardian_OnDelaySpecials()
	{
		// call after each special time reset, to make sure there's some delay between specials
		float gameTime = GameTime();
		float timePlus5 = gameTime + 5.0f;

		if (timePlus5 > NEXT_STUN_BURST)
			NEXT_STUN_BURST = gameTime + Random(1, 5);

		if (timePlus5 > NEXT_CHARGE)
			NEXT_CHARGE = gameTime + Random(1, 5);

		if (timePlus5 > NEXT_ICE_BALL)
			NEXT_ICE_BALL = gameTime + Random(1, 5);

		if (timePlus5 > NEXT_ICE_CIRCLE)
			NEXT_ICE_CIRCLE = gameTime + Random(1, 5);

		if (timePlus5 > NEXT_PROJECTILE)
			NEXT_PROJECTILE = gameTime + Random(1, 5);

		if (timePlus5 > NEXT_METEOR)
			NEXT_METEOR = gameTime + Random(1, 5);
	}

	// game_damaged
	string MonstersElementalIceGuardian_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		PlayRandomSound(1, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);

		NEXT_CALM = GameTime() + 5.0f;

		if (GameTime() > NEXT_DODGE)
		{
			NEXT_DODGE = GameTime() + FREQ_DODGE;
			PlayAnim("critical", ANIM_DODGE);
			PROJECTILE_LOOP_ON = false;
			@DODGE_TARGET = attacker;
		}

		if (HealthOf(ENT_ME) < HALF_HP && GameTime() > NEXT_FLINCH)
		{
			NEXT_FLINCH = GameTime();
			PlayRandomSound(2, 10, SOUND_PAIN1, SOUND_PAIN2);
			NEXT_FLINCH += FREQ_FLINCH;
			ANIM_IDLE = "idle_scared";
			SetIdleAnim("idle_scared");
			PlayAnim("critical", ANIM_FLINCH_CUSTOM);
			PROJECTILE_LOOP_ON = false;
			if (!BE_AGGRESSIVE)
				SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, -600, 150)));
		}
		return result;
	}

	// frame_attack_pushr
	void MonstersElementalIceGuardian_OnFrameAttackPushr()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(-300, -100, 0)));
		PlaySound(0, 10, SOUND_DODGE);
		if (!IsAlive(DODGE_TARGET))
			return;
		if (RangeTo(DODGE_TARGET) < 200.0f)
			AddVelocity(DODGE_TARGET, RelativeVelocity(Vector3(VEL_DODGE_L, VEL_DODGE_F, 110)));
	}

	// my_target_died
	void MonstersElementalIceGuardian_OnMyTargetDied(string offender = "")
	{
		if (!(GameTime() > NEXT_TAUNT))
			return;
		NEXT_TAUNT = GameTime() + FREQ_TAUNT;
		PlayAnim("critical", ANIM_TAUNT);
		PROJECTILE_LOOP_ON = false;
	}

	// do_ice_circle
	// <origin>
	void MonstersElementalIceGuardian_OnDoIceCircle(Vector3 origin = Vector3())
	{
		PlaySound(0, 10, SOUND_SUMMON);
		ICE_CIRCLE_ACTIVE = true;
		ICE_CIRCLE_ORIGIN = origin;
		ICE_CIRCLE_ORIGIN.z = GroundHeight(ICE_CIRCLE_ORIGIN);
		ClientEvent("new", "all", "effects/sfx_seal", ICE_CIRCLE_ORIGIN, ICE_CIRCLE_FXRAD, 8, 15.0f, "freeze_solid");
		CallEventDelayed(1.0f, "ice_circle_loop");
		CallEventDelayed(15.0f, "ice_circle_end");
	}

	// ice_circle_end
	void MonstersElementalIceGuardian_OnIceCircleEnd()
	{
		ICE_CIRCLE_ACTIVE = false;
	}

	// ice_circle_loop
	void MonstersElementalIceGuardian_OnIceCircleLoop()
	{
		if (!ICE_CIRCLE_ACTIVE)
			return;
		CallEventDelayed(0.5f, "ice_circle_loop");

		CIRCLE_TARGS = LegacyFunction("get_tsphere", "enemy", ICE_CIRCLE_RAD, ICE_CIRCLE_ORIGIN);
		if (CIRCLE_TARGS == "none")
			return;
		int count = GetTokenCount(CIRCLE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCircleAffectTargets();
		}
	}

	// circle_affect_targets
	void MonstersElementalIceGuardian_OnCircleAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(CIRCLE_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_cold_freeze", 8.0f, self, DOT_FROST);
	}

	// staff_mode_switch
	void MonstersElementalIceGuardian_OnStaffModeSwitch()
	{
		if (!SHOCK_MODE)
		{
			SHOCK_MODE = true;
			PlaySound(0, 10, SOUND_STAFF_ON);
			Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 3, STAFF_BEAM_COLOR, 200, 10, FREQ_STAFF_MODE_CHANGE);
		}
		else
		{
			SHOCK_MODE = false;
		}
	}

	// do_shock_storm
	void MonstersElementalIceGuardian_OnDoShockStorm()
	{
		// shock storm
		OnDelaySpecials();
		SHOCK_STORM_ON = true;

		if (GUARD_ELEMENT == "ice")
		{
			ClientEvent("update", "all", CL_FX_INDEX, "shock_storm_on");
			OnShockStormLoop();
			CallEventDelayed(10.0f, "shock_storm_end"); // in case frame doesn't kick in

			Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 2, ENT_ME, 4, Vector3(128, 128, 255), 200, 60, 10.0f);
			@SHOCK_STORM_BEAM_ID = EntityOf(ENT_LASTCREATED);
			SHOCK_TARGS = FindInSphere("enemy", 1024);

			PlaySound(1, 10, SOUND_SHOCK_START);
			ServerPlaySound(3, 10, SOUND_SHOCK_LOOP);

			CUR_SHOCK_TARG_IDX = 0.0f;
		}

		if (GUARD_ELEMENT == "fire")
		{
			OnNpcatkSuspendRoam(10.0f);
			SetNoPush(true);

			// finding ground pos in funky way due to some sloppy mapping on Phobia
			Vector3 traceStart = OriginOf(ENT_ME);
			string traceEnd = Text(traceStart);
			traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, -1024.0f));
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");

			ClientEvent("update", "all", CL_FX_INDEX, "poison_storm_on", Vec(traceLine).z);
			OnPoisonStormLoop();
			CallEventDelayed(10.0f, "poison_storm_end"); // in case frame doesn't kick in

			Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 2, ENT_ME, 4, STAFF_BEAM_COLOR, 200, 60, 10.0f);
			@SHOCK_STORM_BEAM_ID = EntityOf(ENT_LASTCREATED);

			PlaySound(1, 10, SOUND_SHOCK_START);

			CUR_SHOCK_TARG_IDX = 0.0f;
		}
	}

	// poison_storm_loop
	void MonstersElementalIceGuardian_OnPoisonStormLoop()
	{
		if (!SHOCK_STORM_ON)
			return;
		CallEventDelayed(0.5f, "poison_storm_loop");
		STORM_TARGS = FindInSphere("enemy", 768);
		if (STORM_TARGS == "none")
			return;
		int count = GetTokenCount(STORM_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonStormAffectTargets();
		}
	}

	// poison_storm_affect_targets
	void MonstersElementalIceGuardian_OnPoisonStormAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(STORM_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison", 10.0f, self, GetVar("FLAME_JET_DOT"));
	}

	// poison_storm_end
	void MonstersElementalIceGuardian_OnPoisonStormEnd()
	{
		SetNoPush(false);
		SHOCK_STORM_ON = false;
		ServerPlaySound(3, 0, SOUND_SHOCK_LOOP);
		ClientEvent("update", "all", CL_FX_INDEX, "poison_storm_end");
		OnDelaySpecials();
	}

	// shock_storm_loop
	void MonstersElementalIceGuardian_OnShockStormLoop()
	{
		if (!SHOCK_STORM_ON)
			return;

		CallEventDelayed(0.5f, "shock_storm_loop");

		if (SHOCK_TARGS == "none")
			return;

		float nShockTargsM1 = GetTokenCount(SHOCK_TARGS) - 1.0f;

		if (CUR_SHOCK_TARG_IDX > nShockTargsM1)
			CUR_SHOCK_TARG_IDX = 0.0f;

		CBaseEntity@ curTarg = FindEntity(GetToken(SHOCK_TARGS, int(CUR_SHOCK_TARG_IDX)));

		Vector3 traceStart = AttachmentPositionOf(ENT_ME, 1);
		Vector3 traceEnd = OriginOf(curTarg);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine == Text(traceEnd))
		{
			PlaySound(0, 10, SOUND_SHOCK_HIT);
			float dotShock = DOT_SHOCK * 2.0f;
			DoDamageEx(@curTarg, "direct", dotShock, "100%", ENT_ME, ENT_ME, "none", "lightning");
			ApplyEffect(curTarg, "effects/dot_lightning", 5.0f, self, DOT_SHOCK);
			Vector3 targOrg = OriginOf(curTarg);
			Vector3 myOrg = OriginOf(ENT_ME);
			float newYaw = AnglesTo(myOrg, targOrg);
			AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, VEL_SHOCK_F, 110)));
			Effect("beam", "update", @SHOCK_STORM_BEAM_ID, "end_target", @curTarg);
			Effect("beam", "update", @SHOCK_STORM_BEAM_ID, "brightness", 200);
		}
		else
		{
			Effect("beam", "update", @SHOCK_STORM_BEAM_ID, "end_target", ENT_ME);
			Effect("beam", "update", @SHOCK_STORM_BEAM_ID, "brightness", 0);
		}

		CUR_SHOCK_TARG_IDX += 1.0f;
	}

	// shock_storm_end
	void MonstersElementalIceGuardian_OnShockStormEnd()
	{
		SHOCK_STORM_ON = false;
		ServerPlaySound(3, 0, SOUND_SHOCK_LOOP);
		ClientEvent("update", "all", CL_FX_INDEX, "shock_storm_end");
		OnDelaySpecials();
	}

	// ext_shender_fail
	void MonstersElementalIceGuardian_OnExtShenderFail()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// set_agro
	void MonstersElementalIceGuardian_OnSetAgro()
	{
		BE_AGGRESSIVE = true;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
		MonstersElementalIceGuardian_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
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
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		MonstersElementalIceGuardian_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		MonstersElementalIceGuardian_OnNpcatkHunt();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		MonstersElementalIceGuardian_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MonstersElementalIceGuardian_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		MonstersElementalIceGuardian_OnCycleDown();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, MonstersElementalIceGuardian_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
		MonstersElementalIceGuardian_OnNpcTargetsighted(target);
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		BasePropelled_OnGameStopmoving(); // monsters/base_propelled
		MonstersElementalIceGuardian_OnGameStopmoving();
	}

	void OnFinalizeNpc() { MonstersElementalIceGuardian_OnFinalizeNpc(); } // finalize_npc
	void OnRefreshClientFx() { MonstersElementalIceGuardian_OnRefreshClientFx(); } // refresh_client_fx
	void OnRestoreRoam() { MonstersElementalIceGuardian_OnRestoreRoam(); } // restore_roam
	void OnFrameAlert() { MonstersElementalIceGuardian_OnFrameAlert(); } // frame_alert
	void OnFrameTaunt() { MonstersElementalIceGuardian_OnFrameTaunt(); } // frame_taunt
	void OnFrameMultiProjectileStart() { MonstersElementalIceGuardian_OnFrameMultiProjectileStart(); } // frame_multi_projectile_start
	void OnFrameMultiProjectileEnd() { MonstersElementalIceGuardian_OnFrameMultiProjectileEnd(); } // frame_multi_projectile_end
	void OnProjectileLoop() { MonstersElementalIceGuardian_OnProjectileLoop(); } // projectile_loop
	void OnFrameProjectile() { MonstersElementalIceGuardian_OnFrameProjectile(); } // frame_projectile
	void OnDoProjectile(Vector3 offset = Vector3()) { MonstersElementalIceGuardian_OnDoProjectile(offset); } // do_projectile
	void OnProjectileStrike() { MonstersElementalIceGuardian_OnProjectileStrike(); } // projectile_strike
	void OnFrameSummon() { MonstersElementalIceGuardian_OnFrameSummon(); } // frame_summon
	void OnFrameSpell() { MonstersElementalIceGuardian_OnFrameSpell(); } // frame_spell
	void OnBurstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MonstersElementalIceGuardian_OnBurstDodamage(hit, target, start, end, damageType, damageText); } // burst_dodamage
	void OnFlamejetDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MonstersElementalIceGuardian_OnFlamejetDodamage(hit, target, start, end, damageType, damageText); } // flamejet_dodamage
	void OnFrameAttack() { MonstersElementalIceGuardian_OnFrameAttack(); } // frame_attack
	void OnFrameAttackPush() { MonstersElementalIceGuardian_OnFrameAttackPush(); } // frame_attack_push
	void OnPushatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MonstersElementalIceGuardian_OnPushatkDodamage(hit, target, start, end, damageType, damageText); } // pushatk_dodamage
	void OnFrameAttackThrow() { MonstersElementalIceGuardian_OnFrameAttackThrow(); } // frame_attack_throw
	void OnThrowatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MonstersElementalIceGuardian_OnThrowatkDodamage(hit, target, start, end, damageType, damageText); } // throwatk_dodamage
	void OnFrameSmash() { MonstersElementalIceGuardian_OnFrameSmash(); } // frame_smash
	void OnBurstAffectTargets() { MonstersElementalIceGuardian_OnBurstAffectTargets(); } // burst_affect_targets
	void OnFrameLongAttack() { MonstersElementalIceGuardian_OnFrameLongAttack(); } // frame_long_attack
	void OnLongatkDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { MonstersElementalIceGuardian_OnLongatkDodamage(hit, target, start, end, damageType, damageText); } // longatk_dodamage
	void OnDelaySpecials() { MonstersElementalIceGuardian_OnDelaySpecials(); } // delay_specials
	void OnFrameAttackPushr() { MonstersElementalIceGuardian_OnFrameAttackPushr(); } // frame_attack_pushr
	void OnDoIceCircle(Vector3 origin = Vector3()) { MonstersElementalIceGuardian_OnDoIceCircle(origin); } // do_ice_circle
	void OnIceCircleEnd() { MonstersElementalIceGuardian_OnIceCircleEnd(); } // ice_circle_end
	void OnIceCircleLoop() { MonstersElementalIceGuardian_OnIceCircleLoop(); } // ice_circle_loop
	void OnCircleAffectTargets() { MonstersElementalIceGuardian_OnCircleAffectTargets(); } // circle_affect_targets
	void OnStaffModeSwitch() { MonstersElementalIceGuardian_OnStaffModeSwitch(); } // staff_mode_switch
	void OnDoShockStorm() { MonstersElementalIceGuardian_OnDoShockStorm(); } // do_shock_storm
	void OnPoisonStormLoop() { MonstersElementalIceGuardian_OnPoisonStormLoop(); } // poison_storm_loop
	void OnPoisonStormAffectTargets() { MonstersElementalIceGuardian_OnPoisonStormAffectTargets(); } // poison_storm_affect_targets
	void OnPoisonStormEnd() { MonstersElementalIceGuardian_OnPoisonStormEnd(); } // poison_storm_end
	void OnShockStormLoop() { MonstersElementalIceGuardian_OnShockStormLoop(); } // shock_storm_loop
	void OnShockStormEnd() { MonstersElementalIceGuardian_OnShockStormEnd(); } // shock_storm_end
	void OnExtShenderFail() { MonstersElementalIceGuardian_OnExtShenderFail(); } // ext_shender_fail
	void OnSetAgro() { MonstersElementalIceGuardian_OnSetAgro(); } // set_agro
	void OnHitDelay() {} // HIT_DELAY

	// This file's events and timers by their .script names
	bool MonstersElementalIceGuardian_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "burst_dodamage") { OnBurstDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "circle_affect_targets") { OnCircleAffectTargets(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "delay_specials") { OnDelaySpecials(); return true; }
		if (name == "do_ice_circle") { OnDoIceCircle(Vec(Param(params, 0))); return true; }
		if (name == "do_projectile") { OnDoProjectile(Vec(Param(params, 0))); return true; }
		if (name == "do_shock_storm") { OnDoShockStorm(); return true; }
		if (name == "ext_shender_fail") { OnExtShenderFail(); return true; }
		if (name == "finalize_npc") { OnFinalizeNpc(); return true; }
		if (name == "flamejet_dodamage") { OnFlamejetDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "frame_alert") { OnFrameAlert(); return true; }
		if (name == "frame_attack") { OnFrameAttack(); return true; }
		if (name == "frame_attack_push") { OnFrameAttackPush(); return true; }
		if (name == "frame_attack_pushr") { OnFrameAttackPushr(); return true; }
		if (name == "frame_attack_throw") { OnFrameAttackThrow(); return true; }
		if (name == "frame_long_attack") { OnFrameLongAttack(); return true; }
		if (name == "frame_multi_projectile_end") { OnFrameMultiProjectileEnd(); return true; }
		if (name == "frame_multi_projectile_start") { OnFrameMultiProjectileStart(); return true; }
		if (name == "frame_projectile") { OnFrameProjectile(); return true; }
		if (name == "frame_smash") { OnFrameSmash(); return true; }
		if (name == "frame_spell") { OnFrameSpell(); return true; }
		if (name == "frame_summon") { OnFrameSummon(); return true; }
		if (name == "frame_taunt") { OnFrameTaunt(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "ice_circle_end") { OnIceCircleEnd(); return true; }
		if (name == "ice_circle_loop") { OnIceCircleLoop(); return true; }
		if (name == "longatk_dodamage") { OnLongatkDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "poison_storm_affect_targets") { OnPoisonStormAffectTargets(); return true; }
		if (name == "poison_storm_end") { OnPoisonStormEnd(); return true; }
		if (name == "poison_storm_loop") { OnPoisonStormLoop(); return true; }
		if (name == "projectile_loop") { OnProjectileLoop(); return true; }
		if (name == "projectile_strike") { OnProjectileStrike(); return true; }
		if (name == "pushatk_dodamage") { OnPushatkDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "refresh_client_fx") { OnRefreshClientFx(); return true; }
		if (name == "restore_roam") { OnRestoreRoam(); return true; }
		if (name == "set_agro") { OnSetAgro(); return true; }
		if (name == "shock_storm_end") { OnShockStormEnd(); return true; }
		if (name == "shock_storm_loop") { OnShockStormLoop(); return true; }
		if (name == "staff_mode_switch") { OnStaffModeSwitch(); return true; }
		if (name == "throwatk_dodamage") { OnThrowatkDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/elemental_ice_guardian"]
shared class MonstersElementalIceGuardianScript : BaseMonsterNewScript, MonstersElementalIceGuardian, BaseFlyerGrav, BasePropelled
{
	// Variables every script that includes this file declares
	string NPC_BASE_EXP = "NPC_BASE_EXP";

	// Variables declared by included files, with the value they start with in this script
	MonstersElementalIceGuardianScript()
	{
		ANIM_IDLE = "idle_ready";
		ANIM_WALK = "walk";
		IMMUNE_VAMPIRE = true;
		SOUND_DEATH = "monsters/ice_guardian/c_elemwatr_dead.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ice_guardian.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersElementalIceGuardian_FirstThink();
		MonstersElementalIceGuardian_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MonstersElementalIceGuardian_DispatchEvent(name, params)
			|| BaseFlyerGrav_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
