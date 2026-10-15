#pragma context server

// Converted from deralia/boss_spider.script by msc_transpiler.
// Inn Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

[script "deralia/boss_spider"]
class BossSpider : SpiderBaseScript
{
	// Constants
	string ANIM_DODGE = "dodge";
	bool SPIDER_LATCHATTACK = true;
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
	string SOUND_LATCH = "monsters/spider/spiderlatch.wav";

	// Variables (an unset .script variable reads as its own name)
	bool SPIDER_LATCHING = false;
	string SPIDER_LATCH_TARGET = "SPIDER_LATCH_TARGET";
	bool SPIDER_LATCHED = false;

	// Variables declared by included files, with the value they start with in this script
	BossSpider()
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
		ATTACK_DAMAGE_LOW = 7.0f;
		ATTACK_DAMAGE_HIGH = 9.0f;
		ATTACK_ACCURACY = "60%";
		SPIDER_IDLE_VOL = 2;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// unnamed block (first think)
	void BossSpider_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "32";
		ATTACK_RANGE = 60.0f;
		NPC_GIVE_EXP = 12.0f;

		HUNT_AGRO = "1"; // base_npc_attack - Preemptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
	}

	// unnamed block (first think)
	// Latch onto unsuspecting n00bs
	// =============================
	void BossSpider_FirstThink2()
	{
		PrecacheFile("effects/effect_spiderlatch");
	}

	// unnamed block (timer)
	void BossSpider_Timer()
	{
		CallEventDelayed(5.0f, "BossSpider_Timer");

		if (!IS_HUNTING)
			return;
		// if !IS_ATTACKING
		if (!IsAlive(ENT_ME))
			return;
		if (!(RandomInt(0, 99) < SPIDER_LATCH_ATKCHANCE))
			return;
		if (SPIDER_LATCHING)
			return;
		if (!(Float(Eval("game.monster.last_seen.distance")) < SPIDER_LATCH_MAXRANGE))
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

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base

		SetHealth(30);
		SetWidth(40);
		SetHeight(64);
		SetHearingSensitivity(3);
		SetName("Araneus");
		NPC_GIVE_EXP = 16.0f;
		SetModel("monsters/spider.mdl");

		SetStat("awareness", 20);
		SetStat("parry", 50, 0, 0);
	}

	// game_parry
	// Dodge an attack
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		SpiderBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/spider_base

		if (SPIDER_LATCHING)
			return;
		PlayAnim("critical", ANIM_DODGE);
	}

	// npc_struck
	// Can be knocked off
	void OnNpcStruck(float damage = 0.0f)
	{
		SpiderBase_OnNpcStruck(damage); // monsters/spider_base

		if (!SPIDER_LATCHED)
			return;
		OnSpiderLatchDrop();
	}

	// npc_death
	// unattach when dead
	void OnNpcDeath()
	{
		SpiderBase_OnNpcDeath(); // monsters/spider_base

		if (!SPIDER_LATCHED)
			return;

		LegacyCommand("setfollow", "none");
		OnSpiderLatchResetmovement();
	}

	// frame_jump
	void OnFrameJump()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 320, 120)));
		SetGravity(0.9f);
		SetAnimFrameRate(0.5f);
		SetMoveSpeed(0);
		PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_LATCH_JUMP);
		CallEventDelayed(0.001f, "spider_latch_checkhitground");
	}

	// spider_latch_checkhitground
	void OnSpiderLatchCheckhitground()
	{
		if (!SPIDER_LATCHING)
			return;
		if (SPIDER_LATCHED)
			return;
		if (DistanceTo(SPIDER_LATCH_TARGET) < 70.0f)
		{
			OnSpiderLatchHit();
		}
		else if (IsOnGround(ENT_ME))
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
	void OnSpiderLatchHit()
	{
		SPIDER_LATCHED = true;
		PlayAnim("break");
		SetIdleAnim(ANIM_LATCH_ON);
		SetOrigin(ENT_ME, OriginOf(SPIDER_LATCH_TARGET));
		LegacyCommand("setfollow", SPIDER_LATCH_TARGET, "align_bottom");
		SetAngle("face.x", 0);
		ApplyEffect(SPIDER_LATCH_TARGET, "effects/effect_spiderlatch", SPIDER_LATCH_ATKDUR, ENT_ME, SPIDER_LATCH_ATKDMG);
		PlaySound(Int(Eval("game.sound.body")), Eval("game.sound.maxvol"), SOUND_LATCH);
		SetBoundingBox(Vector3(-40, -40, 0), Vector3(40, 40, 128));
		OnSpiderLatchThink();
		CallEventDelayed(SPIDER_LATCH_ATKDUR, "spider_latch_drop");
	}

	// spider_latch_think
	void OnSpiderLatchThink()
	{
		if (!SPIDER_LATCHED)
			return;
		if (!IsAlive(SPIDER_LATCH_TARGET))
			OnSpiderLatchDrop();
		else
			CallEventDelayed(0.01f, "spider_latch_think");
	}

	// spider_latch_drop
	void OnSpiderLatchDrop()
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
	void OnSpiderLatchResetmovement()
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
	void OnFrameFalloffend()
	{
		SetIdleAnim(ANIM_IDLE);
		CallEventDelayed(0.2f, "spider_latch_resetmovement");
		PlayAnim("critical", ANIM_IDLE);
		SetBoundingBox("npcsize");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSpiderLatchAtkdur() {} // SPIDER_LATCH_ATKDUR

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/spider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(5.0f, "BossSpider_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BossSpider_FirstThink();
		SpiderBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		BossSpider_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
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
		if (name == "BossSpider_Timer") { BossSpider_Timer(); return true; }
		return SpiderBaseScript::DispatchEvent(name, params);
	}
}
