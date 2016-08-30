// title      : Push-powered two person lay-down weeder 
// author     : Reggie Thomson
// license    : MIT License
// revision   : 0.01
// date       : 20160829
// tags       : Bogey, Tyre, tire, cropshare,  
// file       : push_powered_weeder.scad
// todo       : 

use <bogey.scad>

CartWidth = 1800 ;

PostHeightFront = 500 ;
PostHeightRear = 450 ;
PostDepth = 45 ;
PostWidth = 120 ;
PostCutoutHeight = 150 ;
PostCutoutWidth = 20 ;
PostFixingHoleHeight = 50 ;

LongBarLength = CartWidth ; // http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x120x2400mm-Single/p/166360 £9.49 * 2 (2400)
LongBarDepth = 45 ;
LongBarWidth = 95 ;


FrontToRearPostLength = 900 ; // distance between holes on the bogey for the front and rear posts
FrontExtLength = 400 ;
 
CrossBracingDepth = 45 ;  // http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x70x3600mm-Single/p/190165 £9.69 (3600mm)
CrossBracingWidth = 70 ;

OsbThickness = 18 ; // http://www.wickes.co.uk/Wickes-General-Purpose-OSB3-Board-18-x-1220-x-2440mm/p/110517 £19 * 2
OsbTopWidth = CartWidth / 2 ;
OsbTopLength = 1400 ;

SideBracingLength = OsbTopLength + FrontExtLength ;

// OsbSideLength = 1600 ; // up to 2400 max - now no need for OSB on sides
// OsbSideWidth = 1220 - OsbTopWidth ; // approx 300mm - now no need for OSB on sides
 
module Post( Place, Side)
{

  PostHeight = (Place == "front") ? PostHeightFront : PostHeightRear ; 

  PostXOffset = (Side == "left") ? 0 : CartWidth - PostWidth ;
  PostYOffset = - PostDepth / 2 + ((Place == "front") ? 0 : FrontToRearPostLength ); 
  PostZOffset = (Place == "front") ? - PostFixingHoleHeight : PostHeightFront - PostHeightRear - PostFixingHoleHeight ;

  PostCutoutXOffset = (Side == "left") ? -1 : PostWidth - PostCutoutWidth;
  color("DarkKhaki")
  {
    translate([PostXOffset, PostYOffset, PostZOffset])
    {
      difference ()
      {
        cube([PostWidth, PostDepth, PostHeight], centre = false); // http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x120x2400mm-Single/p/166360 £9.49
        translate([PostCutoutXOffset, -1, -1]) cube([PostCutoutWidth + 1, PostDepth + 2, PostCutoutHeight + 1], centre = false);
        translate([(Side == "left") ? -1 : PostWidth - CrossBracingDepth, -1, PostHeight - CrossBracingWidth]) cube([CrossBracingDepth + 1, PostDepth + 2, CrossBracingWidth + 1], centre = false);
        translate([-1, PostDepth / 2, PostFixingHoleHeight]) rotate([0, 90, 0]) cylinder( h = PostWidth + 2, d = 13, centre = false); // hole for fixing to bogey
      }
    }
  }
}

ShowBogies = 1 ;

// The two bogies
if (ShowBogies)
{
  translate([70,-250,0]) 
  {
    Bogey(Side = "right"); // bogey on right hand side
  }

  translate([CartWidth - 70,-250,0]) 
  {
    Bogey(Side = "left"); // bogey on left hand side
  }
}

