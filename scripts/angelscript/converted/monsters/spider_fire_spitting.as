#pragma context server

// Converted from monsters/spider_fire_spitting.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_spitting.as"

[script "monsters/spider_fire_spitting"]
class SpiderFireSpitting : SpiderSpittingScript
{
	// Variables (an unset .script variable reads as its own name)
	float DOT_FIRE = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SpiderFireSpitting()
	{
		PROJ_TYPE = "proj_fire_xolt";
	}

	// unnamed block (first think)
	void SpiderFireSpitting_FirstThink()
	{
		DOT_FIRE = 3.0f;
	}

	// spider_spawn
	void OnSpiderSpawn()
	{
		SetHealth(100);
		// ov 359
		SetWidth(64);
		SetHeight(64);

		SetName("Fire Spider");
		SetHearingSensitivity(7);
		SetModel("monsters/fer_spider_large.mdl");
		SetProp(ENT_ME, "skin", 1);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 0);
		NPC_GIVE_EXP = 90.0f;
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RandomInt(1, 5) != 1)
			return;
		ApplyEffect(target, "effects/dot_fire", 5, self, DOT_FIRE);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fer_spider_large.mdl");
		CallEventDelayed(SPIDER_IDLE_DELAY, "SpiderBase_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderFireSpitting_FirstThink();
		SpiderSpitting_FirstThink();
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
		if (name == "spider_spawn") { OnSpiderSpawn(); return true; }
		return SpiderSpittingScript::DispatchEvent(name, params);
	}
}
