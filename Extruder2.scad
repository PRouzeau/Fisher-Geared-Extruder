/*Equipment design and all documents:  Copyright August 2015 Pierre ROUZEAU .   
Equipment  license : OHL V1.2     Documents licence : CC BY-SA

GEARED EXTRUDER for the  RepRapPro printer Fisher Delta 
Use the specific M3 hobbed insert of RepRapPro (for Ormerod and other printers) but not the original hobbed insert of the Fisher.
Spring is the one of the Fisher extruder: external diameter 6.5mm, wire 0.8mm, length 7.5 mm
This extruder is specifically designed to fit in the tight space of the fisher (in the fisher the extruder is inside the printer, between the arms), but could be used for any printer with 'Bowden' hotend
A template to position the extruder is supplied. Be careful, the play between arms and motor with all carriages at top is less than 2mm (but your carriage are not supposed to go banging the supports, no ?)
The connection of the bowden is done with the specific RepRapPro 5mm brass insert. If needed, you could thread for another connection.

This is mechanics, so your machine shall be well calibrated ans shall produce accurate dimensions. Gears (especially the pinion, shall be printed relatively slowly (50mm/sec) to produce more accurate teeth profile). Layer 0.2 for the gears. layers 0.2 or 0.25 for base and lever.
Printed in PETG on the Fisher, I really don't recommend to print it in PLA, that may be delicate to assemble without broke anything and there will be problem with the stepper temperature. ABS may be usable (but cannot be printed on a standard Fisher).
Recommended PETG yet: Reprapper. eSun PETG is NOT recommended (unworkable without this geared extruder due to poor winding, so egg and chicken problem here).
Do NOT Forget to activate support in your slicer for the base part. I forget it once for the prototype, then again for the final version (...).
It is an entirely original design, however the gears of the Ormerod extruder were reused (and slightly enlarged) and I get the idea to have the filament in the pressure lever from Ryan Carlyle extruder.
Driven by default  RepRapPro stepper 2.2 kg.cm
Assembly described here :
rouzeau.net/Print3D/FisherExtruder
BOM 
- 1 M3x30 Hex head screw for the hobbed drive
- 3 M3x35 countersunk screws for the stepper assembly on panel (thk 3mm)
- 2 M3x20 countersunk screws for lever articulation and push bearing
- 2 M3x40 screws (hex or cap head) for tensioner
- 1 M3x10 set screw for the pinion
- ordinary M3 nuts (lock is done with glue/resin)
- 1 medium size washer (large gear)
- 6 small sizes washer (4 for large gear and 2 for bearing)
- 3 bearings 623 (10x3x5)
- nut locking glue
- 1 M3 RepRapPro hobbed insert (dia 8) (only sold by them)
- 1 spring diam ext 6.5mm, wire 0.8mm, len 7.5 mm (salvaged from Fisher extruder)
Printed parts (see program below):
- Base : N°2
- Lever : N°3
- Large gear : N°4
- pinion : N°5
- Lever pushing pad : N°6
- template/screw holder for panel fixation : N°7
- tongue for Bowden brass end (original could be reused)
*/

include <PRZutility.scad>
//-- Parameters modifiable by user ------------------------
insertdia = 5.1; // bowden brass insert diam 5
inletTube = 3.8;  //inlet tube diameter  if =0 -> inlet is a cone
htot = 25;      // columns height - this is the minimum for shaft clearance

qpart=1;

if (qpart) {
  if (qpart==1) tsl (-25,-4,36+8) rot (-90) extruder(); // whole extruder
  else if (qpart==2) rot (0,-90) base(); // extruder chassis
  else if (qpart==3) rot (90) rot(-lvang-angflat) lever();  
  else if (qpart==4) rot (0,-90)  lgear2();  // gear wheel  
  else if (qpart==5) rot (0,-90)  sgear2(); // pinion  
  else if (qpart==6) rot (-tsang+90)  pushpad(); // spring pusher
  else if (qpart==7) motorlink();
}


//-- do not touch if you don't know ----------------------------------
diamBB = 9.9; // 623 bearing

springhole = 7; // spring 6.5 mm
boltspace = 10;
boltheaddia = 0; // 5.4 for inserted head (~tiny walls);
thk=16;

hobby = -12.48; // big wheel articulation
hobbz = 5;

levery = -12; // lever articulation
leverz = -9.5;

