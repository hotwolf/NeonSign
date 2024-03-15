//###############################################################################
//# Neon Sign                                                                   #
//###############################################################################
//#    Copyright 2023 Dirk Heisswolf                                            #
//#    This file is part of the DIY Laser Bed project.                          #
//#                                                                             #
//#    This project is free software: you can redistribute it and/or modify     #
//#    it under the terms of the GNU General Public License as published by     #
//#    the Free Software Foundation, either version 3 of the License, or        #
//#    (at your option) any later version.                                      #
//#                                                                             #
//#    This project is distributed in the hope that it will be useful,          #
//#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
//#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
//#    GNU General Public License for more details.                             #
//#                                                                             #
//#    You should have received a copy of the GNU General Public License        #
//#    along with this project.  If not, see <http://www.gnu.org/licenses/>.    #
//#                                                                             #
//#    This project makes use of the NopSCADlib library                         #
//#    (see https://github.com/nophead/NopSCADlib).                             #
//#                                                                             #
//###############################################################################
//# Description:                                                                #
//#   Air nozzle for a K40 laser cutter clone.                                  #
//#                                                                             #
//###############################################################################
//# Version History:                                                            #
//#   April 30, 2023                                                            #
//#      - Initial release                                                      #
//#                                                                             #
//###############################################################################
$pp1_colour = "Orange";
include <../lib/NopSCADlib/lib.scad>
use <../lib/NopSCADlib/utils/annotation.scad>

//Parameters
bezierSteps = 20;

// Bezier curves
N_beziers     = [[[   79.0139,  687.6078,  0.0000], [   79.0139,  687.6078,  0.0000], [   72.4463,  471.6962,  0.0000], [   65.0993,  363.9745,  0.0000]],  // Bezier  1 ->  2
                 [[   65.0993,  363.9745,  0.0000], [   65.0993,  363.9745,  0.0000], [   62.1539,  320.7883,  1.0000], [   60.4134,  295.2689,  1.0000]],  // Bezier  2 ->  3
                 [[   60.4134,  295.2689,  1.0000], [   58.6729,  269.7495,  1.0000], [   54.6563,  210.8580,  0.0000], [   54.6563,  210.8580,  0.0000]],  // Bezier  3 ->  4
                 [[   54.6563,  210.8580,  0.0000], [   53.4723,  193.4981,  0.0000], [   52.9278,  245.7449,  0.0000], [   54.6563,  263.0516,  0.0000]],  // Bezier  4 ->  5
                 [[   54.6563,  263.0516,  0.0000], [   55.4045,  270.5343,  0.0000], [   57.3750,  281.5007, -1.0000], [   60.4088,  295.0124, -1.0000]],  // Bezier  5 ->  6
                 [[   60.4088,  295.0124, -1.0000], [   71.9617,  346.4667, -1.0000], [   98.9338,  434.8340,  0.0000], [  132.5416,  508.3027,  0.0000]],  // Bezier  6 ->  7
                 [[  132.5416,  508.3027,  0.0000], [  174.9745,  601.0638,  0.0000], [  227.9855,  670.0743,  0.0000], [  273.8953,  611.0495,  0.0000]],  // Bezier  7 ->  8
                 [[  273.8953,  611.0495,  0.0000], [  331.9226,  536.4359,  0.0000], [  162.5365,  113.9826,  0.0000], [  162.5365,  193.4577,  0.0000]]]; // Bezier  8 ->  9
//color("brown")   translate([  273.8953,  611.0495,  0.0000]) sphere(d=10);
//color("red")     translate([  331.9226,  536.4359,  0.0000]) sphere(d=10);
//color("green")   translate([  162.5365,  113.9826,  0.0000]) sphere(d=10);
//color("purple")  translate([  162.5365,  193.4577,  0.0000]) sphere(d=5);

