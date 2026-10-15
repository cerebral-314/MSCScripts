#pragma context server

// Converted from items/item_crystal_reloc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crystal.as"

[script "items/item_crystal_reloc"]
class ItemCrystalReloc : BaseCrystalScript
{
	// Variables (an unset .script variable reads as its own name)
	string OWNER_POS = "OWNER_POS";
	float BEAM_ROT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ItemCrystalReloc()
	{
		SKILL_TYPE = "skill.spellcasting";
	}

	// crystal_spawn
	void OnCrystalSpawn()
	{
		SetName("Crystal of Relocation");
		SetDescription("Once this crystal's magic is deployed it will define a new respawn point.");
		SetWeight(5); // some weight prevent over-stock
		SetValue(1000);
		SetHand("both");
	}

	// activate_crystal
	void OnActivateCrystal()
	{
		OWNER_POS = Text(OriginOf(ENT_OWNER));
		BEAM_ROT = 0.0f;
		CallExternal(EntityOf(ENT_OWNER), "set_spawn_point", OWNER_POS);

		for (int i = 0; i < 18; i++)
		{
			loopIteration = i;
			OnBeams();
		}

		PlaySound(0, 10, "magic/spawn.wav");
	}

	// beams
	void OnBeams()
	{
		Vector3 beamStart = Vec(OWNER_POS);
		Vector3 beamEnd = Vec(OWNER_POS);

		beamStart += RelativePosition(Vector3(0, BEAM_ROT, 0), Vector3(0, 32, -32));
		beamEnd += RelativePosition(Vector3(0, BEAM_ROT, 0), Vector3(0, 32, 128));
		Effect("beam", "point", "lgtning.spr", 100, beamStart, beamEnd, Vector3(255, 0, 255), 200, 16, 3);

		BEAM_ROT += 20.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "activate_crystal") { OnActivateCrystal(); return true; }
		if (name == "beams") { OnBeams(); return true; }
		if (name == "crystal_spawn") { OnCrystalSpawn(); return true; }
		return BaseCrystalScript::DispatchEvent(name, params);
	}
}
