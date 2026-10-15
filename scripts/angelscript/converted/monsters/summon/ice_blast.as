#pragma context server

// Converted from monsters/summon/ice_blast.script by msc_transpiler.
// Ice Blast by Thothie, from scratch (this is Freezing Sphere)
// Now that we have xdodamage and $get_tsphere - this should probably be turned into a projectile

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_noclip.as"

[script "monsters/summon/ice_blast"]
class IceBlast : BaseNoclipScript
{
	// Constants
	string SOUND_HUM = "magic/pulsemachine_noloop.wav";
	float HUM_LENGTH = 1.7f;
	float STUCKCHECK_FREQ = 0.5f;
	string BLAST_MODEL = "weapons/projectiles.mdl";
	string MODEL_BODY_OFS = "1";
	string PROJ_ANIM_IDLE = "idle_iceball";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";
	float BALL_SPEED = 100.0f;
	string LIGHTNING_SPRITE = "lgtning.spr";
	int ATTACK_RADIUS = 196;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float FREEZE_DURATION = 0.0f;
	bool PLAYER_SPAWNED = false;
	string OWNER_ANGLES = "OWNER_ANGLES";
	Vector3 FINAL_DEST = Vector3();
	bool FREEZING = false;
	Vector3 ICE_OLD_POS = Vector3();
	CBaseEntity@ IGNORE_TARGET = null;

	// Variables declared by included files, with the value they start with in this script
	IceBlast()
	{
		FWD_SPEED = 10.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNoclip_OnGameSpawn(playerRace, playerGender); // monsters/base_noclip

		SetName("Freezing Sphere");
		SetHealth(1);
		SetInvincible(true);
		SetFly(true);
		SetGravity(0);
		SetFieldOfView(359);
		SetRace("beloved");
		SetWidth(1);
		SetHeight(1);
		SetMonsterClip(false);
		SetModel(BLAST_MODEL);
		SetModelBody(0, Int(MODEL_BODY_OFS));
		SetSolid("not");
		SetBoundingBox("none");
		SetIdleAnim(PROJ_ANIM_IDLE);
		SetMoveAnim(PROJ_ANIM_IDLE);
		SetAnimFrameRate(2);
		PlayAnim("idle");

		FREEZING = true;

		ICE_OLD_POS = OriginOf(ENT_ME);

		CallEventDelayed(0.1f, "freeze_loop");
		CallEventDelayed(0.5f, "hum_loop");

		// local MY_OWNER $get(ent_creationowner,id)
		// local FINAL_DEST $get(MY_OWNER,origin)
		// local FINAL_DEST $relpos($vec(0,0,0),$vec(0,800,0))
		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		SetProp(ENT_ME, "solid", 0);

		CallEventDelayed(10.0f, "remove_me");
	}

	// game_dynamically_created
	// PARAM1 = owner PARAM2 = Freeze Duration PARAM3 = dest
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// setvard MY_OWNER PARAM1
		// setvard FREEZE_DURATION PARAM2
		// setvard FINAL_DEST PARAM3
		// setprop		ent_me movetype const.movetype.noclip
		// setprop		ent_me solid 0
		// //dbg MyOwnerAngles OWNER_ANGLES dest FINAL_DEST
		// setmovedest FINAL_DEST 10
		// setanim.movespeed BALL_SPEED
		MY_OWNER = creatorValue1;
		FREEZE_DURATION = Float(creatorValue2);

		// //dbg temp got duration PARAM2
		PLAYER_SPAWNED = IsPlayer(creatorValue1);

		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		SetProp(ENT_ME, "solid", 0);

		OWNER_ANGLES = Text(AnglesOf(MY_OWNER));

		SetAngle("face", OWNER_ANGLES);

		FINAL_DEST = RelativePosition(Vector3(0, 20000, 0));

		// vectoradd FINAL_DEST $relpos(OWNER_ANGLES,$vec(0,8000,0))
		if (!damage.isEmpty())
			FINAL_DEST = Vec(damage);

		// dbg Dest FINAL_DEST
		NPC_NOCLIP_DEST = FINAL_DEST;
	}

	// hum_loop
	// { stuck_loop
	// if FREEZING
	// callevent STUCKCHECK_FREQ stuck_loop
	// local MY_POS $get(ent_me,origin)
	// if ( $dist(MY_POS,ICE_OLD_POS) == 0 ) callevent game_reached_dest
	// setvard ICE_OLD_POS MY_POS
	// }
	void OnHumLoop()
	{
		if (!FREEZING)
			return;
		CallEventDelayed(HUM_LENGTH, "hum_loop");

		PlaySound(Int(GetVar("CHAN_BODY")), 10, SOUND_HUM);
	}

	// freeze_loop
	void OnFreezeLoop()
	{
		if (!FREEZING)
			return;

		// local MY_YAW $vec.yaw(game.monster.angles)
		// vectoradd FINAL_DEST $relpos($vec(0,MY_YAW,0),$vec(0,1000,0))
		// setangle face_origin FINAL_DEST
		// setorigin ent_me $relpos(0,2,0)
		// setmovedest FINAL_DEST 10
		CallEventDelayed(0.1f, "freeze_loop");

		if (!CanSee("ally"))
			return;
		if (EntityOf(ENT_LASTSEEN) is IGNORE_TARGET)
			return;
		if (RelationshipOf(MY_OWNER, ENT_LASTSEEN) != "enemy")
			return;
		if (!(RangeTo(ENT_LASTSEEN) < ATTACK_RADIUS))
			return;

		Vector3 targetOrg = OriginOf(ENT_LASTSEEN);
		// ents no workie, stickin to points
		// effect beam ents <spritename> <width> <target> <attachment index> <(r,g,b)> <brightness> <noise> <duration>
		// effect beam ents LIGHTNING_SPRITE $get(ent_lastseen,id) $get(ent_me,id) (200,200,255) 150 50 1.0
		Effect("beam", "point", LIGHTNING_SPRITE, 60, RelativePosition(Vector3(0, 0, 0)), targetOrg, Vector3(200, 200, 255), 150, 50, 1.0f);
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);

		if (HealthOf(ENT_LASTSEEN) <= 1500.0f)
		{
			float dot = SkillOf(MY_OWNER, "spellcasting.ice") * 0.25f; // dot = 0.25 x spellcasting.ice
			ApplyEffect(ENT_LASTSEEN, "effects/dot_cold_freeze", FREEZE_DURATION, MY_OWNER, dot, "spellcasting.ice");
		}
		// if ( $get(ent_lastseen,isplayer) )
		// {
		// if !PLAYER_SPAWNED
		// applyeffect ent_lastseen effects/dot_cold_freeze FREEZE_DURATION MY_OWNER
		// }
		// if ( !$get(ent_lastseen,isplayer) ) callexternal $get(ent_lastseen,id) freeze_solid FREEZE_DURATION MY_OWNER
		if (HealthOf(ENT_LASTSEEN) >= 1500.0f && PLAYER_SPAWNED)
		{
			string targName = NameOf(ENT_LASTSEEN);
			PlayerMessage(MY_OWNER, targName + " is too strong to be affected.");
		}
		@IGNORE_TARGET = EntityOf(ENT_LASTSEEN);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		FREEZING = false;
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnHumLength() {} // HUM_LENGTH

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
		if (name == "freeze_loop") { OnFreezeLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "hum_loop") { OnHumLoop(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return BaseNoclipScript::DispatchEvent(name, params);
	}
}
