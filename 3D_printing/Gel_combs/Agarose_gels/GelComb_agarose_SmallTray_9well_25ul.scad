
translate ([0, 0, 0]) {
   comb ();

}


module comb ()
{
    // Base parameters
    length_outer = 83;
    length_inner = 69.4;
    width_lip = 2.8; // 3.1 was a little too high
    width_support = 5;
    height_lip = 10;
    
    // Well parameters
    length_all_wells = 62;
    width_well = 1.0;
    height_well = 12;
    length_well = 2.4;
    num_wells = 17;
    
    // Text label parameters
    text_string = "VBL ";
    text_height = 0.5;
    font_size = 5.5;
    
    // calculate lip support width
    width_lip_support = width_lip + width_support;  
    
    // make the actual comb
    difference()
    {
        base(height_lip,width_lip,length_outer,length_inner,width_lip_support);
        label(height_well,length_well,width_well,num_wells,font_size,
            height_lip, width_lip_support,text_height,text_string);
    }
    
    wells(num_wells,width_well,length_well,length_all_wells,height_lip,height_well);
    
}


module base(height_lip,width_lip,length_outer,length_inner,width_lip_support)
{
    // specify the base structure
    translate([0, height_lip/2, width_lip/2])
    cube ( [length_outer, height_lip, width_lip], center=true);
    translate([0, height_lip/2, width_lip_support/2])
    cube ( [length_inner, height_lip, width_lip_support], center=true);
}

module wells(num_wells,width_well,length_well, length_all_wells,height_lip,
    height_well)
{
    // specify the wells
    
    length_well_centers = length_all_wells - length_well;
    well_spacing = length_well_centers / (num_wells-1);
    height_well_ext = height_well + height_lip;
    
    for (i=[0:1:num_wells-1]) {
        x_offset = i * well_spacing - (length_well_centers / 2);
        translate ([x_offset, height_well_ext/2, width_well/2])
        cube([length_well, height_well_ext, width_well], center=true); 
    }
}   

module label (height_well,length_well,width_well,num_wells,font_size,
    height_lip, width_lip_support,text_height,text_string)
{
    // specify the label
    ul_per_well = round(height_well/3 * length_well * width_well);
    label = str(text_string, num_wells, " wells, ~", ul_per_well, " μl");
    length_label = len(label) * font_size;
    
    translate ([0, height_lip/2+ font_size/2, width_lip_support])
    rotate (a = [180, 180, 0])
    linear_extrude(height=text_height*2, center=true)
    text(label, size = font_size, halign="center");
}