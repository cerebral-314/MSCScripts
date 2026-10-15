#pragma context server

// Converted from monsters/summon/tomahawk.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/bludgeon_axe.as"

[script "monsters/summon/tomahawk"]
class Tomahawk : BludgeonAxeScript
{
	// Variables (an unset .script variable reads as its own name)
	string TOM_TYPE = "TOM_TYPE";
	float DOT_BASE = 0.0f;
	string T_BOX = "T_BOX";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
		BludgeonAxe_OnGameSpawn(playerRace, playerGender); // monsters/summon/bludgeon_axe

		SetName("Tomahawk");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 39);
		SetIdleAnim("spin_vertical_norm");
		SetMoveAnim("spin_vertical_norm");
		SetSolid("none");
		SetWidth(32);
		SetFly(true);
		SetHeight(32);
		SetBlood("none");
		SetInvincible(true);
		SetMonsterClip(false);
		SetRace("demon");
		PLAYING_DEAD = "1"; // not a valid attack target
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DEST = Vec(creatorValue2);
		DMG_BASE = Float(damage);
		TOM_TYPE = extraValue5;
		GAME_PVP = (IsPvp() ? 1 : 0);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		SetOrigin(ENT_ME, AttachmentPositionOf(MY_OWNER, 1));

		ITEM_ID = MY_OWNER;
		if (Truthy(OWNER_ISPLAYER))
		{
			ITEM_ID = skill;
			string dotSkill = "spellcasting.";
			if (TOM_TYPE != "cold")
				dotSkill += TOM_TYPE;
			else
				dotSkill += "ice";
			if (TOM_TYPE != "dark")
			{
				if (TOM_TYPE == "cold")
					DOT_BASE = SkillOf(MY_OWNER, "spellcasting.ice") * 0.5f;
				if (TOM_TYPE == "lightning")
					DOT_BASE = SkillOf(MY_OWNER, "spellcasting.lightning") * 0.75f;
				if (TOM_TYPE == "fire")
					DOT_BASE = SkillOf(MY_OWNER, "spellcasting.fire");
				if (TOM_TYPE == "poison")
					DOT_BASE = SkillOf(MY_OWNER, "spellcasting.affliction");
			}
		}
		OWNER_HALFHEIGHT = HeightOf(MY_OWNER);
		if (!Truthy(OWNER_ISPLAYER))
			OWNER_HALFHEIGHT = Divide(OWNER_HALFHEIGHT, 2.0f);
		SetRace(RaceOf(MY_OWNER));
		NPC_NOCLIP_DEST = MY_DEST;
		IS_ACTIVE = true;

		// storeentity ent_expowner MY_OWNER
		// dbg my $get(ent_me,race)
		CallEventDelayed(0.1f, "damage_loop");
		OnSetSkin();
	}

	// set_skin
	void OnSetSkin(string skinIndex = "")
	{
		if (TOM_TYPE == "fire")
			SetProp(ENT_ME, "skin", 0);
		if (TOM_TYPE == "cold")
			SetProp(ENT_ME, "skin", 1);
		if (TOM_TYPE == "lightning")
			SetProp(ENT_ME, "skin", 2);
		if (TOM_TYPE == "poison")
			SetProp(ENT_ME, "skin", 3);
		if (TOM_TYPE == "dark")
			SetProp(ENT_ME, "skin", 4);
	}

	// damage_loop
	void OnDamageLoop()
	{
		CallEventDelayed(0.2f, "damage_loop");
		// dodamage $relpos(0,0,0) SCAN_RAD DMG_BASE 100% 0.0 reflective DMG_TYPE
		T_BOX = FindInSphere("enemy", SCAN_RAD);
		if (T_BOX == "none")
			return;
		int count = GetTokenCount(T_BOX);
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
		CBaseEntity@ curTarget = FindEntity(GetToken(T_BOX, loopIteration));

		if (IsPlayer(curTarget) && Truthy(OWNER_ISPLAYER) && GAME_PVP < 1)
			exitSub = true;
		if (exitSub)
			return;

		DoDamageEx(@curTarget, "direct", DMG_BASE, "100%", MY_OWNER, MY_OWNER, "axehandling", TOM_TYPE);

		if (TOM_TYPE == "cold")
			ApplyEffect(curTarget, "effects/dot_cold", 5, MY_OWNER, DOT_BASE);
		if (TOM_TYPE == "fire")
			ApplyEffect(curTarget, "effects/dot_fire", 5, MY_OWNER, DOT_BASE);
		if (TOM_TYPE == "lightning")
			ApplyEffect(curTarget, "effects/dot_lightning", 5, MY_OWNER, DOT_BASE);
		if (TOM_TYPE == "poison")
			ApplyEffect(curTarget, "effects/dot_poison", 10.0f, MY_OWNER, DOT_BASE);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "damage_loop") { OnDamageLoop(); return true; }
		if (name == "damage_targets") { OnDamageTargets(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_skin") { OnSetSkin(Param(params, 0)); return true; }
		return BludgeonAxeScript::DispatchEvent(name, params);
	}
}
