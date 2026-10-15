#pragma context server

// Converted from traps/orc_fire_wall.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/traps/fire_wall.as"

[script "traps/orc_fire_wall"]
class OrcFireWall : FireWallScript
{
	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string OrcFireWall_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// if ( $get(PARAM2,isplayer) ) applyeffect PARAM2 effects/dot_fire 2 $get(ent_me,id) MY_BASE_DMG 1
		if (IsAlive(target) && RelationshipOf(ENT_ME, @target) != "ally")
			ApplyEffect(target, "effects/dot_fire", 2, self, MY_BASE_DMG);
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PLAYING_DEAD = "1"; // not valid target

		SetName("Fire Wall Trap");
		SetHealth(5);
		SetRace("orc");
		SetInvincible(true);
		SetRoam(false);
		SetSkillLevel(0);
		SetHearingSensitivity(0);
		SetModel("null.mdl");
		PLAYING_DEAD = "1";

		CallEventDelayed(0.1f, "flames_start");

		// emitsound ent_me $get(ent_me,origin) 192 TIME_LIVE danger 192
		MY_OWNER = EntityId(self);
		MY_BASE_DMG = 120.0f;

		float removeTime = FIRE_DURATION - 0.5f;
		CallEventDelayed(removeTime, "remove_invul");

		CallEventDelayed(FIRE_DURATION, "firewall_death"); // Die after a delay

		SetAngle("face.y", AnglesOf(ENT_ME).y);
		ClientEvent("new", "all", "traps/orc_fire_wall", OriginOf(ENT_ME), AnglesOf(ENT_ME).y); // Send to client immediately - calls client_activate on client
		FLAME_ID = LastClientScriptId();
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return OrcFireWall_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// firewall_death
	// Pewf
	void OnFirewallDeath()
	{
		FLAMING = false;
		OnFirewallEndCl();
		PlaySound(Int(GetVar("CHAN_ITEM")), Eval("game.sound.silentvol"), "items/torch1.wav");
		ClientEvent("remove", "all", FLAME_ID);
		RemoveScript();
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "firewall_death") { OnFirewallDeath(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return FireWallScript::DispatchEvent(name, params);
	}
}
