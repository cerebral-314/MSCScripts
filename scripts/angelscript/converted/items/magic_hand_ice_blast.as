#pragma context server

// Converted from items/magic_hand_ice_blast.script by msc_transpiler.
// Thothie - this thing does WAY too much damage, and is impossible to get at level 15
// - reducing damage and level
// - Seems more appropriate as fire than summon?
// - XP for this goes to null proficiency still :\

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_ice_blast"]
class MagicHandIceBlast : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "600";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "cold";
	int SPELL_MPDRAIN = 50;
	string SPELL_STAT = "none";
	string EFFECT_SCRIPT = "monsters/summon/ice_blast";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 18;

	// Variables declared by included files, with the value they start with in this script
	MagicHandIceBlast()
	{
		ANIM_CAST = "11";
		SOUND_SHOOT = "magic/frost_pulse.wav";
		SPELL_PREPARE_TIME = 1.0f;
		SPELL_ENERGYDRAIN = 1;
	}

	// unnamed block (first think)
	void MagicHandIceBlast_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 18; // will be 18
		PrecacheFile(EFFECT_SCRIPT);
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

		float freezeDuration = SkillOf(ENT_OWNER, "spellcasting.ice");
		if (freezeDuration < 10.0f)
			freezeDuration = 10.0f;
		if (freezeDuration > 20.0f)
			freezeDuration = 20.0f;

		// local FINAL_DEST PARAM2
		Vector3 ownerOrg = OriginOf(ENT_OWNER);
		Vector3 ownerAng = AnglesOf(ENT_OWNER);
		float ownerPitch = ownerAng.x;
		// if ( OWNER_PITCH < 0 ) add OWNER_PITCH 359
		ownerPitch = -ownerPitch;
		float ownerYaw = ownerAng.y;
		float ownerRoll = ownerAng.z;
		Vector3 ownerDest = endPosition;
		ownerDest += RelativePosition(Vector3(ownerPitch, ownerYaw, ownerRoll), Vector3(0, 20000, 0));

		// local LSTORM_MOVETO $get_traceline(OWNER_ORG,OWNER_DEST,worldonly)
		CreateNpc(EFFECT_SCRIPT, RelativePosition(Vector3(0, 32, 32)), @EntityOf(ENT_OWNER), freezeDuration, ownerDest, "spellcasting.ice");
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Freezing Sphere");
		SetDescription("A sphere of ice that freezes opponents");
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
		CallEventDelayed(0.7f, "bitem_set_can_idle");
		PlayViewAnim(17);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandIceBlast_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cast_start") { OnCastStart(); return true; }
		if (name == "cast_toss") { OnCastToss(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "start_spell_anim") { OnStartSpellAnim(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
