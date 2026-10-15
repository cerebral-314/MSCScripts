#pragma context server

// Converted from helena/orcwarboss_ghost.script by msc_transpiler.
// Thothie - Provided for backwards compatability with MS 1.35
// - Guess who's back :D
// - He can be given Infernal Fire Damage or Invulnerability (toggle) via ms_npcscript send:
// - warboss_godon - invincible
// - warboss_godoff - vulnerable
// - warboss_infernal - fire damage +30-60
// - warboss_normal - removes fire damage
// - Note name changes with mode, if you want to have both modes on, consider which you'd rather have

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base.as"

[script "helena/orcwarboss_ghost"]
class OrcwarbossGhost : OrcBaseScript
{
	// Constants
	string ATTACK_ACCURACY = "80%";
	float ATTACK_DMG_LOW = 5.0f;
	float ATTACK_DMG_HIGH = 150.0f;
	int ORC_SHIELD = 0;

	// Variables (an unset .script variable reads as its own name)
	int INFERNAL = 0;
	string DROP_ITEM1 = "DROP_ITEM1";

	// unnamed block (first think)
	void OrcwarbossGhost_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(50, 250);
		NPC_GIVE_EXP = 200.0f;

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
		FLINCH_CHANCE = "35%";

		DROP_ITEM1 = "axes_greataxe";
		DROP_ITEM1_CHANCE = "100%";
		INFERNAL = 0;
	}

	// unnamed block (first think)
	// Manually porting orc_melee include for safty
	void OrcwarbossGhost_FirstThink2()
	{
		MOVE_RANGE = "64";
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 225.0f;
	}

	// swing_axe
	// Deal damage
	// Called from the animation on the attack frame
	void OnSwingAxe()
	{
		OnBaseorcYell();

		float dmg = Random(ATTACK_DMG_LOW, ATTACK_DMG_HIGH);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, dmg, ATTACK_ACCURACY);

		if (INFERNAL == 1)
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_fire", 5, ENT_ME, RandomInt(30, 60));
	}

	// swing_sword
	void OnSwingSword()
	{
		OnSwingAxe();
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		SetHealth(1250);
		// ov 360
		SetWidth(32);
		SetHeight(60);
		SetName("Ghost Graznux the Warboss");
		SetHearingSensitivity(8);
		SetStat("parry", 30);
		SetStat("swordsmanship", 10, 25, 20);
		SetDamageTaken("all", 0.8f);
		SetInvincible(false);

		// thothie experiments
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 200);

		SetModelBody(0, 2); // Body 0=naked 2=leather 3=plate 4=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 5); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// warboss_godoff
	void OnWarbossGodoff()
	{
		SetName("Graznux the Warboss");
		SetInvincible(false);
		SetSayTextRange(1024);
		SayText("What have you done to me!?");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcwarbossGhost_FirstThink();
		OrcwarbossGhost_FirstThink2();
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
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "warboss_godoff") { OnWarbossGodoff(); return true; }
		return OrcBaseScript::DispatchEvent(name, params);
	}
}
