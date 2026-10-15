#pragma context server

// Converted from items/lrod_cl.script by msc_transpiler.
// Magic (client-side special effects)

#include "runtime/ScriptEntity.as"

[script "items/lrod_cl"]
class LrodCl : ScriptEntity
{
	// Constants
	string SPRITE_LIGHTNING = "lgtning.spr";
	string SPRITE_GLOW = "3dmflaora.spr";
	string GLOW_DURATION = "3";
	float OFS_POS = 0.2f;
	float OFS_NEG = -0.2f;
	float LIGHT_RADIUS = 128.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	int SKYLTNG_OFS = 256;

	// unnamed block (timer)
	void LrodCl_Timer()
	{
		bool scriptIsfirstperson = false;
		CallEventDelayed(Random(0.15f, 0.25f), "LrodCl_Timer");

		if (!scriptIsfirstperson)
		{
			// Watching other player cast spell
			OnMakeSprite1(LegacyFunction("getcl", "script.modelid", "bonepos", 21));
			OnMakeSprite1(LegacyFunction("getcl", "script.modelid", "bonepos", 38));
		}
		else
		{
			// //dbg 'script.modelid' - script.modelid
			// //dbg bone 21 -- $getcl(script.modelid,bonepos,21)
			// Watching self cast spell in first person
			string handid = Eval("game.localplayer.viewmodel.active.id");
		}
	}

	// client_activate
	void OnClientActivate(string owner = "", string hand = "", string fxColor = "", string lifetime = "", string sprite = "", string flag = "", string specialFlags = "", string glowRadius = "")
	{
		SetVar("script.modelid", owner);
		SetVar("script.prepduration", hand);
		SetVar("script.duration", fxColor);
		SetVar("script.islocal", 0);

		if (0.0f == Float(Eval("game.localplayer.index")))
		{
			SetVar("script.islocal", 1);
			SetCallback("render", "enable");
		}

		if (Truthy(LegacyFunction("getcl", "script.modelid", "exists")))
		{
			OnScriptPrepdone();

			OnCreateLight(LegacyFunction("getcl", "script.modelid", "origin"));

			OnClHandmagicBeam("righthand");
		}
		else
		{
			OnEffectDie();
		}
	}

	// effect_die
	void OnEffectDie()
	{
		RemoveScript();
	}

	// prep_done
	void OnPrepDone()
	{
		SetVar("script.prepdone", 1);
	}

	// make_sprite_1
	void OnMakeSprite1(string bonePosition = "")
	{
		if (bonePosition == "0")
			return;

		Vector3 pos = Vec(bonePosition);
		pos += Vector3(RandomInt(int(OFS_NEG), int(OFS_POS)), RandomInt(int(OFS_NEG), int(OFS_POS)), RandomInt(int(OFS_NEG), int(OFS_POS)));
		ClientEffect("tempent", "sprite", SPRITE_GLOW, pos, "setup_sprite_1");
	}

	// setup_sprite_1
	void OnSetupSprite12()
	{
		ClientEffect("tempent", "set_current_prop", "death_delay", GLOW_DURATION);
		ClientEffect("tempent", "set_current_prop", "bouncefactor", 0.1f);
		ClientEffect("tempent", "set_current_prop", "scale", 0.1f);
		ClientEffect("tempent", "set_current_prop", "gravity", Random(0.2f, 0.1f));
		ClientEffect("tempent", "set_current_prop", "collide", "world|die");
	}

	// create_light
	void OnCreateLight(string origin = "")
	{
		if (origin == "0")
			return;

		ClientEffect("light", "new", origin, LIGHT_RADIUS, LIGHT_COLOR, "script.duration");
	}

