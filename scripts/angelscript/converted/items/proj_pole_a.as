#pragma context server

// Converted from items/proj_pole_a.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_pole_a"]
class ProjPoleA : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "70";
	int ARROW_BODY_OFS = 70;
	int ARROW_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 0;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	bool PROJ_COLLIDE = true;
	float PROJ_CLOUD_DURATION = 20.0f;

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	bool HIT_NPC = false;
	bool DID_SPAWN_CHECK = false;

	// Variables declared by included files, with the value they start with in this script
	ProjPoleA()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		ARROW_EXPIRE_DELAY = 0;
		SOUND_HITWALL1 = "weapons/xbow_hit1.wav";
		SOUND_HITWALL2 = "weapons/xbow_hit1.wav";
		PROJ_DAMAGE_TYPE = "acid";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		GAME_PVP = (IsPvp() ? 1 : 0);
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(0, 255, 0), 128, 1.5f);
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base
		bool doProj = false;

		if (HIT_NPC)
			return;
		if (DID_SPAWN_CHECK)
			return;
		DID_SPAWN_CHECK = true;

		float myPitch = AnglesOf(ENT_ME).x;

		// dbg game_projectile_landed MY_PITCH
		if (myPitch > 175.0f && myPitch < 360.0f)
			doProj = true;
		if (!doProj)
			return;

		if (ManaOf(ENT_EXPOWNER) < 20.0f)
			PlayerMessageDark(ENT_EXPOWNER, "Insuffcient mana for Afflictor.");

		if (!(ManaOf(ENT_EXPOWNER) >= 20.0f))
			return;
		GiveMana(ENT_EXPOWNER, -20);

		Vector3 myOrg = OriginOf(ENT_ME);
		float groundZ = GroundHeight(myOrg);
		float myZ = myOrg.z;
		// dbg game_projectile_landed MY_ORG vs GROUND_Z
		groundZ += 64.0f;

		// somewhere near the ground
		if (!(myZ < groundZ))
			return;
		groundZ -= 128.0f;
		if (!(myZ > groundZ))
			return;

		myOrg = OriginOf(ENT_ME);
		DebugPrint("game_projectile_landed " + Text(myOrg));
		groundZ = GroundHeight(myOrg);
		myOrg.z = groundZ;

		// ent_expowner
		// scriptflags <target> add <name> <type> [value:1] [expiretime:-1] [expiremsg:none]
		// $get_scriptflag(<target>,<type>,type_exists) - returns 1 if <type> found
		string fxId = ScriptFlag(ENT_EXPOWNER, "pole_a", "name_value");

		if (fxId == "none")
		{
			CreateNpc("monsters/summon/affliction_lance", myOrg, @EntityOf(ENT_EXPOWNER), myOrg, AnglesOf(ENT_ME), PROJ_CLOUD_DURATION); // <ownerId> <origin> <angles> <duration>
		}
		else
		{
			CallExternal(fxId, "transfer_location", myOrg);
		}
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		bool exitSub = false;

		HIT_NPC = true;

		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		if (RelationshipOf(target, ENT_EXPOWNER) != "enemy")
			return;

		float dmg = 800.0f;
		float ownerSkillRatio = SkillOf(ENT_EXPOWNER, "polearms") * 0.01f;
		dmg *= ownerSkillRatio;

		int pushStr = 800;

		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(ENT_EXPOWNER);
		float targAng = AnglesTo(myOrg, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, pushStr, 0)));

		float poisonDot = SkillOf(ENT_EXPOWNER, "spellcasting.affliction") * 0.5f;
		ApplyEffect(target, "effects/dot_acid", 5.0f, @EntityOf(ENT_EXPOWNER), poisonDot, "polearms");

		if (!IsAlive(target))
			return;
		DoDamageEx(@target, "direct", dmg, "100%", ENT_EXPOWNER, ENT_ME, "polearms", "acid");
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/affliction_lance");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Affliction Lance");
		SetDescription("You have been afflicted by this lance");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.8f);
		SetGroupable(25);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
