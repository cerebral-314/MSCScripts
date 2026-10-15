#pragma context server

// Converted from monsters/summon/circle_of_death_old.script by msc_transpiler.
// Circle of Ice, Lesser - by Thothie
// - same as circle of ice but smaller radius, less sprites, and frost_dmg instead of freeze_solid

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "monsters/summon/circle_of_death_old"]
class CircleOfDeathOld : BaseNpcScript
{
	// Constants
	string SEAL_MODEL = "weapons/magic/seals.mdl";
	string SEAL_OFS = "4";
	string SOUND_MANIFEST = "magic/temple.wav";
	string SOUND_PULSE = "magic/pulsemachine_noloop.wav";
	string SOUND_FADE = "magic/frost_reverse.wav";
	string FX_SPRITE = "skull.spr";
	float PULSE_PLAYTIME = 1.7f;
	int CIRCLE_RADIUS = 180;
	float LIGHT_DIE = 1.6f;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DURATION = "MY_DURATION";
	float MY_BASE_DAMAGE = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string MY_SKILL = "MY_SKILL";
	int GAME_PVP = 0;
	string MY_OWNER_RACE = "MY_OWNER_RACE";
	bool CIRCLE_ON = false;
	string THIS_SCRIPT_CLIENT_ID = "THIS_SCRIPT_CLIENT_ID";
	bool CIRCLE_UP = false;
	bool DID_WINDUP = false;
	string CIRCLE_TARGETS = "CIRCLE_TARGETS";

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc

		SetAlive(true);
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = CircleDuration PARAM3 = damage
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust

		MY_OWNER = creatorValue1;
		MY_DURATION = creatorValue2;
		MY_BASE_DAMAGE = Float(damage);

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		if (!Truthy(OWNER_ISPLAYER))
			MY_SKILL = skill;
		else
			MY_SKILL = "none";
		GAME_PVP = (IsPvp() ? 1 : 0);

		MY_OWNER_RACE = RaceOf(creatorValue1);

		SetRace(MY_OWNER_RACE);

		CallEventOrDelay(MY_DURATION, "circle_end");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetName("Circle of Death");
		SetHealth(10000);
		SetFieldOfView(359);
		SetInvincible(true);
		SetHeight(2);
		SetWidth(2);
		SetFly(true);
		LegacyCommand("float", 1);
		SetDamageTaken("all", 0);
		SetGravity(0);
		SetBlood("none");
		SetModel("none");
		SetSolid("none");
		SetBoundingBox("none");

		SetNoPush(true);

		PLAYING_DEAD = "1";

		CIRCLE_ON = true;

		CallEventDelayed(0.1f, "make_seal");

		CallEventDelayed(1.0f, "circle_go");

		CallEventDelayed(0.1f, "circle_hum");
	}

	// make_seal
	void OnMakeSeal()
	{
		SetRace(MY_OWNER_RACE);
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
		if (!CIRCLE_UP)
		{
			// clientevent persist all $currentscript effect.duration $get(ent_me,index) PARAM2 GLOW_COLOR
			float clientDuration = Float(MY_DURATION);
			clientDuration -= 0.2f; // effort to prevent client side fx from sticking
			ClientEvent("new", "all_in_sight", "monsters/summon/circle_of_death_old", clientDuration, IndexOf(ENT_ME), CIRCLE_RADIUS);
			Vector3 myOrigin = OriginOf(ENT_ME);
			ClientEffect("light", "new", myOrigin, CIRCLE_RADIUS, Vector3(128, 128, 255), MY_DURATION);
			THIS_SCRIPT_CLIENT_ID = LastClientScriptId();
			CIRCLE_UP = true;
		}

		if (DID_WINDUP)
			PlaySound(0, 10, SOUND_PULSE);
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

		CallEventDelayed(0.5f, "circle_go");
		CIRCLE_TARGETS = FindInSphere("enemy", CIRCLE_RADIUS);
		if (CIRCLE_TARGETS == "none")
			return;
		int count = GetTokenCount(CIRCLE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDamageTargets();
		}
	}

	// damage_targets
	void OnDamageTargets()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(CIRCLE_TARGETS, loopIteration));

		// dodamage CUR_TARG direct MY_BASE_DAMAGE 100% MY_OWNER magic
		if (Truthy(OWNER_ISPLAYER) && GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;

		DoDamageEx(@curTarg, "direct", MY_BASE_DAMAGE, "100%", MY_OWNER, MY_OWNER, MY_SKILL, "magic");
	}

	// circle_end
	// if ( ENT_LASTHIT isnot 'ENT_LASTHIT' )
	// {
	// ////dbg temp $get(ENT_LASTHIT,name) alive $get(ENT_LASTHIT,isalive)
	// if !$get(ENT_LASTHIT,alive)
	// ////dbg temp CALLING LAUGH
	// callexternal $get(ent_creationowner,id) circle_kill
	// setvard ENT_LASTHIT 'ENT_LASTHIT'
	// }
	// if ( $get(ent_lastseen,id) equals MY_OWNER )
	// {
	// look 1024
	// }
	// dodamage $relpos(0,0,0) CIRCLE_RADIUS 0 100% 0 reflective
	// if $cansee(ally)
	// if $get(ent_lastseen,range) <= CIRCLE_RADIUS
	// if $get(ent_lastseen,relationship,MY_OWNER) equals enemy
	// setvard DMG_TARGET $get(ent_lastseen,id)
	// callevent apply_circle_effect
	// ////dbg temp Saw $get(ent_lastseen,name) is $get(ent_lastseen,relationship,MY_OWNER)
	// ////dbg temp $get(ENT_LASTHIT,name)
	// }
	// {  game_dodamage //1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	// if $get(PARAM2,relationship,MY_OWNER) equals enemy
	// setvard DMG_TARGET $get(ent_laststruckbyme,id)
	// callevent 0.1 apply_circle_effect
	// }
	// { apply_circle_effect
	// if !DMG_DELAY
	// ////dbg temp Circle Damage via ATTACK_FROM for $get(DMG_TARGET,name)
	// dodamage DMG_TARGET direct MY_BASE_DAMAGE 100% MY_OWNER
	// if ( $get(DMG_TARGET,isalive) )
	// {
	// setvard ENT_LASTHIT DMG_TARGET
	// callevent 0.25 dmg_delay_reset
	// setvard DMG_DELAY 1
	// }
	// }
	// { dmg_delay_reset
	// //anti crash from dodamage stack
	// setvard DMG_DELAY 0
	// }
	void OnCircleEnd()
	{
		ClientEvent("remove", "all", THIS_SCRIPT_CLIENT_ID);
		CIRCLE_ON = false;

		ClientEvent("remove", "all", "monsters/summon/circle_of_death_old"); // there can be only one
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("skull.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "circle_end") { OnCircleEnd(); return true; }
		if (name == "circle_go") { OnCircleGo(); return true; }
		if (name == "circle_hum") { OnCircleHum(); return true; }
		if (name == "circle_remove") { OnCircleRemove(); return true; }
		if (name == "damage_targets") { OnDamageTargets(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "make_seal") { OnMakeSeal(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
