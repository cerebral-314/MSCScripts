#pragma context server

// Converted from monsters/summon/tornado.script by msc_transpiler.
// The original idea was to have a tornado that picked people up and carried them along
// had to abandon this, as there's no way to make monsters pick up players
// due to the fact that if two models overlap, one cant move
// if I used the noclip method of movement, players would wind up appearing outside world or inside brushes
// alternate - just damage and throw people

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/summon/tornado"]
class Tornado : BasePropelledScript
{
	// Constants
	string MONSTER_MODEL = "weapons/magic/tornado.mdl";
	string SOUND_WIND1 = "magic/vent1.wav";
	string SOUND_WIND2 = "magic/vent2.wav";
	string SOUND_WIND3 = "magic/vent3.wav";
	string SOUND_ATTACK1 = "magic/gusts1.wav";
	string SOUND_ATTACK2 = "magic/gusts2.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float DMG_BASE = 0.0f;
	string MY_DURATION = "MY_DURATION";
	int GAME_PVP = 0;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string MOVE_TARG = "MOVE_TARG";
	bool IS_ACTIVE = false;
	bool N_VICTIMS = false;
	bool CUR_DMGVICT = false;

	// Variables declared by included files, with the value they start with in this script
	Tornado()
	{
		NPC_HACKED_MOVE_SPEED = 200.0f;
	}

	// unnamed block (first think)
	void Tornado_FirstThink()
	{
		NPC_HACKED_MOVE_SPEED = 200.0f;
	}

	// game_dodamage
	string Tornado_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!IS_ACTIVE)
			return result;

		if (RelationshipOf(MY_OWNER, @target) != "enemy")
			return result;
		if (Truthy(OWNER_ISPLAYER) && GAME_PVP == 0 && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return result;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		CallExternal(MY_OWNER, "ext_dodamage", @target, "direct", DMG_BASE, "100%", MY_OWNER, "magic");
		int rndDir = RandomInt(1, 2);
		if (rndDir == 1)
			rndDir = 1000;
		if (rndDir == 2)
			rndDir = -1000;
		int rndFbdir = RandomInt(1, 2);
		if (rndFbdir == 1)
			rndFbdir = 1000;
		if (rndFbdir == 2)
			rndFbdir = -1000;
		int rndLift = RandomInt(300, 1000);
		DebugPrint("temp " + rndDir + " " + rndLift);

		SetVelocity(target, RelativeVelocity(Vector3(rndDir, rndFbdir, rndLift)));
		return result;
	}

	// unnamed block (timer)
	void Tornado_Timer()
	{
		CallEventDelayed(0.5f, "Tornado_Timer");
		// move towards target erratically
		if (!IS_ACTIVE)
			return;

		int rndMove = RandomInt(1, 2);
		if (rndMove == 1)
		{
			if (MOVE_TARG != "unset")
				SetMoveDest(MOVE_TARG, 10);
			if (MOVE_TARG == "unset")
				rndMove = 2;
		}
		if (rndMove == 2)
		{
			int rndAng = RandomInt(0, 359);
			Vector3 moveDest = MyOrigin() + RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 1000, 0));
			SetMoveDest(moveDest, 10);
		}
	}

	// unnamed block (timer)
	void Tornado_Timer2()
	{
		CallEventDelayed(Random(4, 6), "Tornado_Timer2");
		if (!IS_ACTIVE)
			return;
		PlayRandomSound(0, 10, SOUND_WIND1, SOUND_WIND2, SOUND_WIND3);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		DMG_BASE = Float(creatorValue2);
		MY_DURATION = damage;

		GAME_PVP = (IsPvp() ? 1 : 0);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		SetRace(RaceOf(MY_OWNER));

		MOVE_TARG = ScriptVarOf(MY_OWNER, "NPCATK_TARGET");

		IS_ACTIVE = true;
		OnSummonCycle();

		CallEventOrDelay(MY_DURATION, "end_summon");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Tornado");

		SetModel(MONSTER_MODEL);
		SetInvincible(true);
		SetHealth(1);
		SetRoam(true);
		SetWidth(64);
		SetHeight(128);
		SetBoundingBox("npcsize");
		SetSolid("none");

		SetMonsterClip(false); // ignores monster clips (make sure blooddrinker does too)

		N_VICTIMS = false;
		CUR_DMGVICT = false;

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 180);
	}

	// summon_cycle
	void OnSummonCycle()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "summon_cycle");

		// dbg summon_cycle $get(MOVE_TARG,name) ( MOVE_TARG )
		if (MOVE_TARG == "unset" && CanSee("enemy"))
		{
			OnCheckVict();
			MOVE_TARG = EntityId(EntityOf(ENT_LASTSEEN));
		}

		DoDamage(Text(RelativePosition(Vector3(0, 30, 0))), 128, 0.0f, "100%", 0.0f, "reflective", "target");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return Tornado_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// end_summon
	void OnEndSummon()
	{
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		CallEventDelayed(1.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION
	void OnCheckVict() {} // check_vict

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/magic/tornado.mdl");
		CallEventDelayed(0.5f, "Tornado_Timer");
		CallEventDelayed(Float(Eval("$randf(4,6)")), "Tornado_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tornado_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_summon") { OnEndSummon(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "summon_cycle") { OnSummonCycle(); return true; }
		if (name == "Tornado_Timer") { Tornado_Timer(); return true; }
		if (name == "Tornado_Timer2") { Tornado_Timer2(); return true; }
		return BasePropelledScript::DispatchEvent(name, params);
	}
}
