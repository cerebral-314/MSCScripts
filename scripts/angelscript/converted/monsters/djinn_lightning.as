#pragma context server

// Converted from monsters/djinn_lightning.script by msc_transpiler.
// BOSS MONSTER

#include "runtime/ScriptEntity.as"
#include "converted/monsters/swamp_ogre.as"

[script "monsters/djinn_lightning"]
class DjinnLightning : SwampOgreScript
{
	// Constants
	float FREQ_CRAZY = 0.0f;
	float FREQ_CHAIN = 0.0f;
	float FREQ_BIGJUMP = 0.0f;
	string CHANCE_SHOCK = "30";
	float DMG_CHAIN = 0.0f;
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";
	string SOUND_BCHARGE = "magic/bolt_start.wav";
	string SOUND_LOOP = "magic/bolt_loop.wav";
	string SOUND_BFIRE = "magic/bolt_end.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 3;
	int GOLD_PER_BAG = 25;
	int GOLD_RADIUS = 128;
	int GOLD_MAX_BAGS = 20;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	string CUR_BEAM = "CUR_BEAM";
	string BEAM_LIST = "BEAM_LIST";
	bool CYCLES_ON = false;
	bool AM_BOUNCING = false;
	float BOUNCE_COUNT = 0.0f;
	bool CHAIN_ON = false;
	float CHAIN_COUNT = 0.0f;
	string BEAM_TARGET_LIST = "BEAM_TARGET_LIST";
	string BEAM_ID = "BEAM_ID";

