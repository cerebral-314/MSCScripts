#pragma context server

// Converted from items/proj_simple_cl.script by msc_transpiler.
// creates client side mirror of arrow, which is invisible server side, but still tracked

#include "runtime/ScriptEntity.as"

[script "items/proj_simple_cl"]
class ProjSimpleCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_EXP_OWNER = "FX_EXP_OWNER";
	string FX_MODEL_NAME = "FX_MODEL_NAME";
	string FX_MODEL_OFS = "FX_MODEL_OFS";
	string FX_USE_MOTIONBLUR = "FX_USE_MOTIONBLUR";
	string FX_SPECIAL = "FX_SPECIAL";
	float FX_MAX_DURATION = 0.0f;
	float FX_SCALE = 0.0f;
	float FX_FREMOVE_DELAY = 0.0f;
	bool FX_ACTIVE = false;
	bool FX_IN_FLIGHT = false;
	bool FX_UPDATE_ORG = false;
	bool FX_UPDATE_ANG = false;
	bool FX_UPDATE_VEL = false;
	Vector3 FX_ORIGIN = Vector3();
	string FX_ANGLES = "FX_ANGLES";
	string FX_VELOCITY = "FX_VELOCITY";
	string FX_ANIM_IDX = "FX_ANIM_IDX";
	string FX_GRAVITY = "FX_GRAVITY";
	float FX_DO_STICK = 0.0f;
	int FX_STICK_TARGET = 0;
	bool FX_UPDATE_SPECIAL = false;
	bool FX_SV_UPDATE = false;
	bool FX_STICK_OFS_SET = false;
	Vector3 FX_STICK_DIR = Vector3();
	float FX_STICK_DIST = 0.0f;
	string FX_STICK_ANGS = "FX_STICK_ANGS";
	float L_TARG_ANG = 0.0f;
	string FX_MBLUR_ANGLES = "FX_MBLUR_ANGLES";
	int FX_USE_BONE = 0;
	int BEST_BONE_DIST = 0;
	string FX_PROJ_POS = "FX_PROJ_POS";

	// client_activate
	// <proj_index> <owner_index> <infostring:origin;angles;velocity;anim> <model_name> <model_ofs> <motion_blur:0|1> <special_flags>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetCallback("render", "enable");

		FX_OWNER = owner;
		FX_EXP_OWNER = hand;
		FX_MODEL_NAME = lifetime;
		FX_MODEL_OFS = sprite;
		FX_USE_MOTIONBLUR = flag;
		FX_SPECIAL = specialFlags; // future use for special handling (maybe glow, for instance)

		FX_MAX_DURATION = 5.0f; // we can override with special
		FX_SCALE = 1.0f;
		FX_FREMOVE_DELAY = 0.25f; // extend in case we have more elaborate fx

		FX_ACTIVE = true;
		FX_IN_FLIGHT = true;

		FX_UPDATE_ORG = false;
		FX_UPDATE_ANG = false;
		FX_UPDATE_VEL = false;

		FX_ORIGIN = Vec(GetToken(fxColor, 0));
		FX_ANGLES = GetToken(fxColor, 1);
		FX_VELOCITY = GetToken(fxColor, 2);
		FX_ANIM_IDX = GetToken(fxColor, 3);
		FX_GRAVITY = GetToken(fxColor, 4);
		FX_DO_STICK = Float(GetToken(fxColor, 5));
		FX_STICK_TARGET = 0;

		if (Float(FX_ANIM_IDX) == -1.0f)
			FX_ANIM_IDX = "0";

		// dbg *** $currentscript - ownr FX_OWNER inf L_INFO_STRING
		// dbg *** $currentscript - mdl FX_MODEL_NAME anim FX_ANIM_IDX mot FX_USE_MOTIONBLUR ofs FX_MODEL_OFS grav FX_GRAVITY
		ClientEffect("tempent", "model", FX_MODEL_NAME, FX_ORIGIN, "make_clfx_proj", "update_clfx_proj", "collide_clfx_proj");

		CallEventDelayed(FX_MAX_DURATION, "end_fx");
	}

	// end_fx
	// [reason]
	void OnEndFx(string reason = "")
	{
		bool abortRemove = false;

		// dbg $currentscript - end_fx PARAM1 FX_DO_STICK
		if (int(FX_DO_STICK) != 0)
		{
			if (reason == "touch_remove")
				abortRemove = true;
			if (reason == "strike_target")
				abortRemove = true;
			if (reason == "landed")
				abortRemove = true;
			if (abortRemove)
			{
				CallEventDelayed(5.0f, "end_fx");
				return;
			}
		}
		FX_ACTIVE = false;
		CallEventDelayed(FX_FREMOVE_DELAY, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// ext_scale
	// <ratio>
	void OnExtScale(float ratio = 0.0f, int noBoundingFix = 0, int noRangeFix = 0)
	{
		// dbg $currentscript - ext_scale PARAM1
		FX_SCALE = ratio;
		FX_UPDATE_SPECIAL = true;
	}

	// ext_lighten
	// <ratio>
	void OnExtLighten(string gravity = "", int glowFlag = 0, Vector3 glowColor = Vector3(), string scale = "")
	{
		// dbg $currentscript - ext_lighten PARAM1
		FX_GRAVITY = gravity;
		FX_UPDATE_SPECIAL = true;
	}

	// ext_touch
	// <idx touched>
	void OnExtTouch(string touched = "")
	{
		// dbg $currentscript - ext_touch PARAM1
		// if arrow needs to do something on touch, do it here
		if (Truthy(LegacyFunction("getcl", touched, "isalive")))
			return;
		OnEndFx();
	}

	// ext_hitnpc
	// <index> <stick:0|1>
	void OnExtHitnpc(int targetIndex = 0)
	{
		FX_STICK_TARGET = targetIndex;
		FX_IN_FLIGHT = false;
	}

	// ext_update
	// <origin> <ang> <vel>
	void OnExtUpdate(Vector3 origin = Vector3(), string angles = "", string velocity = "")
	{
		// dbg **** $currentscript - ext_update PARAM1 PARAM2 PARAM3
		if (!FX_IN_FLIGHT)
			return;
		FX_SV_UPDATE = true;
		FX_ORIGIN = origin;
		FX_ANGLES = angles;
		FX_VELOCITY = velocity;
	}

	// make_clfx_proj
	void OnMakeClfxProj()
	{
		ClientEffect("tempent", "set_current_prop", "origin", FX_ORIGIN);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0);
		ClientEffect("tempent", "set_current_prop", "death_delay", 10.0f);
		ClientEffect("tempent", "set_current_prop", "scale", FX_SCALE);
		ClientEffect("tempent", "set_current_prop", "gravity", FX_GRAVITY);
		ClientEffect("tempent", "set_current_prop", "angles", FX_ANGLES);
		ClientEffect("tempent", "set_current_prop", "velocity", FX_VELOCITY);
		if (int(FX_DO_STICK) != 0)
			ClientEffect("tempent", "set_current_prop", "collide", "world");
		else
			ClientEffect("tempent", "set_current_prop", "collide", "world;die");
		ClientEffect("tempent", "set_current_prop", "body", FX_MODEL_OFS);
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 16);
		ClientEffect("tempent", "set_current_prop", "sequence", FX_ANIM_IDX);
	}

	// update_clfx_proj
	void OnUpdateClfxProj()
	{
		string myPos = "L_MY_POS";

		if (FX_ACTIVE)
		{
			if (FX_IN_FLIGHT)
			{
				// there's no model to grab, so none of these work
				// setvard FX_VELOCITY $getcl(FX_OWNER,velocity)
				// setvard FX_ANGLES $getcl(FX_OWNER,angles)
				// local L_MY_POS game.tempent.origin
				// local L_OWNER_POS $getcl(FX_OWNER,origin)
				// if ( $dist(L_MY_POS,L_OWNER_POS) > 100 ) cleffect tempent set_current_prop origin L_OWNER_POS
				if (FX_SV_UPDATE)
				{
					// dbg *** $currentscript - got sv_update
					FX_SV_UPDATE = false;
					myPos = Eval("game.tempent.origin");
					if (Distance(Vec(Text(FX_UPDATE_ORG)), Vec(myPos)) > 100.0f)
						ClientEffect("tempent", "set_current_prop", "origin", FX_ORIGIN);
					ClientEffect("tempent", "set_current_prop", "angles", FX_ANGLES);
					ClientEffect("tempent", "set_current_prop", "velocity", FX_VELOCITY);
				}

				if (FX_UPDATE_SPECIAL)
				{
					// dbg *** $currentscript - got special update
					FX_UPDATE_SPECIAL = false;
					ClientEffect("tempent", "set_current_prop", "scale", FX_SCALE);
					ClientEffect("tempent", "set_current_prop", "gravity", FX_GRAVITY);
				}

				// cleffect tempent set_current_prop gravity FX_GRAVITY //maybe buggy - also maybe limiting if we can't use
				if (Truthy(FX_USE_MOTIONBLUR))
					OnFxMotionBlur();
			}
			else if (int(FX_DO_STICK) != 0)
			{
				if (FX_STICK_TARGET != 0)
				{
					if (Truthy(LegacyFunction("getcl", FX_STICK_TARGET, "exists")))
					{
						ClientEffect("tempent", "set_current_prop", "movetype", 0);
						ClientEffect("tempent", "set_current_prop", "gravity", 0);
						ClientEffect("tempent", "set_current_prop", "collide", "none");
						ClientEffect("tempent", "set_current_prop", "velocity", 0);

						Vector3 stickPoint = Vec(LegacyFunction("getcl", FX_STICK_TARGET, "origin"));
						if (FX_USE_BONE > -1)
							stickPoint = Vec(LegacyFunction("getcl", FX_STICK_TARGET, "bonepos", FX_USE_BONE));
						myPos = Eval("game.tempent.origin");
						if (!FX_STICK_OFS_SET)
						{
							FX_STICK_OFS_SET = true;
							FX_STICK_DIR = DirectionTo(stickPoint, Vec(myPos));
							FX_STICK_DIST = Distance(Vec(myPos), stickPoint);
							FX_STICK_DIR *= FX_STICK_DIST;
							ClientEffect("tempent", "set_current_prop", "framerate", 0);
							ClientEffect("tempent", "set_current_prop", "gravity", 0);
							ClientEffect("tempent", "set_current_prop", "collide", "none");
							FX_STICK_ANGS = Eval("game.tempent.angles");
						}

						// nice try, but wrong approach
						float targYaw = Float(LegacyFunction("getcl", FX_STICK_TARGET, "angles"));
						targYaw = Vec(Text(targYaw)).y + 180.0f;
						if (targYaw > 359.99f)
							L_TARG_ANG -= 359.99f;
						Vector3 newAng = Vec(FX_STICK_ANGS);
						newAng.y = targYaw;
						ClientEffect("tempent", "set_current_prop", "angles", newAng);

						// dbg *** $currentscript stick_point isalive $getcl(FX_STICK_TARGET,isalive) //cant get this
						stickPoint += FX_STICK_DIR;
						ClientEffect("tempent", "set_current_prop", "origin", stickPoint);
					}
					else
					{
						OnEndFx();
					}
				}
			}
			else
			{
				OnEndFx();
			}
		}
		else
		{
			// remove (still got no function for this, dernit)
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(5000, 5000, 5000));
		}
	}

	// fx_motion_blur
	void OnFxMotionBlur()
	{
		FX_MBLUR_ANGLES = Eval("game.tempent.angles");
		ClientEffect("tempent", "model", FX_MODEL_NAME, Eval("game.tempent.origin"), "setup_motion_blur");
	}

	// setup_motion_blur
	void OnSetupMotionBlur()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.15f);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", FX_MBLUR_ANGLES);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "body", FX_MODEL_OFS);
		ClientEffect("tempent", "set_current_prop", "rendermode", "alpha");
		ClientEffect("tempent", "set_current_prop", "renderamt", 50);
	}

	// collide_clfx_proj
	void OnCollideClfxProj(string target = "")
	{
		// dbg **** $currentscript - collide_clfx_proj PARAM1
		// if ( PARAM1 equals world ) local PARAM1 0 //Setting a param like this isn't allowed
		FX_IN_FLIGHT = false;

		ClientEffect("tempent", "set_current_prop", "movetype", 0);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");

		if (int(FX_DO_STICK) != 0)
		{
			if (target != "world" && Float(target) > 0.0f)
			{
				FX_STICK_TARGET = Int(target);
				int nBones = Int(LegacyFunction("getcl", FX_STICK_TARGET, "bonecount"));
				if (nBones == 0)
				{
					FX_USE_BONE = -1;
				}
				else
				{
					BEST_BONE_DIST = 9999;
					FX_PROJ_POS = Eval("game.tempent.origin");
					for (int i = 0; i < nBones; i++)
					{
						loopIteration = i;
						OnFindNearestBone();
					}
				}

				string myPos = Eval("game.tempent.origin");
				Vector3 stickPoint = Vec(LegacyFunction("getcl", FX_STICK_TARGET, "origin"));
				if (FX_USE_BONE > -1)
					stickPoint = Vec(LegacyFunction("getcl", FX_STICK_TARGET, "bonepos", FX_USE_BONE));
				// dbg *** $currentscript - usebone FX_USE_BONE cnt L_N_BONES
				FX_STICK_OFS_SET = true;
				FX_STICK_DIR = DirectionTo(stickPoint, Vec(myPos));
				FX_STICK_DIST = Distance(Vec(myPos), stickPoint);
				FX_STICK_DIR *= FX_STICK_DIST;
				stickPoint += Vec(Text(FX_STICK_DIST));
				ClientEffect("tempent", "set_current_prop", "origin", stickPoint);
				FX_STICK_ANGS = Eval("game.tempent.angles");
			}
		}
		else
		{
			// cleffect tempent set_current_prop follow FX_STICK_TARGET FX_STICK_DIST //also no work
			// cleffect tempent set_current_prop framerate 0
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(5000, 5000, 5000));
		}
	}

	// find_nearest_bone
	void OnFindNearestBone()
	{
		int curBone = loopIteration;
		if (!(curBone > 0))
			return;
		string curBonePos = LegacyFunction("getcl", FX_STICK_TARGET, "bonepos", curBone);
		float curBoneDist = Distance(Vec(FX_PROJ_POS), Vec(curBonePos));

		if (curBoneDist < BEST_BONE_DIST)
		{
			FX_USE_BONE = curBone;
			BEST_BONE_DIST = int(curBoneDist);
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxFremoveDelay() {} // FX_FREMOVE_DELAY
	void OnFxMaxDuration() {} // FX_MAX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "collide_clfx_proj") { OnCollideClfxProj(Param(params, 0)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "ext_hitnpc") { OnExtHitnpc(Int(Param(params, 0))); return true; }
		if (name == "ext_lighten") { OnExtLighten(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "ext_scale") { OnExtScale(Float(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "ext_touch") { OnExtTouch(Param(params, 0)); return true; }
		if (name == "ext_update") { OnExtUpdate(Vec(Param(params, 0)), Param(params, 1), Param(params, 2)); return true; }
		if (name == "find_nearest_bone") { OnFindNearestBone(); return true; }
		if (name == "fx_motion_blur") { OnFxMotionBlur(); return true; }
		if (name == "make_clfx_proj") { OnMakeClfxProj(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_motion_blur") { OnSetupMotionBlur(); return true; }
		if (name == "update_clfx_proj") { OnUpdateClfxProj(); return true; }
		return false;
	}
}
