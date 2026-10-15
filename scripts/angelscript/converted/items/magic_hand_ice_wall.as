#pragma context server

// Converted from items/magic_hand_ice_wall.script by msc_transpiler.
// Thothie - Increasing the mana drain on this to stop it being spammed on players
// - Better solution would be to make it so it can't be spawned within x units of a player
// - Or was killed by players by touch
// - Neither of which I can figure how to do :/

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_ice_wall"]
class MagicHandIceWall : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "600";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "cold";
	int SPELL_MPDRAIN = 25;
	string SPELL_STAT = "spellcasting.ice";
	string EFFECT_SCRIPT = "monsters/summon/summon_ice_wall";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 4;
	float ICE_WALLS = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandIceWall()
	{
		SOUND_SHOOT = "magic/ice_strike.wav";
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 75;
	}

	// unnamed block (first think)
	void MagicHandIceWall_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 4;
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

		ICE_WALLS += 1.0f;
		if (ICE_WALLS >= 0.0f)
			OwnerMessage("Too many ice walls present, cannot create more");
		if (!(ICE_WALLS < 0.0f))
			return;
		float ownerSkill = SkillOf(ENT_OWNER, "spellcasting.ice");
		CreateNpc(EFFECT_SCRIPT, pos, AnglesOf(ENT_OWNER).y, "firstcast", ownerSkill);
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Ice Wall");
		SetDescription("Ice Wall - Impede your opponents progress");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandIceWall_FirstThink();
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
