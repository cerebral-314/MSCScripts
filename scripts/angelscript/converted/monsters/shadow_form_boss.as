#pragma context server

// Converted from monsters/shadow_form_boss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "monsters/shadow_form_boss"]
class ShadowFormBoss : BaseNpcScript
{
	// Constants
	float FREQ_MANIFEST = 15.0f;
	float FREQ_BEAM = 0.0f;
	float DOT_SHOCK = 200.0f;
	int DOT_CAGE = 100;
	float DMG_BEAM = 200.0f;
	int BEAM_RANGE = 700;
	string SOUND_ZAP1 = "debris/zap1.wav";
	string SOUND_ZAP2 = "debris/zap3.wav";
	string SOUND_ZAP3 = "debris/zap8.wav";
	string SOUND_ATTACK1 = "monsters/undeadz/c_shadow_atk1.wav";
	string SOUND_ATTACK2 = "monsters/undeadz/c_shadow_atk2.wav";
	string SOUND_ATTACK3 = "monsters/undeadz/c_shadow_atk3.wav";
	string SOUND_MANIFEST1 = "monsters/undeadz/c_shadow_bat1.wav";
	string SOUND_MANIFEST2 = "monsters/undeadz/c_shadow_bat2.wav";
	string SOUND_PAIN = "monsters/undeadz/c_shadow_hit1.wav";
	string SOUND_CAGE_LOOP = "weapons/egon_run3.wav";
	string SOUND_IDLE_LOOP = "magic/chant_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	bool AM_VISIBLE = false;
	CBaseEntity@ BEAM_FX_ID = null;
	float NEXT_MANIFEST_CHECK = 0.0f;
	float NEXT_BEAM = 0.0f;
	string BEAM_TARGET = "BEAM_TARGET";
	float NEXT_NME_SCAN = 0.0f;
	float NEXT_CAGE = 0.0f;
	string CL_FX_ID = "CL_FX_ID";
	bool CAN_CAGE = false;
	float NEXT_MANIFEST = 0.0f;
	float FADE_STEP = 0.0f;
	float FADEOUT_STEP = 0.0f;
	bool TOTAL_INVIS = false;
	CBaseEntity@ CAGE_BEAM_ID = null;
	bool CAGE_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ShadowFormBoss()
	{
		NPC_IS_BOSS = true;
		SOUND_DEATH = "monsters/undeadz/c_shadow_dead.wav";
	}

	// unnamed block (first think)
	void ShadowFormBoss_FirstThink()
	{
		NPC_GIVE_EXP = 10000.0f;

		NPC_IS_BOSS = true;

		// const SOUND_LOOP_AURA1 magic/chant_loop.wav
		// const SOUND_LOOP_AURA2 magic/haunted_loop.wav
		ANIM_DEATH = "idle";
	}

