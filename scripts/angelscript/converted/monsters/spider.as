#pragma context server

// Converted from monsters/spider.script by msc_transpiler.
// Thothie - SOUND_IDLE = wrong convention not loaded by _base... Use SOUND_IDLE1
// Araneus Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Spider
{
	// Constants
	string SOUND_PAIN = "monsters/spider/spiderhiss.wav";
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SND_STRUCK4 = "SND_STRUCK4";
	string SND_STRUCK5 = "SND_STRUCK5";
	string SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	string ANIM_DODGE = "dodge";
	float ATTACK_DAMAGE_LOW = 2.0f;
	float ATTACK_DAMAGE_HIGH = 3.0f;
	string ATTACK_ACCURACY = "60%";
	int FIN_EXP = 12;
	int SPIDER_IDLE_VOL = 2;
	float SPIDER_IDLE_DELAY = 3.6f;
	int SPIDER_VOLUME = 10;
	bool SPIDER_LATCHATTACK = true;
	string SPIDER_MODEL = "monsters/spider.mdl";
	int SPIDER_LATCH_ATKDMG = 5;
	int SPIDER_LATCH_ATKDUR = 4;
	int SPIDER_LATCH_ATKCHANCE = 20;
	int SPIDER_LATCH_MAXRANGE = 200;
	string ANIM_LATCH_ATTACK = "jumpmiss";
	string ANIM_LATCH_HIT = "jumphit";
	string ANIM_LATCH_ON = "hitbite";
	string ANIM_LATCH_OFF = "falloff";
	string SOUND_LATCH_HISS = "monsters/spider/spiderhiss2.wav";
	string SOUND_LATCH_JUMP = "monsters/spider/spiderjump.wav";
	string SOUND_LATCH_PLYR = "monsters/spider/spiderlatch.wav";
	string SOUND_LATCH_MNTR = "SOUND_LATCH_MNTR";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string HUNT_AGRO = "HUNT_AGRO";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CAN_FLEE = "CAN_FLEE";
	bool SPIDER_LATCHING = false;
	string SPIDER_LATCH_TARGET = "SPIDER_LATCH_TARGET";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	bool SPIDER_LATCHED = false;

	// unnamed block (first think)
	void Spider_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "32";
		ATTACK_RANGE = 80.0f;
		NPC_GIVE_EXP = FIN_EXP;

		HUNT_AGRO = "1"; // base_npc_attack - Preemptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
	}

	// npc_spawn
	void Spider_OnNpcSpawn(string npc = "")
	{
		SetHealth(30);
		// ov 359
		SetWidth(34);
		SetHeight(40);
		SetHearingSensitivity(3);
		SetName("Leaping Cave Spider");
		NPC_GIVE_EXP = 16.0f;
		SetModel(SPIDER_MODEL);

		SetStat("awareness", 20);
		SetStat("parry", 50, 0, 0);
	}

	// game_parry
	// Dodge an attack
	void Spider_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		if (SPIDER_LATCHING)
			return;
		PlayAnim("critical", ANIM_DODGE);
	}

	// unnamed block (first think)
	// Latch onto unsuspecting n00bs
	// =============================
	void Spider_FirstThink2()
	{
		PrecacheFile("effects/effect_spiderlatch");
	}

	// unnamed block (timer)
	void Spider_Timer()
	{
		CallEventDelayed(4.0f, "Spider_Timer");

		if (!SPIDER_LATCHATTACK)
			return;
		if (!IS_HUNTING)
			return;
		if (!IsAlive(ENT_ME))
			return;
		if (!(RandomInt(0, 99) < SPIDER_LATCH_ATKCHANCE))
			return;
		if (SPIDER_LATCHING)
			return;
		if (!(DistanceTo(HUNT_LASTTARGET) < SPIDER_LATCH_MAXRANGE))
			return;
		if (!IsOnGround(ENT_ME))
			return;
		if (!IsOnGround(HUNT_LASTTARGET))
			return;

		PlayAnim("critical", ANIM_LATCH_ATTACK);
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_LATCH_HISS);
		SetMoveDest("none");
		SetAnimFrameRate(0.8f);
		SPIDER_LATCHING = true;
		SPIDER_LATCH_TARGET = HUNT_LASTTARGET;
		CAN_ATTACK = "0";
		CAN_HUNT = "0";
		CAN_HEAR = "0";
		CAN_RETALIATE = "0";
		SetRoam(false);
	}

	// frame_jump
	void Spider_OnFrameJump()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 320, 120)));
		SetGravity(0.9f);
		SetAnimFrameRate(0.5f);
		SetMoveSpeed(0);
		PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_LATCH_JUMP);
		CallEventDelayed(0.001f, "spider_latch_checkhitground");
	}

	// spider_latch_checkhitground
	void Spider_OnSpiderLatchCheckhitground()
	{
		if (!SPIDER_LATCHING)
			return;
		if (SPIDER_LATCHED)
			return;

		if (DistanceTo(SPIDER_LATCH_TARGET) < 70.0f)
		{
			OnSpiderLatchHit();
		}
		else if (Truthy(Eval("game.monster.onground")))
		{
			SetVelocity(ENT_ME, Vector3(0, 0, 0));
			SetAnimFrameRate(1);
			CallEventDelayed(0.2f, "spider_latch_resetmovement");
		}
		else
		{
			CallEventDelayed(0.001f, "spider_latch_checkhitground");
		}
	}

	// spider_latch_hit
	void Spider_OnSpiderLatchHit()
	{
		SPIDER_LATCHED = true;
		PlayAnim("break");
		SetIdleAnim(ANIM_LATCH_ON);
		SetOrigin(ENT_ME, OriginOf(SPIDER_LATCH_TARGET));
		LegacyCommand("setfollow", SPIDER_LATCH_TARGET, "align_bottom");
		SetAngle("face.pitch", 0);
		ApplyEffect(SPIDER_LATCH_TARGET, "effects/effect_spiderlatch", SPIDER_LATCH_ATKDUR, self, SPIDER_LATCH_ATKDMG);
		if (IsPlayer(SPIDER_LATCH_TARGET))
			PlaySound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_LATCH_PLYR);
		else
			PlaySound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_LATCH_MNTR);
		SetBoundingBox(Vector3(-40, -40, 0), Vector3(40, 40, 128));
		OnSpiderLatchThink();
		CallEventDelayed(SPIDER_LATCH_ATKDUR, "spider_latch_drop");
	}

	// spider_latch_think
	void Spider_OnSpiderLatchThink()
	{
		if (!SPIDER_LATCHED)
			return;
		if (!IsAlive(SPIDER_LATCH_TARGET))
			OnSpiderLatchDrop();
		else
			CallEventDelayed(0.01f, "spider_latch_think");
	}

	// spider_latch_drop
	void Spider_OnSpiderLatchDrop()
	{
		if (!SPIDER_LATCHING)
			return;
		SPIDER_LATCHED = false;
		LegacyCommand("setfollow", "none");
		SetGravity(1);
		SetMoveSpeed(-1);
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		PlayAnim("critical", ANIM_LATCH_OFF);
		PlaySound(Int(Eval("game.sound.body")), 0);
	}

	// spider_latch_resetmovement
	void Spider_OnSpiderLatchResetmovement()
	{
		SetRoam(true);
		SetMoveSpeed(1);
		SetGravity(1);
		SetIdleAnim(ANIM_IDLE);
		CAN_ATTACK = "1";
		CAN_HUNT = "1";
		CAN_HEAR = "1";
		CAN_RETALIATE = "1";
		SPIDER_LATCHING = false;
		SPIDER_LATCHED = false;
	}

	// frame_falloffend
	void Spider_OnFrameFalloffend()
	{
		SetIdleAnim(ANIM_IDLE);
		CallEventDelayed(0.2f, "spider_latch_resetmovement");
		PlayAnim("critical", ANIM_IDLE);
		SetBoundingBox("npcsize");
	}

	// npc_struck
	// Can be knocked off
	void Spider_OnNpcStruck(float damage = 0.0f)
	{
		if (!SPIDER_LATCHED)
			return;
		OnSpiderLatchDrop();
	}

	// npc_death
	// unattach when dead
	void Spider_OnNpcDeath()
	{
		if (!SPIDER_LATCHED)
			return;
		LegacyCommand("setfollow", "none");
		OnSpiderLatchResetmovement();
	}

	// frame_bite1
	void Spider_OnFrameBite1()
	{
		SetAnimFrameRate(Float(BASE_FRAMERATE));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base
		Spider_OnNpcSpawn(npc);
	}

	// frame_bite1
	void OnFrameBite1()
	{
		SpiderBase_OnFrameBite1(); // monsters/spider_base
		Spider_OnFrameBite1();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		SpiderBase_OnNpcStruck(damage); // monsters/spider_base
		Spider_OnNpcStruck(damage);
	}

	// npc_death
	void OnNpcDeath()
	{
		SpiderBase_OnNpcDeath(); // monsters/spider_base
		Spider_OnNpcDeath();
	}

	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f) { Spider_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); } // game_parry
	void OnFrameJump() { Spider_OnFrameJump(); } // frame_jump
	void OnSpiderLatchCheckhitground() { Spider_OnSpiderLatchCheckhitground(); } // spider_latch_checkhitground
	void OnSpiderLatchHit() { Spider_OnSpiderLatchHit(); } // spider_latch_hit
	void OnSpiderLatchThink() { Spider_OnSpiderLatchThink(); } // spider_latch_think
	void OnSpiderLatchDrop() { Spider_OnSpiderLatchDrop(); } // spider_latch_drop
	void OnSpiderLatchResetmovement() { Spider_OnSpiderLatchResetmovement(); } // spider_latch_resetmovement
	void OnFrameFalloffend() { Spider_OnFrameFalloffend(); } // frame_falloffend
	void OnSpiderLatchAtkdur() {} // SPIDER_LATCH_ATKDUR

	// This file's events and timers by their .script names
	bool Spider_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "frame_bite1") { OnFrameBite1(); return true; }
		if (name == "frame_falloffend") { OnFrameFalloffend(); return true; }
		if (name == "frame_jump") { OnFrameJump(); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "spider_latch_checkhitground") { OnSpiderLatchCheckhitground(); return true; }
		if (name == "spider_latch_drop") { OnSpiderLatchDrop(); return true; }
		if (name == "spider_latch_hit") { OnSpiderLatchHit(); return true; }
		if (name == "spider_latch_resetmovement") { OnSpiderLatchResetmovement(); return true; }
		if (name == "spider_latch_think") { OnSpiderLatchThink(); return true; }
		if (name == "Spider_Timer") { Spider_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/spider"]
shared class SpiderScript : SpiderBaseScript, Spider
{
	// Variables declared by included files, with the value they start with in this script
	SpiderScript()
	{
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_DAMAGE_LOW = 2.0f;
		ATTACK_DAMAGE_HIGH = 3.0f;
		ATTACK_ACCURACY = "60%";
		SPIDER_IDLE_VOL = 2;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/spider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(4.0f, "Spider_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Spider_FirstThink();
		SpiderBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		Spider_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Spider_DispatchEvent(name, params)
			|| SpiderBaseScript::DispatchEvent(name, params);
	}
}
