shader_type canvas_item;
uniform vec4 color: source_color;

void fragment() {
	COLOR = texture(TEXTURE, UV.xy);
	COLOR.rgb = color.rgb;
	COLOR.a = round(COLOR.a) * color.a;
}
