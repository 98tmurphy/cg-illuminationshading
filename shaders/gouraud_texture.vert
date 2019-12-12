#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;
in vec2 vertex_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform float material_shininess;
uniform vec2 texture_scale;
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;
uniform int light_amount;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;
out vec2 frag_texcoord;

void main() {
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    frag_texcoord = vertex_texcoord * texture_scale;
	
	//--------Color_Frag Code-------//
			//---(Below)---//
	
	mat3 normal_model_matrix = inverse(transpose(mat3(model_matrix)));
	
	vec3 actual_normal = normalize(normal_model_matrix * vertex_normal);
	vec3 actual_position = vec3(model_matrix * vec4(vertex_position, 1.0));
	
	vec3 light_direction; 				//= normalize(light_position - actual_position);
	vec3 reflect_direction; 			//= normalize(reflect(-light_direction, actual_normal));
	vec3 view_direction = normalize(camera_position - actual_position);
	
	ambient = light_ambient;
	diffuse = vec3(0.0, 0.0, 0.0); 		//light_color * clamp(dot(actual_normal, light_direction), 0.0, 1.0);
	specular = vec3(0.0, 0.0, 0.0); 	//light_color * pow(clamp(dot(reflect_direction,view_direction), 0.0, 1.0), material_shininess);
	
	for(int i = 0; i < light_amount; i++)
	{
		light_direction = normalize(light_position[i] - actual_position);
		reflect_direction = normalize(reflect(-light_direction, actual_normal));
		
		//calculate diffuse and specular += previous variables//
		vec3 hold_Diffuse = light_color[i] * clamp(dot(actual_normal, light_direction), 0.0, 1.0);
		vec3 hold_Specular = light_color[i] * pow(clamp(dot(reflect_direction,view_direction), 0.0, 1.0), material_shininess);	
		
		diffuse += hold_Diffuse;
		specular += hold_Specular;
	}
	
	//--------Color_Frag Code-------//
}
