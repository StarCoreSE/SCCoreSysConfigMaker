private AmmoDef Example_Ammo => new AmmoDef
{
    AmmoMagazine = "Energy",
BaseDamage = 1,
    HardPointUsable = true,
    NoGridOrArmorScaling = true, 
    Trajectory = new TrajectoryDef
    {
        MaxLifeTime = 3600,
MaxTrajectory = 3733,
DesiredSpeed = 2747,
    },
    AmmoGraphics = new GraphicDef
    {
	VisualProbability = 1f,
	Lines = new LineDef
	{
	   Tracer = new TracerBaseDef
	   {
	       Enable = true,
	       Length = 10f,
	       Width = 0.1f,
	       Color = Color(red: 5, green: 2, blue: 1f, alpha: 1),
	       Textures = new[] {"ProjectileTrailLine",},
	   },
	},
    },
};


