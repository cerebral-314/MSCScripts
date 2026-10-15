#pragma context server

// Converted from traps/volcano.script by msc_transpiler.
// Thothie - Volcano Trap, from volcano
// - This is intended to hurt everyone in the area, including monsters
// Volcano

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "traps/volcano"]
class Volcano : BaseNpcScript
{
	// Constants
	string DMG_HIGH = "100";
	int DMG_LOW = 50;
	string TIME_LIVE = "30";
	string SOUND_START = "magic/volcano_start.wav";
	string SOUND_LOOP = "magic/volcano_loop.wav";
	string MODEL_WORLD = "misc/volcano.mdl";
	int ROCK_START_HEIGHT = 66;

	// Variables (an unset .script variable reads as its own name)
	bool LOOP_DELAY = false;
	string VOLCANO_ID = "VOLCANO_ID";
	bool ERUPTING = false;
	int xangle = 0;
	int yangle = 0;

	// unnamed block (first think)
	void Volcano_FirstThink()
	{
		ANIM_DEATH = "down"; // for base_npc
		LOOP_DELAY = false;
	}

	// unnamed block (first think)
	void Volcano_FirstThink2()
	{
		PlaySound(Int(GetVar("CHAN_BODY")), 7, SOUND_LOOP);
	}

	// unnamed block (timer)
	// Random shoot rock
	void Volcano_Timer()
	{
		CallEventDelayed(Random(0, 0.5f), "Volcano_Timer");

		if (!ERUPTING)
			return;
		OnVolcanoShoot();
	}

	// unnamed block (timer)
	void Volcano_Timer2()
	{
		CallEventDelayed(Random(0, 0.5f), "Volcano_Timer2");

		if (!ERUPTING)
			return;
		OnVolcanoShoot();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1500);
		SetRace("hated");
		SetInvincible(true); // screw it, it has 1500pts anyways - and ya don't want it to report attacks against itself
		SetSolid("none"); // doesnt trap monsters/players inside of it
		// ov 90
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
		SetStat("spellcasting", 40, 40, 40); // Thothie - this is interesting
		PlayAnim("hold", "up");
		CallEventDelayed(2.0f, "volcano_start"); // Start erupting after a delay
		CallEventOrDelay(TIME_LIVE, "volcano_death"); // Die after a delay
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 10, 6, 512);
		LegacyCommand("emitsound", ENT_ME, OriginOf(ENT_ME), 512, TIME_LIVE, "danger", 512);
		PlaySound(0, 7, SOUND_START);
		ClientEvent("persist", "all", "traps/volcano", OriginOf(ENT_ME), TIME_LIVE);
		VOLCANO_ID = LastClientScriptId();
	}

	// volcano_start
	// Start shooting
	void OnVolcanoStart()
	{
		ERUPTING = true;
	}

	// volcano_shoot
	// Shoot rock
	void OnVolcanoShoot()
	{
		xangle = RandomInt(50, 90);
		yangle = RandomInt(-180, 180);
		SetAngle("view", Vector3(xangle, yangle, 0));

		float attackDamage = Random(DMG_LOW, Float(DMG_HIGH));
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), 128, attackDamage, "100%", 0);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_volcano", RelativePosition(Vector3(0, 0, ROCK_START_HEIGHT)), "none", 500, attackDamage, 0, "none");
		ClientEvent("update", "all_in_sight", VOLCANO_ID, "volcono_shoot_rock", VelocityOf(ENT_LASTPROJECTILE), GetProp(ENT_LASTPROJECTILE, "gravity"));
	}

	// volcano_death
	// Fade out
	void OnVolcanoDeath()
	{
		ERUPTING = false;

		// playanim hold down
		CallEventDelayed(3.0f, "volcano_fadeout");
	}

	// volcano_fadeout
	void OnVolcanoFadeout()
	{
		PlaySound(Int(GetVar("CHAN_BODY")), Eval("game.sound.silentvol"), SOUND_LOOP);
		SetInvincible(false);
		DoDamage(ENT_ME, "direct", 6000, 100, ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnTimeLive() {} // TIME_LIVE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/volcano.mdl");
		CallEventDelayed(Float(Eval("$randf(0.0,0.5)")), "Volcano_Timer");
		CallEventDelayed(Float(Eval("$randf(0.0,0.5)")), "Volcano_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Volcano_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		Volcano_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "volcano_death") { OnVolcanoDeath(); return true; }
		if (name == "volcano_fadeout") { OnVolcanoFadeout(); return true; }
		if (name == "volcano_shoot") { OnVolcanoShoot(); return true; }
		if (name == "volcano_start") { OnVolcanoStart(); return true; }
		if (name == "Volcano_Timer") { Volcano_Timer(); return true; }
		if (name == "Volcano_Timer2") { Volcano_Timer2(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
