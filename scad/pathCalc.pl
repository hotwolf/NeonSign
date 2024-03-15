#! /usr/bin/env perl
###############################################################################
#                              Path Calculator                                #
###############################################################################
#    Copyright 2024 Dirk Heisswolf                                            #
#    This file is part of the NeonSign project.                               #
#                                                                             #
#    This is free software: you can redistribute it and/or modify             #
#    it under the terms of the GNU General Public License as published by     #
#    the Free Software Foundation, either version 3 of the License, or        #
#    (at your option) any later version.                                      #
#                                                                             #
#    N1 is distributed in the hope that it will be useful,                    #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#    GNU General Public License for more details.                             #
#                                                                             #
#    You should have received a copy of the GNU General Public License        #
#    along with this code.  If not, see <http://www.gnu.org/licenses/>.       #
###############################################################################
# Description:                                                                #
#    Converts SVG path strings into usable OpenSCAD outputs                   #
#                                                                             #
###############################################################################
# Version History:                                                            #
#   March 11, 2024                                                            #
#      - Initial release                                                      #
###############################################################################

#################
# Perl settings #
#################
use 5.005;
#use warnings;
use File::Basename;
use FindBin qw($RealBin);
use Data::Dumper;

####################
# Scale and offset #
####################
$xScale  = 220/400;
$yScale  = 220/400;
$xOffset = -300;
$yOffset = -100;

###############
# SVG strings #
###############
$N_matrixRef     = [[5.7520431,0,0,5.7520431,642.17185,282.8834],[$xScale,0,0,$yScale,$xOffset,$yOffset]];
$ina_matrixRef   = [[5.7520431,0,0,5.7520431,642.17185,282.8834],[$xScale,0,0,$yScale,$xOffset,$yOffset]];
$heart_matrixRef = [[0.23782948,0.04443854,-0.04443854,0.23782948,223.78042,-174.07396],[5.7520431,0,0,5.7520431,642.17185,282.8834],[$xScale,0,0,$yScale,$xOffset,$yOffset]];
$heartMatrixStr = "1,0,0,1,0,0";
#$tMatrixStr = "1,0,0,1,0,0";

$N_pathStr =
"m 8.1613201,199.77785 c 0,0 -2.0759705,-68.24821 -4.3982847,-102.298295 0,0 -0.9310337,-13.650866 -1.4812035,-21.717375 -0.550147,-8.066508 -1.81976947,-26.681719 -1.81976947,-26.681719 -0.37426204,-5.487355 -0.54636794,11.027527 0,16.498036 0.23650903,2.365249 0.85936847,5.831635 1.81831247,10.102593 3.6518096,16.264372 12.1775171,44.19668 22.8006861,67.41962 13.412763,29.32118 30.169185,51.13492 44.680946,32.47759 C 88.104056,151.99342 34.562252,18.458815 34.562252,43.580357";
    
$ina_pathStr = 
"m 238.55339,90.021633 c -24.86511,67.225297 -36.624,30.617407 -39.00345,21.970137 -0.81446,-2.96161 -2.30743,-8.93596 -3.75449,-18.842181 -0.72623,-4.962842 2.97541,9.650221 3.47399,14.640381 0.0558,0.55477 0.18053,2.06209 0.28846,4.13396 0.50453,9.67825 0.64551,31.6752 -8.29505,26.43988 -2.68241,-1.57055 -5.23907,-6.77678 -7.02458,-13.2282 -3.85909,-13.94386 -4.11561,-33.704599 5.74745,-35.145849 11.08699,-1.619753 4.40805,18.588299 -5.78884,35.213389 -7.95525,12.97032 -18.05177,23.75984 -23.5238,20.30215 -10.18293,-6.43576 2.89577,-39.48875 -13.10598,-43.97352 -13.76394,-3.856443 -19.28681,35.51164 -19.5008,43.393 -0.0729,2.67948 -0.16164,8.04299 -0.16164,8.04299 0,0 -2.97543,-16.49803 -4.50526,-24.73681 -0.35058,-1.89635 -1.45243,-14.38769 -3.53773,-15.07747 -0.37563,-0.12294 -1.79163,13.88685 -1.88725,14.53338 -1.26802,8.60302 -3.72668,26.50112 -13.37007,30.46685 -7.931423,3.25999 -9.591038,-31.61877 -10.651903,-36.31298 -0.421136,-1.86904 -1.263453,-5.60711 -1.263453,-5.60711 L 89.786392,97.941691";

