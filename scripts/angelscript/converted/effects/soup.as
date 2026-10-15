#pragma context server

// Converted from effects/soup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/soup"]
class Soup : ScriptEntity
{
	// Constants
	float SOUP_TICKRATE = 0.5f;

	// Variables (an unset .script variable reads as its own name)
	float FX_DURATION = 0.0f;
	string FX_POOPY = "FX_POOPY";
	float HP_AMT = 0.0f;
	float MP_AMT = 0.0f;
	float NERF_TICK = 0.0f;
	float FX_END_TIME = 0.0f;

	// unnamed block (first think)
	// soup soup soup soup soup soup soup soup soup soup soup soup soup soup soup
	void Soup_FirstThink()
	{
		SetLocal("reg.effect.name", "soup"); // soup soup soup soup soup soup soup soup
		SetVar(Eval("game.effect.id"), "soup"); // dumb variable is required
		SetLocal("reg.effect.flags", "nostack"); // soup soup soup soup soup soup soup soup
		SetLocal("reg.effect.script", "effects/soup"); // soup soup soup soup soup soup
		// soup soup soup soup soup soup soup soup soup soup soup soup soup soup
		SetVar(Eval("game.effect.removeondeath"), 1); // soup soup soup soup soup soup soup
		// soup soup soup soup soup soup soup soup soup soup soup soup soup soup
		LegacyCommand("registereffect"); // soup soup soup soup soup soup soup soup soup soup soup
	}

	// unnamed block (timer)
	void Soup_Timer()
	{
		CallEventDelayed(SOUP_TICKRATE, "Soup_Timer");

		GiveHealth(HP_AMT);
		GiveMana(MP_AMT);
	}

	// game_activate
	// soup soup soup soup soup soup soup soup soup soup soup soup soup soup soup
	// <duration> <0|1:occasionally drop a brap>
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		FX_DURATION = Float(duration);
		// setvard FX_END_TIME $math(add,game.time,FX_DURATION)
		FX_POOPY = amount;

		HP_AMT = 38.0f;
		MP_AMT = 58.0f;

		NERF_TICK = 9.0f;

		CallEventDelayed(FX_DURATION, "soup_duration_end");
		CallEventDelayed(NERF_TICK, "nerf_soup");
	}

	// nerf_soup
	void OnNerfSoup()
	{
		HP_AMT = Divide(HP_AMT, 2.0f);
		MP_AMT = Divide(MP_AMT, 2.0f);

		NERF_TICK *= 2.0f;

		if (Truthy(FX_POOPY))
		{
			PlaySound(0, 10, "fart.wav", Random(0.6f, 1), RandomInt(50, 150)); // [Attenuation:0.8] [Pitch:100]

			PlayerMessage(ENT_ME, "Oh no. You let one squeak out.");
			DoDamageEx(OriginOf(ENT_ME), 65, 10, 0, ENT_ME, ENT_ME, "spellcasting.affliction", "poison_effect", "dmgevent:poopy");

			// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
			ClientEvent("new", "all", "effects/sfx_poison_cloud", OriginOf(ENT_ME), 20, 1, 0); // <loc> <aoe> <duration> [playsound:0|1]
		}

		CallEventDelayed(NERF_TICK, "nerf_soup");
	}

	// poopy_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void OnPoopyDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (!(DamageTakenOf(target, "poison") > 0.0f))
			return;

		ApplyEffect(target, "effects/dot_poison", 6, self, 10, 0, "spellcasting.affliction");

		if (RandomInt(0, 3) != 0)
			return;
		if (RaceOf(target) == "vermin")
			return;
		if (RaceOf(target) == "wildanimal")
			return;
		if (RaceOf(target) == "spider")
			return;
		if (Contains(RaceOf(target), "ant_"))
			return;

		string str = "Ewww! What's that smell?;What is that *foul* magic!?;I can... taste... apples?;Ack! It got on me!;What in the world did Torkalath let loose!?;";
		CallExternal(target, "ext_speak", GetRandomToken(str));
	}

	// soup_duration_end
	void OnSoupDurationEnd()
	{
		PlayerMessageGreen(ENT_ME, "Ah, that soup was good while it lasted...");
		RemoveScript();
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		FX_END_TIME = 0.0f;
		OnSoupDurationEnd();
	}

	// ext_resetsoup
	void OnExtResetsoup()
	{
		HP_AMT = 38.0f;
		MP_AMT = 58.0f;

		NERF_TICK = 9.0f;

		FX_END_TIME = GameTime() + FX_DURATION;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFxDuration() {} // FX_DURATION
	void OnNerfTick() {} // NERF_TICK

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(SOUP_TICKRATE, "Soup_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Soup_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_resetsoup") { OnExtResetsoup(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "nerf_soup") { OnNerfSoup(); return true; }
		if (name == "poopy_dodamage") { OnPoopyDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "soup_duration_end") { OnSoupDurationEnd(); return true; }
		if (name == "Soup_Timer") { Soup_Timer(); return true; }
		return false;
	}
}
