#pragma context server

// Converted from monsters/skeleton_ravager_venom.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_ravager.as"

[script "monsters/skeleton_ravager_venom"]
class SkeletonRavagerVenom : SkeletonRavagerScript
{
	// Variables (an unset .script variable reads as its own name)
	int PASS_FREEZE_DMG = 0;
	float PASS_FREEZE_DUR = 0.0f;
	string BLOB_ORG = "BLOB_ORG";
	string GLOB_TARG = "GLOB_TARG";

	// Variables declared by included files, with the value they start with in this script
	SkeletonRavagerVenom()
	{
		NPC_BASE_EXP = "600";
		USES_PROJECTILE = true;
		PROJECTILE_SCRIPT = "proj_glob_guided";
		SOUND_PROJECTILE = "bullchicken/bc_attack3.wav";
		DMG_CLAW_EFFECT = "effects/dot_poison";
		DMG_CLAW_EFFECT_DUR = 10.0f;
		MONSTER_MODEL = "monsters/skeleton_ravenous_ele.mdl";
		SOUND_ALERT1 = "monsters/undeadz/c_skeltwar_bat1.wav";
		SOUND_ALERT2 = "monsters/undeadz/c_skeltwar_bat1.wav";
	}

	// unnamed block (first think)
	void SkeletonRavagerVenom_FirstThink()
	{
		PASS_FREEZE_DMG = 50;
		PASS_FREEZE_DUR = 5.0f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseJumper_OnNpcatkHunt(); // monsters/base_jumper
		SkeletonRavager_OnNpcatkHunt(); // monsters/skeleton_ravager
		GLOB_TARG = NPCATK_TARGET;
	}

	// skele_spawn
	void OnSkeleSpawn()
	{
		SkeletonRavager_OnSkeleSpawn(); // monsters/skeleton_ravager
		SetName("Venomboned Ravager");
		SetModelBody(0, 2);
		SetModel(MONSTER_MODEL);
		SetHealth(4000);
		SetWidth(32);
		SetHeight(72);
		SetRace("undead");
		SetBlood("none");
		SetDamageTaken("fire", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("blunt", 1.5f);
		SetDamageTaken("slash", 1);
		SetDamageTaken("pierce", 0.75f);
		SetDamageTaken("lightning", 1.5f);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 2);
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// ext_glob_landed
	// <origin> - from items/proj_glob_dynamic
	void OnExtGlobLanded(string origin = "")
	{
		BLOB_ORG = origin;
		DoDamageEx(origin, 96, "DMG_GLOB", 0.2f, ENT_ME, ENT_ME, "none", "acid_effect", "dmgevent:glob");
	}

	// glob_dodamage
	void OnGlobDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		Vector3 targOrg = OriginOf(target);
		float blobDist = Divide(Distance(Vec(BLOB_ORG), targOrg), 64.0f);
		float blobDistRatio = 1.0f - blobDist;
		float blindDuration = Ratio(blobDistRatio, 2, 6); // blind 2-6 seconds based on how direct the hit was
		DebugPrint("glob_dodamage " + Text(blindDuration));
		ApplyEffect(target, "effects/dot_poison_blind", blindDuration, self, DMG_CLAW_EFFECT_DOT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("claw.spr");
		Precache("monsters/skeleton_ravenous_ele.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonRavagerVenom_FirstThink();
		SkeletonRavager_FirstThink();
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
		if (name == "ext_glob_landed") { OnExtGlobLanded(Param(params, 0)); return true; }
		if (name == "glob_dodamage") { OnGlobDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "skele_spawn") { OnSkeleSpawn(); return true; }
		return SkeletonRavagerScript::DispatchEvent(name, params);
	}
}
