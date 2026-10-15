#pragma context server

// Converted from items/axes_dragon.script by msc_transpiler.
// Dragon axe from axes_vaxe by Thothie
// - Fire elements - fire breath on right click

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_greataxe.as"

[script "items/axes_dragon"]
class AxesDragon : AxesGreataxeScript
{
	// Constants
	int BURN_LEVEL_REQ = 20;
	int MP_DRAIN_RATE = -2;
	string SOUND_FLAME_ON = "monsters/goblin/sps_fogfire.wav";
	string CL_SCRIPT = "items/axes_dragon_cl";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	bool CAN_BURN = false;
	string BURN_DAMAGE = "BURN_DAMAGE";
	float NEXT_MSG = 0.0f;
	float NEXT_FLAME = 0.0f;
	Vector3 OWNER_ANG = Vector3();
	string CL_IDX = "CL_IDX";
	string OWNER_ORG = "OWNER_ORG";
	float NEXT_SCAN = 0.0f;
	string BURN_LIST = "BURN_LIST";
	Vector3 TRACE_START = Vector3();

	// Variables declared by included files, with the value they start with in this script
	AxesDragon()
	{
		BASE_LEVEL_REQ = "20";
		MODEL_VIEW_IDX = 4;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		ANIM_PREFIX = "standard";
		MODEL_BODY_OFS = "34";
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 400;
		MELEE_DMG_TYPE = "fire";
		MELEE_ACCURACY = "50";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal2.wav";
	}

	// game_dodamage
	string AxesDragon_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		if (RelationshipOf(target, ENT_OWNER) != "enemy")
			return result;

		if (IsPlayer(target) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return result;

		ApplyEffect(target, "effects/dot_fire", 5, @EntityOf(ENT_OWNER), BURN_DAMAGE, "spellcasting.fire");
		return result;
	}

