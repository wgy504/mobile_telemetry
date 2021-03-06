wall_width = 3;
inner_width = 54;
inner_depth = 74;
inner_height = 25;
cover_inner_height = 2;

// render quality
//$fa = .25;	// minimum angle 
//$fs = .25;	// minimum size 
$fn=30;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])

        difference() {
            cube([r + 0.01, r + 0.01, h], center = true);

            translate([r/2, r/2, 0])
                cylinder(r = r, h = h + 1, center = true);
        }
}


module nipple(h, d) {
    difference() {
        union() {
            cylinder(h=h, d=d);
            translate([0, 0, h-0.1])
                sphere(d=d);
        }
        /*
#translate([0, 5, h-2.5])
rotate([90, 0, 0])
cylinder(h=10, d=1.2);
         */
    }
}

module mynipple() {
    nipple(wall_width + cover_inner_height +4, 2.5);
}

module nipplehole() {
    union() {
        cylinder(h=2, d1=6, d2=3);
        cylinder(h=20, d=2.5*1.1);
    }
}

module logo() {
    linear_extrude(height=2)
        text(text = "Mobile Telemetry",
                size = 6,
                halign = "center",
                valign = "center", $fn=0);
}

module logo2() {
    linear_extrude(height=2)
        text(text = "\u00A9 2016 mru",
                size = 5,
                halign = "center",
                valign = "center", $fn=0);
}



module holder(d1,h1,d2,h2) {
    union() {
        cylinder(h=h1, d=d1);
        translate([0, 0, h1-0.1])
            cylinder(h=h2, d=d2);
    };
};

module myholder() {
    holder(5, 4, 2, 5);
};

module screw(d, l) {
    cylinder(h = l, d=d);
    translate([0,0,l])
        cylinder(h=d, d1=d, d2=2*d);
}

module box(inner_x, inner_y, inner_h, width) {
    translate([0, 0, inner_h/2-width/2]) 
        difference() {
            cube([inner_x+width*2, inner_y+width*2, inner_h+width], center=true);
            translate([0, 0, width/2])
                cube([inner_x, inner_y, inner_h+0.1], center=true);

            fourtimes(inner_x/2+width,inner_y/2+width)
                fillet(1.5, inner_h+width+0.1);

            fourtimes(inner_x/2+width,inner_y/2+width)
                translate([inner_x/2, 0, -inner_h/2-width/2])
                rotate([0,270,0])
                fillet(1.5, 2*inner_x+width+0.1);
        }
}

module xybox(h) {
    box(inner_width, inner_depth, h, wall_width);
}

module seal(headroom) {
    linear_extrude(height=2) {
        difference() {
            square([inner_width + wall_width + headroom*1, inner_depth + wall_width + headroom*1], center=true);
            square([inner_width + wall_width - headroom*1, inner_depth + wall_width - headroom*1], center=true);
        }   
    }
}


module mybox() {
    xybox(inner_height);
}

module fourtimes(x, y, rotate_each=true) {
    translation = [ [-x, -y, 0], [x, -y, 0], [x, y, 0], [-x, y, 0] ];
    rotation = [ for (a=[0:3]) let (r= rotate_each ? a*90 : 0) [0,0,r] ];
    for ( i = [0:3] ) {
        translate(translation[i])
            rotate(rotation[i])
            children();
    }
}

module cover() {
    difference() {
        xybox(cover_inner_height);
        translate([0, 0, cover_inner_height-2+0.1])
            seal(1.1);

        translate([0, 0, -10])
            fourtimes(inner_width/2+wall_width/2-0.5, inner_depth/2+wall_width/2-0.5)
            nipplehole();
    }
}

module box_w_holder() {

    logo_pos1=[-inner_width/2 - wall_width + 0.5, 0, 18];
    logo_pos2=[-inner_width/2 - wall_width + 0.5, 0, 5];
    logo_rot=[270, 180, 90];

    difference() {
        union() {
            mybox();

            fourtimes(23, 33)
                translate([0,0,-0.1])
                myholder();

            translate([0, 0, inner_height])
                fourtimes(inner_width/2+wall_width/2-0.5, inner_depth/2+wall_width/2-0.5, rotate_each=false)
                mynipple();

            translate([0, 0, inner_height - 0.1])
                seal(1);
        }

        #translate(logo_pos1)
            rotate(logo_rot)
            logo();

        #translate(logo_pos2) 
            rotate(logo_rot) 
            logo2();
    }

}

