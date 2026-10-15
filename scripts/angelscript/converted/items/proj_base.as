#pragma context server

// Converted from items/proj_base.script by msc_transpiler.
// Removed CLIENT_PROJECTILE support. (Client side arrows that used "cleffect ce") //greatguys1@JAN2022
// Thothie - These reg's do not match up with the documented Scripting_Items.txt
// - Not entirely sure if they all work
// - Adding hitwall function in here (many projtiles using game_hitwall - which turns out to be wrong)
// Base Projectile
// 1:32 PM 2/11/2005
// Req. Variables:
// PROJ_STICK_DURATION
// PROJ_DAMAGE

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ProjBase
{
	// Constants
	int PROJ_COLLIDEHITBOX = 1;
	bool PROJ_IGNORENPC = false;
	string MODEL_WORLD = "none";
	bool PROJ_MOTIONBLUR = true;
	bool PROJ_STICK_ON_NPC = true;
	string CLFX_ARROW_SCRIPT = "items/proj_simple_cl";
	float CLFX_ARROW_UPDATE_RATE = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ MY_XBOW = null;
	bool CLFX_ARROW_IN_FLIGHT = false;
	bool PROJ_DELETING = false;
	string BOLT_TRACE_END = "BOLT_TRACE_END";
	bool BP_HIT_TARGET = false;
	bool CLFX_ARROW_INIT = false;
	string CLFX_ARROW_IDX = "CLFX_ARROW_IDX";

	// game_spawn
	void ProjBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		LegacyCommand("movetype", "projectile"); // Causes the orientation to change based on velocity

		if (!Truthy(GetVar("CLFX_ARROW")))
		{
			SetModel(MODEL_WORLD);

			if (GetVar("PROJ_ANIM_IDLE") != "PROJ_ANIM_IDLE" && GetVar("PROJ_ANIM_IDLE") != "none")
				PlayAnim(GetVar("PROJ_ANIM_IDLE"));

			if (GetVar("MODEL_BODY_OFS") != "MODEL_BODY_OFS")
			{
				// //dbg temp setting ofs MODEL_BODY_OFS
				SetModelBody(0, Int(GetVar("MODEL_BODY_OFS")));
			}
		}
		else
		{
			// CLFX_ARROW 1 - creates a client side model for the arrow, but still tracks the arrow server side
			SetBoundingBox("npcsize");
			SetModel("none");
		}

		if (!Truthy(GetVar("HITSCAN_BOLT")))
			SetLocal("reg.proj.dmg", PROJ_DAMAGE);
		else
			SetLocal("reg.proj.dmg", 0);
		if (Truthy(GetVar("HEAVY_ONLY")))
			SetLocal("reg.proj.dmg", PROJ_DAMAGE);
		SetLocal("reg.proj.dmgtype", PROJ_DAMAGE_TYPE);
		SetLocal("reg.proj.aoe.range", GetVar("PROJ_AOE_RANGE"));
		SetLocal("reg.proj.aoe.falloff", GetVar("PROJ_AOE_FALLOFF"));
		SetLocal("reg.proj.stick.duration", GetVar("PROJ_STICK_DURATION")); // this is commented out in code, no effect
		SetLocal("reg.proj.collidehitbox", PROJ_COLLIDEHITBOX); // this is a boolean, decides if to use projectile's hitbox or not
		SetLocal("reg.proj.ignorenpc", PROJ_IGNORENPC); // collide only with world, pass through NPCs if set 1

		LegacyCommand("registerprojectile");

		OnProjectileSpawn();
	}

	// game_fall
	void ProjBase_OnGameFall()
	{
		if (GetVar("MODEL_BODY_OFS") != "MODEL_BODY_OFS")
		{
			// //dbg temp setting ofs MODEL_BODY_OFS
			SetModelBody(0, Int(GetVar("MODEL_BODY_OFS")));
		}
	}

	// game_tossprojectile
	void ProjBase_OnGameTossprojectile()
	{
		if (Truthy(GetVar("CLFX_ARROW")))
			CallEventDelayed(0.01f, "update_clfx_projectile");

		// dbg game_tossprojectile $get(ent_me,itemname)
		@MY_XBOW = ActiveItemOf(ENT_EXPOWNER);

		// setvard MY_OWNER $get(ent_expowner,id)
		if (GetVar("MODEL_BODY_OFS") != "MODEL_BODY_OFS")
		{
			// //dbg temp setting ofs MODEL_BODY_OFS
			if (!Truthy(GetVar("CLFX_ARROW")))
				SetModelBody(0, Int(GetVar("MODEL_BODY_OFS")));
		}
		LegacyCommand("useable", 0); // Can't be picked up after it's shot/tossed
		if (PROJ_MOTIONBLUR && !Truthy(GetVar("CLFX_ARROW")))
			ClientEvent("new", "all_in_sight", "effects/sfx_motionblur", IndexOf(ENT_ME), GetVar("MODEL_BODY_OFS"));
		OnGameFall();

		if (Truthy(GetVar("HITSCAN_BOLT")))
			OnHitscanBolt();
	}

	// game_projectile_landed
	void ProjBase_OnGameProjectileLanded()
	{
		DebugPrint("game_projectile_landed");

		if (Truthy(GetVar("CLFX_ARROW")))
		{
			CLFX_ARROW_IN_FLIGHT = false;
			ClientEvent("update", "all", CLFX_ARROW_IDX, "end_fx", "landed");
		}

		LegacyCommand("movetype", "none"); // Back to normal movement
		if (!Truthy(GetVar("PROJ_STICK_ON_WALL_NEW")))
		{
			LegacyCommand("expiretime", 0);
		}
		else
		{
			// expiretime PROJ_STICK_DURATION
			SetModel(MODEL_WORLD);
			SetModelBody(0, Int(GetVar("MODEL_BODY_OFS")));
			LegacyCommand("solidifyprojectile");
		}

		OnProjectileLanded();

		if (Float(GetVar("PROJ_STICK_DURATION")) == 0.0f)
			OnRemoveProjectile("landed");
		if (Float(GetVar("PROJ_STICK_DURATION")) > 0.0f)
			CallEventOrDelay(GetVar("PROJ_STICK_DURATION"), "remove_projectile");
	}

	// game_touch
	// { ext_touch
	// dbg ext_touch PARAM1
	// projectiletouch PARAM1
	// }
	string ProjBase_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!Truthy(GetVar("PROJ_REMOVE_ON_USE")))
			return result;
		if (PROJ_DELETING)
			return result;
		DebugPrint(NameOf(other));
		if (IsKeyDown(other, "use"))
		{
			PROJ_DELETING = true;
			PlaySound(0, 10, GetVar("SOUND_HITWALL1"));
			OnRemoveProjectile("touch_used");
		}
		if (IsPlayer(other))
			return result;
		PROJ_DELETING = true;
		OnRemoveProjectile("touch_remove");
		ClientEvent("update", "all", CLFX_ARROW_IDX, "ext_touch", IndexOf(other));
		return result;
	}

	// game_projectile_hitwall
	// Event fixed and should now remove arrow properly //greatguys1@FEB2022
	void ProjBase_OnGameProjectileHitwall()
	{
		PlayRandomSound(Int(Eval("game.sound.weapon")), GetVar("HITWALL_VOL"), GetVar("SOUND_HITWALL1"), GetVar("SOUND_HITWALL2"));

		if (Float(GetVar("PROJ_STICK_DURATION")) == 0.0f)
			OnRemoveProjectile("hitwall");
	}

	// ext_lighten
	// param1 = gravity, called externally
	void ProjBase_OnExtLighten(string gravity = "", int glowFlag = 0, Vector3 glowColor = Vector3(), string scale = "")
	{
		SetGravity(Float(gravity));
		if (Truthy(GetVar("CLFX_ARROW")))
			ClientEvent("update", "all", CLFX_ARROW_IDX, "ext_lighten", gravity);
	}

	// ext_scale
	void ProjBase_OnExtScale(float ratio = 0.0f, int noBoundingFix = 0, int noRangeFix = 0)
	{
		SetProp(ENT_ME, "scale", ratio);
		if (Truthy(GetVar("CLFX_ARROW")))
			ClientEvent("update", "all", CLFX_ARROW_IDX, "ext_scale", ratio);
	}

	// hitscan_bolt
	void ProjBase_OnHitscanBolt()
	{
		bool exitSub = false;

		if (Truthy(GetVar("HEAVY_ONLY")))
		{
			exitSub = true;
			if (Contains(NameOf(MY_XBOW), "Heavy"))
			{
				exitSub = false;
				SetGravity(0);
			}
			// dbg adjusting for heavy
			if (Contains(NameOf(MY_XBOW), "Steam"))
			{
				exitSub = false;
				SetGravity(0);
			}
		}
		// dbg adjusting for heavy
		if (exitSub)
			return;

		Vector3 startTrace = OriginOf(ENT_ME);
		Vector3 vMyDest = RelativePosition(Vector3(-Float(Eval("game.monster.angles.pitch")), Float(Eval("game.monster.angles.yaw")), Float(Eval("game.monster.angles.roll"))), Vector3(0, 8000, 0));
		Vector3 myDest = startTrace + vMyDest;

		// debug beam
		// effect beam point lgtning.spr 20 START_TRACE MY_DEST (255,0,255) 200 0 3
		string hitTarg = LegacyFunction("get_traceline", startTrace, myDest, "npc");

		if (hitTarg == EntityId(EntityOf(ENT_EXPOWNER)))
		{
			exitSub = true;
			CallEventDelayed(0.01f, "hitscan_bolt");
		}
		if (exitSub)
			return;

		float myDamage = SkillOf(ENT_EXPOWNER, "archery") * 0.01f * Float(PROJ_DAMAGE);
		int dmgMulti = Int(ScriptVarOf(MY_XBOW, "HITSCAN_DMG_MULTI"));
		if (dmgMulti > 0)
			myDamage *= dmgMulti;

		if (!IsAlive(hitTarg))
		{
			SetOrigin(ENT_ME, Vec(hitTarg));
			BOLT_TRACE_END = LegacyFunction("get_traceline", startTrace, myDest, "worldonly");
			DoDamageEx(startTrace, myDest, myDamage, "100%", ENT_EXPOWNER, ENT_ME, "archery", PROJ_DAMAGE_TYPE, "dmgevent:*bolt");
		}

		if (IsAlive(hitTarg))
		{
			SetOrigin(ENT_ME, OriginOf(hitTarg));
			OnStrikeTarget(hitTarg);
		}
	}

	// strike_target
	void ProjBase_OnStrikeTarget(string target = "")
	{
		if (BP_HIT_TARGET)
			return;
		BP_HIT_TARGET = true;

		SetOrigin(ENT_ME, OriginOf(target));

		float myDamage = SkillOf(ENT_EXPOWNER, "archery") * 0.01f * Float(PROJ_DAMAGE);
		int dmgMulti = Int(ScriptVarOf(MY_XBOW, "HITSCAN_DMG_MULTI"));
		if (dmgMulti > 0)
			myDamage *= dmgMulti;
		// dbg hit $get(MY_XBOW,name) : $get(PARAM1,name) for MY_DAMAGE with PROJ_DAMAGE_TYPE ( skill $get(MY_OWNER,skill.archery) )
		DoDamageEx(target, "direct", myDamage, "100%", ENT_EXPOWNER, ENT_EXPOWNER, "archery", PROJ_DAMAGE_TYPE);

		if (!PROJ_STICK_ON_NPC)
			OnRemoveProjectile("strike_target");
	}

	// game_projectile_hitnpc
	// { game_dodamage
	// setorigin ent_me PARAM4 //This causes an issue where xdodamage will make the arrow stick to other entities. //greatguys1@JAN2022
	// }
	// tracelin and projectile touch work different
	void ProjBase_OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		// dbg game_projectile_hitnpc $get(PARAM1,name)
		if (Truthy(GetVar("CLFX_ARROW")))
		{
			CLFX_ARROW_IN_FLIGHT = false;
			ClientEvent("update", "all", CLFX_ARROW_IDX, "ext_hitnpc", IndexOf(target));
		}

		if (!Truthy(GetVar("HITSCAN_BOLT")))
			return;
		OnStrikeTarget(EntityId(target));
	}

	// remove_projectile
	void ProjBase_OnRemoveProjectile(string fxIndex = "")
	{
		if (GetVar("CLFX_ARROW") != "CLFX_ARROW")
		{
			CLFX_ARROW_IN_FLIGHT = false;
			if (Truthy(GetVar("CLFX_ARROW_NOSTICK")))
				ClientEvent("update", "all", CLFX_ARROW_IDX, "end_fx", fxIndex);
		}

		LegacyCommand("expiretime", 0);
		DeleteMe();
	}

	// update_clfx_projectile
	void ProjBase_OnUpdateClfxProjectile()
	{
		// these have to be assembled and sent, as there's no actual model for client to grab info from
		if (!CLFX_ARROW_INIT)
		{
			CLFX_ARROW_INIT = true;
			CLFX_ARROW_IN_FLIGHT = true;

			Vector3 infoTokens = Vec(TokenAdd(Text(OriginOf(ENT_ME)), Text(AnglesOf(ENT_ME))));
			infoTokens = Vec(TokenAdd(Text(infoTokens), Text(VelocityOf(ENT_ME))));
			infoTokens = Vec(TokenAdd(Text(infoTokens), Text(int(Float(GetVar("PROJ_ANIM_IDLE"))))));
			infoTokens = Vec(TokenAdd(Text(infoTokens), GetProp(ENT_ME, "gravity")));
			infoTokens = Vec(TokenAdd(Text(infoTokens), Text(PROJ_STICK_ON_NPC)));

			string modelBodyOfs = GetVar("MODEL_BODY_OFS");
			if (GetVar("MODEL_BODY_OFS") == "MODEL_BODY_OFS")
				modelBodyOfs = "0";
			// dbg game_tossprojectile using clfx - L_ANIM_IDX
			ClientEvent("new", "all", CLFX_ARROW_SCRIPT, IndexOf(ENT_ME), IndexOf(ENT_EXPOWNER), infoTokens, MODEL_WORLD, modelBodyOfs, PROJ_MOTIONBLUR, "CLFX_ARROW_TAGS");
			CLFX_ARROW_IDX = LastClientScriptId();
			CallEventDelayed(CLFX_ARROW_UPDATE_RATE, "update_clfx_projectile");
		}
		else if (CLFX_ARROW_IN_FLIGHT)
		{
			ClientEvent("update", "all", CLFX_ARROW_IDX, "ext_update", OriginOf(ENT_ME), AnglesOf(ENT_ME), VelocityOf(ENT_ME));
			CallEventDelayed(CLFX_ARROW_UPDATE_RATE, "update_clfx_projectile");
		}
	}

	// ext_render
	// <rendermode> <renderamt>
	void ProjBase_OnExtRender(int renderMode = 0, int renderAmount = 0)
	{
		SetProp(ENT_ME, "rendermode", renderMode);
		SetProp(ENT_ME, "renderamt", renderAmount);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ProjBase_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		ProjBase_OnGameFall();
	}

	void OnGameTossprojectile() { ProjBase_OnGameTossprojectile(); } // game_tossprojectile
	void OnGameProjectileLanded() { ProjBase_OnGameProjectileLanded(); } // game_projectile_landed
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return ProjBase_OnGameTouch(other, hpRange, effectDamage); } // game_touch
	void OnGameProjectileHitwall() { ProjBase_OnGameProjectileHitwall(); } // game_projectile_hitwall
	void OnExtLighten(string gravity = "", int glowFlag = 0, Vector3 glowColor = Vector3(), string scale = "") { ProjBase_OnExtLighten(gravity, glowFlag, glowColor, scale); } // ext_lighten
	void OnExtScale(float ratio = 0.0f, int noBoundingFix = 0, int noRangeFix = 0) { ProjBase_OnExtScale(ratio, noBoundingFix, noRangeFix); } // ext_scale
	void OnHitscanBolt() { ProjBase_OnHitscanBolt(); } // hitscan_bolt
	void OnStrikeTarget(string target = "") { ProjBase_OnStrikeTarget(target); } // strike_target
	void OnGameProjectileHitnpc(CBaseEntity@ target = null) { ProjBase_OnGameProjectileHitnpc(target); } // game_projectile_hitnpc
	void OnRemoveProjectile(string fxIndex = "") { ProjBase_OnRemoveProjectile(fxIndex); } // remove_projectile
	void OnUpdateClfxProjectile() { ProjBase_OnUpdateClfxProjectile(); } // update_clfx_projectile
	void OnExtRender(int renderMode = 0, int renderAmount = 0) { ProjBase_OnExtRender(renderMode, renderAmount); } // ext_render
	void OnClfxArrowUpdateRate() {} // CLFX_ARROW_UPDATE_RATE
	void OnProjStickDuration() {} // PROJ_STICK_DURATION
	void OnProjectileLanded() {} // projectile_landed
	void OnProjectileSpawn() {} // projectile_spawn

	// This file's events and timers by their .script names
	bool ProjBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "ext_lighten") { OnExtLighten(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "ext_render") { OnExtRender(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "ext_scale") { OnExtScale(Float(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "hitscan_bolt") { OnHitscanBolt(); return true; }
		if (name == "remove_projectile") { OnRemoveProjectile(Param(params, 0)); return true; }
		if (name == "strike_target") { OnStrikeTarget(Param(params, 0)); return true; }
		if (name == "update_clfx_projectile") { OnUpdateClfxProjectile(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/proj_base"]
shared class ProjBaseScript : BaseItemExtrasScript, ProjBase
{
	// Variables every script that includes this file declares
	string MODEL_HANDS = "MODEL_HANDS";
	string PROJ_DAMAGE = "PROJ_DAMAGE";
	string PROJ_DAMAGE_TYPE = "PROJ_DAMAGE_TYPE";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ProjBase_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
