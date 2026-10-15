#pragma context server

// Converted from phobia/betor_ally.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_battle_ally.as"
#include "converted/monsters/bandit_elite_mace.as"

[script "phobia/betor_ally"]
class BetorAlly : BanditEliteMaceScript, BaseBattleAlly
{
	// Variables declared by included files, with the value they start with in this script
	BetorAlly()
	{
		MY_SKILL = "bluntarms";
		OVERRIDE_BANDIT_SPAWN = true;
		AI_NO_TARGET_STRING = "\xAFNONE\xAF";
		ANIM_ALLY_JUMP = "long_jump";
		SOUND_ALLY_JUMP = "player/shout1.wav";
		ALLY_JUMP_THRESHOLD = 150;
		BANDIT_TYPE = "mace";
		ATTACK_PERCENTAGE = "85%";
		NPC_FIGHTS_NPCS = true; // from monsters/base_battle_ally
		ALLY_MIN_DISTANCE = 42; // from monsters/base_battle_ally
		ALLY_FOLLOW_CLOSE_DIST = 60; // from monsters/base_battle_ally
		ALLY_FOLLOW_NORM_DIST = 128; // from monsters/base_battle_ally
		ALLY_MOVE_AWAY_DIST = 64; // from monsters/base_battle_ally
		ALLY_REGEN_RATIO = 0.1f; // from monsters/base_battle_ally
		ALLY_MAX_JUMP_RANGE = 600; // from monsters/base_battle_ally
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/bandit_elite");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BanditElite_OnNpcSpawn(npc); // monsters/bandit_elite

		BANDIT_TYPE = "mace";

		SetName("|Betor the Strong");
		SetUniqueName("bandit_betor");
		SetMonsterClip(false);
		SetModel("npc/rogue_1337.mdl");
		SetGold(RandomInt(30, 40));
		SetWidth(32);
		SetHeight(92);

		SetRace("human");
		SetDamageTaken("all", 0.6f);
		SetHearingSensitivity(10);
		SetRoam(false);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		CallEventDelayed(0.1f, "custom_bandit");
	}

	// custom_bandit
	void OnCustomBandit()
	{
		// bowey
		SetHealth(1750);
		MOVE_RANGE = "80";
		ATTACK_RANGE = 100.0f;
		ATTACK1_DAMAGE = Text(Random(30, 60));
		ATTACK_PERCENTAGE = "85%";
		ANIM_ATTACK = "battleaxe_swing1_R";
		ORIG_ATTACK = ANIM_ATTACK;
		SetModelBody(1, 2);
		BANDIT_TYPE = "mace";
	}

	// bandit_ally_start_follow
	void OnBanditAllyStartFollow()
	{
		// saytext Following...
		PlayAnim("break");
		ALLY_FOLLOW_ON = true;
		MADE_DEAL = true;
	}

	// bandit_ally_go_hostile
	void OnBanditAllyGoHostile()
	{
		HOSTILE_MODE = true;
		NPC_NO_PLAYER_DMG = false;
		NPC_BATTLE_ALLY = false;
		ALLY_FOLLOW_ON = false;
		SetRace("rogue");
		SetRoam(true);
		if (BANDIT_TYPE != "bow")
			NO_STUCK_CHECKS = "0";
	}

