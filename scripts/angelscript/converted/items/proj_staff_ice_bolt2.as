#pragma context server

// Converted from items/proj_staff_ice_bolt2.script by msc_transpiler.
// tempt at guided

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_staff_ice_bolt2"]
class ProjStaffIceBolt2 : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "7";
	int ARROW_BODY_OFS = 7;
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_STICK_DURATION = 0;
	int HOMING_TURN = 4;
	float HOMING_CONE = 0.7f;

	// Variables (an unset .script variable reads as its own name)
	string MY_TARG = "MY_TARG";
	string TARG_LIST = "TARG_LIST";
	float TARG_HALF_HEIGHT = 0.0f;
	bool IS_ACTIVE = false;
	bool BOLT_DONE = false;

	// Variables declared by included files, with the value they start with in this script
	ProjStaffIceBolt2()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal1.wav";
		PROJ_DAMAGE_TYPE = "cold";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_COLLIDEHITBOX = 0;
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		DebugPrint("game_tossprojectile");
		CallEventDelayed(0.1f, "pick_target");
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base
		IS_ACTIVE = false;
		BOLT_DONE = true;
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		ProjBase_OnGameProjectileHitnpc(target); // items/proj_base
		ProjArrowBase_OnGameProjectileHitnpc(target); // items/proj_arrow_base
		bool exitSub = false;

		IS_ACTIVE = false;
		BOLT_DONE = true;

		CBaseEntity@ myOwner = EntityOf(ENT_EXPOWNER);
		bool ownerIsplayer = IsPlayer(myOwner);

		if ((ownerIsplayer ? 1 : 0) == 1 && !IsPvp() && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return;

		if (RelationshipOf(myOwner, @target) != "enemy")
			return;

		DoDamageEx(@target, "direct", SkillOf(myOwner, "spellcasting.ice"), "100%", @myOwner, ENT_ME, "spellcasting.ice", "cold");

		float effectDuration = SkillOf(myOwner, "spellcasting.ice");
		float dotIce = SkillOf(myOwner, "spellcasting.ice");
		effectDuration *= 0.5f;
		dotIce *= 0.5f;
		effectDuration = Clamp(effectDuration, 3.0f, 5.0f);

		ApplyEffect(target, "effects/dot_cold", effectDuration, @myOwner, dotIce, "spellcasting.ice");
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Guided Ice Bolt");
		SetDescription("A sharp bolt of ice");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// pick_target
	void OnPickTarget()
	{
		int count;
		int outerIteration;
		if (BOLT_DONE)
			return;
		DebugPrint("pick_target");
		// race human
		// local TARG_LIST $get_insphere(enemy,1024,game.monster.origin)
		MY_TARG = "none";
		string scan = "enemy";
		if (IsPvp())
			scan = "any";
		CallExternal(ENT_EXPOWNER, "ext_sphere_token_byrange", scan, 768, OriginOf(ENT_ME));
		TARG_LIST = ScriptVarOf(ENT_EXPOWNER, "PLR_SCAN_TOKEN");
		DebugPrint("pick_target list " + TARG_LIST);
		if (TARG_LIST != "none")
		{
			count = GetTokenCount(TARG_LIST);
			outerIteration = loopIteration;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnPickTargetLoop();
				if (breakLoop)
				{
					breakLoop = false;
					break;
				}
			}
			loopIteration = outerIteration;
		}
		if (MY_TARG == "none")
		{
			CallEventDelayed(0.25f, "pick_target");
			return;
		}

		DebugPrint("pick_target " + NameOf(MY_TARG));
		if (!IsPlayer(MY_TARG))
			TARG_HALF_HEIGHT = HeightOf(MY_TARG) * 0.5f;
		else
			TARG_HALF_HEIGHT = 0.0f;
		IS_ACTIVE = true;
		CallEventDelayed(0.1f, "orient_on_target");
	}

	// pick_target_loop
	void OnPickTargetLoop()
	{
		string targ = GetToken(TARG_LIST, loopIteration);
		Vector3 pos = OriginOf(targ);

		if (LegacyFunction("get_traceline", OriginOf(ENT_ME), pos, "worldonly") != Text(pos))
			return;
		if (!IsAlive(targ))
			return;
		if (int(DamageTakenOf(targ, "cold")) == 0)
			return;
		if (IsPlayer(targ))
		{
			if (!IsPvp()) // players only in pvp
				return;
		}
		else if (RelationshipOf(ENT_EXPOWNER, targ) != "enemy")
			return;

		// Bolt finds targets in front of you
		string center = Text(pos);
		center = Text(Vec(center) + Vector3(0.0f, 0.0f, HeightOf(targ) * 0.5f));
		Vector3 toTarg = DirectionTo(OriginOf(ENT_ME), Vec(center));
		Vector3 fwd = DirectionTo(Vector3(0, 0, 0), VelocityOf(ENT_ME));
		float dot = toTarg.x * fwd.x + toTarg.y * fwd.y + toTarg.z * fwd.z;
		if (!(dot >= HOMING_CONE))
			return;

		MY_TARG = targ;
		breakLoop = true;
	}

	// orient_on_target
	void OnOrientOnTarget()
	{
		if (!IS_ACTIVE)
			return;
		if (!IsAlive(MY_TARG))
			return;
		CallEventDelayed(0.1f, "orient_on_target");
		Vector3 targOrg = OriginOf(MY_TARG);
		targOrg.z += TARG_HALF_HEIGHT;
		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
		angToTarg.x = -angToTarg.x;

		// turn toward the target a bit at a time instead of snapping to it
		Vector3 curAng = Angles3DTo(Vector3(0, 0, 0), VelocityOf(ENT_ME));
		curAng.x = -curAng.x;
		float turnPitch = angToTarg.x - curAng.x;
		if (turnPitch > 180.0f)
			turnPitch -= 360.0f;
		if (turnPitch < -180.0f)
			turnPitch += 360.0f;
		float turnYaw = angToTarg.y - curAng.y;
		if (turnYaw > 180.0f)
			turnYaw -= 360.0f;
		if (turnYaw < -180.0f)
			turnYaw += 360.0f;
		turnPitch = Clamp(turnPitch, -HOMING_TURN, HOMING_TURN);
		turnYaw = Clamp(turnYaw, -HOMING_TURN, HOMING_TURN);
		angToTarg.x = curAng.x + turnPitch;
		angToTarg.y = curAng.y + turnYaw;

		// dbg orient_on_target ANG_TO_TARG
		SetProp(ENT_ME, "velocity", RelativeVelocity(angToTarg, Vector3(0, 300, 0)));
		SetProp(ENT_ME, "movedir", angToTarg);
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
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "orient_on_target") { OnOrientOnTarget(); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "pick_target_loop") { OnPickTargetLoop(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
