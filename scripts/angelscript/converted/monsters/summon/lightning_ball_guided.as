#pragma context server

// Converted from monsters/summon/lightning_ball_guided.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/fire_ball_guided.as"

[script "monsters/summon/lightning_ball_guided"]
class LightningBallGuided : FireBallGuidedScript
{
	// Variables declared by included files, with the value they start with in this script
	LightningBallGuided()
	{
		SOUND_SPAWN = "debris/beamstart4.wav";
		SOUND_EXPLODE = "ambience/alienlaser1.wav";
		SPRITE_EXPLODE = "xfire2.spr";
		MY_SPEED = "100";
		AM_LIGHTNING = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("ball lightning");
		SetHealth(30); // may make this adjustable
		SetFly(true);
		SetWidth(32);
		SetHeight(32);
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 15);
		SetInvincible(true); // weird gibbing happening, just gonna make invuln
		PLAYING_DEAD = "1";

		SetMonsterClip(false);

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		// check attatchsprite/light commands here
		PlaySound(0, 10, SOUND_SPAWN);

		SetIdleAnim("spin_horizontal_norm");
		SetSolid("none");

		ClientEvent("new", "all", "monsters/summon/guided_ball_cl", IndexOf(ENT_ME), Vector3(255, 255, 0));
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// go_splodie
	void OnGoSplodie()
	{
		int count;
		CallEventDelayed(0.1f, "remove_me");
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		// effect tempent spray SPRITE_EXPLODE game.monster.origin 0 1 0 0
		SetModel("none");
		DoDamageEx(MyOrigin(), MY_AOE, MY_BASE_DMG, 0.1f, MY_OWNER, MY_OWNER, "spellcasting.lightning", "lightning");
		PUSH_LIST = LegacyFunction("get_tsphere", "enemy", MY_AOE, MyOrigin());
		if (PUSH_LIST != "none")
		{
			count = GetTokenCount(PUSH_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnPushLoop();
			}
		}
		// attachsprite SPRITE_EXPLODE trans 20 1.0
		PlayRandomSound(0, 10, SOUND_EXPLODE);
		// drop splodie sprite here
		IS_ACTIVE = false;
	}

	// push_loop
	void OnPushLoop()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(PUSH_LIST, loopIteration));
		DebugPrint("push_loop " + NameOf(curTarget) + " of " + PUSH_LIST);
		Vector3 targetOrg = OriginOf(curTarget);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetVelocity(curTarget, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 500, 0))); // a little to the left too, in case he's stuck up against a wall
		Effect("screenfade", @curTarget, 3, 1, Vector3(255, 255, 255), 255, "fadein");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "push_loop") { OnPushLoop(); return true; }
		return FireBallGuidedScript::DispatchEvent(name, params);
	}
}
