// title      : tyre 
// author     : Reggie Thomson
// license    : MIT License
// revision   : 0.01
// date       : 20160829
// tags       : Tyre, tire 
// file       : tyre.scad

module Tyre (TyreDiameter, TyreWidth, CamberRadius, WheelDiameter, WheelRim, WheelInnerWidth, AxelDiameter, AxelMountDiameter, TyreColour, WheelColour)
{
  OverLap = 0.6; // suitable for round tyres - use a value like 0.8 for flatter tyres
  rotate ([0, 90, 0])
  {
    color (TyreColour) 
    {
      rotate_extrude (angle = 360, convexity = 12)
      {
        hull ()
        {
          translate ([TyreDiameter / 2 - CamberRadius, TyreWidth / 2 - CamberRadius, 0]) 
          {
            circle (r = CamberRadius);
          }
          translate ([TyreDiameter / 2 - CamberRadius, - TyreWidth / 2 + CamberRadius, 0])
          {
            circle (r = CamberRadius);
          }
          translate ([WheelDiameter/2 + CamberRadius * OverLap , TyreWidth / 2 - CamberRadius, 0]) 
          {
            circle (r = CamberRadius);
          }
          translate ([WheelDiameter / 2 + CamberRadius * OverLap , - TyreWidth / 2 + CamberRadius, 0]) 
          {
            circle (r = CamberRadius);
          }
        }
      }
    }
    color (WheelColour)
    {
      rotate_extrude (angle = 360, convexity = 12)
      {
        translate ([WheelDiameter / 2 - WheelRim, - TyreWidth / 2, 0]) 
        {
          square (size = [WheelRim, TyreWidth], center = false);
        }
        
        translate ([AxelMountDiameter / 2, - WheelInnerWidth / 2, 0]) 
        {
          square (size = [WheelDiameter / 2 - WheelRim - AxelMountDiameter / 2, WheelInnerWidth], center = false);
        }  
        
        translate ([AxelDiameter / 2, - TyreWidth / 2, 0]) 
        {
          square (size = [(AxelMountDiameter - AxelDiameter) / 2, TyreWidth], center = false);
        }
      }
    }
  }
}
      
// Tyre (406.4, 75, 30, 230, 20, 45, 12.5, 25, "DimGrey", "Red"); // http://www.ebay.co.uk/itm/321918354090?_trksid=p2055119.m1438.l2649&ssPageName=STRK%3AMEBIDX%3AIT
Tyre (TyreDiameter = 390, TyreWidth = 95, CamberRadius = 45, WheelDiameter = 220, WheelRim = 20, WheelInnerWidth = 45, AxelDiameter = 16, AxelMountDiameter = 36, TyreColour = "Yellow", WheelColour = "Red"); // https://www.amazon.co.uk/Wheelbarrow-Wheels-4-00-8-Breakdown-Replacement/dp/B00KIRDQD8/ref=pd_sim_sbs_86_4?ie=UTF8&psc=1&refRID=WG86P9DETDBC447QBP2Y

