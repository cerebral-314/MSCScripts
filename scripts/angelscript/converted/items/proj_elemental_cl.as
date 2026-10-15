#pragma context server

// Converted from items/proj_elemental_cl.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/proj_elemental_cl"]
class ProjElementalCl : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	float CUR_ANG = 0.0f;
	string CUR_VEL = "CUR_VEL";
	string FX_COLOR = "FX_COLOR";
	float FX_DURATION = 0.0f;
	string FX_SPRITE = "FX_SPRITE";
	string CUR_ORG = "CUR_ORG";
	bool IS_ACTIVE = false;
	string CLOUD_ORG = "CLOUD_ORG";
	string PROJ_LIGHT_ID = "PROJ_LIGHT_ID";
	bool UPDATE_VEL = false;
	float CYCLE_ANGLE = 0.0f;

	// unnamed block (timer)
	void ProjElementalCl_Timer()
	{
		CallEventDelayed(Random(0.01f, 0.05f), "ProjElementalCl_Timer");
		if (!IS_ACTIVE)
			return;
		ClientEffect("tempent", "sprite", FX_SPRITE, CLOUD_ORG, "spit_flames");
		ClientEffect("tempent", "sprite", FX_SPRITE, CLOUD_ORG, "spit_flames");
		ClientEffect("tempent", "sprite", FX_SPRITE, CLOUD_ORG, "spit_flames");
	}

	// client_activate
	// <owner> <startang> <startvel> <startorg> <color> <duration> <sprite>
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		FX_OWNER = owner;
		CUR_ANG = Float(hand);
		CUR_VEL = fxColor;
		FX_COLOR = lifetime;
		FX_DURATION = Float(sprite);
		FX_SPRITE = flag; // sending this so we don't pre-cache without needing to

		CUR_ORG = LegacyFunction("getcl", FX_OWNER, "origin");

		SetCallback("render", "enable");
		IS_ACTIVE = true;

		CLOUD_ORG = CUR_ORG;

		// this no workie with a sprite
		// cleffect sprite FX_SPRITE CUR_ORG setup_cloud update_cloud
		ClientEffect("tempent", "model", "weapons/projectiles.mdl", CUR_ORG, "setup_cloud", "update_cloud");

		ClientEffect("light", "new", LegacyFunction("getcl", FX_OWNER, "origin"), 128, FX_COLOR, 5.0f);
		PROJ_LIGHT_ID = Eval("game.script.last_light_id");

		// dbg *** client_activate org CUR_ORG dur FX_DURATION
		float failsafeDuration = FX_DURATION * 1.5f;

		CallEventDelayed(failsafeDuration, "end_fx"); // server should end it, but just in case
	}

	// game_prerender
	void OnGamePrerender()
	{
		if (!Truthy(LegacyFunction("getcl", FX_OWNER, "exists")))
			return;
		string pos = LegacyFunction("getcl", FX_OWNER, "origin");
		ClientEffect("light", PROJ_LIGHT_ID, pos, 128, FX_COLOR, 1.0f);
	}

	// sv_update_vel
	void OnSvUpdateVel(float angles = 0.0f, string velocity = "", string origin = "")
	{
		// dbg *** sv_update_vel ang CUR_ANG vel CUR_VEL org CUR_ORG
		CUR_ANG = angles;
		CUR_VEL = velocity;
		CUR_ORG = origin;
		UPDATE_VEL = true;
	}

	// update_cloud
	void OnUpdateCloud()
	{
		if (IS_ACTIVE)
		{
			CLOUD_ORG = Eval("game.tempent.origin");
			if (UPDATE_VEL)
			{
				ClientEffect("tempent", "set_current_prop", "angles", CUR_ANG);
				ClientEffect("tempent", "set_current_prop", "velocity", CUR_VEL);
				// cleffect tempent set_current_prop origin CUR_ORG
				UPDATE_VEL = false;
			}
		}
		else
		{
			ClientEffect("tempent", "set_current_prop", "origin", Vector3(20000, 0, 0));
		}
	}

	// proj_explode
	void OnProjExplode()
	{
		IS_ACTIVE = false;

		ClientEffect("light", "new", CLOUD_ORG, 256, FX_COLOR, 2.0f);

		CYCLE_ANGLE = 0.0f;
		for (int i = 0; i < 17; i++)
		{
			loopIteration = i;
			OnCreateExplodeSprites();
		}
		CallEventDelayed(1.5f, "remove_fx");
	}

	// create_explode_sprites
	void OnCreateExplodeSprites()
	{
		Vector3 sprPos = Vec(CLOUD_ORG);
		sprPos += RelativePosition(Vector3(0, CYCLE_ANGLE, 0), Vector3(0, 10, 0));
		ClientEffect("tempent", "sprite", FX_SPRITE, sprPos, "setup_explode_sprite", "update_explode_sprite");
		CYCLE_ANGLE += 20.0f;
	}

	// update_explode_sprite
	void OnUpdateExplodeSprite()
	{
		float curSize = Float(Eval("game.tempent.fuser1"));
		if (!(curSize > 0.01f))
			return;
		curSize -= 0.01f;
		ClientEffect("tempent", "set_current_prop", "scale", curSize);
		ClientEffect("tempent", "set_current_prop", "fuser1", curSize);
	}

	// end_fx
	void OnEndFx(string reason = "")
	{
		IS_ACTIVE = false;
		CallEventDelayed(3.0f, "remove_fx");
	}

	// remove_fx
	void OnRemoveFx()
	{
		RemoveScript();
	}

	// setup_cloud
	void OnSetupCloud()
	{
		// cleffect tempent set_current_prop origin $getcl(FX_OWNER,origin)
		// cleffect tempent set_current_prop rendermode add
		// cleffect tempent set_current_prop renderamt 255
		// cleffect tempent set_current_prop death_delay FX_DURATION
		// cleffect tempent set_current_prop scale 1.0
		// cleffect tempent set_current_prop gravity 	0
		// cleffect tempent set_current_prop angles CUR_ANG
		// cleffect tempent set_current_prop velocity CUR_VEL
		// cleffect tempent set_current_prop collide 	none
		// cleffect tempent set_current_prop framerate 30
		// cleffect tempent set_current_prop frames	1
		// cleffect tempent set_current_prop rendercolor FX_COLOR
		ClientEffect("tempent", "set_current_prop", "origin", LegacyFunction("getcl", FX_OWNER, "origin"));
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 1);
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "scale", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "angles", CUR_ANG);
		ClientEffect("tempent", "set_current_prop", "velocity", CUR_VEL); // $relvel(OWNER_ANG,$vec(0,1000,0))
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "body", 71);
		// cleffect tempent set_current_prop fadeout lifetime
		ClientEffect("tempent", "set_current_prop", "framerate", 1.0f);
		ClientEffect("tempent", "set_current_prop", "frames", 16);
		ClientEffect("tempent", "set_current_prop", "sequence", 11); // maybe adjust based on throw anim
	}

	// spit_flames
	void OnSpitFlames()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 0.5f);
		ClientEffect("tempent", "set_current_prop", "fadeout", 0.5f);
		ClientEffect("tempent", "set_current_prop", "velocity", RelativeVelocity(Vec(Text(CUR_ANG)), Vector3(Random(-120, 120), -200, 0)));
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 5);
		ClientEffect("tempent", "set_current_prop", "scale", 0.5f);
		ClientEffect("tempent", "set_current_prop", "renderamt", 180);
		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		ClientEffect("tempent", "set_current_prop", "collide", "all;die");
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "rendercolor", FX_COLOR);
	}

	// setup_explode_sprite
	void OnSetupExplodeSprite()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", 1.0f);
		ClientEffect("tempent", "set_current_prop", "gravity", 0);
		Vector3 spriteTurn = RelativeVelocity(Vector3(0, CYCLE_ANGLE, 0), Vector3(0, 200, 0));
		ClientEffect("tempent", "set_current_prop", "velocity", spriteTurn);
		ClientEffect("tempent", "set_current_prop", "collide", "none");
		ClientEffect("tempent", "set_current_prop", "fadeout", "lifetime");

		ClientEffect("tempent", "set_current_prop", "rendermode", "add");
		ClientEffect("tempent", "set_current_prop", "renderamt", 255);
		ClientEffect("tempent", "set_current_prop", "death_delay", FX_DURATION);
		ClientEffect("tempent", "set_current_prop", "scale", 2.0f);
		ClientEffect("tempent", "set_current_prop", "angles", CUR_ANG);
		ClientEffect("tempent", "set_current_prop", "framerate", 30);
		ClientEffect("tempent", "set_current_prop", "frames", 1);
		ClientEffect("tempent", "set_current_prop", "rendercolor", FX_COLOR);

		ClientEffect("tempent", "set_current_prop", "fuser1", 1.0f);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnLFailsafeDuration() {} // L_FAILSAFE_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(Float(Eval("$randf(0.01,0.05)")), "ProjElementalCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_explode_sprites") { OnCreateExplodeSprites(); return true; }
		if (name == "end_fx") { OnEndFx(Param(params, 0)); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "proj_explode") { OnProjExplode(); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "setup_cloud") { OnSetupCloud(); return true; }
		if (name == "setup_explode_sprite") { OnSetupExplodeSprite(); return true; }
		if (name == "spit_flames") { OnSpitFlames(); return true; }
		if (name == "sv_update_vel") { OnSvUpdateVel(Float(Param(params, 0)), Param(params, 1), Param(params, 2)); return true; }
		if (name == "update_cloud") { OnUpdateCloud(); return true; }
		if (name == "update_explode_sprite") { OnUpdateExplodeSprite(); return true; }
		if (name == "ProjElementalCl_Timer") { ProjElementalCl_Timer(); return true; }
		return false;
	}
}