ina_beziers   = [[[  807.8877,  340.3804,  0.0000], [  729.2238,  553.0560,  0.0000], [  692.0231,  437.2424, -1.0000], [  684.4954,  409.8857, -1.0000]],  // Bezier  1 ->  2
                 [[  684.4954,  409.8857, -1.0000], [  681.9188,  400.5163, -1.0000], [  677.1956,  381.6157, -1.0000], [  672.6176,  350.2761,  0.0000]],  // Bezier  2 ->  3
                 [[  672.6176,  350.2761,  0.0000], [  670.3201,  334.5756,  1.0000], [  682.0307,  380.8058,  0.5000], [  683.6080,  396.5928,  0.5000]],  // Bezier  3 ->  4
                 [[  683.6080,  396.5928,  0.5000], [  683.7846,  398.3479,  0.5000], [  684.1792,  403.1165,  1.0000], [  684.5206,  409.6711,  1.0000]],  // Bezier  4 ->  5
                 [[  684.5206,  409.6711,  1.0000], [  686.1168,  440.2894,  1.0000], [  686.5628,  509.8795,  0.0000], [  658.2782,  493.3169,  0.0000]],  // Bezier  5 ->  6
                 [[  658.2782,  493.3169,  0.0000], [  649.7921,  488.3483,  0.0000], [  641.7038,  471.8777,  1.0000], [  636.0551,  451.4679,  1.0000]],  // Bezier  6 ->  7
                 [[  636.0551,  451.4679,  1.0000], [  623.8464,  407.3547,  1.0000], [  623.0348,  344.8392,  0.0000], [  654.2378,  340.2796,  0.0000]],  // Bezier  7 ->  8
                 [[  654.2378,  340.2796,  0.0000], [  689.3129,  335.1553,  0.0000], [  668.1833,  399.0860, -1.0000], [  635.9241,  451.6815, -1.0000]],  // Bezier  8 ->  9
                 [[  635.9241,  451.6815, -1.0000], [  610.7567,  492.7147, -1.0000], [  578.8151,  526.8487,  0.0000], [  561.5037,  515.9099,  0.0000]],  // Bezier  9 -> 10
                 [[  561.5037,  515.9099,  0.0000], [  529.2887,  495.5496,  0.0000], [  570.6648,  390.9823,  0.0000], [  520.0413,  376.7942,  0.0000]],  // Bezier 10 -> 11
                 [[  520.0413,  376.7942,  0.0000], [  476.4974,  364.5939,  0.0000], [  459.0251,  489.1397,  0.0000], [  458.3481,  514.0733,  0.0000]],  // Bezier 11 -> 12
                 [[  458.3481,  514.0733,  0.0000], [  458.1175,  522.5502,  1.0000], [  457.8367,  539.5183,  0.0000], [  457.8367,  539.5183,  0.0000]],  // Bezier 12 -> 13
                 [[  457.8367,  539.5183,  0.0000], [  457.8367,  539.5183,  0.0000], [  448.4236,  487.3248, -1.0000], [  443.5838,  461.2604,  0.0000]],  // Bezier 13 -> 14
                 [[  443.5838,  461.2604,  0.0000], [  442.4747,  455.2610,  0.0000], [  438.9888,  415.7431, -1.0000], [  432.3917,  413.5609,  0.0000]],  // Bezier 14 -> 15
                 [[  432.3917,  413.5609,  0.0000], [  431.2034,  413.1720,  1.0000], [  426.7237,  457.4937,  0.0000], [  426.4212,  459.5391,  0.0000]],  // Bezier 15 -> 16
                 [[  426.4212,  459.5391,  0.0000], [  422.4097,  486.7558,  0.0000], [  414.6314,  543.3787,  0.0000], [  384.1233,  555.9247,  0.0000]],  // Bezier 16 -> 17
                 [[  384.1233,  555.9247,  0.0000], [  359.0313,  566.2381,  0.0000], [  353.7809,  455.8948,  0.0000], [  350.4247,  441.0441,  0.0000]],  // Bezier 17 -> 18
                 [[  350.4247,  441.0441,  0.0000], [  349.0924,  435.1312,  0.0000], [  346.4276,  423.3053,  0.0000], [  346.4276,  423.3053,  0.0000]],  // Bezier 18 -> 19
                 [[  346.4276,  423.3053,  0.0000], [  346.4276,  423.3053,  0.0000], [  337.2449,  365.4365,  0.0000], [  337.2449,  365.4365,  0.0000]]]; // Bezier 19 -> 20