pushy = hobby-8; // push bearing
pushz = hobbz-5.6;

lvposy = 5.5; // lever position
lvposz = -15; 

nutalign =23.5;

lvang=35;
angflat = -15;
tsang = lvang-6;


holeplay = 0.15; // diameter increase for all cylinders (internals/external) and off-axis dimension increase for cuben primitives. Not sufficient for small vertical holes.
   //Beware that this increase is the same whatever the axis, so for vertical cylinder holes, you may add other clearance

// misc. parameters
diamNut3 = 6.1; // checked
diamNut4 = 8.1; // checked

//distaxe = sqrt ((hobby-31/2)*(hobby-31/2)+(hobbz-31/2)*(hobbz-31/2)) ;
// echo (distaxe=distaxe); // check axis/axis distance conformity with Ormerod gears

*breaktest();
*pan();

module motorlink() {
   //motor bolts link
  h=3;
  difference () {
    union() {
      rotz(-2) {
        hull() duplx (31) cylz (9,h);
        hull() duply (31) cylz (9,h);
      }  
      rotz(45) cubez (8,8,h, 4);
      hull() { 
        cylz (9,1.2, 31);
        cylz (9,1.2, 31+33,4);
      }  
      hull() 
        duply (31) cylz (9,1.2, 31+33,4);
      hull() {
        cylz (9,1.2, 31+33,4);
        cubez (2,4,1.2, 31+33+11, -18);
      }
      hull() {
        cylz (9,1.2, 31+33,4+31);
        cubez (2,4,1.2, 31+33+11, 31+22);
      }
      // cubez (12,30,1,  31+33+6); check
   }  
   tsl (0,0,1)
     rotz(-2) 
     duplx (31) duply(31) { 
       cylz (-3,66);
       cylinder(d2=6.1, d1=3, h=1.2); 
       cylz (6, 5, 0,0,1.19);}
   duply (31) cylz (-3,66, 31+33,4);     
  }
}

module pan() {   // not used - was for panel placement
  tsl (0,-20, 26) // side panel
    rot (90,-90,90)
      linear_extrude(height = 3, center = false)
        import("panelex.dxf");
  color ("red") cubez (200,200,6);    
  color ("red") cubez (60,10,76,  -30, -47);
  tsl (-60,-44, 85)
  rot (-26)
  color ("red") cubex (60,10,172);
}
 

module extruder() {
/*  import ("ormerod_extruder-drive-block.stl"); // ormerod extruder imported for gear geometry check
  color ("red") cylz (-8.9, 66, 24.72,71.12);
  color ("red") cylz (-5.8, 66, 50.27,55.62);
*/ 
  dist2 = sqrt(pow(50.27-24.72,2) +pow(71.12-55.62,2));
  //echo (dist2 = dist2); // distance between axis

  tsl (17.5,hobby,hobbz) rot (-22) // -22 -> motor bolt -88:lever bolt
    color("green") lgear2();
  tsl (11.5,15.5,15.5) 
    sgear();
  
  base();
  tsl (0, levery, leverz) 
    rot (0) /// rotate the lever
      tsl (0, -levery, -leverz) {
        lever();
        color ("grey")
          cylx (-3,16, thk/2,pushy,pushz);    
        BBx ("623", 0, thk/2,pushy,pushz);
        color ("red")
        tsl (0,pushy, pushz) 
          rot (lvang) 
            cylz (-1.75,99, thk/2, lvposy,lvposz); 
      } 
  pushpad();    
  color ("grey")  { 
    cylx (-8,6, thk/2,hobby,hobbz);
    cylx (3,25, -2,hobby,hobbz);
    cylx (-3,20, thk/2,levery,leverz);
    rot (tsang) 
      tsl (thk/2)   
        dmirrorx(){ 
          cyly (3,40,     boltspace/2, -27, nutalign);  
          cyly (5.5,-3.5, boltspace/2, -27, nutalign);  
        }  
  }  
  tsl (thk/2)
    dmirrorx () 
      BBx ("623", 1, 4,hobby,hobbz);
  tsl (0, 31/2, 31/2)
    rot(0,90)
      nema17 (34);
}

