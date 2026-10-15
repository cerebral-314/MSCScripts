#pragma context server

// Converted from traps/quake.script by msc_transpiler.
// earth quake trap / effect
// addparams:
// set_global //affect all players
// set_noslow //no applyeffect or damage
// set_aoe;<rad> //adjust range (default 512)
// set_dur;<seconds> //adjust duration (default 10.0)
// damage can be adjusted with dmgmulti (even below 1), if dmgmulti is 0, does no damage (effect only), scales by % of maxhp

#include "runtime/ScriptEntity.as"

[script "traps/quake"]
class Quake : ScriptEntity
{
	// Constants
	string SOUND_QUAKE_START = "magic/volcano_start.wav";
	string SOUND_QUAKE_LOOP = "magic/volcano_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	string QUAKE_AOE = "QUAKE_AOE";
	float QUAKE_DURATION = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string DO_EVENTS = "DO_EVENTS";
	bool NO_DAMAGE = false;
	string DMG_OWNER = "DMG_OWNER";
	bool QUAKE_GLOBAL = false;
	bool NO_SLOW = false;
	bool QUAKE_ACTIVE = false;
	float QUAKE_END_TIME = 0.0f;
	string QUAKE_TARGS = "QUAKE_TARGS";

	// unnamed block (first think)
	void Quake_FirstThink()
	{
		QUAKE_AOE = "512";
		QUAKE_DURATION = 10.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_QUAKE_START);
		ServerPlaySound(0, 0, SOUND_QUAKE_LOOP);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Earthquake");
		SetModel("null.mdl");
		SetHealth(1);
		SetWidth(1);
		SetHeight(1);
		SetInvincible(true);
		SetGravity(0);
		SetFly(true);
		SetBlood("none");
		SetRace("hated");
		PLAYING_DEAD = "1";
		SetNoPush(true);
		CallEventDelayed(0.2f, "do_quake");
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		DO_EVENTS = params;

		if (DO_EVENTS != "none")
			OnHandleEvents();

