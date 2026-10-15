#pragma context server

// Converted from monsters/spider_thornlands.script by msc_transpiler.
// Giant Spider

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base_new.as"

[script "monsters/spider_thornlands"]
class SpiderThornlands : SpiderBaseNewScript
{
	// Variables declared by included files, with the value they start with in this script
	SpiderThornlands()
	{
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		SOUND_ATTACK1 = "zombie/claw_miss1.wav";
		SOUND_ATTACK2 = "zombie/claw_miss2.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_DODGE = "dodge";
		ATTACK_DAMAGE_LOW = 9.0f;
		ATTACK_DAMAGE_HIGH = 12.0f;
		ATTACK_ACCURACY = "85%";
		SPIDER_IDLE_VOL = 4;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 10;
	}

	// unnamed block (first think)
	void SpiderThornlands_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "50";
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 250.0f;
		NPC_GIVE_EXP = 100.0f;

		NPC_MUST_SEE_TARGET = "0"; // so big I can't see through myself?
	}

	// game_damaged_other
	string SpiderThornlands_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (PUSH_VEL == "PUSH_VEL")
			return result;

		AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SpiderThornlands_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBaseNew_OnNpcSpawn(npc); // monsters/spider_base_new

		SetHealth(500);
		SetWidth(120);
		SetHeight(64);
		SetName("Gigantic Cave Spider");
		SetHearingSensitivity(6);
		SetModel("monsters/giant_spider.mdl");
		NPC_GIVE_EXP = 100.0f; // doesn't seem to be coming accross in base_monster
		SetDamageTaken("all", 0.85f);

		CatchSpeech("debug_props", "debug");
	}

	// debug_props
	void OnDebugProps()
	{
		SetSayTextRange(1024);

		if (CanSee("enemy"))
			SayText("I see enemy. ( " + NameOf(ENT_LASTSEEN) + " )");
		if (IS_HUNTING)
			SayText("I am hunting: " + NameOf(HUNT_LASTTARGET));
		if (HUNTING_PLAYER)
			SayText("I am hunting a player.");

		if (!CanSee("enemy"))
			SayText("I see NO enemy.");
		if (!IS_HUNTING)
			SayText("I am NOT hunting.");
		if (!HUNTING_PLAYER)
			SayText("I am NOT hunting a player.");

		SayText("My cycle time is " + CYCLE_TIME);
	}

	// bite1
	// Deal damage
	void OnBite1()
	{
		if (RandomInt(0, 1) == 0)
			PlayRandomSound(Int(GetVar("CHAN_VOICE")), SPIDER_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2);
		PUSH_VEL = Text(RelativeVelocity(Vector3(0, 100, 0)));
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH)), "85%");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/giant_spider.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBaseNew_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderThornlands_FirstThink();
		SpiderBaseNew_FirstThink();
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
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SpiderBaseNewScript::DispatchEvent(name, params);
	}
}
