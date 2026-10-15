#pragma context server

// Converted from monsters/cold_lady.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_noclip.as"

[script "monsters/cold_lady"]
class ColdLady : BaseMonsterNewScript, BaseNoclip, BasePropelled
{
	// Constants
	float FREQ_PICK = 5.0f;
	string DMG_ICE = "DMG_ICE";
	float DOT_FREEZE = 0.0f;
	int FWD_SPEED_NORM = 10;
	int FWD_SPEED_FAST = 30;
	float VERT_WOBBLE_ACTIVE = 0.0f;
	bool VERT_WOBBLE_IDLE = false;
	int ROAM_RANGE = 512;
	int MAX_ROAM_RANGE = 4096;
	string SOUND_FREEZE = "debris/beamstart14.wav";
	string SOUND_ATTACK1 = "voices/icelady_giggle1.wav";
	string SOUND_ATTACK2 = "voices/icelady_giggle2.wav";
	string SOUND_ATTACK3 = "voices/icelady_giggle3.wav";
	string SOUND_ALERT = "voices/icelady_taunt1.wav";
	string SOUND_INTRO1 = "voices/icelady_taunt2.wav";
	string SOUND_INTRO2 = "voices/icelady_taunt2b.wav";
	string SOUND_PAIN1 = "voices/icelady_pain1.wav";
	string SOUND_PAIN2 = "voices/icelady_pain2.wav";
	string SOUND_STRUCK1 = "debris/glass1.wav";
	string SOUND_STRUCK2 = "debris/glass2.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	float FWD_SPEED = 10.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float DEST_ROT = 0.0f;
	float MOVE_STEP = 0.0f;
	string MOVE_TARGET = "MOVE_TARGET";
	Vector3 NPC_NOCLIP_DEST = Vector3();
	float VERT_WOBBLE = 0.0f;
	bool PICK_PLAYER_DELAY = false;
	int DID_INTRO = 0;
	string VALID_PLAYERS = "VALID_PLAYERS";
	float N_VALID = 0.0f;
	bool BEAM_ATTACK = false;
	bool MOVING_IN = false;

	// Variables declared by included files, with the value they start with in this script
	ColdLady()
	{
		ANIM_WALK = "treadwater";
		ANIM_RUN = "swim";
		ANIM_IDLE = "treadwater";
		SOUND_DEATH = "voices/icelady_pain2.wav";
	}

	// unnamed block (first think)
	void ColdLady_FirstThink()
	{
		IS_UNHOLY = true;

		ANIM_WALK = "treadwater";
		ANIM_RUN = "swim";
		ANIM_IDLE = "treadwater";
		ANIM_ATTACK = "crouch_shoot_onehanded";

		ATTACK_RANGE = 128.0f;
		ATTACK_MOVERANGE = 100.0f;
		ATTACK_HITRANGE = 200.0f;

		NPC_GIVE_EXP = 400.0f;

		FWD_SPEED = 10.0f;

		ANIM_DEATH = "die_simple";
	}

