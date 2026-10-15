#pragma context server

// Converted from monsters/base_npc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/externals.as"
#include "converted/monsters/base_self_adjust.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseNpc
{
	// Constants
	float NPC_FREQ_WARN = 5.0f;
	string NPC_DEATH_MSG = "unset";
	bool NPC_AUTO_DEATH = true;
	string SOUND_DEATH = "none";

	// Variables (an unset .script variable reads as its own name)
	bool HAS_INCLUDE_NPC = true;
	bool NPC_FRIENDLY = false;
	bool NPC_FIGHTS_NPCS = false;
	bool IMMUNE_VAMPIRE = false;
	bool EFFECT_DAMAGE_DELAY = false;
	bool IS_BLOODLESS = false;
	bool NPC_DID_DEATH = false;
	bool IN_ICECAGE = false;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_CRIT_WARN_DELAY = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	bool NPC_REACT_CANSEETARGET = false;
	string ANIM_DEATH = "ANIM_DEATH";

	// unnamed block (first think)
	void BaseNpc_FirstThink()
	{
		HAS_INCLUDE_NPC = true;
	}

	// display_timing
	void BaseNpc_OnDisplayTiming(string message = "", string value = "")
	{
		InfoMessage("all", message, value);
	}

	// game_spawn
	void BaseNpc_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetBlood("red"); // Default blood

		OnNpcSpawn(); // give splits second for vars to load
		CallEventDelayed(1.0f, "npc_post_spawn");

		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
		{
			// add christmas hat
			if (RaceOf(ENT_ME) == "human")
				SetModelBody(2, 1);
		}

		string myRace = Eval("game.monster.race");

		// FEB2010_04 - To deal with combative NPC's not cycling up fully
		if (myRace == "human")
			NPC_FRIENDLY = true;
		if (myRace == "hguard")
			NPC_FRIENDLY = true;
		if (myRace == "elf")
			NPC_FRIENDLY = true;
		if (myRace == "dwarf")
			NPC_FRIENDLY = true;
		if (NPC_FRIENDLY)
			NPC_FIGHTS_NPCS = true;
		if (Truthy(GetVar("G_NPC_COMBAT_MAP")))
			NPC_FIGHTS_NPCS = true;

		if (myRace != "undead")
		{
			if (DamageTakenOf(ENT_ME, "holy") != 0.0f && !Truthy(GetVar("IS_UNHOLY")))
				SetDamageTaken("holy", 0);
		}
		else
		{
			// is undead (make this into an event if you need to override - or use npc_post_spawn)
			SetDamageTaken("poison", 0);
			IMMUNE_VAMPIRE = true;
		}

		// can't set holy dmg multiplier here, because they multiply on the other side too, and thus cannot be adjusted individually
		// if ( MY_RACE equals undead )
		// {
		// //dbg temp setting undead attribs
		// takedmg holy 12.0
		// setvard	IMMUNE_POISON 1
		// }
		// if ( MY_RACE equals demon ) takedmg holy 3.0
		EFFECT_DAMAGE_DELAY = false;
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void BaseNpc_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		// dbg Spawned: $get(ent_me,name) [ PARAM1 PARAM2 PARAM3 PARAM4 ]
		if (Truthy(GetVar("NPC_REACTS")))
		{
			// if !HAS_INCLUDE_VENDOR
			OnNpcReactLoop();
		}

		if (Contains(NameOf(ENT_ME), "metal"))
			IS_BLOODLESS = true;
		if (Contains(NameOf(ENT_ME), "iron"))
			IS_BLOODLESS = true;
		if (Contains(NameOf(ENT_ME), "stone"))
			IS_BLOODLESS = true;

		if (IS_BLOODLESS)
		{
			IMMUNE_VAMPIRE = true;
			SetDamageTaken("poison", 0);
		}
	}

	// game_death
	// Death
	void BaseNpc_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NPC_DID_DEATH)
			return;
		NPC_DID_DEATH = true;

		// DEC2010_03 - death tracker
		if (Truthy(GetVar("G_APRIL_FOOLS_MODE")))
			CallExternal(GetVar("GAME_MASTER"), "gm_april_fools_spawn_add", OriginOf(ENT_ME));

		if (NPC_SUMMON)
		{
			LegacyCommand("subtract", "G_NPC_SUMMON_COUNT", 1);
			if (Float(GetVar("G_NPC_SUMMON_COUNT")) < 0.0f) // not sure how this is happening - death getting called twice, or something
				SetGlobal("G_NPC_SUMMON_COUNT", 0);
			DebugPrint("game_death_summoned " + GetVar("G_NPC_SUMMON_COUNT"));
		}

		// from base_monster_shared
		if (!Truthy(GetVar("NPC_NO_END_FLY"))) // Thothie - if it flies, its flying days are over
			SetFly(false);

		if (Truthy(GetVar("GOLD_BAGS")) && !NPC_NO_DROPS)
			OnBmGoldSpew(Int(GetVar("GOLD_PER_BAG")), GetVar("GOLD_BAGS_PPLAYER"), Int(GetVar("GOLD_RADIUS")), Int(GetVar("GOLD_BAGS_PPLAYER")), Int(GetVar("GOLD_MAX_BAGS")));

		if (Float(GetVar("DROPS_CONTAINER")) == 1.0f && !Truthy(GetVar("G_NO_DROP")) && RandomInt(1, 100) <= Float(CONTAINER_DROP_CHANCE))
			CreateNpc(GetVar("CONTAINER_SCRIPT"), RelativePosition(Vector3(0, 0, 0)), "CONTAINER_PARAM1", "CONTAINER_PARAM2", "CONTAINER_PARAM3", "CONTAINER_PARAM4");

		// from monsters/externals
		if (EXT_FADE_ON_DEATH && MyMaxHealth() < 1000.0f)
			CallExternal(GetVar("GAME_MASTER"), "gm_fade", self);

		SetAnimFrameRate(Float(BASE_FRAMERATE));
		SetAnimMoveSpeed(BASE_MOVESPEED);

		if (IN_ICECAGE)
		{
			// if ( $get(SCRIPT_ICECAGE,exists) ) deleteent SCRIPT_ICECAGE
			ClientEvent("update", "all", "SCRIPT_ICECAGE", "end_cage_fx");
			// playsound 0 5 debris/bustglass2.wav
			IN_ICECAGE = false;
		}

		if (NPC_CRITICAL)
		{
			// siege system
			string infoTitle = "A CRITICAL NPC HAS DIED!";
			string infoMsg = NameOf(ENT_ME) + " has been slain! ";
			InfoMessage("all", infoTitle, infoMsg);
			CallExternal(GetVar("GAME_MASTER"), "gm_crit_npc_died", self, @EntityOf(ENT_LASTSTRUCK));
		}

		// if ( IN_ICECAGE ) setanim.framerate OLD_FRAMERATE
		OnNpcDeath();

		// ye old standard base_npc
		if (NPC_AUTO_DEATH)
		{
			// Handle death here, instead of in the individual script
			SetMenuAutoOpen(false); // no more talking to the dead

			if (!Truthy(GetVar("NPC_ALERTED_ALL")) && Truthy(GetVar("HAS_AI")))
				OnNpcatkAlertAllAllies(EntityId(EntityOf(ENT_LASTSTRUCK)));

			if (!NPC_SILENT_DEATH)
			{
				if (GetVar("NPC_ALT_SOUND_DEATH") == "NPC_ALT_SOUND_DEATH")
					PlaySound(0, 5, SOUND_DEATH);
				else
					PlaySound(0, 5, GetVar("NPC_ALT_SOUND_DEATH"));
			}
			PlayAnim("critical", ANIM_DEATH);

			// edit reduce - hopefully handled in game_struck anyways
			// callexternal all npcatk_ally_alert $get(ent_laststruck,id) $get(ent_me,id) "ally_died"
			if (!NPC_GAVE_XP_MSG)
			{
				NPC_GAVE_XP_MSG = true;
				string monFull = Eval("game.monster.name.full");
				string outMsg = "You've slain " + monFull;
				if (NPC_DEATH_MSG != "unset")
					outMsg = NPC_DEATH_MSG;
				PlayerMessageGreen(EntityOf(ENT_LASTSTRUCK), outMsg);
			}
		}

		CallExternal(ENT_ME, "effect_die", "base_npc");

		ClearEffects();
	}

	// game_fake_death
	void BaseNpc_OnGameFakeDeath()
	{
		NPC_DID_DEATH = false;
	}

	// game_struck
	void BaseNpc_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NPC_CRITICAL)
		{
			// warn players if critical NPC struck
			if (!NPC_CRIT_WARN_DELAY)
			{
				NPC_CRIT_WARN_DELAY = true;
				CallEventDelayed(NPC_FREQ_WARN, "npcatk_reset_warn_delay");
				string infoTitle = "Critical NPC Under Attack!";
				string infoMsg = NameOf(ENT_ME) + " is under attack!";
				InfoMessage("all", infoTitle, infoMsg);
			}
		}
	}

	// npcatk_reset_warn_delay
	void BaseNpc_OnNpcatkResetWarnDelay()
	{
		NPC_CRIT_WARN_DELAY = false;
	}

	// npcatk_get_postspawn_properties
	// == End Siege Map System
	// { game_heardtext
	// if G_DEVELOPER_MODE
	// saytext I heard PARAM1
	// }
	// FEB2010_08 Moved from base_monster_shared
	// moved from base_monster_shared JUN2010_06
	// called by base_npc_attack (_new)
	void BaseNpc_OnNpcatkGetPostspawnProperties()
	{
		DebugPrint("npcatk_get_postspawn_properties " + Text(NPC_HP_MULTI));

		EXT_HITCHANCE_ADJUSTMENT = "1";
		EXT_DAMAGE_ADJUSTMENT = "1";
	}

	// npc_react_loop
	void BaseNpc_OnNpcReactLoop()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(1.0f, "npc_react_loop");
		if (Truthy(LegacyFunction("cansee", "NPC_REACT_SEETARGET", "NPC_REACT_SEETARGET_RANGE")))
		{
			// don't scream at the same player repeatedly, annoying
			if (EntityOf(ENT_LASTSEEN) !is NPC_REACT_LAST_TARGET)
			{
				@NPC_REACT_LAST_TARGET = EntityOf(ENT_LASTSEEN);
				NPC_REACT_RESET_TARGET_TIME = GameTime() + 60.0f;
				if (!NPC_REACT_CANSEETARGET)
					OnNpcreactTargetsighted(NPC_REACT_LAST_TARGET);
				NPC_REACT_CANSEETARGET = true;
			}
		}
		else
		{
			if (NPC_REACT_CANSEETARGET)
				OnNpcReactSightlost();
			NPC_REACT_CANSEETARGET = false;
			if (GameTime() > NPC_REACT_RESET_TARGET_TIME)
				@NPC_REACT_LAST_TARGET = null;
		}
	}

	// npc_post_spawn
	void BaseNpc_OnNpcPostSpawn()
	{
		if (AnimIndex(ANIM_DEATH) == 0)
		{
			DebugPrint("WARNING! " + ANIM_DEATH + " does not exist in " + ScriptNameOf(ENT_ME));
			string testAnimDeath = "diesimple";
			if (AnimIndex(testAnimDeath) > -1)
				ANIM_DEATH = testAnimDeath;
			testAnimDeath = "diesforward";
			if (AnimIndex(testAnimDeath) > -1)
				ANIM_DEATH = testAnimDeath;
			testAnimDeath = "die";
			if (AnimIndex(testAnimDeath) > -1)
				ANIM_DEATH = testAnimDeath;
			testAnimDeath = "die_fallback";
			if (AnimIndex(testAnimDeath) > -1)
				ANIM_DEATH = testAnimDeath;
			testAnimDeath = "death";
			if (AnimIndex(testAnimDeath) > -1)
				ANIM_DEATH = testAnimDeath;

			if (Truthy(GetVar("G_DEVELOPER_MODE")))
			{
				if (AnimIndex(ANIM_DEATH) > -1)
				{
					DebugPrint("Substituting with " + ANIM_DEATH);
				}
				else
				{
					// local WARN_MSG "Cannot find "
					// strconc WARN_MSG ANIM_DEATH in $get(ent_me,scriptname)
					// infomsg all "SCRIPT ERROR" WARN_MSG
					DebugPrint("WARNING! COULD NOT FIND ALT DEATH ANIM FOR " + ScriptNameOf(ENT_ME) + " [ " + ANIM_DEATH + " ]");
				}
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn();
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	void OnDisplayTiming(string message = "", string value = "") { BaseNpc_OnDisplayTiming(message, value); } // display_timing
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseNpc_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameFakeDeath() { BaseNpc_OnGameFakeDeath(); } // game_fake_death
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnNpcatkResetWarnDelay() { BaseNpc_OnNpcatkResetWarnDelay(); } // npcatk_reset_warn_delay
	void OnNpcatkGetPostspawnProperties() { BaseNpc_OnNpcatkGetPostspawnProperties(); } // npcatk_get_postspawn_properties
	void OnNpcReactLoop() { BaseNpc_OnNpcReactLoop(); } // npc_react_loop
	void OnNpcFreqWarn() {} // NPC_FREQ_WARN
	void OnBmGoldSpew(int goldPerBag = 0, string bagsPerPlayer = "", int distance = 0, int minBags = 0, int maxBags = 0) {} // bm_gold_spew
	void OnNpcDeath() {} // npc_death
	void OnNpcReactSightlost() {} // npc_react_sightlost
	void OnNpcSpawn(string npc = "") {} // npc_spawn
	void OnNpcatkAlertAllAllies(string attacker = "") {} // npcatk_alert_all_allies
	void OnNpcreactTargetsighted(CBaseEntity@ player = null) {} // npcreact_targetsighted

	// This file's events and timers by their .script names
	bool BaseNpc_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "display_timing") { OnDisplayTiming(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_fake_death") { OnGameFakeDeath(); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_react_loop") { OnNpcReactLoop(); return true; }
		if (name == "npcatk_get_postspawn_properties") { OnNpcatkGetPostspawnProperties(); return true; }
		if (name == "npcatk_reset_warn_delay") { OnNpcatkResetWarnDelay(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_npc"]
shared class BaseNpcScript : MonstersExternalsScript, BaseNpc, BaseSelfAdjust
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseNpc_DispatchEvent(name, params)
			|| BaseSelfAdjust_DispatchEvent(name, params)
			|| MonstersExternalsScript::DispatchEvent(name, params);
	}
}
