#pragma context server

// Converted from monsters/telf_warrior_bow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elf_warrior_base.as"

[script "monsters/telf_warrior_bow"]
class TelfWarriorBow : ElfWarriorBaseScript
{
	// Constants
	bool AM_ARCHER = true;
	string ATTACK_STANCE = "bow";
	string SOUND_BOW_STRETCH = "monsters/archer/stretch.wav";
	string SOUND_BOW_SHOOT = "monsters/archer/bow.wav";
	string ARROW_CL_SCRIPT_FIRE = "effects/sfx_fire_burst";
	string ARROW_CL_SCRIPT_COLD = "effects/sfx_ice_burst";

	// Variables (an unset .script variable reads as its own name)
	float MISS_COUNT = 0.0f;
	string PROJ_TYPE = "PROJ_TYPE";
	bool AOE_ARROW = false;
	int ARROW_KNOCKBACK = 0;
	int ARROW_AOE = 0;
	string ARROW_EFFECT = "ARROW_EFFECT";
	int ARROW_DOT_DMG = 0;
	float ARROW_DOT_DUR = 0.0f;
	string ARROW_CL_SCRIPT = "ARROW_CL_SCRIPT";
	int ARROW_DMG_AOE = 0;
	string ARROW_DMG_TYPE = "ARROW_DMG_TYPE";
	string SPIRAL_DMG_TYPE = "SPIRAL_DMG_TYPE";
	string SPIRAL_DMG = "SPIRAL_DMG";
	string SPIRAL_SPIRTE_FILE = "SPIRAL_SPIRTE_FILE";
	int SPIRAL_SPRITE_FRAMES = 0;
	float SPIRAL_SPRITE_SCALE = 0.0f;
	Vector3 SPIRAL_SPRITE_COLOR = Vector3();
	Vector3 SPIRAL_GLOW_COLOR = Vector3();
	bool SPIRAL_ON = false;
	string ARROW_TARGET_LIST = "ARROW_TARGET_LIST";

	// Variables declared by included files, with the value they start with in this script
	TelfWarriorBow()
	{
		CAN_KICK = true;
		FREQ_KICK = 8.0f;
		LEAP_AFTER_KICK = true;
	}

	// unnamed block (first think)
	void TelfWarriorBow_FirstThink()
	{
		NPC_GIVE_EXP = 2500.0f; // bit less threatening / more exploitable than the rest
		DROP_GOLD = 1;
		DROP_GOLD_AMT = 500.0f;

		NPC_RANGED = "1"; // me thinketh we have used wrong convention in many places (NPC_IS_RANGED) - will fix :(
	}

	// game_dodamage
	string TelfWarriorBow_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (IsAlive(target) && RelationshipOf(target, ENT_ME) == "enemy")
			MISS_COUNT = 0.0f;

		if (SPIRAL_ON && hit && RelationshipOf(target, ENT_ME) == "enemy")
			AddVelocity(target, RelativeVelocity(Vector3(0, 200, 110)));
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(ARROW_CL_SCRIPT_FIRE);
		PrecacheFile(ARROW_CL_SCRIPT_COLD);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElfWarriorBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, TelfWarriorBow_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// elf_spawn
	void OnElfSpawn()
	{
		SetName("Torkalath Shadowarcher");
		SetHealth(3500);
		SetDamageTaken("all", 0.5f);
		SetRace("torkie");

		SetModelBody(1, 5); // 0=Unarmed 1=Dagger 2=Mace 3=Axe 4=Sword 5=Bow 6=Litchtounge

		MISS_COUNT = 0.0f;
	}

	// frame_stretch_bow
	void OnFrameStretchBow()
	{
		PlaySound(0, 10, SOUND_BOW_STRETCH);
	}

