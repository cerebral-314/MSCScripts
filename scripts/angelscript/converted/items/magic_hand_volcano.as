#pragma context server

// Converted from items/magic_hand_volcano.script by msc_transpiler.
// Thothie - this thing does WAY too much damage, and is impossible to get at level 15
// - reducing damage and level
// - Seems more appropriate as fire than summon?
// - XP for this goes to null proficiency still :\

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_volcano"]
class MagicHandVolcano : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "600";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 4.0f;
	string SPELL_DAMAGE_TYPE = "fire";
	int SPELL_MPDRAIN = 80;
	string SPELL_STAT = "spellcasting.fire";
	int EFFECT_MAXDURATION = 30;
	float EFFECT_MINDURATION = 8.0f;
	float EFFECT_DURATION_STAT = 0.0f;
	string EFFECT_DURATION = "EFFECT_DURATION";
	string EFFECT_SCRIPT = "monsters/summon/summon_volcano";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 15;
	float EFFECT_DMG = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandVolcano()
	{
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 200;
	}

	// unnamed block (first think)
	void MagicHandVolcano_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 15;

		EFFECT_DMG = SkillOf(ENT_OWNER, "spellcasting.fire");
		// multiply EFFECT_DMG 2.0
		EFFECT_DMG += 100.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
		MagicHandBase_OnGamePrecache(); // items/magic_hand_base
		PrecacheFile(EFFECT_SCRIPT);
	}

	// bitem_set_can_idle
	void OnBitemSetCanIdle()
	{
		BaseItem_OnBitemSetCanIdle(); // items/base_item

		DeleteMe();
	}

	// cast_start
	void OnCastStart()
	{
		MagicHandBase_OnCastStart(); // items/magic_hand_base

		SetVar("baseitem.canidle", 0);
		OnStartSpellAnim();
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		// local pow $get(ent_owner,skill.spellcasting.power) //These do nothing.
		// local con $get(ent_owner,stat.concentration)
		Vector3 pos = endPosition;
		float temp = GroundHeight(pos);
		float x = pos.x;
		float y = pos.y;
		pos = Vector3(x, y, temp);

		CreateNpc(EFFECT_SCRIPT, pos, @EntityOf(ENT_OWNER), EFFECT_DMG, EFFECT_DURATION, "spellcasting.fire");
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Summon Volcano");
		SetDescription("A magical weapon of mass destruction");
	}

	// cast_toss
	// If ranged
	void OnCastToss()
	{
		OnSpellCasted();
		PlayOwnerAnim("critical", PLAYERANIM_CAST, "squatwalk1");
	}

	// start_spell_anim
	void OnStartSpellAnim()
	{
		CallEventDelayed(1.0f, "bitem_set_can_idle");
		PlayViewAnim(16);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandVolcano_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bitem_set_can_idle") { OnBitemSetCanIdle(); return true; }
		if (name == "cast_start") { OnCastStart(); return true; }
		if (name == "cast_toss") { OnCastToss(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "start_spell_anim") { OnStartSpellAnim(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
