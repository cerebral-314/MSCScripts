#pragma context server

// Converted from items/proj_arrow_phx.script by msc_transpiler.
// Projectile for Phoenix Bow. CrazyMonkeyDude Oct 2009
// Checks for distance from owner and adjusts blast radius and damage accordingly
// Fire DOT increases fire skill

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_arrow_phx"]
class ProjArrowPhx : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "48";
	int ARROW_BODY_OFS = 48;
	string PROJ_ANIM_IDLE = "idle_standard";
	int MAX_DIST = 1024;
	int MIN_RADIUS = 32;
	int MAX_RADIUS = 256;
	string SOUND_PHOENIX = "monsters/birds/hawkcaw.wav";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	bool IS_UNDERSKILLED = false;
	string TARGET_LIST = "TARGET_LIST";
	float BURN_DMG = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjArrowPhx()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		MODEL_HANDS = "weapons/projectiles.mdl";
		PROJ_IGNORENPC = true;
		PROJ_DAMAGE = "1";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ProjBase_OnGameSpawn(playerRace, playerGender); // items/proj_base

		SetName("Phoenix Arrow");

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", "ITEM_NAME");
		SetHand("any");

		GAME_PVP = (IsPvp() ? 1 : 0);
		SetGravity(1);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		// Thothie: Sound on launch - follows arrow
		ServerPlaySound(0, 5, SOUND_PHOENIX);
	}

	// game_projectile_hitwall
	// Thothie: Switch from _landed to _hitwall - for some stupid reason _landed is only going off when it strikes an NPC
	void OnGameProjectileHitwall()
	{
		ProjBase_OnGameProjectileHitwall(); // items/proj_base
		ProjArrowBase_OnGameProjectileHitwall(); // items/proj_arrow_base
		float myDamage;
		string myDamageText;
		float myRadius;

		Vector3 userOrg = OriginOf(ENT_EXPOWNER);
		Vector3 myOrg = OriginOf(ENT_ME);
		myOrg.z = GroundHeight(myOrg);
		float distanceTraveled = Distance(userOrg, myOrg);
		float distanceRatio = distanceTraveled;
		string distanceRatioText;

		// Damage
		float ownerSkill = SkillOf(ENT_EXPOWNER, "archery.power");
		string minDmg = Text(ownerSkill);
		float maxDmg = ownerSkill * 3.0f;
		string maxDmgText = Text(maxDmg);

		// Thothie: Optimization, merge these two conditionals
		if (distanceTraveled >= MAX_DIST)
		{
			myDamage = maxDmg;
			myDamageText = maxDmgText;
			myRadius = MAX_RADIUS;
		}
		else
		{
			distanceRatio = Divide(distanceRatio, MAX_DIST);
			distanceRatioText = Text(distanceRatio);
			myDamageText = LegacyFunction("get_skill_ratio", distanceRatioText, minDmg, maxDmgText);
			myDamage = Float(myDamageText);
			myRadius = Float(LegacyFunction("get_skill_ratio", distanceRatioText, MIN_RADIUS, MAX_RADIUS));
		}

		if (IsPlayer(ENT_EXPOWNER) && SkillOf(ENT_EXPOWNER, "archery") < 25.0f)
		{
			IS_UNDERSKILLED = true;
			myDamage *= 0.1f;
			myDamageText = Text(myDamage);
			myRadius *= 0.5f;
		}

		// Thothie: Client fx, self-removing (see items/proj_arrow_phx_cl)
		// - note you do NOT need to add proj_arrow_phx_cl to the items list - as it is not an item
		// - The paramaters after the script name pass to the client script's "client_activate" event
		ClientEvent("new", "all", "items/proj_arrow_phx_cl", myOrg, myRadius);

		// Thothie: This report is for balancing purposes
		DebugPrint("game_projectile_hitwall dmg " + myDamageText + " rad " + Text(myRadius));

		DoDamageEx(myOrg, myRadius, myDamageText, 0, ENT_EXPOWNER, ENT_EXPOWNER, "archery", "fire");

		TARGET_LIST = FindInSphere("any", myRadius);

		// Burn
		if (TARGET_LIST == "none")
			return;

		// Thothie: Optimization, as discussed, only need to check skill once
		BURN_DMG = SkillOf(ENT_EXPOWNER, "spellcasting.fire") * 0.5f;

		if (IS_UNDERSKILLED)
			BURN_DMG *= 0.1f;

		int count = GetTokenCount(TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurnThem();
		}
	}

	// burn_them
	void OnBurnThem()
	{
		bool exitSub = false;
		string curTarget = GetToken(TARGET_LIST, loopIteration);
		if (RelationshipOf(ENT_EXPOWNER, curTarget) != "enemy")
			return;
		if (IsPlayer(ENT_EXPOWNER) && GAME_PVP == 0 && IsPlayer(curTarget))
			exitSub = true;
		if (exitSub)
			return;

		// Thothie: Pass parameter fixed, as discussed ( ent_expowner to $get(ent_expowner,id) )
		ApplyEffect(curTarget, "effects/dot_fire", 5, @EntityOf(ENT_EXPOWNER), BURN_DMG, "archery");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("monsters/birds/hawkcaw.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burn_them") { OnBurnThem(); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