heart_beziers = [[[  878.1800,  345.5915,  0.0000], [  878.1800,  345.5915,  0.0000], [  776.8841,  180.0939,  0.0000], [  776.8841,  180.0939,  0.0000]],  // Bezier  1 ->  2
                 [[  776.8841,  180.0939,  0.0000], [  765.8082,  161.9980,  0.0000], [  760.4219,  141.5105,  0.0000], [  764.3161,  120.6689,  0.0000]],  // Bezier  2 ->  3
                 [[  764.3161,  120.6689,  0.0000], [  768.2104,   99.8274,  0.0000], [  779.9163,   81.7692,  0.0000], [  797.4049,   69.8528,  0.0000]],  // Bezier  3 ->  4
                 [[  797.4049,   69.8528,  0.0000], [  814.8182,   57.9224,  0.0000], [  835.8990,   53.4517,  0.0000], [  856.6653,   57.3319,  0.0000]],  // Bezier  4 ->  5
                 [[  856.6653,   57.3319,  0.0000], [  877.5069,   61.2261,  0.0000], [  895.6263,   73.0214,  0.0000], [  907.6179,   90.5240,  0.0000]],  // Bezier  5 ->  6
                 [[  907.6179,   90.5240,  0.0000], [  907.6179,   90.5240,  0.0000], [  921.4449,  110.7056,  0.0000], [  921.4449,  110.7056,  0.0000]],  // Bezier  6 ->  7
                 [[  921.4449,  110.7056,  0.0000], [  924.6875,  115.4384,  0.0000], [  931.0829,  116.6334,  0.0000], [  935.8158,  113.3908,  0.0000]],  // Bezier  7 ->  8
                 [[  935.8158,  113.3908,  0.0000], [  935.8158,  113.3908,  0.0000], [  955.8188,   99.6861,  0.0000], [  955.8188,   99.6861,  0.0000]],  // Bezier  8 ->  9
                 [[  955.8188,   99.6861,  0.0000], [  973.3214,   87.6945,  0.0000], [  994.4774,   83.2379,  0.0000], [ 1015.2437,   87.1181,  0.0000]],  // Bezier  9 -> 10
                 [[ 1015.2437,   87.1181,  0.0000], [ 1036.0101,   90.9983,  0.0000], [ 1054.0542,  102.7795,  0.0000], [ 1066.0599,  120.2068,  0.0000]],  // Bezier 10 -> 12
                 [[ 1066.0599,  120.2068,  0.0000], [ 1078.0515,  137.7094,  0.0000], [ 1082.4469,  158.7762,  0.0000], [ 1078.5527,  179.6178,  0.0000]],  // Bezier 11 -> 12
                 [[ 1078.5527,  179.6178,  0.0000], [ 1074.7336,  200.4734,  0.0000], [ 1062.9524,  218.5175,  0.0000], [ 1045.4498,  230.5091,  0.0000]],  // Bezier 12 -> 13
                 [[ 1045.4498,  230.5091,  0.0000], [ 1045.4498,  230.5091,  0.0000], [  878.1800,  345.5915,  0.0000], [  878.1800,  345.5915,  0.0000]],  // Bezier 13 -> 14
                 [[  878.1800,  345.5915,  0.0000], [  878.1800,  345.5915,  0.0000], [  878.1800,  345.5915,  0.0000], [  878.1800,  345.5915,  0.0000]]]; // Bezier 14 -> 15

module showNodes (beziers) {
    translate([0,0,-40]) translate(beziers[0][0]) label("1");
    translate([0,0,-40]) translate(beziers[0][3]) label("0");
    for (i=[0:len(beziers)-1]) {
        translate([0,0,20]) translate(beziers[i][0]) label(str(i+1), scale=2, valign="center", halign="center");
        echo(str(i));
    }
    
