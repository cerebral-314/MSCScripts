#pragma context server

// Converted from items/proj_volcano_svr.script by msc_transpiler.
// Volcano projectile

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_base.as"

[script "items/proj_volcano_svr"]
class ProjVolcanoSvr : ProjBaseScript
{
	// Constants
	string SOUND_HITWALL1 = "weapons/bow/arrowhit1.wav";
	string SOUND_HITWALL2 = "weapons/bow/arrowhit1.wav";
	string SOUND_BURN = "items/torch1.wav";
	string ITEM_NAME = "firemana";
	string PROJ_ANIM_IDLE = "idle_standard";
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;
	string PROJ_DAMAGESTAT = "spellcasting.fire";
	int PROJ_AOE_RANGE = 128;
	float LIGHT_RADIUS = 64.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	float LIGHT_DURATION = 0.8f;

	// Variables (an unset .script variable reads as its own name)
	string MY_LIGHT_IDX = "MY_LIGHT_IDX";

	// Variables declared by included files, with the value they start with in this script
	ProjVolcanoSvr()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_MOTIONBLUR = false;
	}

	// projectile_spawn
	void ProjVolcanoSvr_OnProjectileSpawn()
	{
		SetName("Volcanic fireball");
		SetGravity(Random(0.3f, 0.6f));
		LegacyCommand("useable", 0);

		SetModel("none");
	}

	// game_dodamage
	string ProjVolcanoSvr_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		float dmgFire = 0.0f;
		string result = "";

		if (hit)
			return result;

		// effect glow ent_laststruckbyme (255,75,0) 128 1 1
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", "proj_volcano struck " + NameOf(ENT_LASTSTRUCKBYME));

		CBaseEntity@ fMyOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(fMyOwner);

		if (IsPlayer(target) && ownerIsplayer && !IsPvp())
			exitSub = true;
		if (exitSub)
			return result;

		if (ownerIsplayer)
		{
			dmgFire = SkillOf(fMyOwner, "spellcasting.fire") * 2.0f;
			ApplyEffect(target, "effects/dot_fire", 5, @fMyOwner, dmgFire, "spellcasting.fire");
		}
		if (!ownerIsplayer)
		{
			dmgFire = Float(ScriptVarOf(fMyOwner, "DMG_VOLCANO"));
			int useDot = Int(ScriptVarOf(fMyOwner, "DMG_VOLCANO_DOT"));
			if (Text(dmgFire) == "DMG_VOLCANO")
				dmgFire = 50.0f;

			if (Contains(NameOf(target), "Garonhroth")) // more likely to finish Lord BS off with volcano
				dmgFire = 500.0f;
			if (useDot == 0)
				CallExternal("MY_OWNER", "send_damage", @target, "direct", dmgFire, "100%", @fMyOwner, "fire");
			else
				ApplyEffect(target, "effects/dot_fire", 10, @fMyOwner, dmgFire, "spellcasting.fire");
		}

		// callexternal $get(ent_expowner,id) set_fire_to "exp_owner" 5 F_MY_OWNER DMG_FIRE
		ClientEvent("remove", "all", MY_LIGHT_IDX);
		return result;
	}

	// projectile_spawn
	void ProjVolcanoSvr_OnProjectileSpawn_2()
	{
		ClientEvent("new", "all", "items/proj_volcano_svr", OriginOf(ENT_ME), LIGHT_RADIUS, LIGHT_COLOR, LIGHT_DURATION);
		MY_LIGHT_IDX = LastClientScriptId();
	}

	// projectile_spawn
	void OnProjectileSpawn()
	{
		ProjVolcanoSvr_OnProjectileSpawn();
		ProjVolcanoSvr_OnProjectileSpawn_2();
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		SetAngle("face", Vector3(0, 0, 0));
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 20, "DURATION", 256);
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjVolcanoSvr_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// game_removed
	void OnGameRemoved()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", "proj_volcano_svr game_removed");
		ClientEvent("remove", "all", MY_LIGHT_IDX);
	}

	// game_removefromowner
	void OnGameRemovefromowner()
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", "proj_volcano_svr game_removefromowner");
		ClientEvent("remove", "all", MY_LIGHT_IDX);
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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_removed") { OnGameRemoved(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "projectile_spawn") { OnProjectileSpawn(); return true; }
		return ProjBaseScript::DispatchEvent(name, params);
	}
}
