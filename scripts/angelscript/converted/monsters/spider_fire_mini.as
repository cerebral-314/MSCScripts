#pragma context server

// Converted from monsters/spider_fire_mini.script by msc_transpiler.
// lil fire spider
// big ones go splodie on death

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/spider_fire_mini"]
class SpiderFireMini : BaseMonsterNewScript
{
	// Constants
	string ANIM_DODGE = "dodge";
	float FREQ_IDLE_NOISE = 3.6f;
	float DMG_BITE = 0.0f;
	float FREQ_LEAP = 15.0f;
	int RANGE_LEAP_MAX = 512;
	int RANGE_LEAP_LONG = 256;
	int RANGE_LEAP_SHORT = 64;
	int DMG_BURN_DOT = 10;
	string ANIM_LEAP = "jump_miss";
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_STRUCK4 = "monsters/spider/spiderhiss.wav";
	string SOUND_STRUCK5 = "monsters/spider/spiderhiss.wav";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string ANIM_LATCH_ON = "hitbite";
	string ANIM_LATCH_OFF = "falloff";
	string SOUND_LATCH_HISS = "monsters/spider/spiderhiss2.wav";
	string SOUND_LATCH_JUMP = "monsters/spider/spiderjump.wav";
	string SOUND_LATCH_PLYR = "monsters/spider/spiderlatch.wav";
	string SOUND_LATCH_MNTR = "body/flesh1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float LAST_LEAP = 0.0f;
	bool JUMP_SCAN_ACTIVE = false;
	int MY_V_POS = 0;
	bool AM_CHEWING = false;
	string LATCH_TARGET = "LATCH_TARGET";
	bool ROLLING_AWAY = false;

