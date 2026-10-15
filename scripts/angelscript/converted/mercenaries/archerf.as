#pragma context server

// Converted from mercenaries/archerf.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_attack.as"

[script "mercenaries/archerf"]
class Archerf : BaseNpcAttackScript
{
	// Constants
	int ARROW_DAMAGE_LOW = 8;
	int ARROW_DAMAGE_HIGH = 12;
	int ATTACK_SPEED = 700;
	int ATTACK_CONE_OF_FIRE = 4;

	// Variables (an unset .script variable reads as its own name)
	string SND_STRUCK1 = "body/flesh1.wav";
	string SND_STRUCK2 = "body/flesh2.wav";
	string SND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAINYELL = "voices/human/male_hit1.wav";
	string SOUND_WARCRY1 = "voices/human/male_guard_shout.wav";
	string SOUND_WARCRY2 = "voices/human/male_guard_shout2.wav";
	string SND_ATTACK1 = "voices/human/male_hit1.wav";
	string SND_ATTACK2 = "voices/human/male_hit2.wav";
	string SND_ATTACK3 = "voices/human/male_hit3.wav";
	string SND_BOW = "weapons/bow/bow.wav";
	int FLEE_HEALTH = 10;
	string FLEE_CHANCE = "15%";
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	Archerf()
	{
		SOUND_DEATH = "voices/human/male_die.wav";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void Archerf_FirstThink()
	{
		SND_STRUCK1 = "body/flesh1.wav";
		SND_STRUCK2 = "body/flesh2.wav";
		SND_STRUCK3 = "body/flesh3.wav";
		SOUND_PAINYELL = "voices/human/male_hit1.wav";
		SOUND_WARCRY1 = "voices/human/male_guard_shout.wav";
		SOUND_WARCRY2 = "voices/human/male_guard_shout2.wav";
		SND_ATTACK1 = "voices/human/male_hit1.wav";
		SND_ATTACK2 = "voices/human/male_hit2.wav";
		SND_ATTACK3 = "voices/human/male_hit3.wav";
		SND_BOW = "weapons/bow/bow.wav";
		CAN_FLINCH = "1";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "shootorcbow";
		MOVE_RANGE = "600";
		ATTACK_RANGE = 650.0f;
		FLINCH_DELAY = "4";
		FLEE_HEALTH = 10;
		FLEE_CHANCE = "15%";
		CAN_FLEE = "1";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(120);
		// ov 180
		SetWidth(32);
		SetHeight(85);
		SetRace("human");
		SetName("Human Archer");
		SetRoam(true);
		SetSkillLevel(30);
		SetGold(RandomInt(6, 10));
		SetHearingSensitivity(3);
		SetModel("npc/archer.mdl");
		SetDamageTaken("all", 0.8f);
		SetModelBody(2, 2);
		SetIdleAnim("idle1");
		SetMoveAnim("walk");
		GiveItem("proj_arrow_iron", 30);
		SetStat("parry", 5);
	}

	// grab_arrow
	void OnGrabArrow()
	{
		SetModelBody(3, 1);
	}

	// shoot_arrow
	void OnShootArrow()
	{
		// Deal damage
		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), 30.0f); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		int lclAtkdmg = RandomInt(ARROW_DAMAGE_LOW, ARROW_DAMAGE_HIGH);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 6)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, 10, SND_BOW);
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(10);
		PlayRandomSound(2, 10, SOUND_PAINYELL, SND_STRUCK2, SOUND_PAINYELL);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/archer.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Archerf_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		return BaseNpcAttackScript::DispatchEvent(name, params);
	}
}
