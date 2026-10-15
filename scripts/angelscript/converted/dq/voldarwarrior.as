#pragma context server

// Converted from dq/voldarwarrior.script by msc_transpiler.
// Thothie - Provided for backwards compatability with MS 1.35
// - Not quite such a free kill anymore nor as generous with gold
// - Does not roam, useful if you need a fairly mean orc who stays still
// - Warning about this guy: If attacked from behind while idle, he wont fight back, so place him with his back to a wall
// - Voldar's Henchment have Poison Blades

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base.as"

[script "dq/voldarwarrior"]
class Voldarwarrior : OrcBaseScript
{
	// Constants
	string ATTACK_ACCURACY = "80%";
	float ATTACK_DMG_LOW = 10.0f;
	float ATTACK_DMG_HIGH = 20.0f;
	int ORC_SHIELD = 0;

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";
	string ANIM_ATTACK2 = "ANIM_ATTACK2";

	// Variables declared by included files, with the value they start with in this script
	Voldarwarrior()
	{
		NPC_DEATH_MSG = "You have slain one of Voldar's henchmen";
	}

	// unnamed block (first think)
	void Voldarwarrior_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(15, 35);
		NPC_GIVE_EXP = 80.0f;
		DROP_ITEM1 = "swords_poison1"; // Used by base_monster
		DROP_ITEM1_CHANCE = "10%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
		ANIM_ATTACK2 = "swordswing1_L"; // Attack animation 2
		FLINCH_CHANCE = "55%";
	}

	// unnamed block (first think)
	// manually including monsters/orc_base_melee for edit
	// Orc base melee
	void Voldarwarrior_FirstThink2()
	{
		MOVE_RANGE = "64";
		ATTACK_RANGE = 72.0f;
		ATTACK_HITRANGE = 128.0f;
	}

	// orc_spawn
	void Voldarwarrior_OnOrcSpawn()
	{
		SetWidth(40);
		SetHeight(90);
	}

	// orc_spawn
	void Voldarwarrior_OnOrcSpawn_2()
	{
		SetProp(ENT_ME, "skin", 3);

		SetHealth(250);
		// fov 360
		SetWidth(32);
		SetHeight(60);
		SetName("Voldar's Henchman");
		SetHearingSensitivity(8);
		SetStat("parry", 15);
		SetStat("swordsmanship", 10, 25, 20);
		SetDamageTaken("all", 0.8f);
		SetRoam(false);

		SetModelBody(0, 0); // Body 0=naked 2=leather 3=plate 4=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 4); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		Voldarwarrior_OnOrcSpawn();
		Voldarwarrior_OnOrcSpawn_2();
	}

	// swing_axe
	// Deal damage
	// Called from the animation on the attack frame
	void OnSwingAxe()
	{
		OnBaseorcYell();
		float dmg = Random(ATTACK_DMG_LOW, ATTACK_DMG_HIGH);
		DoDamageEx(ENT_LASTSEEN, ATTACK_HITRANGE, dmg, ATTACK_ACCURACY, ENT_ME, ENT_ME, "none", "slash", "dmgevent:swing");
	}

	// swing_sword
	void OnSwingSword()
	{
		OnSwingAxe();
	}

	// swing_dodamage
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		ApplyEffect(target, "effects/dot_poison", 5, self, RandomInt(5, 10));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Voldarwarrior_FirstThink();
		Voldarwarrior_FirstThink2();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return OrcBaseScript::DispatchEvent(name, params);
	}
}