module base() {
  thk2 = 5;
  difference () {
  union() {
    hull() {
      cylx  (9, thk);
      cylx  (9, thk, 0,-5);
      cylx  (8, thk2,  0,31);
    }
    hull() {
      cylx  (9, thk,0,-4);
      cylx  (3, thk-3.5,  0,5.5,4);
      cylx  (8, thk, 0,0,31);
      cylx  (9, thk, 0,levery,leverz);
      cylx  (12, thk, 0,hobby+2.5,hobbz+4);
    }
    hull () { // nuts retainer
      cylx  (3, thk,  0,-8.5,26.2);
      cylx  (3, thk,  0,-7.2,18.5);
      cylx  (3, thk,  0,-2,30);
    }
    cylx (8,htot,0,0,31);
    cylx (8,htot,0,31);
    //cylx (9,12,0,31,31);
    cylx (8,htot,0,31,31);
  } // then whats removed
    tsl (thk-1.7)
      rot (0,90) cylinder (d2=7, d1=2.5, h=1.8); 
    tsl (thk-1.7, levery, leverz)
      rot (0,90) cylinder (d2=7, d1=2.5, h=1.8); 
    cylx  (-35, 66, 0,hobby-20,hobbz-6, 50);
    hull() {
      cylx (-16,66,  0,6,12.5, 64);
      cylx (-3,66,  0,38,5.5);
      cylx (-3,66,  0,6.5,32);
    }
    duplz (31) duply (31) cylx (-3.2,66);
    
    cylx (-3, 66,   0,levery,leverz); 
    cylx (-diamBB, 66, 0,hobby,hobbz);
    hull()  
      duply (-20)
        tsl (0,pushy+0.5, pushz)
          rot (lvang+2) cylz (-8,99, thk/2, lvposy+1.5,lvposz); 
    rot (tsang) {
      cubex (66,2.7,5.3, -2,7.5,nutalign);  // nut space
      tsl (thk/2)   
        dmirrorx() 
          cyly (-3,66, boltspace/2, -5, nutalign);  
    }
  }
  difference () {
    hull() {
      duplz (31) duply (31) cylx (8,1.2);
    } 
    duplz (31) duply (31) cylx (-3.2,66);
    
    cylx (-22.5, 66, 0, 31/2,31/2, 50);
    rot (tsang) 
      cubex (66,2.7,5.5, -2,7.5,nutalign);  // nut space
  }
  tsl (thk-0.15,hobby,hobbz) // add bearing retainer
    rot (0,90)
    difference () {
      cylinder (d1=diamBB+4, d2=diamBB+2.5, h=1.5);
      tsl (0,0,-0.1)
        cylinder (d1=diamBB+0.3, d2=diamBB-1.5, h=2);
      rotz (3) cubez (20,10,10,  0, -7.9, -5);
    }   
}

module lever() {
leverw = 7.5;  
  difference() {
    union() {
     tsl (0,pushy, pushz)
      rot (lvang) {
        tsl (thk/2, lvposy, lvposz) {
          hull() {
            cylz (leverw,44.4,  0, 0,-5);
            rot (angflat) 
              cubez (leverw, 1.5, 44,  0,-13.1,-7);          
          }
          hull() { // bowden holder
            cylz (11,-13,  0, 0,-5);
            cylx (-9,11,  0, 3,-8); // tongue holder 
            cylx (-9,11,  0, -3,-8); // tongue holder 
            rot (angflat) 
              cubez (leverw, 1.5, -4,  0,-13.1,-7);          
          }
          hull() { // push wheel support
            rot (angflat) {
              cubez (leverw+8, 3, 12,  0,-12.35,7);          
              cubez (leverw-0.5, 3, 24,  0,-12.35,1.2);          
            }  
            cylx (-8, leverw+8, 0,-lvposy, -lvposz);
          }
        }
      }
     // cylx (9,leverw-0.1,  thk/2-leverw/2+0.05,levery,leverz);
    } // then whats removed
    cylx (-3,16, thk/2,pushy,pushz);
    cylx (boltheaddia,3,  thk/2+6,pushy,pushz);
    cylx (9.2,20,  -2,hobby,hobbz); // hobbed insert room
    cylx (10.5,20,  -2,hobby+5,hobbz-0.8); // install room
    cylx (-3,66,  thk/2-leverw/2,levery,leverz);
    
    tsl (thk/2,pushy, pushz) 
      rot (lvang) {
        cylz (-2.1,99, 0, lvposy,lvposz); // filament hole
        cylz (insertdia, -15, 0, lvposy,lvposz-5); // bowden insert hole
        //inletTube=false;  
        tsl (0,lvposy,lvposz+35) // filament inlet
          if (inletTube) 
            cylz (inletTube,7, 0,0,-2);
          else  
            tsl (0,0,0) 
              cylinder (h=5, d2=6, d1=2);
        cubez (11, 8.8, 2.7,  -1,lvposy,-23.5);  // tongue hole
      }  
    hull() {
      cylx (-10.5, 4.5, thk/2,pushy,pushz);
      cylx (-6.5, 5.5, thk/2,pushy,pushz);
      cylx (-10.5, 4.5, thk/2,pushy-10,pushz-2.5);
      cylx (-6.5, 5.5, thk/2,pushy-10,pushz-2.5);
    }
    rot (tsang) {// spring guide
      cyly (springhole,6.8, thk/2, -25,nutalign); 
      tsl (thk/2)   
        dmirrorx() 
          cyly (4,40,     boltspace/2, -25.5, nutalign);  
    }       
    tsl (14.7,pushy, pushz)
      rot (lvang) 
        rot (0,90)  cylinder (d1=2.8, d2=6.5, h=1.2);
  }
  rot (lvang+angflat) // support spring hole
    cubez (6,3, 0.8, 8,-22.6,19.8);
}

