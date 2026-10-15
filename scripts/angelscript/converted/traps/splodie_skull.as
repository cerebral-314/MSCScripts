#pragma context server

// Converted from traps/splodie_skull.script by msc_transpiler.
// The old exploding bear trap in the ass trick
// (Bounces around, then explodes, poisoning all nearby)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/externals.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SplodieSkull
{
	// Constants
	float SCAN_SIZE = 100.0f;
	Vector3 GLOW_SHELL = Vector3();
	string SOUND_HATCH = "debris/bustflesh1.wav";
	int DMG_SPLODE = 200;
	float DMG_POISON = 75.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	float MONSTER_HP = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string MY_OWNER = "MY_OWNER";
	bool IMMUNE_VAMPIRE = false;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	float DEATH_TIME = 0.0f;

	// unnamed block (first think)
	void SplodieSkull_FirstThink()
	{
		IS_UNHOLY = true;

		MONSTER_HP = 50.0f;
		NPC_GIVE_EXP = 30.0f; // note this monster has internal handlers
	}

	// game_dynamically_created
	void SplodieSkull_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SetMonsterClip(false);

		MY_OWNER = creatorValue1;
		SetRace(RaceOf(MY_OWNER));

		if (!creatorValue2.isEmpty())
		{
			SetDamageMultiplier(Float(creatorValue2));
			MONSTER_HP *= Float(creatorValue2);
			SetHealth(MONSTER_HP);
		}
	}

	// game_spawn
	void SplodieSkull_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnSkullSpawn();
	}

	// skull_spawn
	void SplodieSkull_OnSkullSpawn()
	{
		SetName("Green Goblin Skull");
		if (Text(MONSTER_HP) == "MONSTER_HP")
			SetHealth(50);
		else
			SetHealth(MONSTER_HP);
		SetRace("demon");
		SetModel("monsters/skull.mdl");
		SetBlood("none");
		SetWidth(16);
		SetHeight(16);
		SetModelBody(0, 1);

		SetBlood("none");
		IMMUNE_VAMPIRE = true;

		SetBoundingBox("npcsize");

		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));

		Effect("glow", ENT_ME, GLOW_SHELL, 128, -1, 0);

		CallEventDelayed(0.1f, "scan_bounce");

		CallEventDelayed(Random(10, 20), "self_destruct");
		CallEventDelayed(0.01f, "bounce_about");
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void SplodieSkull_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		float totalAdj = 0.0f;

		if (!healthMultiplier.isEmpty())
		{
			SetDamageMultiplier(Float(healthMultiplier));
			totalAdj += Float(healthMultiplier);
		}

		if (!params.isEmpty())
		{
			MONSTER_HP *= Float(damageMultiplier);
			SetHealth(MONSTER_HP);
			totalAdj += Float(healthMultiplier);
		}

		NPC_DO_EVENTS = params;

		if (totalAdj != 0.0f)
		{
			totalAdj = Divide(totalAdj, 2.0f);
			NPC_GIVE_EXP *= totalAdj;
		}

		SetSkillLevel(NPC_GIVE_EXP);

		if (params == "none")
			return;
		int count = GetTokenCount(NPC_DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkDoEvents();
		}
	}

	// unnamed block (timer)
	void SplodieSkull_Timer()
	{
		CallEventDelayed(Random(1, 5), "SplodieSkull_Timer");
		OnBounceAbout(); // random jiggle
	}

	// scan_bounce
	void SplodieSkull_OnScanBounce()
	{
		CallEventDelayed(0.2f, "scan_bounce");
		float myZvel = Vec(Eval("game.monster.velocity")).z;
		// //dbg MY_ZVEL
		if (!(myZvel < 0.0f))
			return;

		Vector3 traceStart = MyOrigin() + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 0));
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, -50)));
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != traceEnd)
			PlaySound(0, 10, "weapons/g_bounce1.wav");
	}

	// bounce_about
	void SplodieSkull_OnBounceAbout()
	{
		// no room, toss in random dir
		int tossDir = RandomInt(-200, 200);
		int tossHor = RandomInt(-200, 200);
		int tossVer = RandomInt(-400, 600);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(tossDir, tossHor, tossVer)));
	}

	// game_struck
	void SplodieSkull_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnBounceAbout();
	}

	// self_destruct
	void SplodieSkull_OnSelfDestruct()
	{
		OnNpcSuicide();
	}

	// game_death
	void SplodieSkull_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (CUSTOM_DEATH)
			return;
		CallExternal(MY_OWNER, "skull_died");
		OnXpSend();

		DEATH_TIME = GameTime() + 0.2f;

		Effect("tempent", "gibs", "bonegibs.mdl", RelativePosition(Vector3(0, 0, 0)), 0.1f, 100, 30, 2, 4);
		PlaySound(0, 10, SOUND_HATCH);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		Vector3 splodePos = RelativePosition(Vector3(0, 0, 0));
		ClientEvent("new", "all", "effects/sfx_splodie", splodePos, Vector3(0, 255, 0));
		// dodamage SPLODE_POS 128 DMG_SPLODE 100% 0 reflective poison
		DoDamageEx(splodePos, 128, DMG_SPLODE, 0, ENT_ME, ENT_ME, "none", "blunt");
	}

	// xp_send
	void SplodieSkull_OnXpSend()
	{
		string monFull = Eval("game.monster.name.full");
		string outMsg = "You've slain " + monFull;
		PlayerMessageGreen(EntityOf(ENT_LASTSTRUCK), outMsg);
	}

	// game_dodamage
	string SplodieSkull_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!(GameTime() < DEATH_TIME)) // delay so poison effect doesnt push
			return result;
		if (!IsAlive(target))
			return result;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;
		Vector3 targetOrg = OriginOf(target);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0)));
		ApplyEffect(ENT_LASTSTRUCK, "effects/dot_poison", 5.0f, self, DMG_POISON);
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { SplodieSkull_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		SplodieSkull_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnGameSpawn(string playerRace = "", string playerGender = "") { SplodieSkull_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnSkullSpawn() { SplodieSkull_OnSkullSpawn(); } // skull_spawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { SplodieSkull_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnScanBounce() { SplodieSkull_OnScanBounce(); } // scan_bounce
	void OnBounceAbout() { SplodieSkull_OnBounceAbout(); } // bounce_about
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { SplodieSkull_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnSelfDestruct() { SplodieSkull_OnSelfDestruct(); } // self_destruct
	void OnXpSend() { SplodieSkull_OnXpSend(); } // xp_send
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SplodieSkull_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnNpcatkDoEvents() {} // npcatk_do_events

	// This file's events and timers by their .script names
	bool SplodieSkull_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bounce_about") { OnBounceAbout(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "scan_bounce") { OnScanBounce(); return true; }
		if (name == "self_destruct") { OnSelfDestruct(); return true; }
		if (name == "skull_spawn") { OnSkullSpawn(); return true; }
		if (name == "xp_send") { OnXpSend(); return true; }
		if (name == "SplodieSkull_Timer") { SplodieSkull_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "traps/splodie_skull"]
shared class SplodieSkullScript : MonstersExternalsScript, SplodieSkull
{
	// Variables every script that includes this file declares
	bool CUSTOM_DEATH = false;

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("bonegibs.mdl");
		Precache("monsters/skull.mdl");
		CallEventDelayed(Float(Eval("$randf(1.0,5.0)")), "SplodieSkull_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SplodieSkull_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SplodieSkull_DispatchEvent(name, params)
			|| MonstersExternalsScript::DispatchEvent(name, params);
	}
}
