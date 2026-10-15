#pragma context server

// Converted from player/player.script by msc_transpiler.
// Player
// Server-side stuff

#include "runtime/ScriptEntity.as"
#include "converted/player/player_sound.as"
#include "converted/player/player_animation.as"
#include "converted/player/player_main.as"
#include "converted/player/server/meta_perks.as"
#include "converted/player/player_sv_menu.as"
#include "converted/player/player_sv_regen.as"
#include "converted/help/first_transition.as"
#include "converted/help/first_party.as"
#include "converted/help/first_skillgain.as"
#include "converted/help/first_death.as"
#include "converted/player/player_sh_stats.as"
#include "converted/player/externals.as"

[script "player/player"]
class PlayerPlayer : PlayerExternalsScript, PlayerSound, PlayerAnimation, PlayerMain, ValidSpawnNew, PlayerServerDmgpoints, ElementResist, MetaPerks, PlayerSvMenu, PlayerSvRegen, FirstTransition, FirstParty, FirstSkillgain, FirstDeath, PlayerShStats
{
	// Variables declared by included files, with the value they start with in this script
	PlayerPlayer()
	{
		ANIM_STAND = "stand"; // from player/player_animation
		ANIM_STAND_IDLE = "idle"; // from player/player_animation
		ANIM_CROUCH = "crouch_idle"; // from player/player_animation
		ANIM_CROUCHMOVE = "crawl"; // from player/player_animation
		ANIM_WALK = "walk_slow"; // from player/player_animation
		ANIM_RUN = "run"; // from player/player_animation
		ANIM_JUMP = "jump"; // from player/player_animation
		ANIM_TREAD = "treadwater"; // from player/player_animation
		ANIM_SWIM = "swim"; // from player/player_animation
		ANIM_DEATH = "die_simple"; // from player/player_animation
		ANIM_DEATH2 = "die_forwards"; // from player/player_animation
		ANIM_TYPE_ONCE = true; // from player/player_animation
		ANIM_TYPE_HOLD = 2; // from player/player_animation
		FREQ_AFK_CHECK = 60.0f; // from player/player_main
		LEAP_SIDE_DRAIN = 30; // from player/player_main
		LEAP_BACK_DRAIN = 60; // from player/player_main
		HBAR_FRAMES = 12; // from player/player_main
		SOUND_LEVELUP1 = "magic/converted_EnchP01.wav"; // from player/player_main
		LEVELUP_SCRIPT = "player/player_cl_effects_levelup"; // from player/player_main
		PLR_DARK_LEVEL_LOSS_RATE = 50; // from player/player_main
		PLR_MAX_DARK_LEVEL = 50000; // from player/player_main
		SOUND_BEAR_STRUCK1 = "monsters/bear/c_bear_hit1.wav"; // from player/player_main
		SOUND_BEAR_STRUCK2 = "monsters/bear/c_bear_hit2.wav"; // from player/player_main
		SOUND_BEAR_STRUCK3 = "monsters/bear/c_bear_no.wav"; // from player/player_main
		PLR_RESIST_RESET = "1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0"; // from player/server/element_resist
		BASE_REGEN_RATE = 12.0f; // from player/player_sv_regen
		BASE_REGEN_HP = true; // from player/player_sv_regen
		BASE_REGEN_MP = true; // from player/player_sv_regen
	}

	// game_precache
	// nclude player/player_statusflags
	void OnGamePrecache()
	{
		PrecacheFile("[full]", "player/emote_idle");
		PrecacheFile("[full]", "player/emote_yes");
		PrecacheFile("[full]", "player/emote_no");
		PrecacheFile("[full]", "player/emote_sit&stand");

		PrecacheFile("player/player_cl_effects");
		PrecacheFile("player/player_cl_effects_water");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayerServerDmgpoints_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // player/server/dmgpoints
		ElementResist_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // player/server/element_resist
		PlayerMain_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // player/player_main
		FirstDeath_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // help/first_death
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, PlayerServerDmgpoints_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PlayerMain_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PlayerMain_OnGameDamagedOther_2(target, damage, damageType, damageEvent));
		result = AppendResult(result, PlayerExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PlayerMain_OnGameSpawn(playerRace, playerGender); // player/player_main
		PlayerSvMenu_OnGameSpawn(playerRace, playerGender); // player/player_sv_menu
	}

	// game_learnskill
	void OnGameLearnskill(string skill = "", string subSkill = "", float value = 0.0f)
	{
		PlayerMain_OnGameLearnskill(skill, subSkill, value); // player/player_main
		FirstSkillgain_OnGameLearnskill(skill, subSkill, value); // help/first_skillgain
	}

