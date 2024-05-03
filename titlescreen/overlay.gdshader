shader_type canvas_item;


uniform vec4 color;
uniform float mx;


void fragment() {
	
	vec4 texture_var = texture(TEXTURE, UV);
	vec4 color2 = mix(texture_var, color, mx);
	
	COLOR = color2;
}
