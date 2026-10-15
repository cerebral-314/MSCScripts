#pragma context server

// Converted from items/magic_hand_conjure_venom_claws.script by msc_transpiler.
// Conjures venom claws on the wielder

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_conjure_venom_claws"]
class MagicHandConjureVenomClaws : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "0";
	float MELEE_ATK_DURATION = 1.0f;
	int SPELL_MPDRAIN = 40;
	string SPELL_STAT = "spellcasting.affliction";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 20;

	// Variables declared by included files, with the value they start with in this script
	MagicHandConjureVenomClaws()
	{
		MELEE_DMG_DELAY = 0.9f;
		SPELL_PREPARE_TIME = 1.0f;
	}

	// unnamed block (first think)
	void MagicHandConjureVenomClaws_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 20;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		if (SkillOf(ENT_OWNER, "spellcasting.affliction") >= 27.0f)
		{
			OwnerMessage("Your affliction level strengthens the claws...");
			CreateNpc("monsters/companion/spell_maker_base", Vector3(1000, 1000, 10000), @EntityOf(ENT_OWNER), "blunt_gauntlets_fe2", "none", "none", "none");
		}
		else
		{
			CreateNpc("monsters/companion/spell_maker_base", Vector3(1000, 1000, 10000), @EntityOf(ENT_OWNER), "blunt_gauntlets_fe1", "none", "none", "none");
		}

		DeleteMe();
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Conjure Venom Claws");
		SetDescription("A venomous imbuement of your fists.");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandConjureVenomClaws_FirstThink();
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