	// cl_handmagic_beam
	// Eletricity moving through player hands in view model
	// ====================================================
	// Called from viewmodel and from this script
	void OnClHandmagicBeam(string hand = "")
	{
		if (hand == "hands")
		{
			SetVar("magichand.on", 1);
			SetVar("handmagic.handid", Eval("game.localplayer.viewmodel.active.id"));
			SetVar("handmagic.anim", LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "anim"));
			SetVar("handmagic.event", "handmagic_connecthands");
		}
		else if (hand == "righthand")
		{
			SetVar("magichand.on", 1);
			SetVar("handmagic.handid", Eval("game.localplayer.viewmodel.active.id"));
			SetVar("handmagic.anim", LegacyFunction("getcl", Eval("game.localplayer.viewmodel.active.id"), "anim"));
			SetVar("handmagic.event", "handmagic_righthand");
		}
		else
		{
			SetVar("magichand.on", 0);
		}
	}

	// handmagic_connecthands
	void OnHandmagicConnecthands(string flag = "")
	{
		if (!Truthy(flag))
		{
			// Called from game_render_transparent
			// Connect beams between these finger bones
			OnHandmagicCreatebeam(16, 35);
			OnHandmagicCreatebeam(19, 38);
			OnHandmagicCreatebeam(22, 41);
			OnHandmagicCreatebeam(25, 44);
			OnHandmagicCreatebeam(28, 47);
		}
		else
		{
			// Called from game_prerender
			// Create glow on hands
			OnCreateSprite2(1); // Righthand
			OnCreateSprite2(2); // Lefthand
		}
	}

	// handmagic_righthand
	void OnHandmagicRighthand(string flag = "")
	{
		if (!Truthy(flag))
		{
			// Called from game_render_transparent
			// Connect beams between these finger bones
			OnHandmagicCreatebeamToSky(35);
			OnHandmagicCreatebeamToSky(38);
			OnHandmagicCreatebeamToSky(41);
			OnHandmagicCreatebeamToSky(44);
			OnHandmagicCreatebeamToSky(47);
		}
		else
		{
			// Called from game_prerender
			// Create glow on right hands
			OnCreateSprite2(1); // Righthand
		}
	}

	// game_render_transparent
	void OnGameRenderTransparent()
	{
		// (never true here, the rest is skipped) if magichand.on == 1
	}

	// handmagic_createbeam
	void OnHandmagicCreatebeam(int leftBone = 0, int rightBone = 0)
	{
		string posLeft = LegacyFunction("getcl", "handmagic.handid", "bonepos", leftBone);
		string posRight = LegacyFunction("getcl", "handmagic.handid", "bonepos", rightBone);

		ClientEffect("beam_points", posLeft, posRight, SPRITE_LIGHTNING, 0.001f, 0.1f, 0.1f, 0.3f, 0.1f, 30, Vector3(1, 0.5f, 2));
	}

	// handmagic_createbeam_to_sky
	void OnHandmagicCreatebeamToSky(int fingerBone = 0)
	{
		if (!(RandomInt(0, 100) < 10))
			return;

		string posFinger = LegacyFunction("getcl", "handmagic.handid", "bonepos", fingerBone);
		string posSky = posFinger;

		float ofsX = Random(-SKYLTNG_OFS, SKYLTNG_OFS);
		float ofsY = Random(-SKYLTNG_OFS, SKYLTNG_OFS);
		posSky = Text(Vec(posSky) + Vector3(ofsX, ofsY, 1024));

		ClientEffect("beam_points", posFinger, posSky, SPRITE_LIGHTNING, 0.1f, 1, 0.1f, 0.3f, 0.1f, 30, Vector3(1, 0.5f, 2));
	}

	// game_prerender
	void OnGamePrerender()
	{
		// (never true here, the rest is skipped) if magichand.on == 1
	}

	// create_sprite_2
	// Glow sprite in middle of hand.  Attaches to viewmodel attachment point
	void OnCreateSprite2(int attachment = 0)
	{
		SetVar("magichand.attachment", attachment);
		ClientEffect("frameent", "sprite", SPRITE_GLOW, Vector3(0, 0, 0), "setup_sprite_2");
	}

	// setup_sprite_2
	void OnSetupSprite2()
	{
		ClientEffect("frameent", "set_current_prop", "scale", 0.25f);
		ClientEffect("frameent", "set_current_prop", "rendermode", "add");
		ClientEffect("frameent", "set_current_prop", "renderamt", 128);
		ClientEffect("frameent", "set_current_prop", "rendercolor", Vector3(0, 0, 255));
		ClientEffect("frameent", "set_current_prop", "follow", "handmagic.handid");
		ClientEffect("frameent", "set_current_prop", "body", "magichand.attachment");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnHandmagicEvent() {} // handmagic.event
	void OnScriptPrepdone() {} // script.prepdone

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		Precache("lgtning.spr");
		CallEventDelayed(Float(Eval("$randf(0.15,0.25)")), "LrodCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cl_handmagic_beam") { OnClHandmagicBeam(Param(params, 0)); return true; }
		if (name == "client_activate") { OnClientActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "create_light") { OnCreateLight(Param(params, 0)); return true; }
		if (name == "create_sprite_2") { OnCreateSprite2(Int(Param(params, 0))); return true; }
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "game_render_transparent") { OnGameRenderTransparent(); return true; }
		if (name == "handmagic_connecthands") { OnHandmagicConnecthands(Param(params, 0)); return true; }
		if (name == "handmagic_createbeam") { OnHandmagicCreatebeam(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "handmagic_createbeam_to_sky") { OnHandmagicCreatebeamToSky(Int(Param(params, 0))); return true; }
		if (name == "handmagic_righthand") { OnHandmagicRighthand(Param(params, 0)); return true; }
		if (name == "make_sprite_1") { OnMakeSprite1(Param(params, 0)); return true; }
		if (name == "prep_done") { OnPrepDone(); return true; }
		if (name == "setup_sprite_1") { OnSetupSprite12(); return true; }
		if (name == "setup_sprite_2") { OnSetupSprite2(); return true; }
		if (name == "LrodCl_Timer") { LrodCl_Timer(); return true; }
		return false;
	}
}
