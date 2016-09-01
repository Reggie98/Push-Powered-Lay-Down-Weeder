// title      : Push-powered two person lay-down weeder 
// author     : Reggie Thomson
// license    : MIT License
// revision   : 0.02
// date       : 20160901
// tags       : cropshare, weeder, push-powered
// file       : push_powered_weeder.scad
// todo       : add cross bracing if needed; make rear post holes fit the bogey; optional cupboard on one side; 
//            : head rest not fixed; exploded view; dimensions; head rest foam size from FoamToppingOffcutLength


ShowBogies = 1 ; // 0 = just show the top without posts or bogies, 1 = show everything
WithOSBSides = 1 ; // 0 = don't have sides, 1 = add OSB to sides
UndercoatColour = "White";
IsPainted = 1 ;
ShowFoam = 1 ;
ShowGraffiti = 1 ; // IsPainted ; // Only show graffiti if painted

use <bogey.scad>

CartWidth = 1800 ;

PostHeightFront = 500 ;
PostHeightRear = 450 ;
PostDepth = 45 ;
PostWidth = 120 ;
PostCutoutHeight = 150 ;
PostCutoutWidth = 20 ;
PostFixingHoleHeight = 50 ;
PostColour = IsPainted ? UndercoatColour : "DarkKhaki";

LongBarLength = CartWidth; // http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x120x2400mm-Single/p/166360 £9.49 * 2 (2400)
LongBarDepth = 45 ;
LongBarWidth = 95 ;
LongBarColour = IsPainted ? UndercoatColour : "YellowGreen";

FrontToRearPostLength = 900 ; // distance between holes on the bogey for the front and rear posts
FrontExtLength = 400 ;

OsbBoardSize = [2440, 1220, 18]; // http://www.wickes.co.uk/Wickes-General-Purpose-OSB3-Board-18-x-1220-x-2440mm/p/110517 £19 * 2
OsbThickness = OsbBoardSize[2]; 
OsbTopWidth = CartWidth / 2  + (WithOSBSides ? OsbThickness : 0);
OsbTopLength = 1400 ;
OSBTopRightColour = IsPainted ? UndercoatColour : "SaddleBrown";
OSBTopLeftColour = IsPainted ? UndercoatColour : "Sienna";

OsbSideLength = OsbTopLength + FrontExtLength; // up to 2440 max 
OsbSideWidth = OsbBoardSize[1] - OsbTopWidth; // approx 300mm
OSBSideColour = IsPainted ? UndercoatColour : "Coral";
 
SideBarDepth = 45 ;  // http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x70x3600mm-Single/p/190165 £9.69 (3600mm)
SideBarWidth = 70 ;
SideBarLength = OsbTopLength + FrontExtLength - LongBarDepth;
SideBarColour = IsPainted ? UndercoatColour : "SpringGreen";

FoamToppingSize = [1900, 1370, 75];
FoamToppingLength = OsbTopLength + 100 ; // allow for some overhang over the front or rear edges of the OSB board 
FoamToppingWidth = FoamToppingSize[1] / 2 ; // cut in two lengthways
FoamToppingDepth = FoamToppingSize[2];
FoamToppingColour = "Yellow";
FoamToppingRightXOffset = (CartWidth / 2 - FoamToppingWidth) / 2 ;
FoamToppingLeftXOffset = (CartWidth * 3 / 2 - FoamToppingWidth) / 2 ;
FoamToppingOffcutLength = FoamToppingSize[0] - FoamToppingLength;

FoamHeadRestWidth = FoamToppingDepth * 2 + LongBarDepth;
FoamHeadRestLength = FoamToppingWidth;
  
module Post( Place, Side )
{

  PostHeight = (Place == "Front") ? PostHeightFront : PostHeightRear; 

  PostXOffset = (Side == "Left") ? 0 : CartWidth - PostWidth;
  PostYOffset = - PostDepth / 2 + ((Place == "Front") ? 0 : FrontToRearPostLength ); 
  PostZOffset = (Place == "Front") ? - PostFixingHoleHeight : PostHeightFront - PostHeightRear - PostFixingHoleHeight;

