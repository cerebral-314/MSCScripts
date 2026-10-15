#pragma context server

// Converted from belmont/bandit_extortionist.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_elite_dagger.as"

[script "belmont/bandit_extortionist"]
class BanditExtortionist : BanditEliteDaggerScript
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ BAR_ID = null;
	bool STARTED_SCENE = false;

	// unnamed block (first think)
	void BanditExtortionist_FirstThink()
	{
		SetUniqueName("extorter");
		SetSayTextRange(1024);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditElite_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bandit_elite
		if (!IsAlive(BAR_ID))
			return;
		CallExternal(BAR_ID, "extorter_slain", @EntityOf(ENT_LASTSTRUCK));
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared

		SetRoam(false);
		OnNpcatkSuspendAi();
		CallEventDelayed(1.0f, "get_bar_id");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BanditElite_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/bandit_elite
		BanditElite_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // monsters/bandit_elite
		BanditElite_OnGameStruck_3(damage, extraValue2, extraValue3, extraValue4); // monsters/bandit_elite
		if (SUSPEND_AI)
			OnNpcatkResumeAi();
	}

	// get_bar_id
	void OnGetBarId()
	{
		@BAR_ID = FindByName("bartender");
		OnScanForPlayers();
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (CanSee("enemy") && IsPlayer(ENT_LASTSEEN))
		{
			STARTED_SCENE = true;
			OnStartScene();
		}

		if (STARTED_SCENE)
			return;
		CallEventDelayed(1.0f, "scan_for_players");
	}

	// start_scene
	void OnStartScene()
	{
		SetMoveDest(@BAR_ID, 32);
		SayText("Helga, your payment is late, again. I warned you this this would be the last time.");
		CallEventDelayed(3.0f, "helga_respond1");
	}

	// helga_respond1
	void OnHelgaRespond1()
	{
		CallExternal(BAR_ID, "ext_harass1");
		CallEventDelayed(3.0f, "me_harass2");
	}

	// me_harass2
	void OnMeHarass2()
	{
		SayText("Come now, you surely have made enough for the payment by now.");
		CallEventDelayed(3.0f, "helga_respond2");
	}

	// helga_respond2
	void OnHelgaRespond2()
	{
		CallExternal(BAR_ID, "ext_harass2");
		CallEventDelayed(3.0f, "me_harass3");
	}

	// me_harass3
	void OnMeHarass3()
	{
		SayText("We have to keep the riff-raff, in line... We have to set... An example.");
		PlayAnim("hold", "stand_squatwalk1_L");
		CallEventDelayed(3.0f, "helga_respond3");
	}

	// helga_respond3
	void OnHelgaRespond3()
	{
		CallExternal(BAR_ID, "ext_harass3");
		CallEventDelayed(6.0f, "me_kill_da_bitch");
	}

	// me_kill_da_bitch
	void OnMeKillDaBitch()
	{
		PlayAnim("critical", ANIM_ATTACK);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		CallExternal(BAR_ID, "npc_suicide");
		CallEventDelayed(2.0f, "warn_all");
	}

	// warn_all
	void OnWarnAll()
	{
		SayText("Let that be a lesson to the rest of you. Do not defy the [insert name of bandit mafia here]!");
		PlayAnim("critical", "aim_punch1");
		SetRoam(true);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BanditExtortionist_FirstThink();
		BanditElite_FirstThink();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_bar_id") { OnGetBarId(); return true; }
		if (name == "helga_respond1") { OnHelgaRespond1(); return true; }
		if (name == "helga_respond2") { OnHelgaRespond2(); return true; }
		if (name == "helga_respond3") { OnHelgaRespond3(); return true; }
		if (name == "me_harass2") { OnMeHarass2(); return true; }
		if (name == "me_harass3") { OnMeHarass3(); return true; }
		if (name == "me_kill_da_bitch") { OnMeKillDaBitch(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "start_scene") { OnStartScene(); return true; }
		if (name == "warn_all") { OnWarnAll(); return true; }
		return BanditEliteDaggerScript::DispatchEvent(name, params);
	}
}
