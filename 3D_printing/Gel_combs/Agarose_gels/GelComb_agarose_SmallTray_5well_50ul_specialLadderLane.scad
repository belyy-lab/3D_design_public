
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
    
    // Special well (narrower than others; used for ladder) parameters
    length_special_well = 2;
    
    // Well parameters
    length_all_wells = 62.0;
    width_well = 1.4; // 1.0 is a good default
    height_well = 12;
    length_well = 9;
    num_sample_wells = 5;
    
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
        label(height_well,length_well,width_well,num_sample_wells,font_size,
            height_lip, width_lip_support,text_height,text_string);
    }
    
    wells(num_sample_wells,width_well,length_well,length_all_wells,height_lip,height_well, length_special_well);
    
}


module base(height_lip,width_lip,length_outer,length_inner,width_lip_support)
{
    // specify the base structure
    translate([0, height_lip/2, width_lip/2])
    cube ( [length_outer, height_lip, width_lip], center=true);
    translate([0, height_lip/2, width_lip_support/2])
    cube ( [length_inner, height_lip, width_lip_support], center=true);
}

module wells(num_sample_wells,width_well,length_well, length_all_wells,height_lip,
    height_well, length_special_well)
{
    // perform some dimension calculations
    height_well_ext = height_well + height_lip;
    well_length_no_gaps = num_sample_wells * length_well + length_special_well;
    num_wells = num_sample_wells + 1;
    well_spacing = (length_all_wells - well_length_no_gaps) / (num_wells-1);
    origin_offset = (length_special_well + well_spacing)/2;
    length_samp_well_centers = (length_well + well_spacing) * (num_sample_wells-1); 
    
    echo(well_spacing);
     // make the special well
    x_offset = -(length_all_wells-length_special_well)/2;
    translate ([-x_offset, height_well_ext/2, width_well/2])
    cube([length_special_well, height_well_ext, width_well], center=true); 
    
    // make the other wells
    for (i=[0:1:num_sample_wells-1]) {
        //x_offset = i * well_spacing - (length_well_centers / 2);
        //x_offset = curr_pos + length_well + well_spacing;
        x_offset = -origin_offset - length_samp_well_centers * 
            -(i / (num_sample_wells - 1) - 0.5);
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