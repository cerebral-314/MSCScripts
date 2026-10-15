#pragma context server

// Converted from traps/splodie_skull_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/traps/splodie_skull.as"

[script "traps/splodie_skull_ice"]
class SplodieSkullIce : SplodieSkullScript
{
	// Variables declared by included files, with the value they start with in this script
	SplodieSkullIce()
	{
		CUSTOM_DEATH = true;
	}

	// game_dodamage
	string SplodieSkullIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (!IsAlive(target))
			return result;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;
		ApplyEffect(target, "effects/dot_cold", 5.0f, self, "DOT_COLD");
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		SplodieSkull_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // traps/splodie_skull
		if (IsAlive(MY_OWNER))
			CallExternal(MY_OWNER, "skull_died");
		OnXpSend();

		DEATH_TIME = GameTime() + 0.2f;

		PlaySound(0, 10, SOUND_HATCH);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		Vector3 splodePos = RelativePosition(Vector3(0, 0, 0));
		ClientEvent("new", "all", "effects/sfx_splodie", splodePos, Vector3(128, 128, 255));
		DoDamageEx(splodePos, 128, DMG_SPLODE, 0, ENT_ME, ENT_ME, "none", "blunt");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, SplodieSkull_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SplodieSkullIce_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// skull_spawn
	void OnSkullSpawn()
	{
		SetName("Icey Skull");
		if (Text(MONSTER_HP) == "MONSTER_HP")
			SetHealth(50);
		else
			SetHealth(MONSTER_HP);
		SetRace("demon");
		SetModel("monsters/skull.mdl");
		SetProp(ENT_ME, "skin", 1);
		SetBlood("none");
		SetWidth(16);
		SetHeight(16);
		SetModelBody(0, 1);

		SetBlood("none");
		IMMUNE_VAMPIRE = true;

		SetBoundingBox("npcsize");

		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));

		Effect("glow", ENT_ME, Vector3(128, 128, 255), 128, -1, 0);

		IMMUNE_VAMPIRE = true;

		CallEventDelayed(0.1f, "scan_bounce");

		CallEventDelayed(Random(10, 20), "self_destruct");
		CallEventDelayed(0.01f, "bounce_about");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "skull_spawn") { OnSkullSpawn(); return true; }
		return SplodieSkullScript::DispatchEvent(name, params);
	}
}
