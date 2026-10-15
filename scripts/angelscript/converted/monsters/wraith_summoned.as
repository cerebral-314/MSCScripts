#pragma context server

// Converted from monsters/wraith_summoned.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_noclip.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class WraithSummoned
{
	// Constants
	bool BASENOCLIP_NO_SETMOVEDEST = true;
	int FWD_SPEED_STANDARD = 20;
	string CL_SCRIPT = "monsters/wraith_cl";
	float FREQ_ROAM = 0.0f;
	string SOUND_MOAN = "crow/ghostwail.wav";
	string SOUND_DEATH = "ichy/ichy_die2.wav";
	string SOUND_DRAIN_START = "crow/Triggered/tomb5.wav";
	string SOUND_DRAIN_LOOP = "x/x_teleattack1.wav";
	string SOUND_HOVER_LOOP = "ambience/labdrone2.wav";
	string SOUND_KILL = "houndeye/he_blast3.wav";
	string SOUND_TELE = "magic/teleport.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_WALK = "ANIM_WALK";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	float FWD_SPEED = 0.0f;
	float DMG_DRAIN = 0.0f;
	float MP_DRAIN_AMT = 0.0f;
	Vector3 NPC_NOCLIP_DEST = Vector3();
	bool IS_FLEEING = false;
	string PLAYER_LIST = "PLAYER_LIST";
	bool AM_DRAINING = false;
	string MY_CL_IDX = "MY_CL_IDX";
	float LASTATK_MESSAGE = 0.0f;
	string MY_OWNER = "MY_OWNER";
	string INITIAL_ORIGIN = "INITIAL_ORIGIN";

	// unnamed block (first think)
	void WraithSummoned_FirstThink()
	{
		ANIM_RUN = "idle";
		ANIM_IDLE = "idle";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "idle";
		ANIM_WALK = "idle";

		ATTACK_RANGE = 128.0f;
		ATTACK_MOVERANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		NPC_GIVE_EXP = 400.0f;
		FWD_SPEED = 20.0f;
		DMG_DRAIN = 20.0f; // for monsters
		MP_DRAIN_AMT = 1.0f; // for players
	}

	// npc_spawn
	void WraithSummoned_OnNpcSpawn(string npc = "")
	{
		SetName("Wraith");
		SetModel("monsters/netherspirit.mdl");
		SetWidth(20);
		SetHeight(80);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		SetHealth(750);
		SetRace("undead");
		SetBlood("none");
		SetDamageTaken("slash", 0);
		SetDamageTaken("pierce", 0);
		SetDamageTaken("blunt", 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("stun", 0);

		SetSolid("slidebox");

		SetGravity(0);

		SetRoam(true);

		SetHearingSensitivity(11);

		CallEventDelayed(1.0f, "sustain_renderprops");

		CallEventDelayed(0.5f, "do_manual_roam");
	}

	// npc_post_spawn
	void WraithSummoned_OnNpcPostSpawn()
	{
		if (!(NPC_DMG_MULTI > 1.0f))
			return;
		MP_DRAIN_AMT *= NPC_DMG_MULTI;
		DMG_DRAIN *= NPC_DMG_MULTI;
	}

	// npcatk_hunt
	void WraithSummoned_OnNpcatkHunt()
	{
		if (RangeTo(NPCATK_TARGET) < ATTACK_MOVERANGE)
			FWD_SPEED = 0.0f;
		else
			FWD_SPEED = FWD_SPEED_STANDARD;

		if (IS_FLEEING)
			NPC_NOCLIP_DEST = Vec(Eval("game.monster.movedest.origin"));

		if (NPCATK_TARGET != "unset")
		{
			float myZ = OriginOf(ENT_ME).z;
			float targetZ = OriginOf(NPCATK_TARGET).z;
			if (IsPlayer(NPCATK_TARGET))
				targetZ -= 46.0f;
			Vector3 myOrg = OriginOf(ENT_ME);
			myOrg.z = targetZ;
			SetOrigin(ENT_ME, myOrg);

			if (RangeTo(NPCATK_TARGET) < 55.0f)
			{
				// setvard IS_FLEEING 1
				// callevent npcatk_suspend_ai 1.0
				// setvard FWD_SPEED 50
				// setvard NPC_NOCLIP_DEST $get(NPCATK_TARGET,origin)
				// local RND_ANG $randf(0,359.99)
				// teleport away from targets stuck inside you
				float rndAng = Random(0, 359.99f);
				NPC_NOCLIP_DEST += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 80, 0));
				NPC_NOCLIP_DEST.z = targetZ;
				SetOrigin(ENT_ME, NPC_NOCLIP_DEST);
				PlaySound(0, 10, SOUND_TELE);
			}
			else
			{
				IS_FLEEING = false;
				NPC_NOCLIP_DEST = OriginOf(NPCATK_TARGET);
				NPC_NOCLIP_DEST.z = targetZ;
			}
		}

		if (NPCATK_TARGET != "unset")
			return;

		CallEventDelayed(FREQ_ROAM, "do_manual_roam");
		FWD_SPEED = FWD_SPEED_STANDARD;

		PLAYER_LIST = GetActivePlayers();
		PLAYER_LIST = TokenShuffle(PLAYER_LIST);
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPickTarget();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// pick_target
	void WraithSummoned_OnPickTarget()
	{
		string curTarg = GetToken(PLAYER_LIST, loopIteration);
		if (!IsAlive(curTarg))
			return;
		if (!(RangeTo(curTarg) < 1024.0f))
			return;
		OnNpcatkTarget2(curTarg);
	}

	// do_manual_roam
	void WraithSummoned_OnDoManualRoam()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(FREQ_ROAM, "do_manual_roam");
		if (NPCATK_TARGET != "unset")
			return;
		NPC_NOCLIP_DEST = Vec(NPC_HOME_LOC);
		float rndAng = Random(0, 359.99f);
		NPC_NOCLIP_DEST += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 512, 0));
	}

	// sustain_renderprops
	void WraithSummoned_OnSustainRenderprops()
	{
		// in case a glow shell renders invisible, also handle sound loop here
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(5.0f, "sustain_renderprops");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		ServerPlaySound(3, 10, SOUND_HOVER_LOOP);
		if (RandomInt(1, 10) == 1)
			PlaySound(0, 10, SOUND_MOAN);
	}

	// turn_undead
	void WraithSummoned_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		// turn undead is instant death for these guys
		if (NOT_SUMMONED) // unless they ain't summoned
			return;
		float dmgHoly = MaxHealthOf(ENT_ME) * 2.0f;
		DoDamageEx(ENT_ME, "direct", 1000, "100%", @exorcist, @exorcist, "spellcasting.divination", "holy");
	}

	// npc_death
	void WraithSummoned_OnNpcDeath()
	{
		AM_DRAINING = false;
		SetAnimFrameRate(0);
		FWD_SPEED = 0.0f;
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self, 5, 128);
		PlaySound(1, 10, SOUND_DEATH);
		ServerPlaySound(2, 0, SOUND_DRAIN_LOOP);
		ServerPlaySound(3, 0, SOUND_HOVER_LOOP);
		if (Float(MY_CL_IDX) != 0.0f)
			ClientEvent("update", "all", MY_CL_IDX, "end_fx");
		if (!IsAlive(MY_OWNER))
			return;
		CallExternal(MY_OWNER, "ext_wraith_died");
	}

	// frame_attack_start
	void WraithSummoned_OnFrameAttackStart()
	{
		ServerPlaySound(2, 10, SOUND_DRAIN_LOOP);
		OnStartDrainAttack();
	}

	// frame_attack_end
	void WraithSummoned_OnFrameAttackEnd()
	{
		OnEndDrainAttack();
	}

	// end_drain_attack
	void WraithSummoned_OnEndDrainAttack()
	{
		ServerPlaySound(2, 0, SOUND_DRAIN_LOOP);
		ClientEvent("update", "all", MY_CL_IDX, "end_fx");
		AM_DRAINING = false;
		MY_CL_IDX = "0";
	}

	// start_drain_attack
	void WraithSummoned_OnStartDrainAttack()
	{
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), IndexOf(NPCATK_TARGET), ATTACK_HITRANGE);
		MY_CL_IDX = LastClientScriptId();
		AM_DRAINING = true;
		OnDrainAttackLoop();
	}

	// drain_attack_loop
	void WraithSummoned_OnDrainAttackLoop()
	{
		if (!AM_DRAINING)
			return;
		CallEventDelayed(0.1f, "drain_attack_loop");
		if (IsPlayer(NPCATK_TARGET))
		{
			bool seeTarget = CanSee(NPCATK_TARGET);

			if (seeTarget && RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			{
				GiveMana(NPCATK_TARGET, -MP_DRAIN_AMT);
				if (GameTime() > LASTATK_MESSAGE)
				{
					LASTATK_MESSAGE = GameTime() + 2.0f;
					PlayerMessage(NPCATK_TARGET, "Your soul is being drained!");
					Effect("screenfade", NPCATK_TARGET, 2, 1, Vector3(0, 0, 255), 180, "fadein");
				}
				if (ManaOf(NPCATK_TARGET) <= 0.0f)
					OnSlayTarget();
			}
		}
		else if (CanSee(NPCATK_TARGET))
			DoDamage(NPCATK_TARGET, "direct", DMG_DRAIN, "100%", ENT_ME, "dark");
	}

	// slay_target
	void WraithSummoned_OnSlayTarget()
	{
		OnEndDrainAttack();
		PlayerMessage(NPCATK_TARGET, "Your soul has been drained.");
		// figure slay target function here (maybe new code-side function)
		DoDamage(NPCATK_TARGET, "direct", 99999, "100%", ENT_ME, "target");
		CallExternal(NPCATK_TARGET, "ext_playsound_kiss", 1, 10, SOUND_KILL);
		PlaySound(0, 10, SOUND_MOAN);
	}

	// game_dynamically_created
	// <owner> <first_target> <start_pos>
	void WraithSummoned_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		// setvard FIRST_TARGET PARAM2 //scratch this, better a random player
		INITIAL_ORIGIN = damage;
		CallEventDelayed(0.1f, "set_first_origin");
	}

	// set_first_origin
	void WraithSummoned_OnSetFirstOrigin()
	{
		SetOrigin(ENT_ME, Vec(INITIAL_ORIGIN));
	}

	// ext_master_died
	// called by master on death
	void WraithSummoned_OnExtMasterDied(CBaseEntity@ master = null)
	{
		if (EntityId(master) != MY_OWNER)
			return;
		OnNpcSuicide();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		WraithSummoned_OnTurnUndead(holyDamage, exorcist);
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
		WraithSummoned_OnNpcPostSpawn();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		WraithSummoned_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		WraithSummoned_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		WraithSummoned_OnNpcatkHunt();
	}

	void OnPickTarget() { WraithSummoned_OnPickTarget(); } // pick_target
	void OnDoManualRoam() { WraithSummoned_OnDoManualRoam(); } // do_manual_roam
	void OnSustainRenderprops() { WraithSummoned_OnSustainRenderprops(); } // sustain_renderprops
	void OnNpcDeath() { WraithSummoned_OnNpcDeath(); } // npc_death
	void OnFrameAttackStart() { WraithSummoned_OnFrameAttackStart(); } // frame_attack_start
	void OnFrameAttackEnd() { WraithSummoned_OnFrameAttackEnd(); } // frame_attack_end
	void OnEndDrainAttack() { WraithSummoned_OnEndDrainAttack(); } // end_drain_attack
	void OnStartDrainAttack() { WraithSummoned_OnStartDrainAttack(); } // start_drain_attack
	void OnDrainAttackLoop() { WraithSummoned_OnDrainAttackLoop(); } // drain_attack_loop
	void OnSlayTarget() { WraithSummoned_OnSlayTarget(); } // slay_target
	void OnSetFirstOrigin() { WraithSummoned_OnSetFirstOrigin(); } // set_first_origin
	void OnExtMasterDied(CBaseEntity@ master = null) { WraithSummoned_OnExtMasterDied(master); } // ext_master_died
	void OnFreqRoam() {} // FREQ_ROAM

	// This file's events and timers by their .script names
	bool WraithSummoned_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_manual_roam") { OnDoManualRoam(); return true; }
		if (name == "drain_attack_loop") { OnDrainAttackLoop(); return true; }
		if (name == "end_drain_attack") { OnEndDrainAttack(); return true; }
		if (name == "ext_master_died") { OnExtMasterDied(EntityParam(params, 0)); return true; }
		if (name == "frame_attack_end") { OnFrameAttackEnd(); return true; }
		if (name == "frame_attack_start") { OnFrameAttackStart(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "set_first_origin") { OnSetFirstOrigin(); return true; }
		if (name == "slay_target") { OnSlayTarget(); return true; }
		if (name == "start_drain_attack") { OnStartDrainAttack(); return true; }
		if (name == "sustain_renderprops") { OnSustainRenderprops(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/wraith_summoned"]
shared class WraithSummonedScript : BaseMonsterNewScript, WraithSummoned, BaseNoclip, BasePropelled
{
	// Variables every script that includes this file declares
	bool I_AM_TURNABLE = false;
	bool NOT_SUMMONED = false;

	// Variables declared by included files, with the value they start with in this script
	WraithSummonedScript()
	{
		SOUND_DEATH = "ichy/ichy_die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/netherspirit.mdl");
		Precache("ambience/labdrone2.wav");
		Precache("x/x_teleattack1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WraithSummoned_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseNoclip_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return WraithSummoned_DispatchEvent(name, params)
			|| BaseNoclip_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