    for (bezier = beziers) {
        //Start node
        color("red") translate(bezier[0]) sphere(d=10);
        //End node
        color("red") translate(bezier[3]) sphere(d=10);
//        color("black") hull() {
//            translate(bezier[0]) sphere(d=2);
//            translate(bezier[3]) sphere(d=2);
//        }
//        //Start handle
//        color("green") translate(bezier[1]) sphere(d=10);
//        color("blue") hull() {
//            translate(bezier[0]) sphere(d=4);
//            translate(bezier[1]) sphere(d=4);
//        }
//        //End handle
//        color("green") translate(bezier[2]) sphere(d=10);
//        color("blue") hull() {
//            translate(bezier[2]) sphere(d=4);
//            translate(bezier[3]) sphere(d=4);
//        }
//        color("blue") hull() {
//            translate(bezier[1]) sphere(d=4);
//            translate(bezier[2]) sphere(d=4);
//        }
    }
}
*showNodes(N_beziers);
*showNodes(ina_beziers);
*showNodes(heart_beziers);

module drawPath (path) {
    for (idx = [1:len(path)-1]) {
        newPos = path[idx];
        oldPos = path[idx-1];
       if ($children > 0) {
            hull() {
                translate(oldPos) children(0);
                translate(newPos) children(0);
            }
        }
    }
}

module drawBeziers (beziers, steps=2) {
    for (bezier = beziers) {
        path = bezier_path(bezier, steps);
        drawPath(path) {
            children();
        }
        *show_path(path);
    }
}
function wireLength(beziers, i=0, length=0) =
    i >= len(beziers)-1 ? length : wireLength(beziers, i+1, length + bezier_length(v=beziers[i]));
echo("wire length = ", wireLength(N_beziers)+wireLength(ina_beziers));
 
module slotProfile () {
    union() {
        sphere(d=2.2);
        translate([0,0,-10]) cylinder(h=10, d=1.8);
    } 
}
*slotProfile ();

module guideProfile() {
     union() {
        translate([0,0,-1]) cylinder(h=2, d1=4, d2=6);
        translate([0,0,1]) cylinder(h=10, d=6);
    } 
}
*guideProfile();

module inverterMount() {
    difference() {
        union() {
            hull() {
                translate([ 8, 8,-3]) cylinder(h=3, r=8);
                translate([83, 8,-3]) cylinder(h=3, r=8);
                translate([ 8,25,-3]) cylinder(h=3, r=8);
                translate([83,25,-3]) cylinder(h=3, r=8);                          
            }
            translate([25,16.5,-5.4]) cylinder(h=2.6, d=4.8);
            translate([32,16.5,-4.2]) cylinder(h=1.4, d=1.4);
        }
        union() {
            translate([25,16.5,-10]) cylinder(h=20, d=2.6);
            translate([25,16.5,-1.4]) cylinder(h=1.5, d1=2, d2=5); 
        }       
   }
} 
*inverterMount();

module inverterMountProfile() {
    translate([ 4,27,-3]) cylinder(h=3, r=4);
    translate([87,27,-3]) cylinder(h=3, r=4);                          
}

