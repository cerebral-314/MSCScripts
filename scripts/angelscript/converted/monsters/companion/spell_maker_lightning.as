#pragma context server

// Converted from monsters/companion/spell_maker_lightning.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_lightning"]
class SpellMakerLightning : SpellMakerBaseScript
{
	// Constants
	string FX_SCRIPT = "monsters/companion/spell_maker_lightning";
	string MODEL_OFSET = "0";
	string SOUND_SPAWN = "weather/Storm_exclamation.wav";
	float REMOVE_DELAY = 10.0f;
	bool SHOW_FX = true;
	string EFFECTS_SPRITE = "lgtning.spr";
	string C_FX_SPRITE = "lgtning.spr";

	// Variables declared by included files, with the value they start with in this script
	SpellMakerLightning()
	{
		ANIM_IDLE = "";
		SPAWNER_MODEL = "none";
	}

	// unnamed block (first think)
	void SpellMakerLightning_FirstThink()
	{
		ANIM_IDLE = "";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SpellMakerBase_OnGameSpawn(playerRace, playerGender); // monsters/companion/spell_maker_base
	}

	// svr_show_fx
	// ========= OLD SERVER SIDE METHOD
	void OnSvrShowFx()
	{
		// //dbg LIGHTning_maker Owner MY_OWNER Spell SPELL_TO_GRANT Item ITEM_CREATED_ME Dbg Height MY_SPAWN_HEIGHT
		float beamWidth = SkillOf(MY_OWNER, "spellcasting.lightning");
		beamWidth = int(beamWidth);

		int x = -64;
		int y = -64;
		float z = RelativePosition(Vector3(0, 0, 0)).z;
		float gnd = (GroundHeight(RelativePosition(Vector3(x, y, 250))) - z) * -1.0f;
		float temp = gnd - 64.0f;
		OnBeamSilent(Text(x), Text(y));

		x = 64;
		y = 64;
		z = RelativePosition(Vector3(0, 0, 0)).z;
		gnd = (GroundHeight(RelativePosition(Vector3(x, y, 250))) - z) * -1.0f;
		temp = gnd - 64.0f;
		OnBeamSilent(Text(x), Text(y));

		x = -64;
		y = 64;
		z = RelativePosition(Vector3(0, 0, 0)).z;
		gnd = (GroundHeight(RelativePosition(Vector3(x, y, 250))) - z) * -1.0f;
		temp = gnd - 64.0f;
		OnBeamSilent(Text(x), Text(y));

		x = 64;
		y = -64;
		z = RelativePosition(Vector3(0, 0, 0)).z;
		gnd = (GroundHeight(RelativePosition(Vector3(x, y, 250))) - z) * -1.0f;
		temp = gnd - 64.0f;
		OnBeamSilent(Text(x), Text(y));

		x = 0;
		y = 0;
		z = RelativePosition(Vector3(0, 0, 0)).z;
		gnd = (GroundHeight(RelativePosition(Vector3(x, y, 250))) - z) * -1.0f;
		temp = gnd - 64.0f;
		OnCenterBeam(Text(x), Text(y));
	}

	// beam_silent
	void OnBeamSilent(string origin = "", string angles = "")
	{
		float beamWidth = SkillOf(MY_OWNER, "spellcasting.lightning");
		beamWidth = int(beamWidth) * 8.0f;

		int groundLevel = -1000;
		int height = 1000;

		Effect("beam", "point", EFFECTS_SPRITE, beamWidth, RelativePosition(Vector3(Float(origin), Float(angles), 1000)), RelativePosition(Vector3(Float(origin), Float(angles), -1000)), Vector3(128, 128, 255), 64, 64, 2);
	}

	// center_beam
	void OnCenterBeam(string origin = "", string angles = "")
	{
		int beamWidth = 1600;

		int groundLevel = -1000;
		int height = 1000;

		Effect("beam", "point", C_FX_SPRITE, beamWidth, RelativePosition(Vector3(Float(origin), Float(angles), 1000)), RelativePosition(Vector3(Float(origin), Float(angles), -1000)), Vector3(255, 255, 255), 64, 64, 2);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpellMakerLightning_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "beam_silent") { OnBeamSilent(Param(params, 0), Param(params, 1)); return true; }
		if (name == "center_beam") { OnCenterBeam(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "svr_show_fx") { OnSvrShowFx(); return true; }
		return SpellMakerBaseScript::DispatchEvent(name, params);
	}
}
