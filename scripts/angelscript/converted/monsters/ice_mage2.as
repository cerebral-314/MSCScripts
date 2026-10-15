#pragma context server

// Converted from monsters/ice_mage2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/ice_mage2"]
class IceMage2 : BaseMonsterNewScript
{
	// Constants
	string ANIM_BURST = "crouch_idle";
	string ANIM_IDLE_ALERT = "alert_idle";
	string ANIM_FREEZE_RAY = "ref_shoot_rayspell";
	string ANIM_FLY = "jump";
	string ANIM_LOOK = "look";
	float FREQ_DODGE = 5.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	int LIGHT_RAD = 96;
	float FREQ_BURST = 0.0f;
	float FREQ_BURST_SHORT = 10.0f;
	float DOT_FREEZE = 100.0f;
	float FREEZE_RAY_BASEDOT = 25.0f;
	bool FREEZE_RAY_SLOW_AMT = true;
	string SOUND_FREEZE_RAY = "magic/freezeray_loop.wav";
	string SOUND_BURST_CHARGE = "weapons/magic/ice_powerup.wav";
	string SOUND_BURST = "weapons/magic/frost_reverse.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NExT_BURST = 0.0f;
	float NEXT_BURST = 0.0f;
	bool DOING_BURST = false;
	string CL_LIGHT_IDX = "CL_LIGHT_IDX";
	float NEXT_CL_REFRESH = 0.0f;
	float NEXT_DODGE = 0.0f;
	bool DOING_BEAM = false;
	string LAST_BEAM = "LAST_BEAM";
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
	IceMage2()
	{
		ANIM_IDLE = "idle";
	}

	// unnamed block (first think)
	void IceMage2_FirstThink()
	{
		// base anims
		ANIM_IDLE = "idle";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_simple";

		MOVE_RANGE = "512";
		ATTACK_MOVERANGE = 512.0f;
		ATTACK_RANGE = 1024.0f;
		ATTACK_HITRANGE = 1024.0f;
		ANIM_ATTACK = "ref_shoot_staff"; // staff_strike

		NPC_GIVE_EXP = 1000.0f;

		NPC_RANGED = "1";
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string IceMage2_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (Contains(damageType, "effect"))
		{
			bool noDodge = true;
		}
		if (!(GameTime() > NEXT_DODGE))
			return result;
		NEXT_DODGE = GameTime() + FREQ_DODGE;
		OnShadowShift();
		return result;
	}

