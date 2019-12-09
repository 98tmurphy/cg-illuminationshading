#version 300 es

precision mediump float;

in vec3 ambient;
in vec3 diffuse;
in vec3 specular;
in vec2 frag_texcoord;

uniform vec3 material_color;    // Ka and Kd
uniform vec3 material_specular; // Ks
uniform sampler2D image;        // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
	vec3 final_Material = vec3(texture(image, frag_texcoord))*material_color;
	
    //FragColor = texture(image, frag_texcoord);
	FragColor = vec4(final_Material * ambient + final_Material * diffuse + material_specular * specular, 1.0);
}