	// game_transition_entered
	void OnGameTransitionEntered(string transDesc = "", string destMap = "", string localSpawn = "", string destSpawn = "")
	{
		PlayerMain_OnGameTransitionEntered(transDesc, destMap, localSpawn, destSpawn); // player/player_main
		FirstTransition_OnGameTransitionEntered(transDesc, destMap, localSpawn, destSpawn); // help/first_transition
	}

	// game_party_join
	void OnGamePartyJoin(string partyName = "")
	{
		PlayerMain_OnGamePartyJoin(partyName); // player/player_main
		FirstParty_OnGamePartyJoin(partyName); // help/first_party
	}

	// game_player_putinworld
	void OnGamePlayerPutinworld()
	{
		PlayerMain_OnGamePlayerPutinworld(); // player/player_main
		MetaPerks_OnGamePlayerPutinworld(); // player/server/meta_perks
	}

	void OnSpiderProtectEnd() { PlayerExternals_OnSpiderProtectEnd(); } // spider_protect_end
	void OnExtSetbodytype(string bodyType = "", string armorId = "") { PlayerExternals_OnExtSetbodytype(bodyType, armorId); } // ext_setbodytype

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("health_bar.spr");
		Precache("human/reference.mdl");
		Precache("dwarf/reference.mdl");
		Precache("player/hitground1.wav");
		Precache("magic/volcano_loop.wav");
		Precache("weapons/polearm_spin.wav");
		Precache("ambience/pulsemachine.wav");
		Precache("ambience/dronemachine1.wav");
		Precache("monsters/bear/c_beardire_bat1.wav");
		Precache("monsters/goblin/sps_fogfire.wav");
		Precache("player/swordready.wav");
		Precache("player/shout1.wav");
		Precache("player/jab1.wav");
		Precache("player/jab2.wav");
		Precache("player/breathe_fast1.wav");
		Precache("player/breathe_fast2.wav");
		Precache("player/breathe_fast3.wav");
		Precache("player/death.wav");
		Precache("player/chesthit1.wav");
		Precache("player/stomachhit1.wav");
		Precache("player/armhit1.wav");
		Precache("player/leghit1.wav");
		Precache("player/fallpain1.wav");
		Precache("player/fallpain2.wav");
		Precache("player/fallpain3.wav");
		Precache("player/fallpain4.wav");
		Precache("player/Femaleswordready.wav");
		Precache("player/Femaleshout1.wav");
		Precache("player/Femalejab1.wav");
		Precache("player/Femalejab2.wav");
		Precache("player/Femalebreathe_fast1.wav");
		Precache("player/Femalebreathe_fast2.wav");
		Precache("player/Femalebreathe_fast3.wav");
		Precache("player/FemaleDeath.wav");
		Precache("player/Femalechesthit1.wav");
		Precache("player/Femalestomachhit1.wav");
		Precache("player/Femalearmhit1.wav");
		Precache("player/Femaleleghit1.wav");
		Precache("player/Femalefallpain1.wav");
		Precache("player/Femalefallpain2.wav");
		Precache("player/Femalefallpain3.wav");
		Precache("player/Femalefallpain4.wav");
		Precache("magic/chant_loop.wav");
		Precache("ambience/rocketrumble1.wav");
		Precache("ambience/alien_powernode.wav");
		Precache("magic/bolt_loop.wav");
		Precache("magic/pulsemachine_noloop.wav");
		Precache("magic/freezeray_loop.wav");
		Precache("lgtning.spr");
		CallEventDelayed(FREQ_AFK_CHECK, "PlayerMain_Timer");
		CallEventDelayed(FINAL_REGEN_RATE_HP, "player_regen_hp");
		CallEventDelayed(FINAL_REGEN_RATE_MP, "player_regen_mp");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerAnimation_FirstThink();
		PlayerMain_FirstThink();
		PlayerServerDmgpoints_FirstThink();
		ElementResist_FirstThink();
		PlayerSvRegen_FirstThink();
		PlayerExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return PlayerAnimation_DispatchEvent(name, params)
			|| PlayerMain_DispatchEvent(name, params)
			|| ValidSpawnNew_DispatchEvent(name, params)
			|| PlayerServerDmgpoints_DispatchEvent(name, params)
			|| ElementResist_DispatchEvent(name, params)
			|| MetaPerks_DispatchEvent(name, params)
			|| PlayerSvMenu_DispatchEvent(name, params)
			|| PlayerSvRegen_DispatchEvent(name, params)
			|| FirstTransition_DispatchEvent(name, params)
			|| FirstParty_DispatchEvent(name, params)
			|| FirstSkillgain_DispatchEvent(name, params)
			|| FirstDeath_DispatchEvent(name, params)
			|| PlayerShStats_DispatchEvent(name, params)
			|| PlayerExternalsScript::DispatchEvent(name, params);
	}
}
