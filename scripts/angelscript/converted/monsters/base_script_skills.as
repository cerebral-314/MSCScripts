#pragma context server

// Converted from monsters/base_script_skills.script by msc_transpiler.
// Script side XP system
// - just in case

#include "runtime/ScriptEntity.as"

[script "monsters/base_script_skills"]
class BaseScriptSkills : ScriptEntity
{
	// Constants
	bool NPC_HITDATA_SWORDSMANSHIP = false;
	bool NPC_HITDATA_MARTIALARTS = true;
	int NPC_HITDATA_AXEHANDLING = 2;
	int NPC_HITDATA_SMALLARMS = 3;
	int NPC_HITDATA_ARCHERY = 4;
	int NPC_HITDATA_SPELLS_FIRE = 5;
	int NPC_HITDATA_SPELLS_ICE = 6;
	int NPC_HITDATA_SPELLS_LIGHTNING = 7;
	int NPC_HITDATA_SPELLS_EARTH = 8;
	int NPC_HITDATA_SPELLS_SUMMON = 9;
	int NPC_HITDATA_SPELLS_DIVINATION = 10;
	int NPC_HITDATA_SPELLS_AFFLICTION = 11;
	string NPC_HITDATA_INIT_SKILLS = "0;0;0;0;0;0;0;0;0;0;0;0";
	string NPC_SKILLS_LIST = "swordsmanship;martialarts;axehandling;bluntarms;smallarms;archery;spellcasting.fire;spellcasting.ice;spellcasting.lightning;spellcasting.earth;spellcasting.summon;spellcasting.divination;spellcasting.affliction";

	// Variables (an unset .script variable reads as its own name)
	string NPC_HITDATA_IDS = "NPC_HITDATA_IDS";
	string NPC_HITDATA_DMG = "NPC_HITDATA_DMG";
	string NPC_TOTAL_DAMAGE = "NPC_TOTAL_DAMAGE";
	string NPC_ADJUSTED_DMG = "NPC_ADJUSTED_DMG";
	int FOUND_EMPTY_SLOT = 0;
	string PLAYER_HITDATA_SKILLS_0 = "PLAYER_HITDATA_SKILLS_0";
	string PLAYER_HITDATA_SKILLS_1 = "PLAYER_HITDATA_SKILLS_1";
	string PLAYER_HITDATA_SKILLS_2 = "PLAYER_HITDATA_SKILLS_2";
	string PLAYER_HITDATA_SKILLS_3 = "PLAYER_HITDATA_SKILLS_3";
	string PLAYER_HITDATA_SKILLS_4 = "PLAYER_HITDATA_SKILLS_4";
	string PLAYER_HITDATA_SKILLS_5 = "PLAYER_HITDATA_SKILLS_5";
	string PLAYER_HITDATA_SKILLS_6 = "PLAYER_HITDATA_SKILLS_6";
	string PLAYER_HITDATA_SKILLS_7 = "PLAYER_HITDATA_SKILLS_7";
	string PLAYER_HITDATA_SKILLS_8 = "PLAYER_HITDATA_SKILLS_8";
	string PLAYER_HITDATA_SKILLS_9 = "PLAYER_HITDATA_SKILLS_9";
	string T_SKILL_LIST = "T_SKILL_LIST";
	float TOTAL_XP_TO_GIVE = 0.0f;
	string OUT_IDX = "OUT_IDX";

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type PARAM4=AccuracyRoll PARAM5=skill_type
	string BaseScriptSkills_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		float getAmt = 0.0f;
		string result = "";

		float incDmg = damage;
		string incDmgText = Text(incDmg);

		// hande parry here
		// parrystuff
		// parrystuff
		// parrystuff
		NPC_ADJUSTED_DMG = incDmgText;

		OnNpcResistDamage(); // handle any dmg resists here, return NPC_ADJUSTED_DMG

		incDmgText = NPC_ADJUSTED_DMG;
		incDmg = Float(incDmgText);

		// handle XP
		if (inflictor is null)
			return result;
		if (!(incDmg > 0.0f))
			return result;
		if (!IsPlayer(attacker))
			return result;

		int playerHitdataIdx = FindToken(NPC_HITDATA_IDS, EntityId(attacker));

