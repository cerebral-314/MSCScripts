#pragma context server

// Converted from monsters/orc_demonic_sniper.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_sniper.as"

[script "monsters/orc_demonic_sniper"]
class OrcDemonicSniper : OrcSniperScript
{
	// Constants
	int DMG_AOE = 400;
	float DOT_DMG = 30.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = false;
	Vector3 ARROW_ORG = Vector3();

	// Variables declared by included files, with the value they start with in this script
	OrcDemonicSniper()
	{
		ARROW_TYPE = "proj_arrow_npc_dyn";
		DMG_SMASH = "$rand(50,100)";
		DMG_SWIPE = "$rand(20,50)";
		DMG_KICK = "$rand(20,50)";
		DROP_ITEM_BASE1 = "none";
		CONTAINER_BASE = "chests/quiver_of_fire";
		FIN_EXP = 200;
	}

	// unnamed block (first think)
	void OrcDemonicSniper_FirstThink()
	{
		DROPS_CONTAINER = 1;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		SetName("Demonic Blackhand Archer");
		SetProp(ENT_ME, "skin", 2);
		SetWidth(32);
		SetHeight(60);
		SetHealth(400);
		SetHearingSensitivity(2);
		SetStat("parry", 30);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("holy", 0.5f);
		IS_UNHOLY = true;

		SetModelBody(0, 3); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild

		CallEventDelayed(1.0f, "reset_range"); // debug
		CallEventDelayed(2.0f, "finalize_npc");
	}

	// finalize_npc
	void OnFinalizeNpc()
	{
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(100, 200);
		DROP_ITEM1 = DROP_ITEM_BASE1;
		DROP_ITEM1_CHANCE = "0%";
	}

	// ext_arrow_landed
	void OnExtArrowLanded(Vector3 origin = Vector3())
	{
		ARROW_ORG = origin;
		// <center_point> <radius> <light:0|1> <light_color>
		ClientEvent("new", "all", "effects/sfx_fire_burst", ARROW_ORG, 128, 1, Vector3(255, 0, 0));
		DoDamageEx(ARROW_ORG, 128, DMG_AOE, 0, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:fireburst");
	}

	// ext_arrow_hit
	// direct hit
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		if (!Truthy(hit))
			return;
		if (RelationshipOf(hitEntity, ENT_ME) != "enemy")
			return;
		ApplyEffect(hitEntity, "effects/dot_fire", 5.0f, self, DOT_DMG);
		AddVelocity(hitEntity, RelativeVelocity(Vector3(0, 600, 110)));
	}

	// fireburst_dodamage
	void OnFireburstDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_DMG);

		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = ARROW_ORG;
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 500, 110)));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcDemonicSniper_FirstThink();
		OrcSniper_FirstThink();
		OrcBaseRanged_FirstThink();
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
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "ext_arrow_landed") { OnExtArrowLanded(Vec(Param(params, 0))); return true; }
		if (name == "finalize_npc") { OnFinalizeNpc(); return true; }
		if (name == "fireburst_dodamage") { OnFireburstDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		return OrcSniperScript::DispatchEvent(name, params);
	}
}
