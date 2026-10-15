#pragma context server

// Converted from monsters/spider_fire_turret.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/spider_turret.as"

[script "monsters/spider_fire_turret"]
class SpiderFireTurret : SpiderTurretScript
{
	// Variables declared by included files, with the value they start with in this script
	SpiderFireTurret()
	{
		PROJ_TYPE = "proj_fire_xolt";
		ANIM_RUN = "idle";
		ANIM_WALK = "idle";
	}

	// unnamed block (first think)
	void SpiderFireTurret_FirstThink()
	{
		DOT_FIRE = 3.0f;
	}

	// spider_spawn
	void OnSpiderSpawn()
	{
		SetHealth(150);
		// ov 359
		SetWidth(64);
		SetHeight(64);

		SetName("Fire Spider");
		SetHearingSensitivity(7);
		SetModel("monsters/fer_spider_large.mdl");
		SetProp(ENT_ME, "skin", 1);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 0);
		SetAnimMoveSpeed(0);
		SetMoveSpeed(0);
		SetMoveAnim(ANIM_IDLE);
		NO_STUCK_CHECKS = "1";

		NPC_GIVE_EXP = 100.0f;
		CallEventDelayed(0.1f, "make_turret");
	}

	// make_turret
	void OnMakeTurret()
	{
		ANIM_RUN = "idle";
		ANIM_WALK = "idle";
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RandomInt(1, 5) != 1)
			return;
		ApplyEffect(target, "effects/dot_fire", 5, self, DOT_FIRE, 1, 1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpiderFireTurret_FirstThink();
		SpiderTurret_FirstThink();
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
		if (name == "make_turret") { OnMakeTurret(); return true; }
		if (name == "spider_spawn") { OnSpiderSpawn(); return true; }
		return SpiderTurretScript::DispatchEvent(name, params);
	}
}