	// bandit_ally_drinkup
	void OnBanditAllyDrinkup()
	{
		PlayAnim("critical", "aim_punch1");

		float myHp = HealthOf(ENT_ME);
		float myMaxhp = MaxHealthOf(ENT_ME);

		if (myHp < myMaxhp)
		{
			float healAmt = myMaxhp;
			string healAmtText;
			healAmt -= myHp;
			healAmtText = Text(healAmt);
			GiveHealth(ENT_ME, healAmtText);
		}

		string outTitle = NameOf(ENT_ME) + " has quaffed a potion of fire resistance.";
		InfoMessage("all", outTitle, "' '");
		SetDamageTaken("fire", 0.25f);
		SetDamageTaken("all", 0.4f);
		PlaySound(0, 10, "items/drink.wav");
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, 2, 2);
	}

	// bandit_ally_boss_dead
	void OnBanditAllyBossDead()
	{
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement("deep_idle");
		SetMoveDest("none");
		OnCheckQualify();
		ALLY_FOLLOW_ON = false;
		REWARD_MODE = true;
		SetMenuAutoOpen(true);
	}

	// check_qualify
	void OnCheckQualify()
	{
		TC_QUAL_PLAYERS = false;
		TC_QUAL_PLAYERS = Truthy(GetActivePlayers());
		TC_AVG_DMG_PTS = 0.0f;
		int count = GetTokenCount(Text(TC_QUAL_PLAYERS));
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnTcGetAverages();
		}
		TC_AVG_DMG_PTS = Divide(TC_AVG_DMG_PTS, PlayerCount());
		TC_HALF_AVG_DMG_PTS = TC_AVG_DMG_PTS * 0.5f;
	}

	// tc_get_averages
	void OnTcGetAverages()
	{
		string curPlayer = GetToken(Text(TC_QUAL_PLAYERS), loopIteration);
		TC_AVG_DMG_PTS += Float(ScriptVarOf(curPlayer, "PLR_TOTAL_DMG"));
	}

	// say_reward
	void OnSayReward(CBasePlayer@ player = null)
	{
		bool exitSub = false;
		int userPts = Int(ScriptVarOf(player, "PLR_TOTAL_DMG"));
		USER_QUALIFIES = false;
		if (userPts >= TC_HALF_AVG_DMG_PTS)
			USER_QUALIFIES = true;
		if (!USER_QUALIFIES)
		{
			PlayAnim("critical", "look_idle");
			SayText("Judging by your performance out there, or rather the lack there of, I don't think you're ready for what I could teach you.");
		}
		if (!USER_QUALIFIES)
			return;
		float userSteam = Float(SteamIdOf(player));
		userSteam += Float(GetProp(player, "slot"));
		if (Contains(GetVar("G_REWARD_LIST"), Text(userSteam)))
		{
			PlayAnim("critical", "look_idle");
			SayText("Sorry, the deal was you could train once from one of us. Thanks for the assist though. We should be fine from here.");
			exitSub = true;
		}
		if (exitSub)
			return;

		CBaseEntity@ ralionId = FindByName("bandit_ralion");
		if (!IsAlive(ralionId))
		{
			PlayAnim("critical", "look_idle");
			SayText("Ralion maybe dead, but I'll stick to his deal... I'll show you what I know.");
		}
		else
		{
			PlayAnim("critical", "look_idle");
			SayText("Alright... I'll show you what I know.");
		}

		float xpGain = 20000.0f;
		float plrAdj = (PlayerCount() - 1.0f) * 0.25f + 1.0f;
		xpGain *= plrAdj;
		LegacyCommand("giveexp", @player, MY_SKILL, int(xpGain));
		PlayerMessageGreen(player, "* " + int(xpGain) + " XP Awarded ( " + MY_SKILL + " )");
		LegacyCommand("token.add", "G_REWARD_LIST", userSteam);

		string outMsg = "You recieve " + MY_SKILL + " from " + NameOf(ENT_ME);
		InfoMessage(player, "Training Recieved", outMsg);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (HOSTILE_MODE)
			return;
		if (!MADE_DEAL)
			return;

		if (REWARD_MODE)
		{
			InfoMessage(player, "Training with bandits", "You may only train with one bandit, so choose wisely.");
			menuItem.title = "Bluntarms Training...";
			menuItem.type = "callback";
			menuItem.callback = "say_reward";
			RegisterMenuItem(menuItem);
		}
	}

	// bandits_remove
	void OnBanditsRemove()
	{
		DeleteEntity(ENT_ME, "fade"); // folks left us here, probably hoping to exploit, remove
	}

	// bandit_ally_lights
	void OnBanditAllyLights()
	{
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(10.0f, "bandit_ally_lights");
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 64, 0), 64, 9.9f);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseBattleAlly_OnNpcatkHunt(); // monsters/base_battle_ally
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseBattleAlly_FirstThink();
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
		if (name == "bandit_ally_boss_dead") { OnBanditAllyBossDead(); return true; }
		if (name == "bandit_ally_drinkup") { OnBanditAllyDrinkup(); return true; }
		if (name == "bandit_ally_go_hostile") { OnBanditAllyGoHostile(); return true; }
		if (name == "bandit_ally_lights") { OnBanditAllyLights(); return true; }
		if (name == "bandit_ally_start_follow") { OnBanditAllyStartFollow(); return true; }
		if (name == "bandits_remove") { OnBanditsRemove(); return true; }
		if (name == "check_qualify") { OnCheckQualify(); return true; }
		if (name == "custom_bandit") { OnCustomBandit(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_reward") { OnSayReward(PlayerParam(params, 0)); return true; }
		if (name == "tc_get_averages") { OnTcGetAverages(); return true; }
		return BaseBattleAlly_DispatchEvent(name, params)
			|| BanditEliteMaceScript::DispatchEvent(name, params);
	}
}
