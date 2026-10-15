#pragma context server

// Converted from items/proj_snow_ball2.script by msc_transpiler.
// Thothie - AOE probably not working, AOE names to not match up with proj_base
// - couple other var names not matching up as well :\
// Catabult Ball

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_snow_ball2"]
class ProjSnowBall2 : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 9;
	string MODEL_BODY_OFS = "9";
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	int PROJ_AOE_RANGE = 200;
	float PROJ_AOE_FALLOFF = 1.0f;

	// Variables (an unset .script variable reads as its own name)
	bool DID_ICE_SPIKES = false;
	bool DMG_SET = false;
	string DMG_ICE = "DMG_ICE";
	int ICE_RADIUS = 0;
	int ICE_AMT = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjSnowBall2()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "fire.wav";
		SOUND_HITWALL2 = "fire.wav";
		PROJ_DAMAGE_TYPE = "siege";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ProjSnowBall2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");

		if (!hit)
			return result;

		CallExternal(target, "hit_by_siege");
		return result;
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		if (DID_ICE_SPIKES)
			return;
		OnIceSpikes(OriginOf(target));
	}

	// projectile_landed
	void OnProjectileLanded()
	{
		ProjArrowBase_OnProjectileLanded(); // items/proj_arrow_base
		if (DID_ICE_SPIKES)
			return;
		OnIceSpikes(OriginOf(ENT_ME));
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Ice Boulder");
		SetDescription("A giant rock");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0.4f);
		SetGroupable(25);
	}

	// ice_spikes
	void OnIceSpikes(Vector3 position = Vector3())
	{
		float dmgIce = Float(DMG_ICE);
		float iceRadius = ICE_RADIUS;
		float iceAmt = ICE_AMT;
		DID_ICE_SPIKES = true;
		Effect("screenshake", position, 100, 5, 3, 500);

		string spriteDest = Text(position);
		spriteDest = Text(Vec(spriteDest) + Vector3(0.0f, 0.0f, 32.0f));
		Effect("tempent", "trail", "blueflare1.spr", position, spriteDest, 2, 0.1f, 9, 30, 0);

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);

		if (!DMG_SET)
		{
			dmgIce = SkillOf(myOwner, "spellcasting.ice");
			iceRadius = SkillOf(myOwner, "spellcasting.ice") * 10.0f;
			iceAmt = 10.0f + dmgIce;
		}
		// PARAM1 dmg PARAM2 Radius PARAM3 #spikes
		Vector3 spawnPos = position;
		float myGround = GroundHeight(spawnPos);
		spawnPos.z = myGround;
		CreateNpc("monsters/summon/ice_spikes", spawnPos, @myOwner, dmgIce, iceRadius, iceAmt, "spellcasting.ice");

		CallEventDelayed(0.1f, "vanish");
	}

	// set_dmg
	// ext call <dmg> <radius> <amt> <gravity>
	void OnSetDmg(string dmg = "", int radius = 0, int amt = 0, float gravity = 0.0f)
	{
		DMG_SET = true;
		DMG_ICE = dmg;
		ICE_RADIUS = radius;
		ICE_AMT = amt;
		SetGravity(gravity);
	}

	// vanish
	void OnVanish()
	{
		DeleteMe();
	}

	// hitwall
	void OnHitwall()
	{
		PlaySound(Int(Eval("const.snd.body")), Eval("const.snd.fullvol"), "fire.wav");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ProjSnowBall2_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rockgibs.mdl");
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "hitwall") { OnHitwall(); return true; }
		if (name == "ice_spikes") { OnIceSpikes(Vec(Param(params, 0))); return true; }
		if (name == "projectile_landed") { OnProjectileLanded(); return true; }
		if (name == "set_dmg") { OnSetDmg(Param(params, 0), Int(Param(params, 1)), Int(Param(params, 2)), Float(Param(params, 3))); return true; }
		if (name == "vanish") { OnVanish(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