module pushpad() {
  rot (tsang) // spring guide
    tsl (thk/2) 
      difference() {
        hull() 
          dmirrorx()
            cyly (8.5,5, boltspace/2, -27,nutalign); 
        dmirrorx()
          cyly (-3,66, boltspace/2, -22,nutalign); 
        cyly (springhole,6, 0, -25,nutalign);  
        cubey (10,30,10, 5+8, -30,nutalign); 
      //  rot(-tsang) cubez (30,5,30, 0,-28.5,-5); 
      }  
}  

// -- Gears - STL from Ormerod extruder -----

module lgear() {
  tsl (0,-24.05,61.44) rot (0,90) import("ormerod_large-gear.stl");  
} 

module lgear2() {
  difference () {
    union() {
      scale ([1.33,1,1]) lgear();  
      cylx (12,22, 0.15,0,0, 50);
      intersection () {  
        union() {
        for(i=[0:13]) 
          rot(i*360/12)
              hull() {
                cylx (1, 23,  0.1, 0, 7);
                dmirrory() 
                  cylx (1, 23,  0.1, 2, 4);
              }
        hull() { // index
          cylx (1, 23,  0.1, -10, 0);
          dmirrorz() 
            cylx (1, 23,  0.1, -4.2, 2);
      }       
        }      
        rot (0,90)  cylinder (d1=3, d2=25, h=25);      
      }      
    } // then whats removed
    cylx (-2.95,66);
    hull() {
      tsl (9-0.6)  // hexagon chamfer
        rot (0,90) cylinder (d1=6, d2=7.3, h=2.6, $fn=6);
      cylx (8,1, 22);  
    }
    tsl (9-3)  // hexagon
      rot (0,90) cylinder (d=6, h=2.5, $fn=6);
    hull() { // enlarged hole for lever assembly and motor install.
      cylx (-6.3,33, 0,14.8);  
      cylx (-6.3,33, 0,13);  
    }  
  }    
}

module sgear() { // no longer used - prefer sgear2
  difference () {
    union() {
      scale ([1.1,1,1])
        tsl (3.7,-55.89,67.25)  rot (0,90) import("ormerod_small-gear.stl");   
      hull() {  
        cylx (11,12, -6);
        dmirrorz () 
          cylx (4, 8.3,  -6, 6.7, 3.3);
        dmirrorz () 
          cylx (4, 10.3,  -6, 6.2, 2.2);
      } 
      cylx (11,15, -9);
       tsl (4.5)
       rot (0,90)
       cylinder (d1=14.1, d2=10, h=1.5);
    }  
    cylx (-5, 66);
    cyly (3, 10,  -0.5, 0);
    hull() {
      cubey (14,2.5,5.3, -11+5.3,5-1.2);  // nut space
      cyly (0.5, 2.5, 2.7,5-1.2,0);
    }  
  }
  *tsl (-5,1.96,-2.5) // flat - no longer used (set screw)
    cube ([10, 2, 5]) ;
} 


