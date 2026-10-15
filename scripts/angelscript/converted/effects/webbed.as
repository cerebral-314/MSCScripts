#pragma context server

// Converted from effects/webbed.script by msc_transpiler.
// Webbed npcs are slowed. Continuous webbing cocoons the target.
// Stacked webbed effects increase the intensity of the web.
// Large enemies take more web to cocoon
// Small enemies dont take as much web to cocoon
// . effectmestack effects/webbed 10 GAME_MASTER

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_effect.as"

[script "effects/webbed"]
class Webbed : BaseEffectScript
{
	// Constants
	int PLAYER_WEB_TILL_COCOON = 10;
	int WEB_FOR_SIZE = 17;

	// Variables (an unset .script variable reads as its own name)
	string WEB_DECAY_TIME = "0";
	float WEBS_ATTACHED = 0.0f;
	float WEBS_TILL_COCOON = 0.0f;
	bool EFFECT_DUPLICATED = false;
	float NEXT_DECAY = 0.0f;
	string CLFX_ID = "CLFX_ID";
	bool DID_COCOON = false;

	// Variables declared by included files, with the value they start with in this script
	Webbed()
	{
		EFFECT_ID = "webbed";
	}

	// unnamed block (first think)
	void Webbed_FirstThink()
	{
		WEBS_ATTACHED = 0.0f;
		WEBS_TILL_COCOON = 0.0f; // Set in game_activate

		WEB_DECAY_TIME = "0"; // Largest decay time will override any subsequent smaller ones
	}

	// game_activate
	// PARAM1 = Single web decay time; PARAM2 = Webber
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect

		// Largest decay time will override any smaller ones

		if (Truthy(ScriptFlag(ENT_ME, "spider_resist", "type_exists"))) // Get immunity
		{
			PlayerMessage(amount, NameOf(ENT_ME) + " is immune to webs!");

			EFFECT_DUPLICATED = true; // Helps prevent silliness
			RemoveScript();
			return;
		}

		if (!EFFECT_DUPLICATED) // First instance of web
		{
			// set up fx
			// clientevent new all effects/sfx_webbed $get(ent_me,index) WEBS_ATTACHED
			OnSetCocoonAmt(); // Get amt of webs until cocoon

			SetVar(Eval("game.effect.canjump"), 0); // No jump allowed while webbed
			SetVar(Eval("game.effect.canrun"), 0); // No running, the movespeed change will make run ineffective anyways

			PlayerMessage(ENT_ME, "You have been webbed!");
		}