	// game_precache
	// items may not use this, test
	void OnGamePrecache()
	{
		PrecacheFile("items/axes_dragon_cl");
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee

		GAME_PVP = (IsPvp() ? 1 : 0);
		if (SkillOf(ENT_OWNER, "spellcasting.fire") >= BURN_LEVEL_REQ)
			CAN_BURN = true;
		BURN_DAMAGE = Text(SkillOf(ENT_OWNER, "spellcasting.fire"));
		BURN_DAMAGE = Text(Divide(Float(BURN_DAMAGE), 2.0f));
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		if (CL_IDX == "CL_IDX")
			return;
		ClientEvent("update", "all", CL_IDX, "end_fx");
		ServerPlaySound(1, 0, SOUND_FLAME_ON);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		AxesGreataxe_OnWeaponSpawn(); // items/axes_greataxe

		SetName("Dragon Axe");
		SetDescription("An axe enchanted with fire");
		SetWeight(90);
		SetValue(2500);
		SetHudSprite("hand", "133");
		SetHudSprite("trade", "133");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesDragon_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;
		// (always true here) if game.serverside

		if (!(GameTime() > NEXT_FLAME))
			return;

		if (!CanAttack(ENT_OWNER))
		{
			exitSub = true;
			if (GameTime() > NEXT_MSG)
			{
				PlayerMessageDark(ENT_OWNER, "Fire Breath: Can't attack now.");
				NEXT_MSG = GameTime() + 1.0f;
			}
		}
		if (exitSub)
			return;

		if (ManaOf(ENT_OWNER) <= -MP_DRAIN_RATE)
		{
			PlayerMessageDark(ENT_OWNER, "Dragon Axe - Fire Breath: Not enough mana.");
			exitSub = true;
			NEXT_FLAME = GameTime() + 1.0f;
		}
		if (exitSub)
			return;

		if (!CAN_BURN)
		{
			PlayerMessageDark(ENT_OWNER, "Dragon Axe - Fire Breath: Insufficient fire skill.");
			exitSub = true;
			NEXT_FLAME = GameTime() + 1.0f;
		}
		if (exitSub)
			return;

		NEXT_FLAME = GameTime() + 0.1f;

		OWNER_ANG = AnglesOf(ENT_OWNER);

		if (CL_IDX == "CL_IDX")
		{
			ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_OWNER));
			CL_IDX = LastClientScriptId();
			ServerPlaySound(1, 10, SOUND_FLAME_ON);
		}
		else
		{
			Vector3 cloudStart = BonePositionOf(ENT_OWNER, 15);
			cloudStart += RelativePosition(OWNER_ANG, Vector3(0, 32, -30)); // a little in front of face (and now down, due to change in player model, I guess)
			Vector3 cloudAng = OWNER_ANG;
			cloudAng.x = -OWNER_ANG.x;
			cloudStart.z += 24.0f;
			ClientEvent("update", "all", CL_IDX, "make_clouds", cloudStart, cloudAng);
		}

		OWNER_ORG = Text(OriginOf(ENT_OWNER));

		GiveMana(ENT_OWNER, MP_DRAIN_RATE);

		if (!(GameTime() > NEXT_SCAN))
			return;

		NEXT_SCAN = GameTime() + 0.5f;

		BURN_DAMAGE = Text(SkillOf(ENT_OWNER, "spellcasting.fire"));
		BURN_DAMAGE = Text(Divide(Float(BURN_DAMAGE), 2.0f));

		Vector3 scanPos = OriginOf(ENT_OWNER);
		// setvard OWNER_YAW $get(ent_owner,angles.yaw)
		scanPos += RelativePosition(OWNER_ANG, Vector3(0, 128, 0));

		// if ( G_DEVELOPER_MODE )
		// {
		// local BEAM_END SCAN_POS
		// vectoradd BEAM_END z 64
		// effect beam point lgtning.spr 30 SCAN_POS BEAM_END (255,0,255) 200 0 0.5
		// }
		CallExternal(ENT_OWNER, "ext_box_token", "enemy", 96, scanPos);
		BURN_LIST = ScriptVarOf(ENT_OWNER, "PLR_SCAN_TOKEN");
		if (BURN_LIST == "none")
			return;
		TRACE_START = BonePositionOf(ENT_OWNER, 15);
		int count = GetTokenCount(BURN_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurnTargets();
		}
	}

	// burn_targets
	void OnBurnTargets()
	{
		bool exitSub = false;
		string curTarget = GetToken(BURN_LIST, loopIteration);

		// dont burn players outside of PVP
		if (IsPlayer(curTarget) && GAME_PVP == 0)
			exitSub = true;
		if (exitSub)
			return;

		// within the cone
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, Vec(OWNER_ORG), OWNER_ANG, 30))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;

		// make sure I'm not trying to burn through a wall
		Vector3 traceEnd = OriginOf(curTarget);
		if (!IsPlayer(curTarget))
		{
			// adjust for origin center
			float halfMonHeight = Divide(HeightOf(curTarget), 2.0f);
			traceEnd.z += halfMonHeight;
		}
		string traceCheck = LegacyFunction("get_traceline", TRACE_START, traceEnd, "worldonly");
		if (traceCheck != Text(traceEnd))
			return;

		// burn em
		ApplyEffect(curTarget, "effects/dot_fire", 5.0f, @EntityOf(ENT_OWNER), BURN_DAMAGE, "spellcasting.fire");
		if (!(MaxHealthOf(curTarget) < 10000.0f))
			return;
		if (!(HeightOf(curTarget) < 120.0f))
			return;
		if (Truthy(ScriptVarOf("CUR_TARG", "NPC_OVERSIZED")))
			return;
		Vector3 pushVel = RelativeVelocity(Vector3(0, 300, 120));
		AddVelocity(curTarget, pushVel);
	}

	// game_-attack2
	void OnGameReleaseAttack2()
	{
		if (CL_IDX == "CL_IDX")
			return;
		ClientEvent("update", "all", CL_IDX, "end_fx");
		CL_IDX = "CL_IDX";
		ServerPlaySound(1, 0, SOUND_FLAME_ON);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
		Precache("monsters/goblin/sps_fogfire.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "burn_targets") { OnBurnTargets(); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_-attack2") { OnGameReleaseAttack2(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesGreataxeScript::DispatchEvent(name, params);
	}
}