module sgear2() {
  difference () {
    union() {
      cylx (7,20, 1); // because of STL hole chamfer make a groove
      tsl (10.2)
      scale ([1,1,1])
        tsl (3.7,-55.89,67.25)  rot (0,90) import("ormerod_small-gear.stl");   
      hull() {  
        cylx (12, 12);
        dmirrorz () 
          cylx (4, 8.3,  0, 7, 3.9);
        dmirrorz () 
          cylx (4, 10.3,  3, 6.2, 2.2);
      }
      hull() {  
        cylx (12,6, 7.5);
        cylx (17.1,1, 13.3,0,0, 40);
        dmirrorz () 
          cylx (4, 4,  7.5, 7, 3.9);
      }
    } // then whats removed  
    cylx (-5, 66);
    tsl (-0.1) // chamfer bottom
      rot (0,90) cylinder (d1=5.8, d2=5, h=0.6);
    tsl (21.5) // chamfer top
     rot (0,90) cylinder (d1=5, d2=5.8, h=0.6);
    cyly (3, 10,  9.5, 0);
    hull() {
      cubey (1,2.5,5.7, 1,5-1.2);  // nut space - tapered inlet
      cubey (14,2.5,5.4, -1+5.3,5-1.2);  // nut space
      // beware, that is enlarged by 'holeplay' parameter
      cyly (0.5,2.5,  2.7+10,5-1.2,0);
    }  
  }
  // cylx (12,22, 0,8);
}


//-- utility -------------------------------------------------

module BBx (type="623", orient=1, x,y,z) {
  tsl (x,y,z)
    rot (0,90)
      BB(type, orient);
}

module BB (type="623", orient=1) {
  module B(De,di,thk,Flthk=0,DFl=0, orient) {
    mz = (orient==0)?-thk/2:0; 
    mirr = (orient==-1)?true:false;
    DF = (DFl) ? DFl: De+1.5*Flthk;
    tsl (0,0,mz)
    mirrorz(mirr)
      color ("silver")
        tsl (0,0,-Flthk) 
          difference() {
            union() {
              cylz (De, thk);  
              if (Flthk)
                cylz (DF, Flthk);
            }  
            cylz (di, thk+0.2, 0,0,-0.1);  
          }
  } 
  if (type=="623")       B(10,3,4,0,0,   orient);
  else if (type=="F623") B(10,3,4,1,11.5,orient);  
  else if (type=="624")  B(13,4,5,0,0,  orient);
  else if (type=="F624") B(13,4,5,1,15, orient);  
  else if (type=="625")  B(16,5,5,0,0,  orient);
  else if (type=="F625") B(16,5,5,1,18, orient);
  else if (type=="603")  B(9 ,3,5,0,0,  orient);    
  else if (type=="604")  B(12,4,4,0,0,  orient);    
  else if (type=="605")  B(14,5,5,0,0,  orient);  
  else if (type=="606")  B(17,6,6,0,0,  orient); 
  else if (type=="607")  B(19,7,6,0,0,  orient);   
  else if (type=="608")  B(22,8,7,0,0,  orient);
  else if (type=="634")  B(16,4,5,0,0,  orient);  
  else if (type=="MR63")  B(6,3,2,0,0,  orient);        
  else if (type=="MR73")  B(7,3,3,0,0,  orient);      
  else if (type=="MR83")  B(8,3,2.5,0,0,orient);
  else if (type=="MR83b") B(8,3,3,0,0,  orient);    
  else if (type=="MR93")  B(9,3,4,0,0,  orient); 
  else if (type=="MR103") B(10,3,4,0,0,orient); // same as 623 
}


module breaktest(){ // part to be breaked to test layer adhesion
  mcube (22,22, 6, false);
  mcube (15,10, 4, false, -15, 12);
  mcube (15,10, 4, false, 22);
  mcube (4,10, 20, false);
  mcube (4,10, 20, false, 18,12);
  mcube (10,4, 20, false, 12  );
  mcube (10,4, 20, false, 0,18);
};


module nema17(lg=40) { // NEMA 17 stepper motor. - replace by STL ??
  color("grey")
    difference() {
      union() {
        intersection() {
          cubez(42.2, 42.2, lg,0,0,-lg);
          cylz(50.1,lg+1,0,0,-lg-0.5,60);
        }
        cylz(22,2,0,0,0,32);
        cylz(5,24,0,0,0,24);
      }
      for (a = [0:90:359]) 
        rotz(a) cylz(-3,10, 15.5,15.5);
    }
}