  PostCutoutXOffset = (Side == "Left") ? -1 : PostWidth - PostCutoutWidth;
  color(PostColour)
  {
    translate( [PostXOffset, PostYOffset, PostZOffset] )
    {
      difference()
      {
        // http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x120x2400mm-Single/p/166360 £9.49
        cube( [PostWidth, PostDepth, PostHeight], center = false ); 
        echo( str( Place, " ", Side, " Post, Timber: ", PostWidth, "x", PostDepth, "mm, Length=", PostHeight, "mm" ) );
        // cut out 
        translate( [PostCutoutXOffset, -1, -1] ) cube( [PostCutoutWidth + 1, PostDepth + 2, PostCutoutHeight + 1], center = false );
        
        // cut out for side bar
        translate( [(Side == "Left") ? -1 : PostWidth - SideBarDepth, -1, PostHeight - SideBarWidth] ) cube( [SideBarDepth + 1, PostDepth + 2, SideBarWidth + 1], center = false );
        
        // hole for fixing to bogey - can have several holes to allow for adjusting the height and slope of the top
        translate( [-1, PostDepth / 2, PostFixingHoleHeight] ) rotate( [0, 90, 0] ) cylinder( h = PostWidth + 2, d = 13, center = false ); 
      }
    }
  }
}

module FoamHeadRest( Side )
{
  if (ShowFoam)
  {
    FoamCamber = 5 ;

    translate( [Side == "Right" ? FoamToppingRightXOffset : FoamToppingLeftXOffset , -FoamToppingDepth, 1])
    {
      difference()
      {
        rotate( [90, 0, 90] )
        {
          color( FoamToppingColour )
          {
            linear_extrude( height = FoamToppingWidth, center = false, convexity = 10, slices = 20)
            {
              hull()
              {
                translate( [FoamCamber, FoamCamber, 0] ) 
                {
                  circle( r = FoamCamber );
                }
                translate( [FoamHeadRestWidth - FoamCamber, FoamCamber, 0] ) 
                {
                  circle( r = FoamCamber );
                }
                translate( [FoamToppingDepth, LongBarWidth, 0] ) 
                {
                  circle( r = FoamToppingDepth );
                }
                translate( [FoamHeadRestWidth - FoamToppingDepth, LongBarWidth, 0] )
                {
                  circle( r = FoamToppingDepth );
                }
              }
            }
          }
        }
        // cut the channel for the Head Rest bar
        translate( [-1, FoamToppingDepth, -1]) cube( [FoamHeadRestLength + 2, LongBarDepth, LongBarWidth + 2], center = false );
      }
    }
  }
}

module TextWrite( Lines, Height, Translate, Rotate, Colour)
{
  if (ShowGraffiti)
  {
    translate( Translate + [0, Height * ( len( Lines ) - 1) / 2, 0]) 
    {
      rotate( Rotate )
      {
        color( Colour ) linear_extrude( height = 0.5 ) 
        {
          for ( i = [0 : len( Lines ) - 1])
          {
            translate([0 , - (i - 1) * Height * 1.4, 0 ]) text(text = Lines[i], size = Height, halign = "center", valign = "center");
          }
        }
      }
    }
  }
}

// The two bogies
if (ShowBogies)
{
  translate( [70,-250,0] ) 
  {
    Bogey( Side = "Right" ); // bogey on right hand side
  }

  translate( [CartWidth - 70,-250,0] ) 
  {
    Bogey( Side = "Left" ); // bogey on left hand side
  }
}