rotate ([ (ShowBogies ? - atan ((PostHeightFront - PostHeightRear ) / FrontToRearPostLength ) : 0), 0, 0]) 
{
  // posts to hold the top boards and sides
  if (ShowBogies)
  {
    Post( Place = "front", Side = "left") ;
    Post( Place = "rear", Side = "left") ;
    Post( Place = "front", Side = "right") ;
    Post( Place = "rear", Side = "right") ;
  }
  
  translate ([0, ShowBogies ? PostDepth / 2 : 0, ShowBogies ? PostHeightFront - PostFixingHoleHeight : 0])
  {
    // The structure holding the top in place
    color("YellowGreen") translate ([CrossBracingDepth, 0, - LongBarWidth]) cube ([CartWidth - 2 * CrossBracingDepth, LongBarDepth, LongBarWidth], centre = false); // front bar - http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x95x3600mm-Single/p/190167 £11.99

    color("YellowGreen") translate ([CrossBracingDepth, FrontToRearPostLength, - LongBarWidth]) cube ([CartWidth - 2 * CrossBracingDepth, LongBarDepth, LongBarWidth], centre = false); // rear bar - http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x95x3600mm-Single/p/190167 £11.99


    color("SpringGreen") translate ([0, - FrontExtLength - LongBarDepth, - CrossBracingWidth ]) cube ([CrossBracingDepth, SideBracingLength, CrossBracingWidth], centre = false); // left bracing 
    color("SpringGreen") translate ([( CartWidth - CrossBracingDepth ) / 2, LongBarDepth, - CrossBracingWidth ]) cube ([CrossBracingDepth, OsbTopLength - LongBarDepth - CrossBracingDepth * 2, CrossBracingWidth], centre = false); // centre bracing
    color("SpringGreen") translate ([CartWidth - CrossBracingDepth, - FrontExtLength - LongBarDepth, - CrossBracingWidth ]) cube ([CrossBracingDepth, SideBracingLength, CrossBracingWidth], centre = false); // right bracing

    
    color("SpringGreen") translate ([CrossBracingDepth, OsbTopLength - CrossBracingDepth - LongBarDepth, - CrossBracingWidth ]) cube ([CartWidth - 2 * CrossBracingDepth, CrossBracingDepth, CrossBracingWidth], centre = false); // rear bracing 
    
    
    color("SpringGreen") translate ([CrossBracingDepth, - FrontExtLength - CrossBracingDepth, - CrossBracingWidth ]) cube ([CartWidth - 2 * CrossBracingDepth, CrossBracingDepth, CrossBracingWidth], centre = false); // front head rest

    /*
    // incorrect - currently hits the rear posts. Anyway, are they necessary?
    InnerBracingOffset = sqrt (CrossBracingDepth * CrossBracingDepth + LongBarDepth * LongBarDepth) ;
    a = CartWidth / 2 - (CrossBracingDepth * 1.5) ;
    b = FrontToRearPostLength - LongBarDepth ;
    InnerBracingLength = sqrt  ( a * a + b * b) ;
    for (i = [ 0 : 1 ])
    {
      j = i == 0 ? CartWidth / 2 - CrossBracingDepth / 2 :  CartWidth / 2 + CrossBracingDepth / 2;
      InnerBracingAngle = i == 0 ? atan (b / a) - 90 : 90 - atan (b / a) ;
      translate ( [j, 0, - CrossBracingWidth ])
      {
        color("Magenta") rotate ([0, 0, InnerBracingAngle ]) translate ([- CrossBracingDepth / 2, InnerBracingOffset, 0 ]) cube ([CrossBracingDepth, InnerBracingLength, CrossBracingWidth], centre = false); // cross bracing 
        // rotate ([0, 0, InnerBracingAngle ]) translate ([- CrossBracingDepth / 2, InnerBracingOffset, 0 ]) cube ([CrossBracingDepth, InnerBracingLength, CrossBracingWidth], centre = false); // cross bracing 
      }
    }
    */

    

    // The top OSB boards
    color("SaddleBrown")  translate ([0, - PostDepth, 0]) cube ([OsbTopWidth, OsbTopLength, OsbThickness ], centre = false) ;
    color("Sienna")  translate ([CartWidth / 2, - PostDepth, 0]) cube ([OsbTopWidth, OsbTopLength, OsbThickness ], centre = false) ;



  }

}


  