$heart_pathStr = 
#"M 352.02963,1051.59 182.22871,863.3586 c -18.56646,-20.5817 -30.4,-45.6 -30.4,-73.3 0,-27.7 10.7,-53.7 30.3,-73.2 19.5,-19.5 45.5,-30.3 73.1,-30.3 27.7,0 53.8,10.8 73.4,30.4 l 22.6,22.6 c 5.3,5.3 13.8,5.3 19.1,0 l 22.4,-22.4 c 19.6,-19.6 45.7,-30.4 73.3,-30.4 27.6,0 53.6,10.8 73.2,30.3 19.6,19.6 30.3,45.6 30.3,73.3 0.1,27.7 -10.7,53.7 -30.3,73.3 L 352.02963,1051.59";
"M352.02963,1051.59 L 352.02963,1051.59 182.22871,863.3586 c -18.56646,-20.5817 -30.4,-45.6 -30.4,-73.3 0,-27.7 10.7,-53.7 30.3,-73.2 19.5,-19.5 45.5,-30.3 73.1,-30.3 27.7,0 53.8,10.8 73.4,30.4 l 22.6,22.6 c 5.3,5.3 13.8,5.3 19.1,0 l 22.4,-22.4 c 19.6,-19.6 45.7,-30.4 73.3,-30.4 27.6,0 53.6,10.8 73.2,30.3 19.6,19.6 30.3,45.6 30.3,73.3 0.1,27.7 -10.7,53.7 -30.3,73.3 L 352.02963,1051.59 L 352.02963,1051.59";

####################
# Global variables #
####################
my @matrix   = split(/\s*,\s*/, $tMatrixStr);
my @path     = ();
my $pathName = "";
my @curPoint = (0,0);
my @beziers  = ();

################
# Convert Path #
################
$matrixRef = $N_matrixRef;
@path      = split(/\s+/, $N_pathStr);
$pathName  = "N_beziers    ";
@curPoint  = (0,0);
@beziers   = ();

parse();
printSCAD();

$matrixRef = $ina_matrixRef;
@path      = split(/\s+/, $ina_pathStr);
$pathName  = "ina_beziers  ";
@curPoint  = (0,0);
@beziers   = ();

parse();
printSCAD();

$matrixRef = $heart_matrixRef;
@path      = split(/\s+/, $heart_pathStr);
$pathName  = "heart_beziers";
@curPoint  = (0,0);
@beziers   = ();

parse();
printSCAD();

#########################
# Matrix transformation #
#########################
sub transform {
    my $matrixRef       = shift @_;
    my $pointRef        = shift @_;

    my $x = $pointRef->[0];
    my $y = $pointRef->[1];
    my $newX;
    my $newY;
    
    foreach $matrix (@$matrixRef) {    
	$newX = ($matrix->[0]*$x) + ($matrix->[2]*$y) + $matrix->[4];
	$newY = ($matrix->[1]*$x) + ($matrix->[3]*$y) + $matrix->[5];
	$x = $newX;
	$y = $newY;
    }
	
    #printf STDERR "transform matrix: \"%s\"\n", join(",", @$matrixRef);
    #printf STDERR "transform X:      \"%s\" -> \"%s\"\n", $pointRef->[0], $newX;
    #printf STDERR "transform Y:      \"%s\" -> \"%s\"\n", $pointRef->[1], $newY;
   
    return ($x, $y);
}

#my @out = transform([1,0,0,1,0,0],[12,34]);
#printf STDERR "transform: \"%s\", \"%s\"\n", $out[0], $out[1];

#####################
# Parse path string #
#####################
sub isPoint {
    if ($path[0] =~ /\s*-?\d+\.?\d*,-?\d+\.?\d*\s*/) {
	#printf STDERR "isPoint: TRUE \"%s\"\n", $path[0];
	return 1;
    } else {
	#printf STDERR "isPoint: FALSE \"%s\"\n", $path[0];
	return 0;
    }
}

sub pullPoint {
    my $word = shift(@path);
    #printf STDERR "pullPoint: \"%s\" -> \"%s\"\n", $word, $path[0];
    if ($word =~  /\s*(-?\d+\.?\d*),(-?\d+\.?\d*)\s*/) {
	return ($1,$2);
    } else {
	die "parse error!";
    }
}

sub parse_m {
    if ($path[0] =~ /\s*m\s*/) {
	#printf STDERR "parse_m: \"%s\"\n", $path[0];
	shift(@path);
	#printf STDERR "parse_m: -> \"%s\"\n", $path[0];
	while (isPoint()) {
	    my @point = pullPoint();
	    $curPoint[0] += $point[0]; 
	    $curPoint[1] += $point[1]; 
	}
	return 1;
    }
    return 0;
}

