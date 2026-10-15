#pragma context server

// Converted from monsters/base_self_adjust.script by msc_transpiler.
// moving self-adjustment system here so can easily be included in non-ai mobs
// add future adaptive system here
// also handles add params and map defined adjustments (but not externals)

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseSelfAdjust
{
	// Constants
	string NPC_ADJ_TIERS = "0;500;1000;2000;3000;5000";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;2.0;3.0;3.5;4.0;5.0;";
	string NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;3.5;4.0;5.0;";

	// Variables (an unset .script variable reads as its own name)
	string NEW_NAME = "NEW_NAME";
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	float NPC_DMG_MULTI = 0.0f;
	float NPC_HP_MULTI = 0.0f;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	float NPC_EVENT_COUNTER = 0.0f;
	float NPC_MAXHP = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	float NPC_ADJ_LEVEL = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	float NPC_ALL_XP_ADJ = 0.0f;
	float ADJ_RATIO = 0.0f;
	float NPC_EXP_FINAL = 0.0f;
	float DROP_GOLD_AMT = 0.0f;

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void BaseSelfAdjust_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		bool creatAdj = false;

		DebugPrint("game_postspawn got name " + title + " dmg " + damageMultiplier + " hp " + healthMultiplier + " ( PARAMS: " + params + " )");
		NEW_NAME = title;
		if (NEW_NAME != "default")
		{
			SetName(NEW_NAME);
			NPC_CUSTOM_NAME = true;
			NPC_CUSTOM_NAME_STRING = NEW_NAME;
		}

		if (Text(NPC_DMG_MULTI) == "NPC_DMG_MULTI")
			NPC_DMG_MULTI = 1.0f;
		if (Float(damageMultiplier) > 1.0f)
		{
			NPC_DMG_MULTI = Float(damageMultiplier);
			SetDamageMultiplier(NPC_DMG_MULTI);
			creatAdj = true;
		}

		NPC_HP_MULTI = 1.0f;
		if (Float(healthMultiplier) > 1.0f)
		{
			NPC_HP_MULTI = Float(healthMultiplier);
			creatAdj = true;
		}

		// if ( CREAT_ADJ ) dbg Adjusted: $get(ent_me,name) dmgmulti NPC_DMG_MULTI hpmulti NPC_HP_MULTI
		if (params != "none")
		{
			NPC_DO_EVENTS = params;
			CallEventDelayed(0.01f, "npcatk_setup_addparams");
		}
	}

	// game_dynamically_created
	void BaseSelfAdjust_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (GetVar("G_MAP_ADDPARAMS") != "0")
			OnNpcatkSetupAddparams();
	}

	// npcatk_setup_addparams
	void BaseSelfAdjust_OnNpcatkSetupAddparams()
	{
		DebugPrint("npcatk_setup_addparams [ " + NPC_DO_EVENTS + " ]");

		// add global add params, if any
		if (GetVar("G_MAP_ADDPARAMS") != "0" && !Contains(NPC_DO_EVENTS, "no_global") && !Truthy(GetVar("I_R_PET")))
		{
			string npcDoEvents = GetVar("G_MAP_ADDPARAMS") + NPC_DO_EVENTS;
			NPC_DO_EVENTS = npcDoEvents;
			DebugPrint("npcatk_setup_addparams gaddparamsout " + NPC_DO_EVENTS);
		}

		NPC_EVENT_COUNTER = 0.0f;
		OnNpcatkDoEvents();
	}

	// npcatk_do_events
	void BaseSelfAdjust_OnNpcatkDoEvents()
	{
		float nEvents = GetTokenCount(NPC_DO_EVENTS) - 1.0f;

		DebugPrint("npcatk_do_events checking " + (int(NPC_EVENT_COUNTER + 1.0f)) + " / " + (int(nEvents + 1.0f)));

		string eventName = GetToken(NPC_DO_EVENTS, int(NPC_EVENT_COUNTER));
		float nextEventIdx = NPC_EVENT_COUNTER + 1.0f;
		if (nextEventIdx <= nEvents)
		{
			string nextEvent = GetToken(NPC_DO_EVENTS, int(nextEventIdx));
			// igonring this event, if it is a number or vector, likely a parameter
			if (!Truthy(OnNpcatkDoEventsIsnum(eventName)))
			{
				DebugPrint("npcatk_do_events " + (int(NPC_EVENT_COUNTER + 1.0f)) + " / " + (int(nEvents + 1.0f)) + " = " + eventName + " " + nextEvent);
				CallEventOrDelay(eventName, nextEvent);
			}
		}
		else if (!Truthy(OnNpcatkDoEventsIsnum(eventName)))
		{
			DebugPrint("npcatk_do_events " + (int(NPC_EVENT_COUNTER + 1.0f)) + " / " + (int(nEvents + 1.0f)) + " = " + eventName);
			CallEventOrDelay(eventName);
		}

		if (NPC_EVENT_COUNTER < nEvents)
		{
			NPC_EVENT_COUNTER += 1.0f;
			CallEventDelayed(0.01f, "npcatk_do_events");
		}
		else if (NPC_USES_HANDLE_EVENTS) // post-spawn events, such as sprite-in, handled in base_monster_shared
			OnNpcatkHandlePostevents();
	}

	// npcatk_do_events_isnum
	string BaseSelfAdjust_OnNpcatkDoEventsIsnum(string text = "")
	{
		string result = "";
		// check if event, isn't actually an event, but parameter to be passed, such as a number or vector
		// dbg npcatk_do_events_isnum PARAM1
		string firstChar = Left(text, 1);
		bool isNum = false;
		string numchars = "0123456789.,)($";
		if (numchars.findFirst(firstChar) > -1)
		{
			DebugPrint("npcatk_do_events_isnum " + text + " seems to be a parameter, skipping");
			isNum = true;
		}
		result = AppendResult(result, Text(isNum));
		return result;
	}

	// npc_post_spawn
	void BaseSelfAdjust_OnNpcPostSpawn()
	{
		bool gotName = false;
		string addStr = "ADD_STR";
		if (Truthy(GetVar("I_R_PET")))
			return;

		if (NPC_SELF_ADJUST)
			OnNpcatkSelfAdjust();

		OnNpcatkSetSkill(); // FEB2010_08 moved from base_monster_shared

		DebugPrint("npc_post_spawn Final Adjustments - ( mdmg " + Text(NPC_DMG_MULTI) + " mhp " + Text(NPC_HP_MULTI) + " xp " + Text(NPC_GIVE_EXP) + " )");

		NPC_MAXHP = MyMaxHealth();
		if (NPC_HP_MULTI > 0.0f)
		{
			NPC_MAXHP *= NPC_HP_MULTI;
			SetHealth(NPC_MAXHP);
		}

		if (BASE_FRAMERATE == "BASE_FRAMERATE")
			BASE_FRAMERATE = "1.0";
		if (Text(BASE_MOVESPEED) == "BASE_MOVESPEED")
			BASE_MOVESPEED = 1.0f;

		if (NPC_CUSTOM_NAME)
		{
			if (Contains(NameOf(ENT_ME), NPC_CUSTOM_NAME_STRING))
				gotName = true;
			if (!gotName)
			{
				SetName(NPC_CUSTOM_NAME_STRING);
				DebugPrint("npc_post_spawn " + NPC_CUSTOM_NAME_STRING);
			}
		}

		if (NPC_ADJ_LEVEL > 0.0f)
		{
			if (NPC_ADJ_LEVEL == 1.0f)
				addStr = " II";
			if (NPC_ADJ_LEVEL == 2.0f)
				addStr = " III";
			if (NPC_ADJ_LEVEL == 3.0f)
				addStr = " IV";
			if (NPC_ADJ_LEVEL == 4.0f)
				addStr = " V";
			if (NPC_ADJ_LEVEL == 5.0f)
				addStr = " VI";
			string newName = GetProp(ENT_ME, "name.prefix") + "|" + NameOf(ENT_ME) + addStr;
			SetName(newName);
		}
	}

	// npcatk_self_adjust
	void BaseSelfAdjust_OnNpcatkSelfAdjust()
	{
		int totalHp = Int(Eval("game.players.totalhp"));

		NPC_ADJ_LEVEL = 0.0f;
		if (totalHp > Float(GetToken(NPC_ADJ_TIERS, 1)))
			NPC_ADJ_LEVEL = 1.0f;
		if (totalHp > Float(GetToken(NPC_ADJ_TIERS, 2)))
			NPC_ADJ_LEVEL = 2.0f;
		if (totalHp > Float(GetToken(NPC_ADJ_TIERS, 3)))
			NPC_ADJ_LEVEL = 3.0f;
		if (totalHp > Float(GetToken(NPC_ADJ_TIERS, 4)))
			NPC_ADJ_LEVEL = 4.0f;
		if (totalHp > Float(GetToken(NPC_ADJ_TIERS, 5)))
			NPC_ADJ_LEVEL = 5.0f;

		if (Float(NPC_ADJ_DOWN) > 0.0f)
		{
			NPC_ADJ_LEVEL -= Float(NPC_ADJ_DOWN);
			if (NPC_ADJ_LEVEL < 0.0f)
				NPC_ADJ_LEVEL = 0.0f;
		}

		float addNpcHpMulti = Float(GetToken(NPC_ADJ_HP_MUTLI_TOKENS, int(NPC_ADJ_LEVEL)));
		if (NPC_HP_MULTI == 1.0f)
			addNpcHpMulti -= 1.0f;
		NPC_HP_MULTI += addNpcHpMulti;

		// setvard NPC_HP_MULTI_ADD $get_token(NPC_ADJ_HP_MUTLI_TOKENS,NPC_ADJ_LEVEL)
		float addNpcDmgMulti = Float(GetToken(NPC_ADJ_DMG_MUTLI_TOKENS, int(NPC_ADJ_LEVEL)));
		if (NPC_DMG_MULTI == 1.0f)
			addNpcDmgMulti -= 1.0f;
		NPC_DMG_MULTI += addNpcDmgMulti;

		// setvard NPC_DMG_MULTI_ADD $get_token(NPC_ADJ_DMG_MUTLI_TOKENS,NPC_ADJ_LEVEL)
		SetDamageMultiplier(NPC_DMG_MULTI); // this will be readjusted (added to) if dmgmulti also set in entity

		float orgExp = NPC_GIVE_EXP;
		if (NPC_GIVE_EXP == 0.0f && orgExp > 0.0f)
			NPC_GIVE_EXP = orgExp;

		DebugPrint("npcatk_self_adjust " + Text(NPC_ADJ_LEVEL));
	}

	// game_death
	void BaseSelfAdjust_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool exitSub = false;

		if (NPC_SELF_ADJUST && !NPC_NO_COUNT && !NPC_SELF_ADJUST_NOAVG)
		{
			LegacyCommand("add", "G_SADJ_DEATHS", 1);
			float fNpcAdjLevel = NPC_ADJ_LEVEL + 1.0f;
			if (Float(NPC_ADJ_DOWN) > 0.0f)
			{
				fNpcAdjLevel += 1.0f;
				fNpcAdjLevel += Float(NPC_ADJ_DOWN);
			}

			LegacyCommand("add", "G_SADJ_LEVELS", fNpcAdjLevel);

			DebugPrint("SelfAdj_Count: kills " + GetVar("G_SADJ_DEATHS") + " levels " + GetVar("G_SADJ_LEVELS"));
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
			{
				int totalKills = Int(GetVar("G_SADJ_DEATHS"));
				string totalLevels = GetVar("G_SADJ_LEVELS");
				string avgLevelsText = totalLevels;
				float avgLevels = Divide(Float(avgLevelsText), totalKills);
				avgLevelsText = Text(avgLevels);
				string outTitle = "+" + Text(fNpcAdjLevel);
				string outMsg = "Average=" + avgLevelsText;
				InfoMessage("all", outTitle, outMsg);
			}
		}

		// just track average player HP on the server with each kill
		if (Float(GetVar("G_TRACK_HP")) > 0.0f && !NPC_SELF_ADJUST_NOAVG && !Truthy(GetVar("I_R_PET")))
		{
			LegacyCommand("add", "G_TRACK_HP", Eval("game.players.totalhp"));
			LegacyCommand("add", "G_TRACK_KILLS", 1);
		}

		if (!(Float(GetVar("G_TRACK_DEATHS")) > 0.0f))
			return;
		if (Truthy(GetVar("AM_SUMMONED")))
			return;
		if (Truthy(GetVar("I_R_PET")))
			return;
		if (NPC_NO_COUNT)
			return;
		if (Contains(ScriptNameOf(ENT_ME), "summon"))
			exitSub = true;
		if (Contains(ScriptNameOf(ENT_ME), "companion"))
			exitSub = true;
		if (exitSub)
			return;
		LegacyCommand("add", "G_TRACK_DEATHS", 1);
		if (Float(GetVar("G_TRACK_DEATHS")) >= Float(GetVar("G_TRACK_DEATHS_TRIGGER")) && GetVar("G_TRACK_DEATHS_EVENT") != "none")
		{
			CallExternal(GetVar("GAME_MASTER"), "G_TRACK_DEATHS_EVENT");
			SetGlobal("G_TRACK_DEATHS_EVENT", "none"); // might wanna keep tracking, but we only do this once
		}
	}

	// npcatk_set_skill
	void BaseSelfAdjust_OnNpcatkSetSkill()
	{
		float adjRatio;
		bool overAdjust = false;
		float adj = 0.0f;
		float debug;
		string debugText;
		float totalMultiToAdd = 0.0f;

		if (GetVar("NPC_BASE_EXP") != "NPC_BASE_EXP") // this is to deal with setvar/d conflicts
			NPC_GIVE_EXP = Float(GetVar("NPC_BASE_EXP"));
		if (Text(NPC_GIVE_EXP) == "NPC_GIVE_EXP")
			NPC_GIVE_EXP = ExperienceOf(ENT_ME);
		if (GetVar("NPC_EXP_MULTI") != "NPC_EXP_MULTI") // pre-multiplier
			NPC_GIVE_EXP *= Float(GetVar("NPC_EXP_MULTI"));

		// Adjust skill for multipliers and special conditions
		if (ExperienceOf(ENT_ME) == 0.0f)
		{
			DebugPrint("npcatk_set_skill xp wasn't set, using NPC_GIVE_EXP");
			SetSkillLevel(NPC_GIVE_EXP);
		}
		else
		{
			DebugPrint("npcatk_set_skill NPC_GIVE_EXP was not set, using " + Text(ExperienceOf(ENT_ME)));
			NPC_GIVE_EXP = ExperienceOf(ENT_ME);
		}

		if (!(NPC_GIVE_EXP > 0.0f)) // if this mob has no XP, skip this shit
			return;

		NPC_ALL_XP_ADJ = 1.0f;

		// check for HP/HP dmg multiplier over adjust [begin]
		if (NPC_DMG_MULTI >= NPC_HP_MULTI)
		{
			adjRatio = Divide(NPC_HP_MULTI, NPC_DMG_MULTI);
		}
		else
		{
			adjRatio = NPC_DMG_MULTI;
			ADJ_RATIO = Divide(ADJ_RATIO, NPC_HP_MULTI);
		}
		if (adjRatio < 0.25f)
			overAdjust = true;
		if (ToLowerCase(MapName()) == "undercliffs") // allowing it on this map
			overAdjust = false;
		if (overAdjust)
		{
			string msgTitle = "MAP ERROR: " + NameOf(ENT_ME);
			InfoMessage("all", msgTitle, "HP/DMG multipliers cannot be more than 4x one another, or XP will not be adjusted");
		}

		// check for HP/HP dmg multiplier over adjust [end]
		if (!overAdjust)
		{
			if (NPC_DMG_MULTI > 1.0f)
			{
				// ~ +50% per 100%>1
				adj = NPC_DMG_MULTI;
				if (adj > 5.0f)
					adj = 5.0f;
				adj -= 1.0f;
				adj *= 0.5f;
				adj += 1.0f;
				debugText = "dmgmulti:" + Text(NPC_DMG_MULTI);
				DebugPrint("expadj " + Text(adj) + " noscale " + debugText);
				NPC_ALL_XP_ADJ += adj;
			}

			if (NPC_HP_MULTI > 1.0f)
			{
				// ~ +50% per 100%>1
				adj = NPC_HP_MULTI;
				if (adj > 5.0f)
					adj = 5.0f;
				adj -= 1.0f;
				adj *= 0.5f;
				adj += 1.0f;
				debugText = "hpmulti:" + Text(NPC_HP_MULTI);
				DebugPrint("expadj " + Text(adj) + " noscale " + debugText);
				NPC_ALL_XP_ADJ += adj;
			}
		}

		// adjust flags
		if (NPC_ADJ_FLAGS != "NPC_ADJ_FLAGS")
		{
			if (Contains(NPC_ADJ_FLAGS, "telehunt"))
			{
				adj = 0.0f;
				if (NPC_TELEHUNT_FREQ > 30.0f)
					adj += 1.5f;
				else if (NPC_TELEHUNT_FREQ >= 20.0f)
					adj += 2.0f;
				else if (EXT_DEMON_BLOOD_RATIO >= 10.0f)
					adj += 2.25f;
				else if (NPC_TELEHUNT_FREQ >= 6.0f)
					adj += 2.5f;
				else if (NPC_TELEHUNT_FREQ >= 0.0f)
					adj += 3.0f;
				DebugPrint("expadj " + Text(adj) + " noscale telehunt");
				NPC_ALL_XP_ADJ += adj;
			}
			adj = 0.0f;
			if (Contains(NPC_ADJ_FLAGS, "speed_x2"))
				adj += 1.5f;
			if (Contains(NPC_ADJ_FLAGS, "speed_x3"))
				adj += 1.75f;
			if (Contains(NPC_ADJ_FLAGS, "speed_x4"))
				adj += 2.0f;
			if (adj > 0.0f)
				DebugPrint("expadj 2.0 noscale speed_xX");
			NPC_ALL_XP_ADJ += adj;
			if (Contains(NPC_ADJ_FLAGS, "demon_blood"))
			{
				adj = 0.0f;
				if (EXT_DEMON_BLOOD_RATIO > 1.0f)
				{
					int maxScale = 5;
					float inScale = EXT_DEMON_BLOOD_RATIO;
					if (inScale > 5.0f)
						inScale = 5.0f;
					inScale = Divide(inScale, maxScale);
					debugText = "demon_blood:" + Text(EXT_DEMON_BLOOD_RATIO);
					DebugPrint("expadj " + Text(Ratio(inScale, 1.1f, 2)) + " noscale " + debugText);
					adj += Ratio(inScale, 1.1f, 2);
					NPC_ALL_XP_ADJ += adj;
				}
			}
			if (Contains(NPC_ADJ_FLAGS, "mspeed"))
			{
				if (NPC_MOVE_SPEED_ADJ > 1.0f)
				{
					adj = 0.0f;
					float toAdd = 0.25f;
					float timesToAdd = NPC_MOVE_SPEED_ADJ;
					toAdd *= timesToAdd;
					toAdd = Clamp(toAdd, 0.25f, 2.0f);
					toAdd += 1.0f;
					DebugPrint("expadj " + Text(toAdd) + " noscale mspeed+");
					adj += toAdd;
					NPC_ALL_XP_ADJ += adj;
				}
				if (NPC_MOVE_SPEED_ADJ < 1.0f)
				{
					// really need to rethink how expadj works, too easy to get negatives, too difficult to figure down ratios
					// maybe postive ratios increase by an amount, and negative ones subtract
					// also I suck at basic math these days
					adj = 0.0f;
					if (NPC_MOVE_SPEED_ADJ >= 0.75f)
						adj -= 0.25f;
					else if (NPC_MOVE_SPEED_ADJ >= 0.5f)
						adj -= 0.5f;
					else if (NPC_MOVE_SPEED_ADJ >= 0.25f)
						adj -= 0.75f;
					else if (NPC_MOVE_SPEED_ADJ < 0.25f)
						adj -= 0.9f;
					DebugPrint("expadj " + Text(adj) + " noscale mspeed-");
					NPC_ALL_XP_ADJ += adj;
				}
			}
		}

		// moar adjustments
		if (NPC_DOT_POISON)
		{
			totalMultiToAdd = 0.25f * NPC_DOT_POISON_RATIO + 1.0f;
			DebugPrint("expadj " + Text(totalMultiToAdd) + " noscale NPC_DOT_POISON");
			NPC_ALL_XP_ADJ += totalMultiToAdd;
		}
		if (NPC_DOT_FIRE)
		{
			totalMultiToAdd = 0.25f * NPC_DOT_FIRE_RATIO + 1.0f;
			DebugPrint("expadj " + Text(totalMultiToAdd) + " noscale NPC_DOT_FIRE");
			NPC_ALL_XP_ADJ += totalMultiToAdd;
		}
		if (NPC_DOT_COLD)
		{
			totalMultiToAdd = 0.25f * NPC_DOT_COLD_RATIO + 1.0f;
			DebugPrint("expadj " + Text(totalMultiToAdd) + " noscale NPC_DOT_COLD");
			NPC_ALL_XP_ADJ += totalMultiToAdd;
		}
		if (NPC_DOT_LIGHTNING)
		{
			totalMultiToAdd = 0.25f * NPC_DOT_LIGHTNING_RATIO + 1.0f;
			DebugPrint("expadj " + Text(totalMultiToAdd) + " noscale NPC_DOT_LIGHTNING");
			NPC_ALL_XP_ADJ += totalMultiToAdd;
		}

		if (GetVar("NPC_BONUS_XP_RATIO") != "NPC_BONUS_XP_RATIO") // generic bonus XP multi for individual mobs
			NPC_ALL_XP_ADJ += 0.0f;

		if (!Truthy(GetVar("NO_EXP_MULTI")))
			LegacyCommand("expadj", NPC_ALL_XP_ADJ, "noscale", "apply external adjustments");

		// finals
		if (Text(NPC_EXP_REDUCT) != "NPC_EXP_REDUCT")
			LegacyCommand("expadj", NPC_EXP_REDUCT, "noscale", "NPC_EXP_REDUCT");

		if (GetVar("G_EXP_MULTI") != "G_EXP_MULTI" && Float(GetVar("G_EXP_MULTI")) != 1.0f)
			LegacyCommand("expadj", GetVar("G_EXP_MULTI"), "noscale", "global xp multi");

		if (Truthy(GetVar("NO_EXP_MULTI")))
		{
			DebugPrint("expadj No XP Multi Allowed, resetting.");
			SetSkillLevel(0); // reset, but can still reduce
			if (Text(NPC_EXP_REDUCT) != "NPC_EXP_REDUCT")
				LegacyCommand("expadj", NPC_EXP_REDUCT, "noscale", "NPC_EXP_REDUCT+NO_EXP_MULTI");
		}

		DebugPrint("expadj [PRE-FN] " + Text(ExperienceOf(ENT_ME)));

		// last
		// FN XP multi applies even on NO_EXP_MULTI mobs - eg. rats
		if (Truthy(Eval("game.central")))
		{
			LegacyCommand("expadj", 2.0f, "noscale", "FN"); // +200% XP on FN
			// +50% XP/player beyond the first
			float nPlayerAdj = Float(Eval("game.playersnb.noafk"));
			debug = nPlayerAdj;
			debugText = Text(debug);

			if (NPC_IS_BOSS)
			{
				LegacyCommand("expadj", 4.0f, "noscale", "FNBoss"); // +400% XP for bosses on FN
			}

			if (nPlayerAdj > 1.0f)
				nPlayerAdj -= 1.0f;
			nPlayerAdj *= 0.5f;
			nPlayerAdj += 1.0f;
			LegacyCommand("expadj", nPlayerAdj, "noscale", debugText);
		}

		// ============= fin XP adjust
		NPC_GIVE_EXP = ExperienceOf(ENT_ME);
		NPC_EXP_FINAL = NPC_GIVE_EXP;

		// adjust gold too
		if (Truthy(Eval("game.central")) && NPC_GIVE_EXP != 0.0f)
		{
			// (never true here, the rest is skipped) if NPC_ORIG_EXP isnot 'NPC_ORIG_EXP'
		}
	}

	// game_dynamically_created
	void BaseSelfAdjust_OnGameDynamicallyCreated_2(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (creatorValue1 != "events")
			return;
		NPC_DO_EVENTS = creatorValue2;
		CallEventDelayed(0.01f, "npcatk_setup_addparams"); // delay, make sure I spawn first
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	void OnNpcatkSetupAddparams() { BaseSelfAdjust_OnNpcatkSetupAddparams(); } // npcatk_setup_addparams
	void OnNpcatkDoEvents() { BaseSelfAdjust_OnNpcatkDoEvents(); } // npcatk_do_events
	string OnNpcatkDoEventsIsnum(string text = "") { return BaseSelfAdjust_OnNpcatkDoEventsIsnum(text); } // npcatk_do_events_isnum
	void OnNpcPostSpawn() { BaseSelfAdjust_OnNpcPostSpawn(); } // npc_post_spawn
	void OnNpcatkSelfAdjust() { BaseSelfAdjust_OnNpcatkSelfAdjust(); } // npcatk_self_adjust
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnNpcatkSetSkill() { BaseSelfAdjust_OnNpcatkSetSkill(); } // npcatk_set_skill
	void OnLEventName() {} // L_EVENT_NAME
	void OnNpcatkHandlePostevents() {} // npcatk_handle_postevents

	// This file's events and timers by their .script names
	bool BaseSelfAdjust_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npcatk_do_events") { OnNpcatkDoEvents(); return true; }
		if (name == "npcatk_do_events_isnum") { Return(OnNpcatkDoEventsIsnum(Param(params, 0))); return true; }
		if (name == "npcatk_self_adjust") { OnNpcatkSelfAdjust(); return true; }
		if (name == "npcatk_set_skill") { OnNpcatkSetSkill(); return true; }
		if (name == "npcatk_setup_addparams") { OnNpcatkSetupAddparams(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_self_adjust"]
shared class BaseSelfAdjustScript : ScriptEntity, BaseSelfAdjust
{
	// Variables every script that includes this file declares
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool DEMON_BLOOD = false;
	int DROP_GOLD = 0;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	bool FREEZE_WAS_SUSPEND = false;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	bool HIT_BY_MANABALL = false;
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool I_R_FROZEN = false;
	float MAKE_NOISE = 0.0f;
	int MONSTER_WIDTH = 0;
	string MY_OLD_NAME = "MY_OLD_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_CRITICAL = false;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool NPC_DID_DEATH = false;
	float NPC_DIE_NT_BASE = 0.0f;
	bool NPC_DIE_NT_FIRST_RUN = false;
	float NPC_DIE_NT_NEXT_CHECK = 0.0f;
	bool NPC_DIE_ON_SPAWN_REMOVAL = false;
	bool NPC_DOT_COLD = false;
	float NPC_DOT_COLD_RATIO = 0.0f;
	bool NPC_DOT_FIRE = false;
	float NPC_DOT_FIRE_RATIO = 0.0f;
	bool NPC_DOT_LIGHTNING = false;
	float NPC_DOT_LIGHTNING_RATIO = 0.0f;
	bool NPC_DOT_POISON = false;
	float NPC_DOT_POISON_RATIO = 0.0f;
	float NPC_DO_ON_DIE = 0.0f;
	float NPC_DO_ON_SPOT = 0.0f;
	bool NPC_DO_SPAWN_SOUND = false;
	bool NPC_DUMP_XP = false;
	float NPC_EXP_REDUCT = 0.0f;
	int NPC_FADEIN_RATE = 0;
	bool NPC_FADEIN_SET = false;
	float NPC_FADE_IN_SPEED = 0.0f;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	string NPC_GLOW = "NPC_GLOW";
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	int NPC_NO_AGRO = 0;
	bool NPC_NO_AUTO_ACTIVATE = false;
	bool NPC_NO_COUNT = false;
	bool NPC_NO_DROPS = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_NO_ROAM = false;
	bool NPC_NO_SIEGE_HUNT = false;
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	bool NPC_OVERRIDE_DEATH = false;
	bool NPC_QUED_FOR_DEATH = false;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	bool NPC_SELF_ADJUST = false;
	bool NPC_SELF_ADJUST_NOAVG = false;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_SILENT_DEATH = false;
	bool NPC_SILENT_SUICIDE = false;
	int NPC_SPRITE_IN = 0;
	bool NPC_SUMMON = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseSelfAdjust_DispatchEvent(name, params);
	}
}
