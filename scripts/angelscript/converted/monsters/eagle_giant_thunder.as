#pragma context server

// Converted from monsters/eagle_giant_thunder.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/eagle_giant_base.as"

[script "monsters/eagle_giant_thunder"]
class EagleGiantThunder : EagleGiantBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	EagleGiantThunder()
	{
		FREQ_ZAP = 10.0f;
		DOT_SHOCK = 25.0f;
		SOUND_ZAP_WARMUP = "debris/beamstart2.wav";
		SOUND_ZAP = "debris/beamstart9.wav";
		SOUND_STORM = "weather/Storm_exclamation.wav";
	}

	// unnamed block (first think)
	void EagleGiantThunder_FirstThink()
	{
		NPC_GIVE_EXP = 400.0f;
	}

	// game_dodamage
	string EagleGiantThunder_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (StartsWith(damageType, "effect_"))
			return result;
		AddVelocity(target, RelativeVelocity(Vector3(20, 200, 10)));
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/tornado");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		EagleGiantBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/eagle_giant_base
		int count = GetTokenCount(BEAM_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBeamsRemove();
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EagleGiantBase_OnNpcSpawn(npc); // monsters/eagle_giant_base

		SetName("Thunderbird");
		SetRace("demon");
		SetHealth(2000);
		SetWidth(64);
		SetHeight(64);
		SetModel("monsters/eagle_large.mdl");
		SetIdleAnim("flapping");
		SetMoveAnim("flapping");
		SetHearingSensitivity(8);
		SetRoam(true);
		SetDamageTaken("poison", 2);
		SetDamageTaken("holy", 1);
		SetDamageTaken("lightning", 0);
		SetProp(ENT_ME, "skin", 6);
		CallEventDelayed(FREQ_ZAP, "do_zap");
		CallEventDelayed(FREQ_STORM, "do_storm");

		BEAM_LIST = "";
		CallEventDelayed(0.1f, "init_beam1");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleGiantThunder_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// do_zap
	void OnDoZap()
	{
		CallEventDelayed(FREQ_ZAP, "do_zap");
		BEAM_TARGETS = LegacyFunction("get_tbox", "enemy", 1024, MyOrigin());
		if (BEAM_TARGETS == "none")
			return;
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 3, 3);
		PlaySound(0, 10, SOUND_ZAP_WARMUP);
		CallEventDelayed(1.0f, "do_zap2");
	}

	// do_zap2
	void OnDoZap2()
	{
		BEAMS_ON = 0.0f;
		int count = GetTokenCount(BEAM_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnZapTargets();
		}
		PlaySound(0, 10, SOUND_ZAP);
		CallEventDelayed(2.0f, "turn_beams_off");
	}

	// zap_targets
	void OnZapTargets()
	{
		int curIdx = loopIteration;
		if (!(BEAMS_ON < 4.0f)) // only have 4 beams to work with
			return;
		CBaseEntity@ curTarget = FindEntity(GetToken(BEAM_TARGETS, curIdx));
		Vector3 curTargOrg = OriginOf(curTarget);
		CBaseEntity@ curBeam = FindEntity(GetToken(BEAM_LIST, curIdx));
		string traceTarget = LegacyFunction("get_traceline", MyOrigin(), curTargOrg, "worldonly");
		if (traceTarget != Text(curTargOrg))
			return;
		BEAMS_ON += 1.0f;
		Effect("beam", "update", @curBeam, "end_target", @curTarget, 0);
		Effect("beam", "update", @curBeam, "brightness", 200);
		ApplyEffect(curTarget, "effects/dot_lightning", 5, self, DOT_SHOCK);
		AddVelocity(curTarget, RelativeVelocity(Vector3(-100, 1000, 250)));
	}

	// turn_beams_off
	void OnTurnBeamsOff()
	{
		int count = GetTokenCount(BEAM_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBeamsOffLoop();
		}
	}

	// beams_off_loop
	void OnBeamsOffLoop()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "brightness", 0);
	}

	// beams_remove
	void OnBeamsRemove()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "remove", 0.1f);
	}

	// init_beam1
	void OnInitBeam1()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam3");
	}

	// init_beam3
	void OnInitBeam3()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam4");
	}

	// init_beam4
	void OnInitBeam4()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
	}

	// do_storm
	void OnDoStorm()
	{
		CallEventDelayed(FREQ_STORM, "do_storm");
		if (NPCATK_TARGET == "unset")
			return;

		PlaySound(0, 10, SOUND_STORM);
		PlayAnim("critical", ANIM_ATTACK);
		CreateNpc("monsters/summon/tornado", RelativePosition(Vector3(0, 64, 0)), self, 50, 20.0f);
		OnNpcatkSuspendAi("3.0");
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPC_HOME_LOC, 32);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqStorm() {} // FREQ_STORM
	void OnFreqZap() {} // FREQ_ZAP

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EagleGiantThunder_FirstThink();
		EagleGiantBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "beams_off_loop") { OnBeamsOffLoop(); return true; }
		if (name == "beams_remove") { OnBeamsRemove(); return true; }
		if (name == "do_storm") { OnDoStorm(); return true; }
		if (name == "do_zap") { OnDoZap(); return true; }
		if (name == "do_zap2") { OnDoZap2(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "init_beam1") { OnInitBeam1(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "init_beam3") { OnInitBeam3(); return true; }
		if (name == "init_beam4") { OnInitBeam4(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "turn_beams_off") { OnTurnBeamsOff(); return true; }
		if (name == "zap_targets") { OnZapTargets(); return true; }
		return EagleGiantBaseScript::DispatchEvent(name, params);
	}
}