sub parse_M {
    if ($path[0] =~ /\s*M\s*/) {
	shift(@path);
	while (isPoint()) {
	    my @point = pullPoint();
	}
	return 1;
    }
    return 0;
}

 sub parse_l {
    if ($path[0] =~ /\s*l\s*/) {
	shift(@path);
	while (isPoint()) {
	    my @point = pullPoint();
	    $point[0] += $curPoint[0]; 
	    $point[1] += $curPoint[1]; 
	    push @beziers, [[transform($matrixRef,\@curPoint)],
			    [transform($matrixRef,\@curPoint)],
			    [transform($matrixRef,\@point)],
			    [transform($matrixRef,\@point)]];
	    $curPoint[0] = $point[0]; 
	    $curPoint[1] = $point[1]; 
	}
	return 1;
    }
    return 0;
}
   
 sub parse_L {
    if ($path[0] =~ /\s*L\s*/) {
	shift(@path);
	while (isPoint()) {
	    my @point = pullPoint();
	    push @beziers, [[transform($matrixRef,\@curPoint)],
			    [transform($matrixRef,\@curPoint)],
			    [transform($matrixRef,\@point)],
			    [transform($matrixRef,\@point)]];
	    $curPoint[0] = $point[0]; 
	    $curPoint[1] = $point[1]; 
	}
	return 1;
    }
    return 0;
}
   
sub parse_c {
    if ($path[0] =~ /\s*c\s*/) {
	shift(@path);
	while (isPoint()) {
	    my @ctrlStart = pullPoint();
	    my @ctrlEnd   = pullPoint();
	    my @end       = pullPoint();
	    $ctrlStart[0] += $curPoint[0]; 
	    $ctrlStart[1] += $curPoint[1]; 
	    $ctrlEnd[0]   += $curPoint[0]; 
	    $ctrlEnd[1]   += $curPoint[1]; 
	    $end[0]       += $curPoint[0]; 
	    $end[1]       += $curPoint[1]; 
	    push @beziers, [[transform($matrixRef,\@curPoint)],
			    [transform($matrixRef,\@ctrlStart)],
			    [transform($matrixRef,\@ctrlEnd)],
			    [transform($matrixRef,\@end)]];   

	    @tcurPoint = transform(\@matrix,\@curPoint);
	    #printf STDERR "parse_c: curPoint  (%s) (%f:%f)\n", join(";", @curPoint) , @tcurPoint[0], @tcurPoint[1];
	    #printf STDERR "parse_c: curPoint  (%s) (%s)\n", join(";", @curPoint)  ,join(";", @{@beziers[0]->[0]});
	    #printf STDERR "parse_c: ctrlStart (%s) (%s)\n", join(";", @ctrlStart) ,join(";", @{@beziers[0]->[1]});
	    #printf STDERR "parse_c: ctrlEnd   (%s) (%s)\n", join(";", @ctrlEnd)   ,join(";", @{@beziers[0]->[2]});
	    #printf STDERR "parse_c: end       (%s) (%s)\n", join(";", @end)       ,join(";", @{@beziers[0]->[3]});

	    $curPoint[0] = $end[0]; 
	    $curPoint[1] = $end[1];
	    
	    
	    
	}
	return 1;
    }
    return 0;
}
   
sub parse_C {
    if ($path[0] =~ /\s*C\s*/) {
	shift(@path);
	while (isPoint()) {
	    my @ctrlStart = pullPoint();
	    my @ctrlEnd   = pullPoint();
	    my @end       = pullPoint();
	    push @beziers, [[transform($matrixRef,\@curPoint)],
			    [transform($matrixRef,\@ctrlStart)],
			    [transform($matrixRef,\@ctrlEnd)],
			    [transform($matrixRef,\@end)]];
	    $curPoint[0] = $end[0]; 
	    $curPoint[1] = $end[1]; 
	}
	return 1;
    }
    return 0;
}

sub parse {
    while (scalar(@path) !=0) {
	#printf STDERR "current token: \"%s\"\n", $path[0];
	if    (parse_m) {}
	elsif (parse_M) {}
	elsif (parse_l) {}
	elsif (parse_L) {}
	elsif (parse_c) {}
	elsif (parse_C) {}
	else {
	    die "illegal path token";
	}
    }
}
	
sub printSCAD {
    my $lineCnt     = 0;
    my $firstLine   = sprintf("%s = [", $pathName);
    my $nextLine    = $pathName;
       $nextLine    =~ s/./\ /g;
       $nextLine    = sprintf("\n%s    ", $nextLine); 

    foreach $bezier (@beziers) {
	if ($lineCnt++ == 0) {
	    print STDOUT $firstLine;
	} else {
	    printf STDOUT (",  // Bezier %2d -> %2d", $lineCnt-1, $lineCnt);	
	    print STDOUT $nextLine;
	}
	printf STDOUT ("[[%10.4f,%10.4f,  0.0000],", $bezier->[0]->[0], $bezier->[0]->[1]);
	printf STDOUT (" [%10.4f,%10.4f,  0.0000],", $bezier->[1]->[0], $bezier->[1]->[1]);
	printf STDOUT (" [%10.4f,%10.4f,  0.0000],", $bezier->[2]->[0], $bezier->[2]->[1]);
	printf STDOUT (" [%10.4f,%10.4f,  0.0000]]", $bezier->[3]->[0], $bezier->[3]->[1]);
    }
    printf STDOUT ("]; // Bezier %2d -> %2d\n\n", $lineCnt++, $lineCnt);
}
	
1;
