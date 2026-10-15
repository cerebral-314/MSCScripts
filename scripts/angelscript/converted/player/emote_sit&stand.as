#pragma context server

// Converted from player/emote_sit&stand.script by msc_transpiler.
// Thothie - Raising sit mana regen to 5, and sit health regen to 3 (total) due to mass complaints
// - What I really want is to heal by a % of maximum health/manna, attempting
// Sit down, Stand up

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "player/emote_sit&stand"]
class EmoteSitStand : BaseEffectScript
{
	// Constants
	string TEXT_SIT = "#ACTION_SIT";
	string TEXT_STAND = "#ACTION_STAND";
	bool VIEW_LOWERTIME = true;
	bool VIEW_RAISETIME = true;

	// Variables (an unset .script variable reads as its own name)
	bool AM_SITTING = false;
	float FULL_ALERT = 0.0f;
	float PLR_SPEED_SPEED_RATIO = 0.0f;
	string SCRIPT_ID = "SCRIPT_ID";
	float STRUCK_TIME = 0.0f;
	float MAX_HEALTH = 0.0f;
	float REGEN_RATE = 0.0f;
	int REGEN_INT = 0;
	float MAX_MANA = 0.0f;
	float MANA_RATE = 0.0f;
	int MANA_INT = 0;

	// Variables declared by included files, with the value they start with in this script
	EmoteSitStand()
	{
		EFFECT_ID = "player_sitstand";
		EFFECT_FLAGS = "player_action";
	}

	// unnamed block (first think)
	void EmoteSitStand_FirstThink()
	{
		SetVar(Eval("game.effect.displayname"), TEXT_SIT);

		AM_SITTING = false;

		FULL_ALERT = 0.0f;
		PLR_SPEED_SPEED_RATIO = 1.0f;
	}

	// unnamed block (timer)
	void EmoteSitStand_Timer()
	{
		int showitOn = 0;
		float myHp;
		string myHpText = "MY_HP";
		float myMaxhp = 0.0f;
		CallEventDelayed(5.0f, "EmoteSitStand_Timer"); // Gain health

		if (STRUCK_TIME > 0.0f)
			STRUCK_TIME -= 1.0f;

		if (Text(STRUCK_TIME) == "STRUCK_TIME")
			STRUCK_TIME = 1.0f;

		if (STRUCK_TIME <= 1.0f)
		{
			if (AM_SITTING)
			{
				int demonOn = Int(ScriptVarOf(ENT_ME, "DEMON_BLOOD"));
				if (demonOn == 0)
				{
					MAX_HEALTH = MaxHealthOf(ENT_ME);
					REGEN_RATE = 0.05f * MAX_HEALTH;
					REGEN_INT = int(REGEN_RATE);
					if (REGEN_INT < 2)
						REGEN_INT = 2;
					LegacyCommand("add", "regen.hp.amt", REGEN_INT);
					GiveHealth(ENT_ME, "regen.hp.amt");
					LegacyCommand("drainstamina", ENT_ME, -1000);

					showitOn = Int(ScriptVarOf(ENT_ME, "SHOW_HEALTH"));
					if (showitOn != 0)
					{
						myHp = HealthOf(ENT_ME);
						myMaxhp = MaxHealthOf(ENT_ME);
						myHp = int(myHp);
						myHpText = Text(myHp);
						myMaxhp = int(myMaxhp);
					}
				}
			}
			else
			{
				SetVar("regen.hp.amt", 1);
			}

			if (AM_SITTING) // Gain mana
			{
				MAX_MANA = MaxManaOf(ENT_ME);
				MANA_RATE = 0.20f * MAX_MANA;
				MANA_INT = int(MANA_RATE);
				if (MANA_INT < 4)
					MANA_INT = 4;
				LegacyCommand("add", "regen.mp.amt", MANA_INT);
				GiveMana(ENT_ME, "regen.mp.amt");

				if (showitOn != 0)
				{
					float myMp = ManaOf(ENT_ME);
					string myMpText;
					float myMaxmp = MaxManaOf(ENT_ME);
					myMp = int(myMp);
					myMpText = Text(myMp);
					myMaxmp = int(myMaxmp);

					FULL_ALERT += 1.0f;
					if (ManaOf(ENT_ME) == MaxManaOf(ENT_ME))
						myMpText = "MAX";
					if (HealthOf(ENT_ME) == MaxHealthOf(ENT_ME))
						myHpText = "MAX";
					if (ManaOf(ENT_ME) < MaxManaOf(ENT_ME))
						FULL_ALERT = 0.0f;
					if (HealthOf(ENT_ME) < MaxHealthOf(ENT_ME))
						FULL_ALERT = 0.0f;
					if (FULL_ALERT == 1.0f)
						PlayerMessageGreen(ENT_ME, "You are fully rested.");
					if (FULL_ALERT == 0.0f)
						PlayerMessageGreen(ENT_ME, "Resting... HP: ( " + myHpText + " / " + Text(myMaxhp) + " ) MANA: ( " + myMpText + " / " + Text(myMaxmp) + " )");
				}
			}
			else
			{
				SetVar("regen.mp.amt", 1);
			}
		}
	}

