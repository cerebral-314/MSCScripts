#pragma context server

// Converted from monsters/bear_base_giant.script by msc_transpiler.
// Standard Giant Bear

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BearBaseGiant
{
	// Constants
	string ATTACK_NORMAL_DAMAGE = "10";
	string ATTACK_STANDING_DAMAGE = "ATTACK_STANDING_DAMAGE";
	int ATTACK_STOMPRANGE = 160;
	int ATTACK_STOMPDMG = 5;
	string NPC_BASE_EXP = "90";
	string BEAR_VOLUME = "game.sound.maxvol";
	string SOUND_DEATH = "monsters/bear/giantbeardeath.wav";
	string SOUND_DEATH2 = "monsters/bear/giantbeardeath2.wav";
	string SOUND_GETUP_GROWL = "monsters/bear/giantbeardeath2.wav";
	string SOUND_GETUP = "monsters/troll/step1.wav";
	string SOUND_GETDOWN = "monsters/troll/step2.wav";
	string SOUND_UPSNARL = "monsters/bear/giantbearupsnarl.wav";
	string SOUND_UPSTEP1 = "monsters/bear/giantbearstep1.wav";
	string SOUND_UPSTEP2 = "monsters/bear/giantbearstep2.wav";
	bool NPC_AUTO_DEATH = false;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float MSC_PUSH_RESIST = 0.0f;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	bool BEAR_STANDING = false;
	bool BEAR_CANSTAND = true;
	bool BEAR_ISSTOMPATK = false;
	bool BEAR_ISDDEAD = false;
	float STAND_HEALTH = 0.0f;
	float AS_ATTACKING = 0.0f;
	string CAN_ATTACK = "CAN_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool BEAR_ISDEAD = false;

	// unnamed block (first think)
	void BearBaseGiant_FirstThink()
	{
		MSC_PUSH_RESIST = 0.75f;
		ATTACK_DAMAGE = ATTACK_NORMAL_DAMAGE;
		MOVE_RANGE = "108";
		ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = 160.0f;
	}

	// game_postspawn
	void BearBaseGiant_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		if (StartsWith(ToLowerCase(MapName()), "skycastle"))
			DROP_ITEM1_CHANCE = "0%";
	}

	// npc_spawn
	void BearBaseGiant_OnNpcSpawn(string npc = "")
	{
		SetHealth(170);
		// ov 150
		SetWidth(105);
		SetHeight(95);
		SetVolume(10);
		SetModel("monsters/giant_bear.mdl");
		SetHearingSensitivity(8);

		ANIM_ATTACK = "attack"; // part of the workaround
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		BEAR_STANDING = false;
		BEAR_CANSTAND = true;
		BEAR_ISSTOMPATK = false;
		BEAR_ISDDEAD = false;
	}

	// npc_post_spawn
	void BearBaseGiant_OnNpcPostSpawn()
	{
		STAND_HEALTH = MyMaxHealth() * 0.75f;
	}

	// frame_runstomp
	void BearBaseGiant_OnFrameRunstomp()
	{
		OnBearShake();
	}

	// frame_attack1
	// ATTACK
	void BearBaseGiant_OnFrameAttack1()
	{
		PlayRandomSound(Int(Eval("game.sound.weapon")), BEAR_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3); // Attack grunts

		BEAR_ISSTOMPATK = false;
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// game_damaged_other
	string BearBaseGiant_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		bool shouldPushEntity = true;
		if (BEAR_ISSTOMPATK)
		{
			// Let player jump to avoid stomp damage
			if (!IsOnGround(ENT_LASTSTRUCKBYME))
			{
				shouldPushEntity = false;
				SetVar(Eval("game.monster.canceldamage"), 1);
			}
		}

		if (!shouldPushEntity)
			return result;

		int forwardpush = 190;
		float sidepush = Random(-60, 0);
		int uppush = 10;
		if (BEAR_ISDEAD)
		{
			forwardpush = 100;
			sidepush = 0.0f;
			uppush = 200;
		}

		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(sidepush, forwardpush, uppush))); // Push the player a bit
		return result;
	}

	// unnamed block (timer)
	// STAND UP ON HIND LEGS
	// ---------------------
	void BearBaseGiant_Timer()
	{
		// Stand up after some health is gone
		CallEventDelayed(3.0f, "BearBaseGiant_Timer");

		if (BEAR_STANDING && RandomInt(0, 100) < 25)
			PlaySound(0, 10, BEAR_VOLUME, SOUND_UPSNARL);

		if (!(RandomInt(0, 100) < 50))
			return;
		if (!(MyHealth() < STAND_HEALTH))
			return;
		if (BEAR_STANDING)
			return;
		if (!BEAR_CANSTAND)
			return;
		if (!IS_HUNTING)
			return;
		if (!(Float(LegacyFunction("cansee", ENT_LASTSEEN, "range")) < 250.0f))
			return;

		OnBearStandup();
	}

	// bear_standup
	void BearBaseGiant_OnBearStandup()
	{
		BEAR_STANDING = true;
		ANIM_ATTACK = "upattack";
		ANIM_IDLE = "upidle";
		ANIM_WALK = "upwalk";
		ANIM_RUN = "upwalk";
		ATTACK_DAMAGE = ATTACK_STANDING_DAMAGE;

		CallEventDelayed(RandomInt(7, 15), "bear_getdown");
		SetIdleAnim("upidle");
		SetMoveAnim(ANIM_WALK);
		SetDamageTaken("all", 0.6f);
		PlayAnim("critical", "getup");
		AS_ATTACKING = GameTime();
		PlaySound(Int(Eval("game.sound.voice")), BEAR_VOLUME, SOUND_GETUP_GROWL);
	}

	// bear_getdown
	void BearBaseGiant_OnBearGetdown()
	{
		BEAR_STANDING = false;
		BEAR_CANSTAND = false;
		ANIM_ATTACK = "attack";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_DAMAGE = ATTACK_NORMAL_DAMAGE;
		CAN_ATTACK = "0";
		SetIdleAnim("idle");
		SetMoveAnim(ANIM_WALK);
		AS_ATTACKING = GameTime();
		PlayAnim("critical", "getdown");
		SetDamageTaken("all", 1);
		OnBearStomp();
		CallEventDelayed(15.0f, "bear_resetstand");
		CallEventDelayed(3.0f, "bear_falldelay");
	}

	// bear_falldelay
	void BearBaseGiant_OnBearFalldelay()
	{
		CAN_ATTACK = "1"; // Resume attack after a slight delay
	}

	// frame_getup
	void BearBaseGiant_OnFrameGetup()
	{
		PlaySound(Int(Eval("game.sound.voice")), BEAR_VOLUME, SOUND_GETUP);
	}

	// frame_upstep
	void BearBaseGiant_OnFrameUpstep()
	{
		OnBearWalkeffect();
	}

	// frame_hitground
	void BearBaseGiant_OnFrameHitground()
	{
		OnBearShake();
		OnBearStomp();
	}

	// bear_resetstand
	void BearBaseGiant_OnBearResetstand()
	{
		BEAR_CANSTAND = true;
	}

	// npc_death
	// --------------------------
	// --------------------------
	void BearBaseGiant_OnNpcDeath()
	{
		PlayRandomSound(2, SOUND_DEATH, SOUND_DEATH2);

		if (BEAR_STANDING)
			ANIM_DEATH = "updeath";

		PlayAnim("critical", ANIM_DEATH);
		BEAR_ISDEAD = true;
	}

	// bear_shake
	void BearBaseGiant_OnBearShake()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 190, 20, 1, 256);
		PlaySound(1, 10, SOUND_GETDOWN);
	}

	// bear_walkeffect
	void BearBaseGiant_OnBearWalkeffect()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 128, 10, 1, 128);
		PlayRandomSound(1, SOUND_UPSTEP1, SOUND_UPSTEP2);
	}

	// bear_stomp
	void BearBaseGiant_OnBearStomp()
	{
		BEAR_ISSTOMPATK = true;
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), ATTACK_STOMPRANGE, ATTACK_STOMPDMG, "100%", 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BearBaseGiant_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
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
		BearBaseGiant_OnNpcPostSpawn();
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		BearBase_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/bear_base
		BearBaseGiant_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc); // monsters/bear_base
		BearBaseGiant_OnNpcSpawn(npc);
	}

	void OnFrameRunstomp() { BearBaseGiant_OnFrameRunstomp(); } // frame_runstomp
	void OnFrameAttack1() { BearBaseGiant_OnFrameAttack1(); } // frame_attack1
	void OnBearStandup() { BearBaseGiant_OnBearStandup(); } // bear_standup
	void OnBearGetdown() { BearBaseGiant_OnBearGetdown(); } // bear_getdown
	void OnBearFalldelay() { BearBaseGiant_OnBearFalldelay(); } // bear_falldelay
	void OnFrameGetup() { BearBaseGiant_OnFrameGetup(); } // frame_getup
	void OnFrameUpstep() { BearBaseGiant_OnFrameUpstep(); } // frame_upstep
	void OnFrameHitground() { BearBaseGiant_OnFrameHitground(); } // frame_hitground
	void OnBearResetstand() { BearBaseGiant_OnBearResetstand(); } // bear_resetstand
	void OnNpcDeath() { BearBaseGiant_OnNpcDeath(); } // npc_death
	void OnBearShake() { BearBaseGiant_OnBearShake(); } // bear_shake
	void OnBearWalkeffect() { BearBaseGiant_OnBearWalkeffect(); } // bear_walkeffect
	void OnBearStomp() { BearBaseGiant_OnBearStomp(); } // bear_stomp

	// This file's events and timers by their .script names
	bool BearBaseGiant_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bear_falldelay") { OnBearFalldelay(); return true; }
		if (name == "bear_getdown") { OnBearGetdown(); return true; }
		if (name == "bear_resetstand") { OnBearResetstand(); return true; }
		if (name == "bear_shake") { OnBearShake(); return true; }
		if (name == "bear_standup") { OnBearStandup(); return true; }
		if (name == "bear_stomp") { OnBearStomp(); return true; }
		if (name == "bear_walkeffect") { OnBearWalkeffect(); return true; }
		if (name == "frame_attack1") { OnFrameAttack1(); return true; }
		if (name == "frame_getup") { OnFrameGetup(); return true; }
		if (name == "frame_hitground") { OnFrameHitground(); return true; }
		if (name == "frame_runstomp") { OnFrameRunstomp(); return true; }
		if (name == "frame_upstep") { OnFrameUpstep(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "BearBaseGiant_Timer") { BearBaseGiant_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bear_base_giant"]
shared class BearBaseGiantScript : BearBaseScript, BearBaseGiant
{
	// Variables declared by included files, with the value they start with in this script
	BearBaseGiantScript()
	{
		ANIM_IDLE = "ANIM_IDLE";
		ANIM_WALK = "ANIM_WALK";
		ANIM_RUN = "ANIM_RUN";
		SOUND_DEATH = "monsters/bear/giantbeardeath.wav";
		NPC_AUTO_DEATH = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_bear.mdl");
		CallEventDelayed(3.0f, "BearBaseGiant_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearBaseGiant_FirstThink();
		BearBase_FirstThink();
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
		return BearBaseGiant_DispatchEvent(name, params)
			|| BearBaseScript::DispatchEvent(name, params);
	}
}