		if (Float(damageMultiplier) == 0.0f)
			NO_DAMAGE = true;
		else
			SetDamageMultiplier(Float(damageMultiplier));
	}

	// game_dynamically_created
	// events <params>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DebugPrint("game_dynamically_created " + creatorValue1 + " " + creatorValue2 + " " + damage + " " + skill);
		if (creatorValue1 == "events")
		{
			DO_EVENTS = creatorValue2;
			CallEventDelayed(0.1f, "handle_events");
		}
		else if (IsAlive(creatorValue1))
		{
			DMG_OWNER = creatorValue1;
			SetRace(RaceOf(DMG_OWNER));
		}
	}

	// handle_events
	void OnHandleEvents()
	{
		int count = GetTokenCount(DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnHandleEventsLoop();
		}
	}

	// handle_events_loop
	void OnHandleEventsLoop()
	{
		string paramOut = "PARAM_OUT";
		int curIdx = loopIteration;
		string curEvent = GetToken(DO_EVENTS, curIdx);
		if (curIdx < GetTokenCount(DO_EVENTS) - 1.0f)
			paramOut = GetToken(DO_EVENTS, int(curIdx + 1.0f));
		CallEventOrDelay(curEvent, paramOut);
	}

	// set_aoe
	void OnSetAoe(string aoeRadius = "")
	{
		DebugPrint("set_aoe " + aoeRadius);
		if (aoeRadius.isEmpty())
			return;
		QUAKE_AOE = aoeRadius;
	}

	// set_dur
	void OnSetDur(string duration = "")
	{
		if (duration.isEmpty())
			return;
		QUAKE_DURATION = Float(duration);
		DebugPrint("set_dur " + duration + " [ " + Text(QUAKE_DURATION) + " ]");
	}

	// set_global
	void OnSetGlobal()
	{
		DebugPrint("set_global");
		QUAKE_GLOBAL = true;
	}

	// set_noslow
	void OnSetNoslow()
	{
		NO_SLOW = true;
	}

	// set_nodamage
	void OnSetNodamage()
	{
		NO_DAMAGE = true;
	}

	// do_quake
	void OnDoQuake()
	{
		QUAKE_ACTIVE = true;

		DebugPrint("do_quake " + Text(QUAKE_DURATION));

		if (!QUAKE_GLOBAL)
		{
			ServerPlaySound(1, 10, SOUND_QUAKE_START, 0.8f, 60);
			ServerPlaySound(2, 10, SOUND_QUAKE_LOOP, 0.8f, 60);
			QUAKE_AOE = "256";
		}

		QUAKE_END_TIME = GameTime() + QUAKE_DURATION;
		CallEventDelayed(QUAKE_DURATION, "quake_end");

		if (!QUAKE_GLOBAL)
		{
			CallEventDelayed(0.1f, "quake_loop");
			Effect("screenshake", OriginOf(ENT_ME), 50, 10, QUAKE_DURATION, Float(QUAKE_AOE) * 1.5f);
			ClientEvent("new", "all", "effects/sfx_quake", IndexOf(ENT_ME), 1, QUAKE_AOE, QUAKE_DURATION);
		}
		else
		{
			CallExternal("players", "ext_quake_fx", QUAKE_DURATION, SOUND_QUAKE_START, SOUND_QUAKE_LOOP);
			CallEventDelayed(0.1f, "global_quake_loop");
		}
	}

	// quake_loop
	void OnQuakeLoop()
	{
		if (!QUAKE_ACTIVE)
			return;
		CallEventDelayed(1.0f, "quake_loop");

		QUAKE_TARGS = FindInSphere("enemy", Float(QUAKE_AOE));
		if (QUAKE_TARGS == "none")
			return;
		int count = GetTokenCount(QUAKE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnQuakeApplyeffect();
		}
	}

	// global_quake_loop
	void OnGlobalQuakeLoop()
	{
		if (!QUAKE_ACTIVE)
			return;
		CallEventDelayed(1.0f, "quake_loop");

		if (!(PlayerCount() > 0))
			return;
		QUAKE_TARGS = GetPlayers();
		if (QUAKE_TARGS == "none")
			return;
		int count = GetTokenCount(QUAKE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnQuakeApplyeffect();
		}
	}

	// quake_applyeffect
	void OnQuakeApplyeffect()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(QUAKE_TARGS, loopIteration));

		if (!IsOnGround(curTarg))
			return;
		float dmg = MaxHealthOf(curTarg) * 0.01f;

		if (NO_DAMAGE)
			dmg = 0.0f;

		if (NO_SLOW)
			return;

		if (!QUAKE_GLOBAL)
			ApplyEffect(curTarg, "effects/effect_quake", self, self, QUAKE_AOE, dmg, QUAKE_END_TIME, 0);
		else
			ApplyEffect(curTarg, "effects/effect_quake", @curTarg, self, QUAKE_AOE, dmg, QUAKE_END_TIME, 0);
	}

	// quake_end
	void OnQuakeEnd()
	{
		if (!QUAKE_GLOBAL)
			ServerPlaySound(2, 0, SOUND_QUAKE_LOOP);
		QUAKE_ACTIVE = false;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnCurEvent() {} // CUR_EVENT
	void OnQuakeDuration() {} // QUAKE_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rockgibs.mdl");
		Precache("magic/volcano_start.wav");
		Precache("magic/volcano_loop.wav");
		Precache("null.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Quake_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_quake") { OnDoQuake(); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "global_quake_loop") { OnGlobalQuakeLoop(); return true; }
		if (name == "handle_events") { OnHandleEvents(); return true; }
		if (name == "handle_events_loop") { OnHandleEventsLoop(); return true; }
		if (name == "quake_applyeffect") { OnQuakeApplyeffect(); return true; }
		if (name == "quake_end") { OnQuakeEnd(); return true; }
		if (name == "quake_loop") { OnQuakeLoop(); return true; }
		if (name == "set_aoe") { OnSetAoe(Param(params, 0)); return true; }
		if (name == "set_dur") { OnSetDur(Param(params, 0)); return true; }
		if (name == "set_global") { OnSetGlobal(); return true; }
		if (name == "set_nodamage") { OnSetNodamage(); return true; }
		if (name == "set_noslow") { OnSetNoslow(); return true; }
		return false;
	}
}
