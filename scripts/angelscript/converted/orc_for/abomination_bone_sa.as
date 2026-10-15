#pragma context server

// Converted from orc_for/abomination_bone_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/abomination_bone.as"

[script "orc_for/abomination_bone_sa"]
class AbominationBoneSa : AbominationBoneScript
{
	// Variables declared by included files, with the value they start with in this script
	AbominationBoneSa()
	{
		NPC_BASE_EXP = "7000";
		DOT_BREATH = 100;
		DMG_BITE_SHORT = 150;
		DMG_BITE_LONG = 350;
		DMG_LSHIELD = 150;
		NPC_SELF_ADJUST = true;
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.0;1.0;1.0;1.25;2.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;1.0;1.0;1.0;1.5;2.0;";
		START_SUSPEND = true;
		NO_SPAWN_STUCK_CHECK = true;
		NPC_BOSS_REGEN_RATE = 0.03f;
		NPC_BOSS_RESTORATION = 0.25f;
	}

	// unnamed block (first think)
	void AbominationBoneSa_FirstThink()
	{
		NPC_SELF_ADJUST = true;

		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_spawn
	void AbominationBoneSa_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("bone_abomination");
	}

	// final_adj
	void AbominationBoneSa_OnFinalAdj()
	{
		if (NPC_ADJ_LEVEL < 5.0f)
			SetName("Lesser Bone Abomination");
		else
			SetName("Bone Abomination");
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/abomination_bone");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		AbominationBoneSa_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// final_adj
	void OnFinalAdj()
	{
		AbominationBoneSa_OnFinalAdj();
		AbominationBone_OnFinalAdj(); // monsters/abomination_bone
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
		AbominationBone_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/abomination_bone
		CallExternal("players", "ext_orcfor_boss_musak", 3, OriginOf(ENT_ME));
	}

	// eat_me
	void OnEatMe()
	{
		PlayAnim("critical", "grab_fling");
	}

	// frame_grab
	void OnFrameGrab()
	{
		DeleteEntity(FindByName("orc_summoner"));
		ClientEvent("new", "all", "orc_for/orc_summoner_slaughter_cl", IndexOf(ENT_ME));
		FLING_IDX = LastClientScriptId();
		PlaySound(0, 10, "debris/bustflesh1.wav");
	}

	// frame_fling
	void OnFrameFling()
	{
		UseTrigger("twal_shaman_block");
		Vector3 flingVel = RelativeVelocity(Vector3(-400, 400, 110));
		ClientEvent("update", "all", FLING_IDX, "do_fling", flingVel);
		CallEventDelayed(1.0f, "intro_done");
		PlaySound(0, 10, "debris/bustflesh2.wav");
	}

	// intro_done
	void OnIntroDone()
	{
		OnNpcatkResumeAi();
		SetRoam(true);
		SetInvincible(false);
		INTRO_DONE = true;
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/Orc.mdl");
		Precache("monsters/abomination.mdl");
		Precache("ambience/steamjet1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AbominationBoneSa_FirstThink();
		AbominationBone_FirstThink();
		AbominationBone_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "eat_me") { OnEatMe(); return true; }
		if (name == "final_adj") { OnFinalAdj(); return true; }
		if (name == "frame_fling") { OnFrameFling(); return true; }
		if (name == "frame_grab") { OnFrameGrab(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "intro_done") { OnIntroDone(); return true; }
		if (name == "start_da_musak") { OnStartDaMusak(); return true; }
		if (name == "start_da_musak2") { OnStartDaMusak2(); return true; }
		if (name == "start_musak") { OnStartMusak(); return true; }
		if (name == "start_musak2") { OnStartMusak2(); return true; }
		return AbominationBoneScript::DispatchEvent(name, params);
	}
}
