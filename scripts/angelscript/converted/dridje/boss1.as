#pragma context server

// Converted from dridje/boss1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/rabid_skele_base.as"

[script "dridje/boss1"]
class Boss1 : RabidSkeleBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Boss1()
	{
		FREQ_PROJECTILE = 5.0f;
		DUR_CLOAK = 10.0f;
	}

	// game_touch
	string Boss1_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!AM_CLOAKED)
			return result;
		if (RelationshipOf(other, ENT_ME) != "enemy")
			return result;
		AddVelocity(other, RelativeVelocity(Vector3(0, 800, 400)));
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string Boss1_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (!AM_CLOAKED)
		{
			string tBox = FindInBox("players", 256);
			if (tBox != "none" && GetTokenCount(tBox) > 2)
				OnDoCloak();
		}

		if (!AM_CLOAKED)
			return result;
		bool canHit = false;
		if (damageType != "magic")
			canHit = true;
		if (damageType != "holy")
			canHit = true;
		if (damageType != "dark")
			canHit = true;
		if (canHit)
			return result;
		result = AppendResult(result, "0.0");
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		OnStartCycles();
	}

	// cycle_npc
	void OnCycleNpc(string mode = "")
	{
		BaseNpcAttackNew_OnCycleNpc(mode); // monsters/base_npc_attack_new
		OnStartCycles();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Boss1_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// check_projectile
	void OnCheckProjectile()
	{
		RabidSkeleBase_OnCheckProjectile(); // monsters/rabid_skele_base
		// zap a random player
		if (AM_CLOAKED)
			return;

		PLAYER_LIST = GetActivePlayers();
		PLAYER_LIST = TokenShuffle(PLAYER_LIST);

		if (!BEAMS_INITED)
			OnInitBeams();

		// pick first one you can draw a line to
		BEAM_TARGET = "unset";
		int count = GetTokenCount(PLAYER_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPickBeamTarget();
		}

		if (BEAM_TARGET == "unset")
			return;
		OnDoBeam();
	}

	// rabid_skele_spawn
	void OnRabidSkeleSpawn()
	{
		SetName("Etherial Bone");

		SetModel("monsters/rabid_skelly.mdl");
		SetRace("undead");
		SetBlood("none");
		SetHearingSensitivity(4);
		NPC_GIVE_EXP = 60.0f;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
		SetWidth(32);
		SetHeight(64);
		SetProp(ENT_ME, "skin", 5); // or whatever the lightning skin is

		SetHealth(2000);
		SetDamageTaken("holy", 2);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("lightning", 0);

		AM_CLOAKED = false;

		BEAM_ID1 = "unset";
		BEAM_ID2 = "unset";
		BEAMS_INITED = false;
	}

	// start_cycles
	void OnStartCycles()
	{
		CallEventDelayed(FREQ_CLOAK, "do_cloak");
		CallEventDelayed(FREQ_PROJECTILE, "check_projectile");
	}

	// do_beam
	void OnDoBeam()
	{
		PlaySound(0, 10, "SOUND_BEAM_WARMUP");
		PlayAnim("critical", ANIM_PROJECTILE);
	}

	// mdl_projectile
	// model event - needs to be added to model
	void OnMdlProjectile()
	{
		PlaySound(0, 10, "SOUND_BEAM_FIRE");
		Effect("beam", "update", BEAM_ID1, "end_target", BEAM_TARGET, 0);
		Effect("beam", "update", BEAM_ID2, "end_target", BEAM_TARGET, 0);
		Effect("beam", "update", BEAM_ID1, "brightness", 200);
		Effect("beam", "update", BEAM_ID2, "brightness", 200);
		DoDamage(BEAM_TARGET, "direct", "DMG_BEAM", "100%", ENT_ME, "lightning");
		AddVelocity(BEAM_TARGET, RelativeVelocity(Vector3(0, 800, 1000)));
	}

	// pick_beam_target
	void OnPickBeamTarget()
	{
		if (IsAlive(BEAM_TARG))
			return;
		string curPlayer = GetToken(PLAYER_LIST, loopIteration);
		if (!(RangeTo(curPlayer) < 1024.0f))
			return;
		Vector3 targOrg = OriginOf(curPlayer);
		Vector3 startTrace = AttachmentPositionOf(ENT_ME, 0);
		string traceOrg = LegacyFunction("get_traceline", startTrace, targOrg, "worldonly");
		if (Text(startTrace) != Text(targOrg))
			return;
		BEAM_TARG = curPlayer;
	}

	// init_beams
	void OnInitBeams()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 0, ENT_ME, 1, Vector3(200, 255, 50), 0, 30, -1);
		BEAM_ID1 = EntityId(EntityOf(ENT_LASTCREATED));
		CallEventDelayed(0.5f, "init_beams2");
	}

	// init_beams2
	void OnInitBeams2()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 0, ENT_ME, 1, Vector3(200, 255, 50), 0, 30, -1);
		BEAM_ID2 = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// do_cloak
	void OnDoCloak()
	{
		PlaySound(0, 10, "SOUND_CLOAK");
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 256, 2, 2);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SetAnimMoveSpeed(5);
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "2048", Text(DUR_CLOAK));
		AM_CLOAKED = true;
		SetCallback("touch", "enable");
		CallEventDelayed(DUR_CLOAK, "end_cloak");
	}

	// end_cloak
	void OnEndCloak()
	{
		PlaySound(0, 10, "SOUND_CLOAK");
		SetCallback("touch", "disabled");
		AM_CLOAKED = false;
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 256, 2, 2);
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
		SetAnimMoveSpeed(2);
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return Boss1_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDurCloak() {} // DUR_CLOAK
	void OnFreqCloak() {} // FREQ_CLOAK
	void OnFreqProjectile() {} // FREQ_PROJECTILE

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_projectile") { OnCheckProjectile(); return true; }
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_beam") { OnDoBeam(); return true; }
		if (name == "do_cloak") { OnDoCloak(); return true; }
		if (name == "end_cloak") { OnEndCloak(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "init_beams") { OnInitBeams(); return true; }
		if (name == "init_beams2") { OnInitBeams2(); return true; }
		if (name == "mdl_projectile") { OnMdlProjectile(); return true; }
		if (name == "pick_beam_target") { OnPickBeamTarget(); return true; }
		if (name == "rabid_skele_spawn") { OnRabidSkeleSpawn(); return true; }
		if (name == "start_cycles") { OnStartCycles(); return true; }
		return RabidSkeleBaseScript::DispatchEvent(name, params);
	}
}
