#pragma context server

// Converted from developer/devcmds.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Devcmds
{

	// game_playercmd
	void Devcmds_OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "")
	{
		if (command == "dev_on")
		{
			if (argument == "wargwable")
			{
				ConsoleMessage(ENT_CURRENTPLAYER, "Developer Mode ON");
				InfoMessage("all", "DEVELOPER MODE", "Developer mode is on.");
				SetGlobal("G_DEVELOPER_MODE", 1);
			}
		}
		else if (command == "dev_off" && Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "Developer Mode OFF");
			InfoMessage("all", "DEVELOPER MODE", "Developer mode is off.");
			SetGlobal("G_DEVELOPER_MODE", 0);
		}
	}

	// dev_command
	// <eventname> [params]
	void Devcmds_OnDevCommand(string eventName = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		if (Truthy(Eval("game.central"))) // This script is not included in the release pack, but here anyways...
			return;
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;

		CallEventOrDelay(eventName, value, value2, value3, value4, value5, value6, value7);
	}

	// mp3
	// <target|all> <mode:stop|combat|system> <file> - plays music on target or players within, path is assumed to be in music directory
	void Devcmds_OnMp3(string target = "", string mode = "", string file = "")
	{
		PlayMusic(target, mode, file);
	}

	// tele
	// <x> <y> <z> - Teleport to a particular destination
	void Devcmds_OnTele(string destX = "", string destY = "", string destZ = "")
	{
		string str = "Teleportion to:" + destX + destY + destZ;
		ConsoleMessage(ENT_CURRENTPLAYER, str);
		SetOrigin(ENT_CURRENTPLAYER, Vector3(Float(destX), Float(destY), Float(destZ)));
	}

	// teledest
	// <unique_name> - Teleports to an entity with that name. Teleports to map objects too
	void Devcmds_OnTeledest(string uniqueName = "")
	{
		CBaseEntity@ ent = FindEntity(LegacyFunction("get_by_name", uniqueName, "id"));
		if (Exists(ent))
			SetOrigin(ENT_CURRENTPLAYER, OriginOf(ent));
	}

	// slayall
	// <0|1> - Slays all monsters, or only "evil" monsters
	void Devcmds_OnSlayall(string evilOnly = "")
	{
		if (Truthy(evilOnly))
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "Slaying Bad Guys");
			CallExternal("all", "npc_suicide", "only_bad");
		}
		else
		{
			ConsoleMessage(ENT_CURRENTPLAYER, "Slaying all");
			CallExternal("all", "npc_suicide");
		}
	}

	// usetrig
	// <trigger> - Fires a particular trigger
	void Devcmds_OnUsetrig(string trigger = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Fire map event: " + trigger);
		UseTrigger(trigger);
	}

	// dumpquest
	// <quest> - Shows what information is stored on a particular quest
	void Devcmds_OnDumpquest(string questName = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Quest " + questName + " is: " + GetQuestData(ENT_CURRENTPLAYER, questName));
	}

	// newnpc
	// <scriptname> [params] - Creates a given npc
	void Devcmds_OnNewnpc(string scriptname = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		ConsoleMessage("Got command newnpc");

		Vector3 spawnPoint = OriginOf(ENT_CURRENTPLAYER);
		Vector3 myAngles = AnglesOf(ENT_CURRENTPLAYER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 128, 0));

		CreateNpc(scriptname, spawnPoint, value, value2, value3, value4, value5, value6, value7);
	}

	// newdyn
	// <idx> [params] - Creates an npc from the given index from ms_dynamicnpc
	void Devcmds_OnNewdyn(string npcIndex = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Got command newdyn");

		string idxText = npcIndex;
		int idx = Int(idxText);
		if (idxText.isEmpty())
			idx = 0;
		string script = GetToken(Eval("game.cvar.ms_dynamicnpc"), idx);

		OnNewnpc(script, value, value2, value3, value4, value5, value6, value7);
	}

	// newitem
	// <item_scriptname> [params] - Creates a given item with given parameters.
	void Devcmds_OnNewitem(string itemScriptname = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Got command newitem");

		Vector3 spawnPoint = OriginOf(ENT_CURRENTPLAYER);
		Vector3 myAngles = AnglesOf(ENT_CURRENTPLAYER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));

		CreateItem(itemScriptname, spawnPoint, value, value2, value3, value4, value5, value6, value7);
	}

	// eventtarg
	// <script_event> [params] - Runs a script event on the player's current target
	void Devcmds_OnEventtarg(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		CallExternal(TargetOf(ENT_CURRENTPLAYER), scriptEvent, value, value2, value3, value4, value5, value6, value7);
	}

	// eventme
	// <script_event> [params] - Runs a script event on the player
	void Devcmds_OnEventme(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		CallExternal(ENT_CURRENTPLAYER, scriptEvent, value, value2, value3, value4, value5, value6, value7);
	}

	// eventplayers
	// <script_event> [params] - Runs a script event on all players
	void Devcmds_OnEventplayers(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		CallExternal("players", scriptEvent, value, value2, value3, value4, value5, value6, value7);
	}

	// eventgm
	// <script_event> [params] - Runs a script event on the game master
	void Devcmds_OnEventgm(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		CallExternal(GetVar("GAME_MASTER"), scriptEvent, value, value2, value3, value4, value5, value6, value7);
	}

	// eventall
	// <script_event> [params] - Runs a script event on all scripted entities
	void Devcmds_OnEventall(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "")
	{
		CallExternal("all", scriptEvent, value, value2, value3, value4, value5, value6, value7);
	}

	// blamb
	// [radius] [damage] [type] - Damages enemies near the player
	void Devcmds_OnBlamb(string blastRadius = "", string damage = "", string damageType = "")
	{
		string radius = "300";
		string dmg = "300";
		string type = "dark_effect";

		if (!blastRadius.isEmpty())
			radius = blastRadius;
		if (!damage.isEmpty())
			dmg = damage;
		if (!damageType.isEmpty())
			type = damageType;

		ConsoleMessage(ENT_CURRENTPLAYER, "Blamb! AOE: " + radius + " DMG: " + dmg + " Type: " + type);

		// XDODAMAGE <target|(origin)> <range|aoe|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(OriginOf(ENT_CURRENTPLAYER), radius, dmg, 0, @EntityOf(ENT_CURRENTPLAYER), @EntityOf(ENT_CURRENTPLAYER), "none", type, "none");
	}

	// setquest
	// <quest> <value> - Sets a given quest to a given value
	void Devcmds_OnSetquest(string questName = "", string value = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Setting Quest: " + questName + " to " + value);

		Quest("set", EntityOf(ENT_CURRENTPLAYER), questName, value);
	}

	// getquest
	// <quest>
	void Devcmds_OnGetquest(string quest = "")
	{
		string questData = GetQuestData(ENT_CURRENTPLAYER, quest);

		ConsoleMessage(ENT_CURRENTPLAYER, questData);
	}

	// setgold
	// <amt> - Sets gold to a given amount
	void Devcmds_OnSetgold(int amount = 0)
	{
		CallExternal(ENT_CURRENTPLAYER, "ext_setgold", Text(amount));
	}

	// addhp
	// <amt> - Add the given hp to the player
	void Devcmds_OnAddhp(string hpAmount = "")
	{
		CallExternal(ENT_CURRENTPLAYER, "give_hp", hpAmount);
	}

	// addmp
	// <amt> - Add the given mp to the player
	void Devcmds_OnAddmp(string mpAmount = "")
	{
		CallExternal(ENT_CURRENTPLAYER, "give_mp", mpAmount);
	}

	// rat
	void Devcmds_OnRat()
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Spawning Rat");
		Vector3 spawnPoint = OriginOf(ENT_CURRENTPLAYER);
		Vector3 myAngles = AnglesOf(ENT_CURRENTPLAYER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 128, 0));

		CreateNpc("monsters/giantrat", spawnPoint);
	}

	// skele
	void Devcmds_OnSkele()
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Spawning skele");
		Vector3 spawnPoint = OriginOf(ENT_CURRENTPLAYER);
		Vector3 myAngles = AnglesOf(ENT_CURRENTPLAYER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 128, 0));

		CreateNpc("monsters/skeleton", spawnPoint);
	}

	// teleforward
	void Devcmds_OnTeleforward(string forwardDistance = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Teleporting Forward " + forwardDistance + " units");

		Vector3 myPos = OriginOf(ENT_CURRENTPLAYER);
		Vector3 myAng = ViewAnglesOf(ENT_CURRENTPLAYER);
		myPos += RelativePosition(myAng, Vector3(0, Float(forwardDistance), 0));
		SetOrigin(ENT_CURRENTPLAYER, myPos);
	}

	// effectme
	void Devcmds_OnEffectme(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Applying effect, " + effectScript + " to self.");
		ApplyEffect(ENT_CURRENTPLAYER, effectScript, duration, owner, value, skill, value2);
	}

	// effectmestack
	void Devcmds_OnEffectmestack(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Applying stacking effect, " + effectScript + " to self.");
		ApplyEffect(ENT_CURRENTPLAYER, effectScript, duration, owner, value, skill, value2);
	}

	// effecttarg
	void Devcmds_OnEffecttarg(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Applying effect, " + effectScript + " to target, " + NameOf(TargetOf(ENT_CURRENTPLAYER)));
		ApplyEffect(TargetOf(ENT_CURRENTPLAYER), effectScript, duration, owner, value, skill, value2);
	}

	// effecttargstack
	void Devcmds_OnEffecttargstack(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Applying effect, " + effectScript + " to target, " + NameOf(TargetOf(ENT_CURRENTPLAYER)));
		ApplyEffect(TargetOf(ENT_CURRENTPLAYER), effectScript, duration, owner, value, skill, value2);
	}

	// testdmg
	void Devcmds_OnTestdmg(string damageType = "")
	{
		ConsoleMessage(ENT_CURRENTPLAYER, "Damage mult for " + damageType + " is " + Text(DamageTakenOf(ENT_CURRENTPLAYER, damageType)));
	}

	// throw
	void Devcmds_OnThrow()
	{
		CallExternal(ENT_CURRENTPLAYER, "ext_tossprojectile", "proj_fire_ball", "view", "none", 6000, 10, 0, "none");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePlayercmd(string command = "", string argument = "", string argument2 = "", string voteOption = "", string voteOption2 = "", string voteOption3 = "", string voteOption4 = "", string value = "", string value2 = "") { Devcmds_OnGamePlayercmd(command, argument, argument2, voteOption, voteOption2, voteOption3, voteOption4, value, value2); } // game_playercmd
	void OnDevCommand(string eventName = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnDevCommand(eventName, value, value2, value3, value4, value5, value6, value7); } // dev_command
	void OnMp3(string target = "", string mode = "", string file = "") { Devcmds_OnMp3(target, mode, file); } // mp3
	void OnTele(string destX = "", string destY = "", string destZ = "") { Devcmds_OnTele(destX, destY, destZ); } // tele
	void OnTeledest(string uniqueName = "") { Devcmds_OnTeledest(uniqueName); } // teledest
	void OnSlayall(string evilOnly = "") { Devcmds_OnSlayall(evilOnly); } // slayall
	void OnUsetrig(string trigger = "") { Devcmds_OnUsetrig(trigger); } // usetrig
	void OnDumpquest(string questName = "") { Devcmds_OnDumpquest(questName); } // dumpquest
	void OnNewnpc(string scriptname = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnNewnpc(scriptname, value, value2, value3, value4, value5, value6, value7); } // newnpc
	void OnNewdyn(string npcIndex = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnNewdyn(npcIndex, value, value2, value3, value4, value5, value6, value7); } // newdyn
	void OnNewitem(string itemScriptname = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnNewitem(itemScriptname, value, value2, value3, value4, value5, value6, value7); } // newitem
	void OnEventtarg(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnEventtarg(scriptEvent, value, value2, value3, value4, value5, value6, value7); } // eventtarg
	void OnEventme(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnEventme(scriptEvent, value, value2, value3, value4, value5, value6, value7); } // eventme
	void OnEventplayers(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnEventplayers(scriptEvent, value, value2, value3, value4, value5, value6, value7); } // eventplayers
	void OnEventgm(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnEventgm(scriptEvent, value, value2, value3, value4, value5, value6, value7); } // eventgm
	void OnEventall(string scriptEvent = "", string value = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "", string value6 = "", string value7 = "") { Devcmds_OnEventall(scriptEvent, value, value2, value3, value4, value5, value6, value7); } // eventall
	void OnBlamb(string blastRadius = "", string damage = "", string damageType = "") { Devcmds_OnBlamb(blastRadius, damage, damageType); } // blamb
	void OnSetquest(string questName = "", string value = "") { Devcmds_OnSetquest(questName, value); } // setquest
	void OnGetquest(string quest = "") { Devcmds_OnGetquest(quest); } // getquest
	void OnSetgold(int amount = 0) { Devcmds_OnSetgold(amount); } // setgold
	void OnAddhp(string hpAmount = "") { Devcmds_OnAddhp(hpAmount); } // addhp
	void OnAddmp(string mpAmount = "") { Devcmds_OnAddmp(mpAmount); } // addmp
	void OnRat() { Devcmds_OnRat(); } // rat
	void OnSkele() { Devcmds_OnSkele(); } // skele
	void OnTeleforward(string forwardDistance = "") { Devcmds_OnTeleforward(forwardDistance); } // teleforward
	void OnEffectme(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "") { Devcmds_OnEffectme(effectScript, duration, owner, value, skill, value2); } // effectme
	void OnEffectmestack(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "") { Devcmds_OnEffectmestack(effectScript, duration, owner, value, skill, value2); } // effectmestack
	void OnEffecttarg(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "") { Devcmds_OnEffecttarg(effectScript, duration, owner, value, skill, value2); } // effecttarg
	void OnEffecttargstack(string effectScript = "", string duration = "", string owner = "", string value = "", string skill = "", string value2 = "") { Devcmds_OnEffecttargstack(effectScript, duration, owner, value, skill, value2); } // effecttargstack
	void OnTestdmg(string damageType = "") { Devcmds_OnTestdmg(damageType); } // testdmg
	void OnThrow() { Devcmds_OnThrow(); } // throw

	// This file's events and timers by their .script names
	bool Devcmds_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "addhp") { OnAddhp(Param(params, 0)); return true; }
		if (name == "addmp") { OnAddmp(Param(params, 0)); return true; }
		if (name == "blamb") { OnBlamb(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "dev_command") { OnDevCommand(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "dumpquest") { OnDumpquest(Param(params, 0)); return true; }
		if (name == "effectme") { OnEffectme(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "effectmestack") { OnEffectmestack(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "effecttarg") { OnEffecttarg(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "effecttargstack") { OnEffecttargstack(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "eventall") { OnEventall(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "eventgm") { OnEventgm(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "eventme") { OnEventme(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "eventplayers") { OnEventplayers(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "eventtarg") { OnEventtarg(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "game_playercmd") { OnGamePlayercmd(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "getquest") { OnGetquest(Param(params, 0)); return true; }
		if (name == "mp3") { OnMp3(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "newdyn") { OnNewdyn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "newitem") { OnNewitem(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "newnpc") { OnNewnpc(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "rat") { OnRat(); return true; }
		if (name == "setgold") { OnSetgold(Int(Param(params, 0))); return true; }
		if (name == "setquest") { OnSetquest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "skele") { OnSkele(); return true; }
		if (name == "slayall") { OnSlayall(Param(params, 0)); return true; }
		if (name == "tele") { OnTele(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "teledest") { OnTeledest(Param(params, 0)); return true; }
		if (name == "teleforward") { OnTeleforward(Param(params, 0)); return true; }
		if (name == "testdmg") { OnTestdmg(Param(params, 0)); return true; }
		if (name == "throw") { OnThrow(); return true; }
		if (name == "usetrig") { OnUsetrig(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "developer/devcmds"]
shared class DevcmdsScript : ScriptEntity, Devcmds
{
	// Variables every script that includes this file declares
	string BETA_TIMESTAMP = "BETA_TIMESTAMP";
	CBaseEntity@ CALLING_PLAYER = null;
	bool CAN_VOTE = false;
	string CREST_SELECTION = "CREST_SELECTION";
	float CUSTOM_COUNT = 0.0f;
	float FREQ_WEATHER = 0.0f;
	bool HIGH_IDX = false;
	bool HIGH_SCORE = false;
	string LEADING_GUILDS = "LEADING_GUILDS";
	float LISTMAPS_COUNT = 0.0f;
	string LISTMAPS_MSG_EPC = "LISTMAPS_MSG_EPC";
	string LISTMAPS_MSG_HAR = "LISTMAPS_MSG_HAR";
	string LISTMAPS_MSG_LOW = "LISTMAPS_MSG_LOW";
	string LISTMAPS_MSG_MED = "LISTMAPS_MSG_MED";
	string LISTMAPS_MSG_VHR = "LISTMAPS_MSG_VHR";
	string LISTMAPS_START = "LISTMAPS_START";
	string LISTMAPS_STOP = "LISTMAPS_STOP";
	string LISTMAPS_TARGET = "LISTMAPS_TARGET";
	string LTNG_SND = "LTNG_SND";
	CBaseEntity@ L_VOTE_CALLER = null;
	int MAP_VOTE_DELAY = 0;
	string POINTS_NLIST = "POINTS_NLIST";
	string POINTS_PLIST = "POINTS_PLIST";
	string POINTS_TNLIST = "POINTS_TNLIST";
	string POINTS_TPLIST = "POINTS_TPLIST";
	string RESIST_NAMES = "RESIST_NAMES";
	string RESIST_VALUES = "RESIST_VALUES";
	string SCRIPT_SFX1 = "SCRIPT_SFX1";
	string SOUND_RAIN = "SOUND_RAIN";
	string SPRITE_MIST = "SPRITE_MIST";
	string SPRITE_RIPPLE = "SPRITE_RIPPLE";
	string SPRITE_SPLASH = "SPRITE_SPLASH";
	string TEST_PLR = "TEST_PLR";
	bool TIMESET_DELAY = false;
	int TIME_UPDATE_INTERVAL = 0;
	string TIP_TEXT = "TIP_TEXT";
	bool WARNED_DRIDJE = false;
	bool WEATHERSET_DELAY = false;
	string WEATHER_SPRITE = "WEATHER_SPRITE";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Devcmds_DispatchEvent(name, params);
	}
}
