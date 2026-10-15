#pragma context server

// Converted from monsters/skeleton_archer_ice2.script by msc_transpiler.
// Nastier of the ice archers

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_archer_base.as"

[script "monsters/skeleton_archer_ice2"]
class SkeletonArcherIce2 : SkeletonArcherBaseScript
{
	// Constants
	string SKELE_ARROW_EFFECT = "effects/dot_cold";
	bool SKELE_ARROW_EFFECT_HANDLED = true;
	int SKELE_ARROW_AOE = 128;
	int SKELE_DOT_DMG = 50;
	float SKELE_DOT_DUR = 5.0f;
	bool SKELE_ARROW_GLOW = true;
	Vector3 SKELE_ARROW_GLOW_COLOR = Vector3();
	int C_SKELE_ARROW_KNOCKBACK = 800;
	bool SKELE_DROPS_CONTAINER = true;
	string SKELE_CONTAINER_SCRIPT = "chests/quiver_of_frost";
	string SKELE_DROPS_CONTAINER_CHANCE = "100%";
	bool SKELE_ARROW_ARC = true;
	string ARROW_CL_SCRIPT = "effects/sfx_ice_burst";
	int DMG_AOE = 200;
	string FREEZE_DUR = "8.0";

	// Variables declared by included files, with the value they start with in this script
	SkeletonArcherIce2()
	{
		DMG_ARROW = 400;
		DMG_SWIPE = "80";
		C_SKELE_PUSH_STRENGTH = 600;
		SKELE_GOLD = 100;
		SKELE_START_LIVES = 1;
		SKELE_ARROW_SPEED = 500;
	}

	// unnamed block (first think)
	void SkeletonArcherIce2_FirstThink()
	{
		// base stats
		NPC_GIVE_EXP = 800.0f;
	}

	// unnamed block (timer)
	void SkeletonArcherIce2_Timer()
	{
		CallEventDelayed(15.1f, "SkeletonArcherIce2_Timer");
		// renew light 10/secs (light is now self-removing)
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 128, 15.0f);
	}

	// npc_post_spawn
	// glow
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(128, 128, 255), 128, 15.0f);
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SetName("Ancient Frozen Archer");
		SetHealth(3000);

		SetDamageTaken("fire", 1.25f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("holy", 1.25f);
		SetHeight(80);
		SetWidth(30);

		SetModelBody(0, 5); // 0=Classic 1=Dark 2=Poison 3=Fire 4=Gore 5=Ice 6=Gold 7=Stone 8=Royal_ice 9=Bright_Fire 10=Greek_Armor
		SetModelBody(1, 10); // 0=Unarmed 1=Mace 2=Sword 3=Hammers 4=Sword+Shield 5=Ice_Clubs 6=Fire_Clubs 7=Big_Sword 8=Wand 9=Wand_Glow 10=Bow
		SetModelBody(2, 0); // 0=Hide_Arrow 1=Show_arrow
	}

	// skele_arrow_fx
	void OnSkeleArrowFx(string arrowOrigin = "")
	{
		// <center_point> <radius> <light:0|1> <light_color>
		ClientEvent("new", "all", ARROW_CL_SCRIPT, arrowOrigin, 128, 1, Vector3(0, 0, 255));
		DoDamageEx(arrowOrigin, SKELE_ARROW_AOE, DMG_AOE, 0, ENT_ME, ENT_ME, "none", "cold_effect");
	}

	// skele_handle_effect
	void OnSkeleHandleEffect(CBaseEntity@ target = null)
	{
		ApplyEffect(target, "effects/dot_cold_freeze", FREEZE_DUR, self, SKELE_DOT_DMG);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
		CallEventDelayed(15.1f, "SkeletonArcherIce2_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonArcherIce2_FirstThink();
		SkeletonArcherBase_FirstThink();
		SkeletonArcherBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SkeletonArcherBase_FirstThink3();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "skele_arrow_fx") { OnSkeleArrowFx(Param(params, 0)); return true; }
		if (name == "skele_handle_effect") { OnSkeleHandleEffect(EntityParam(params, 0)); return true; }
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		if (name == "SkeletonArcherIce2_Timer") { SkeletonArcherIce2_Timer(); return true; }
		return SkeletonArcherBaseScript::DispatchEvent(name, params);
	}
}
