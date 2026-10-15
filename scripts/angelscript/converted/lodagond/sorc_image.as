#pragma context server

// Converted from lodagond/sorc_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "lodagond/sorc_image"]
class SorcImage : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float ANIM_SPEED = 0.0f;
	string FACE_YAW = "FACE_YAW";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("monsters/sorc.mdl");
		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 3); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_chieften 4=lizard_cap
		SetModelBody(2, 8); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker

		SetNoPush(true);

		SetInvincible(true);
		SetSolid("none");
		SetRace("demon");

		SetName("Runegahr, Shadahar Orc Chieftain");

		SetSayTextRange(2048);
		ANIM_SPEED = 1.0f;
		SetAnimFrameRate(ANIM_SPEED);

		Effect("glow", ENT_ME, Vector3(200, 200, 255), 32, -1, 0);
	}

	// ext_convo1
	void OnExtConvo1()
	{
		SetSayTextRange(2048);
		SayText("Release me!");
		PlaySound(0, 10, "voices/sc_convo1.wav");
		PlayAnim("critical", "warcry");
		CallEventDelayed(0.1f, "slow_down");
	}

	// ext_convo5
	void OnExtConvo5()
	{
		PlayAnim("critical", "warcry");
		PlaySound(0, 10, "voices/sc_convo5.wav");
		SayText("Ha! Maldora is NOT the Doom Bringer! He's an imposter with delusions of grandeur!");
	}

	// ext_convo8
	void OnExtConvo8()
	{
		PlayAnim("critical", "warcry");
		PlaySound(0, 10, "voices/sc_convo8.wav");
		SayText("You'll... be dead before that happens! If you'd bother to look behind you...");
	}

	// slow_down
	void OnSlowDown()
	{
		if (!(ANIM_SPEED >= 0.01f))
			return;
		CallEventDelayed(0.25f, "slow_down");
		ANIM_SPEED -= 0.05f;
		if (ANIM_SPEED <= 0.01f)
			ANIM_SPEED = 0.0001f;
		DebugPrint("slow_down " + Text(ANIM_SPEED));
		SetAnimFrameRate(ANIM_SPEED);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FACE_YAW = creatorValue1;
		CallEventDelayed(0.1f, "set_yaw");
	}

	// set_yaw
	void OnSetYaw()
	{
		SetAngle("face", Vector3(0, Float(FACE_YAW), 0));
	}

	// sorc_in
	void OnSorcIn()
	{
		// delay for mapper tools
		CallEventDelayed(1.0f, "sorc_go");
	}

	// sorc_go
	void OnSorcGo()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		UseTrigger("sorc_go");
		CreateNpc("monsters/sorc_chief1", RelativePosition(Vector3(0, 0, 0)));
		PlaySound(0, 10, "debris/bustglass3.wav");
		Effect("tempent", "gibs", "glassgibs.mdl", RelativePosition(Vector3(0, 0, 32)), 1, 40, 10, 100, 30);
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_convo1") { OnExtConvo1(); return true; }
		if (name == "ext_convo5") { OnExtConvo5(); return true; }
		if (name == "ext_convo8") { OnExtConvo8(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "set_yaw") { OnSetYaw(); return true; }
		if (name == "slow_down") { OnSlowDown(); return true; }
		if (name == "sorc_go") { OnSorcGo(); return true; }
		if (name == "sorc_in") { OnSorcIn(); return true; }
		return false;
	}
}
