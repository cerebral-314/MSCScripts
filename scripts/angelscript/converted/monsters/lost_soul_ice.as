#pragma context server

// Converted from monsters/lost_soul_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/lost_soul.as"

[script "monsters/lost_soul_ice"]
class LostSoulIce : LostSoulScript
{
	// Variables declared by included files, with the value they start with in this script
	LostSoulIce()
	{
		MONSTER_HP = 500.0f;
		DMG_SPLODIE = 200;
		DOT_COLD = 30;
		CUSTOM_DAMAGE = true;
	}

	// game_dodamage
	string LostSoulIce_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (DEATH_ATTACK)
		{
			if (GameTime() < DEATH_TIME && IsAlive(target) && RelationshipOf(target, ENT_ME) == "enemy") // delay so poison effect doesnt keep pushing player
			{
				Vector3 targetOrg = OriginOf(target);
				float targAng = AnglesTo(MyOrigin(), targetOrg);
				int newYaw = int(targAng);
				SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
				ApplyEffect(target, "effects/dot_cold", 5.0f, self, DOT_COLD);
			}
		}
		else if (hit && IsAlive(ENT_ME) && IsAlive(target))
		{
			AddVelocity(target, RelativeVelocity(Vector3(20, 200, 10)));
			ApplyEffect(target, "effects/dot_cold", 5.0f, self, DOT_COLD);
		}
		return result;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, LostSoul_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, LostSoulIce_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// skull_spawn
	void OnSkullSpawn()
	{
		SetName("Lost Soul");
		SetRace("demon");
		if (Text(MONSTER_HP) == "MONSTER_HP")
			SetHealth(300);
		else
			SetHealth(MONSTER_HP);
		SetBlood("none");
		SetWidth(16);
		SetHeight(16);
		SetModel("monsters/skull.mdl");
		SetIdleAnim("idle");
		SetMoveAnim("idle");
		SetHearingSensitivity(11);
		SetRoam(true);
		SetFly(true);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 4);
		SetDamageTaken("cold", 0);

		IMMUNE_VAMPIRE = true;

		COUNT_ATK = 0.0f;

		SetProp(ENT_ME, "skin", 1);
	}

	// skull_death
	void OnSkullDeath()
	{
		DEATH_TIME = GameTime();
		AM_DEAD = true;
		DEATH_TIME += 0.2f;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		Vector3 splodePos = RelativePosition(Vector3(0, 0, 0));
		ClientEvent("new", "all", "effects/sfx_splodie", splodePos, Vector3(128, 128, 255));
		DEATH_ATTACK = true;
		// dodamage SPLODE_POS 128 DMG_SPLODE 100% 0 reflective poison
		DoDamageEx(splodePos, 128, "DMG_SPLODE", 0, ENT_ME, ENT_ME, "none", "blunt");
	}

	// game_dynamically_created
	// <owner> <str> <duration>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		SetRace(RaceOf(MY_OWNER));
		AM_SUMMONED = true;

		SetMonsterClip(false);

		if (RaceOf(MY_OWNER) == "0")
			SetRace("demon");

		if (!creatorValue2.isEmpty())
		{
			SetDamageMultiplier(Float(creatorValue2));
			MONSTER_HP *= Float(creatorValue2);
		}

		SetHealth(MONSTER_HP);

		if (damage.isEmpty())
			return;
		CallEventOrDelay(damage, "self_destruct");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "skull_death") { OnSkullDeath(); return true; }
		if (name == "skull_spawn") { OnSkullSpawn(); return true; }
		return LostSoulScript::DispatchEvent(name, params);
	}
}
