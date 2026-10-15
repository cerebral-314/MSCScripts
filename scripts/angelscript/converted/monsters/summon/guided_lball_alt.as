#pragma context server

// Converted from monsters/summon/guided_lball_alt.script by msc_transpiler.
// Alternative server-side tracking sphere
// Simpler navigation method than current guided fire or lightning projectiles

#include "runtime/ScriptEntity.as"

[script "monsters/summon/guided_lball_alt"]
class GuidedLballAlt : ScriptEntity
{
	// Constants
	int SPHERE_SPEED = 30;
	string DMG_TYPE = "lightning";
	string SOUND_LOOP = "magic/bolt_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_OWNER = "MY_OWNER";
	string MY_DMG = "MY_DMG";
	float MY_RADIUS = 0.0f;
	float MAX_DURATION = 0.0f;
	float DOT_DMG = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int GAME_PVP = 0;
	float EXPIRE_TIME = 0.0f;
	string SKILL_TYPE = "SKILL_TYPE";
	string NME_TOKEN = "NME_TOKEN";
	string MY_TARGET = "MY_TARGET";
	bool IS_ACTIVE = false;
	string SCAN_TOKENS = "SCAN_TOKENS";

	// unnamed block (timer)
	void GuidedLballAlt_Timer()
	{
		CallEventDelayed(0.25f, "GuidedLballAlt_Timer");

		if (!IS_ACTIVE)
			return;

		if (!IsAlive(MY_TARGET))
			OnPickTarget();

		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(MY_TARGET);

		Vector3 angToTarg = Angles3DTo(myOrg, targOrg);
		angToTarg.x = -angToTarg.x;

		string destOrg = Text(myOrg);
		destOrg = Text(Vec(destOrg) + RelativeVelocity(angToTarg, Vector3(0, SPHERE_SPEED, 0)));

		SetVelocity(ENT_ME, RelativeVelocity(angToTarg, Vector3(0, SPHERE_SPEED, 0)));

		// check for wall collision
		string wallCheck = LegacyFunction("get_traceline", myOrg, destOrg, "worldonly");
		if (wallCheck != destOrg)
			OnSphereExplode();

		// check if stuck on something I can't detect
		// if ( IS_ACTIVE )
		// {
		// if ( $get(ent_me,origin) equals OLD_ORIGIN ) callevent sphere_explode
		// }
		// setvard OLD_ORIGIN MY_ORG
		if (GameTime() > EXPIRE_TIME && IS_ACTIVE)
			OnSphereExplode();

		// check for nmes
		if (IS_ACTIVE)
		{
			SCAN_TOKENS = FindInSphere("enemy", 64);
			if (SCAN_TOKENS != "none")
				OnSphereExplode();
		}

		if (IS_ACTIVE)
			SetOrigin(ENT_ME, Vec(destOrg));
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lightning Sphere");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 18);
		SetWidth(16);
		SetHeight(16);
		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetRoam(false);
		SetGravity(0);

		SetIdleAnim("spin_horizontal_slow");
		SetMoveAnim("spin_horizontal_slow");

		PLAYING_DEAD = "1";
		SetInvincible(true);

		ServerPlaySound(1, 5, SOUND_LOOP);
	}

	// game_dynamically_created
	// <owner> <dmg> <radius> <duration> [skill]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DMG = creatorValue2;
		MY_RADIUS = Float(damage);
		MAX_DURATION = Float(skill);

		DOT_DMG = Float(MY_DMG);
		DOT_DMG *= 0.1f;

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		GAME_PVP = (IsPvp() ? 1 : 0);

		EXPIRE_TIME = GameTime() + MAX_DURATION;

		SKILL_TYPE = "none";
		if (Truthy(OWNER_ISPLAYER))
			SKILL_TYPE = extraValue5;

		SetRace(RaceOf(MY_OWNER));
		CallEventDelayed(0.1f, "pick_target");
	}

	// pick_target
	void OnPickTarget()
	{
		string nmeTokens = FindInSphere("enemy", 1024);
		if (NME_TOKEN != "none")
		{
			NME_TOKEN = TokenShuffle(NME_TOKEN);
			MY_TARGET = GetToken(NME_TOKEN, 0);
		}

		if (!IsAlive(MY_TARGET))
			MY_TARGET = ScriptVarOf(MY_OWNER, "NPCATK_TARGET");

		IS_ACTIVE = true;
	}

	// sphere_explode
	void OnSphereExplode()
	{
		if (!IS_ACTIVE) // redudant check so as not to explode twice for some odd reason
			return;
		IS_ACTIVE = false;
		ServerPlaySound(1, 0, SOUND_LOOP);
		ClientEvent("new", "all", "monsters/summon/guided_lball_alt_cl", OriginOf(ENT_ME), MY_RADIUS);
		DoDamageEx(OriginOf(ENT_ME), MY_RADIUS, MY_DMG, 0, MY_OWNER, MY_OWNER, SKILL_TYPE, DMG_TYPE);
		CallEventDelayed(0.01f, "remove_me");

		SCAN_TOKENS = FindInSphere("enemy", 256);
		if (SCAN_TOKENS == "none")
			return;
		int count = GetTokenCount(SCAN_TOKENS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargets();
		}
	}

	// affect_targets
	void OnAffectTargets()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TOKENS, loopIteration));

		if (Truthy(OWNER_ISPLAYER) && GAME_PVP == 0 && IsPlayer(curTarg))
			exitSub = true;
		if (exitSub)
			return;

		ApplyEffect(curTarg, "effects/dot_lightning", 5.0f, MY_OWNER, DOT_DMG, SKILL_TYPE);
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
		Precache("weapons/projectiles.mdl");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(0.25f, "GuidedLballAlt_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "affect_targets") { OnAffectTargets(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "pick_target") { OnPickTarget(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "sphere_explode") { OnSphereExplode(); return true; }
		if (name == "GuidedLballAlt_Timer") { GuidedLballAlt_Timer(); return true; }
		return false;
	}
}
