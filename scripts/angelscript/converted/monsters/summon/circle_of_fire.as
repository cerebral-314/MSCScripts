#pragma context server

// Converted from monsters/summon/circle_of_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/circle_of_fire"]
class CircleOfFire : ScriptEntity
{
	// Constants
	string SOUND_MANIFEST = "weapons/egon_windup2.wav";
	string SOUND_PULSE = "magic/egon_run3_noloop.wav";
	float PULSE_PLAYTIME = 2.1f;
	string SOUND_FADE = "weapons/egon_off1.wav";
	string SEAL_MODEL = "weapons/magic/seals.mdl";
	string SEAL_OFS = "1";
	string FX_SPRITE = "Fire2.spr";
	int CIRCLE_RADIUS = 128;
	string APPLY_EFFECT = "effects/dot_fire";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DURATION = "MY_DURATION";
	float MY_BASE_DAMAGE = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int GAME_PVP = 0;
	bool CIRCLE_ON = false;
	string THIS_SCRIPT_CLIENT_ID = "THIS_SCRIPT_CLIENT_ID";
	bool CIRCLE_UP = false;
	bool DID_WINDUP = false;
	string SCAN_TARGS = "SCAN_TARGS";

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = Duration PARAM3 = Damage
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DURATION = creatorValue2;
		MY_BASE_DAMAGE = Float(damage);

		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));
		GAME_PVP = (IsPvp() ? 1 : 0);

		CallEventOrDelay(MY_DURATION, "circle_end");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Circle of Fire");
		SetHealth(1);
		SetFieldOfView(359); // poison cloud dont have this
		SetInvincible(true);
		SetRace("beloved");
		SetHeight(2);
		SetWidth(2);
		SetFly(true);
		SetGravity(0);
		SetBlood("none");
		SetModel("none"); // SEAL_MODEL
		// setidleanim idle
		SetSolid("none");

		// drop_to_floor
		CIRCLE_ON = true;

		CallEventDelayed(0.1f, "make_seal");

		// tempent trail <modelname/spritename> <start> <dest> <count> <life> <scale> <speed> <randomness>
		CallEventDelayed(1.0f, "circle_go");

		CallEventDelayed(0.1f, "circle_hum");
	}

	// make_seal
	void OnMakeSeal()
	{
		Vector3 sealPos = OriginOf(ENT_ME);
		float groundZ = GroundHeight(sealPos);
		float sealZ = sealPos.z;
		float groundDist = groundZ - sealZ;
		// //dbg MyBasePos SEAL_POS GroundZ GROUND_Z
		sealPos += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, groundDist));
		// //dbg MyGroundPos SEAL_POS Ground GROUND_DIST
		CreateNpc("monsters/summon/seal_maker", sealPos, SEAL_MODEL, MY_DURATION, SEAL_OFS);
	}

	// circle_hum
	void OnCircleHum()
	{
		// drop_to_floor ent_me
		// playanim once idle
		if (!CIRCLE_UP)
		{
			// clientevent persist all $currentscript effect.duration $get(ent_me,index) PARAM2 GLOW_COLOR
			float clientDuration = Float(MY_DURATION);
			clientDuration -= 0.2f; // effort to prevent client side fx from sticking
			ClientEvent("new", "all_in_sight", "monsters/summon/circle_of_fire", clientDuration, IndexOf(ENT_ME), 128);
			THIS_SCRIPT_CLIENT_ID = LastClientScriptId();

			// dbg StickyClientDebug game.script.last_sent_id
			CIRCLE_UP = true;
		}

		if (DID_WINDUP)
			PlaySound(0, 5, SOUND_PULSE);
		if (!DID_WINDUP)
		{
			PlaySound(0, 10, SOUND_MANIFEST);
			DID_WINDUP = true;
		}

		if (!CIRCLE_ON)
			return;
		CallEventDelayed(PULSE_PLAYTIME, "circle_hum");
	}

	// circle_go
	void OnCircleGo()
	{
		if (!CIRCLE_ON)
			return;

		CallEventDelayed(0.25f, "circle_go");

		SCAN_TARGS = FindInSphere("any", CIRCLE_RADIUS);

		if (SCAN_TARGS == "none")
			return;
		int nTargs = GetTokenCount(SCAN_TARGS);
		if (!(nTargs > 0))
			return;

		for (int i = 0; i < nTargs; i++)
		{
			loopIteration = i;
			OnZapTargets();
		}

		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), CIRCLE_RADIUS, 0, "100%", 0, "reflective");

		if (!CanSee("ally"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) <= CIRCLE_RADIUS))
			return;
		if (RelationshipOf(ENT_LASTSEEN, MY_OWNER) != "enemy")
			return;
		// //dbg Saw $get(ent_lastseen,name)
		string dmgSource = MY_OWNER;
		// if ( $get(MY_OWNER,isplayer) == 0 ) local DMG_SOURCE $get(ent_me,id)
		if (HasEffect(ENT_LASTSEEN, "DOT_fire"))
			return;
		ApplyEffect(ENT_LASTSEEN, APPLY_EFFECT, 1, dmgSource, MY_BASE_DAMAGE);
	}

	// zap_targs
	void OnZapTargs()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TARGS, loopIteration));
		if (!IsAlive(curTarg))
			return;
		if (RelationshipOf(curTarg, MY_OWNER) != "enemy")
			return;
		string dmgSource = MY_OWNER;
		if (Truthy(OWNER_ISPLAYER) && GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;
		if (HasEffect(curTarg, "DOT_fire"))
			return;
		ApplyEffect(curTarg, APPLY_EFFECT, 1, dmgSource, MY_BASE_DAMAGE);
	}

	// circle_end
	void OnCircleEnd()
	{
		CIRCLE_ON = false;

		ClientEvent("remove", "all", THIS_SCRIPT_CLIENT_ID);
		PlaySound(0, 10, SOUND_FADE);
		CallEventDelayed(0.5f, "circle_remove");
	}

	// circle_remove
	void OnCircleRemove()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION
	void OnPulsePlaytime() {} // PULSE_PLAYTIME
	void OnZapTargets() {} // zap_targets

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "circle_end") { OnCircleEnd(); return true; }
		if (name == "circle_go") { OnCircleGo(); return true; }
		if (name == "circle_hum") { OnCircleHum(); return true; }
		if (name == "circle_remove") { OnCircleRemove(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "make_seal") { OnMakeSeal(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "zap_targs") { OnZapTargs(); return true; }
		return false;
	}
}
