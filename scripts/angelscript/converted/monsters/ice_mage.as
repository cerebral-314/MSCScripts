#pragma context server

// Converted from monsters/ice_mage.script by msc_transpiler.
// Ice Mage for Crow by Thothie
// - Freeze Ray attack - makes player slow in increments
// - (will need to add new effect with player setvard)
// - (if starts eating too much time, just use frostbolt)
// - swipes with freeze effect
// - fast frostbolt
// - blizzard (make sure, if multiple are present, only one uses blizz at a time)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ice_mage"]
class MonstersIceMage : BaseMonsterNewScript
{
	// Constants
	float FREQ_TELE = 0.0f;
	string ANIM_IDLE_ALERT = "alert_idle";
	string ANIM_JUMP = "long_jump";
	string ANIM_FREEZE_RAY = "ref_shoot_rayspell";
	string ANIM_CAST = "cast";
	string ANIM_FLY = "jump";
	string ANIM_LOOK = "look";
	string ANIM_DEATH1 = "die_simple";
	string ANIM_DEATH2 = "die_backwards1";
	string ANIM_DEATH3 = "die_backwards";
	string ANIM_DEATH4 = "die_forwards";
	string ANIM_DEATH5 = "headshot";
	string ANIM_DEATH6 = "die_spin";
	string ANIM_DEATH7 = "gutshot";
	string LIGHT_COLOR = "LIGHT_COLOR";
	int LIGHT_RAD = 96;
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";
	string DMG_SWIPE = "DMG_SWIPE";
	int DMG_STAFF = 0;
	int DMG_BOLT = 0;
	int DMG_DOT_BOLT = 0;
	int DMG_SOLID = 0;
	float DMG_BEAM = 3.0f;
	int FBEAM_RANGE = 1024;
	string ATTACK_HITCHANCE = "95%";
	string FREQ_BOLT = "2.0";
	float FREQ_FREEZE = 1.0f;
	float FREQ_FREEZE_SOUND = 1.6f;
	float BOLT_SPEED = 300.0f;
	string SOUND_SWIPE = "weapons/swingsmall.wav";
	string SOUND_FROSTBOLT = "magic/frost_pulse.wav";
	string SOUND_FREEZE_BEAM = "magic/freezeray_loop.wav";
	string SOUND_BLIZZARD = "doors/aliendoor3.wav";
	string SOUND_STUCK1 = "debris/glass1.wav";
	string SOUND_STUCK2 = "debris/glass2.wav";
	string SOUND_TELE = "magic/teleport.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float PROJSET_DURATION = 0.0f;
	int PROJSET_DAMAGE = 0;
	string BEAM_ID = "BEAM_ID";
	bool BEAM_ON = false;
	bool BOLT_DELAY = false;
	bool FREEZE_SOUND_DELAY = false;
	bool FBEAM_ATTACK = false;
	string BEAM_TRACE_START = "BEAM_TRACE_START";
	string BEAM_TRACE_END = "BEAM_TRACE_END";
	bool BEAM_DEFINED = false;
	string BEAM_TARGET = "BEAM_TARGET";
	string NEW_FREEZE_TARGET = "NEW_FREEZE_TARGET";
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	string OWNER_ID = "OWNER_ID";
	bool ICE_SUMMONED = false;
	float N_TELES = 0.0f;
	string TELE_ID1 = "TELE_ID1";
	string TELE_ID2 = "TELE_ID2";
	string TELE_ID3 = "TELE_ID3";
	string TELE_ID4 = "TELE_ID4";
	int FOUND_NEAR_TARGET = 0;
	int SEARCH_RAD = 0;
	Vector3 TELE_DEST = Vector3();
	Vector3 TELE_ANG = Vector3();
	Vector3 TELE_ANGS = Vector3();
	float LAST_TELE = 0.0f;
	float RENDER_COUNT = 0.0f;
	string NEAR_DEST = "NEAR_DEST";
	bool BUGGER_IN_WAY = false;
	float BUGGER_IN_WAY_COUNT = 0.0f;
	CBaseEntity@ BUGGER_ID = null;
	string NEW_TARGET = "NEW_TARGET";

	// Variables declared by included files, with the value they start with in this script
	MonstersIceMage()
	{
		ANIM_IDLE = "idle";
		SOUND_DEATH = "voices/kcult_pain1.wav";
	}

