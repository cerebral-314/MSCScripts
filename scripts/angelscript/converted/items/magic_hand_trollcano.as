#pragma context server

// Converted from items/magic_hand_trollcano.script by msc_transpiler.
// Thothie - this thing does WAY too much damage, and is impossible to get at level 15
// - reducing damage and level
// - Seems more appropriate as fire than summon?
// - XP for this goes to null proficiency still :\

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_trollcano"]
class MagicHandTrollcano : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "600";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "fire";
	int SPELL_MPDRAIN = 1;
	string SPELL_STAT = "spellcasting.fire";
	int EFFECT_MAXDURATION = 30;
	float EFFECT_MINDURATION = 8.0f;
	float EFFECT_DURATION_STAT = 1.0f;
	string EFFECT_DURATION = "20";
	int EFFECT_MAX_DMG = 10;
	float EFFECT_MIN_DMG = 3.0f;
	string EFFECT_SCRIPT = "monsters/summon/volcano_troll";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 1;

	// Variables declared by included files, with the value they start with in this script
	MagicHandTrollcano()
	{
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 200;
	}

	// unnamed block (first think)
	void MagicHandTrollcano_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 1;
		PrecacheFile(EFFECT_SCRIPT);
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		Vector3 pos = endPosition;
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);
		CreateNpc(EFFECT_SCRIPT, pos, @EntityOf(ENT_OWNER));
		DeleteEntity(ENT_ME); // prevents volcano spam
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Trollcano");
		SetDescription("Trollllololol");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandTrollcano_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
