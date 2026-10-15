#pragma context server

// Converted from dq/voldararcher.script by msc_transpiler.
// Voldar's Rangers

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_sniper.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Voldararcher
{
	// Constants
	string ARROW_TYPE = "proj_arrow_gpoison";
	string NPC_DEATH_MSG = "You have slain one of Voldar's rangers";

	// Variables (an unset .script variable reads as its own name)
	bool DOING_KICK = false;
	bool KICK_TYPE = false;
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	bool IS_ARROW = false;

	// orc_spawn
	void Voldararcher_OnOrcSpawn()
	{
		SetProp(ENT_ME, "skin", 3);

		SetHealth(220);
		// ov 180
		SetName("Voldar's Ranger");
		SetHearingSensitivity(2);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);

		DOING_KICK = false;
		KICK_TYPE = true;

		SetModelBody(0, 3); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// npc_post_spawn
	void Voldararcher_OnNpcPostSpawn()
	{
		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_gpoison";
	}

	// shoot_arrow
	void Voldararcher_OnShootArrow()
	{
		bool exitSub = false;

		if (Truthy(LegacyFunction("cansee", "enemy", KICK_RANGE)))
		{
			PlayAnim("break");
			DOING_KICK = false;
			KICK_TYPE = true;
			OnDoKick();
			exitSub = true;
		}
		if (exitSub)
			return;

		float targetDist = RangeTo(ENT_LASTSEEN);
		Vector3 finalTarget = OriginOf(ENT_LASTSEEN);
		finalTarget += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, targetDist));
		targetDist = Divide(targetDist, 100.0f);
		SetAngle("add_view.pitch", targetDist);

		float lclAtkdmg = Random(0, 0);

		IS_ARROW = true;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		TossProjectile(ARROW_TYPE, RelativePosition(Vector3(0, 0, 18)), ENT_LASTSEEN, ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none"); // Converted to use new tossprojectile //greatguys1@FEB2022
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f);

		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, 10, SOUND_BOW);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		OrcSniper_OnOrcSpawn(); // monsters/orc_sniper
		Voldararcher_OnOrcSpawn();
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		OrcBase_OnNpcPostSpawn(); // monsters/orc_base
		OrcSniper_OnNpcPostSpawn(); // monsters/orc_sniper
		OrcSniper_OnNpcPostSpawn_2(); // monsters/orc_sniper
		Voldararcher_OnNpcPostSpawn();
	}

	void OnShootArrow() { Voldararcher_OnShootArrow(); } // shoot_arrow
	void OnDoKick() {} // do_kick

	// This file's events and timers by their .script names
	bool Voldararcher_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/voldararcher"]
shared class VoldararcherScript : OrcSniperScript, Voldararcher
{
	// Variables declared by included files, with the value they start with in this script
	VoldararcherScript()
	{
		ARROW_TYPE = "proj_arrow_gpoison";
		NPC_DEATH_MSG = "You have slain one of Voldar's rangers";
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Voldararcher_DispatchEvent(name, params)
			|| OrcSniperScript::DispatchEvent(name, params);
	}
}
