#pragma context server

// Converted from monsters/morc_icewarrior.script by msc_transpiler.
// Marogar (Polar) Ice warrior, from Orc Warrior, by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_base_melee.as"
#include "converted/monsters/orc_base.as"

[script "monsters/morc_icewarrior"]
class MorcIcewarrior : OrcBaseScript, OrcBaseMelee
{
	// Constants
	string ATTACK_ACCURACY = "75%";
	float ATTACK_DMG_LOW = 30.0f;
	float ATTACK_DMG_HIGH = 120.0f;
	string SOUND_ICEATK = "debris/beamstart14.wav";

	// Variables (an unset .script variable reads as its own name)
	string DROP_ITEM1 = "DROP_ITEM1";
	float FX_ATK = 0.0f;

	// unnamed block (first think)
	void MorcIcewarrior_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(15, 30);
		NPC_GIVE_EXP = 120.0f;
		DROP_ITEM1 = "swords_liceblade"; // Used by base_monster
		DROP_ITEM1_CHANCE = "5%"; // Used by base_monster

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseMelee_OnOrcSpawn(); // monsters/orc_base_melee

		SetHealth(500);
		// ov 180
		SetName("Marogar Ice Warrior");
		SetHearingSensitivity(5);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0.1f);

		FX_ATK = 1.0f;
		SetModel("monsters/morc.mdl");

		SetModelBody(0, 2); // Body 0=topless+skirt 1=topless+pants 2=brestplate 3=whitefurhide
		SetModelBody(1, 2); // Head 0=cap_shorthorn 1=cap_spike 2=wbuffo_skin 3=cheif_ramhorns 4=wletherhood
		SetModelBody(2, 4); // Weapon 0=fist 1=axe 2=wood_bow 3=icebow 4=icesword 5=iceaxe
	}

	// swing_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	void OnSwingDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		FX_ATK += 1.0f;

		if (FX_ATK > 3.0f)
			FX_ATK = 1.0f;

		if (!hit)
			return;

		if (!(RangeTo(target) <= ATTACK_HITRANGE))
			return;

		if (FX_ATK != 3.0f)
			return;

		PlaySound(Int(GetVar("CHAN_BODY")), 8, SOUND_ICEATK);

		ApplyEffect(target, "effects/dot_cold", RandomInt(3, 5), ENT_ME, RandomInt(5, 10));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		OrcBaseMelee_OnNpcatkTargetvalidate(target); // monsters/orc_base_melee
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		OrcBase_OnNpcatkTargetvalidate(target); // monsters/orc_base
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		OrcBaseMelee_OnMyTargetDied(offender); // monsters/orc_base_melee
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
	}

	void OnBaseorcYell() { OrcBase_OnBaseorcYell(); } // baseorc_yell

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/morc.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcIcewarrior_FirstThink();
		OrcBaseMelee_FirstThink();
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
		if (name == "swing_dodamage") { OnSwingDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return OrcBaseMelee_DispatchEvent(name, params)
			|| OrcBaseScript::DispatchEvent(name, params);
	}
}
