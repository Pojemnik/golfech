shader_type canvas_item;

void fragment() {
	COLOR = texture(TEXTURE, UV.xy);
	COLOR.a = round(COLOR.a);
}