	// unnamed block (timer)
	void ColdLady_Timer()
	{
		CallEventDelayed(3.0f, "ColdLady_Timer");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// game_dodamage
	string ColdLady_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!BEAM_ATTACK)
			return result;
		BEAM_ATTACK = false;
		Vector3 traceStart = OriginOf(ENT_ME);
		Vector3 traceEnd = OriginOf(MOVE_TARGET);
		string traceIt = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		Effect("beam", "point", "lgtning.spr", 60, traceStart, traceIt, Vector3(128, 128, 255), 200, 60, 1.0f);
		if (!hit)
			return result;
		if (!(RangeTo(target) <= ATTACK_HITRANGE))
			return result;
		ApplyEffect(target, "effects/dot_cold_freeze", 4.0f, self, DOT_FREEZE);
		PlaySound(0, 10, SOUND_FREEZE);
		CallEventDelayed(0.5f, "do_giggle");
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
		SetFly(false);
		SetGravity(1);
		SetVelocity(ENT_ME, Vector3(0, 0, -200));
		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
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
		NPC_NOCLIP_DEST = MyOrigin();
		OnNpcatkSuspendAi(); // redund
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);

		if (MOVE_TARGET != "unset")
			return;
		if (RelationshipOf(ENT_LASTSTRUCK, ENT_ME) != "enemy")
			return;
		MOVE_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Cold Lady");
		SetBlood("none");
		SetRace("demon");
		SetHealth(900);
		SetModel("monsters/icelady.mdl");
		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("holy", 1.5f);
		SetFly(true);

		SetWidth(32);
		SetHeight(96);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_RUN);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		DEST_ROT = 0.0f;
		MOVE_STEP = 0.0f;
		MOVE_TARGET = "unset";

		OnNpcatkSuspendAi();
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ColdLady_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// basenoclip_flight
	// {
	// repeatdelay 1.0
	// dbg temp movin MOVING_IN dist $dist(game.monster.origin,NPC_NOCLIP_DEST) range $get(MOVE_TARGET,range) targ $get(MOVE_TARGET,name) step MOVE_STEP
	// }
	void OnBasenoclipFlight()
	{
		BaseNoclip_OnBasenoclipFlight(); // monsters/base_noclip

		if (!IsAlive(MOVE_TARGET) && MOVE_TARGET != "unset")
			OnClearTarget("dead");

		if (MOVE_TARGET == "unset")
		{
			if (Distance(MyOrigin(), NPC_NOCLIP_DEST) < ATTACK_MOVERANGE)
			{
				MOVE_STEP = 128.0f;
				VERT_WOBBLE = (VERT_WOBBLE_IDLE ? 1.0f : 0.0f);
				NPC_NOCLIP_DEST = Vec(NPC_HOME_LOC);
				OnDoMoveStep();
			}

			if (!PICK_PLAYER_DELAY)
			{
				PICK_PLAYER_DELAY = true;
				CallEventDelayed(FREQ_PICK, "reset_pplayer");
				OnPickAPlayer();
			}
		}

		if (DID_INTRO == 0 && CanSee("enemy"))
		{
			DID_INTRO = 1;
			PlaySound(0, 10, SOUND_ALERT);
			CallEventDelayed(4.0f, "do_intro");
		}

		if (MOVE_TARGET != "unset")
		{
			if (MOVING_IN)
			{
				if (RangeTo(MOVE_TARGET) < ATTACK_RANGE)
					OnDoAttack(MOVE_TARGET);
				if (Distance(MyOrigin(), Vec(NPC_HOME_LOC)) > MAX_ROAM_RANGE)
					OnClearTargets();
				if (MOVING_IN)
				{
					SetMoveAnim(ANIM_WALK);
					SetIdleAnim(ANIM_WALK);
					PlayAnim("once", ANIM_WALK);
					if (Distance(MyOrigin(), NPC_NOCLIP_DEST) < ATTACK_MOVERANGE)
					{
						FWD_SPEED = FWD_SPEED_NORM;
						VERT_WOBBLE = VERT_WOBBLE_ACTIVE;
						if (RangeTo(MOVE_TARGET) < ATTACK_MOVERANGE)
							OnMoveAway("in_range");
						MOVE_STEP -= 100.0f;
						if (MOVE_STEP < 0.0f)
							MOVE_STEP = 0.0f;
						NPC_NOCLIP_DEST = OriginOf(MOVE_TARGET);
						OnDoMoveStep();
					}
				}
			}

			if (!MOVING_IN && Distance(MyOrigin(), NPC_NOCLIP_DEST) < ATTACK_MOVERANGE)
			{
				FWD_SPEED = FWD_SPEED_FAST;
				NPC_NOCLIP_DEST = OriginOf(MOVE_TARGET);
				VERT_WOBBLE = (VERT_WOBBLE_IDLE ? 1.0f : 0.0f);
				SetMoveAnim(ANIM_RUN);
				SetIdleAnim(ANIM_RUN);
				PlayAnim("once", ANIM_RUN);
				MOVE_STEP += 100.0f;
				if (RangeTo(MOVE_TARGET) > ROAM_RANGE)
					OnMoveIn("too_far");
				NPC_NOCLIP_DEST = OriginOf(MOVE_TARGET);
				OnDoMoveStep();
			}
		}
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
	}

	// clear_target
	void OnClearTarget(string reason = "")
	{
		DebugPrint("targ_reset_cuz " + reason);
		MOVE_TARGET = "unset";
		MOVE_STEP = 0.0f;
		OnMoveAway("clear_targets");
	}

	// do_move_step
	void OnDoMoveStep()
	{
		DEST_ROT += 45.0f;
		if (DEST_ROT > 359.0f)
			DEST_ROT -= 359.0f;
		NPC_NOCLIP_DEST += RelativePosition(Vector3(0, DEST_ROT, 0), Vector3(0, MOVE_STEP, VERT_WOBBLE));
	}

	// do_intro
	void OnDoIntro()
	{
		float introDiff = GameTime() - Float(GetVar("G_ICELADY_INTRO"));
		if (!(introDiff > 10.0f))
			return;

		SetGlobal("G_ICELADY_INTRO", GameTime());
		PlayRandomSound(0, 10, SOUND_INTRO1, SOUND_INTRO2);
	}

	// reset_pplayer
	void OnResetPplayer()
	{
		PICK_PLAYER_DELAY = false;
	}

	// pick_a_player
	void OnPickAPlayer()
	{
		// dbg picking player
		SetVar("PLAYER_LIST", GetActivePlayers());
		VALID_PLAYERS = "";
		N_VALID = 0.0f;
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPickPlayerLoop();
		}
		if (N_VALID == 1.0f)
		{
			OnMoveIn("new_target");
			MOVE_TARGET = GetToken("PLAYER_LIST", 0);
		}

		// dbg Targeted $get(MOVE_TARGET,name)
		if (N_VALID == 0.0f)
			MOVE_TARGET = "unset";

		if (!(N_VALID > 1.0f))
			return;
		N_VALID -= 1.0f;
		int rndValid = RandomInt(0, int(N_VALID));
		OnMoveIn("new_target_multi");
		MOVE_TARGET = GetToken("PLAYER_LIST", rndValid);
	}

	// pick_player_loop
	void OnPickPlayerLoop()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		// dbg temp $get(CUR_PLAYER,name) $get(CUR_PLAYER,range)
		if (!(RangeTo(curPlayer) < ROAM_RANGE))
			return;
		VALID_PLAYERS = TokenAdd(VALID_PLAYERS, Text(loopIteration));
		N_VALID += 1.0f;
	}

	// do_attack
	void OnDoAttack(string damage = "")
	{
		BEAM_ATTACK = true;
		PlayAnim("once", ANIM_ATTACK);
		DoDamage(MOVE_TARGET, ATTACK_HITRANGE, DMG_ICE, "100%", "cold");
		OnMoveAway("did_attack");
		CallEventDelayed(10.0f, "check_froze");
	}

	// check_froze
	void OnCheckFroze()
	{
		if (Truthy(ScriptVarOf(MOVE_TARGET, "PL_I_R_FROZEN")))
			OnPickAPlayer();
	}

	// do_giggle
	void OnDoGiggle()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// move_away
	void OnMoveAway(string reason = "")
	{
		DebugPrint("moving_away " + reason);
		MOVING_IN = false;
	}

	// move_in
	void OnMoveIn(string reason = "")
	{
		DebugPrint("moving_in " + reason);
		MOVING_IN = true;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
	}

	void OnFreqPick() {} // FREQ_PICK
	void OnClearTargets() {} // clear_targets

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/icelady.mdl");
		CallEventDelayed(3.0f, "ColdLady_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ColdLady_FirstThink();
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
		if (name == "basenoclip_flight") { OnBasenoclipFlight(); return true; }
		if (name == "check_froze") { OnCheckFroze(); return true; }
		if (name == "clear_target") { OnClearTarget(Param(params, 0)); return true; }
		if (name == "do_attack") { OnDoAttack(Param(params, 0)); return true; }
		if (name == "do_giggle") { OnDoGiggle(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_move_step") { OnDoMoveStep(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "move_away") { OnMoveAway(Param(params, 0)); return true; }
		if (name == "move_in") { OnMoveIn(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "pick_a_player") { OnPickAPlayer(); return true; }
		if (name == "pick_player_loop") { OnPickPlayerLoop(); return true; }
		if (name == "reset_pplayer") { OnResetPplayer(); return true; }
		if (name == "ColdLady_Timer") { ColdLady_Timer(); return true; }
		return BaseNoclip_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