	// Variables declared by included files, with the value they start with in this script
	DjinnLightning()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		NPC_BOSS_RESTORATION = 0.25f;
		HEADBUTT_FREQ = 20.0f;
	}

	// unnamed block (first think)
	void DjinnLightning_FirstThink()
	{
		if (ToLowerCase(MapName()) == "cleicert")
		{
			NPC_IS_BOSS = true;
			NPC_BASE_EXP = "4000";
		}
		else
		{
			NPC_BASE_EXP = "1000";
		}

		IS_UNHOLY = true;
	}

	// game_dodamage
	string DjinnLightning_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		if (SWIPE_ATTACK)
		{
			SWIPE_ATTACK = false;
			if (RandomInt(1, 100) < Float(CHANCE_SHOCK))
			{
				PlaySound(0, 10, SOUND_BFIRE);
				Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, 1, 1);
				ApplyEffect(target, "effects/dot_lightning", RandomInt(2, 5), self, 10);
			}
		}

		if (CHAIN_ON)
		{
			// effect beam point lgtning.spr 30 BEAM_START BEAM_END (255,255,255) 255 10 0.2
			// effect beam end lgtning.spr 30 BEAM_START PARAM2 0 (200,255,50) 200 10 0.2
			// callevent set_beam $get(PARAM2,id)
			AddVelocity(target, Vector3(0, -50, 50)); // $vec(0,-110,130)
		}
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
		int count = GetTokenCount(BEAM_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBeamsRemove();
		}
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
		SetDamageTaken("all", 0.7f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("holy", 0.25f);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SwampOgre_OnNpcSpawn(npc); // monsters/swamp_ogre

		if (ToLowerCase(MapName()) == "cleicert")
			SetName("Lightning Djinn Ji'Azolt");
		if (ToLowerCase(MapName()) != "cleicert")
			SetName("Lightning Djinn");
		SetHealth(3000);
		SetRace("demon");
		SetRoam(true);
		SetGold(0);
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(8);
		SetBlood("green"); // check in code
		SetIdleAnim(ANIM_IDLE);

		SetProp(ENT_ME, "skin", 4);

		RUN_STEP = 0.0f;

		CallEventDelayed(1.0f, "idle_sounds");

		CUR_BEAM = "0";
		BEAM_LIST = "";
		CallEventDelayed(0.1f, "init_beam1");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SwampOgre_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnLightning_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		CallEventDelayed(FREQ_CHAIN, "do_lightning");
		CallEventDelayed(FREQ_CRAZY, "go_crazy");
		CallEventDelayed(FREQ_BIGJUMP, "do_big_jump");
	}

	// go_crazy
	// ====== BOUNCIE
	void OnGoCrazy()
	{
		OnNpcatkSuspendAi();
		PlayAnim("critical", "idle2");
		SetIdleAnim("idle2");
		SetMoveAnim("idle2");
		PlaySound(0, 10, SOUND_BCHARGE);
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 0.9f, 0.9f);
		CallEventDelayed(1.1f, "go_crazy2");
	}

	// go_crazy2
	void OnGoCrazy2()
	{
		PlaySound(0, 10, SOUND_BFIRE);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));
		AM_BOUNCING = true;
		BOUNCE_COUNT = 0.0f;
		OnBounceLoop();
		CallEventDelayed(1.0f, "resume_attack");
	}

	// resume_attack
	void OnResumeAttack()
	{
		OnNpcatkResumeAi();
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
	}

	// bounce_loop
	void OnBounceLoop()
	{
		BOUNCE_COUNT += 1.0f;
		if (BOUNCE_COUNT == 20.0f)
		{
			SetProp(ENT_ME, "movetype", Eval("const.movetype.step"));
			SetProp(ENT_ME, "rendermode", 0);
			SetProp(ENT_ME, "renderamt", 255);
			CallEventDelayed(FREQ_CRAZY, "go_crazy");
		}
		if (!(BOUNCE_COUNT < 20.0f))
			return;
		CallEventDelayed(0.5f, "bounce_loop");
		int tossDir = RandomInt(-600, 600);
		int tossHor = RandomInt(-600, 600);
		int tossVer = RandomInt(-600, 800);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(tossDir, tossHor, tossVer)));
	}

	// do_lightning
	// ====== DELUXE SHOCKIE
	void OnDoLightning(string endOrigin = "")
	{
		CHAIN_ON = true;
		CHAIN_COUNT = 0.0f;
		OnNpcatkSuspendAi();
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 3, 1);
		CUR_BEAM = "0";
		BEAM_TARGET_LIST = LegacyFunction("get_tsphere", "enemy", 1024, MyOrigin());
		DebugPrint(BEAM_TARGET_LIST);
		int count = GetTokenCount(BEAM_TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSetBeam();
		}
		CallEventDelayed(0.1f, "chain_lightning");
	}

	// chain_lightning
	void OnChainLightning()
	{
		int count;

		CHAIN_COUNT += 1.0f;
		if (CHAIN_COUNT < 30.0f)
		{
			SetIdleAnim("idle2");
			SetMoveAnim("idle2");
		}
		if (CHAIN_COUNT == 30.0f)
		{
			CHAIN_ON = false;
			count = GetTokenCount(BEAM_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBeamsOff();
			}
			CallEventDelayed(1.0f, "resume_attack");
			CallEventDelayed(FREQ_CHAIN, "do_lightning");
		}
		if (!(CHAIN_COUNT < 30.0f))
			return;
		CallEventDelayed(0.1f, "chain_lightning");
		// dodamage $relpos(0,0,0) 1024 DMG_CHAIN 100% 0.0 reflective lightning
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
		count = GetTokenCount(BEAM_TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPushTargets();
		}
	}

	// push_targets
	void OnPushTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(BEAM_TARGET_LIST, loopIteration));
		if (NameOf(curTarget) == "Npc")
			return;
		if (NameOf(curTarget) == "0")
			return;

		Vector3 targOrg = OriginOf(BEAM_TARGET_LIST);
		string traceLine = LegacyFunction("get_traceline", MyOrigin(), targOrg, "worldonly");
		if (traceLine != Text(targOrg))
			return;
		float finDmg = DMG_CHAIN;
		float resistFloat = DamageTakenOf(curTarget, "lightning");
		finDmg *= resistFloat;
		LegacyCommand("drainhp", @curTarget, ENT_ME, finDmg);
		AddVelocity(curTarget, Vector3(0, -110, 130)); // $vec(0,-110,130)
	}

	// set_beam
	void OnSetBeam()
	{
		CBaseEntity@ curBeamId = FindEntity(GetToken(BEAM_LIST, Int(CUR_BEAM)));
		CBaseEntity@ curTarget = FindEntity(GetToken(BEAM_TARGET_LIST, loopIteration));
		if (NameOf(curTarget) == "Npc")
			return;
		if (NameOf(curTarget) == "0")
			return;

		if (curBeamId is null)
			return;

		DebugPrint("beam " + EntityId(curBeamId) + " to " + NameOf(curTarget));
		Effect("beam", "update", @curBeamId, "brightness", 200);
		Effect("beam", "update", @curBeamId, "end_target", @curTarget, 0);
		CUR_BEAM = Text(Float(CUR_BEAM) + 1.0f);

		// applyeffect CUR_TARGET effects/dot_lightning 3.0 $get(ent_me,id) DMG_SHOCK
		if (!(Float(CUR_BEAM) > GetTokenCount(BEAM_LIST)))
			return;
		CUR_BEAM = "0";
	}

	// beams_off
	void OnBeamsOff()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "brightness", 0);
	}

	// beams_remove
	void OnBeamsRemove()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "remove", 0);
	}

	// do_big_jump
	void OnDoBigJump()
	{
		CallEventDelayed(FREQ_BIGJUMP, "do_big_jump");
		if (NPCATK_TARGET == "unset")
			return;
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, 1);
		PlayAnim("critical", ANIM_LEAP);
		PlaySound(0, 10, SOUND_LEAP);
		int jumpHeight = RandomInt(550, 650);
		int jumpDist = RandomInt(800, 900);
		CallEventDelayed(0.1f, "big_jump_boost");
	}

	// big_jump_boost
	void OnBigJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
	}

	// init_beam1
	void OnInitBeam1()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		BEAM_ID = EntityId(EntityOf(ENT_LASTCREATED));
		DebugPrint("init_beam1 " + BEAM_ID);
		CallEventDelayed(0.1f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam2 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam3");
	}

	// init_beam3
	void OnInitBeam3()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam3 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam4");
	}

	// init_beam4
	void OnInitBeam4()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam4 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqBigjump() {} // FREQ_BIGJUMP
	void OnFreqChain() {} // FREQ_CHAIN
	void OnFreqCrazy() {} // FREQ_CRAZY

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnLightning_FirstThink();
		SwampOgre_FirstThink();
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
		if (name == "beams_off") { OnBeamsOff(); return true; }
		if (name == "beams_remove") { OnBeamsRemove(); return true; }
		if (name == "big_jump_boost") { OnBigJumpBoost(); return true; }
		if (name == "bounce_loop") { OnBounceLoop(); return true; }
		if (name == "chain_lightning") { OnChainLightning(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_big_jump") { OnDoBigJump(); return true; }
		if (name == "do_lightning") { OnDoLightning(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "go_crazy") { OnGoCrazy(); return true; }
		if (name == "go_crazy2") { OnGoCrazy2(); return true; }
		if (name == "init_beam1") { OnInitBeam1(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "init_beam3") { OnInitBeam3(); return true; }
		if (name == "init_beam4") { OnInitBeam4(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "push_targets") { OnPushTargets(); return true; }
		if (name == "resume_attack") { OnResumeAttack(); return true; }
		if (name == "set_beam") { OnSetBeam(); return true; }
		return SwampOgreScript::DispatchEvent(name, params);
	}
}
