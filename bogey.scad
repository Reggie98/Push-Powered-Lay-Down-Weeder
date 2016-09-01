// title      : bogey with two tyres
// author     : Reggie Thomson
// license    : MIT License
// revision   : 0.01
// date       : 20160830
// tags       : Bogey, Tyre, tire 
// file       : bogey.scad
// todo       : may need cross bracing between the two angle bars; exploded view; dimensions


use <tyre.scad>

include <MCAD/metric_fastners.scad>


module SteelAngle( Length, Width, Depth, Thickness )
{
  rotate( [-90, 0, 0] )
  {
    linear_extrude( height = Length, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0 )
    {
      square( [Width, Thickness], center = false );
      square( [Thickness, Depth], center = false );
    }
  }
  echo( str( "Steel Angle: ", Width, "x", Depth, "x", Thickness, "mm, Length=", Length, "mm" ) );
}

module SteelAngleWithHoles()
{
  difference()
  {
    // uses https://www.themetalstore.co.uk/products/1-5-metre-lengths-3mm-angle 40x40x3mm 1500mm = £5.10 * 4 + £10 = £30.20
    SteelAngle( Length = 1500, Width = 40, Depth = 40, Thickness = 3 );
    translate( [-1, 50, -40 / 2] ) rotate( [0, 90, 0] ) cylinder( h = 3 + 2, d = 13, center = false ); // hole for front wheel
    translate( [-1, 300, -40 / 2] ) rotate( [0, 90, 0] ) cylinder( h = 3 + 2, d = 13, center = false ); // hole for front post
    translate( [-1, 1500 - 300, -40 / 2] ) rotate( [0, 90, 0] ) cylinder( h = 3 + 2, d = 13, center = false ); // hole for rear post
    translate( [-1, 1500 - 50, -40 / 2] ) rotate( [0, 90, 0] ) cylinder( h = 3 + 2, d = 13, center = false ); // hole for rear wheel
  }
}

module NutBolt( MSize, Length, Side )
{
  SteelAngleThickness = 3 ;
  SteelAngleXApart = 100 ;
  NutLength = 9 ;
  BoltHeadLength = 8 ;
  RotateY = Side == "Left" ? -90 : 90 ;
  NutTranslateX = Side == "Left" ? - SteelAngleXApart / 2 - SteelAngleThickness - NutLength : SteelAngleXApart / 2 + SteelAngleThickness + NutLength ;
  BoltTranslateX = Side == "Left" ? SteelAngleXApart / 2 + SteelAngleThickness + BoltHeadLength : - SteelAngleXApart / 2 - SteelAngleThickness - BoltHeadLength;
  color( "Silver" ) 
  {
    translate( [NutTranslateX, 0, 0] ) 
    {
      rotate( [0, RotateY, -180] )
      {
        flat_nut( MSize );
        echo( str( "Nut: M", MSize) );
      }
    }
    translate( [BoltTranslateX, 0, 0] )
    {
      rotate( [0, RotateY, 0] )
      {
        bolt( MSize, Length );
        echo( str( "Bolt: M", MSize, "x", Length ) );
      }
    }
  }
}   

module Bogey( Side )
{
  // using wheels: https://www.amazon.co.uk/Wheelbarrow-Wheels-4-00-8-Breakdown-Replacement/dp/B00KIRDQD8/ref=pd_sim_sbs_86_4?ie=UTF8&psc=1&refRID=WG86P9DETDBC447QBP2Y £19.95 * 4 = £79.80
  
  Tyre( TyreDiameter = 390, TyreWidth = 95, CamberRadius = 45, WheelDiameter = 220, WheelRim = 20, WheelInnerWidth = 45, AxelDiameter = 16, AxelMountDiameter = 36, TyreColour = "Yellow", WheelColour = "Red" );
  
  translate( [0, 1400, 0] )
  {
    Tyre( TyreDiameter = 390, TyreWidth = 95, CamberRadius = 45, WheelDiameter = 220, WheelRim = 20, WheelInnerWidth = 45, AxelDiameter = 16, AxelMountDiameter = 36, TyreColour = "Yellow", WheelColour = "Red" ); 
  }
  
  translate( [50, -50, 40 / 2] )
  {
    color( "Green" ) SteelAngleWithHoles();
  }

  translate( [-50, - 50, 40 / 2] )
  {
    mirror( [1, 0, 0] )
    {
      color( "Green" ) SteelAngleWithHoles();
    }
  }
  
  NutBolt( MSize = 12, Length = 150, Side = Side ); // Nut and bolt for front wheel (free with wheel)
  
  translate( [0, 300 - 50, 0] )
  {
    NutBolt( MSize = 12, Length = 150, Side = Side ); // Nut and bolt for front post
  }
  translate( [0, 1500 - 350, 0] )
  {
    NutBolt( MSize = 12, Length = 150, Side = Side ); // Nut and bolt for rear post
  }
  translate( [0, 1500 - 100, 0] )
  {
    NutBolt( MSize = 12, Length = 150, Side = Side ); // Nut and bolt for rear wheel (free with wheel)
  }
  
}

Bogey( Side = "Right" );



  
