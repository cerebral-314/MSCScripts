#pragma context server

// Converted from monsters/spider_mini_poison.script by msc_transpiler.
// Mini-Spider + Poison by Thothie (from spider_mini)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_base.as"

[script "monsters/spider_mini_poison"]
class SpiderMiniPoison : SpiderBaseScript
{
	// Constants
	bool DELETE_ON_DEATH = true;

	// Variables declared by included files, with the value they start with in this script
	SpiderMiniPoison()
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
		ATTACK_DAMAGE_LOW = 1.0f;
		ATTACK_DAMAGE_HIGH = 2.0f;
		ATTACK_ACCURACY = "40%";
		SPIDER_IDLE_VOL = 1;
		SPIDER_IDLE_DELAY = 3.6f;
		SPIDER_VOLUME = 5;
	}

	// unnamed block (first think)
	void SpiderMiniPoison_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";

		MOVE_RANGE = "30";
		ATTACK_RANGE = 38.0f;
		NPC_GIVE_EXP = 25.0f;

		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		RETALIATE_CHANCE = "75%"; // base_npc_attack - Automatically switch targets to the last damaging player
		CAN_FLEE = "0"; // base_npc_attack - Whether I run away at low health
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SpiderBase_OnNpcSpawn(npc); // monsters/spider_base

		SetHealth(30);
		// ov 359
		SetWidth(16);
		SetHeight(20);
		SetHearingSensitivity(3);
		SetName("Poisonous Spider");
		NPC_GIVE_EXP = 20.0f; // not getting set proper in base_monster, near as I can tell
		SetModel("monsters/fer_spider_mini.mdl");
		SetModelBody(0, 2);
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_poison", RandomInt(3, 5), self, RandomInt(1, 5));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider_mini.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderMiniPoison_FirstThink();
		SpiderBase_FirstThink();
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
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return SpiderBaseScript::DispatchEvent(name, params);
	}
}