module sign() {
    //Letters
    difference() {
        //Positive
        union() {
            //N
            drawBeziers(N_beziers, steps=bezierSteps) {
                guideProfile();
            }
            //ina
            drawBeziers(ina_beziers, steps=bezierSteps) {
                guideProfile();
            }
            //Heart
            drawBeziers(heart_beziers, steps=bezierSteps) {
                guideProfile();
            }
            //Base
            translate([0,0,1]) hull() {
                translate(bezier(0,   N_beziers[0]))     cylinder(h=10, d=6);
                translate(bezier(0.3, N_beziers[0]))     cylinder(h=10, d=6);
                translate(bezier(0,   heart_beziers[0])) cylinder(h=10, d=6);
                translate(bezier(0.3, heart_beziers[0])) cylinder(h=10, d=6);
            }
            //Inverter
            translate([580,560,8]) rotate([0,0,158]) inverterMount();
            hull() {
              translate([580,560,8]) rotate([0,0,158]) inverterMountProfile();
              translate([580,500,8]) rotate([0,0,158]) inverterMountProfile();
            }            
        }
        //Negative
        union() {
            //N
            drawBeziers(N_beziers, steps=bezierSteps) {
                slotProfile();
            }
            //ina
            drawBeziers(ina_beziers, steps=bezierSteps) {
                slotProfile();
            }
            //Heart
            drawBeziers(heart_beziers, steps=bezierSteps) {
                slotProfile();
            }
            //Backside
            translate([0,0,8]) cube([1200,800,100]);
            //Wire guides
            translate([   79.0139,  687.6078, -20.0000]) cylinder(h=40, d=3);
            translate([  807.8877,  340.3804, -20.0000]) cylinder(h=40, d=3);
            translate([  878.1800,  345.5915, -20.0000]) cylinder(h=40, d=3);
            translate([  572.5000,  460.0000, 7.0000]) sphere(d=8);
            translate([  572.5000,  460.0000, 7.0000]) cylinder(h=20, d=8);            
            hull() {
                translate([  807.8877,  340.3804, 7.0000]) sphere(d=4);
                translate([  807.8877,  340.3804, 7.0000]) cylinder(h=20, d=4);
                translate([  878.1800,  345.5915, 7.0000]) sphere(d=4);
                translate([  878.1800,  345.5915, 7.0000]) cylinder(h=20, d=4);
             }   
             hull() {
                translate([  807.8877,  340.3804, 7.0000]) sphere(d=4);
                translate([  807.8877,  340.3804, 7.0000]) cylinder(h=20, d=4);
                translate([  572.5000,  460.0000, 7.0000]) sphere(d=4);
                translate([  572.5000,  460.0000, 7.0000]) cylinder(h=20, d=4);
             }   
             hull() {
               translate([  572.5000,  460.0000, 7.0000]) sphere(d=4);
               translate([  572.5000,  460.0000, 7.0000]) cylinder(h=20, d=4);
               translate([   79.0139,  687.6078, 7.0000]) sphere(d=4);
               translate([   79.0139,  687.6078, 7.0000]) cylinder(h=20, d=4);
             }   
              hull() {
               translate([  572.500,  460.0000, 7.0000]) sphere(d=4);
               translate([  572.500,  460.0000, 7.0000]) cylinder(h=20, d=4);
               translate([  572.500,  520.0000, 7.0000]) sphere(d=4);
               translate([  572.500,  520.0000, 7.0000]) cylinder(h=20, d=4);
             }   
            //Mounting holes
            translate([  850.000,  320.0000, -20.0000]) cylinder(h=40, d=8);
            translate([  90.000,  640.0000, -20.0000]) cylinder(h=40, d=8);
        }
    }            
}   
*translate([200,-200,0]) rotate([0,0,22]) sign();  
        
module tileShape(x=0, y=0) {    
tileBottomPoints = [
  [   0,   0,  0 ],  //0
  [ 180,   0,  0 ],  //1
  [ 180, 180,  0 ],  //2
  [   0, 180,  0 ],  //3
  [  20,  20, 20 ],  //4
  [ 200,  20, 20 ],  //5
  [ 200, 200, 20 ],  //6
  [  20, 200, 20 ]]; //7
  
tileBottomFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
  
    
  translate([-110+180*x,180*y,0]) 
  union() {  
    translate([0,0,4])                         polyhedron(tileBottomPoints, tileBottomFaces);
    translate([200,200,-16]) rotate([0,0,180]) polyhedron(tileBottomPoints, tileBottomFaces);
  }
}
//%for (x=[0:6])
//for (y=[0:2])
//tileShape(x,y);


module tile(x=0, y=0) {    

    intersection() {
        tileShape(x,y);
        translate([200,-200,0]) rotate([0,0,22]) sign();  
    }
}
    
tile(1,2);
