#pragma context server

// Converted from orc_for/djinn_ogre_fire_sa.script by msc_transpiler.
// only used for the final boss

#include "runtime/ScriptEntity.as"
#include "converted/monsters/djinn_ogre_fire.as"

[script "orc_for/djinn_ogre_fire_sa"]
class DjinnOgreFireSa : DjinnOgreFireScript
{
	// Variables declared by included files, with the value they start with in this script
	DjinnOgreFireSa()
	{
		NPC_BASE_EXP = "4000";
		NPC_SELF_ADJUST = true;
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.0;1.5;2.0;5.0;7.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;1.0;1.25;2.0;5.0;7.0;";
		START_SUSPEND = true;
	}

	// unnamed block (first think)
	void DjinnOgreFireSa_FirstThink()
	{
		// shouldn't spawn at >2000hp so this is kinda pointless
		NPC_SELF_ADJUST = true;
	}

	// game_precache
	void DjinnOgreFireSa_OnGamePrecache()
	{
		PrecacheFile("monsters/djinn_ogre_fire");
	}

	// game_precache
	void OnGamePrecache()
	{
		DjinnOgreFireSa_OnGamePrecache();
		DjinnOgreFire_OnGamePrecache(); // monsters/djinn_ogre_fire
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DjinnOgreFire_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/djinn_ogre_fire
		CallExternal("players", "ext_orcfor_boss_musak", 3, OriginOf(ENT_ME));
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		SetUniqueName("fire_djinn");
		SetInvincible(true);
		OnNpcatkSuspendAi();
	}

	// final_postspawn
	void OnFinalPostspawn()
	{
		DjinnOgreFire_OnFinalPostspawn(); // monsters/djinn_ogre_fire
		OnNpcatkSuspendAi();
	}

	// kill_zugdah
	void OnKillZugdah()
	{
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);
		CallEventDelayed(1.0f, "kill_summoner");
	}

	// kill_summoner
	void OnKillSummoner()
	{
		PlayAnim("critical", "attack1");
		CallExternal(FindByName("orc_summoner"), "ext_me_die");
		PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
		CallEventDelayed(1.0f, "bring_the_pain");
	}

	// bring_the_pain
	void OnBringThePain()
	{
		UseTrigger("twal_shaman_block");
		SetRoam(true);
		SetInvincible(false);
		OnNpcatkResumeAi();
		CallEventDelayed(4.0f, "start_da_musak");
	}

	// start_da_musak
	void OnStartDaMusak()
	{
		SetVar("PLAYER_LIST", GetActivePlayers());
		CallEventDelayed(GetTokenCount("PLAYER_LIST"), "start_musak");
		CallEventDelayed(45.0f, "start_da_musak2");
	}

	// start_musak
	void OnStartMusak()
	{
		string curTarg = GetToken("PLAYER_LIST", loopIteration);
		if (RangeTo(curTarg) < 768.0f)
			CallExternal(curTarg, "ext_orcfor_boss_musak", 1);
	}

	// start_da_musak2
	void OnStartDaMusak2()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(80.0f, "start_da_musak2");
		if (NPCATK_TARGET == "unset")
			return;
		SetVar("PLAYER_LIST", GetActivePlayers());
		CallEventDelayed(GetTokenCount("PLAYER_LIST"), "start_musak2");
	}

	// start_musak2
	void OnStartMusak2()
	{
		string curTarg = GetToken("PLAYER_LIST", loopIteration);
		if (RangeTo(curTarg) < 768.0f)
			CallExternal(curTarg, "ext_orcfor_boss_musak", 2);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnOgreFireSa_FirstThink();
		DjinnOgreFire_FirstThink();
		DjinnOgreFire_FirstThink2();
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
		if (name == "bring_the_pain") { OnBringThePain(); return true; }
		if (name == "final_postspawn") { OnFinalPostspawn(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "kill_summoner") { OnKillSummoner(); return true; }
		if (name == "kill_zugdah") { OnKillZugdah(); return true; }
		if (name == "start_da_musak") { OnStartDaMusak(); return true; }
		if (name == "start_da_musak2") { OnStartDaMusak2(); return true; }
		if (name == "start_musak") { OnStartMusak(); return true; }
		if (name == "start_musak2") { OnStartMusak2(); return true; }
		return DjinnOgreFireScript::DispatchEvent(name, params);
	}
}
