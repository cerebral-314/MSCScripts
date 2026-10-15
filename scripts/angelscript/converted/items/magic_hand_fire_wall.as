#pragma context server

// Converted from items/magic_hand_fire_wall.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_fire_wall"]
class MagicHandFireWall : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "500";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 4.0f;
	string SPELL_DAMAGE_TYPE = "fire";
	int SPELL_MPDRAIN = 30;
	string SPELL_STAT = "spellcasting.fire";
	int EFFECT_MAXDURATION = 30;
	float EFFECT_MINDURATION = 0.5f;
	float EFFECT_DURATION_STAT = 0.0f;
	string EFFECT_DURATION = "EFFECT_DURATION";
	int EFFECT_MAX_DMG = 10;
	float EFFECT_MIN_DMG = 0.1f;
	float EFFECT_DMG = 0.0f;
	string EFFECT_SCRIPT = "monsters/summon/summon_fire_wall";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 13;

	// Variables declared by included files, with the value they start with in this script
	MagicHandFireWall()
	{
		SOUND_SHOOT = "magic/fireball_powerup.wav";
		SOUND_CHARGE = "magic/fireball_strike.wav";
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 50;
	}

	// unnamed block (first think)
	void MagicHandFireWall_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 13;
		PrecacheFile(EFFECT_SCRIPT);
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		Vector3 pos = endPosition;
		pos = Vector3(pos.x, pos.y, GroundHeight(pos));

		int fireDuration = 15; // Duration must be constant due to client side effect method in summon script
		float fireDamage = SkillOf(ENT_OWNER, "spellcasting.fire") * 0.5f;

		CreateNpc(EFFECT_SCRIPT, pos, @EntityOf(ENT_OWNER), AnglesOf(ENT_OWNER).y, fireDamage, fireDuration, "spellcasting.fire");
		DeleteEntity(ENT_ME); // prevents spam
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Fire wall");
		SetDescription("A wall of searing fire to trap your opponents");
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, SOUND_CHARGE);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		Precache("magic/fireball_strike.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandFireWall_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