		if (playerHitdataIdx == -1)
		{
			// init new player
			playerHitdataIdx = GetTokenCount(NPC_HITDATA_IDS);

			// I can only track up to 10 players hitting me, try to drop one
			if (playerHitdataIdx > 15)
			{
				for (int i = 0; i < playerHitdataIdx; i++)
				{
					loopIteration = i;
					OnNpcexpDropExpCounter();
				}
				FOUND_EMPTY_SLOT = -1;
				for (int i = 0; i < playerHitdataIdx; i++)
				{
					loopIteration = i;
					OnNpcexpFindEmptySlot();
				}
			}

			if (playerHitdataIdx >= 10)
				PlayerMessage(attacker, "XP Sys Warning: " + NameOf(ENT_ME) + " cannot find anymore XP slots");

			if (playerHitdataIdx < 10)
				NPC_HITDATA_IDS = TokenAdd(NPC_HITDATA_IDS, EntityId(attacker));
		}

		int skillIdx = FindToken(NPC_SKILLS_LIST, EntityId(inflictor));

		if (playerHitdataIdx == 0)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_0, skillIdx));
		if (playerHitdataIdx == 1)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_1, skillIdx));
		if (playerHitdataIdx == 2)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_2, skillIdx));
		if (playerHitdataIdx == 3)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_3, skillIdx));
		if (playerHitdataIdx == 4)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_4, skillIdx));
		if (playerHitdataIdx == 5)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_5, skillIdx));
		if (playerHitdataIdx == 6)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_6, skillIdx));
		if (playerHitdataIdx == 7)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_7, skillIdx));
		if (playerHitdataIdx == 8)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_8, skillIdx));
		if (playerHitdataIdx == 9)
			getAmt = Float(GetToken(PLAYER_HITDATA_SKILLS_9, skillIdx));

		getAmt += incDmg;

		if (playerHitdataIdx == 0)
			PLAYER_HITDATA_SKILLS_0 = TokenSet(PLAYER_HITDATA_SKILLS_0, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 1)
			PLAYER_HITDATA_SKILLS_1 = TokenSet(PLAYER_HITDATA_SKILLS_1, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 2)
			PLAYER_HITDATA_SKILLS_2 = TokenSet(PLAYER_HITDATA_SKILLS_2, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 3)
			PLAYER_HITDATA_SKILLS_3 = TokenSet(PLAYER_HITDATA_SKILLS_3, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 4)
			PLAYER_HITDATA_SKILLS_4 = TokenSet(PLAYER_HITDATA_SKILLS_4, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 5)
			PLAYER_HITDATA_SKILLS_5 = TokenSet(PLAYER_HITDATA_SKILLS_5, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 6)
			PLAYER_HITDATA_SKILLS_6 = TokenSet(PLAYER_HITDATA_SKILLS_6, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 7)
			PLAYER_HITDATA_SKILLS_7 = TokenSet(PLAYER_HITDATA_SKILLS_7, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 8)
			PLAYER_HITDATA_SKILLS_8 = TokenSet(PLAYER_HITDATA_SKILLS_8, skillIdx, Text(getAmt));
		if (playerHitdataIdx == 9)
			PLAYER_HITDATA_SKILLS_9 = TokenSet(PLAYER_HITDATA_SKILLS_9, skillIdx, Text(getAmt));

		float getTotalAmt = Float(GetToken(NPC_HITDATA_DMG, playerHitdataIdx));
		getTotalAmt += incDmg;

		NPC_HITDATA_DMG = TokenSet(NPC_HITDATA_DMG, playerHitdataIdx, Text(getTotalAmt));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		NPC_HITDATA_IDS = "";
		NPC_HITDATA_DMG = "";
		NPC_TOTAL_DAMAGE = "";
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return BaseScriptSkills_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// npcexp_drop_exp_counter
	void OnNpcexpDropExpCounter()
	{
		string curExpPlayer = GetToken(NPC_HITDATA_IDS, loopIteration);
		bool dropThisPlayer = false;
		if (!Exists(curExpPlayer))
			dropThisPlayer = true;
		if (!IsPlayer(curExpPlayer))
			dropThisPlayer = true;
		if (!dropThisPlayer)
			return;
		OnNpcexpResetSkills(Float(curExpPlayer));
	}

	// npcexp_find_empty_slot
	void OnNpcexpFindEmptySlot()
	{
		if (!(FOUND_EMPTY_SLOT < 0))
			return;
		string curExpPlayer = GetToken(NPC_HITDATA_IDS, loopIteration);
		if (curExpPlayer == "0")
			FOUND_EMPTY_SLOT = loopIteration;
	}

	// player_left
	void OnPlayerLeft(CBaseEntity@ player = null)
	{
		int playerHitdataIdx = FindToken(NPC_HITDATA_IDS, Text(loopIteration));
		if (!(playerHitdataIdx > -1))
			return;
		OnNpcexpResetSkills(playerHitdataIdx);
	}

	// npcexp_reset_skills
	void OnNpcexpResetSkills(float playerIndex = 0.0f)
	{
		// (re)init player skill data
		NPC_HITDATA_DMG = TokenSet(NPC_HITDATA_DMG, int(playerIndex), "0");
		NPC_HITDATA_IDS = TokenSet(NPC_HITDATA_IDS, int(playerIndex), "0");
		if (playerIndex == 0.0f)
			PLAYER_HITDATA_SKILLS_0 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 1.0f)
			PLAYER_HITDATA_SKILLS_1 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 2.0f)
			PLAYER_HITDATA_SKILLS_2 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 3.0f)
			PLAYER_HITDATA_SKILLS_3 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 4.0f)
			PLAYER_HITDATA_SKILLS_4 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 5.0f)
			PLAYER_HITDATA_SKILLS_5 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 6.0f)
			PLAYER_HITDATA_SKILLS_6 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 7.0f)
			PLAYER_HITDATA_SKILLS_7 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 8.0f)
			PLAYER_HITDATA_SKILLS_8 = NPC_HITDATA_INIT_SKILLS;
		if (playerIndex == 9.0f)
			PLAYER_HITDATA_SKILLS_9 = NPC_HITDATA_INIT_SKILLS;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// (never true here, the rest is skipped) if NPC_GIVE_EXP > 0
	}

	// npcexp_dish_out_exp
	void OnNpcexpDishOutExp()
	{
		// proc each player
		int curIdx = loopIteration;
		string curPlayer = GetToken(NPC_HITDATA_IDS, curIdx);
		float curDmg = Float(GetToken(NPC_HITDATA_DMG, curIdx));

		if (curIdx == 0)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_0;
		if (curIdx == 1)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_1;
		if (curIdx == 2)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_2;
		if (curIdx == 3)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_3;
		if (curIdx == 4)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_4;
		if (curIdx == 5)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_5;
		if (curIdx == 6)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_6;
		if (curIdx == 7)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_7;
		if (curIdx == 8)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_8;
		if (curIdx == 9)
			T_SKILL_LIST = PLAYER_HITDATA_SKILLS_9;

		// player did less than all the damage to me, adjust
		TOTAL_XP_TO_GIVE = 0.0f;
		float myHp = MyMaxHealth();
		if (curDmg < myHp)
		{
			curDmg = Divide(curDmg, myHp);
			TOTAL_XP_TO_GIVE *= curDmg;
		}

		// player did more damage than I had hp (prob due to regen/whatnot), adjust (give him my max exp)
		if (curDmg > myHp)
		{
			TOTAL_XP_TO_GIVE = 0.0f; // redundant
		}

		OUT_IDX = curIdx;

		// proc each skill
		int count = GetTokenCount(T_SKILL_LIST);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcexpLearnSkill();
		}
		loopIteration = outerIteration;
	}

	// npcexp_learn_skill
	void OnNpcexpLearnSkill()
	{
		string thisPlayer = GetToken(NPC_HITDATA_IDS, Int(OUT_IDX));
		int totalDmg = Int(GetToken(NPC_HITDATA_DMG, Int(OUT_IDX)));

		int skillIdx = loopIteration;
		string dmgWithThisSkill = GetToken(T_SKILL_LIST, skillIdx);

		float percentDmgDoneWSkill = Float(dmgWithThisSkill);
		percentDmgDoneWSkill = Divide(percentDmgDoneWSkill, totalDmg);

		float skillPointsToGiveSkill = TOTAL_XP_TO_GIVE * percentDmgDoneWSkill;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNpcResistDamage() {} // npc_resist_damage

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcexp_dish_out_exp") { OnNpcexpDishOutExp(); return true; }
		if (name == "npcexp_drop_exp_counter") { OnNpcexpDropExpCounter(); return true; }
		if (name == "npcexp_find_empty_slot") { OnNpcexpFindEmptySlot(); return true; }
		if (name == "npcexp_learn_skill") { OnNpcexpLearnSkill(); return true; }
		if (name == "npcexp_reset_skills") { OnNpcexpResetSkills(Float(Param(params, 0))); return true; }
		if (name == "player_left") { OnPlayerLeft(EntityParam(params, 0)); return true; }
		return false;
	}
}
