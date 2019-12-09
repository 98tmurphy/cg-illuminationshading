#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform float material_shininess; // n
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;

void main() {
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
	
	mat3 normal_model_matrix = inverse(transpose(mat3(model_matrix)));
	
	vec3 actual_normal = normalize(normal_model_matrix * vertex_normal);
	vec3 actual_position = vec3(model_matrix * vec4(vertex_position, 1.0));
	
	vec3 light_direction = normalize(light_position - actual_position);
	vec3 reflect_direction = normalize(reflect(-light_direction, actual_normal));
	vec3 view_direction = normalize(camera_position - actual_position);
	
	ambient = light_ambient;
	diffuse = light_color * clamp(dot(actual_normal, light_direction), 0.0, 1.0);
	specular = light_color * pow(clamp(dot(reflect_direction,view_direction), 0.0, 1.0), material_shininess);		
}
