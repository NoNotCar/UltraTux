shader_type canvas_item;
render_mode unshaded;
uniform vec4 top: source_color;
uniform vec4 mid1: source_color;
uniform vec4 mid2: source_color;
uniform vec4 bottom: source_color;
uniform vec4 bubble: source_color;
uniform sampler2D noise;
const vec2 dim = vec2(128.0, 48.0);

void fragment() {
	vec2 puv = floor(UV * dim) / dim;
	float tex = texture(noise, mod(vec2(puv.x + sin(puv.y * TAU * 2.0) * 0.01, puv.y * 0.5 + TIME / 12.0), vec2(1.0,1.0))).x;
	
	float heat = puv.y - 0.2 + tex * 0.15;
	if (heat < 0.0){
		COLOR = vec4(0.0,0.0,0.0,0.0);
	}else if (heat < 0.05){
		COLOR = top;
	}else if (heat < 0.12){
		COLOR = mid1;
	}else if (heat < 0.2){
		COLOR = mid2;
	}else if (tex < 0.65){
		COLOR = bottom;
	}else{
		COLOR = bubble;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