	// frame_shoot_bow
	void OnFrameShootBow()
	{
		int arrowSpeed = 0;
		string arrowScript = "ARROW_SCRIPT";
		bool arrowGlow = false;
		Vector3 arrowGlowColor = Vec("ARROW_GLOW_COLOR");
		bool spiralArrow = false;
		PlaySound(0, 10, SOUND_BOW_SHOOT);
		MISS_COUNT += 1.0f;

		int nProjectiles = 3; // constant this

		int rndProjectile = RandomInt(3, 5); // override

		// we're not actually going to use the first two, as there's already plenty of skeles doing this in The_Wall
		// however, we'll keep them around, so she can easily be adjusted to do otherwise on other maps
		if (rndProjectile == 1)
		{
			PROJ_TYPE = "fire_aoe"; // this var isn't actually used, but may help for reference
			arrowSpeed = 500;
			arrowScript = "proj_arrow_npc_dyn";
			arrowGlow = true;
			arrowGlowColor = Vector3(255, 0, 0);
			AOE_ARROW = true;
			ARROW_KNOCKBACK = 800;
			ARROW_AOE = 128;
			ARROW_EFFECT = "effects/dot_fire";
			ARROW_DOT_DMG = 150;
			ARROW_DOT_DUR = 5.0f;
			ARROW_CL_SCRIPT = ARROW_CL_SCRIPT_FIRE;
			ARROW_DMG_AOE = 200;
			ARROW_DMG_TYPE = "fire_effect";
		}

		if (rndProjectile == 2)
		{
			PROJ_TYPE = "ice_aoe";
			arrowSpeed = 500;
			arrowScript = "proj_arrow_npc_dyn";
			arrowGlow = true;
			arrowGlowColor = Vector3(128, 128, 255);
			AOE_ARROW = true;
			ARROW_KNOCKBACK = 800;
			ARROW_AOE = 128;
			ARROW_EFFECT = "effects/dot_cold";
			ARROW_DOT_DMG = 50;
			ARROW_DOT_DUR = 5.0f;
			ARROW_CL_SCRIPT = ARROW_CL_SCRIPT_COLD;
			ARROW_DMG_AOE = 150;
			ARROW_DMG_TYPE = "cold_effect";
		}

		if (rndProjectile == 3)
		{
			PROJ_TYPE = "spiral_fire";
			arrowScript = "proj_arrow_spiral";
			arrowSpeed = 200;
			AOE_ARROW = false;
			ARROW_KNOCKBACK = 0;
			SPIRAL_DMG_TYPE = "fire_effect";
			SPIRAL_DMG = "100";
			SPIRAL_SPIRTE_FILE = "3dmflaora.spr";
			SPIRAL_SPRITE_FRAMES = 19;
			SPIRAL_SPRITE_SCALE = 1.0f;
			SPIRAL_SPRITE_COLOR = Vector3(255, 0, 0);
			SPIRAL_GLOW_COLOR = Vector3(255, 0, 0);
			SPIRAL_ON = true;
			spiralArrow = true;
		}

		if (rndProjectile == 4)
		{
			PROJ_TYPE = "spiral_cold";
			arrowScript = "proj_arrow_spiral";
			arrowSpeed = 200;
			AOE_ARROW = false;
			ARROW_KNOCKBACK = 0;
			SPIRAL_DMG_TYPE = "cold_effect";
			SPIRAL_DMG = "100";
			SPIRAL_SPIRTE_FILE = "char_breath.spr";
			SPIRAL_SPRITE_FRAMES = 1;
			SPIRAL_SPRITE_SCALE = 2.5f;
			SPIRAL_SPRITE_COLOR = Vector3(255, 255, 255);
			SPIRAL_GLOW_COLOR = Vector3(128, 128, 255);
			SPIRAL_ON = true;
			spiralArrow = true;
		}

		if (rndProjectile == 5)
		{
			PROJ_TYPE = "spiral_lightning";
			arrowScript = "proj_arrow_spiral";
			arrowSpeed = 200;
			AOE_ARROW = false;
			ARROW_KNOCKBACK = 0;
			SPIRAL_DMG_TYPE = "lightning_effect";
			SPIRAL_DMG = "100";
			SPIRAL_SPIRTE_FILE = "3dmflaora.spr";
			SPIRAL_SPRITE_FRAMES = 8;
			SPIRAL_SPRITE_SCALE = 0.5f;
			SPIRAL_SPRITE_COLOR = Vector3(255, 255, 0);
			SPIRAL_GLOW_COLOR = Vector3(255, 255, 0);
			SPIRAL_ON = true;
			spiralArrow = true;
		}

		if (!AOE_ARROW)
		{
			// IT WOULD BE REALLY NICE IF SHOOTING AN ARROW AT AN ORIGIN ACTUALLY WORKED! ><
			// if ( SPIRAL_ARROW )
			// {
			// if ( $get(NPCATK_TARGET,range) < 256 )
			// {
			// //he's near me - shoot straight, instead of angling into the floor
			// local SHOOT_ORG $get(ent_me,origin)
			// vectoradd SHOOT_ORG $relpos($vec(0,game.monster.angles.yaw.0),$vec(0,128,$vec.z(ARROW_OFS)))
			// //setangle view_origin SHOOT_ORG
			// dbg adjust SHOOT_ORG
			// tossprojectile SHOOT_ORG ARROW_SPEED DMG_ARROW 0 ARROW_SCRIPT ARROW_OFS
			// }
			// else
			// {
			// tossprojectile NPCATK_TARGET ARROW_SPEED DMG_ARROW 0 ARROW_SCRIPT ARROW_OFS
			// }
			// }
			// else
			// {
			// tossprojectile NPCATK_TARGET ARROW_SPEED DMG_ARROW 0 ARROW_SCRIPT ARROW_OFS
			// callexternal ent_lastprojectile ext_lighten 0 ARROW_GLOW ARROW_GLOW_COLOR
			// }
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile(arrowScript, RelativePosition(Vector3(10, 0, 28)), NPCATK_TARGET, arrowSpeed, "DMG_ARROW", 0, "none");
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0, arrowGlow, arrowGlowColor);
		}
		else
		{
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			// for AOE arrows, shoot around the target randomly
			float halfAoe = Divide(ARROW_AOE, 2.0f);
			targOrg += RelativePosition(Vector3(0, Random(0, 359.99f), 0), Vector3(0, halfAoe, 0));
			if (!IsPlayer(Text(targOrg)))
				targOrg.z += HeightOf(NPCATK_TARGET);
			float targDist = Divide(Distance(targOrg, MyOrigin()), 25.0f);
			SetAngle("add_view.pitch", targDist);
			TossProjectile(arrowScript, RelativePosition(Vector3(10, 0, 28)), "none", arrowSpeed, "DMG_ARROW", 1, "none");
			float gravAdj = 0.4f;
			// don't think this is working (also logic is likely plain wrong)
			if (targOrg.z < Float(Eval("game.monster.origin.z")))
			{
				float adjRatio = Divide(targOrg.z, Float(Eval("game.monster.origin.z")));
				gravAdj = Float(LegacyFunction("get_skill_ratio", adjRatio, 0.4f, 2.0f));
				DebugPrint("adjusting down " + Text(gravAdj) + " ( " + Text(adjRatio) + " )");
			}
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", gravAdj, arrowGlow, arrowGlowColor);
		}

