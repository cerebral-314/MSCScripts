#pragma context server

// Converted from monsters/sorc_archer3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_sniper.as"

[script "monsters/sorc_archer3"]
class SorcArcher3 : OrcSniperScript
{
	// Constants
	int DMG_AOE = 200;
	int ARROW_DAMAGE_LOW = 100;
	int ARROW_DAMAGE_HIGH = 200;
	bool AM_SORC = true;

	// Variables (an unset .script variable reads as its own name)
	bool DOING_KICK = false;
	bool KICK_TYPE = false;
	string ARROW_TARGET_LIST = "ARROW_TARGET_LIST";

	// Variables declared by included files, with the value they start with in this script
	SorcArcher3()
	{
		ARROW_TYPE = "proj_arrow_npc_dyn";
		FIN_EXP = 400;
		DROP_ITEM_BASE1 = "bows_swiftbow";
		CONTAINER_BASE = "chests/quiver_of_lightning";
	}

	// unnamed block (first think)
	void SorcArcher3_FirstThink()
	{
		DROP_GOLD_AMT = RandomInt(20, 60);
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		OrcBaseRanged_OnOrcSpawn(); // monsters/orc_base_ranged
		OrcSniper_OnOrcSpawn(); // monsters/orc_sniper

		SetHealth(800);
		// ov 180
		SetName("Elite Shadahar Archer");
		SetHearingSensitivity(10);
		SetStat("parry", 60);
		SetDamageTaken("all", 0.7f);
		SetRace("orc");

		SetModel("monsters/sorc.mdl");

		DOING_KICK = false;
		KICK_TYPE = true;

		SetModelBody(0, 3); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 3); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 2); // weapon: 0=unarmed 1=axe 2=bow_noarrow 3=bow_witharrow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
	}

	// ext_arrow_hit
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) - called from proj_arrow_npc_dyn
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		bool hitEnemy = false;

		Vector3 arrowPos = startPosition;
		bool targAlive = IsAlive(hitEntity);
		if (RelationshipOf(hitEntity, ENT_ME) == "enemy" && targAlive)
			hitEnemy = true;
		if (hitEnemy)
			arrowPos = OriginOf(hitEntity);
		arrowPos.z = GroundHeight(arrowPos);
		// <center_point> <radius> <light:0|1> <light_color>
		ClientEvent("new", "all", "effects/sfx_shock_burst", arrowPos, 128, 1, Vector3(255, 255, 0));
		// dodamage ARROW_ORG SKELE_ARROW_AOE DMG_AOE 100% 0 reflective lightning
		DoDamageEx(arrowPos, 128, DMG_AOE, 0, ENT_ME, ENT_ME, "none", "lightning_effect");

		ARROW_TARGET_LIST = LegacyFunction("get_tsphere", "enemy", 128, arrowPos);
		if (ARROW_TARGET_LIST == "none")
			return;
		int count = GetTokenCount(ARROW_TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnArrowAffectTargets();
		}
	}

	// arrow_affect_targets
	void OnArrowAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(ARROW_TARGET_LIST, loopIteration));
		ApplyEffect(curTarg, "effects/dot_lightning", 5.0f, self, 40);
		ARROW_MISSED = 0.0f;
	}

	// shoot_arrow
	void OnShootArrow()
	{
		float targetDist = RangeTo(ENT_LASTSEEN);
		Vector3 finalTarget = OriginOf(ENT_LASTSEEN);
		finalTarget += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, targetDist));
		targetDist = Divide(targetDist, 100.0f);
		SetAngle("add_view.pitch", targetDist);

		IS_ARROW = true;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(ARROW_TYPE, RelativePosition(Vector3(0, 0, 18)), "none", 900, DMG_BOW, ATTACK_CONE_OF_FIRE, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "ext_lighten", 0.4f, 1, Vector3(255, 255, 0));

		SetModelBody(2, 2); // Hide arrow
		PlaySound(2, 10, SOUND_BOW);

		MELEE_ATK = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/orc.mdl");
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcArcher3_FirstThink();
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
		if (name == "arrow_affect_targets") { OnArrowAffectTargets(); return true; }
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return OrcSniperScript::DispatchEvent(name, params);
	}
}