	// Variables declared by included files, with the value they start with in this script
	SpiderFireMini()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
	}

	// unnamed block (first think)
	void SpiderFireMini_FirstThink()
	{
		// base anims
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		// base stats
		MOVE_RANGE = "30";
		ATTACK_RANGE = 50.0f;
		ATTACK_HITRANGE = 80.0f;
		NPC_GIVE_EXP = 10.0f;
	}

	// unnamed block (timer)
	void SpiderFireMini_Timer()
	{
		CallEventDelayed(FREQ_IDLE_NOISE, "SpiderFireMini_Timer");

		if (!Truthy(Eval("game.monster.alive")))
			return;

		ServerPlaySound(2, 5, SOUND_IDLE1);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ServerPlaySound(2, 0, SOUND_IDLE1);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(Int(Eval("game.sound.body")), 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Fire Spider Hatchling");
		SetModel("monsters/fer_spider_mini.mdl");
		SetProp(ENT_ME, "skin", 1);
		SetHealth(10);
		SetWidth(16);
		SetHeight(20);
		SetRace("demon");
		SetHearingSensitivity(6);
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetBoundingBox("npcsize"); // hoping will help with "reach" issues

		SetSolid("none");
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (NPCATK_TARGET == "unset")
			return;
		if (!(GameTime() > LAST_LEAP))
			return;
		if (!(RangeTo(NPCATK_TARGET) < RANGE_LEAP_MAX))
			return;

		LAST_LEAP = GameTime() + FREQ_LEAP;

		OnNpcatkSuspendAi();

		PlayAnim("critical", ANIM_LEAP);
		SetMoveDest(NPCATK_TARGET, 999);
		CallEventDelayed(0.1f, "leap_boost");
		CallEventDelayed(1.0f, "check_hit");
	}

	// bite1
	// model anim
	void OnBite1()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_BITE), "ATTACK_ACCURACY");
	}

	// check_hit
	void OnCheckHit()
	{
		if (AM_CHEWING)
			return;
		OnNpcatkResumeAi();
		JUMP_SCAN_ACTIVE = false;
	}

	// leap_boost
	void OnLeapBoost()
	{
		Vector3 jumpVel = Vec("JUMP_VEL");
		PlaySound(0, 10, SOUND_LATCH_HISS);
		if (RangeTo(NPCATK_TARGET) >= RANGE_LEAP_LONG)
			jumpVel = RelativeVelocity(Vector3(0, 800, 300));
		if (RangeTo(NPCATK_TARGET) < RANGE_LEAP_LONG)
			jumpVel = RelativeVelocity(Vector3(0, 400, 200));
		if (RangeTo(NPCATK_TARGET) <= RANGE_LEAP_SHORT)
			jumpVel = RelativeVelocity(Vector3(0, 200, 50));
		AddVelocity(ENT_ME, jumpVel);
		JUMP_SCAN_ACTIVE = true;
		CallEventDelayed(0.1f, "jump_scan");
	}

	// jump_scan
	void OnJumpScan()
	{
		if (!JUMP_SCAN_ACTIVE)
			return;
		CallEventDelayed(0.1f, "jump_scan");
		string inBox = FindInBox("enemy", 64);
		if (inBox == "none")
			return;
		inBox = SortEntities(inBox, "range");
		OnLatchOnto(FindEntity(GetToken(inBox, 0)));
	}

	// latch_onto
	void OnLatchOnto(CBaseEntity@ target = null)
	{
		SetSolid("box");
		MY_V_POS = RandomInt(-64, 0);
		AM_CHEWING = true;
		JUMP_SCAN_ACTIVE = false;
		LATCH_TARGET = EntityId(target);
		// setfollow LATCH_TARGET align_bottom
		PlayAnim("break");
		SetAngle("face.pitch", 0);
		SetIdleAnim(ANIM_LATCH_ON);
		SetMoveAnim(ANIM_LATCH_ON);
		// applyeffect LATCH_TARGET effects/effect_spiderlatch 5.0 DMG_BITE $get(ent_me,id)
		ApplyEffect(LATCH_TARGET, "effects/dot_fire", 10.0f, self, DMG_BURN_DOT);
		SetBoundingBox(Vector3(-40, -40, 0), Vector3(40, 40, 128));
		OnSpiderLatchThink();
		CallEventDelayed(5.0f, "do_dismount");
	}

	// spider_latch_think
	void OnSpiderLatchThink()
	{
		Vector3 targOrg;

		if (!AM_CHEWING)
			return;

		DebugPrint("chewing");
		// target face
		if (IsPlayer(LATCH_TARGET))
		{
			targOrg = EyePositionOf(LATCH_TARGET);
		}
		else
		{
			targOrg = OriginOf(LATCH_TARGET);
			float targHeight = HeightOf(LATCH_TARGET);
			targOrg.z += targHeight;
		}
		float targYaw = AnglesOf(LATCH_TARGET).y;
		targOrg += RelativePosition(Vector3(0, targYaw, 0), Vector3(0, 5, MY_V_POS));
		SetOrigin(ENT_ME, targOrg);

		if (!IsAlive(LATCH_TARGET))
			OnDoDismount();
		else
			CallEventDelayed(0.01f, "spider_latch_think");
	}

	// do_dismount
	void OnDoDismount()
	{
		SetSolid("none");
		ROLLING_AWAY = true;
		OnRollAway();

		AM_CHEWING = false;
		// setfollow none
		PlayAnim("critical", ANIM_LATCH_OFF);
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		OnNpcatkResumeAi();
	}

	// roll_away
	void OnRollAway()
	{
		if (!IsAlive(ENT_ME))
			return;
		if (!ROLLING_AWAY)
			return;
		// callevent as_check_spawn_stuck
		// callevent 0.1 roll_away
		// leap away
		Vector3 targetOrg = OriginOf(LATCH_TARGET);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, -500, 10)));
	}

	// frame_falloffend
	void OnFrameFalloffend()
	{
		ROLLING_AWAY = false;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		PlayAnim("critical", ANIM_IDLE);
		SetBoundingBox("npcsize");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider_mini.mdl");
		Precache("monsters/spider/spideridle.wav");
		CallEventDelayed(FREQ_IDLE_NOISE, "SpiderFireMini_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderFireMini_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "check_hit") { OnCheckHit(); return true; }
		if (name == "do_dismount") { OnDoDismount(); return true; }
		if (name == "frame_falloffend") { OnFrameFalloffend(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "jump_scan") { OnJumpScan(); return true; }
		if (name == "latch_onto") { OnLatchOnto(EntityParam(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "roll_away") { OnRollAway(); return true; }
		if (name == "spider_latch_think") { OnSpiderLatchThink(); return true; }
		if (name == "SpiderFireMini_Timer") { SpiderFireMini_Timer(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
