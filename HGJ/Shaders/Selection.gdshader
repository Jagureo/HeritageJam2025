shader_type canvas_item;

// Tint change from pulse animation
uniform vec4 tintColour : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tintFactor : hint_range(-1.0, 1.0) = 0.0;
uniform float fade : hint_range(0.0, 1.0) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	vec4 mainTexture = texture(TEXTURE, UV);
	vec4 tintOutput = mainTexture;

	// Tint
	float originalModulation = 1.0 - tintFactor;
	COLOR.rgb = mix(mainTexture.rgb * originalModulation, tintColour.rgb * tintFactor, tintFactor);
	COLOR.a *= fade;
}
