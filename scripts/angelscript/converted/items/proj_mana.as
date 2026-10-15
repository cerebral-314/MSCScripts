#pragma context server

// Converted from items/proj_mana.script by msc_transpiler.
// magic bolt that varies with size by the energy put into it

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_mana"]
class ProjMana : ProjArrowBaseScript
{
	// Constants
	int ARROW_BODY_OFS = 6;
	string SOUND_SHOOT = "ambience/alienflyby1.wav";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string MODEL_BODY_OFS = "0";
	int PROJ_STICK_DURATION = 0;
	bool PROJ_SOLIDIFY_ON_WALL = false;
	int PROJ_DAMAGE_AOE_RANGE = 0;
	bool PROJ_DAMAGE_AOE_FALLOFF = true;
	string PROJ_ANIM_IDLE = "none";

	// Variables (an unset .script variable reads as its own name)
	int GAME_PVP = 0;
	float NEXT_TOUCH = 0.0f;
	bool SCAN_ON = false;
	string TOKEN_TARGETS = "TOKEN_TARGETS";
	string MY_OWNER = "MY_OWNER";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string F_BALL_SIZE = "F_BALL_SIZE";
	string F_BALL_DMG = "F_BALL_DMG";
	string F_BALL_TYPE = "F_BALL_TYPE";
	string DAMAGE_LIST = "DAMAGE_LIST";
	float SCAN_SIZE = 0.0f;
	string SCAN_TARGS = "SCAN_TARGS";
	float LAST_TOUCHED = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ProjMana()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "none";
		HITWALL_VOL = 2;
		PROJ_MOTIONBLUR = false;
		PROJ_DAMAGE = "0";
		PROJ_DAMAGE_TYPE = "magic";
		PROJ_IGNORENPC = true;
	}

	// game_touch
	string ProjMana_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		if (!(GameTime() > NEXT_TOUCH))
			return result;
		NEXT_TOUCH = GameTime() + 0.1f;
		DebugPrint("game_touch " + NameOf(other));
		OnCheckDamage(EntityId(other));
		return result;
	}

	// game_projectile_hitwall
	void ProjMana_OnGameProjectileHitwall()
	{
		DebugPrint("game_projectile_hitwall");

		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
		// expiretime 0
		SetAlive(false);
		SCAN_ON = false;
		RemoveScript();
		DeleteEntity(ENT_ME);
	}

	// game_projectile_hitwall
	// used
	void ProjMana_OnGameProjectileHitwall_2()
	{
		ServerPlaySound(4, 0, SOUND_SHOOT);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		TOKEN_TARGETS = "";
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		F_BALL_SIZE = ScriptVarOf(MY_OWNER, "BALL_SIZE");
		F_BALL_DMG = ScriptVarOf(MY_OWNER, "BALL_DMG");
		F_BALL_TYPE = ScriptVarOf(MY_OWNER, "BALL_TYPE");
		DAMAGE_LIST = "";

		float fBallVol = Clamp(int(Float(F_BALL_SIZE)), 1.0f, 10.0f);
		ServerPlaySound(4, fBallVol, SOUND_SHOOT);

		DebugPrint("game_tossprojectile " + F_BALL_SIZE + " " + F_BALL_DMG + " " + F_BALL_TYPE + " " + NameOf(MY_OWNER));

		if (F_BALL_TYPE == "F_BALL_TYPE")
			F_BALL_TYPE = "magic";
		SCAN_SIZE = 16.0f;
		if (Truthy(OWNER_ISPLAYER))
			SCAN_SIZE = 12.0f;
		SCAN_SIZE *= Float(F_BALL_SIZE);

		if (Float(F_BALL_SIZE) == 0.0f)
			DeleteEntity(ENT_ME);
		if (!(Float(F_BALL_SIZE) > 0.0f))
			return;

		SetModel("weapons/projectiles.mdl");
		// local SUB_MODEL $int(F_BALL_SIZE)
		// add SUB_MODEL 12
		// local SUB_MODEL $int(SUB_MODEL)
		// setmodelbody 0 SUB_MODEL
		SetModelBody(0, 13);
		float scaleSize = Float(F_BALL_SIZE);
		scaleSize *= 0.75f;
		SetProp(ENT_ME, "scale", scaleSize);

		SetBoundingBox("animsize");

		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 20);

		// dbg temp got size F_BALL_SIZE dmg F_BALL_DMG sub SUB_MODEL
		// clientevent new all monsters/summon/magic_dart_cl $get(ent_me,index) F_BALL_SIZE manabolt
		// setvard MY_SCRIPT_IDX game.script.last_sent_id
		SCAN_ON = true;
		OnScanDamage();
	}

	// game_touch
	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		result = AppendResult(result, ProjBase_OnGameTouch(other, hpRange, effectDamage));
		result = AppendResult(result, ProjMana_OnGameTouch(other, hpRange, effectDamage));
		return result;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Manabolt");
		SetDescription("Manabolt");
		SetWeight(0);
		SetValue(16);
		SetGravity(0.0001f);

		SetModel("none");

		CallEventDelayed(10.0f, "remove_me");

		GAME_PVP = (IsPvp() ? 1 : 0);

		LegacyCommand("projectiletouch", 1);
	}

	// game_fall
	// override base_arrow.  Just do nothing
	void OnGameFall()
	{
		DebugPrint("game_fall");
	}

	// game_projectile_hitwall
	void OnGameProjectileHitwall()
	{
		ProjMana_OnGameProjectileHitwall();
		ProjMana_OnGameProjectileHitwall_2();
	}

	// game_projectile_hitnpc
	void OnGameProjectileHitnpc(CBaseEntity@ target = null)
	{
		DebugPrint("game_projectile_hitnpc " + NameOf(target));
	}

	// game_projectile_landed
	void OnGameProjectileLanded()
	{
		DebugPrint("game_projectile_landed");
	}

	// scan_damage
	void OnScanDamage()
	{
		if (SCAN_ON)
			CallEventDelayed(0.1f, "scan_damage");

		// if game.time > NEXT_DAMAGE
		Vector3 myOrg = OriginOf(ENT_ME);

		if (Text(myOrg) == Text(Vector3(0, 0, 0)))
			DeleteEntity(ENT_ME);

		// //dbg temp game.monster.moveprox
		// xdodamage MY_ORG SCAN_SIZE F_BALL_DMG 100% ent_expowner ent_expowner archery magic
		// snap damage loc to ground if low flying
		float myHeight = myOrg.z - GroundHeight(myOrg);
		if (myHeight < 72.0f)
		{
			// dbg adjusting down
			myOrg.z = GroundHeight(myOrg);
			if (SCAN_SIZE > 32.0f) {}
		}

		// local BEAM_END MY_ORG
		// vectoradd BEAM_END z 16
		// effect beam point lgtning.spr 5 MY_ORG BEAM_END (255,0,255) 255 0 0.1
		SCAN_TARGS = LegacyFunction("get_tsphere", "any", SCAN_SIZE, myOrg);

		// dbg SCAN_TARGS
		if (SCAN_TARGS == "none")
			return;

		int count = GetTokenCount(SCAN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDamageTargets();
		}
	}

	// damage_targets
	void OnDamageTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TARGS, loopIteration));
		OnCheckDamage("CUR_TARGET");
	}

	// remove_last_touched
	void OnRemoveLastTouched()
	{
		LAST_TOUCHED = 0.0f;
	}

	// check_damage
	// <target> <by_touch-0:1>
	void OnCheckDamage(string target = "")
	{
		bool exitSub = false;

		if (Contains(DAMAGE_LIST, target)) // damage each target once
			exitSub = true;
		if (exitSub)
			return;

		DebugPrint("damage_targets nam " + NameOf(target) + " nme " + RelationshipOf(target, ENT_EXPOWNER) + " plr " + Text(IsPlayer(target)));
		if (RelationshipOf(target, MY_OWNER) != "enemy")
			return;
		if (IsPlayer(target) && GAME_PVP == 0 && Truthy(OWNER_ISPLAYER))
			exitSub = true;
		if (exitSub)
			return;
		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = OriginOf(ENT_ME);

		DebugPrint("damageline " + Text(myOrg) + " " + Text(targOrg) + " " + F_BALL_DMG);
		DoDamageEx(myOrg, targOrg, F_BALL_DMG, "100%", ENT_EXPOWNER, ENT_ME, "archery", "magic", "dmgevent:ext_manaball");

		DAMAGE_LIST = TokenAdd(DAMAGE_LIST, target);
	}

	// remove_me
	// Go through NPCs
	// { game_hitnpc
	// setmodel null.mdl
	// callexternal MY_OWNER send_damage $get(ent_laststruckbyme,id) direct F_BALL_DMG 100% MY_OWNER F_BALL_TYPE
	// effect screenfade $get(ent_laststruckbyme,id) 3 1 (255,255,255) 255 fadein
	// expiretime 0
	// }
	// { [override] game_projectile_landed
	// dbg game_projectile_landed
	// setmodel null.mdl
	// //clientevent update all MY_SCRIPT_IDX shrink_out
	// expiretime 0
	// callevent remove_me
	// }
	// { [server] hit_target
	// setvard HIT_SOMETHING 1
	// setvard LOOP_COUNT 0
	// calleventloop GET_COUNT dmg_target
	// }
	// { [server] dmg_target
	// add LOOP_COUNT 1
	// if ( LOOP_COUNT == 1 ) local CHECK_ENT GET_ENT1
	// if ( LOOP_COUNT == 2 ) local CHECK_ENT GET_ENT2
	// if ( LOOP_COUNT == 3 ) local CHECK_ENT GET_ENT3
	// if ( LOOP_COUNT == 4 ) local CHECK_ENT GET_ENT4
	// if ( LOOP_COUNT == 5 ) local CHECK_ENT GET_ENT5
	// if ( LOOP_COUNT == 6 ) local CHECK_ENT GET_ENT6
	// if ( LOOP_COUNT == 7 ) local CHECK_ENT GET_ENT7
	// if ( LOOP_COUNT == 8 ) local CHECK_ENT GET_ENT8
	// if ( LOOP_COUNT == 9 ) local CHECK_ENT GET_ENT9
	// //dbg in sphere ( SCAN_SIZE ) $get(CHECK_ENT,name)
	// if $get(CHECK_ENT,relationship,MY_OWNER) equals enemy
	// if ( OWNER_ISPLAYER )
	// {
	// if game.pvp == 0
	// if $get(CHECK_ENT,isplayer)
	// local EXIT_SUB 1
	// //dbg aborted, players do not atk players in non-pvp ( game.pvp )
	// }
	// if !EXIT_SUB
	// if ( !$get(CHECK_ENT,scriptvar,HIT_BY_MANABALL) ) callexternal MY_OWNER send_damage CHECK_ENT direct F_BALL_DMG 100% MY_OWNER magic
	// if ( OWNER_ISPLAYER ) callexternal CHECK_ENT ext_hit_manaball
	// effect screenfade CHECK_ENT 3 1 (255,255,255) 255 fadein
	// //if ( OWNER_ISPLAYER ) setvard SCAN_ON 0 //player version only damages once
	// }
	// { damage_targets_insphere
	// local CUR_TARGET $get_token(SCAN_TOKENS,game.script.iteration)
	// if $get(CUR_TARGET,relationship,MY_OWNER) equals enemy
	// //dont damage players in non-pvp (sometimes they show up as enemies)
	// if ( OWNER_ISPLAYER )
	// {
	// if !GAME_PVP
	// if $get(CUR_TARGET,isplayer)
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// //callexternal MY_OWNER send_damage CHECK_ENT direct F_BALL_DMG 100% MY_OWNER magic
	// if ( TOKEN_TARGETS contains CUR_TARGET ) local EXIT_SUB 1
	// if !EXIT_SUB
	// if ( $get_token_amt(TOKEN_TARGETS) > 11 ) setvard TOKEN_TARGETS ''
	// token.add TOKEN_TARGETS CUR_TARGET
	// if ( OWNER_ISPLAYER ) callexternal CUR_TARGET ext_hit_manaball
	// local TARG_ORG $get(CUR_TARG,origin)
	// local MY_ORG $get(ent_me,origin)
	// xdodamage MY_ORG TARG_ORG F_BALL_DMG 100% MY_OWNER MY_OWNER archery magic
	// }
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("ambience/alienflyby1.wav");
		Precache("weapons/projectiles.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "check_damage") { OnCheckDamage(Param(params, 0)); return true; }
		if (name == "damage_targets") { OnDamageTargets(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_projectile_hitnpc") { OnGameProjectileHitnpc(EntityParam(params, 0)); return true; }
		if (name == "game_projectile_hitwall") { OnGameProjectileHitwall(); return true; }
		if (name == "game_projectile_landed") { OnGameProjectileLanded(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "remove_last_touched") { OnRemoveLastTouched(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "scan_damage") { OnScanDamage(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