rotate( [(ShowBogies ? - atan( (PostHeightFront - PostHeightRear ) / FrontToRearPostLength ) : 0), 0, 0] ) 
{
  // posts to hold the top boards and sides
  if (ShowBogies)
  {
    Post( Place = "Front", Side = "Left");
    Post( Place = "Rear", Side = "Left");
    Post( Place = "Front", Side = "Right");
    Post( Place = "Rear", Side = "Right");
  }
  
  translate( [0, ShowBogies ? PostDepth / 2 : 0, ShowBogies ? PostHeightFront - PostFixingHoleHeight : 0] )
  {
    // The structure holding the top in place
    
    // front bar - http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x95x3600mm-Single/p/190167 £11.99
    translate( [SideBarDepth, 0, - LongBarWidth] )
    {
      color( LongBarColour ) cube( [CartWidth - 2 * SideBarDepth, LongBarDepth, LongBarWidth], center = false ); 
      echo( str( "Front Bar, Timber: ", LongBarWidth, "x", LongBarDepth, "mm, Length=", CartWidth - 2 * SideBarDepth ) ); 
      TextWrite( Lines = ["The Cropshare Push-Powered, Lay-Down Weeder"], Height = 30, Translate = [CartWidth / 2, 0, 0], Rotate = [90, 0, 0], Colour = "RoyalBlue");
    }
    
    // rear bar - http://www.wickes.co.uk/Wickes-Treated-Kiln-Dried-C16-Regularised-45x95x3600mm-Single/p/190167 £11.99
    translate( [SideBarDepth, FrontToRearPostLength - LongBarDepth - PostDepth, - LongBarWidth] ) 
    {
      difference()
      {
        // allows for interlocking of the center strut
        color( LongBarColour ) cube( [CartWidth - 2 * SideBarDepth, LongBarDepth, LongBarWidth], center = false ); 
        echo( str( "Rear Bar, Timber: ", LongBarWidth, "x", LongBarDepth, "mm, Length=", CartWidth - 2 * SideBarDepth ) ); 
        translate( [CartWidth / 2 - SideBarDepth * 3 / 2, -1, LongBarWidth - SideBarDepth + 1] ) cube( [SideBarDepth, LongBarDepth + 2, SideBarDepth + 1], center = false );
      }
    }

    // left strut
    translate( [0, - FrontExtLength, - SideBarWidth] ) 
    {
      color( SideBarColour ) cube( [SideBarDepth, SideBarLength, SideBarWidth], center = false );  
      echo( str( "Left Strut, Timber: ", SideBarWidth, "x", SideBarDepth, "mm, Length=", SideBarLength ) ); 
    }
    
    // center strut
    translate( [( CartWidth - SideBarDepth ) / 2, LongBarDepth, - SideBarWidth] )
    {
      difference()
      {
        // allows for interlocking of the rear bar
        color( SideBarColour ) cube( [SideBarDepth, OsbTopLength - LongBarDepth - SideBarDepth * 2, SideBarWidth], center = false ); 
        echo( str( "Centre Strut, Timber: ", SideBarWidth, "x", SideBarDepth, "mm, Length=", OsbTopLength - LongBarDepth - SideBarDepth * 2 ) ); 
        translate( [0, FrontToRearPostLength - LongBarDepth - SideBarDepth * 2 - 1, 0] ) cube( [SideBarDepth + 2, LongBarDepth + 2, SideBarWidth - SideBarDepth], center = false );
      }
    }
    
    // right strut
    translate( [CartWidth - SideBarDepth, - FrontExtLength, - SideBarWidth] )
    {
      color( SideBarColour ) cube( [SideBarDepth, SideBarLength, SideBarWidth], center = false ); 
      echo( str( "Right Strut, Timber: ", SideBarWidth, "x", SideBarDepth, "mm, Length=", SideBarLength ) ); 
    }

    // rear strut
    translate( [SideBarDepth, OsbTopLength - SideBarDepth - LongBarDepth, - SideBarWidth] )
    {
      color( SideBarColour ) cube( [CartWidth - 2 * SideBarDepth, SideBarDepth, SideBarWidth], center = false );  
      echo( str( "Rear Strut, Timber: ", SideBarWidth, "x", SideBarDepth, "mm, Length=", CartWidth - 2 * SideBarDepth ) ); 
      TextWrite( Lines = ["Just Married :-)"], Height = 45, Translate = [CartWidth / 2, SideBarDepth, - SideBarWidth / 2], Rotate = [90, 0, 180], Colour = "DarkSlateBlue");
    }
    
    // front head rest
    translate( [0, - FrontExtLength - LongBarDepth, - LongBarWidth ] )
    {
      color( LongBarColour ) cube( [CartWidth, LongBarDepth, LongBarWidth], center = false ); 
      echo( str( "Front Head Rest, Timber: ", LongBarWidth, "x", LongBarDepth, "mm, Length=", CartWidth ) ); 
      TextWrite( Lines = ["Death to all", "weedz"], Height = 20, Translate = [CartWidth / 2, -12, LongBarWidth / 2], Rotate = [90, 0, 0], Colour = "Red");
      TextWrite( Lines = ["Reggie's", "crazy", "idea"], Height = 18, Translate = [CartWidth - 60, -18, LongBarWidth / 2], Rotate = [90, 0, 0], Colour = "Red");
      
      // front head rest foam covering
      FoamHeadRest( "Right" );
      FoamHeadRest( "Left" );

    }

    
    // The top OSB boards
    translate( [(WithOSBSides ? - OsbThickness : 0), - PostDepth, 0] )
    {
      color( OSBTopRightColour ) cube( [OsbTopWidth, OsbTopLength, OsbThickness], center = false );
      echo( str( "Top Right OSB: ", OsbTopLength, "x", OsbTopWidth, "x", OsbThickness, "mm" ) ); 
    }

    translate( [CartWidth / 2, - PostDepth, 0] )
    {
      color( OSBTopLeftColour ) cube( [OsbTopWidth, OsbTopLength, OsbThickness], center = false );
      echo( str( "Top Left OSB: ", OsbTopLength, "x", OsbTopWidth, "x", OsbThickness, "mm" ) ); 
    }

    TextWrite( Lines = ["No hanky-panky!", "By Order of", "the Management.", "Sept 1984"], Height = 35, Translate = [CartWidth / 2, OsbTopLength / 2, OsbThickness], Rotate = [0, 0, 90], Colour = "Red");
    
    // The foam topping for two weeders
    if (ShowFoam)
    {
      echo( str( "Foam Topping: ", FoamToppingSize[0], "x", FoamToppingSize[1], "x", FoamToppingSize[2], "mm" ) ); 
      translate( [FoamToppingRightXOffset, - PostDepth - (FoamToppingLength - OsbTopLength) / 2, OsbThickness])
      {
        color( FoamToppingColour ) cube( [FoamToppingWidth, FoamToppingLength, FoamToppingDepth], center = false );
      }

      translate( [FoamToppingLeftXOffset, - PostDepth - (FoamToppingLength - OsbTopLength) / 2, OsbThickness])
      {
        color( FoamToppingColour ) cube( [FoamToppingWidth, FoamToppingLength, FoamToppingDepth], center = false );
      }   
    }
    
    if (WithOSBSides)
    {
      // The right side OSB board
      translate( [- OsbThickness, - FrontExtLength - SideBarDepth, - OsbSideWidth] )
      {
        color( OSBSideColour ) cube( [OsbThickness, OsbSideLength, OsbSideWidth], center = false );
        echo( str( "Right Side OSB: ", OsbSideLength, "x", OsbSideWidth, "x", OsbThickness, "mm" ) ); 
        TextWrite( Lines = ["Paul's secret", "store of Booze"], Height = 60, Translate = [0, OsbSideLength / 2, 80], Rotate = [90, 0, -90], Colour = "DarkSlateBlue");
      }
      // The left side OSB board
      translate( [CartWidth, - FrontExtLength - SideBarDepth, - OsbSideWidth] )
      {
        color( OSBSideColour ) cube( [OsbThickness, OsbSideLength, OsbSideWidth], center = false );
        echo( str( "Left Side OSB: ", OsbSideLength, "x", OsbSideWidth, "x", OsbThickness, "mm" ) ); 
        TextWrite( Lines = ["Helen", "woz", "ere"], Height = 40, Translate = [OsbThickness, OsbSideLength / 2, 120], Rotate = [0, 90, 0], Colour = "Maroon");
        TextWrite( Lines = ["Ben", "did", "this"], Height = 20, Translate = [OsbThickness, OsbSideLength - 60, 40], Rotate = [0, 90, 0], Colour = "RoyalBlue");
      }
    }
  }
}
 
