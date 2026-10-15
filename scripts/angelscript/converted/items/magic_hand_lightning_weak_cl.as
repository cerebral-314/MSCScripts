#pragma context server

// Converted from items/magic_hand_lightning_weak_cl.script by msc_transpiler.
// Magic (client-side special effects)

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base_cl.as"

[script "items/magic_hand_lightning_weak_cl"]
class MagicHandLightningWeakCl : MagicHandBaseClScript
{
	// Variables declared by included files, with the value they start with in this script
	MagicHandLightningWeakCl()
	{
		SPRITE_LIGHTNING = "lgtning.spr";
		SPRITE_GLOW = "3dmflaora.spr";
		GLOW_DURATION = "3";
		SKYLTNG_OFS = 256;
	}

	// game_precache
	void MagicHandLightningWeakCl_OnGamePrecache()
	{
	}

	// game_precache
	void OnGamePrecache()
	{
		MagicHandLightningWeakCl_OnGamePrecache();
		MagicHandBaseCl_OnGamePrecache(); // items/magic_hand_base_cl
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		Precache("lgtning.spr");
		CallEventDelayed(Float(Eval("$randf(0.10,0.25)")), "MagicHandBaseCl_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cl_handmagic_beam") { OnClHandmagicBeam(Param(params, 0)); return true; }
		if (name == "create_sprite_2") { OnCreateSprite2(Int(Param(params, 0))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_prerender") { OnGamePrerender(); return true; }
		if (name == "game_render_transparent") { OnGameRenderTransparent(); return true; }
		if (name == "handmagic_connecthands") { OnHandmagicConnecthands(Param(params, 0)); return true; }
		if (name == "handmagic_createbeam") { OnHandmagicCreatebeam(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "handmagic_createbeam_to_sky") { OnHandmagicCreatebeamToSky(Int(Param(params, 0))); return true; }
		if (name == "handmagic_righthand") { OnHandmagicRighthand(Param(params, 0)); return true; }
		if (name == "setup_sprite_2") { OnSetupSprite2(); return true; }
		return MagicHandBaseClScript::DispatchEvent(name, params);
	}
}
