#pragma context server

// Converted from items/proj_crescent.script by msc_transpiler.
// tempt at guided

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_crescent"]
class ProjCrescent : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "0";
	int ARROW_BODY_OFS = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "spin_vertical_fast";
	int PROJ_STICK_DURATION = 0;
	float FWD_SPEED = 400.0f;
	string SOUND_SPIN = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	float NEXT_DAMAGE = 0.0f;
	int GAME_PVP = 0;
	string CRE_TYPE = "CRE_TYPE";
	string CRE_EFFECT_SCRIPT = "CRE_EFFECT_SCRIPT";
	string CRE_EFFECT_SKILL = "CRE_EFFECT_SKILL";
	float CRE_EFFECT_RATIO = 0.0f;
	string CRE_EFFECT_NAME = "CRE_EFFECT_NAME";
	float CRE_EFFECT_DURATION = 0.0f;
	bool IS_ACTIVE = false;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float DMG_AMT = 0.0f;
	string USE_SKILL = "USE_SKILL";
	Vector3 START_ANG = Vector3();
	float PLR_CRE_HAND = 0.0f;
	float SWIRVE_CYCLE = 0.0f;
	float NEXT_ACQUIRE = 0.0f;
	Vector3 START_POS = Vector3();
	string CL_IDX = "CL_IDX";
	string NPCATK_TARGET = "NPCATK_TARGET";
	float TARG_HALF_HEIGHT = 0.0f;
	float NEXT_ANGLE_UPDATE = 0.0f;
	bool DID_LAND = false;

	// Variables declared by included files, with the value they start with in this script
	ProjCrescent()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal1.wav";
		PROJ_DAMAGE_TYPE = "slash";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_COLLIDEHITBOX = 0;
		PROJ_IGNORENPC = true;
	}

	// game_touch
	string ProjCrescent_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		bool exitSub = false;
		string result = "";
		// dbg game_touch $get(PARAM1,name)
		if (!(GameTime() > NEXT_DAMAGE))
			return result;
		NEXT_DAMAGE = GameTime() + 0.1f;
		DoDamageEx(@other, "direct", DMG_AMT, "100%", ENT_EXPOWNER, ENT_EXPOWNER, USE_SKILL, CRE_TYPE);

		if (!IsPlayer(ENT_EXPOWNER)) // monsters handle this on their script side
			return result;
		if (CRE_TYPE == "slash")
			return result;
		if (IsPlayer(other) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;
		if (HasEffect(other, CRE_EFFECT_NAME))
			return result;
		float dotAmt = Float(GetProp(ENT_EXPOWNER, CRE_EFFECT_SKILL));
		dotAmt *= CRE_EFFECT_RATIO;
		ApplyEffect(other, CRE_EFFECT_SCRIPT, CRE_EFFECT_DURATION, @EntityOf(ENT_EXPOWNER), dotAmt, "smallarms");
		return result;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		DebugPrint("game_tossprojectile");
		GAME_PVP = (IsPvp() ? 1 : 0);
		CRE_TYPE = ScriptVarOf(ENT_EXPOWNER, "PLR_CRE_TYPE");

		if (CRE_TYPE == "fire")
		{
			CRE_EFFECT_SCRIPT = "effects/dot_fire";
			CRE_EFFECT_SKILL = "skill.spellcasting.fire";
			CRE_EFFECT_RATIO = 0.5f;
			CRE_EFFECT_NAME = "DOT_fire";
			CRE_EFFECT_DURATION = 5.0f;
		}

		if (CRE_TYPE == "cold")
		{
			CRE_EFFECT_SCRIPT = "effects/dot_cold";
			CRE_EFFECT_SKILL = "skill.spellcasting.ice";
			CRE_EFFECT_RATIO = 0.25f;
			CRE_EFFECT_NAME = "DOT_cold";
			CRE_EFFECT_DURATION = 5.0f;
		}

		if (CRE_TYPE == "lightning")
		{
			CRE_EFFECT_SCRIPT = "effects/dot_lightning";
			CRE_EFFECT_SKILL = "skill.spellcasting.lightning";
			CRE_EFFECT_RATIO = 0.4f;
			CRE_EFFECT_NAME = "DOT_lightning";
			CRE_EFFECT_DURATION = 5.0f;
		}

		if (CRE_TYPE == "poison")
		{
			CRE_EFFECT_SCRIPT = "effects/dot_poison";
			CRE_EFFECT_SKILL = "skill.spellcasting.affliction";
			CRE_EFFECT_RATIO = 0.3f;
			CRE_EFFECT_NAME = "DOT_poison";
			CRE_EFFECT_DURATION = 10.0f;
		}

		LegacyCommand("projectiletouch", 1);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renaderamt", 0);
		IS_ACTIVE = true;
		OWNER_ISPLAYER = Text(IsPlayer(ENT_EXPOWNER));
		if (Truthy(OWNER_ISPLAYER))
		{
			DMG_AMT = SkillOf(ENT_EXPOWNER, "smallarms.power") * 2.0f;
			USE_SKILL = "smallarms";
			START_ANG = ViewAnglesOf(ENT_EXPOWNER);
			PLR_CRE_HAND = Float(ScriptVarOf(ENT_EXPOWNER, "PLR_CRE_HAND"));
		}
		else
		{
			// setvard START_YAW $vec.yaw(START_YAW)
			DMG_AMT = Float(ScriptVarOf(ENT_EXPOWNER, "DMG_CRESCENT"));
			START_ANG = AnglesOf(ENT_EXPOWNER);
			USE_SKILL = "none";
		}
		SWIRVE_CYCLE = 0.0f;
		SetProp(ENT_ME, "velocity", RelativeVelocity(START_ANG, Vector3(0, FWD_SPEED, 0)));
		SetProp(ENT_ME, "movedir", START_ANG);

		NEXT_ACQUIRE = GameTime() + 0.5f;

		CallEventDelayed(0.05f, "cl_start");
		CallEventDelayed(0.1f, "projectile_loop");
		CallEventDelayed(3.0f, "end_projectile");
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base
		DID_LAND = true;
		OnEndProjectile();
	}

	// game_touch
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		result = AppendResult(result, ProjBase_OnGameTouch(other, hpRange, effectDamage));
		result = AppendResult(result, ProjCrescent_OnGameTouch(other, hpRange, effectDamage));
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Whirling Crescent Blade");
		SetDescription("A sharp bolt of ice");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);

		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renaderamt", 0);
	}

	// cl_start
	void OnClStart()
	{
		START_POS = OriginOf(ENT_ME);
		ClientEvent("new", "all", "items/proj_crescent_cl", IndexOf(ENT_ME), AnglesOf(ENT_ME), VelocityOf(ENT_ME), OriginOf(ENT_ME));
		CL_IDX = LastClientScriptId();
	}

	// projectile_loop
	void OnProjectileLoop()
	{
		bool exitSub = false;
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.5f, "projectile_loop");

		ServerPlaySound(2, 10, SOUND_SPIN, 0.8f, 200);

		if (!IsAlive(NPCATK_TARGET) && GameTime() > NEXT_ACQUIRE)
		{
			NEXT_ACQUIRE = GameTime() + 2.0f;
			CallExternal(ENT_EXPOWNER, "ext_sphere_token", "enemy", 1024, OriginOf(ENT_ME)); // yes monsters have this too
			string targList = ScriptVarOf(ENT_EXPOWNER, "PLR_SCAN_TOKEN");
			if (targList != "none")
			{
				targList = SortEntities(targList, "range");
				NPCATK_TARGET = GetToken(targList, 0);

				// don't track targets behind owner
				Vector3 targPos = OriginOf(NPCATK_TARGET);
				Vector3 ownerPos = OriginOf(ENT_EXPOWNER);
				Vector3 ownerAng = START_ANG;
				if (!WithinCone2D(targPos, ownerPos, ownerAng, 100))
				{
					NPCATK_TARGET = "unset";
					exitSub = true;
				}
				if (!exitSub)
				{
					if (!IsPlayer(NPCATK_TARGET))
						TARG_HALF_HEIGHT = HeightOf(NPCATK_TARGET) * 0.5f;
					else
						TARG_HALF_HEIGHT = 0.0f;
				}
			}
		}

		// I want to take advantage of the weapon dmgevent here, but for some damn reason
		// setting the inflictor to ent_me causes this projectile to switch positions
		// xdodamage $get(ent_me,origin) 64 DMG_AMT 0 ent_expowner ent_expowner USE_SKILL DMG_TYPE
		if (!(GameTime() > NEXT_ANGLE_UPDATE))
			return;
		NEXT_ANGLE_UPDATE = GameTime() + 0.1f;

		if (IsAlive(NPCATK_TARGET) && RandomInt(1, 2) < 100)
		{
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			targOrg.z += TARG_HALF_HEIGHT;
			Vector3 myOrg = OriginOf(ENT_ME);
			Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
			angToTarg.x = -angToTarg.x;
			SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, FWD_SPEED, 0)));
			SetProp(ENT_ME, "movedir", angToTarg);

			if (RangeTo(NPCATK_TARGET) < 64.0f)
			{
				DebugPrint("range_check " + Text(RangeTo(NPCATK_TARGET)));
				NEXT_ANGLE_UPDATE = GameTime() + 0.9f;
				CallEventDelayed(1.0f, "return_user");
			}
		}

		// callevent swirve_wander
		// callevent swirve_wander
		// callevent 0.1 cl_update
		ClientEvent("update", "all", CL_IDX, "sv_update_vel", AnglesOf(ENT_ME), VelocityOf(ENT_ME), OriginOf(ENT_ME));
	}

	// return_user
	void OnReturnUser()
	{
		NPCATK_TARGET = EntityId(EntityOf(ENT_EXPOWNER));
	}

	// cl_update
	void OnClUpdate()
	{
		ClientEvent("update", "all", CL_IDX, "sv_update_vel", AnglesOf(ENT_ME), VelocityOf(ENT_ME), OriginOf(ENT_ME));
	}

	// swirve_wander
	void OnSwirveWander()
	{
		int swirve = 0;
		SWIRVE_CYCLE += 1.0f;
		if (SWIRVE_CYCLE == 1.0f)
			swirve = -64;
		if (SWIRVE_CYCLE == 2.0f)
		{
			swirve = 64;
			SWIRVE_CYCLE = 0.0f;
		}
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(ENT_ME) + RelativePosition(START_ANG, Vector3(swirve, 200, 0));
		Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
		angToTarg.x = -angToTarg.x;
		SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, FWD_SPEED, 0)));
	}

	// end_projectile
	void OnEndProjectile()
	{
		Vector3 sprPos;
		ClientEvent("update", "all", CL_IDX, "end_fx");
		if (!Truthy(OWNER_ISPLAYER))
		{
			CallExternal(ENT_EXPOWNER, "ext_crescent_done"); // tell monster his ball popped
			sprPos = OriginOf(ENT_EXPOWNER);
			Vector3 ownerAng = AnglesOf(ENT_EXPOWNER);
			ClientEvent("new", "all", "items/proj_ub_cl", OriginOf(ENT_ME), sprPos);
		}
		else
		{
			sprPos = OriginOf(ENT_EXPOWNER);
			float ownerYaw = AnglesOf(ENT_EXPOWNER).y;
			// vectoradd SPR_POS $relpos($vec(0,OWNER_YAW,0),$vec(10,32,20)) //gonna have to rig someting to figure right or left hand
			if (PLR_CRE_HAND == 1.0f)
				sprPos += RelativePosition(Vector3(0, ownerYaw, 0), Vector3(10, 32, 20));
			else
				sprPos += RelativePosition(Vector3(0, ownerYaw, 0), Vector3(-10, 32, 20));
			// same CL effect as Unholy Blade on return
			ClientEvent("new", "all", "items/proj_ub_cl", OriginOf(ENT_ME), sprPos);
		}

		if (DID_LAND)
			return;
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("zombie/claw_miss2.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "cl_start") { OnClStart(); return true; }
		if (name == "cl_update") { OnClUpdate(); return true; }
		if (name == "end_projectile") { OnEndProjectile(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "projectile_loop") { OnProjectileLoop(); return true; }
		if (name == "return_user") { OnReturnUser(); return true; }
		if (name == "swirve_wander") { OnSwirveWander(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
