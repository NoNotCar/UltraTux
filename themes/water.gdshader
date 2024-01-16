shader_type canvas_item;

uniform vec4 surface_colour: source_color;

void fragment() {
	float px = floor(UV.x * 24.0);
	float py = floor(UV.y * 12.0);
	float surface = 6.0 + sin(px * TAU / 12.0  + TIME * 5.9) * 1.6 + sin(px * TAU / 8.0 - TIME * 1.77) * 0.75 - cos(TIME * 2.0) * 0.5;
	if (py < surface){
		COLOR = vec4(0,0,0,0);
	}
	else if (py - 1.0 < surface){
		COLOR = surface_colour;
	}
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
