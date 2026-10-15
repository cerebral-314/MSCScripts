#pragma context server

// Converted from items/proj_bolt_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_bolt_fire"]
class ProjBoltFire : ProjArrowBaseScript
{
	// Constants
	bool HITSCAN_BOLT = true;
	string MODEL_BODY_OFS = "49";
	int ARROW_BODY_OFS = 49;
	int PROJ_DAMAGE_AOE_RANGE = 250;
	string PROJ_ANIM_IDLE = "none";
	int PROJ_STICK_DURATION = 1;
	bool ARROW_SOLIDIFY_ON_WALL = true;
	string ARROW_BREAK_CHANCE = "100%";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float BOLT_DAMAGE = 0.0f;
	Vector3 START_TRACE = Vector3();
	Vector3 MY_START_ANG = Vector3();
	bool DID_SPLODIE = false;
	Vector3 TRACE_END = Vector3();
	bool DIRECT_HIT = false;

	// Variables declared by included files, with the value they start with in this script
	ProjBoltFire()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL2 = "weapons/bow/arrowhit1.wav";
		PROJ_DAMAGE_TYPE = "fire";
		PROJ_IGNORENPC = true;
	}

	// game_fall
	// { game_dodamage
	// local HIT_TARG PARAM2
	// if $get(HIT_TARG,isalive)
	// if $get(HIT_TARG,maxhp) < 1000
	// if $get(HIT_TARG,race) isnot human
	// if $get(HIT_TARG,race) isnot hguard
	// addvelocity HIT_TARG $relvel(10,400,600)
	// }
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		ProjBase_OnGameFall(); // items/proj_base
		ProjArrowBase_OnGameFall(); // items/proj_arrow_base
		DebugPrint("game_fall " + MODEL_BODY_OFS + " " + MODEL_WORLD);
		SetProp(ENT_ME, "rendermode", 0);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// game_tossprojectile
	void OnGameTossprojectile()
	{
		ProjBase_OnGameTossprojectile(); // items/proj_base
		ProjArrowBase_OnGameTossprojectile(); // items/proj_arrow_base
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Dwarven Bolt");
		SetDescription("'An awkward bolt made by the dwarves. Handle with care '");
		SetWeight(0.2f);
		SetValue(500);
		SetGravity(0);
		SetGroupable(25);
		SetHudSprite("hand", "arrows");
		SetHudSprite("trade", "expbolt");

		// dunno why it wont let me use a null.mdl without crashing
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// hitscan_bolt
	// { game_projectile_hitwall
	// setorigin ent_me TRACE_END
	// }
	// { game_hitnpc
	// callevent go_splodie
	// }
	void OnHitscanBolt()
	{
		MY_OWNER = EntityId(EntityOf(ENT_EXPOWNER));
		@MY_XBOW = ActiveItemOf(MY_OWNER);

		BOLT_DAMAGE = SkillOf(MY_OWNER, "archery") * 0.01f * Float(PROJ_DAMAGE);
		int dmgMulti = Int(ScriptVarOf(MY_XBOW, "HITSCAN_DMG_MULTI"));
		if (dmgMulti > 0)
			BOLT_DAMAGE *= dmgMulti;

		START_TRACE = OriginOf(ENT_ME);

		// local TRACE_ANG $get(ent_expowner,viewangles)
		// vectorset TRACE_ANG x $neg($vec.x(TRACE_ANG))
		// vectoradd START_TRACE $relpos(TRACE_ANG,$vec(0,20,0))
		Vector3 vMyDest = RelativePosition(Vector3(-Float(Eval("game.monster.angles.pitch")), Float(Eval("game.monster.angles.yaw")), Float(Eval("game.monster.angles.roll"))), Vector3(0, 8000, 0));
		Vector3 myDest = START_TRACE + vMyDest;

		MY_START_ANG = AnglesOf(ENT_ME);

		SetProp(ENT_ME, "avelocity", 0);
		SetProp(ENT_ME, "velocity", 0);
		SetProp(ENT_ME, "movetype", 0);

		// setvard TRACE_END $get_traceline(START_TRACE,MY_DEST,ent)
		// dbg trace TRACE_END $get(TRACE_END,exists) $get(TRACE_END,alive) $get(TRACE_END,hp)
		// if ( $get(TRACE_END,exists) )
		// {
		// dbg trace_posnpc $get(TRACE_END,hp)
		// if ( $get(TRACE_END,hp) == 0 ) local HIT_FUNC 1
		// if ( !HIT_FUNC )
		// {
		// setvard TRACE_END $get(TRACE_END,origin) //hit monster, move to
		// }
		// else
		// {
		// setvard TRACE_END $get_traceline(START_TRACE,MY_DEST,worldonly) //hit func_wall or such, retrace
		// dbg trace_wall TRACE_END
		// }
		// }
		// setorigin ent_me TRACE_END //$get(HIT_TARG,origin)
		// xdodamage TRACE_END 128 BOLT_DAMAGE 0.5 MY_OWNER ent_me archery PROJ_DAMAGE_TYPE dmgevent:*bolt
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			Effect("beam", "point", "lgtning.spr", 20, START_TRACE, myDest, Vector3(255, 0, 255), 200, 0, 1.0f);
		DoDamageEx(START_TRACE, myDest, 0, "100%", MY_OWNER, ENT_ME, "none", "target", "dmgevent:*boltscan");
	}

	// go_splodie
	void OnGoSplodie()
	{
		if (DID_SPLODIE)
			return;
		LegacyCommand("movetype", "none");
		SetOrigin(ENT_ME, TRACE_END);
		DID_SPLODIE = true;
		PlayRandomSound(0, 10, "weapons/explode3.wav");
		LegacyCommand("attachlight", "torch");
		LegacyCommand("attachsprite", "explode1.spr", "trans", 12, 1.5f);
		LegacyCommand("expiretime", 1);
	}

	// boltscan_dodamage
	void OnBoltscanDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		Vector3 endValue = Vec("L_END");
		if (IsAlive(target))
		{
			TRACE_END = OriginOf(target);
			DIRECT_HIT = true;
		}
		else
		{
			endValue = end;
			string trace = LegacyFunction("get_traceline", START_TRACE, endValue, "worldonly");
			TRACE_END = Vec(trace);
		}
		DebugPrint("boltscan_dodamage " + Text(TRACE_END) + " " + NameOf(target));

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			Vector3 traceEnd = TRACE_END;
			traceEnd.z += 64.0f;
			Effect("beam", "point", "lgtning.spr", 20, TRACE_END, traceEnd, Vector3(255, 0, 0), 200, 0, 5.0f);

			endValue = end;
			endValue.z += 64.0f;
			Effect("beam", "point", "lgtning.spr", 20, end, endValue, Vector3(0, 0, 255), 200, 0, 5.0f);
		}
		CallEventDelayed(0.1f, "splode_dmg");
	}

	// splode_dmg
	void OnSplodeDmg()
	{
		DoDamageEx(TRACE_END, 128, BOLT_DAMAGE, 0.5f, MY_OWNER, ENT_ME, "archery", PROJ_DAMAGE_TYPE, "dmgevent:*bolt");
		SetOrigin(ENT_ME, TRACE_END);
		// massive amounts of fail
		// dbg splode_dmg MY_START_ANG
		// setprop ent_me movetype 5
		// setprop ent_me angles MY_START_ANG
		// setprop ent_me angle MY_START_ANG
		// setprop ent_me avelocity $relvel(MY_START_ANG,$vec(0,1000,0))
		// setprop ent_me velocity $relvel(MY_START_ANG,$vec(0,1000,0))
		// setangle face MY_START_ANG
		CallEventDelayed(0.1f, "go_splodie");
	}

	// bolt_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) DmgType DmgAmt
	void OnBoltDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (IsAlive(target))
		{
			DebugPrint("bolt_dodamage_npc " + Text(OriginOf(target)));
			// setorigin ent_me $get(PARAM2,origin)
			if (hit)
			{
				CBaseEntity@ hitTarg = target;
				if (MaxHealthOf(hitTarg) < 1000.0f && RaceOf(hitTarg) != "human" && RaceOf(hitTarg) != "hguard")
				{
					// addvelocity HIT_TARG $relvel(10,400,600)
					Vector3 targOrg = OriginOf(hitTarg);
					float newYaw = AnglesTo(TRACE_END, targOrg);
					if (!DIRECT_HIT)
						AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(10, 400, 600)));
					else
						AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(10, -400, 600)));
				}
			}
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
		Precache("explode1.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		if (name == "bolt_dodamage") { OnBoltDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "boltscan_dodamage") { OnBoltscanDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_tossprojectile") { OnGameTossprojectile(); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "hitscan_bolt") { OnHitscanBolt(); return true; }
		if (name == "splode_dmg") { OnSplodeDmg(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