	// unnamed block (timer)
	void IceMage2_Timer()
	{
		CallEventDelayed(0.0f, "IceMage2_Timer");

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
		ClientEvent("remove", "all", CL_LIGHT_IDX);
		if (DOING_BEAM)
			OnBeamEnd();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Frost Mage");
		SetModel("monsters/ice_mage.mdl");
		SetHealth(4000);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("poison", 0.5f);

		SetWidth(32);
		SetHeight(96);
		SetRoam(true);
		SetHearingSensitivity(4);
		SetProp(ENT_ME, "skin", 1);

		NExT_BURST = GameTime();
		NEXT_BURST += FREQ_BURST;

		CallEventDelayed(1.0f, "get_teleporters");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (NPCATK_TARGET == "unset" && DOING_BEAM)
			OnBeamEnd();

		if (NPCATK_TARGET == "unset")
			return;
		if (GameTime() > NEXT_CL_REFRESH)
		{
			ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), LIGHT_COLOR, LIGHT_RAD, 15.0f);
			CL_LIGHT_IDX = LastClientScriptId();
			NEXT_CL_REFRESH = GameTime() + 15.0f;
		}

		if (DOING_BURST)
			return;
		if (CanSee(NPCATK_TARGET))
		{
			if (!DOING_BEAM)
				OnBeamStart();
			else
				ApplyEffect(NPCATK_TARGET, "effects/dot_cold", 10, self, FREEZE_RAY_BASEDOT, "none");
		}
		else if (DOING_BEAM)
			OnBeamEnd();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, IceMage2_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		NEXT_BURST = GameTime() + FREQ_BURST;

		if (GameTime() > NEXT_BURST)
		{
			if (RangeTo(NPCATK_TARGET) < 200.0f)
				OnDoBurst();
			else
				NEXT_BURST = GameTime() + FREQ_BURST_SHORT;
		}
	}

	// do_burst
	void OnDoBurst()
	{
		if (DOING_BEAM)
			OnBeamEnd();
		DOING_BURST = true;
		SetRoam(false);
		OnNpcatkSuspendMovement("crouch_aim_staff", "6.0");
		OnNpcatkSuspendAi("6.0");
		PlaySound(0, 10, SOUND_BURST_CHARGE);
		CallEventDelayed(3.0f, "do_burst2");
		CallEventDelayed(6.0f, "do_burst3");
		ClientEvent("new", "all", "effects/sfx_burst_sphere", OriginOf(ENT_ME));
	}

	// do_burst2
	void OnDoBurst2()
	{
		PlaySound(0, 10, SOUND_BURST);
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, DOT_FREEZE, "100%", ENT_ME, ENT_ME, "none", "cold_effect", "dmgevent:freeze");
	}

	// do_burst3
	void OnDoBurst3()
	{
		SetRoam(true);
		DOING_BURST = false;
	}

	// freeze_dodamage
	void OnFreezeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_cold_freeze", 7.0f, self, DOT_FREEZE, "none", 9999);
	}

	// shadow_shift
	void OnShadowShift()
	{
		ClientEvent("persist", "all", "effects/sfx_motionblur_temp", IndexOf(ENT_ME), 0, 1, 3.0f);
		float rndAng = Random(0, 359);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, rndAng, 0), Vector3(0, 1000, 0)));
		PlaySound(0, 10, "SOUND_DODGE");
		CallEventDelayed(0.25f, "stop_shadow_shift");
	}

	// stop_shadow_shift
	void OnStopShadowShift()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
	}

	// beam_start
	void OnBeamStart()
	{
		DOING_BEAM = true;
		Effect("beam", "ents", "lgtning.spr", 1, NPCATK_TARGET, 1, ENT_ME, 1, Vector3(0, 128, 255), 200, 0, 60.0f);
		LAST_BEAM = ENT_LASTCREATED;
		PlaySound(1, 10, SOUND_FREEZE_RAY);
	}

	// beam_end
	void OnBeamEnd()
	{
		if (DOING_BEAM)
			CallExternal(NPCATK_TARGET, "ext_freeze_ray_remove", self);
		DOING_BEAM = false;
		PlaySound(1, 0, SOUND_FREEZE_RAY);
		Effect("beam", "update", LAST_BEAM, "remove");
	}

	// get_teleporters
	// =============== Teleport system from original script
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
		PlaySound(0, 10, "SOUND_TELE");
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
		PlaySound(0, 10, "SOUND_TELE");
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ice_mage.mdl");
		CallEventDelayed(Float(Eval("FREQ_TELE")), "IceMage2_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		IceMage2_FirstThink();
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
		if (name == "beam_end") { OnBeamEnd(); return true; }
		if (name == "beam_start") { OnBeamStart(); return true; }
		if (name == "check_near_dest") { OnCheckNearDest(); return true; }
		if (name == "do_burst") { OnDoBurst(); return true; }
		if (name == "do_burst2") { OnDoBurst2(); return true; }
		if (name == "do_burst3") { OnDoBurst3(); return true; }
		if (name == "find_near_teleporter") { OnFindNearTeleporter(); return true; }
		if (name == "flicker_in") { OnFlickerIn(); return true; }
		if (name == "flicker_out") { OnFlickerOut(); return true; }
		if (name == "freeze_dodamage") { OnFreezeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_teleporters") { OnGetTeleporters(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "shadow_shift") { OnShadowShift(); return true; }
		if (name == "stop_shadow_shift") { OnStopShadowShift(); return true; }
		if (name == "tele_in") { OnTeleIn(); return true; }
		if (name == "tele_out") { OnTeleOut(); return true; }
		if (name == "IceMage2_Timer") { IceMage2_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
