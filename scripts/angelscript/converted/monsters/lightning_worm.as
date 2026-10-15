#pragma context server

// Converted from monsters/lightning_worm.script by msc_transpiler.
// Well this thing's just weird

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_noclip.as"

[script "monsters/lightning_worm"]
class LightningWorm : BaseMonsterNewScript, BaseNoclip, BasePropelled
{
	// Constants
	string ANIM_EGG = "headshot";
	string SOUND_LOOP1 = "ambience/alien_creeper.wav";
	string SOUND_LOOP2 = "ambience/alien_frantic.wav";
	string SOUND_STRUCK1 = "bullchicken/bc_bite1.wav";
	string SOUND_STRUCK2 = "bullchicken/bc_bite3.wav";
	string SOUND_STRUCK3 = "debris/bustflesh2.wav";
	string SOUND_EGG = "tentacle/te_roar1.wav";
	string SOUND_CHARGE1 = "houndeye/he_attack1.wav";
	string SOUND_CHARGE2 = "houndeye/he_attack2.wav";
	string SOUND_CHARGE3 = "houndeye/he_attack3.wav";
	string SOUND_SHOOT1 = "houndeye/he_blast1.wav";
	string SOUND_SHOOT2 = "houndeye/he_blast2.wav";
	string SOUND_SHOOT3 = "houndeye/he_blast3.wav";
	float DMG_SHOCK = 0.0f;
	float DOT_SHOCK = 0.0f;
	int ROAM_RADIUS = 256;
	float VERT_RANGE_FULL = 0.0f;
	float VERT_RANGE_HALF = 0.0f;
	float FREQ_SHOOT = 0.0f;
	float FREQ_EGG = 0.0f;
	float FREQ_SOUND = 10.0f;
	float FREQ_REND = 0.5f;
	float FWD_SPEED = 10.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ACTIVE_HORRORS = 0.0f;
	Vector3 CENTER_POINT = Vector3();
	float QUARTER_HP = 0.0f;
	bool MOVING_CENTER = false;
	float HORROR_LIMIT = 0.0f;
	CBaseEntity@ WORM_TARGET = null;
	bool BEAM_ATTACK = false;
	Vector3 NPC_NOCLIP_DEST = Vector3();
	float DEST_ROT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	LightningWorm()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		ANIM_IDLE = "swim";
		ANIM_RUN = "swim";
		ANIM_WALK = "swim";
		ATTACK_RANGE = 2048.0f;
	}

	// unnamed block (first think)
	void LightningWorm_FirstThink()
	{
		if (ToLowerCase(MapName()) == "cleicert")
			NPC_IS_BOSS = true;

		IS_UNHOLY = true;

		ANIM_ATTACK = "treadwater";

		ANIM_DEATH = "die_simple";

		ATTACK_MOVERANGE = 1.0f;

		ANIM_IDLE = "swim";
		ANIM_RUN = "swim";
		ANIM_WALK = "swim";

		NPC_GIVE_EXP = 1500.0f;

		ATTACK_RANGE = 2048.0f;
	}

	// unnamed block (timer)
	void LightningWorm_Timer()
	{
		CallEventDelayed(FREQ_REND, "LightningWorm_Timer");
		if (MyHealth() < QUARTER_HP && RandomInt(1, 5) == 1)
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 64, 1, 1);
		if (RandomInt(1, 20) == 1)
			PlayAnim("critical", "crouch_idle");

		// playanim once swim
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RandomInt(128, 255));
	}

	// unnamed block (timer)
	void LightningWorm_Timer2()
	{
		CallEventDelayed(FREQ_SOUND, "LightningWorm_Timer2");
		ServerPlaySound(2, 0, "null.wav");
		CallEventDelayed(0.1f, "loop_sound");
	}

	// unnamed block (timer)
	void LightningWorm_Timer3()
	{
		CallEventDelayed(FREQ_SHOOT, "LightningWorm_Timer3");
		if (!IsAlive(WORM_TARGET))
			return;
		PlayRandomSound(0, 10, SOUND_CHARGE1, SOUND_CHARGE2, SOUND_CHARGE3);
		float shootDelay = Random(1.5f, 2);
		PlayAnim("critical", ANIM_ATTACK);
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 5, 5);
		CallEventDelayed(shootDelay, "do_lightning");
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string LightningWorm_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit && BEAM_ATTACK)
		{
			BEAM_ATTACK = false;
			if (!IsAlive(target))
			{
				Vector3 traceStart = OriginOf(ENT_ME);
				Vector3 traceEnd = OriginOf(WORM_TARGET);
				string traceIt = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
				Effect("beam", "point", "lgtning.spr", 60, traceStart, traceIt, Vector3(255, 255, 50), 200, 60, 1.0f);
			}
		}

		if (!hit)
			return result;
		// beam point <spritename> <width> <startpos> <endpos> <(r,g,b)> <brightness> <noise> <duration>
		if (!BEAM_ATTACK)
			return result;
		BEAM_ATTACK = false;
		ApplyEffect(target, "effects/dot_lightning", 5, self, DOT_SHOCK);
		Vector3 beamStart = OriginOf(ENT_ME);
		Vector3 beamEnd = OriginOf(WORM_TARGET);
		Effect("beam", "point", "lgtning.spr", 60, beamStart, beamEnd, Vector3(255, 255, 50), 200, 60, 1.0f);
		return result;
	}

	// unnamed block (timer)
	void LightningWorm_Timer4()
	{
		CallEventDelayed(FREQ_EGG, "LightningWorm_Timer4");
		if (!(ACTIVE_HORRORS < HORROR_LIMIT))
			return;
		PlayAnim("critical", ANIM_EGG);
		PlaySound(0, 10, SOUND_EGG);
		CallEventDelayed(0.5f, "lay_egg");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		CallExternal(GetVar("GAME_MASTER"), "gm_worm_gold", self, "chests/bag_o_gold_50");
		ServerPlaySound(2, 0, "null.wav");
		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));
		SetVelocity(ENT_ME, Vector3(-110, 110, 110));
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
		OnLoopSound();
		OnNpcatkSuspendAi(); // redund
		QUARTER_HP = MyMaxHealth() * 0.25f;
		SetMoveDest(CENTER_POINT, 0);
		MOVING_CENTER = true;

		HORROR_LIMIT = 4.0f;
		if (Float(Eval("game.players.totalhp")) > 1600.0f)
			HORROR_LIMIT += 1.0f;
		if (Float(Eval("game.players.totalhp")) > 3200.0f)
			HORROR_LIMIT += 1.0f;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		@WORM_TARGET = EntityOf(ENT_LASTSTRUCK);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Ethereal Vermicular");
		SetRace("demon");
		SetHealth(4000);
		SetModel("monsters/weird_worm.mdl");
		SetDamageTaken("lightning", 0);
		SetDamageTaken("holy", 1);
		SetBlood("green");
		SetFly(true);

		SetWidth(72);
		SetHeight(72);

		SetMoveAnim("swim");
		SetIdleAnim("swim");

		ACTIVE_HORRORS = 0.0f;

		OnNpcatkSuspendAi();
		CallEventDelayed(0.1f, "set_centerpoint");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, LightningWorm_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// basenoclip_flight
	void OnBasenoclipFlight()
	{
		BaseNoclip_OnBasenoclipFlight(); // monsters/base_noclip

		DebugPrint("temp dist " + Text(Distance(MyOrigin(), CENTER_POINT)) + " ( " + Text(MOVING_CENTER) + " )");

		if (MOVING_CENTER)
		{
			NPC_NOCLIP_DEST = CENTER_POINT;
			if (Distance(MyOrigin(), NPC_NOCLIP_DEST) < 96.0f)
				MOVING_CENTER = false;
		}
		if (MOVING_CENTER)
			return;

		if (Distance(MyOrigin(), NPC_NOCLIP_DEST) < 96.0f)
		{
			DEST_ROT += 45.0f;
			if (DEST_ROT > 359.0f)
				DEST_ROT -= 359.0f;
			NPC_NOCLIP_DEST = CENTER_POINT;
			float vertRange = VERT_RANGE_FULL;
			if (RandomInt(1, 2) == 1)
				vertRange = VERT_RANGE_HALF;
			NPC_NOCLIP_DEST += RelativePosition(Vector3(0, DEST_ROT, 0), Vector3(0, ROAM_RADIUS, vertRange));
		}
	}

	// set_centerpoint
	void OnSetCenterpoint()
	{
		CENTER_POINT = MyOrigin();
		CENTER_POINT.z += 256.0f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
	}

	// loop_sound
	void OnLoopSound()
	{
		if (MyHealth() > QUARTER_HP)
			ServerPlaySound(2, 10, SOUND_LOOP1);
		if (MyHealth() < QUARTER_HP)
			ServerPlaySound(2, 10, SOUND_LOOP2);
	}

	// do_lightning
	void OnDoLightning(string endOrigin = "")
	{
		PlayRandomSound(0, 10, SOUND_SHOOT1, SOUND_SHOOT2, SOUND_SHOOT3);
		BEAM_ATTACK = true;

		// beam ents <spritename> <width> <target> <attachment index> <(r,g,b)> <brightness> <noise> <duration>
		// effect beam ents lgtning.spr 60 WORM_TARGET 0 (255,255,50) 200 60 1.0
		DoDamage(WORM_TARGET, ATTACK_RANGE, DMG_SHOCK, "100%", "lightning");
	}

	// lay_egg
	void OnLayEgg()
	{
		if ((IsInWater(ENT_ME) ? 1 : 0) != 0) // hoping off map will = in water
			return;
		CreateNpc("monsters/summon/horror_egg_lightning", RelativePosition(Vector3(0, 0, 0)), self);
		ACTIVE_HORRORS += 1.0f;
	}

	// horror_died
	void OnHorrorDied()
	{
		ACTIVE_HORRORS -= 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip
	}

	void OnShootDelay() {} // SHOOT_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/egg.mdl");
		Precache("monsters/weird_worm.mdl");
		Precache("null.wav");
		Precache("ambience/alien_creeper.wav");
		Precache("ambience/alien_frantic.wav");
		CallEventDelayed(FREQ_REND, "LightningWorm_Timer");
		CallEventDelayed(FREQ_SOUND, "LightningWorm_Timer2");
		CallEventDelayed(FREQ_SHOOT, "LightningWorm_Timer3");
		CallEventDelayed(FREQ_EGG, "LightningWorm_Timer4");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LightningWorm_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseNoclip_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "basenoclip_flight") { OnBasenoclipFlight(); return true; }
		if (name == "do_lightning") { OnDoLightning(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "horror_died") { OnHorrorDied(); return true; }
		if (name == "lay_egg") { OnLayEgg(); return true; }
		if (name == "loop_sound") { OnLoopSound(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_centerpoint") { OnSetCenterpoint(); return true; }
		if (name == "LightningWorm_Timer") { LightningWorm_Timer(); return true; }
		if (name == "LightningWorm_Timer2") { LightningWorm_Timer2(); return true; }
		if (name == "LightningWorm_Timer3") { LightningWorm_Timer3(); return true; }
		if (name == "LightningWorm_Timer4") { LightningWorm_Timer4(); return true; }
		return BaseNoclip_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