	// game_damaged
	string ShadowFormBoss_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (AM_VISIBLE)
		{
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 255);
		}
		else
		{
			ClearEffects();
		}
		PlayRandomSound(0, 10, "SOUND_PAIN1", "SOUND_PAIN2", "SOUND_PAIN3");
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/shadow_form_boss_fx");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		DebugPrint("game_death - enter");
		if (ToLowerCase(MapName()) == "bloodshrine")
			CallExternal("all", "ext_boss_dead");
		if (CAGE_ACTIVE)
			OnExtEndCage();
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		ClientEvent("update", "all", CL_FX_ID, "boss_died");
		CallExternal(BEAM_FX_ID, "remove_beams");
		ServerPlaySound(2, 0, SOUND_IDLE_LOOP);
		DebugPrint("game_death - exit");
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		if (ToLowerCase(MapName()) == "bloodshrine")
			CallExternal("all", "ext_shadowform_boss");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		NPCATK_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Ancient Shadowform");
		SetUniqueName("shadowform_boss");
		SetModel("monsters/shadowform_eye.mdl");
		SetHealth(25000);
		SetWidth(64);
		SetHeight(64);
		SetFly(true);
		SetGravity(0);
		SetNoPush(true);
		SetMoveSpeed(0);
		SetHearingSensitivity(11);
		SetRace("undead");
		IMMUNE_VAMPIRE = true;

		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 0.2f);
		SetDamageTaken("fire", 0.2f);
		SetDamageTaken("acid", 0.2f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("slash", 0.5f);
		SetDamageTaken("blunt", 0.5f);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("holy", 1);
		SetDamageTaken("dark", 0);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SetInvincible(true);
		AM_VISIBLE = false;

		CallEventDelayed(0.1f, "cl_fx_loop");
		CallEventDelayed(0.5f, "setup_beams");
		NPCATK_TARGET = "unset";
		CallEventDelayed(1.0f, "npcatk_hunt");
	}

	// setup_beams
	void OnSetupBeams()
	{
		CreateNpc("monsters/shadow_form_boss_fx", RelativePosition(Vector3(0, 0, 0)));
		@BEAM_FX_ID = EntityOf(ENT_LASTCREATED);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		bool acquireTarget = false;
		if (CAGE_ACTIVE)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(heardId, ENT_ME) != "enemy")
			return;
		if (NPCATK_TARGET == "unset")
			acquireTarget = true;
		if (RangeTo(NPCATK_TARGET) > RangeTo(heardId))
			acquireTarget = true;
		if (!acquireTarget)
			return;
		NPCATK_TARGET = EntityId(heardId);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(0.1f, "npcatk_hunt");

		float gameTime = GameTime();

		if (!AM_VISIBLE && gameTime > NEXT_MANIFEST && gameTime > NEXT_MANIFEST_CHECK)
		{
			NEXT_MANIFEST_CHECK = gameTime + 3.0f;
			string nmeDetect = FindInSphere("enemy", 384);
			if (nmeDetect != "none")
			{
				nmeDetect = TokenShuffle(nmeDetect);
				NPCATK_TARGET = GetToken(nmeDetect, 0);
				OnDoManifest();
			}
		}

		if (gameTime > NEXT_BEAM)
		{
			NEXT_BEAM = gameTime + FREQ_BEAM;
			string beamTargs = FindInSphere("enemy", BEAM_RANGE);
			if (beamTargs == "none")
				NEXT_BEAM = gameTime + 1.0f;
			if (beamTargs != "none")
			{
				beamTargs = TokenShuffle(beamTargs);
				BEAM_TARGET = GetToken(beamTargs, 0);
				CallEventDelayed(0.1f, "do_beam");
			}
		}

		if (NPCATK_TARGET == "unset" && gameTime > NEXT_NME_SCAN)
		{
			NEXT_NME_SCAN = gameTime + 1.0f;
			OnRandomTarget();
		}

		if (AM_VISIBLE)
		{
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 255);
		}

		if (CAGE_ACTIVE)
			return;
		if (TOTAL_INVIS)
			return;

		if (NPCATK_TARGET == "unset")
			return;
		if (!IsAlive(NPCATK_TARGET))
		{
			NPCATK_TARGET = "unset";
		}
		else
		{
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			Vector3 myOrg = OriginOf(ENT_ME);
			Vector3 newAngs = Angles3DTo(myOrg, targOrg);
			// vectormultiply NEW_ANGS $vec(-1,1,1)
			// dbg NEW_ANGS
			SetAngle("face", newAngs);
			if (CAN_CAGE && gameTime > NEXT_CAGE)
			{
				NEXT_CAGE = gameTime + 1.0f;
				OnDoCage();
			}
		}
	}

	// cl_fx_loop
	void OnClFxLoop()
	{
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(2, 0, SOUND_IDLE_LOOP);
		ServerPlaySound(2, 10, SOUND_IDLE_LOOP);
		if (CL_FX_ID != "CL_FX_ID")
			ClientEvent("update", "all", CL_FX_ID, "remove_fx");
		ClientEvent("new", "all", "monsters/shadow_form_boss_cl", IndexOf(ENT_ME));
		CL_FX_ID = LastClientScriptId();
		CallEventDelayed(30.0f, "cl_fx_loop");
	}

	// ext_cl_fx_update
	// called by brush/gm
	void OnExtClFxUpdate()
	{
		if (CL_FX_ID != "CL_FX_ID")
			ClientEvent("update", "all", CL_FX_ID, "remove_fx");
		ClientEvent("new", "all", "monsters/shadow_form_boss_cl", IndexOf(ENT_ME));
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return ShadowFormBoss_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// make_visible
	void OnMakeVisible()
	{
		OnFadeIn();
		AM_VISIBLE = true;
		SetInvincible(false);
		CallEventDelayed(2.0f, "enable_cage");
		CallEventDelayed(20.0f, "make_invisible");
	}

	// enable_cage
	void OnEnableCage()
	{
		CAN_CAGE = true;
	}

	// make_invisible
	void OnMakeInvisible()
	{
		CAN_CAGE = false;
		AM_VISIBLE = false;
		NEXT_MANIFEST = GameTime() + FREQ_MANIFEST;
		OnFadeOut();
	}

	// fade_in
	void OnFadeIn()
	{
		FADE_STEP = 0.0f;
		OnFadeInLoop();
	}

	// fade_in_loop
	void OnFadeInLoop()
	{
		if (!(FADE_STEP < 255.0f))
			return;
		FADE_STEP += 5.0f;
		if (FADE_STEP == 255.0f)
			FADE_STEP = 255.0f;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", FADE_STEP);
		CallEventDelayed(0.1f, "fade_in_loop");
	}

	// fade_out
	void OnFadeOut()
	{
		FADEOUT_STEP = 255.0f;
		OnFadeOutLoop();
	}

	// fade_out_loop
	void OnFadeOutLoop()
	{
		if (!(FADEOUT_STEP > 0.0f))
			return;
		FADEOUT_STEP -= 5.0f;
		if (FADEOUT_STEP <= 0.0f)
		{
			FADEOUT_STEP = 0.0f;
			ClearEffects();
			SetInvincible(true);
			TOTAL_INVIS = true;
		}
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", FADEOUT_STEP);
		CallEventDelayed(0.1f, "fade_out_loop");
	}

	// do_manifest
	void OnDoManifest()
	{
		TOTAL_INVIS = false;
		NEXT_MANIFEST = GameTime() + 999.0f;
		OnMakeVisible();
	}

	// do_beam
	void OnDoBeam()
	{
		Vector3 beamColor = Vec("BEAM_COLOR");
		string rendProps = "REND_PROPS";
		string dmgType = "DMG_TYPE";

		Vector3 traceStart = OriginOf(ENT_ME);
		float rndAng = Random(0, 359.99f);
		float rndDist = Random(64, 150);
		traceStart += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, rndDist, 0));
		Vector3 traceEnd = OriginOf(BEAM_TARGET);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine == Text(traceEnd))
		{
			int beamType = RandomInt(1, 2);
			if (beamType == 1)
			{
				beamColor = Vector3(64, 128, 255);
				rendProps = "1;1.0;255;add;(64,128,255);1;1";
				dmgType = "lightning";
			}
			else
			{
				beamColor = Vector3(255, 0, 0);
				rendProps = "1;1.0;255;add;(255,0,0);1;1";
				dmgType = "dark";
			}
			Effect("beam", "point", "lgtning.spr", 60, traceStart, traceEnd, beamColor, 200, 10, 1.0f);
			ClientEvent("new", "all", "effects/sfx_sprite", traceStart, "3dmflaora.spr", rendProps, 2.0f);
			PlayRandomSound(1, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
			PlayRandomSound(3, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
			DoDamage(BEAM_TARGET, "direct", DMG_BEAM, "100%", ENT_ME, dmgType);
			if (beamType == 1)
				ApplyEffect(BEAM_TARGET, "effects/dot_lightning", 5.0f, self, DOT_SHOCK);
		}
		else
		{
			NEXT_BEAM = GameTime() + 1.0f;
		}
	}

	// do_cage
	void OnDoCage()
	{
		Vector3 traceStart = OriginOf(ENT_ME);
		Vector3 traceEnd = OriginOf(NPCATK_TARGET);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine == Text(traceEnd))
		{
			CAN_CAGE = false;
			NEXT_CAGE = GameTime() + 15.0f;
			PlayRandomSound(3, 10, SOUND_MANIFEST1, SOUND_MANIFEST2);
			ServerPlaySound(4, 10, SOUND_CAGE_LOOP);
			Effect("beam", "ents", "lgtning.spr", 90, ENT_ME, 1, NPCATK_TARGET, 1, Vector3(200, 255, 0), 255, 20, 15.0f);
			@CAGE_BEAM_ID = EntityOf(ENT_LASTCREATED);
			ApplyEffect(NPCATK_TARGET, "effects/dot_lightning_cage", 15.0f, self);
			ApplyEffect(NPCATK_TARGET, "effects/dot_lightning", 15.0f, self, DOT_CAGE, "none");
			CAGE_ACTIVE = true;
			CallEventDelayed(15.0f, "ext_end_cage");
		}
		else
		{
			CAN_CAGE = true;
			OnRandomTarget();
		}
	}

	// random_target
	void OnRandomTarget()
	{
		string nmeDetect = FindInSphere("enemy", 384);
		if (nmeDetect == "none")
			return;
		nmeDetect = TokenShuffle(nmeDetect);
		NPCATK_TARGET = GetToken(nmeDetect, 0);
	}

	// ext_end_cage
	void OnExtEndCage()
	{
		if (!CAGE_ACTIVE)
			return;
		CAGE_ACTIVE = false;
		ServerPlaySound(4, 0, SOUND_CAGE_LOOP);
		CAN_CAGE = false;
		Effect("beam", "update", @CAGE_BEAM_ID, "brightness", 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/shadowform_beams.mdl");
		Precache("shadowfog.spr");
		Precache("monsters/shadowform_eye.mdl");
		Precache("magic/chant_loop.wav");
		Precache("weapons/egon_run3.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ShadowFormBoss_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cl_fx_loop") { OnClFxLoop(); return true; }
		if (name == "do_beam") { OnDoBeam(); return true; }
		if (name == "do_cage") { OnDoCage(); return true; }
		if (name == "do_manifest") { OnDoManifest(); return true; }
		if (name == "enable_cage") { OnEnableCage(); return true; }
		if (name == "ext_cl_fx_update") { OnExtClFxUpdate(); return true; }
		if (name == "ext_end_cage") { OnExtEndCage(); return true; }
		if (name == "fade_in") { OnFadeIn(); return true; }
		if (name == "fade_in_loop") { OnFadeInLoop(); return true; }
		if (name == "fade_out") { OnFadeOut(); return true; }
		if (name == "fade_out_loop") { OnFadeOutLoop(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "make_invisible") { OnMakeInvisible(); return true; }
		if (name == "make_visible") { OnMakeVisible(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "random_target") { OnRandomTarget(); return true; }
		if (name == "setup_beams") { OnSetupBeams(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
