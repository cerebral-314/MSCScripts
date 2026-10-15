#pragma context server

// Converted from monsters/worm_abyssal_head.script by msc_transpiler.
// worm head, acts as hit box for oversized beastie (monsters/worm_abyssal)
// Weird stuff happens with models this big - they ignore their normal bbox, and somehow have one that represents their actual size, and even polies.
// ...Which would be great, except it moves with them, causing players to be stuck inside, and thus imobilized.
// This mysterious secondary hull also does not function as a hitbox, so you can't get close enough to actually hit the mob.
// Think maybe it's defaulting to animsize when mob is over a certain size, but changing it to a fixed sized bbox doesn't undo it.
// Anywho... This works around that by attaching this NPC, which acts as its hitbox, and passing damage/applyeffects to the actual mob that spawns it (monsters/worm_abyssal).
// Downside is it blinds the mob, but as seen in (monsters/worm_abyssal), this can be worked around.
// Given that the Abyssal Worm mob's "eyes" are at its feat (~600 units below the players) it would be basically blind anyways.
// Some of the work arounds for this involve measuring attacks in Range2D (thus ignoring the height difference), and tracing attacks from its eye attachment, instead of its base.
// Sounds are also played on this NPC, as they may not be heard from so far down below the players.

#include "runtime/ScriptEntity.as"

