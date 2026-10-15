#pragma context server

// Converted from items/proj_lightning_ball.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_lightning_ball"]
class ProjLightningBall : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 6;
	string SOUND_SHOOT = "ambience/alienflyby1.wav";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	string PROJ_ANIM_IDLE = "none";
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 32;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string F_BALL_SIZE = "F_BALL_SIZE";
	string F_BALL_DMG = "F_BALL_DMG";
	string F_BALL_TYPE = "F_BALL_TYPE";
	float SCAN_SIZE = 0.0f;
	string MY_SCRIPT_IDX = "MY_SCRIPT_IDX";
	bool SCAN_ON = false;
	bool HIT_SOMETHING = false;
	float LOOP_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjLightningBall()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "none";
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "lightning";
	}

	// game_spawn
	// [1]
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		ProjBase_OnGameSpawn(playerRace, playerGender); // items/proj_base

		if (playerRace != "1")
			CallEventDelayed(10.0f, "remove_me");
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		F_BALL_SIZE = ScriptVarOf(MY_OWNER, "BALL_SIZE");
		F_BALL_DMG = ScriptVarOf(MY_OWNER, "BALL_DMG");
		F_BALL_TYPE = "lightning";
		if (ScriptVarOf(MY_OWNER, "BALL_TYPE") != "BALL_TYPE")
			F_BALL_TYPE = ScriptVarOf(MY_OWNER, "BALL_TYPE");
		SCAN_SIZE = 16.0f;
		if (Truthy(OWNER_ISPLAYER))
			SCAN_SIZE = 12.0f;
		SCAN_SIZE *= Float(F_BALL_SIZE);

		if (Float(F_BALL_SIZE) == 0.0f)
			DeleteEntity(ENT_ME);
		if (!(Float(F_BALL_SIZE) > 0.0f))
			return;

		SetModel("weapons/projectiles.mdl");
		float subModel = int(Float(F_BALL_SIZE)) + 12.0f;
		subModel = int(subModel);
		SetModelBody(0, int(subModel));
		SetBoundingBox("animsize");

		if (F_BALL_TYPE == "holy")
		{
			SetProp(ENT_ME, "rendermode", 1);
			SetProp(ENT_ME, "rendercolor", Vector3(0, 0, 255));
		}

		// dbg temp got size F_BALL_SIZE dmg F_BALL_DMG sub SUB_MODEL
		// clientevent new all monsters/summon/magic_dart_cl $get(ent_me,index) F_BALL_SIZE manabolt
		MY_SCRIPT_IDX = LastClientScriptId();
		PlaySound(0, F_BALL_SIZE, SOUND_SHOOT);
		SCAN_ON = true;
		OnScanDamage();
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		ProjBase_OnGameProjectileLanded(); // items/proj_base

		SetModel("none");

		ClientEvent("update", "all", MY_SCRIPT_IDX, "shrink_out");

		LegacyCommand("expiretime", 0);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Manabolt");
		SetDescription("Manabolt");
		SetWeight(0);
		SetValue(1);
		SetGravity(0.0001f);

		SetModel("none");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
	}

	// game_hitworld
	void OnGameHitworld()
	{
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
	}

	// scan_damage
	void OnScanDamage()
	{
		if (SCAN_ON)
			CallEventDelayed(0.1f, "scan_damage");

		// //dbg temp game.monster.moveprox
		LegacyCommand("getents", "any", SCAN_SIZE);
		// (never true here, the rest is skipped) if GET_COUNT > 0
	}

	// game_hitnpc
	void OnGameHitnpc()
	{
		CallExternal(MY_OWNER, "send_damage", @EntityOf(ENT_LASTSTRUCKBYME), "direct", F_BALL_DMG, "100%", MY_OWNER, F_BALL_TYPE);
		DoDamageEx(@EntityOf(ENT_LASTSTRUCKBYME), F_BALL_DMG, "100%", MY_OWNER, MY_OWNER, "spellcasting.lightning", F_BALL_TYPE);
		Effect("screenfade", @EntityOf(ENT_LASTSTRUCKBYME), 3, 1, Vector3(255, 255, 255), 255, "fadein");
		DeleteMe();
	}

	// hit_target
	void OnHitTarget()
	{
		HIT_SOMETHING = true;
		LOOP_COUNT = 0.0f;
		for (int i = 0; i < 0; i++)
		{
			loopIteration = i;
			OnDmgTarget();
		}
	}

	// dmg_target
	void OnDmgTarget()
	{
		string checkEnt = "CHECK_ENT";
		bool exitSub = false;
		LOOP_COUNT += 1.0f;
		if (LOOP_COUNT == 1.0f)
			checkEnt = "GET_ENT1";
		if (LOOP_COUNT == 2.0f)
			checkEnt = "GET_ENT2";
		if (LOOP_COUNT == 3.0f)
			checkEnt = "GET_ENT3";
		if (LOOP_COUNT == 4.0f)
			checkEnt = "GET_ENT4";
		if (LOOP_COUNT == 5.0f)
			checkEnt = "GET_ENT5";
		if (LOOP_COUNT == 6.0f)
			checkEnt = "GET_ENT6";
		if (LOOP_COUNT == 7.0f)
			checkEnt = "GET_ENT7";
		if (LOOP_COUNT == 8.0f)
			checkEnt = "GET_ENT8";
		if (LOOP_COUNT == 9.0f)
			checkEnt = "GET_ENT9";

		// dbg in sphere ( SCAN_SIZE ) $get(CHECK_ENT,name)
		if (RelationshipOf(checkEnt, MY_OWNER) != "enemy")
			return;

		if (Truthy(OWNER_ISPLAYER) && (IsPvp() ? 1 : 0) == 0 && IsPlayer(checkEnt))
			exitSub = true;
		// dbg aborted, players do not atk players in non-pvp ( game.pvp )
		if (exitSub)
			return;

		if (!Truthy(ScriptVarOf(checkEnt, "HIT_BY_MANABALL")))
			DoDamageEx(checkEnt, "direct", F_BALL_DMG, "100%", MY_OWNER, MY_OWNER, "spellcasting.lightning", F_BALL_TYPE);
		Effect("screenfade", checkEnt, 3, 1, Vector3(255, 255, 255), 255, "fadein");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "dmg_target") { OnDmgTarget(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_hitnpc") { OnGameHitnpc(); return true; }
		if (name == "game_hitworld") { OnGameHitworld(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "hit_target") { OnHitTarget(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "scan_damage") { OnScanDamage(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
