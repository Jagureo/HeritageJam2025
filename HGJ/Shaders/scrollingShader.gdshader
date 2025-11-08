shader_type canvas_item;

uniform float scrollSpeed : hint_range(0, 5) = 0.0;
uniform float scrollAngle : hint_range(0, 360, 1) = 180.0;
uniform float repeatX : hint_range(-20, 20, 1) = 1;
uniform float repeatY : hint_range(-20, 20, 1) = 1;
uniform vec4  tintColour : source_color = vec4(1.0);


// void vertex() {

// }

void fragment() {
	float angleRad = radians(scrollAngle);
	vec2 direction = vec2(cos(angleRad), sin(angleRad));
	vec2 offsetUV  = UV - (TIME * scrollSpeed * direction);

	// Tiling
	vec2 scaledUV = vec2(fract(offsetUV.x * repeatX), fract(offsetUV.y * repeatY));
	vec2 texelSize = vec2(1.0) / vec2(textureSize(TEXTURE, 0));
	vec2 snappedUV = round(scaledUV / texelSize) * texelSize;

	COLOR = texture(TEXTURE, snappedUV) * tintColour;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
