#pragma context server

// Converted from monsters/summon/fire_wave.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/fire_wave"]
class FireWave : ScriptEntity
{
	// Constants
	float FWD_SPEED = 10.0f;
	float MY_RADIUS = 76.0f;
	string SOUND_BURN = "ambience/burning2.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_DAMAGE = 0.0f;
	float MY_DOT = 0.0f;
	string MY_DURATION = "MY_DURATION";
	Vector3 NPC_NOCLIP_DEST = Vector3();
	string MY_CL_IDX = "MY_CL_IDX";
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string HIT_TARGS = "HIT_TARGS";

	// unnamed block (timer)
	void FireWave_Timer()
	{
		CallEventDelayed(0.5f, "FireWave_Timer");
		if (!IS_ACTIVE)
			return;

		// xdodamage $relpos(0,0,0) MY_RADIUS MY_DAMAGE 1 MY_OWNER MY_OWNER spellcasting.fire fire
		HIT_TARGS = FindInBox("enemy", MY_RADIUS);
		if (HIT_TARGS == "none")
			return;
		int count = GetTokenCount(HIT_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurnTargets();
		}
	}

	// game_dynamically_created
	// <owner> <dmg> <dot> <duration>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DAMAGE = Float(creatorValue2);
		MY_DOT = Float(damage);
		MY_DURATION = skill;

		SetRace(RaceOf(MY_OWNER));

		float ownerYaw = AnglesOf(MY_OWNER).y;
		NPC_NOCLIP_DEST = MyOrigin() + RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, 9999, 0));

		ClientEvent("new", "all", "monsters/summon/fire_wave", IndexOf(ENT_ME), ownerYaw);
		MY_CL_IDX = LastClientScriptId();

		IS_ACTIVE = true;
		CallEventDelayed(0.1f, "active_loop");
		CallEventOrDelay(MY_DURATION, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		IS_ACTIVE = false;
		PlaySound(Int(GetVar("CHAN_ITEM")), 0, SOUND_BURN);
		ClientEvent("remove", "all", MY_CL_IDX);
		CallEventDelayed(0.1f, "remove_me2");
	}

	// remove_me2
	void OnRemoveMe2()
	{
		DeleteEntity(ENT_ME);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Wave of Fire");
		SetWidth(32);
		SetHeight(32);
		SetModel("none");
		SetSolid("none");
		PLAYING_DEAD = "1";
		SetInvincible(true);

		PlaySound(Int(GetVar("CHAN_ITEM")), 7, SOUND_BURN);
	}

	// active_loop
	void OnActiveLoop()
	{
		if (!IS_ACTIVE)
			return;

		CallEventDelayed(0.1f, "active_loop");

		// setvelocity ent_me $revel(0,50,0)
		// dmg
		// dbg rad MY_RADIUS dmg MY_DAMAGE $get(MY_OWNER,name)
		// xdodamage $relpos(0,0,0) MY_RADIUS MY_DAMAGE 1.0 MY_OWNER MY_OWNER spellcasting.fire fire
		// dodamage $relpos(0,0,0) MY_RADIUS MY_DAMAGE 100% 0.0 reflective fire
		// "flight"
		Vector3 myOrg = MyOrigin() + RelativeVelocity(Vector3(0, FWD_SPEED, 0));
		myOrg.z = GroundHeight(myOrg);
		myOrg.z += 10.0f;
		SetOrigin(ENT_ME, myOrg);

		SetMoveDest(NPC_NOCLIP_DEST, 9999);
	}

	// burn_targets
	void OnBurnTargets()
	{
		string curTarget = GetToken(HIT_TARGS, loopIteration);
		// dbg burn_targets target $get(CUR_TARGET,name) [
		// if $get(CUR_TARGET,isalive)
		ApplyEffect(curTarget, "effects/dot_fire", 10, MY_OWNER, MY_DOT);
		AddVelocity(curTarget, RelativeVelocity(Vector3(-20, 600, 30)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(0.5f, "FireWave_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "active_loop") { OnActiveLoop(); return true; }
		if (name == "burn_targets") { OnBurnTargets(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "remove_me2") { OnRemoveMe2(); return true; }
		if (name == "FireWave_Timer") { FireWave_Timer(); return true; }
		return false;
	}
}
