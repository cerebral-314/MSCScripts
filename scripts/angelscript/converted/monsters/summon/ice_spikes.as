#pragma context server

// Converted from monsters/summon/ice_spikes.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/ice_spikes"]
class IceSpikes : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string DMG_ICE = "DMG_ICE";
	float MY_RADIUS = 0.0f;
	string NUM_SPIKES = "NUM_SPIKES";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_SCRIPT_ID = "MY_SCRIPT_ID";

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// MY_OWNER DMG_ICE ICE_RADIUS ICE_AMT
		MY_OWNER = creatorValue1;
		DMG_ICE = creatorValue2;
		MY_RADIUS = Float(damage);
		NUM_SPIKES = skill;

		// dbg ice_spikes set $get(MY_OWNER,name) dmg DMG_ICE rad MY_RADIUS num NUM_SPIKES
		CallEventDelayed(0.1f, "apply_damage");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Ice Spikes");
		SetSolid("none");
		SetWidth(32);
		SetHeight(32);
		SetRace("beloved");
		PLAYING_DEAD = "1"; // not valid target
		SetInvincible(true);
	}

	// apply_damage
	void OnApplyDamage(CBaseEntity@ target = null)
	{
		ClientEvent("new", "all", "monsters/summon/ice_spikes", OriginOf(ENT_ME), MY_RADIUS, NUM_SPIKES);
		MY_SCRIPT_ID = LastClientScriptId();

		Vector3 dmgPos = MyOrigin();
		// <position> 	<range> 	<dmg> 	<cth> 	<attn> 	<flags> 	[type]
		CallExternal(MY_OWNER, "send_damage", dmgPos, MY_RADIUS, DMG_ICE, "100%", 0, "reflective", "pierce");
		DoDamageEx(dmgPos, MY_RADIUS, DMG_ICE, 0, MY_OWNER, MY_OWNER, "spellcasting.ice", "ice");

		PlaySound(0, 10, "magic/freeze.wav");
		CallEventDelayed(5.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		ClientEvent("remove", "all", MY_SCRIPT_ID);
		CallEventDelayed(1.0f, "remove_me2");
	}

	// remove_me2
	void OnRemoveMe2()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_damage") { OnApplyDamage(EntityParam(params, 0)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "remove_me2") { OnRemoveMe2(); return true; }
		return false;
	}
}
