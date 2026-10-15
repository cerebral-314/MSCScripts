#pragma context server

// Converted from monsters/summon/summon_lightning_storm.script by msc_transpiler.
// Lightning Storm
// Does friendly damage, but only to players

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

[script "monsters/summon/summon_lightning_storm"]
class SummonLightningStorm : BaseAoeScript
{
	// Constants
	int STORM_HEIGHT = 260;
	string SMOKE_SPRITE = "bigsmoke.spr";
	string LIGHTNING_SPRITE = "lgtning.spr";
	string LIGHTNING_SPRITE_SPARKS = "3dmflaora.spr";
	int STORM_WIDTH = 75;

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	float LOOP_SOUND = 0.0f;
	string AOE_OWNER = "AOE_OWNER";
	string MY_ITEM = "MY_ITEM";
	float NEG_WIDTH = 0.0f;
	float MY_BASE_DAMAGE = 0.0f;
	string BASE_DURATION = "BASE_DURATION";
	float STORM_DURATION = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	string CAST_BY_PLAYER = "CAST_BY_PLAYER";
	string STORM_CLID = "STORM_CLID";

	// Variables declared by included files, with the value they start with in this script
	SummonLightningStorm()
	{
		AOE_FREQ = 1.0f;
		AOE_RADIUS = "150";
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe
		SetName("Lightning Storm");
		SetInvincible(true);
		SetNoPush(true);
		SetGravity(0);

		PLAYING_DEAD = "1"; // not valid target

		LOOP_SOUND = 0.0f;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		AOE_OWNER = creatorValue1;
		MY_OWNER = creatorValue1; // For base_aoe support
		if (Truthy(GetProp(AOE_OWNER, "is_item")))
		{
			MY_ITEM = AOE_OWNER;
			AOE_OWNER = EntityId(OwnerOf(MY_ITEM));
			MY_OWNER = AOE_OWNER;
		}

		NEG_WIDTH = -STORM_WIDTH;

		SetAngle("face.y", creatorValue2);

		MY_BASE_DAMAGE = Float(damage);
		BASE_DURATION = skill;
		STORM_DURATION = GameTime() + Float(skill);
		ACTIVE_SKILL = extraValue5;

		CAST_BY_PLAYER = GetProp(MY_ITEM, "is_item");

		float fGroundZ = GroundHeight(MyOrigin());
		DebugPrint("GroundLevelSentToClient: " + Text(fGroundZ));

		ClientEvent("new", "all", "monsters/summon/summon_lightning_storm", OriginOf(ENT_ME), creatorValue2, fGroundZ);
		STORM_CLID = LastClientScriptId();

		OnDoStorm();
		OnCheckDeath();
	}

	// do_storm
	// Deal damage
	void OnDoStorm()
	{
		CallEventDelayed(0.3f, "do_storm");

		LOOP_SOUND += 1.0f;
		if (LOOP_SOUND >= 3.0f)
		{
			PlaySound(0, 6, "weather/lightning.wav");
			LOOP_SOUND = 0.0f;
		}
	}

	// apply_aoe_effect
	// <target>
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		if (HasEffect(target, "DOT_lightning"))
			return;

		float effectDur = 5.0f;

		string ent = AOE_OWNER;
		if (Truthy(GetProp(ent, "is_item")))
		{
			effectDur *= 2.0f;
			ent = EntityId(OwnerOf(ent));
		}

		ApplyEffect(target, "effects/dot_lightning", effectDur, ent, MY_BASE_DAMAGE, ACTIVE_SKILL);
	}

	// sustain_storm
	// <position> //called externally from magic hand
	void OnSustainStorm(string position = "")
	{
		SetOrigin(ENT_ME, Vec(position));
		ClientEvent("update", "all", STORM_CLID, "cl_pos_update", position);
		STORM_DURATION = GameTime() + Float(BASE_DURATION);
	}

	// check_death
	void OnCheckDeath()
	{
		CallEventDelayed(0.5f, "check_death");

		bool remove = false;

		if (GameTime() > STORM_DURATION)
			remove = true;

		if (remove)
		{
			ClientEvent("remove", "all", STORM_CLID);
			CallExternal(MY_ITEM, "storm_ended");
			DeleteEntity(ENT_ME);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflaora.spr");
		Precache("bigsmoke.spr");
		Precache("lgtning.spr");
		CallEventDelayed(0.5f, "check_death");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "check_death") { OnCheckDeath(); return true; }
		if (name == "do_storm") { OnDoStorm(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "sustain_storm") { OnSustainStorm(Param(params, 0)); return true; }
		return BaseAoeScript::DispatchEvent(name, params);
	}
}
