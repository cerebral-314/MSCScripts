#pragma context server

// Converted from items/proj_poison_spell.script by msc_transpiler.
// Poison by Thothie (From /roj_spawner)

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_poison_spell"]
class ProjPoisonSpell : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "8";
	int ARROW_BODY_OFS = 8;
	string SOUND_BURN = "bullchicken/bc_acid1.wav";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.affliction";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 30;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjPoisonSpell()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "bullchicken/bc_acid1.wav";
		SOUND_HITWALL2 = "bullchicken/bc_acid1.wav";
		PROJ_DAMAGE_TYPE = "poison";
		PROJ_DAMAGE = "50";
		PROJ_COLLIDEHITBOX = 32;
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjPoisonSpell_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		CBaseEntity@ entHit = target;
		float poisonDamage = SkillOf(myOwner, "spellcasting.affliction") * 0.1f;
		if (poisonDamage < 0.1f)
			poisonDamage = 0.1f;
		float effectDuration = poisonDamage * 5.0f + 30.0f;
		string effectDurationText = Text(effectDuration);
		if (effectDuration > 120.0f)
		{
			effectDuration = 120.0f;
			effectDurationText = Text(effectDuration);
		}

		ApplyEffect(entHit, "effects/dot_poison", effectDurationText, @myOwner, poisonDamage, "spellcasting.affliction");
		return result;
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		ProjArrowBase_OnProjectileSpawn(); // items/proj_arrow_base

		SetName("Poisoner");
		SetWeight(500);
		SetValue(5);
		SetGravity(0);
		SetGroupable(25);

		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", ITEM_NAME);
		SetHand("any");
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 128, 100, 100);
	}

	// projectile_landed
	// end projectile_spawn
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base

		OnPoisonLanded();
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjPoisonSpell_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnPoisonLanded() {} // poison_landed

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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
