#version 300 es

precision mediump float;

in vec3 ambient;
in vec3 diffuse;
in vec3 specular;
in vec2 frag_texcoord;
in vec3 frag_pos;
in vec3 frag_normal;

uniform vec3 light_ambient;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n
uniform sampler2D image;          // use in conjunction with Ka and Kd
uniform int light_amount;

out vec4 FragColor;

void main() {
	vec3 final_Material = vec3(vec4(material_color,1.0) * texture(image, frag_texcoord));
    //FragColor = vec4(material_color, 1.0) * texture(image, frag_texcoord);
	
	vec3 light_direction; //= normalize(light_position - frag_pos);
	vec3 reflect_direction; //= normalize(reflect(-light_direction, frag_normal));
	vec3 view_direction = normalize(camera_position - frag_pos);

    vec3 diffuse = vec3(0.0, 0.0, 0.0); //= light_color * clamp(dot(frag_normal, light_direction), 0.0, 1.0);
    vec3 specular = vec3(0.0, 0.0, 0.0); //= light_color* pow(clamp(dot(reflect_direction,view_direction), 0.0, 1.0), material_shininess);
	
	for(int i = 0; i < light_amount; i++)
	{
		light_direction = normalize(light_position[i] - frag_pos);
		reflect_direction = normalize(reflect(-light_direction, frag_normal));
		
		//calculate diffuse and specular += previous variables//
		vec3 hold_Diffuse = light_color[i] * clamp(dot(frag_normal, light_direction), 0.0, 1.0);
		vec3 hold_Specular = light_color[i] * pow(clamp(dot(reflect_direction,view_direction), 0.0, 1.0), material_shininess);	
		
		diffuse += hold_Diffuse;
		specular += hold_Specular;
	}

    FragColor = vec4(final_Material * light_ambient + final_Material * diffuse + material_specular * specular, 1.0);
}
