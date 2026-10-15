#pragma context server

// Converted from other/make_glow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_flyer_grav.as"
#include "converted/monsters/externals.as"

[script "other/make_glow"]
class MakeGlow : MonstersExternalsScript, BaseFlyerGrav
{
	// Variables (an unset .script variable reads as its own name)
	bool SUSPEND_AI = false;
	float CYCLE_RATE = 0.0f;

	// game_damaged
	string MakeGlow_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (RelationshipOf(attacker, ENT_ME) != "enemy")
			return result;
		NPCATK_TARGET = "HEARD_ID";
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, 30, 30); // no work
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
		SetName("Killer Map Brush");
		SetRace("hated");
		SetHealth(1000);
		SetHearingSensitivity(11);
		NPCATK_TARGET = "unset";
		SetMenuAutoOpen(true);
		SUSPEND_AI = true;
		SetGravity(0);
		CYCLE_RATE = 1.0f;
		CallEventDelayed(1.0f, "npcatk_hunt");
		SetProp("rendermode", "2");
		SetProp("renderamt", "255");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
		CallEventDelayed(CYCLE_RATE, "npcatk_hunt");
		if (SUSPEND_AI)
			return;
		DebugPrint("Hunting " + NameOf(NPCATK_TARGET) + " [ " + Text(RangeTo(NPCATK_TARGET)) + " ]");

		PlaySound(2, 10, "magic/energy1.wav");

		if (!IsAlive(NPCATK_TARGET))
			NPCATK_TARGET = "unset";
		if (NPCATK_TARGET == "unset")
			return;
		SetMoveDest(NPCATK_TARGET, 32);
		if (CanSee(NPCATK_TARGET))
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 50, 0)));

		if (RangeTo(NPCATK_TARGET) < 64.0f)
			DoDamage(NPCATK_TARGET, 64, 5, 50, "slash");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		PlaySound(0, 10, "voices/human/male_die.wav");
		DeleteEntity(ENT_ME, "fade");
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(ENT_ME, @heardId) != "enemy")
			return;
		NPCATK_TARGET = EntityId(heardId);
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, 30, 30);
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return MakeGlow_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// npcatk_resume_ai
	// this works, btw
	// { game_playerused
	// setprop ent_me rendermode 5
	// setprop ent_me renderamt 255
	// }
	void OnNpcatkResumeAi(string target = "")
	{
		CYCLE_RATE = 0.1f;
		NPCATK_TARGET = target;
		SUSPEND_AI = false;
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		CYCLE_RATE = 1.0f;
		SUSPEND_AI = true;
	}

	// menu_hunt
	void OnMenuHunt(CBasePlayer@ npc = null)
	{
		OnNpcatkResumeAi(EntityId(npc));
	}

	// menu_stop
	void OnMenuStop()
	{
		OnNpcatkSuspendAi();
	}

	// menu_glow
	void OnMenuGlow()
	{
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 255, 0), 128, 30.0f);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		if (SUSPEND_AI)
		{
			menuItem.title = "Hunt";
			menuItem.type = "callback";
			menuItem.callback = "menu_hunt";
			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Stop";
			menuItem.type = "callback";
			menuItem.callback = "menu_stop";
			RegisterMenuItem(menuItem);
		}

		menuItem.title = "Glow";
		menuItem.type = "callback";
		menuItem.callback = "menu_glow";
		RegisterMenuItem(menuItem);

		menuItem.title = "Additive";
		menuItem.type = "callback";
		menuItem.callback = "menu_additive";
		RegisterMenuItem(menuItem);

		menuItem.title = "Spin";
		menuItem.type = "callback";
		menuItem.callback = "menu_spin";
		RegisterMenuItem(menuItem);
	}

	// menu_fly
	void OnMenuFly()
	{
		// fly 1 //CRASHES
		SetGravity(0);
		SetSayTextRange(1024);
		SayText("Weeee!");
	}

	// menu_additive
	void OnMenuAdditive()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// menu_spin
	void OnMenuSpin()
	{
		SetProp(ENT_ME, "avelocity", Vector3(50, 50, 0));
		CallEventDelayed(0.1f, "menu_spin");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnCycleRate() {} // CYCLE_RATE

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseFlyerGrav_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "menu_additive") { OnMenuAdditive(); return true; }
		if (name == "menu_fly") { OnMenuFly(); return true; }
		if (name == "menu_glow") { OnMenuGlow(); return true; }
		if (name == "menu_hunt") { OnMenuHunt(PlayerParam(params, 0)); return true; }
		if (name == "menu_spin") { OnMenuSpin(); return true; }
		if (name == "menu_stop") { OnMenuStop(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		return BaseFlyerGrav_DispatchEvent(name, params)
			|| MonstersExternalsScript::DispatchEvent(name, params);
	}
}
