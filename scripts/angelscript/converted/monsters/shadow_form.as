#pragma context server

// Converted from monsters/shadow_form.script by msc_transpiler.
// Shadowform, sprite based monster
// - Shocks opponents
// - grabs/paralyzes players, until struck by another player
// - Immune to all but Holy and Dark

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"

[script "monsters/shadow_form"]
class ShadowForm : BaseMonsterNewScript, BaseFlyerGrav
{
	// Constants
	bool AS_CUSTOM_UNSTUCK = true;
	float FREQ_CL_UPDATE = 15.0f;
	float FREQ_IDLE_SOUND = 0.0f;
	float FREQ_IDLE_ZAP = 0.0f;
	float FREQ_PAIN = 1.0f;
	float FREQ_ATTACK = 5.0f;
	float FREQ_MINOR_STRIKE = 3.0f;
	int DMG_MAIN_ZAP = 1100;
	int DOT_MAIN_ZAP = 50;
	int DMG_MINOR_STRIKE = 300;
	int DOT_MINOR_STRIKE = 30;
	int RANGE_MINOR_STRIKE = 768;
	string SOUND_ALERT = "monsters/shadow/shadow_alert.wav";
	string SOUND_IDLE1 = "monsters/shadow/shadow_idle1.wav";
	string SOUND_IDLE2 = "monsters/shadow/shadow_idle2.wav";
	string SOUND_IDLE3 = "monsters/shadow/shadow_idle3.wav";
	string SOUND_PAIN1 = "monsters/shadow/shadow_pain1.wav";
	string SOUND_PAIN2 = "monsters/shadow/shadow_pain2.wav";
	string SOUND_PAIN3 = "monsters/shadow/shadow_pain3.wav";
	string SOUND_ZAP_READY = "magic/lightprep.wav";
	string SOUND_ZAP_IDLE = "magic/elecidle.wav";
	string SOUND_ZAP1 = "debris/zap1.wav";
	string SOUND_ZAP2 = "debris/zap3.wav";
	string SOUND_ZAP3 = "debris/zap8.wav";
	float FREQ_SHOCK_SCAN = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IMMUNE_ALL_BUT_HOLY = true;
	bool IS_UNHOLY = true;
	float NPC_HACKED_MOVE_SPEED = 10.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float MISS_COUNT = 0.0f;
	float CYCLE_IDLE_SOUND = 0.0f;
	float NEXT_PAIN_SOUND = 0.0f;
	bool DID_ALERT = false;
	float NEXT_IDLE_ZAP = 0.0f;
	float NEXT_IDLE_SOUND = 0.0f;
	float NEXT_ATTACK = 0.0f;
	float NEXT_SHOCK_SCAN = 0.0f;
	bool SHADOW_CL_ON = false;
	string CL_SCRIPT_IDX = "CL_SCRIPT_IDX";
	float NEXT_MINOR_STRIKE = 0.0f;
	string SCAN_TARGS = "SCAN_TARGS";

	// Variables declared by included files, with the value they start with in this script
	ShadowForm()
	{
		NPC_MUST_SEE_TARGET = "0";
		SOUND_DEATH = "monsters/shadow/shadow_death.wav";
		AS_DIST_THRESH = 5;
	}

	// unnamed block (first think)
	void ShadowForm_FirstThink()
	{
		IMMUNE_ALL_BUT_HOLY = true;
		IS_UNHOLY = true;
		NPC_HACKED_MOVE_SPEED = 10.0f;
		IMMUNE_VAMPIRE = true;

		NPC_MUST_SEE_TARGET = "0";

		ANIM_ATTACK = "walk";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "walk";
		ANIM_DEATH = "walk";

		ATTACK_MOVERANGE = 64.0f;
		ATTACK_RANGE = 512.0f;

		if (Contains(ToLowerCase(MapName()), "lodagond"))
			NPC_GIVE_EXP = 2000.0f;
		else
			NPC_GIVE_EXP = 1000.0f;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string ShadowForm_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!IsAlive(ENT_ME))
			return result;

