shader_type spatial;
render_mode wireframe;

const uint FLAG_TOP_LEFT = 1u << 4u;
const uint FLAG_TOP_RIGHT = 1u << 5u;
const uint FLAG_BOTTOM_LEFT = 1u << 6u;
const uint FLAG_BOTTOM_RIGHT = 1u << 7u;
//const uint FLAG_TOP_LEFT = 1u << 28u;
//const uint FLAG_TOP_RIGHT = 1u << 29u;
//const uint FLAG_BOTTOM_LEFT = 1u << 30u;
//const uint FLAG_BOTTOM_RIGHT = 1u << 31u;

uniform sampler2D morph_data: filter_nearest;
uniform vec2 grid_const = vec2(8.0, 0.125);

varying vec3 color;
varying flat uint flags;

// Morphs input vertex from high to low detailed mesh position.
vec2 morph_vertex(vec2 in_vertex, float morph_k) {
   vec2 frac_part = fract(in_vertex * vec2(grid_const.x, grid_const.x)) * vec2(grid_const.y, grid_const.y);
   return in_vertex - frac_part * morph_k;
}

void vertex() {
	int i = INSTANCE_ID;
	NORMAL = vec3(0,1,0);
	color = COLOR.rgb;
	UV = VERTEX.xz;
	flags = floatBitsToUint(COLOR.a);
	//uint lod = flags & uint(0x0F000000);
	uint lod = flags & uint(0x0F);
	vec2 morph_const = texelFetch(morph_data, ivec2(int(lod), 0), 0).xy;
	float d = length((MODELVIEW_MATRIX * vec4(VERTEX, 1.0)).xyz);
	float morph_k = 1.0f - clamp(morph_const.x - d * morph_const.y, 0.0, 1.0);
	vec2 morphed_pos = morph_vertex(VERTEX.xz, morph_k);
	float h = 0.0;
	VERTEX = vec3(morphed_pos.x, h, morphed_pos.y);
	float tt = TAU;
}

void fragment() {
	if (!bool(flags & FLAG_TOP_LEFT) && (UV.x < 0.5 && UV.y < 0.5) ||
			!bool(flags & FLAG_TOP_RIGHT) && (UV.x > 0.5 && UV.y < 0.5) ||
			!bool(flags & FLAG_BOTTOM_LEFT) && (UV.x < 0.5 && UV.y > 0.5) ||
			!bool(flags & FLAG_BOTTOM_RIGHT) && (UV.x > 0.5 && UV.y > 0.5)) {
		ALPHA = 0.0;
	}

	ALBEDO = color;
}