[script "monsters/worm_abyssal_head"]
class WormAbyssalHead : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	bool NPC_NO_HEALTH_BAR = false;
	string PASS_ATK = "PASS_ATK";
	string PASS_DMG = "PASS_DMG";
	string PASS_CHANCE = "PASS_CHANCE";
	string PASS_TYPE = "PASS_TYPE";
	bool PASS_PENDING = false;
	string MY_OWNER = "MY_OWNER";
	bool IS_ACTIVE = false;

	// unnamed block (first think)
	void WormAbyssalHead_FirstThink()
	{
		// setcallback touch enable
		NPC_NO_HEALTH_BAR = true;
		PASS_ATK = "";
		PASS_DMG = "";
		PASS_CHANCE = "";
		PASS_TYPE = "";
		PASS_PENDING = false;
	}

	// game_damaged
	// { game_touch
	// if $get(PARAM1,isplayer)
	// setvard TRIGGER_MODE 1
	// if ( !TRIGGER_MODE ) setsolid trigger
	// setvard NEXT_TRIG_RESET game.time
	// add NEXT_TRIG_RESET 0.1
	// }
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type PARAM4=accuracy_roll PARAM5=skill PARAM6=inflictor
	string WormAbyssalHead_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, "0");
		if (RelationshipOf(attacker, ENT_ME) != "enemy")
			return result;

		LegacyCommand("bleed", ENT_ME, "yellow", RandomInt(100, 10000));

		string hitChance = "100%";
		if (StartsWith(ItemNameOf(skill), "proj"))
		{
			// make sure projectiles don't pass their skill hitchance
			hitChance = "100%";
		}
		PASS_ATK = TokenAdd(PASS_ATK, EntityId(attacker));
		PASS_DMG = TokenAdd(PASS_DMG, Text(damage));
		PASS_CHANCE = TokenAdd(PASS_CHANCE, hitChance);
		PASS_TYPE = TokenAdd(PASS_TYPE, damageType);
		if (PASS_PENDING)
			return result;
		PASS_PENDING = true;
		CallEventDelayed(0.01f, "pass_damage");
		return result;
	}

	// game_applyeffect
	// <applyeffect|applyeffect> <target> <effectscript> [params...]
	string WormAbyssalHead_OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "")
	{
		DebugPrint("game_applyeffect got " + command + " " + EntityId(caller) + " " + effect + " " + value + " " + attacker + " " + value2 + " " + value3 + " " + value4 + " " + value5);
		DebugPrint("test " + Eval("game.event.params"));
		string return_ = TokenAdd("redirect", MY_OWNER);
		return return_;
	}

	// game_dynamically_created
	// owner
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		// setvard NPC_PASS_APPLYEFFECTS MY_OWNER //added this to the code, lets you pass applyeffects from one mob to another (switched up for game_applyeffect)
		SetRace(RaceOf(MY_OWNER));
		IS_ACTIVE = true;
		OnSnapLoop();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Abyssal Worm");
		SetModel("monsters/abyssal_worm_hitbox.mdl");
		SetWidth(128);
		SetHeight(150);
		SetFly(true);
		SetGravity(0);
		SetHealth(999999);
	}

	// debug_model
	void OnDebugModel()
	{
		SetModelBody(0, 1);
	}

	// snap_loop
	void OnSnapLoop()
	{
		if (!IS_ACTIVE)
			return;
		Vector3 pos = AttachmentPositionOf(MY_OWNER, 1);
		pos.z += -75.0f;
		SetOrigin(ENT_ME, pos);
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			string boxMin = GetProp(ENT_ME, "absmin");
			string boxMax = GetProp(ENT_ME, "absmax");

			string boxEdge1a = boxMin;
			Vector3 boxEdge1b = Vector3(Vec(boxMin).x, Vec(boxMin).y, Vec(boxMax).z);
			string boxEdge2a = boxMin;
			Vector3 boxEdge2b = Vector3(Vec(boxMax).x, Vec(boxMin).y, Vec(boxMin).z);
			string boxEdge3a = boxMin;
			Vector3 boxEdge3b = Vector3(Vec(boxMin).x, Vec(boxMax).y, Vec(boxMin).z);
			Effect("beam", "point", "lgtning.spr", 3, boxEdge1a, boxEdge1b, Vector3(255, 0, 255), 200, 0, 0.1f);
			Effect("beam", "point", "lgtning.spr", 3, boxEdge2a, boxEdge2b, Vector3(255, 0, 255), 200, 0, 0.1f);
			Effect("beam", "point", "lgtning.spr", 3, boxEdge3a, boxEdge3b, Vector3(255, 0, 255), 200, 0, 0.1f);
		}

		// if ( game.time > NEXT_TRIG_RESET )
		// {
		// if TRIGGER_MODE
		// setvard TRIGGER_MODE 0
		// setsolid box
		// }
		if (!IsAlive(MY_OWNER))
		{
			IS_ACTIVE = false;
			// setcallback touch disable
			DeleteEntity(ENT_ME);
		}
		if (!IS_ACTIVE)
			return;
		SetHealth(HealthOf(MY_OWNER), MaxHealthOf(MY_OWNER));
		CallEventDelayed(0.01f, "snap_loop");
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return WormAbyssalHead_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// pass_damage
	void OnPassDamage()
	{
		PASS_PENDING = false;
		int count = GetTokenCount(PASS_DMG);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPassDamageOne();
		}
		PASS_ATK = "";
		PASS_DMG = "";
		PASS_CHANCE = "";
		PASS_TYPE = "";
	}

	// pass_damage_one
	void OnPassDamageOne()
	{
		int idx = loopIteration;
		CBaseEntity@ atk = FindEntity(GetToken(PASS_ATK, idx));
		DoDamageEx(MY_OWNER, "direct", GetToken(PASS_DMG, idx), GetToken(PASS_CHANCE, idx), @atk, @atk, "none", GetToken(PASS_TYPE, idx));
	}

	string OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "") { return WormAbyssalHead_OnGameApplyeffect(command, caller, effect, value, attacker, value2, value3, value4, value5); } // game_applyeffect

	// ext_playsound
	void OnExtPlaysound(int soundFile = 0, Vector3 sourceOrigin = Vector3(), string maxRange = "", string volume = "", string pitch = "")
	{
		DebugPrint("ext_playsound [ " + Eval("game.event.params") + " ] " + soundFile + " " + Text(sourceOrigin) + " " + maxRange + " " + volume + " " + pitch);
		if (Float(Eval("game.event.params")) < 4.0f)
			PlaySound(soundFile, sourceOrigin, maxRange);
		else
			PlaySound(soundFile, sourceOrigin, maxRange, volume, pitch);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/abyssal_worm_hitbox.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		WormAbyssalHead_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "debug_model") { OnDebugModel(); return true; }
		if (name == "ext_playsound") { OnExtPlaysound(Int(Param(params, 0)), Vec(Param(params, 1)), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "game_applyeffect") { Return(OnGameApplyeffect(Param(params, 0), EntityParam(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8))); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "pass_damage") { OnPassDamage(); return true; }
		if (name == "pass_damage_one") { OnPassDamageOne(); return true; }
		if (name == "snap_loop") { OnSnapLoop(); return true; }
		return false;
	}
}
