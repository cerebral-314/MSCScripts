#pragma context server

// Converted from lodagond/ice_mage_image.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "lodagond/ice_mage_image"]
class IceMageImage : ScriptEntity
{
	// Constants
	float FREQ_BEAM = 3.0f;
	float BEAM_DURATION = 50.0f;
	string ANIM_TALK = "ref_shoot_staff";
	string FINGER_ADJ = "$relpos($vec(0,MY_YAW,0),$vec(0,30,54))";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string MY_OWNER = "MY_OWNER";
	string MAGE_NAME = "MAGE_NAME";

	// unnamed block (first think)
	void IceMageImage_FirstThink()
	{
		IS_UNHOLY = true;
	}

	// game_spawn
	// {
	// repeatdelay FREQ_BEAM
	// effect tempent trail 3dmflaora.spr $relpos(0,0,0) $relpos(0,0,32) 10 1 1 5 12
	// }
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetModel("monsters/ice_mage.mdl"); // check model name
		SetName("Ice Mage");

		// setprop ent_me skin 1
		SetInvincible(true);
		// setsolid none
		// setbbox none
		SetRace("demon");
		SetWidth(32);
		SetHeight(96);

		SetProp(ENT_ME, "skin", 1);

		SetNoPush(true);

		SetSayTextRange(2048);
		ServerPlaySound(1, 1, "magic/freezeray_loop_quiet.wav");
		SetIdleAnim("ref_shoot_rayspell");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// worried that name_unique may not take variables, do passing indirect
		MY_OWNER = creatorValue1;
		MAGE_NAME = creatorValue2;
		if (MAGE_NAME == "mage1")
		{
			SetName("Ice Mage Zarcon");
			SetUniqueName("mage1");
		}
		if (MAGE_NAME == "mage2")
		{
			SetName("Ice Mage Phrezax");
			SetUniqueName("mage2");
		}
		if (MAGE_NAME == "mage3")
		{
			SetName("Ice Mage Frozon");
			SetUniqueName("mage3");
		}
		if (MAGE_NAME == "mage4")
		{
			SetName("Ice Mage Depthaw");
			SetUniqueName("mage4");
		}
		SetAngle("face", MY_OWNER);
		CallEventDelayed(0.1f, "straighten_up");
	}

	// straighten_up
	void OnStraightenUp()
	{
		int myYaw = Int(Eval("game.monster.angles.yaw"));
		SetAngle("face", Vector3(0, myYaw, 0));
		CallEventDelayed(1.0f, "draw_beam");
	}

	// ext_convo2
	void OnExtConvo2()
	{
		PlayAnim("critical", ANIM_TALK);
		// Zarcon(1) [med]
		SayText("I'm sorry, we were told to freeze you here forever.");
		PlaySound(2, 10, "voices/sc_convo2.wav");
	}

	// ext_convo3
	void OnExtConvo3()
	{
		PlayAnim("critical", ANIM_TALK);
		// Phrezax(2) [low]
		SayText("Yes, releasing you would rather countermand orders...");
		PlaySound(2, 10, "voices/sc_convo3.wav");
	}

	// ext_convo4
	void OnExtConvo4()
	{
		PlayAnim("critical", ANIM_TALK);
		// Frozon(3) [high]
		SayText("If only you had pledged your loyalty to Lor Malgoriand, we wouldn't have to waste our time.");
		PlaySound(2, 10, "voices/sc_convo4.wav");
	}

	// ext_convo6
	void OnExtConvo6()
	{
		PlayAnim("critical", ANIM_TALK);
		// Depthaw(4) [russ]
		SayText("Maldora IS Lor Malgoriand you insolent fool!");
		PlaySound(2, 10, "voices/sc_convo6.wav");
	}

	// ext_convo7
	void OnExtConvo7()
	{
		PlayAnim("critical", ANIM_TALK);
		// Frozon(3) [high]
		SayText("And we will be there when he is restored to his throne in the Palace of Shae-hae-deed.");
		PlaySound(2, 10, "voices/sc_convo7.wav");
	}

	// ext_convo9
	void OnExtConvo9()
	{
		PlayAnim("critical", ANIM_TALK);
		// Phrezax(2) [low]
		SayText("Oh we see them, and when we're done with you...");
		PlaySound(2, 10, "voices/sc_convo9.wav");
	}

	// ext_convo10
	void OnExtConvo10()
	{
		PlayAnim("critical", ANIM_TALK);
		// Frozon(3) [high]
		SayText("We'll mount their corpses in this beautiful ice casket, along with yours.");
		PlaySound(2, 10, "voices/sc_convo10.wav");
	}

	// ext_mage_go
	void OnExtMageGo()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		ServerPlaySound(1, 0, "magic/freezeray_loop_quiet.wav");
		CreateNpc("monsters/ice_mage", RelativePosition(Vector3(0, 0, 0)), NameOf(ENT_ME), MY_OWNER);
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// draw_beam
	void OnDrawBeam()
	{
		// beam end	<spritename>	<width>	<startpos>				<target>	<att>	<(rrr,gggg,bbb)>	<brightness>	<noise>		<duration>
		// effect	beam end	lgtning.spr		100		game.monster.origin		BEAM_TARGET	3		(200,200,255)		255				1			BEAM_DURATION
		Vector3 traceStart = OriginOf(ENT_ME);
		float myYaw = MyAngles().y;
		traceStart += Vec(FINGER_ADJ); // start fingers
		Vector3 traceEnd = OriginOf(MY_OWNER) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 64));
		Effect("beam", "point", "lgtning.spr", 10, traceStart, traceEnd, Vector3(200, 200, 255), 255, 0, BEAM_DURATION);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/ice_mage.mdl");
		Precache("magic/freezeray_loop_quiet.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		IceMageImage_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "draw_beam") { OnDrawBeam(); return true; }
		if (name == "ext_convo10") { OnExtConvo10(); return true; }
		if (name == "ext_convo2") { OnExtConvo2(); return true; }
		if (name == "ext_convo3") { OnExtConvo3(); return true; }
		if (name == "ext_convo4") { OnExtConvo4(); return true; }
		if (name == "ext_convo6") { OnExtConvo6(); return true; }
		if (name == "ext_convo7") { OnExtConvo7(); return true; }
		if (name == "ext_convo9") { OnExtConvo9(); return true; }
		if (name == "ext_mage_go") { OnExtMageGo(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "straighten_up") { OnStraightenUp(); return true; }
		return false;
	}
}
