#pragma context server

// Converted from monsters/summon/volcano_troll.script by msc_transpiler.
// Trollcano

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

[script "monsters/summon/volcano_troll"]
class VolcanoTroll : BaseAoeScript
{
	// Constants
	string SOUND_START = "magic/volcano_start.wav";
	string SOUND_LOOP = "magic/volcano_loop.wav";
	string MODEL_WORLD = "misc/volcano.mdl";
	int ROCK_START_HEIGHT = 66;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	bool LOOP_DELAY = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string CAST_BY_PLAYER = "CAST_BY_PLAYER";
	string EFFECT_DURATION = "EFFECT_DURATION";
	float CLIENT_DURATION = 0.0f;
	bool ERUPTING = false;

	// Variables declared by included files, with the value they start with in this script
	VolcanoTroll()
	{
		AOE_FREQ = 2.0f;
		AOE_RADIUS = "32";
	}

	// unnamed block (first think)
	void VolcanoTroll_FirstThink()
	{
		ANIM_DEATH = "down"; // for base_npc
		LOOP_DELAY = false;
	}

	// unnamed block (first think)
	void VolcanoTroll_FirstThink2()
	{
		PlaySound(Int(GetVar("CHAN_BODY")), 7, SOUND_LOOP);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe

		SetHealth(1500);
		SetInvincible(true); // screw it, it has 1500pts anyways - and ya don't want it to report attacks against itself
		SetSolid("none"); // doesnt trap monsters/players inside of it
		SetWidth(32);
		SetHeight(64);
		SetName("Trollcano!");
		SetRoam(false);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetModel(MODEL_WORLD);
		SetBlood("none");
		PlayAnim("hold", "up");
		PLAYING_DEAD = "1";
		CallEventDelayed(2.0f, "volcano_start"); // Start erupting after a delay
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 10, 6, 512);
		PlaySound(0, 7, SOUND_START);
	}

	// game_dynamically_created
	// PARAM1=owner
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		CAST_BY_PLAYER = Text(IsPlayer(creatorValue1));

		MY_OWNER = creatorValue1;

		// setduration
		EFFECT_DURATION = "25";
		CLIENT_DURATION = Float(EFFECT_DURATION);
		CLIENT_DURATION -= 1.0f; // ensures clients are done before fx is deleted

		CallEventOrDelay(EFFECT_DURATION, "volcano_death"); // Die after a delay
		ClientEvent("persist", "all", "monsters/summon/volcano_troll", OriginOf(ENT_ME), CLIENT_DURATION, IndexOf(MY_OWNER));
	}

	// volcano_start
	// Start shooting
	void OnVolcanoStart()
	{
		ERUPTING = true;
	}

	// volcano_death
	// Fade out
	void OnVolcanoDeath()
	{
		ERUPTING = false;

		PlayAnim("hold", "down");
		CallEventDelayed(3.0f, "volcano_fadeout");
	}

	// volcano_fadeout
	void OnVolcanoFadeout()
	{
		PlaySound(Int(GetVar("CHAN_BODY")), Eval("game.sound.silentvol"), SOUND_LOOP);
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnEffectDuration() {} // EFFECT_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/volcano.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VolcanoTroll_FirstThink();
		VolcanoTroll_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "volcano_death") { OnVolcanoDeath(); return true; }
		if (name == "volcano_fadeout") { OnVolcanoFadeout(); return true; }
		if (name == "volcano_start") { OnVolcanoStart(); return true; }
		return BaseAoeScript::DispatchEvent(name, params);
	}
}
