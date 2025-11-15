shader_type canvas_item;

uniform sampler2D map: filter_nearest;
uniform sampler2D grass: filter_nearest, repeat_enable;
uniform sampler2D bunker: filter_nearest, repeat_enable;
uniform sampler2D water: filter_nearest, repeat_enable;
uniform sampler2D wall: filter_nearest, repeat_enable;

const float scale = 112.0 / 12.0;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV.xy);
	
	if (original_color == texture(map, vec2(0.25, 0.25))) {
		COLOR = texture(grass, UV.xy * scale); 
	} else if (original_color == texture(map, vec2(0.75, 0.25))) {
		COLOR = texture(bunker, UV.xy * scale);
	} else if (original_color == texture(map, vec2(0.25, 0.75))) {
		COLOR = texture(water, UV.xy * scale);
	} else if (original_color == texture(map, vec2(0.75, 0.75))) {
		COLOR = texture(wall, UV.xy * scale);
	}  else {
		COLOR = original_color;
	}
}