	// unnamed block (first think)
	void MonstersIceMage_FirstThink()
	{
		IS_UNHOLY = true;

		// base anims
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "ref_shoot_staff"; // staff_strike
		ANIM_DEATH = "die_simple";

		// base stats
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 170.0f;
		ATTACK_MOVERANGE = 300.0f;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 20);

		NPC_GIVE_EXP = 350.0f;
	}

	// npc_post_spawn
	void MonstersIceMage_OnNpcPostSpawn()
	{
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("poison", 0.5f);

		OnLightMe();

		// effect beam end lgtning.spr 10 L_BEAM_START BEAM_TARGET 0 (200,200,255) 255 0 BEAM_DUR
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 1, ENT_ME, 2, Vector3(200, 200, 255), 0, 0, -1);
		BEAM_ID = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// game_death
	void MonstersIceMage_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (GetVar("G_BEAMER") == EntityId(self))
			SetGlobal("G_BEAMER", "unset");
		if (GetVar("G_BEAMER") == EntityId(self))
			SetGlobal("G_ICE_TELE", 0);
		if (ICE_SUMMONED)
			CallExternal(OWNER_ID, "ext_ice_mage_died");

		Effect("beam", "update", BEAM_ID, "remove", 0.1f);

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
	}

	// npcatk_hunt
	void MonstersIceMage_OnNpcatkHunt()
	{
		if (EntityOf(GetVar("G_BEAMER")) !is self && BEAM_ON)
		{
			Effect("beam", "update", BEAM_ID, "brightness", 0);
			BEAM_ON = false;
		}
	}

	// npcatk_hunt
	void MonstersIceMage_OnNpcatkHunt_2()
	{
		if (!CanSee(NPCATK_TARGET))
			ATTACK_MOVERANGE = Float(Eval("game.monster.moveprox"));
		if (CanSee(NPCATK_TARGET))
			ATTACK_MOVERANGE = 300.0f;

		if (EntityOf(GetVar("G_BEAMER")) !is self)
			return;
		if (RangeTo(NPCATK_TARGET) > FBEAM_RANGE)
			SetGlobal("G_BEAMER", "unset");
		if (!CanSee(NPCATK_TARGET))
			SetGlobal("G_BEAMER", "unset");
	}

	// game_dodamage
	string MonstersIceMage_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (FBEAM_ATTACK)
		{
			FBEAM_ATTACK = false;
			Vector3 traceStart = OriginOf(ENT_ME);
			float myYaw = MyAngles().y;
			traceStart += Vec(FINGER_ADJ); // start fingers
			Vector3 traceEnd = OriginOf(NPCATK_TARGET);
			string traceIt = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
			CBaseEntity@ myFinger = self;
			BEAM_TRACE_START = Text(traceStart);
			BEAM_TRACE_END = traceIt;
			BEAM_DEFINED = true;

			if (hit)
			{
				ApplyEffect(target, "effects/dot_cold", 1, self, Random(5, 15), "none");
				BEAM_TARGET = EntityId(target);
				Effect("beam", "update", BEAM_ID, "end_target", BEAM_TARGET, 0);
			}
		}
		return result;
	}

	// npc_post_spawn
	// Glow fx ============
	// call at spawn or cycle_up
	void MonstersIceMage_OnNpcPostSpawn_2()
	{
		ClientEvent("persist", "all", "monsters/lighted_cl", IndexOf(ENT_ME), LIGHT_COLOR, LIGHT_RAD);
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// game_death
	void MonstersIceMage_OnGameDeath_2(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ServerPlaySound(2, 0, SOUND_FREEZE_BEAM);
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		ClientEvent("update", "all", MY_LIGHT_SCRIPT, "remove_me");
	}

	// unnamed block (timer)
	void MonstersIceMage_Timer()
	{
		CallEventDelayed(FREQ_TELE, "MonstersIceMage_Timer");

		if (!(N_TELES > 0.0f))
			return;

		// prevent tele merges
		float lastTeleDiff = GameTime() - Float(GetVar("G_ICE_TELE"));
		if (!(lastTeleDiff > 5.0f))
			return;

		if (Truthy(LegacyFunction("cansee", NPCATK_TARGET, 256)))
			return;

		float totalTeles = N_TELES + 1.0f;

		// find if any players are near my teleport points
		// if the are, teleport there and target them
		SetVar("PLAYER_LIST", GetActivePlayers());
		FOUND_NEAR_TARGET = 0;
		SEARCH_RAD = 512;
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnFindNearTeleporter();
		}

		if (!(FOUND_NEAR_TARGET > 0))
			return;

		OnNpcatkSettarget(NEW_TARGET);
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", "ICE_MAGE: found " + NameOf(NEW_TARGET) + " near " + FOUND_NEAR_TARGET);
		int pickTele = FOUND_NEAR_TARGET;

		if (pickTele == 1)
		{
			TELE_DEST = OriginOf(TELE_ID1);
			TELE_ANG = AnglesOf(TELE_ID1);
			CallExternal(TELE_ID1, "tele_used");
		}
		if (pickTele == 2)
		{
			TELE_DEST = OriginOf(TELE_ID2);
			TELE_ANG = AnglesOf(TELE_ID2);
			CallExternal(TELE_ID2, "tele_used");
		}
		if (pickTele == 3)
		{
			TELE_DEST = OriginOf(TELE_ID3);
			TELE_ANG = AnglesOf(TELE_ID3);
			CallExternal(TELE_ID3, "tele_used");
		}
		if (pickTele == 4)
		{
			TELE_DEST = OriginOf(TELE_ID4);
			TELE_ANG = AnglesOf(TELE_ID4);
			CallExternal(TELE_ID4, "tele_used");
		}
		if (pickTele > N_TELES)
		{
			TELE_DEST = NPC_SPAWN_LOC;
			TELE_DEST.z += 128.0f;
			TELE_ANGS = NPC_SPAWN_ANGLES;
		}

		CreateNpc("monsters/summon/ibarrier", TELE_DEST, self, 64, 2, 0, 0, 0, 1); // <owner> <rad> <duration> [invisible:0|1] [silent:0|1] [dmg] [push_allys:0|1]
		LAST_TELE = GameTime();
		SetGlobal("G_ICE_TELE", GameTime());
		CallEventDelayed(0.25f, "flicker_out");
		CallEventDelayed(0.75f, "tele_out");
		CallEventDelayed(1.5f, "tele_in");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		MonstersIceMage_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
		MonstersIceMage_OnGameDeath_2(attacker, extraValue2, extraValue3, extraValue4);
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
		MonstersIceMage_OnNpcPostSpawn();
		MonstersIceMage_OnNpcPostSpawn_2();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		SetName(creatorValue1);
		OWNER_ID = creatorValue2; // violates convention
		ICE_SUMMONED = true;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 8, SOUND_STUCK1, SOUND_STUCK2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		if (!ICE_SUMMONED)
			SetName("Ice Mage");
		SetModel("monsters/ice_mage.mdl");
		SetHealth(1500);
		SetRace("demon");
		SetWidth(32);
		SetHeight(72);
		SetRoam(true);
		SetHearingSensitivity(4);

		SetFly(false);

		SetProp(ENT_ME, "skin", 1);

		PROJSET_DURATION = 10.0f;
		PROJSET_DAMAGE = DMG_DOT_BOLT;

		CallEventDelayed(1.0f, "get_teleporters");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		MonstersIceMage_OnNpcatkHunt();
		MonstersIceMage_OnNpcatkHunt_2();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		ServerPlaySound(2, 0, SOUND_FREEZE_BEAM);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, MonstersIceMage_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		bool exitSub = false;

		// projectiles
		if (I_R_FROZEN) // not possible currently, but may change in future (other paralysis spell)
			return;

		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;

		if (!BOLT_DELAY && EntityOf(GetVar("G_BEAMER")) !is self)
		{
			BOLT_DELAY = true;
			CallEventOrDelay(FREQ_BOLT, "reset_bolt_delay");
			PlayAnim("critical", ANIM_CAST);

			Vector3 pos = OriginOf(ENT_ME);
			pos.z += 62.0f;

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_ice_bolt2", pos, NPCATK_TARGET, BOLT_SPEED, DMG_BOLT, 0, "none");
			PlaySound(0, 10, SOUND_FROSTBOLT);
		}

		if (IsAlive(GetVar("G_BEAMER")) && EntityOf(GetVar("G_BEAMER")) !is self)
			exitSub = true;
		if (exitSub)
			return;

		if (Truthy(ScriptVarOf(NPCATK_TARGET, "PL_I_R_FROZEN")))
			SetGlobal("G_BEAMER", "unset");

		if (Float(ScriptVarOf(NPCATK_TARGET, "PL_I_R_FROZEN")) == 1.0f)
			return;
		if (!(RangeTo(NPCATK_TARGET) < FBEAM_RANGE))
			return;

		if (!FREEZE_SOUND_DELAY)
		{
			ServerPlaySound(2, 5, SOUND_FREEZE_BEAM);
			FREEZE_SOUND_DELAY = true;
			CallEventDelayed(FREQ_FREEZE_SOUND, "reset_freeze_sound_delay");
			if (BEAM_DEFINED)
			{
				Vector3 beamStart = MyOrigin();
				float myYaw = MyAngles().y;
				beamStart += Vec(FINGER_ADJ);
				float beamDur = FREQ_FREEZE_SOUND + 0.25f;
			}
		}

		// effect beam end lgtning.spr 10 L_BEAM_START BEAM_TARGET 0 (200,200,255) 255 0 BEAM_DUR
		// effect beam end BEAM_SPRITE 30 BEAM_START PULL_TARGET 0 (255,255,0) 200 30 1.5
		// effect beam point lgtning.spr 10 BEAM_TRACE_START BEAM_TRACE_END (200,200,255) 255 0 FREQ_FREEZE_SOUND
		AS_ATTACKING = GameTime();
		PlayAnim("once", "cast"); // ref_rayspell looks crappy
		FBEAM_ATTACK = true;
		SetGlobal("G_BEAMER", self);
		if (!BEAM_ON)
		{
			Effect("beam", "update", BEAM_ID, "brightness", 255);
			BEAM_ON = true;
		}
		OnNpcatkDodamage(NPCATK_TARGET, Text(FBEAM_RANGE), Text(DMG_BEAM), "100%", "cold");
	}

	// reset_freeze_sound_delay
	void OnResetFreezeSoundDelay()
	{
		ServerPlaySound(2, 0, SOUND_FREEZE_BEAM);
		FREEZE_SOUND_DELAY = false;
	}

	// reset_bolt_delay
	void OnResetBoltDelay()
	{
		BOLT_DELAY = false;
	}

	// reset_freeze_target
	void OnResetFreezeTarget()
	{
		NEW_FREEZE_TARGET = "unset";
	}

	// staff_strike
	void OnStaffStrike()
	{
		ServerPlaySound(2, 0, SOUND_FREEZE_BEAM);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_STAFF), ATTACK_HITCHANCE, "pierce");
		if (RandomInt(1, 5) == 1)
			OnNpcatkFlee(NPCATK_TARGET, "512", "5.0");
		if (EntityOf(GetVar("G_BEAMER")) is self)
			SetGlobal("G_BEAMER", "unset");
	}

	// get_teleporters
	void OnGetTeleporters()
	{
		N_TELES = 0.0f;

		TELE_ID1 = EntityId(FindByName("sorc_telepoint1"));
		TELE_ID2 = EntityId(FindByName("sorc_telepoint2"));
		TELE_ID3 = EntityId(FindByName("sorc_telepoint3"));
		TELE_ID4 = EntityId(FindByName("sorc_telepoint4"));

		if (Exists(TELE_ID1))
			N_TELES += 1.0f;
		if (Exists(TELE_ID2))
			N_TELES += 1.0f;
		if (Exists(TELE_ID3))
			N_TELES += 1.0f;
		if (Exists(TELE_ID4))
			N_TELES += 1.0f;
	}

	// flicker_out
	void OnFlickerOut()
	{
		RENDER_COUNT -= 50.0f;
		if (!(RENDER_COUNT > 0.0f))
			return;
		CallEventDelayed(0.1f, "flicker_out");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RENDER_COUNT);
	}

	// tele_out
	void OnTeleOut()
	{
		PlaySound(0, 10, SOUND_TELE);
		SetOrigin(ENT_ME, Vector3(-20000, 10000, -20000));
	}

	// tele_in
	void OnTeleIn()
	{
		bool exitSub = false;

		// check for targets in dest path
		NEAR_DEST = LegacyFunction("get_tsphere", "any", 64, TELE_DEST);
		BUGGER_IN_WAY = false;
		int count = GetTokenCount(NEAR_DEST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckNearDest();
		}
		if (BUGGER_IN_WAY)
		{
			BUGGER_IN_WAY_COUNT += 1.0f;
			DebugPrint("tele_in " + NameOf(BUGGER_ID) + " / " + ScriptVarOf(BUGGER_ID, "IS_TELE") + " @ " + Text(TELE_DEST));
			CallEventDelayed(0.1f, "tele_in");
			exitSub = true;
		}
		if (exitSub)
			return;

		BUGGER_IN_WAY_COUNT = 0.0f;

		SetOrigin(ENT_ME, TELE_DEST);
		SetAngle("face", TELE_ANGS);
		PlaySound(0, 10, SOUND_TELE);
		RENDER_COUNT = 0.0f;
		OnFlickerIn();
		LAST_TELE = GameTime();
		SetGlobal("G_ICE_TELE", GameTime());
	}

	// check_near_dest
	void OnCheckNearDest()
	{
		bool entOkay = false;
		CBaseEntity@ curEnt = FindEntity(GetToken(NEAR_DEST, loopIteration));
		if (Contains(NameOf(curEnt), "Barrier"))
			entOkay = true;
		if (Truthy(ScriptVarOf(curEnt, "IS_TELE")))
			entOkay = true;
		if (entOkay)
			return;
		BUGGER_IN_WAY = true;
		@BUGGER_ID = curEnt;
	}

	// flicker_in
	void OnFlickerIn()
	{
		RENDER_COUNT += 50.0f;
		if (RENDER_COUNT >= 255.0f)
		{
			SetProp(ENT_ME, "rendermode", 0);
			SetProp(ENT_ME, "renderamt", 255);
		}
		if (!(RENDER_COUNT < 255.0f))
			return;
		CallEventDelayed(0.1f, "flicker_in");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RENDER_COUNT);
	}

	// find_near_teleporter
	void OnFindNearTeleporter()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		Vector3 playerOrg = OriginOf(curPlayer);

		if (FOUND_NEAR_TARGET != 0)
			return;

		if (!(N_TELES >= 1.0f))
			return;
		Vector3 testTele = OriginOf(TELE_ID1);
		testTele.z = GroundHeight(testTele);
		if (Distance(playerOrg, testTele) < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 1;
			NEW_TARGET = curPlayer;
		}

		if (!(N_TELES >= 2.0f))
			return;
		testTele = OriginOf(TELE_ID2);
		testTele.z = GroundHeight(testTele);
		if (Distance(playerOrg, testTele) < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 2;
			NEW_TARGET = curPlayer;
		}

		if (!(N_TELES >= 3.0f))
			return;
		testTele = OriginOf(TELE_ID3);
		testTele.z = GroundHeight(testTele);
		if (Distance(playerOrg, testTele) < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 3;
			NEW_TARGET = curPlayer;
		}

		if (!(N_TELES >= 4.0f))
			return;
		testTele = OriginOf(TELE_ID4);
		testTele.z = GroundHeight(testTele);
		if (Distance(playerOrg, testTele) < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 4;
			NEW_TARGET = curPlayer;
		}

		testTele = NPC_SPAWN_LOC;
		if (Distance(playerOrg, testTele) < SEARCH_RAD)
		{
			FOUND_NEAR_TARGET = 5;
			NEW_TARGET = curPlayer;
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqBolt() {} // FREQ_BOLT
	void OnFreqFreezeSound() {} // FREQ_FREEZE_SOUND
	void OnLightMe() {} // light_me

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ice_mage.mdl");
		Precache("magic/freezeray_loop.wav");
		CallEventDelayed(FREQ_TELE, "MonstersIceMage_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersIceMage_FirstThink();
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
		if (name == "check_near_dest") { OnCheckNearDest(); return true; }
		if (name == "find_near_teleporter") { OnFindNearTeleporter(); return true; }
		if (name == "flicker_in") { OnFlickerIn(); return true; }
		if (name == "flicker_out") { OnFlickerOut(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_teleporters") { OnGetTeleporters(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "reset_bolt_delay") { OnResetBoltDelay(); return true; }
		if (name == "reset_freeze_sound_delay") { OnResetFreezeSoundDelay(); return true; }
		if (name == "reset_freeze_target") { OnResetFreezeTarget(); return true; }
		if (name == "staff_strike") { OnStaffStrike(); return true; }
		if (name == "tele_in") { OnTeleIn(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		if (name == "MonstersIceMage_Timer") { MonstersIceMage_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