		if (MISS_COUNT > 4.0f)
		{
			// if you miss a bunch, twitch a bit in hopes for a better angle
			MISS_COUNT = 2.0f;
			PlayAnim("break");
			OnChickenRun(1.5f);
		}
	}

	// ext_arrow_hit
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) - called from proj_arrow_npc_dyn
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		bool hitEnemy = false;
		int count;
		bool targAlive = IsAlive(hitEntity);
		if (RelationshipOf(hitEntity, ENT_ME) == "enemy" && targAlive)
			hitEnemy = true;

		// if ( ARROW_KNOCKBACK > 0 )
		// {
		// if HIT_ENEMY
		// addvelocity PARAM2 $relvel(0,ARROW_KNOCKBACK,110)
		// }
		if (ARROW_EFFECT != "ARROW_EFFECT" && hitEnemy)
			ApplyEffect(hitEntity, ARROW_EFFECT, ARROW_DOT_DUR, self, ARROW_DOT_DMG);

		if (AOE_ARROW)
		{
			Vector3 arrowPos = startPosition;
			if (hitEnemy)
				arrowPos = OriginOf(hitEntity);
			arrowPos.z = GroundHeight(arrowPos);

			ClientEvent("new", "all", ARROW_CL_SCRIPT, arrowPos, 128, 1, Vector3(255, 0, 0));
			DoDamageEx(arrowPos, ARROW_AOE, ARROW_DMG_AOE, 0, ENT_ME, ENT_ME, "none", ARROW_DMG_TYPE);

			ARROW_TARGET_LIST = LegacyFunction("get_tsphere", "enemy", ARROW_AOE, arrowPos);
			if (ARROW_TARGET_LIST != "none")
			{
				count = GetTokenCount(ARROW_TARGET_LIST);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnArrowAffectTargets();
				}
			}
		}
	}

	// arrow_affect_targets
	void OnArrowAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(ARROW_TARGET_LIST, loopIteration));
		ApplyEffect(curTarg, ARROW_EFFECT, ARROW_DOT_DUR, self, ARROW_DOT_DMG);
		MISS_COUNT = 0.0f;
	}

	// ext_spiral_done
	void OnExtSpiralDone()
	{
		SPIRAL_ON = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("char_breath.spr");
		Precache("npc/elf_f_warrior.mdl");
		Precache("magic/bolt_loop.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TelfWarriorBow_FirstThink();
		ElfWarriorBase_FirstThink();
		ElfWarriorBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_affect_targets") { OnArrowAffectTargets(); return true; }
		if (name == "elf_spawn") { OnElfSpawn(); return true; }
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "ext_spiral_done") { OnExtSpiralDone(); return true; }
		if (name == "frame_shoot_bow") { OnFrameShootBow(); return true; }
		if (name == "frame_stretch_bow") { OnFrameStretchBow(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return ElfWarriorBaseScript::DispatchEvent(name, params);
	}
}
