#pragma context server

// Converted from monsters/orc_demonic_shaman.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orc_shaman_fire.as"

[script "monsters/orc_demonic_shaman"]
class OrcDemonicShaman : OrcShamanFireScript
{
	// Constants
	float DOT_DMG = 50.0f;
	int DMG_DEATH_BURST = 400;
	bool ORC_SHAMAN_CUSTOM_DEATH = true;
	bool ORC_SHAMAN_CUSTOM_FIREBALL = true;

	// Variables (an unset .script variable reads as its own name)
	string PROJ_ELEMENT_TYPE = "PROJ_ELEMENT_TYPE";
	bool IS_UNHOLY = false;
	string SPLODIE_TARGS = "SPLODIE_TARGS";
	string PROJ_ELEMENT_TARGET = "PROJ_ELEMENT_TARGET";

	// Variables declared by included files, with the value they start with in this script
	OrcDemonicShaman()
	{
		FIRE_BALL_DAMAGE_NORM = "$rand(100,150)";
		PROJECTILE_SCRIPT = "proj_elemental_guided";
		SOUND_DEATH = "weapons/explode3.wav";
	}

	// unnamed block (first think)
	void OrcDemonicShaman_FirstThink()
	{
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(50, 100);
		NPC_GIVE_EXP = 300.0f;
		PROJ_ELEMENT_TYPE = "fire_jet";
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("effects/sfx_explode");
	}

	// throw_fireball
	void OnThrowFireball()
	{
		OrcShamanFire_OnThrowFireball(); // monsters/orc_shaman_fire
		CallEventDelayed(FIRE_BALL_FREQ, "reset_fireball");
		FIRE_BALL_DELAY = true;
		PlaySound(0, 10, SOUND_FIRESHOOT);
		PROJ_ELEMENT_TARGET = NPCATK_TARGET;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJECTILE_SCRIPT, RelativePosition(Vector3(0, 48, 18)), NPCATK_TARGET, ATTACK_SPEED, FIRE_BALL_DAMAGE, ATTACK_CONE_OF_FIRE, "none");
	}

	// orc_shaman_death
	void OnOrcShamanDeath()
	{
		OrcShamanFire_OnOrcShamanDeath(); // monsters/orc_shaman_fire
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		ClientEvent("remove", "all", MY_CL_SCRIPT_IDX);

		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 256, DMG_DEATH_BURST, 0.1f, ENT_ME, ENT_ME, "none", "generic");
		ClientEvent("new", "all", "effects/sfx_explode", OriginOf(ENT_ME), 256);
		Effect("tempent", "gibs", "fleshgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, 50, 50, 15, 10.0f);
		SPLODIE_TARGS = FindInSphere("enemy", 256);
		if (SPLODIE_TARGS == "none")
			return;
		int count = GetTokenCount(SPLODIE_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSplodieAffectTargets();
		}
	}

	// orc_spawn
	void OnOrcSpawn()
	{
		SetHealth(420);
		// ov 180
		SetName("Demonic Orc Fire Shaman");
		SetProp(ENT_ME, "skin", 2);
		SetWidth(32);
		SetHeight(60);
		SetHearingSensitivity(8);
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("holy", 0.5f);
		IS_UNHOLY = true;

		FIRE_BALL_DAMAGE = FIRE_BALL_DAMAGE_NORM;

		ClientEvent("persist", "all", FIRE_FIST_SCRIPT, IndexOf(ENT_ME), 19);
		MY_CL_SCRIPT_IDX = LastClientScriptId();

		// giveitem item_torch
		SetModelBody(0, 0); // Body 0=naked 1=leather 2=plate 3=green-hide
		SetModelBody(1, 4); // Head 0=cap_shorthorn 1=cap_nohorn 2=buffo_skin 3=cheif_ramhorns 4=green_hood
		SetModelBody(2, 0); // Weapon 0=fist 1=axe 2=bow_weak 3=bow_strng 4=sword 5=bloodyaxe 6=sword&sheild
	}

	// ext_proj_elemental_hit
	// <origin> <type>
	void OnExtProjElementalHit(Vector3 origin = Vector3(), string element = "")
	{
		DoDamageEx(origin, 128, FIRE_BALL_DAMAGE, 0, ENT_ME, ENT_ME, "none", "fire_effect", "dmgevent:fireburst");
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
		string myOrg = "ARROW_ORG";
		float targAng = AnglesTo(Vec(myOrg), targOrg);
		int newYaw = int(targAng);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 500, 110)));
	}

	// splodie_affect_targets
	void OnSplodieAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SPLODIE_TARGS, loopIteration));
		if (RelationshipOf(curTarg, ENT_ME) == "enemy")
			ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_DMG);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0)));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("fleshgibs.mdl");
		Precache("monsters/orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcDemonicShaman_FirstThink();
		OrcShamanFire_FirstThink();
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
		if (name == "ext_proj_elemental_hit") { OnExtProjElementalHit(Vec(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "fireburst_dodamage") { OnFireburstDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "orc_shaman_death") { OnOrcShamanDeath(); return true; }
		if (name == "orc_spawn") { OnOrcSpawn(); return true; }
		if (name == "splodie_affect_targets") { OnSplodieAffectTargets(); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		return OrcShamanFireScript::DispatchEvent(name, params);
	}
}