		CallExternal(self, "ext_webbed", duration); // Apply a web
	}

	// effect_die
	void OnEffectDie()
	{
		BaseEffect_OnEffectDie(); // effects/base_effect

		if (EFFECT_DUPLICATED)
			return;
		if (IsPlayer(ENT_ME))
		{
			if (!DID_COCOON)
				PlayerMessage(ENT_ME, "The webs have fallen away.");
			else
				PlayerMessage(ENT_ME, "You struggle your way out of the cocoon.");
		}

		if (Truthy(CLFX_ID))
			ClientEvent("update", "all", CLFX_ID, "fx_die");
	}

	// game_duplicated
	// Gets called before game_activate
	void OnGameDuplicated()
	{
		BaseEffect_OnGameDuplicated(); // effects/base_effect

		if (!EFFECT_DUPLICATED)
		{
			EFFECT_DUPLICATED = true;
			RemoveScript();
		}
	}

	// set_cocoon_amt
	// sets WEBS_TILL_COCOON by either player, or volume
	void OnSetCocoonAmt()
	{
		if (IsPlayer(ENT_ME))
		{
			WEBS_TILL_COCOON = PLAYER_WEB_TILL_COCOON;
		}
		else
		{
			float mySize = Divide(HeightOf(ENT_ME) + WidthOf(ENT_ME), WEB_FOR_SIZE);

			WEBS_TILL_COCOON = Clamp(int(mySize), 2.0f, 20.0f);
		}
	}

	// ext_webbed
	void OnExtWebbed(string decayTime = "")
	{
		if (EFFECT_DUPLICATED)
			return;
		if (DID_COCOON)
			return;

		if (Float(decayTime) > Float(WEB_DECAY_TIME)) // Keep longest web decay time applied
			WEB_DECAY_TIME = decayTime;

		WEBS_ATTACHED += 1.0f; // Attach a web

		if (WEBS_ATTACHED < WEBS_TILL_COCOON)
		{
			// Override original effect end time
			EFFECT_STARTED = GameTime();
			EFFECT_DURATION = Text(Float(WEB_DECAY_TIME) * WEBS_ATTACHED);

			// Set next decay timer
			NEXT_DECAY = GameTime() + Float(WEB_DECAY_TIME);
			CallEventOrDelay(WEB_DECAY_TIME, "web_decay");

			// Update slowness and web fx intensity
			OnWebUpdate();

			PlaySound(0, 10, "bullchicken/bc_acid2.wav");
		}
		else
		{
			OnStartCocoon();
		}

		// Client fx
		if (!Truthy(CLFX_ID))
		{
			ClientEvent("new", "all", "effects/sfx_webbed", WEB_DECAY_TIME, IndexOf(ENT_ME), WEBS_TILL_COCOON);
			CLFX_ID = LastClientScriptId();
		}
		else
		{
			ClientEvent("update", "all", CLFX_ID, "ext_webbed", WEB_DECAY_TIME);
		}
	}

	// web_decay
	void OnWebDecay()
	{
		if (DID_COCOON)
			return;
		if (GameTime() >= NEXT_DECAY)
		{
			PlayerMessage(ENT_ME, "Some of the webs loosen.");
			WEBS_ATTACHED -= 1.0f;

			// Set next decay timer
			NEXT_DECAY = GameTime() + Float(WEB_DECAY_TIME);
			CallEventOrDelay(WEB_DECAY_TIME, "web_decay");

			OnWebUpdate();
		}
	}

	// web_update
	void OnWebUpdate()
	{
		float speedFactor = Divide(WEBS_ATTACHED, WEBS_TILL_COCOON);

		float speed = 50.0f * speedFactor;

		SetVar(Eval("game.effect.movespeed"), 100.0f - speed);
		SetVar(Eval("game.effect.anim.framerate"), 1.0f - speedFactor);
	}

	// start_cocoon
	void OnStartCocoon()
	{
		DID_COCOON = true;

		PlayerMessage(ENT_ME, "The sticky web envelopes you in a cocoon, rendering you immovable.");
		PlaySound(0, 10, "debris/bustflesh1.wav");
		ScriptFlags(ENT_ME, "add", "cocooned", "nopush", 1, -1, "none");

		SetVar(Eval("game.effect.canattack"), 0);
		SetVar(Eval("game.effect.canduck"), 0);
		SetVar(Eval("game.effect.movespeed"), 0.001f);
		SetVar(Eval("game.effect.anim.framerate"), 0.001f);

		if (!IsPlayer(ENT_ME))
		{
			// For npcs
			CallExternal(ENT_ME, "freeze_solid_start", WEB_DECAY_TIME);
		}

		CallEventOrDelay(WEB_DECAY_TIME, "end_cocoon");
	}

	// end_cocoon
	void OnEndCocoon()
	{
		ScriptFlags(ENT_ME, "remove", "cocooned");
		PlaySound(0, 10, "debris/bustflesh1.wav");

		RemoveScript();
	}

	// game_predeath
	void OnGamePredeath()
	{
		SetVar(Eval("game.effect.canattack"), 1);
		SetVar(Eval("game.effect.canduck"), 1);
		SetVar(Eval("game.effect.movespeed"), 100);
		SetVar(Eval("game.effect.anim.framerate"), 1);
		CallExternal(ENT_ME, "freeze_solid_end", 1);

		OnEndCocoon();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnWebDecayTime() {} // WEB_DECAY_TIME

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Webbed_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "effect_die") { OnEffectDie(); return true; }
		if (name == "end_cocoon") { OnEndCocoon(); return true; }
		if (name == "ext_webbed") { OnExtWebbed(Param(params, 0)); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_duplicated") { OnGameDuplicated(); return true; }
		if (name == "game_predeath") { OnGamePredeath(); return true; }
		if (name == "set_cocoon_amt") { OnSetCocoonAmt(); return true; }
		if (name == "start_cocoon") { OnStartCocoon(); return true; }
		if (name == "web_decay") { OnWebDecay(); return true; }
		if (name == "web_update") { OnWebUpdate(); return true; }
		return BaseEffectScript::DispatchEvent(name, params);
	}
}
