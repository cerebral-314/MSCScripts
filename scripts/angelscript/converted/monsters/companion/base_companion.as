#pragma context server

// Converted from monsters/companion/base_companion.script by msc_transpiler.
// Companion.  Follows player through transitions
// Teleports to player when too far away

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseCompanion
{
	// Constants
	bool COMPANION_NEW_TYPE = true;

	// Variables (an unset .script variable reads as its own name)
	bool I_R_COMPANION = true;
	int I_R_PET = 1;
	Vector3 COMPANION_LR = Vector3();
	bool NO_SPAWN_STUCK_CHECK = false;
	string COMPANION_NAME = "COMPANION_NAME";
	string ACT_NAME = "ACT_NAME";
	string NAMEPREFIX = "NAMEPREFIX";
	string SUMMON_MASTER = "SUMMON_MASTER";
	float COMPANION_XP = 0.0f;
	bool CONVERTING_COMPANION = false;
	float PET_LAST_ATTACK = 0.0f;
	float COMPANION_TELE_ANG = 0.0f;
	float BCOMP_LAST_TELEPORT = 0.0f;
	float COMPANION_NEXT_TELE_SOUND = 0.0f;
	string COMPANION_HP = "COMPANION_HP";
	float BCOMP_START_CATCHUP = 0.0f;
	bool NEW_PET = false;
	bool BCOMP_UPDATE_XP = false;
	float COMPANION_NEXT_REGEN = 0.0f;
	bool COMPANION_CONFIRM_DISMISS = false;
	bool IS_HIRED = false;

	// unnamed block (first think)
	void BaseCompanion_FirstThink()
	{
		I_R_COMPANION = true;
		I_R_PET = 1;
		COMPANION_LR = Vec(Text(0));
		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_spawn
	void BaseCompanion_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnPetSpawn();

		COMPANION_NAME = ACT_NAME;
		OnExtCompanionUpdateName();
	}

	// ext_companion_update_name
	void BaseCompanion_OnExtCompanionUpdateName()
	{
		string myName = ItemNameOf(ENT_ME) + "_name";
		myName = GetQuestData(SUMMON_MASTER, myName);
		if (myName != "0")
		{
			string newName = myName;
			COMPANION_NAME = myName;
			newName += " (" + NameOf(SUMMON_MASTER) + "'s" + ")";
			SetName(newName);
		}
		else
		{
			ACT_NAME = NameOf(ENT_ME);
			NAMEPREFIX = NameOf(SUMMON_MASTER) + "'s" + " " + NameOf(ENT_ME);
			SetName(NAMEPREFIX);
		}
	}

	// game_companion_save
	void BaseCompanion_OnGameCompanionSave()
	{
		SetVar("companion.save.health", HealthOf(ENT_ME));
		SetVar("companion.save.xp", COMPANION_XP);
		DebugPrint("game_companion_save " + Text(COMPANION_XP));
	}

	// game_companion_restore
	void BaseCompanion_OnGameCompanionRestore()
	{
		SUMMON_MASTER = EntityId(EntityOf(ENT_OWNER));
		SetHealth(0);
		COMPANION_XP = 0.0f;
		CONVERTING_COMPANION = true;
		DebugPrint("game_companion_restore " + Text(COMPANION_XP));
	}

	// companion_update_hp
	// { game_spawn
	// callevent 1.0 companion_initiate
	// //stepsize 256
	// }
	// { companion_initiate
	// //init XP and other stuff here
	// if ( COMPANION_TYPE isnot 'COMPANION_TYPE' )
	// {
	// if !COMPANION_NEW_TYPE
	// //callexternal ent_owner ext_add_pet COMPANION_TYPE $get(ent_me,id)
	// }
	// callevent companion_update_hp
	// setvard COMPANION_NAME "Your "
	// stradd COMPANION_NAME ACT_NAME
	// }
	void BaseCompanion_OnCompanionUpdateHp()
	{
		if (Text(COMPANION_XP) == "COMPANION_XP")
			COMPANION_XP = 0.0f;
		float finalHp = Float(GetVar("BASE_HP"));
		finalHp += COMPANION_XP;
		if (finalHp > Float(GetVar("COMPANION_MAXHP")))
			finalHp = Float(GetVar("COMPANION_MAXHP"));
		SetHealth(HealthOf(ENT_ME), finalHp);
		DebugPrint("companion_update_hp " + Text(HealthOf(ENT_ME)) + " " + Text(MaxHealthOf(ENT_ME)));
	}

	// game_dodamage
	string BaseCompanion_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		PET_LAST_ATTACK = GameTime() + 10.0f;
		return result;
	}

	// bs_set_follow_mode
	void BaseCompanion_OnBsSetFollowMode()
	{
		OnBasecompanionCatchup(1);
	}

	// basecompanion_catchup
	// <emergency:0|1>
	void BaseCompanion_OnBasecompanionCatchup(int emergency = 0)
	{
		bool exitSub = false;

		if (emergency == 0)
		{
			if (GUARD_MODE)
				exitSub = true;
			if (!IS_HIRED)
				exitSub = true;
			if (NPCATK_TARGET != "unset")
				exitSub = true;
		}
		// if ( EXIT_SUB ) dbg basecompanion_catchup ABORTED GUARD_MODE IS_HIRED $cansee(NPCATK_TARGET) L_PET_LAST_ATTACK vs. game.time
		if (exitSub)
			return;

		Vector3 pos = OriginOf(SUMMON_MASTER);
		if (emergency == 0) // dun wanna teleport into lava if master standing at edge of pit
			pos.z = GroundHeight(pos);

		float telePlus10 = BCOMP_LAST_TELEPORT + 1.0f;
		// if teleport  greater than 1 seconds ago, make dest origin based on master's viewangle
		// otherwise rotate around master
		if (GameTime() > telePlus10)
		{
			COMPANION_LR = ViewAnglesOf(SUMMON_MASTER);
		}
		else
		{
			// setvard COMPANION_TELE_ANG $randf(-16.0,16.0)
			COMPANION_TELE_ANG += 16.0f;
			if (COMPANION_TELE_ANG > 359.0f)
				COMPANION_TELE_ANG -= 359.0f;
		}
		BCOMP_LAST_TELEPORT = GameTime();

		// calc left side of master
		float ang = COMPANION_LR.y + COMPANION_TELE_ANG;
		pos += RelativePosition(Vector3(0, ang, 0), Vector3(-48, 0, 0));
		Vector3 oldPos = OriginOf(ENT_ME);
		SetOrigin(ENT_ME, pos);
		// test new position
		// vectoradd L_POS $relpos($vec(0,90,0),$vec(0,16,0))
		// setsolid PLAYER_FOLLOW none
		SetLocal("reg.npcmove.endpos", pos);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", "z", 16);
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, SUMMON_MASTER);
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			// position failed, go back to where I was
			// dbg failed OLD_POS -> L_POS
			SetOrigin(ENT_ME, oldPos);
		}
		else if (GameTime() > COMPANION_NEXT_TELE_SOUND)
		{
			// sucesess - make notification sound once in awhile
			PlaySound(0, 10, GetVar("SOUND_TELE"));
			COMPANION_NEXT_TELE_SOUND = GameTime() + 2.0f;
		}
	}

	// npcatk_hunt
	// { basecompanion_snap_to_ground
	// if !AM_FLYER
	// //teleport to ground, if nearby
	// local TRACE_START $get(ent_me,origin)
	// vectoradd TRACE_START z 28
	// local TRACE_END TRACE_START
	// vectoradd TRACE_END z -64
	// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
	// dbg snap to ground
	// if TRACE_LINE equals TRACE_END
	// setorigin ent_me TRACE_LINE
	// }
	// Teleport to master if too far away
	void BaseCompanion_OnNpcatkHunt()
	{
		bool exitSub = false;
		// if !COMPANION_EGGED
		// //debugprint $get(ent_owner,dist)
		if (CONVERTING_COMPANION)
		{
			SUMMON_MASTER = EntityId(EntityOf(ENT_OWNER));
			if (!Truthy(ScriptVarOf(SUMMON_MASTER, "PLR_IN_WORLD")))
				exitSub = true;
			if (!exitSub)
			{
				COMPANION_XP = 0.0f;
				COMPANION_HP = "companion.save.health";
				DebugPrint("convert_companion " + NameOf(SUMMON_MASTER) + " " + Text(COMPANION_XP) + " " + COMPANION_HP + " " + ScriptVarOf(SUMMON_MASTER, "PLR_IN_WORLD"));

				string myScript = ItemNameOf(ENT_ME);
				string petList = GetQuestData(SUMMON_MASTER, "pets");
				if (petList == "0")
				{
					string addPet = myScript;
					Quest("set", SUMMON_MASTER, "pets", addPet);
				}
				else
				{
					petList = TokenAdd(petList, myScript);
					Quest("set", SUMMON_MASTER, "pets", petList);
				}

				Quest("set", SUMMON_MASTER, myScript, COMPANION_XP);
				myScript += "_hp";
				Quest("set", SUMMON_MASTER, myScript, COMPANION_HP);

				LegacyCommand("companion", "remove", ENT_ME, ENT_OWNER);
				SetAlive(false);
				CONVERTING_COMPANION = false;
				exitSub = true;
				PlayerMessageYellow(SUMMON_MASTER, "Companion converted to new system");
				DeleteEntity(ENT_ME);
			}
		}
		if (exitSub)
			return;

		if (!(GameTime() > BCOMP_START_CATCHUP))
			return;
		if (!IsAlive(SUMMON_MASTER))
		{
			OnCompanionUnsummon();
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!(DistanceTo(SUMMON_MASTER) > 512.0f))
			return;
		// dbg npcatk_hunt basecompanion_catchup
		OnBasecompanionCatchup();
	}

	// npc_death
	void BaseCompanion_OnNpcDeath()
	{
		if (COMPANION_NEW_TYPE)
			OnNewtypeRemovePet(1);
		if (COMPANION_NEW_TYPE)
			return;
		LegacyCommand("companion", "remove", ENT_ME, ENT_OWNER);
	}

	// bcompanion_regme
	// <owner>
	void BaseCompanion_OnBcompanionRegme(string owner = "")
	{
		if (COMPANION_NEW_TYPE && NEW_PET)
		{
			CallExternal(SUMMON_MASTER, "ext_summon_register_pet", self);
			string myScript = ItemNameOf(ENT_ME);
			string petList = GetQuestData(SUMMON_MASTER, "pets");
			if (petList == "0")
			{
				string addPet = myScript;
				Quest("set", SUMMON_MASTER, "pets", addPet);
			}
			else
			{
				petList = TokenAdd(petList, myScript);
				Quest("set", SUMMON_MASTER, "pets", petList);
			}
			if (COMPANION_XP == 0.0f) {}
			myScript = ItemNameOf(ENT_ME) + "_hp";
			Quest("set", myScript, MaxHealthOf(ENT_ME));
		}

		if (COMPANION_NEW_TYPE)
			return;
		LegacyCommand("companion", "add", ENT_ME, owner);
	}

	// game_dynamically_created
	// { bcompanion_un_regme
	// if !COMPANION_NEW_TYPE
	// companion remove ent_me SUMMON_MASTER
	// }
	// <owner> <first_summon:0|1>
	void BaseCompanion_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (CONVERTING_COMPANION)
			return;

		if (COMPANION_NEW_TYPE)
		{
			BCOMP_START_CATCHUP = GameTime() + 3.0f;
			SUMMON_MASTER = creatorValue1;
			string myScript = ItemNameOf(ENT_ME);
			COMPANION_XP = Float(GetQuestData(SUMMON_MASTER, myScript));
			if (Float(creatorValue2) == 1.0f)
				NEW_PET = true;
			if (!NEW_PET)
			{
				// dbg game_dynamically_created $get(ent_me,hp) / $get(ent_me,maxhp)
				// callevent companion_update_hp
				float finalHp = Float(GetVar("BASE_HP"));
				finalHp += COMPANION_XP;
				if (finalHp > Float(GetVar("COMPANION_MAXHP")))
					finalHp = Float(GetVar("COMPANION_MAXHP"));

				myScript = ItemNameOf(ENT_ME) + "_hp"; // current hp
				COMPANION_HP = GetQuestData(SUMMON_MASTER, myScript);
				SetHealth(Float(COMPANION_HP), finalHp);
				DebugPrint("game_dynamically_created " + Text(HealthOf(ENT_ME)) + " / " + Text(MaxHealthOf(ENT_ME)));
				CallEventDelayed(0.1f, "bcomp_restore_old_hp");
			}
			else
			{
				SetHealth(Float(GetVar("BASE_HP")));
			}
		}

		OnBcompanionRegme(creatorValue1);
	}

	// bcomp_restore_old_hp
	void BaseCompanion_OnBcompRestoreOldHp()
	{
		float finalHp = Float(GetVar("BASE_HP"));
		finalHp += COMPANION_XP;
		if (finalHp > Float(GetVar("COMPANION_MAXHP")))
			finalHp = Float(GetVar("COMPANION_MAXHP"));

		string myScript = ItemNameOf(ENT_ME) + "_hp"; // current hp
		COMPANION_HP = GetQuestData(SUMMON_MASTER, myScript);
		if (Float(COMPANION_HP) == 0.0f)
			COMPANION_HP = Text(finalHp);
		SetHealth(Float(COMPANION_HP), finalHp);
		DebugPrint("bcomp_restore_old_hp " + Text(HealthOf(ENT_ME)) + " " + Text(MaxHealthOf(ENT_ME)));
	}

	// game_damaged_other
	string BaseCompanion_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		int targValue = Int(GetProp(target, "skilllevel"));

		if (!(targValue > 0))
			return result;

		// target's XP value must be > 10% of my own XP
		float minValue = COMPANION_XP * 0.1f; // $get(PARAM1,skilllevel)

		// dbg game_damaged_other TARG_VALUE vs MIN_VALUE
		if (!(targValue > minValue))
			return result;

		float inDmg = damage * 0.01f;
		COMPANION_XP += inDmg;
		BCOMP_UPDATE_XP = true;
		return result;
	}

	// unnamed block (timer)
	void BaseCompanion_Timer()
	{
		CallEventDelayed(5.0f, "BaseCompanion_Timer");
		if (!IsAlive(ENT_ME))
			return;
		if (!COMPANION_NEW_TYPE)
			return;
		if (!BCOMP_UPDATE_XP)
			return;
		string myScript = ItemNameOf(ENT_ME);
		Quest("set", SUMMON_MASTER, myScript, COMPANION_XP);
		myScript += "_hp";
		DebugPrint("update_hp " + myScript + " " + Text(HealthOf(ENT_ME)));
		Quest("set", SUMMON_MASTER, myScript, HealthOf(ENT_ME)); // current health
		BCOMP_UPDATE_XP = false;
	}

	// ext_unreg_pets
	void BaseCompanion_OnExtUnregPets(string owner = "")
	{
		if (owner != SUMMON_MASTER)
			return;
		OnBcompanionUnRegme();
	}

	// game_damaged
	string BaseCompanion_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		BCOMP_UPDATE_XP = true;

		if (!IsPlayer(attacker))
		{
			if (RangeTo(SUMMON_MASTER) > 512.0f)
				PlayerMessage(SUMMON_MASTER, COMPANION_NAME + " is under attack!");

			float quartHealth = MaxHealthOf(ENT_ME) * 0.25f;
			if (HealthOf(ENT_ME) < quartHealth)
				PlayerMessage(SUMMON_MASTER, COMPANION_NAME + " is low on health! ( " + int(HealthOf(ENT_ME)) + " hp )");

			COMPANION_NEXT_REGEN = GameTime() + 30.0f;
		}

		if (NEW_AI)
			return result;

		if (!IsPlayer(attacker))
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// my_target_died
	void BaseCompanion_OnMyTargetDied(string offender = "")
	{
		OnCompanionUpdateHp();
	}

	// ext_givexp
	void BaseCompanion_OnExtGivexp(float xpAmount = 0.0f)
	{
		COMPANION_XP += xpAmount;
		BCOMP_UPDATE_XP = true;
	}

	// companion_abandon
	void BaseCompanion_OnCompanionAbandon(CBasePlayer@ value = null, string source = "")
	{
		// offer SUMMON_MASTER item_charm_w1_full
		// deleteent ent_me fade
		// callevent bcompanion_un_regme
		if (source != "from_menu")
			return;
		COMPANION_CONFIRM_DISMISS = true;
		CallEventDelayed(0.5f, "companion_give_menu");
	}

	// companion_give_menu
	void BaseCompanion_OnCompanionGiveMenu()
	{
		OpenMenu(SUMMON_MASTER);
	}

	// game_menu_cancel
	void BaseCompanion_OnGameMenuCancel(CBasePlayer@ player = null)
	{
		COMPANION_CONFIRM_DISMISS = false;
	}

	// companion_release_cancel
	void BaseCompanion_OnCompanionReleaseCancel()
	{
		COMPANION_CONFIRM_DISMISS = false;
	}

	// companion_release
	void BaseCompanion_OnCompanionRelease()
	{
		HelpTip(SUMMON_MASTER, "generic", "PET DISMISSED", "This pet will continue to remain with you until map change or death.");
		PlayerMessage(SUMMON_MASTER, "Pet dismissed...");
		// callexternal ent_owner ext_remove_pet COMPANION_TYPE
		OnBsSetDefendMode();
		IS_HIRED = false;
		CallEventDelayed(0.1f, "bcompanion_un_regme");
		if (!COMPANION_NEW_TYPE)
			return;
		OnNewtypeRemovePet();
	}

	// companion_unsummon
	void BaseCompanion_OnCompanionUnsummon(CBasePlayer@ reason = null, string value = "", string flag = "")
	{
		if (!IS_HIRED)
			return;
		if (EntityId(reason) == "trigger_hurt")
		{
			PlaySound(0, 10, SOUND_PAIN);
			HelpTip(SUMMON_MASTER, "generic", "PET UNSUMMONED DUE TO HAZARD", "You can re-summon your pet by using Summon Pet on the player menu [default: F11]");
		}
		else
		{
			HelpTip(SUMMON_MASTER, "generic", "PET UNSUMMONED", "You can re-summon your pet by using Summon Pet on the player menu [default: F11]");
		}
		// callexternal ent_owner player_unsummon_pets
		if (!COMPANION_NEW_TYPE)
			return;
		string myScript = ItemNameOf(ENT_ME);
		Quest("set", SUMMON_MASTER, myScript, COMPANION_XP);
		myScript += "_hp";
		DebugPrint("update_hp " + myScript + " " + Text(HealthOf(ENT_ME)));
		Quest("set", SUMMON_MASTER, myScript, HealthOf(ENT_ME)); // current health
		BCOMP_UPDATE_XP = false;
		if (!Truthy(flag))
			CallExternal(SUMMON_MASTER, "ext_unsummon_pets_new", SUMMON_MASTER, self, 1);
		SetAlive(false);
		DeleteEntity(ENT_ME, "fade");
	}

	// newtype_remove_pet
	// <died:0|1>
	void BaseCompanion_OnNewtypeRemovePet(int died = 0)
	{
		string petList = GetQuestData(SUMMON_MASTER, "pets");
		string myScript = ItemNameOf(ENT_ME);
		int petIdx = FindToken(petList, myScript);
		petList = TokenRemove(petList, petIdx);
		DebugPrint("newtype_remove_pet " + petList);
		Quest("set", SUMMON_MASTER, "pets", petList);
		Quest("set", SUMMON_MASTER, myScript, 0);
		if (died == 0)
			return;
		CallExternal(SUMMON_MASTER, "ext_unsummon_pets_new", SUMMON_MASTER, self);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseCompanion_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnExtCompanionUpdateName() { BaseCompanion_OnExtCompanionUpdateName(); } // ext_companion_update_name
	void OnGameCompanionSave() { BaseCompanion_OnGameCompanionSave(); } // game_companion_save
	void OnGameCompanionRestore() { BaseCompanion_OnGameCompanionRestore(); } // game_companion_restore
	void OnCompanionUpdateHp() { BaseCompanion_OnCompanionUpdateHp(); } // companion_update_hp
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BaseCompanion_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnBsSetFollowMode() { BaseCompanion_OnBsSetFollowMode(); } // bs_set_follow_mode
	void OnBasecompanionCatchup(int emergency = 0) { BaseCompanion_OnBasecompanionCatchup(emergency); } // basecompanion_catchup
	void OnNpcatkHunt() { BaseCompanion_OnNpcatkHunt(); } // npcatk_hunt
	void OnNpcDeath() { BaseCompanion_OnNpcDeath(); } // npc_death
	void OnBcompanionRegme(string owner = "") { BaseCompanion_OnBcompanionRegme(owner); } // bcompanion_regme
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { BaseCompanion_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnBcompRestoreOldHp() { BaseCompanion_OnBcompRestoreOldHp(); } // bcomp_restore_old_hp
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return BaseCompanion_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other
	void OnExtUnregPets(string owner = "") { BaseCompanion_OnExtUnregPets(owner); } // ext_unreg_pets
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return BaseCompanion_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnMyTargetDied(string offender = "") { BaseCompanion_OnMyTargetDied(offender); } // my_target_died
	void OnExtGivexp(float xpAmount = 0.0f) { BaseCompanion_OnExtGivexp(xpAmount); } // ext_givexp
	void OnCompanionAbandon(CBasePlayer@ value = null, string source = "") { BaseCompanion_OnCompanionAbandon(value, source); } // companion_abandon
	void OnCompanionGiveMenu() { BaseCompanion_OnCompanionGiveMenu(); } // companion_give_menu
	void OnGameMenuCancel(CBasePlayer@ player = null) { BaseCompanion_OnGameMenuCancel(player); } // game_menu_cancel
	void OnCompanionReleaseCancel() { BaseCompanion_OnCompanionReleaseCancel(); } // companion_release_cancel
	void OnCompanionRelease() { BaseCompanion_OnCompanionRelease(); } // companion_release
	void OnCompanionUnsummon(CBasePlayer@ reason = null, string value = "", string flag = "") { BaseCompanion_OnCompanionUnsummon(reason, value, flag); } // companion_unsummon
	void OnNewtypeRemovePet(int died = 0) { BaseCompanion_OnNewtypeRemovePet(died); } // newtype_remove_pet
	void OnBcompanionUnRegme() {} // bcompanion_un_regme
	void OnBsSetDefendMode() {} // bs_set_defend_mode
	void OnPetSpawn() {} // pet_spawn

	// This file's events and timers by their .script names
	bool BaseCompanion_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basecompanion_catchup") { OnBasecompanionCatchup(Int(Param(params, 0))); return true; }
		if (name == "bcomp_restore_old_hp") { OnBcompRestoreOldHp(); return true; }
		if (name == "bcompanion_regme") { OnBcompanionRegme(Param(params, 0)); return true; }
		if (name == "bs_set_follow_mode") { OnBsSetFollowMode(); return true; }
		if (name == "companion_abandon") { OnCompanionAbandon(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "companion_give_menu") { OnCompanionGiveMenu(); return true; }
		if (name == "companion_release") { OnCompanionRelease(); return true; }
		if (name == "companion_release_cancel") { OnCompanionReleaseCancel(); return true; }
		if (name == "companion_unsummon") { OnCompanionUnsummon(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "companion_update_hp") { OnCompanionUpdateHp(); return true; }
		if (name == "ext_companion_update_name") { OnExtCompanionUpdateName(); return true; }
		if (name == "ext_givexp") { OnExtGivexp(Float(Param(params, 0))); return true; }
		if (name == "ext_unreg_pets") { OnExtUnregPets(Param(params, 0)); return true; }
		if (name == "game_companion_restore") { OnGameCompanionRestore(); return true; }
		if (name == "game_companion_save") { OnGameCompanionSave(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "newtype_remove_pet") { OnNewtypeRemovePet(Int(Param(params, 0))); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "BaseCompanion_Timer") { BaseCompanion_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/companion/base_companion"]
shared class BaseCompanionScript : ScriptEntity, BaseCompanion
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	bool ALLY_RESPONSE_DELAY = false;
	bool AM_FLANKING = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_RUN_BASE = "ANIM_RUN_BASE";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_WALK_BASE = "ANIM_WALK_BASE";
	float AS_ATTACKING = 0.0f;
	bool AS_CAN_MOVE = false;
	int AS_CRITICAL_THRESH = 0;
	int AS_DIST_THRESH = 0;
	bool AS_FIRST_STUCK = false;
	Vector3 AS_FLEE_POINT = Vector3();
	float AS_HITBACK_FRUST = 0.0f;
	float AS_HITBACK_FRUST_RUNS = 0.0f;
	float AS_IN_RANGE_CLICKS = 0.0f;
	float AS_LAST_HIT = 0.0f;
	Vector3 AS_LAST_ORIGIN = Vector3();
	string AS_LAST_POS = "AS_LAST_POS";
	bool AS_LAST_POS_SET = false;
	float AS_LAST_STRIKE = 0.0f;
	float AS_MAX_ATTACK_TIME = 0.0f;
	float AS_MISS_COUNT = 0.0f;
	string AS_MOVEPROX = "AS_MOVEPROX";
	float AS_NEXT_CHECK = 0.0f;
	Vector3 AS_SPAWN_POINT = Vector3();
	bool AS_STARTED = false;
	float AS_STUCK_FREQ = 0.0f;
	bool AS_TELE_OUT = false;
	Vector3 AS_TELE_POINT = Vector3();
	int AS_TELE_THRESH = 0;
	float AS_UNSTUCK_ANG = 0.0f;
	float AS_WIGGLE_DURATION = 0.0f;
	int ATTACK_ANIMINDEX = 0;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	bool BAST_DID_INIT = false;
	bool BAST_FIRST_TEST = false;
	float BAST_FWD = 0.0f;
	float BAST_MOB_HEIGHT_ADJ = 0.0f;
	string BAST_PLAYER_LIST = "BAST_PLAYER_LIST";
	float BAST_ROT = 0.0f;
	bool BAST_SPAWNCHECK = false;
	Vector3 BAST_SPAWN_POS = Vector3();
	bool BAST_STUCK_DID_INIT = false;
	bool BAST_TELEPORTING = false;
	string BAST_TEST_PLAYER = "BAST_TEST_PLAYER";
	float BAST_VFLOAT = 0.0f;
	float BMS_RENDERAMT = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CHASE_RANGE = "CHASE_RANGE";
	bool CHICKEN_RUN = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool CYCLED_UP = false;
	string CYCLE_TIME = "CYCLE_TIME";
	float CYCLE_TIME_BATTLE = 0.0f;
	float CYCLE_TIME_IDLE = 0.0f;
	float CYCLE_TIME_NPC = 0.0f;
	bool DEFEND_MODE = false;
	int DEFEND_RANGE = 0;
	int DEF_STEP_SIZE = 0;
	bool DEMON_BLOOD = false;
	bool DID_HELP_TIP = false;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	bool EFFECT_DAMAGE_DELAY = false;
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	string ENTITY_ENEMY = "ENTITY_ENEMY";
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	float FD_LOOP_COUNT = 0.0f;
	string FD_MAX_RANGE = "FD_MAX_RANGE";
	Vector3 FLEESTUCK_OLDPOS = Vector3();
	int FLEE_DIR = 0;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float FLEE_STUCKCHECK_FREQ = 0.0f;
	int FLEE_STUCK_COUNT = 0;
	string FLEE_TARGET = "FLEE_TARGET";
	float FLEE_TIME = 0.0f;
	bool FLINCHED_RECENTLY = false;
	string FLINCH_ANIM = "FLINCH_ANIM";
	float FLINCH_DAMAGE_THRESHOLD = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_DMG_REQ = 0.0f;
	float FLINCH_HEALTH = 0.0f;
	bool FOLLOW_MASTER = false;
	bool FREEZE_WAS_SUSPEND = false;
	bool GUARD_MODE = false;
	Vector3 GUARD_POS = Vector3();
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	float HACK_ATTACK_DELAY = 0.0f;
	float HACK_DAMAGE_DELAY = 0.0f;
	bool HACK_DELAYING_ATTACK = false;
	bool HAS_AI = false;
	bool HAS_INCLUDE_NPC = false;
	bool HAVE_TARGET = false;
	bool HEARD_PLAYER = false;
	bool HEARD_VERIFY = false;
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	bool HIT_BY_MANABALL = false;
	int HOVER_CLOSE = 0;
	int HOVER_DISTANCE = 0;
	int HOVER_FAR = 0;
	bool HUNTING_PLAYER = false;
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	bool IGNORE_TARGETS = false;
	bool IMMUNE_VAMPIRE = false;
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool IS_FLEEING = false;
	bool IS_HUNTING = false;
	CBaseEntity@ I_HEARD = null;
	bool I_R_FROZEN = false;
	bool KILL_MODE = false;
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MAKE_NOISE = 0.0f;
	float MAX_ADV_SEARCHTIME = 0.0f;
	string ME_STREGTH = "ME_STREGTH";
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_ID = 0;
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	bool NEW_AI = false;
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	float NEXT_HITFRUST_RECORD = 0.0f;
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "NPC_ADJ_DMG_MUTLI_TOKENS";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	string NPC_ADJ_HP_MUTLI_TOKENS = "NPC_ADJ_HP_MUTLI_TOKENS";
	float NPC_ADJ_LEVEL = 0.0f;
	string NPC_ADJ_TIERS = "NPC_ADJ_TIERS";
	bool NPC_ALERTED_ALL = false;
	string NPC_ALERT_LIST = "NPC_ALERT_LIST";
	string NPC_ALERT_OF = "NPC_ALERT_OF";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	CBaseEntity@ NPC_ALLY_TO_AID = null;
	float NPC_ALL_XP_ADJ = 0.0f;
	bool NPC_ATTACK_MISS = false;
	string NPC_ATTACK_TARGET = "NPC_ATTACK_TARGET";
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	float NPC_BOSS_REGEN_FREQ = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.0f;
	float NPC_BOSS_RESTORATION = 0.0f;
	bool NPC_CANSEE_TARGET = false;
	string NPC_CANT_PARRY_TYPES = "NPC_CANT_PARRY_TYPES";
	int NPC_CHASE_RANGE = 0;
	float NPC_CLOSEIN_RANGE = 0.0f;
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_COULD_SEE_TARGET = false;
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	float NPC_DBL_MOVEPROX = 0.0f;
	string NPC_DEATH_MSG = "NPC_DEATH_MSG";
	float NPC_DELAY_RETALITATE = 0.0f;
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool NPC_DID_DEATH = false;
	bool NPC_DID_STEP_ADJ = false;
	float NPC_DIE_NT_BASE = 0.0f;
	bool NPC_DIE_NT_FIRST_RUN = false;
	float NPC_DIE_NT_NEXT_CHECK = 0.0f;
	bool NPC_DIE_ON_SPAWN_REMOVAL = false;
	float NPC_DMG_MULTI = 0.0f;
	bool NPC_DOT_COLD = false;
	float NPC_DOT_COLD_RATIO = 0.0f;
	bool NPC_DOT_FIRE = false;
	float NPC_DOT_FIRE_RATIO = 0.0f;
	bool NPC_DOT_LIGHTNING = false;
	float NPC_DOT_LIGHTNING_RATIO = 0.0f;
	bool NPC_DOT_POISON = false;
	float NPC_DOT_POISON_RATIO = 0.0f;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	float NPC_DO_ON_DIE = 0.0f;
	float NPC_DO_ON_SPOT = 0.0f;
	bool NPC_DO_SPAWN_SOUND = false;
	bool NPC_DUMP_XP = false;
	float NPC_EVENT_COUNTER = 0.0f;
	float NPC_EXP_FINAL = 0.0f;
	float NPC_EXP_REDUCT = 0.0f;
	int NPC_FADEIN_RATE = 0;
	bool NPC_FADEIN_SET = false;
	float NPC_FADE_IN_SPEED = 0.0f;
	bool NPC_FIGHTS_NPCS = false;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	int NPC_FRUST_THRESHOLD = 0;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	bool NPC_GOING_HOME = false;
	float NPC_HALF_HEIGHT = 0.0f;
	float NPC_HALF_WIDTH = 0.0f;
	bool NPC_HAS_TARGET = false;
	float NPC_HEIGHT = 0.0f;
	bool NPC_HOMER_FIRST_CALL = false;
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_HUNTING_BLIND = false;
	bool NPC_IGNORE_PLAYERS = false;
	bool NPC_INALLY = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	Vector3 NPC_LAST_ORIGIN = Vector3();
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	string NPC_LOST_TARGET = "NPC_LOST_TARGET";
	bool NPC_MADE_IT_HOME = false;
	float NPC_MAXHP = 0.0f;
	float NPC_MAX_RANGE = 0.0f;
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool NPC_MOVEMENT_SUSPENDED = false;
	string NPC_MOVEPROX = "NPC_MOVEPROX";
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NPC_NEVER_RESUME = false;
	bool NPC_NEVER_RESUME_AI = false;
	float NPC_NEXT_RETALITATE = 0.0f;
	float NPC_NEXT_RHOME_WIGGLE = 0.0f;
	int NPC_NO_AGRO = 0;
	bool NPC_NO_ATTACK = false;
	bool NPC_NO_AUTO_ACTIVATE = false;
	bool NPC_NO_COUNT = false;
	bool NPC_NO_DROPS = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_NO_ROAM = false;
	bool NPC_NO_SIEGE_HUNT = false;
	string NPC_OLD_ANIM_IDLE = "NPC_OLD_ANIM_IDLE";
	string NPC_OLD_ANIM_RUN = "NPC_OLD_ANIM_RUN";
	string NPC_OLD_ANIM_WALK = "NPC_OLD_ANIM_WALK";
	string NPC_OLD_ROAM = "NPC_OLD_ROAM";
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	bool NPC_OVERRIDE_DEATH = false;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	CBasePlayer@ NPC_PROXACT_SCANID = null;
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROX_LOOP = false;
	bool NPC_QUED_FOR_DEATH = false;
	string NPC_RANGED = "NPC_RANGED";
	string NPC_RANGE_TYPE = "NPC_RANGE_TYPE";
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_RETALIATING = false;
	bool NPC_RETURNING_HOME = false;
	bool NPC_ROAMING_HOME = false;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	bool NPC_SELF_ADJUST = false;
	bool NPC_SELF_ADJUST_NOAVG = false;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_SILENT_DEATH = false;
	bool NPC_SILENT_SUICIDE = false;
	Vector3 NPC_SPAWN_ANGLES = Vector3();
	Vector3 NPC_SPAWN_LOC = Vector3();
	float NPC_SPAWN_PRED1 = 0.0f;
	float NPC_SPAWN_PRED2 = 0.0f;
	float NPC_SPAWN_TIME = 0.0f;
	int NPC_SPRITE_IN = 0;
	string NPC_STOREHUNTSTATE_ADVANCED = "NPC_STOREHUNTSTATE_ADVANCED";
	string NPC_STOREHUNTSTATE_MLK = "NPC_STOREHUNTSTATE_MLK";
	float NPC_STORE_HP = 0.0f;
	string NPC_STORE_LOST_TARGET = "NPC_STORE_LOST_TARGET";
	string NPC_STORE_TARGET = "NPC_STORE_TARGET";
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_VADJSTING = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	int NPC_WANDER_RANGE = 0;
	bool NPC_WAS_IN_BATTLE = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	int OLD_NO_STUCK_CHECKS = 0;
	float ORIG_MOVERANGE = 0.0f;
	string OWNER_TARGET = "OWNER_TARGET";
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool RE_FLEE_DELAY = false;
	bool SEARCH_ROTATION = false;
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_PAIN = "SOUND_PAIN";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	bool STUCK_CHECKING = false;
	float STUCK_COUNT = 0.0f;
	int SUMMON_CIRCLE_INDEX = 0;
	string SUMMON_LAST_TARG = "SUMMON_LAST_TARG";
	float SUMMON_LAST_TARG_NOTICE = 0.0f;
	int SUMMON_RUN_DIST = 0;
	int SUMMON_VICINITY = 0;
	string SUM_REPORT_SUFFIX = "SUM_REPORT_SUFFIX";
	string SUM_SAY_ATTACK = "SUM_SAY_ATTACK";
	string SUM_SAY_COME = "SUM_SAY_COME";
	string SUM_SAY_DEATH = "SUM_SAY_DEATH";
	string SUM_SAY_DEFEND = "SUM_SAY_DEFEND";
	string SUM_SAY_GUARD = "SUM_SAY_GUARD";
	string SUM_SAY_HUNT = "SUM_SAY_HUNT";
	bool SUSPEND_AI = false;
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(5.0f, "BaseCompanion_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseCompanion_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseCompanion_DispatchEvent(name, params);
	}
}
