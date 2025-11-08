shader_type canvas_item;

// Tint change from pulse animation
uniform vec4 tintColour : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tintFactor : hint_range(-1.0, 1.0) = 0.0;
uniform float fade : hint_range(0.0, 1.0) = 1.0;


// Outline shader
uniform vec4 outlineColour : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float outlineWidth : hint_range(0,10) = 10.0;
const vec2 OFFSETS[8] = {
	vec2(-1,-1), vec2(-1,0), vec2(-1,1), vec2(0,-1),
	vec2(0,1), vec2(1,-1), vec2(1,0), vec2(1,1)
};



void fragment() {

	vec4 mainTexture = texture(TEXTURE, UV);
	vec2 size = TEXTURE_PIXEL_SIZE * outlineWidth;

	// Calculate outline alpha
	float outline = 0.0;
	for (int i = 0; i < OFFSETS.length(); i++) 
	{
		outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
	}	
	outline = min(outline, 1.0);

	// If pixel is outside main sprite but within outline
	if (mainTexture.a < 0.1 && outline > 0.0) 
	{
		COLOR = vec4(outlineColour.rgb, outline * fade);
	}
	// Otherwise apply tint to main texture
	else
	{
		float originalModulation = 1.0 - tintFactor;
		COLOR.rgb = mix(mainTexture.rgb * originalModulation, tintColour.rgb * tintFactor, tintFactor);
		COLOR.a = mainTexture.a * fade;
	}



	// Tint
	// vec4 mainTexture = texture(TEXTURE, UV);
	// vec4 tintOutput = mainTexture;
	// float originalModulation = 1.0 - tintFactor;


	// COLOR.rgb = mix(mainTexture.rgb * originalModulation, tintColour.rgb * tintFactor, tintFactor);
	// COLOR.a *= fade;

}