		if (!SHADOW_CL_ON)
			OnDoManifest();

		if (!IMMUNE_ALL_BUT_HOLY)
			return result;
		bool noDamage = true;
		if (Contains(damageType, "holy"))
			noDamage = false;
		if (Contains(damageType, "dark"))
			noDamage = false;
		if (Contains(damageType, "target"))
			noDamage = false;
		if (Contains(damageType, "magic"))
			noDamage = false;
		if (noDamage)
		{
			result = AppendResult(result, "0");
		}
		else
		{
			if (GameTime() > 0.0f && EntityId(attacker) != NPCATK_TARGET)
				OnAddMinorStrike(attacker);

			if (GameTime() > NEXT_PAIN_SOUND)
			{
				NEXT_PAIN_SOUND = GameTime() + FREQ_PAIN;
				PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
				Effect("beam", "ents", "lgtning.spr", 6, ENT_ME, RandomInt(0, 3), ENT_ME, RandomInt(0, 3), Vector3(255, 0, 0), 255, 255, Random(1, 2));
			}
		}
		return result;
	}

	// unnamed block (timer)
	void ShadowForm_Timer()
	{
		CallEventDelayed(0.2f, "ShadowForm_Timer");
		if (!IsAlive(ENT_ME))
			return;

		string moveDest = Eval("game.monster.movedest.origin");

		if (moveDest == Text(Vector3(0, 0, 0)))
			return;

		AddVelocity(ENT_ME, RelativePosition(MyAngles(), Vector3(0, NPC_HACKED_MOVE_SPEED, 0)));
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
		if (CL_SCRIPT_IDX != "CL_SCRIPT_IDX")
			ClientEvent("update", "all", CL_SCRIPT_IDX, "shadow_death");
	}

	// npc_suicide
	void OnNpcSuicide(string suicideMode = "")
	{
		MonstersExternals_OnNpcSuicide(suicideMode); // monsters/externals
		IMMUNE_ALL_BUT_HOLY = false;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Shadow Form");
		SetHealth(5000);
		SetDamageTaken("holy", 2);
		SetDamageTaken("dark", 0.5f);
		SetDamageTaken("stun", 0);

		SetBlood("none");

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0);
		SetDamageTaken("lightning", 0);

		SetRace("demon");
		SetModel("monsters/shadow_hitbox.mdl");
		SetWidth(90);
		SetHeight(90);
		SetHearingSensitivity(11);
		SetGravity(0);

		MISS_COUNT = 0.0f;
		CYCLE_IDLE_SOUND = 0.0f;
		ArrayCreate("ARRAY_MINOR_STRIKE");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		if (!IsAlive(ENT_ME))
			return;
		if (!SHADOW_CL_ON)
			return;

		if (NPCATK_TARGET == "none")
			return;

		float gameTime = GameTime();

		if (gameTime > NEXT_IDLE_ZAP)
		{
			PlaySound(2, 5, SOUND_ZAP_IDLE);
			Effect("beam", "ents", "lgtning.spr", 2, ENT_ME, RandomInt(0, 3), ENT_ME, RandomInt(0, 3), Vector3(128, 128, 255), 200, 255, Random(2, 4));
			NEXT_IDLE_ZAP = gameTime + FREQ_IDLE_ZAP;
		}

		if (gameTime > NEXT_IDLE_SOUND)
		{
			CYCLE_IDLE_SOUND += 1.0f;
			if (CYCLE_IDLE_SOUND > 3.0f)
				CYCLE_IDLE_SOUND = 0.0f;
			if (CYCLE_IDLE_SOUND == 1.0f)
				PlaySound(4, 10, SOUND_IDLE1);
			if (CYCLE_IDLE_SOUND == 2.0f)
				PlaySound(3, 10, SOUND_IDLE2);
			if (CYCLE_IDLE_SOUND == 3.0f)
				PlaySound(4, 10, SOUND_IDLE3);
			NEXT_IDLE_SOUND = gameTime + FREQ_IDLE_SOUND;
		}

		if (gameTime > NEXT_SHOCK_SCAN)
		{
			NEXT_SHOCK_SCAN = gameTime + FREQ_SHOCK_SCAN;
			OnShockScan(); // shock random player in range, other than primary target
		}

		if (GetArrayCount("ARRAY_MINOR_STRIKE") > 0 && gameTime > NEXT_MINOR_STRIKE)
		{
			NEXT_MINOR_STRIKE = gameTime + FREQ_MINOR_STRIKE;
			OnMinorStrike();
		}
	}

	// npcatk_attack
	void OnNpcatkAttack()
	{
		BaseNpcAttackNew_OnNpcatkAttack(); // monsters/base_npc_attack_new
		if (GameTime() > NEXT_ATTACK)
		{
			// fake "can see"
			Vector3 myOrg = OriginOf(ENT_ME);
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			string traceLine = LegacyFunction("get_traceline", myOrg, targOrg, "worldonly");
			if (traceLine == Text(targOrg))
			{
				NEXT_ATTACK = GameTime() + FREQ_ATTACK;
				OnZapTarget1();
			}
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_ALERT = false;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, ShadowForm_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
		OnDoManifest();
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/shadow_form_cl");
	}

	// do_manifest
	void OnDoManifest()
	{
		if (!DID_ALERT)
		{
			DID_ALERT = true;
			PlaySound(0, 10, SOUND_ALERT);

			float gameTime = GameTime();

			NEXT_IDLE_ZAP = gameTime + FREQ_IDLE_ZAP;

			NEXT_IDLE_SOUND = gameTime + FREQ_IDLE_SOUND;

			NEXT_ATTACK = gameTime + FREQ_ATTACK;

			NEXT_SHOCK_SCAN = gameTime + FREQ_SHOCK_SCAN;

			if (ToLowerCase(MapName()) == "nashalrath")
			{
				// weird shit going on here, music ends when mob dies
				CallExternal(NPCATK_TARGET, "ext_play_music", "Hashalgath.mp3");
			}
		}

		if (SHADOW_CL_ON)
			return;
		SHADOW_CL_ON = true;
		OnShadowClLoop();
	}

	// shadow_cl_loop
	void OnShadowClLoop()
	{
		if (!SHADOW_CL_ON)
			return;
		CallEventDelayed(FREQ_CL_UPDATE, "shadow_cl_loop");
		ClientEvent("new", "all", "monsters/shadow_form_cl", IndexOf(ENT_ME), FREQ_CL_UPDATE);
		CL_SCRIPT_IDX = LastClientScriptId();
	}

	// shock_scan
	void OnShockScan()
	{
		SCAN_TARGS = FindInSphere("enemy", RANGE_MINOR_STRIKE);
		if (SCAN_TARGS == "none")
			return;
		int count = GetTokenCount(SCAN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnShockScanLoop();
		}
	}

	// shock_scan_loop
	void OnShockScanLoop()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TARGS, loopIteration));
		if (!IsAlive(curTarg))
			return;
		if (EntityId(curTarg) == NPCATK_TARGET)
			return;
		OnAddMinorStrike(curTarg);
	}

	// zap_target1
	void OnZapTarget1()
	{
		if (!IsAlive(ENT_ME))
			return;
		PlaySound(0, 10, SOUND_ZAP_READY);
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 0, ENT_ME, 1, Vector3(128, 128, 128), 200, 255, 0.5f);
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 1, ENT_ME, 2, Vector3(128, 128, 128), 200, 255, 0.5f);
		Effect("beam", "ents", "lgtning.spr", 10, ENT_ME, 2, ENT_ME, 3, Vector3(128, 128, 128), 200, 255, 0.5f);
		CallEventDelayed(0.5f, "zap_target2");
	}

	// zap_target2
	void OnZapTarget2()
	{
		if (!IsAlive(ENT_ME))
			return;
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 0, ENT_ME, 1, Vector3(180, 180, 180), 200, 255, 0.5f);
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 2, Vector3(180, 180, 180), 200, 255, 0.5f);
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 3, Vector3(180, 180, 180), 200, 255, 0.5f);
		CallEventDelayed(0.5f, "zap_target3");
	}

	// zap_target3
	void OnZapTarget3()
	{
		if (!IsAlive(ENT_ME))
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		string traceLine = LegacyFunction("get_traceline", myOrg, targOrg, "worldonly");
		Effect("beam", "end", "lgtning.spr", 60, traceLine, ENT_ME, 0, Vector3(255, 255, 255), 200, 255, 3.0f);
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
		if (traceLine == Text(targOrg))
		{
			MISS_COUNT = 0.0f;
			DoDamage(NPCATK_TARGET, "direct", DMG_MAIN_ZAP, "100%", "lightning");
			ApplyEffect(NPCATK_TARGET, "effects/dot_lightning", 5.0f, self, DOT_MAIN_ZAP);
			AddVelocity(NPCATK_TARGET, RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, 800, 110)));
			NEXT_ATTACK = GameTime() + FREQ_ATTACK;
		}
		else
		{
			MISS_COUNT += 1.0f;
			if (MISS_COUNT > 2.0f)
			{
				OnNpcStuck();
				MISS_COUNT = 2.0f;
			}
		}
	}

	// npc_stuck
	void OnNpcStuck()
	{
		float rndP = Random(-359, 359);
		float rndY = Random(-359, 359);
		float rndR = Random(-359, 359);
		SetVelocity(ENT_ME, RelativePosition(Vector3(rndP, rndY, rndY), Vector3(0, 400, 0)));
	}

	// add_minor_strike
	// <id_to_que>
	void OnAddMinorStrike(CBaseEntity@ target = null)
	{
		ArrayAdd("ARRAY_MINOR_STRIKE", @target);
	}

	// minor_strike
	void OnMinorStrike()
	{
		string minorStrikeTarg = GetArray("ARRAY_MINOR_STRIKE", "0");
		ArrayRemoveAt("ARRAY_MINOR_STRIKE", 0);

		if (!(RangeTo(minorStrikeTarg) < RANGE_MINOR_STRIKE))
			return;

		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(minorStrikeTarg);
		string traceLine = LegacyFunction("get_traceline", myOrg, targOrg, "worldonly");
		int rndAtch = RandomInt(1, 3);
		if (traceLine == Text(targOrg))
		{
			Effect("beam", "end", "lgtning.spr", 10, traceLine, ENT_ME, rndAtch, Vector3(128, 128, 255), 200, 255, 2.0f);
			PlayRandomSound(0, 5, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);

			DoDamage(minorStrikeTarg, "direct", DMG_MINOR_STRIKE, "100%", "lightning");
			ApplyEffect(minorStrikeTarg, "effects/dot_lightning", 5.0f, self, "DOT_MINOR_ZAP");
			float targAng = AnglesTo(myOrg, targOrg);
			int newYaw = int(targAng);
			AddVelocity(minorStrikeTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 300, 110)));
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	void OnFreqClUpdate() {} // FREQ_CL_UPDATE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("shadowfog.spr");
		Precache("monsters/shadow_hitbox.mdl");
		CallEventDelayed(0.2f, "ShadowForm_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShadowForm_FirstThink();
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
		if (name == "add_minor_strike") { OnAddMinorStrike(EntityParam(params, 0)); return true; }
		if (name == "do_manifest") { OnDoManifest(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "minor_strike") { OnMinorStrike(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_stuck") { OnNpcStuck(); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "shadow_cl_loop") { OnShadowClLoop(); return true; }
		if (name == "shock_scan") { OnShockScan(); return true; }
		if (name == "shock_scan_loop") { OnShockScanLoop(); return true; }
		if (name == "zap_target1") { OnZapTarget1(); return true; }
		if (name == "zap_target2") { OnZapTarget2(); return true; }
		if (name == "zap_target3") { OnZapTarget3(); return true; }
		if (name == "ShadowForm_Timer") { ShadowForm_Timer(); return true; }
		return BaseFlyerGrav_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
