#pragma context server

// Converted from monsters/beetle_venom.script by msc_transpiler.
// Poisonus explosion on death

#include "runtime/ScriptEntity.as"
#include "converted/monsters/beetle_base.as"

[script "monsters/beetle_venom"]
class BeetleVenom : BeetleBaseScript
{
	// Constants
	float DOT_POISON = 50.0f;
	float DMG_BURST = 200.0f;
	string SOUND_POISON_BURST = "weapons/explode3.wav";

	// Variables (an unset .script variable reads as its own name)
	string POISON_TARGS = "POISON_TARGS";
	string FART_CL_IDX = "FART_CL_IDX";

	// Variables declared by included files, with the value they start with in this script
	BeetleVenom()
	{
		BBET_GORE_PUSH_STR = 300;
		BBET_FAKE_DEATH = 1;
		DMG_SLASH = 40.0f;
		DMG_GORE = 60;
		DMG_LEAP = 100;
	}

	// unnamed block (first think)
	void BeetleVenom_FirstThink()
	{
		NPC_GIVE_EXP = 600.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BeetleBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/beetle_base
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		PlaySound(0, 10, SOUND_POISON_BURST);
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, DMG_BURST, 0, ENT_ME, ENT_ME, "none", "poison");
		ClientEvent("new", "all", "effects/sfx_poison_explode", OriginOf(ENT_ME), 256);
		Effect("tempent", "gibs", "cactusgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, 50, 50, 15, 2.0f);
		POISON_TARGS = FindInSphere("enemy", 256);
		PlaySound(0, 10, SOUND_POISON_BURST);
		if (POISON_TARGS == "none")
			return;
		int count = GetTokenCount(POISON_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonAffectTargets();
		}
	}

	// bbet_fly_start
	void OnBbetFlyStart()
	{
		BeetleBase_OnBbetFlyStart(); // monsters/beetle_base
		ClientEvent("new", "all", "monsters/beetle_venom_cl", IndexOf(ENT_ME), 10.0f);
		FART_CL_IDX = LastClientScriptId();
	}

	// bbet_end_flight
	void OnBbetEndFlight()
	{
		BeetleBase_OnBbetEndFlight(); // monsters/beetle_base
		if (!BBET_FLYING)
			return;
		ClientEvent("update", "all", FART_CL_IDX, "remove_fx");
	}

	// beetle_spawn
	void OnBeetleSpawn()
	{
		SetName("Venomsack Beetle");
		SetHealth(1000);
		SetModelBody(0, 1); // 0=Horned 1=Venom 2=Fire
	}

	// poison_affect_targets
	void OnPoisonAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(POISON_TARGS, loopIteration));
		ApplyEffect(curTarg, "effects/dot_poison", 5.0f, self, DOT_POISON);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetles.mdl");
		Precache("cactusgibs.mdl");
		Precache("poison_cloud.spr");
		Precache("monsters/beetle/charge_loop1.wav");
		Precache("monsters/beetle/fly1.wav");
		CallEventDelayed(Float(Eval("$randf(8.0,15.0)")), "BeetleBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleVenom_FirstThink();
		BeetleBase_FirstThink();
		BeetleBase_FirstThink2();
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
		if (name == "bbet_end_flight") { OnBbetEndFlight(); return true; }
		if (name == "bbet_fly_start") { OnBbetFlyStart(); return true; }
		if (name == "beetle_spawn") { OnBeetleSpawn(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "poison_affect_targets") { OnPoisonAffectTargets(); return true; }
		return BeetleBaseScript::DispatchEvent(name, params);
	}
}
