#pragma context server

// Converted from monsters/summon/sorc_axe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/bludgeon_axe.as"

[script "monsters/summon/sorc_axe"]
class SorcAxe : BludgeonAxeScript
{
	// Constants
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";

	// Variables (an unset .script variable reads as its own name)
	float BASE_DOT = 0.0f;
	float NEXT_SCAN = 0.0f;
	string TARG_LIST = "TARG_LIST";

	// Variables declared by included files, with the value they start with in this script
	SorcAxe()
	{
		DMG_TYPE = "lightning";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
		BludgeonAxe_OnGameSpawn(playerRace, playerGender); // monsters/summon/bludgeon_axe

		SetName("Thunder Axe");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 34);
		SetIdleAnim("spin_horizontal_norm");
		SetMoveAnim("spin_horizontal_norm");
		SetSolid("none");
		SetWidth(32);
		SetFly(true);
		SetHeight(32);
		SetBlood("none");
		SetInvincible(true);
		SetMonsterClip(false);
		SetRace("demon");
		PLAYING_DEAD = "1"; // not a valid attack target

		Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, -1, 0);

		DebugPrint("spawned");
	}

	// do_shock
	// <param1 = shock targ> <param2 damage> (called externally by owner)
	void OnDoShock(CBaseEntity@ shockTarget = null, float damage = 0.0f)
	{
		bool exitSub = false;

		// this is never called by the player script, so not entirely sure why this is here >_>
		if (RelationshipOf(shockTarget, MY_OWNER) != "enemy")
			return;
		if (Truthy(OWNER_ISPLAYER) && GAME_PVP < 1 && IsPlayer(shockTarget))
			exitSub = true;
		if (exitSub)
			return;

		Vector3 beamStart = MyOrigin();
		Effect("beam", "end", "lgtning.spr", 30, beamStart, @shockTarget, 0, Vector3(255, 255, 0), 255, 30, 0.5f);
		ApplyEffect(shockTarget, "effects/dot_lightning", 3, self, damage);
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DEST = Vec(creatorValue2);
		DMG_BASE = Float(damage);
		GAME_PVP = (IsPvp() ? 1 : 0);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		ITEM_ID = MY_OWNER;
		if (Truthy(OWNER_ISPLAYER))
			ITEM_ID = skill;
		OWNER_HALFHEIGHT = HeightOf(MY_OWNER);
		if (!Truthy(OWNER_ISPLAYER))
			OWNER_HALFHEIGHT = Divide(OWNER_HALFHEIGHT, 2.0f);
		SetRace(RaceOf(MY_OWNER));
		NPC_NOCLIP_DEST = MY_DEST;
		IS_ACTIVE = true;
		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);

		if (Truthy(OWNER_ISPLAYER))
			BASE_DOT = SkillOf(MY_OWNER, "spellcasting.lightning") * 0.75f;

		// dbg my $get(ent_me,race)
		CallEventDelayed(0.1f, "damage_loop");
	}

	// damage_loop
	void OnDamageLoop()
	{
		int count;
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "damage_loop");
		if (!Truthy(OWNER_ISPLAYER))
		{
			DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), SCAN_RAD, DMG_BASE, "100%", 0.0f, "reflective", DMG_TYPE);
		}
		else
		{
			DoDamageEx(RelativePosition(Vector3(0, 0, 0)), SCAN_RAD, DMG_BASE, 0, MY_OWNER, MY_OWNER, "axehandling", "slash");
			if (GameTime() > NEXT_SCAN)
			{
				NEXT_SCAN = GameTime() + 0.25f;
				TARG_LIST = FindInSphere("enemy", SCAN_RAD);
				if (TARG_LIST != "none")
				{
					count = GetTokenCount(TARG_LIST);
					for (int i = 0; i < count; i++)
					{
						loopIteration = i;
						OnPlrZapTargets();
					}
				}
			}
		}
	}

	// plr_zap_targets
	void OnPlrZapTargets()
	{
		bool exitSub = false;
		string curTarg = GetToken(TARG_LIST, loopIteration);
		if (IsPlayer(curTarg) && GAME_PVP < 1)
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(curTarg, "effects/dot_lightning", 5.0f, MY_OWNER, BASE_DOT);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "damage_loop") { OnDamageLoop(); return true; }
		if (name == "do_shock") { OnDoShock(EntityParam(params, 0), Float(Param(params, 1))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "plr_zap_targets") { OnPlrZapTargets(); return true; }
		return BludgeonAxeScript::DispatchEvent(name, params);
	}
}