	// game_activate
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		CallEventDelayed(0.5f, "send_emote"); // I need this delay
	}

	// send_emote
	void OnSendEmote()
	{
		ClientEvent("new", ENT_ME, "player/emote_sit&stand");
		SCRIPT_ID = LastClientScriptId();
	}

	// game_player_activate
	void OnGamePlayerActivate()
	{
		if (!AM_SITTING)
		{
			if (!CanAttack(ENT_ME))
			{
				PlayerMessageDark(ENT_ME, "Can't use this emote while unable to attack.");
				return;
			}

			CallExternal(ENT_ME, "emote_stop"); // Stop other emotes
			PlayAnim("hold", "sitdown");

			CallExternal(ScriptVarOf(ENT_ME, "PLR_ACTIVE_WEAPON"), "ext_player_sit"); // tell weapon I'm sitting

			SetVar(Eval("game.effect.canmove"), 0);
			SetVar(Eval("game.effect.canattack"), 0);
			SetVar(Eval("game.effect.canrun"), 0);
			SetVar(Eval("game.effect.canjump"), 0);
			SetVar(Eval("game.effect.canduck"), 0);

			LegacyCommand("setstatus", "add", "sitting");
			AM_SITTING = true;

			ClientEvent("update", ENT_ME, SCRIPT_ID, "view_change", 1);

			SetVar(Eval("game.effect.displayname"), TEXT_STAND);
			SetVar(Eval("game.effect.updateplayer"), 1);
		}
		else
		{
			ClientEvent("update", ENT_ME, SCRIPT_ID, "view_change", 0);
			CallEventOrDelay(VIEW_RAISETIME, "player_sit_freedom");
			LegacyCommand("setstatus", "remove", "sitting");
		}
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		STRUCK_TIME = 5.0f; // Do not allow heal 5 cycles after being struck
		SetVar("regen.hp.amt", 0);
	}

	// player_sit_freedom
	void OnPlayerSitFreedom()
	{
		PlayAnim("break");
		SetVar(Eval("game.effect.canmove"), 1);
		SetVar(Eval("game.effect.canattack"), 1);
		SetVar(Eval("game.effect.canrun"), 1);
		SetVar(Eval("game.effect.canjump"), 1);
		SetVar(Eval("game.effect.canduck"), 1);

		// quest set ent_me emote_sitting 0
		AM_SITTING = false;
		SetVar(Eval("game.effect.displayname"), TEXT_SIT);
		SetVar(Eval("game.effect.updateplayer"), 1);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!AM_SITTING) // if sitting
			return;
		ClientEvent("update", ENT_ME, SCRIPT_ID, "view_change", 0); // Then set view height back to standing
	}

	// plr_change_speed
	// ============ new speed system
	// <duration [-1 for until removed]|normal> <speed_ratio> <tag>
	void OnPlrChangeSpeed(string duration = "", float speedRatio = 0.0f, string tag = "")
	{
		DebugPrint("player/emote_sit&stand plr_change_speed " + duration + " " + Text(speedRatio) + " " + tag);

		if (duration == "normal")
		{
			PLR_SPEED_SPEED_RATIO = 1.0f;
			ClientEvent("update", ENT_ME, SCRIPT_ID, "plr_update_speed_client", PLR_SPEED_SPEED_RATIO);
			SetVar(Eval("game.effect.movespeed"), PLR_SPEED_SPEED_RATIO * 100.0f);
			SetVar(Eval("game.effect.anim.framerate"), PLR_SPEED_SPEED_RATIO);
			ScriptFlags(ENT_ME, "cleartype", "speed");
			return;
		}

		string action = "add";
		if (Truthy(ScriptFlag(ENT_ME, tag, "name_exists")))
			action = "edit";
		ScriptFlags(ENT_ME, action, tag, "speed", speedRatio, duration);

		OnPlrGetTotalSpeed(); // This event also calls apply speed
	}

	// plr_update_speed_effects
	// <update|remove> [tag]
	void OnPlrUpdateSpeedEffects(string mode = "", string effectTag = "")
	{
		DebugPrint("plr_update_speed_effects " + mode + " " + effectTag);

		if (mode == "remove")
		{
			DebugPrint("player/emote_sit&stand - plr_update_speed_effects remove " + effectTag);
			ScriptFlags(ENT_ME, "remove", effectTag);
		}

		OnPlrGetTotalSpeed();
	}

	// ext_scriptflag_expired
	void OnExtScriptflagExpired()
	{
		if (PLR_SPEED_SPEED_RATIO == 1.0f)
			return;
		CallEventDelayed(0.1f, "plr_get_total_speed");
	}

	// plr_get_total_speed
	void OnPlrGetTotalSpeed()
	{
		if (!Truthy(ScriptFlag(ENT_ME, "speed", "type_exists")))
		{
			OnPlrChangeSpeed("normal");
			return;
		}

		string speedFlagTotal = ScriptFlag(ENT_ME, "speed", "type_value");
		string speedFlagCount = ScriptFlag(ENT_ME, "speed", "type_count");

		float newSpeed = Divide(Float(speedFlagTotal), Float(speedFlagCount));

		PLR_SPEED_SPEED_RATIO = newSpeed;

		OnPlrApplySpeed();

		DebugPrint("player/emote_sit&stand plr_get_total_speed - tot " + speedFlagTotal + " count " + speedFlagCount + " new " + Text(PLR_SPEED_SPEED_RATIO) + " / " + Text(PLR_SPEED_SPEED_RATIO * 100.0f));
	}

	// plr_apply_speed
	void OnPlrApplySpeed()
	{
		if (SCRIPT_ID == "SCRIPT_ID")
		{
			ClientEvent("new", ENT_ME, "player/emote_sit&stand");
			SCRIPT_ID = LastClientScriptId();
		}

		ClientEvent("update", ENT_ME, SCRIPT_ID, "plr_update_speed_client", PLR_SPEED_SPEED_RATIO);

		SetVar(Eval("game.effect.anim.framerate"), PLR_SPEED_SPEED_RATIO);
		SetVar(Eval("game.effect.movespeed"), PLR_SPEED_SPEED_RATIO * 100.0f);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnViewRaisetime() {} // VIEW_RAISETIME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(5.0f, "EmoteSitStand_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EmoteSitStand_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_scriptflag_expired") { OnExtScriptflagExpired(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_player_activate") { OnGamePlayerActivate(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "player_sit_freedom") { OnPlayerSitFreedom(); return true; }
		if (name == "plr_apply_speed") { OnPlrApplySpeed(); return true; }
		if (name == "plr_change_speed") { OnPlrChangeSpeed(Param(params, 0), Float(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "plr_get_total_speed") { OnPlrGetTotalSpeed(); return true; }
		if (name == "plr_update_speed_effects") { OnPlrUpdateSpeedEffects(Param(params, 0), Param(params, 1)); return true; }
		if (name == "send_emote") { OnSendEmote(); return true; }
		if (name == "EmoteSitStand_Timer") { EmoteSitStand_Timer(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
