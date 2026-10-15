#pragma context server

// Converted from monsters/elemental_pure_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/elemental_pure_cl"]
class ElementalPureCl : ScriptEntity
{
	// Constants
	int MAX_BONE = 17;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_COLOR = "FX_COLOR";
	string FX_TYPE = "FX_TYPE";
	float FX_DURATION = 0.0f;
	bool FX_ACTIVE = false;
	string FX_LIGHT = "FX_LIGHT";
	bool OWNER_DIED = false;
	string BONE_IDX = "BONE_IDX";

	// client_activate
	// $get(ent_me,index) ELM_COLOR ELM_TYPE FREQ_CL_REFRESH
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		FX_COLOR = hand;
		FX_TYPE = fxColor;
		FX_DURATION = Float(lifetime);
		FX_ACTIVE = true;

		DebugPrint("monsters/elemental_pure_cl client_activate own " + FX_OWNER + " col " + FX_COLOR + " typ " + FX_TYPE + " dur " + Text(FX_DURATION));

		SetCallback("render", "enable");

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), 64, FX_COLOR, 0.1f);
		FX_LIGHT = Eval("game.script.last_light_id");

		OnSkeletonSprite();

		CallEventDelayed(FX_DURATION, "end_fx");
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		FX_ACTIVE = false;
		CallEventDelayed(1.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// owner_death
	void OnOwnerDeath()
	{
		OWNER_DIED = true;
		CallEventDelayed(3.0f, "end_fx");
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!(Float(FX_LIGHT) > 0.0f))
			return;
		ClientEffect("light", FX_LIGHT, LegacyFunction("getcl", FX_OWNER, "origin"), 64, "AU_COLOR", 0.1f);
	}

	// skeleton_sprite
	void OnSkeletonSprite()
	{
		int count;
		if (FX_TYPE == "fire")
		{
			ArrayCreate("ARRAY_BONEPOS");
			count = MAX_BONE;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnLightBonesFire();
			}
		}
	}

	// light_bones_fire
	void OnLightBonesFire()
	{
		DebugPrint("light_bones_fire");
		BONE_IDX = loopIteration;
		string pos = LegacyFunction("getcl", FX_OWNER, "bonepos", BONE_IDX);
		ClientEffect("tempent", "sprite", "3dmflaora.spr", pos, "setup_bone_sprite", "update_bone_sprite");
	}

	// setup_bone_sprite
	void OnSetupBoneSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "renderamt", 150);
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 255, 255));
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "iuser1", BONE_IDX);
		float createTime = GameTime();
		ClientEffect("tempent", "set_current_prop", "fuser1", createTime + 0.1f);
	}

	// update_bone_sprite
	// { keep_bone_pos
	// if FX_ACTIVE
	// if !OWNER_DIED
	// callevent 0.01 keep_bone_pos
	// calleventloop MAX_BONE store_bone_pos
	// }
	// { store_bone_pos
	// local L_IDX $int(game.script.iteration)
	// array.set ARRAY_BONEPOS L_IDX $getcl(FX_OWNER,bonepos,L_IDX)
	// }
	void OnUpdateBoneSprite()
	{
		if (FX_ACTIVE)
		{
			if (!OWNER_DIED)
			{
				string idx = Eval("game.tempent.iuser1");
				string pos = LegacyFunction("getcl", FX_OWNER, "bonepos", idx); // $get_array(ARRAY_BONEPOS,L_IDX)
				// dbg update_bone_sprite L_POS
				// dbg update_bone_sprite FX_OWNER L_IDX L_POS
				ClientEffect("tempent", "set_current_prop", "origin", pos);
				int nextUpdate = Int(Eval("game.tempent.fuser1"));
				float time = GameTime();
				if (time > nextUpdate) // drip a sprite every 0.1 secs
				{
					ClientEffect("tempent", "set_current_prop", "fuser1", time + 0.1f);
					ClientEffect("tempent", "sprite", "3dmflaora.spr", pos, "setup_drip_sprite");
				}
			}
			else
			{
				ClientEffect("tempent", "set_current_prop", "velocity", Vector3(0, 0, -100));
				ClientEffect("tempent", "set_current_prop", "gravity", 1);
				ClientEffect("tempent", "set_current_prop", "collide", "world");
				ClientEffect("tempent", "set_current_prop", "bouncefactor", 5);
			}
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 20000, 20000));
		}
	}

	// setup_drip_sprite
	void OnSetupDripSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.25f);
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");
		ClientEffect("tempent", "set_current_prop", "renderamt", 150);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "rendercolor", Vector3(255, 255, 255));
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "scale", 0.25f);
		ClientEffect("tempent", "set_current_prop", "gravity", 1);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "light_bones_fire") { OnLightBonesFire(); return true; }
		if (name == "owner_death") { OnOwnerDeath(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_bone_sprite") { OnSetupBoneSprite(); return true; }
		if (name == "setup_drip_sprite") { OnSetupDripSprite(); return true; }
		if (name == "skeleton_sprite") { OnSkeletonSprite(); return true; }
		if (name == "update_bone_sprite") { OnUpdateBoneSprite(); return true; }
		return false;
	}
}
