#pragma context server

// Converted from monsters/zorc_archer2.script by msc_transpiler.
// Thothie - Zombie Orcs (not the ones used in mscave)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_sniper.as"

[script "monsters/zorc_archer2"]
class ZorcArcher2 : OrcSniperScript
{
	// Constants
	string NPC_BASE_EXP = "600";

	// Variables (an unset .script variable reads as its own name)
	bool DOING_KICK = false;
	bool KICK_TYPE = false;

	// Variables declared by included files, with the value they start with in this script
	ZorcArcher2()
	{
		DMG_BOW = 800;
		DMG_SMASH = "400";
		DMG_SWIPE = "200";
		DMG_KICK = "200";
		ARROW_TYPE = "proj_arrow_npc_dyn";
		SOUND_BOW = "monsters/archer/bow.wav";
	}

	// unnamed block (first think)
	void ZorcArcher2_FirstThink()
	{
		BO_ZOMBIE_MODE = true;
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		OrcSniper_OnOrcSpawn(); // monsters/orc_sniper

		SetHealth(6000);
		SetName("Undead Orc Archer");
		SetHearingSensitivity(2);
		SetDamageTaken("all", 0.8f);

		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1);
		SetDamageTaken("pierce", 0.5f);
		SetDamageTaken("cold", 0.25f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("fire", 1.25f);

		SetAnimFrameRate(0.75f);
		BASE_FRAMERATE = "0.75";

		SetRace("undead");

		DOING_KICK = false;
		KICK_TYPE = true;

		SetModelBody(0, 3); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 3); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 3); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild

		SetProp(ENT_ME, "skin", 1);
	}

	// set_turret
	void OnSetTurret()
	{
		OrcSniper_OnSetTurret(); // monsters/orc_sniper
		if (!Truthy(NO_STUCK_CHECKS)) // enforcer due to odd reset someplace
			CallEventDelayed(0.1f, "set_turret");
		SetMoveSpeed(0);
		BASE_MOVESPEED = 0.0f;
		SetMoveAnim(ANIM_IDLE);
		SetRoam(false);
		NO_STUCK_CHECKS = "1";
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
	}

	// ext_arrow_hit
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		if (RelationshipOf(hitEntity, ENT_ME) != "enemy")
			return;
		AddVelocity(hitEntity, RelativeVelocity(Vector3(0, 800, 110)));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ZorcArcher2_FirstThink();
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
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "set_turret") { OnSetTurret(); return true; }
		return OrcSniperScript::DispatchEvent(name, params);
	}
}
