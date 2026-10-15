#pragma context server

// Converted from monsters/summon/npc_volcano.script by msc_transpiler.
// Thothie - Reduced level of Volcano to something obtainable
// Thothie - No parameters other than owner are passing to this monster for some reason
// - Reducing damage as well
// - PARAM1 = owner
// Volcano

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "monsters/summon/npc_volcano"]
class NpcVolcano : BaseNpcScript
{
	// Constants
	string SOUND_START = "magic/volcano_start.wav";
	string SOUND_LOOP = "magic/volcano_loop.wav";
	string MODEL_WORLD = "misc/volcano.mdl";
	int ANGLE_OFFSET = 60;
	int FORCE_OFFSET = 70;
	int ROCK_START_HEIGHT = 66;

	// Variables (an unset .script variable reads as its own name)
	bool I_DO_FIRE_DAMAGE = false;
	string DMG_HIGH = "DMG_HIGH";
	int DMG_LOW = 0;
	string TIME_LIVE = "TIME_LIVE";
	bool LOOP_DELAY = false;
	string VOLCANO_ID = "VOLCANO_ID";
	bool ERUPTING = false;
	string FUNC_ROCKSPAWN_ORIGIN = "FUNC_ROCKSPAWN_ORIGIN";

	// unnamed block (first think)
	void NpcVolcano_FirstThink()
	{
		ANIM_DEATH = "down"; // for base_npc
		I_DO_FIRE_DAMAGE = true;
	}

	// unnamed block (timer)
	// Random shoot rock
	void NpcVolcano_Timer()
	{
		CallEventDelayed(Random(0, 0.5f), "NpcVolcano_Timer");

		if (!ERUPTING)
			return;
		OnVolcanoShoot();
	}

	// unnamed block (timer)
	void NpcVolcano_Timer2()
	{
		CallEventDelayed(Random(0, 0.5f), "NpcVolcano_Timer2");

		if (!ERUPTING)
			return;
		OnVolcanoShoot();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust

		// $get(ent_me,id) 300 SPELL_FREQ
		DMG_HIGH = creatorValue2;
		DMG_LOW = 25; // never set, so rolls started at 0
		TIME_LIVE = damage; // Seconds to live
		LOOP_DELAY = false;

		CallEventOrDelay(TIME_LIVE, "volcano_death"); // Die after a delay
		ClientEvent("new", "all", "monsters/summon/npc_volcano", IndexOf(ENT_ME), TIME_LIVE);
		VOLCANO_ID = LastClientScriptId();

		// emitsound ent_me $get(ent_me,origin) 512 TIME_LIVE danger 512
		// This seems to be giving skill points - but to no paticular skill (keep leveling up null)
		// debugprint ParAtCreate PARAM1
		LegacyCommand("storeentity", ENT_EXPOWNER, creatorValue1); // Give any gained exp to the player
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1500);
		SetInvincible(true); // screw it, it has 1500pts anyways - and ya don't want it to report attacks against itself
		SetSolid("none"); // doesnt trap monsters/players inside of it
		SetFieldOfView(90);
		SetWidth(32);
		SetHeight(64);
		SetName("A Volcano");
		SetRoam(false);
		SetDamageTaken("cold", 2);
		SetDamageTaken("fire", 0);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetModel(MODEL_WORLD);
		SetBlood("none");
		SetStat("spellcasting", 15, 15, 15);
		PlayAnim("hold", "up");
		CallEventDelayed(2.0f, "volcano_start"); // Start erupting after a delay
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 10, 6, 512);
		PlaySound(0, 7, SOUND_START);
	}

	// volcano_start
	// Start shooting
	void OnVolcanoStart()
	{
		ERUPTING = true;
		ClientEvent("update", "all", VOLCANO_ID, "fx_start");
	}

	// volcano_shoot
	// Shoot rock
	void OnVolcanoShoot()
	{
		float attackDamage = Random(DMG_LOW, Float(DMG_HIGH));

		// Target pos, not view angles - view pitch is inverted and these were
		// firing into the ground. Same as summon_volcano.
		Vector3 origin = RelativePosition(Vector3(0, 0, ROCK_START_HEIGHT));
		string dir = Text(origin);
		dir = Text(Vec(dir) + Vector3(0.0f, 0.0f, 50.0f));
		dir = Text(Vec(dir) + Vector3(ANGLE_OFFSET * Random(-1, 1), 0.0f, 0.0f));
		dir = Text(Vec(dir) + Vector3(0.0f, ANGLE_OFFSET * Random(-1, 1), 0.0f));

		float force = 500.0f + FORCE_OFFSET * Random(-1, 1);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_volcano", origin, dir, force, attackDamage, 0, "none");

		// extra red rocks for show, own arcs clientside
		ClientEvent("update", "all_in_sight", VOLCANO_ID, "volcono_shoot_rock");
	}

	// volcano_death
	// Fade out
	void OnVolcanoDeath()
	{
		ERUPTING = false;
		ClientEvent("update", "all", VOLCANO_ID, "fx_end");

		PlayAnim("hold", "down");
		CallEventDelayed(3.0f, "volcano_fadeout");
	}

	// volcano_fadeout
	void OnVolcanoFadeout()
	{
		PlaySound(Int(GetVar("CHAN_BODY")), Eval("game.sound.silentvol"), SOUND_LOOP);
		DeleteEntity(ENT_ME, "fade");
	}

	// func_rockspawn
	// returns the origin of fireball spawn
	void OnFuncRockspawn()
	{
		Vector3 origin;

		origin = OriginOf(ENT_ME);

		origin.z += ROCK_START_HEIGHT;

		FUNC_ROCKSPAWN_ORIGIN = Text(origin);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnTimeLive() {} // TIME_LIVE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/volcano.mdl");
		Precache("fire1_fixed.spr");
		Precache("rain_mist.spr");
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(Float(Eval("$randf(0.0,0.5)")), "NpcVolcano_Timer");
		CallEventDelayed(Float(Eval("$randf(0.0,0.5)")), "NpcVolcano_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NpcVolcano_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "func_rockspawn") { OnFuncRockspawn(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "volcano_death") { OnVolcanoDeath(); return true; }
		if (name == "volcano_fadeout") { OnVolcanoFadeout(); return true; }
		if (name == "volcano_shoot") { OnVolcanoShoot(); return true; }
		if (name == "volcano_start") { OnVolcanoStart(); return true; }
		if (name == "NpcVolcano_Timer") { NpcVolcano_Timer(); return true; }
		if (name == "NpcVolcano_Timer2") { NpcVolcano_Timer2(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
