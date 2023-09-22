GDPC                �
                                                                      !   \   res://.godot/exported/133200997/export-0783e7cbf2b0a1e6505b5629fa6c9082-player_texture.res  ��      �
      ��NH�Cv��~#�    T   res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn  P�      g      �C�*7�Z1���i$�    X   res://.godot/exported/133200997/export-4cfa184f3667b66afc932584b1bf2358-clear_sky.res                x��;_V����c(��    P   res://.godot/exported/133200997/export-4fe1464105c47ebb93ca2be69ccaeb47-tail.scn��      P      �,n& j-�t�"�ǏQ    T   res://.godot/exported/133200997/export-6f9b3841ff273fd663e4d807c75f8c65-walls.scn   p�      �      (ST���L��;;�҂z    T   res://.godot/exported/133200997/export-72e228c7f6bf196d70e576847011330f-m_player.res�s      ~      /e���z�%�ٍ8�$��    T   res://.godot/exported/133200997/export-76e0adcbc83681695885bae615f516ae-world.scn   �      !      =F��C+�6����v    P   res://.godot/exported/133200997/export-9c8493a753c42d45460d9b93900e0179-food.scn            ����۞�a| OZ��    T   res://.godot/exported/133200997/export-d5e193774c5ee8e412d6b0813a27ef0b-tails.scn    �      L      ��0#7���"Ȕ�P    ,   res://.godot/global_script_class_cache.cfg  0�      R      GUL��N�Ra�u���    L   res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.s3tc.ctex   0      �U      (�?�k0����A�       res://.godot/uid_cache.bin  P�      )      �G�wjͳ~A#F��1       res://board.gdshader              �3�u%b(3D̆ u�       res://clear_sky.tres.remap  @�      f       ?ZuT��#|0qr.$       res://food.gd   0      �      �Vr�m;O�����,�t       res://food.tscn.remap   ��      a       RO���� ���       res://icon.svg  ��      �      C��=U���^Qu��U3       res://icon.svg.import   �r      �       W�_��Vt��jb�^       res://m_player.tres.remap    �      e        V���Т`�[�a��       res://player.gd Pu      �      eG��LNݠ�4�(	Q       res://player.gdshader   @�            P��\5˗a�����.�       res://player.tscn.remap ��      c       ������T�?�L���        res://player_texture.tres.remap  �      k       ��恌�f?+�(�+       res://project.binary��      W      ��1����f�6�m]�       res://sky.gdshader  ��      �       ���괕�,B].>/��       res://tail.gd   ��      �      l���eVj�Ԕ	��,       res://tail.gdshader p�      b       Õ�l⩣�L��_$�2       res://tail.tscn.remap   p�      a       6��������X��Ԁ       res://tails.gd  0�      �      ����w��*�i��u       res://tails.tscn.remap  ��      b       5�<6{\:���O��)9�       res://walls.tscn.remap  P�      b       `.�GqZ���HT��hP/       res://world.gd  @�      �      �]
�>S�/�X\ۍ�_       res://world.tscn.remap  ��      b       �t�׵B�}��6�x    shader_type spatial;
//render_mode unshaded;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

vec3 draw_background(vec2 cuv, float T, float cells) {
	vec2 speed = vec2(T*.05, T*.001) * -1.;
	speed /= cells / 80.;
	vec2 uv = fract((cuv - speed) * cells);
	vec2 id = floor((cuv - speed) * cells);
	
	float n = n21(id + cells*100.);
	
	float d = length(uv - .5 + vec2(fract(n*12.22)*.8 - .4, fract(n*1222.3322)*.8 - .4));
	
	if (n < .97) {
		return vec3(0.);
	}
	
	float size = .05 + 0.05*fract(n*32.332) - .0025;
	
	return vec3(1.) * smoothstep(.1, 1., (size/2.)/pow(d, 1.2));
}

void fragment() {
	float size = 17.1;
	
	vec2 uv = fract(UV*size);
	vec2 id = floor(UV*size);
	
	float n = n21(id+10.);
	
	float line = .07;
	
//	float border = max(.05/pow(abs(uv.x-.5), 1.2), .05/pow(abs(uv.y-.5), 1.2));
//	border = step(border, 4.);

	float border = 1. - max(step(uv.x-(line - 0.07), line), step(uv.y+(line - 0.07), line));
	

	
	if (n > .8) {
		border = 0.;	
	}
	
	ALBEDO = vec3(.9, .3, .1)*border*.2;
	
	if (border == 0.) {
		ROUGHNESS = 0.;
		ALBEDO = draw_background(UV, TIME, 80) + draw_background(UV, TIME, 160) + draw_background(UV, TIME, 180);
	}
	
//	vec2 suv = fract((UV - vec2(.5,0))*vec2(17.1, 1.));
//	vec2 sid = floor((UV - vec2(.5,0))*vec2(17.1, 1.));
//
//	float tn = n21(vec2(floor(TIME), sid.x));
//
//	float slider = .05/pow(abs(suv.x-.5), .9) * sin(suv.y*9. + TIME*4. + (tn - .5)*20.);
//
//
//
//	if (ALBEDO.r == 0. && tn > .9) {
//		ALBEDO = slider * vec3(.9, .3, .1);
//	}
		
	
}
0���Ƀ��~��RSRC                    Environment            ��������                                            �      resource_local_to_scene    resource_name    sky_top_color    sky_horizon_color 
   sky_curve    sky_energy_multiplier 
   sky_cover    sky_cover_modulate    ground_bottom_color    ground_horizon_color    ground_curve    ground_energy_multiplier    sun_angle_max 
   sun_curve    use_debanding    script    sky_material    process_mode    radiance_size    noise_type    seed 
   frequency    offset    fractal_type    fractal_octaves    fractal_lacunarity    fractal_gain    fractal_weighted_strength    fractal_ping_pong_strength    cellular_distance_function    cellular_jitter    cellular_return_type    domain_warp_enabled    domain_warp_type    domain_warp_amplitude    domain_warp_frequency    domain_warp_fractal_type    domain_warp_fractal_octaves    domain_warp_fractal_lacunarity    domain_warp_fractal_gain    width    height    depth    invert 	   seamless    seamless_blend_skirt 
   normalize    color_ramp    noise    background_mode    background_color    background_energy_multiplier    background_intensity    background_canvas_max_layer    background_camera_feed_id    sky    sky_custom_fov    sky_rotation    ambient_light_source    ambient_light_color    ambient_light_sky_contribution    ambient_light_energy    reflected_light_source    tonemap_mode    tonemap_exposure    tonemap_white    ssr_enabled    ssr_max_steps    ssr_fade_in    ssr_fade_out    ssr_depth_tolerance    ssao_enabled    ssao_radius    ssao_intensity    ssao_power    ssao_detail    ssao_horizon    ssao_sharpness    ssao_light_affect    ssao_ao_channel_affect    ssil_enabled    ssil_radius    ssil_intensity    ssil_sharpness    ssil_normal_rejection    sdfgi_enabled    sdfgi_use_occlusion    sdfgi_read_sky_light    sdfgi_bounce_feedback    sdfgi_cascades    sdfgi_min_cell_size    sdfgi_cascade0_distance    sdfgi_max_distance    sdfgi_y_scale    sdfgi_energy    sdfgi_normal_bias    sdfgi_probe_bias    glow_enabled    glow_levels/1    glow_levels/2    glow_levels/3    glow_levels/4    glow_levels/5    glow_levels/6    glow_levels/7    glow_normalized    glow_intensity    glow_strength 	   glow_mix    glow_bloom    glow_blend_mode    glow_hdr_threshold    glow_hdr_scale    glow_hdr_luminance_cap    glow_map_strength 	   glow_map    fog_enabled    fog_light_color    fog_light_energy    fog_sun_scatter    fog_density    fog_aerial_perspective    fog_sky_affect    fog_height    fog_height_density    volumetric_fog_enabled    volumetric_fog_density    volumetric_fog_albedo    volumetric_fog_emission    volumetric_fog_emission_energy    volumetric_fog_gi_inject    volumetric_fog_anisotropy    volumetric_fog_length    volumetric_fog_detail_spread    volumetric_fog_ambient_inject    volumetric_fog_sky_affect -   volumetric_fog_temporal_reprojection_enabled ,   volumetric_fog_temporal_reprojection_amount    adjustment_enabled    adjustment_brightness    adjustment_contrast    adjustment_saturation    adjustment_color_correction        $   local://ProceduralSkyMaterial_v760g <         local://Sky_qk67l �         local://FastNoiseLite_e777k �         local://NoiseTexture3D_uvas2 �         local://Environment_at2h2          ProceduralSkyMaterial          �� <��D>���>  �?      q=�C         Sky                          FastNoiseLite                   hв2���Lhв2         NoiseTexture3D    0                     Environment    1         2      ���>���>��>?  �?7            ?         i         j      ��9@m      �(�>u      ���>��"?���>  �?v      333?w      R��>x      W[1=y      ��>{      \OzC|      !�r��                  RSRC�1pI�extends Node3D
class_name Food

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	if is_multiplayer_authority():
		position.x = randi_range(-15, 15)
		position.y = randi_range(-7, 25)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_x(delta * PI/4)
	rotate_y(delta * PI/2)
	rotate_z(delta * PI/8)
	pass

@rpc("any_peer", "call_local")
func eaten():
	call_deferred("queue_free")
�NIPN��RSRC                    PackedScene            ��������                                                  ..    . 	   position    resource_local_to_scene    resource_name    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_height    subdivide_depth    script    custom_solver_bias    margin    radius    properties/0/path    properties/0/spawn    properties/0/sync    properties/0/watch 	   _bundled       Script    res://food.gd ��������      local://BoxMesh_o0nup �         local://SphereShape3D_t1xxh �      %   local://SceneReplicationConfig_fd5bs          local://PackedScene_l1yyx g         BoxMesh             SphereShape3D          333?         SceneReplicationConfig                                                        PackedScene          	         names "         food    script    Node3D    StaticBody3D    MeshInstance3D    mesh 	   skeleton    CollisionShape3D    shape    MultiplayerSynchronizer    replication_config    	   variants                                                                 node_count             nodes     -   ��������       ����                            ����                     ����                                ����                     	   	   ����   
                conn_count              conns               node_paths              editable_instances              version             RSRC.x���r�GST2   �   �     �����                � �               ���)TUUU� I�$I�&!&!UUUU� I  &!&!UUUU�z�     &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�zX    &!&!UUUU� O9  &!&!UUUU� I�$O'&!&!UUUU        ���)UUU� I�$I�&!&!UUUU�!@    F!&!UUUU�       �1&!U5	 �       �1g!   �       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1g!p   �       �1&!U\` � �   F!&!UUUU� I�$N�'&!&!UUUU� �p &!&!UUUU�       �1&!%�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1&!TXp@� X8��G)&!UUUU�zP   &!&!UUUU�       �1g!  �       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1g)@�� �x � @&!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �:�1UUU�       WD2UU5�       WD2U  �       WD2k@  �       �:�1UUUT�       �1�1UUUU�       �1�1UUUU�       �:�1UUU�       WD2� �       WD2U�  �       WD2UUX��       �:�1UUUT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2T\Pp�       �1�1UUUU�       �1�1UUUU�       WD25�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2PPPP�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2%%%�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2@   �       WD+:U   �       WD+:U   �       WD2   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2PPXX�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2555	�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2\\\`�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       6D2UU��       WD2]�  �       WD2UUX��       m:�1UUU�       WD2�% �       wDD   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDD@   �       WD2WX@ �       �:�1UUUT�       WD2UU%�       WD2u�  �       6D2UUWT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       m:�1UUU�       WD2 �       wDwDUUUU�       wDwDUUUU�       WL�:   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WDm:�   �       wDwDUUUU�       wDwDUUUU�       WD2P@� �       �:�1UUUT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2%	�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2TXp`�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD25�U�       wDD   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDD   @�       WD2P\VU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2@pPT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       ��xLUUU�       ���TU% �       ���u   �       ���TW`  �       ���TUUW\�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       ���TUU�5�       ���T�	  �       ���}   �       ���TUX� �       ��xLUUUT�       wDwDUUUU�       wDwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       ���T%�       ��IJ �`P�       Y�IJ\UUU�       ��IJ�UU�       ���Sp@���       wDwDUUUU�       wDwDUUUU�       ���TU�	�       ���TUWP`�       wDwDUUUU�       wDwDUUUU�       ��T	C�       ��IJpVUU�       8�IJ5UUU�       ��IJ �       ���TTXPp�       wDwDUUUU�       wDwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       ���T	�       ��IJX\\X�       BBUUUU�       BBUUUU�       ��IJ�����       wDwDUUUU�       wDwDUUUU�       ���T�       ���T@@@@�       wDwDUUUU�       wDwDUUUU�       ��IJBBBB�       BBUUUU�       BBUUUU�       ��IJ%555�       ���T```p�       wDwDUUUU�       wDwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       ���T%U�       ��IJPp� �       ׽IJUUU\�       ��IJUU��       ��nS�����       wDwDUUUU�       wDwDUUUU�       ���T�       ���T@@@@�       wDwDUUUU�       wDwDUUUU�       ���SC	5�       ��IJUUVp�       ��)JUUU5�       ��IJ �       ���TPXTW�       wDwDUUUU�       wDwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       ���T%UU�       ���T  �U�       ���T `WU�       9uxLTUUU�       wDwDUUUU�       wDwDUUUU�       ���T	��       ���T@@pW�       wDwDUUUU�       wDwDUUUU�       9mwLUUU�       ���T 	�U�       ���T  �U�       ���T�XUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       ��KB��       ��8uU  �       ���TU   �       ���TU�  �       ���TU_� �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       \��LUUU�       ϘTUUU �       ϘTUUU �       ϘTUUU �       ϘTUUU �       |��LUUUT�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       ���TU� �       ���TU*  �       ���TU   �       ��8uU  ��       ��KBVTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       xLwDUUUU�       ��xLUUU�       �ƘLUUU�       ��z} �       �LwDUUUU�       wDwDUUUU�       wDwDUUUU�       ���T%�       ���T  �\�       ���T  �U�       ���T  �U�       ���T  *5�       ���TXPPP�       wDwDUUUU�       wDwDUUUU�       wLwDUUUU�       ����@@@�       �ƘL�UUU�       ��xL�UUU�       xLwDUUUU�       WD2TTTT�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       7D2���       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       ���T�       ���TUU  �       ���TUU� �       ���TUU� �       ���T �       ���TTTTV�       wDwDUUUU�       wDwDUUUU�       ���T��       ���TPp` �       ���TUU� �       ���TUU* �       ���TUU  �       ���T@@@@�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       6D2TTVW�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       L:�1UUU�       WD2 �       wDwDUUUU�       wDwDUUUU�       ���TUUU�       ���T �UU�       ���T �UU�       ���T  UU�       ���T  UU�       \�xLTWUU�       wDwDUUUU�       wDwDUUUU�       �xL�UU�       ���T  UU�       ���T  UU�       ���T �UU�       ���T UU�       ���T`UUU�       wDwDUUUU�       wDwDUUUU�       WD2 �@p�       +:�1TUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2%�UU�       WD:  	�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2  �p�       WD2XVUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       D25UUU�       WD2 %U�       WDQ;   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD1;   `�       WD2 �XU�       �C
2\UUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       RC
25UUU�       WD2 -UU�       WD2  -U�       WD,:   ��       WL�C   -�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WL�C   x�       WD+:   _�       WD2  xU�       WD2 xUU�       RC
2\UUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�       &!&!UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       
2�1UUUU�       �:�1
UUU�       �:�1UUU�       �:�1�UUU�       �:�1�UUU�       
2�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       &!&!UUUU�z 0  &!&!UUUU�       �1g!  �       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1g) ��@�x  ` 
 &!&!UUUU� 1�&!&!UUUU�       �1&!%�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1&!@pXT�  (��%G)&!UUUU� ɑ�I�$&!&!UUUU�   �F!&!UUUU�       �1&! 	5U�       �1g)   )�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1g)   h�       �1&! `\U�    
4F!&!UUUU� x�$I�$&!&!UUUU        ���)UUUT� ���I�$&!&!UUUU�  0 ���G)&!UUUU�x    �N&!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�       &!&!UUUU�x    �5&!&!UUUU�   `��$G)&!UUUU� p�$I�$&!&!UUUU        ���)UUU� I��	�RF!TUUU��     �1&!UU-�       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �       �1&!UU  �P    �1&!UUx�� I�$`8�RF!UUU�P   �1&!�5%�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU� �  �1&!V\XP�       �1&!�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �C
2UUU%�       WD2UU� �       +:�1UUUT�       :�1UUUU�       WD2UUs �       �C
2UUUX�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       WD2�       wDwDUUUU�       WD2VT� �       WD2�* �       wDwDUUUU�       WD2@@@@�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       �:�1UUU�       WD2UU_��       WD2UU�%�       WD2	  �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2`@  �       WD2UUWX�       WD2UU��       �:�1UUUT�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       WD2	�       wDwDUUUU�       WD�C   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD�Cp   �       wDwDUUUU�       WD2\P`@�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       WD25��       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD2@P\V�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       1C�1�       wDwDUUUU�       ��,S�C�       ��IJ� �U�       ���TUWTZ�       ��TUUU�       ���TUUUT�       ���TU���       ��IJ �U�       ��S�����       wDwDUUUU�       QC�1TTTT�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       1C�1�       wDwDUUUU�       ��IJbcC�       ��)JUUU�       גTQQXT�       ���T5555�       ���T\\\\�       ϓL��%�       ��)JUUU��       ��IJ�����       wDwDUUUU�       QC�1TTTT�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       1C�1�       wDwDUUUU�       ^ߘT5UUU�       ���T�UUU�       �TwDTUUU�       ���T5�UU�       ���T\VUU�       �TwDUUU�       ���TUUU�       ~�T\UUU�       wDwDUUUU�       QC�1TTTT�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       ��
:���       ���T� UU�       ���T_ %�       xLwDUUUU�       ���TUU�       ���TU� ��       ���TU� ��       ���TUUTT�       wDwDUUUU�       ���T� �X�       ���T� UU�       Ք
:TTWW�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       ;�1�UU�       WD�:   �       ���T%5�U�       ���TU 
U�       ���T* U�       \�xLTVWU�       ;�xL��U�       ���TT� U�       ���TU �U�       ���TXXVU�       WD�:   @�       �:�1TVUU�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       �1�1UUUU�       WD2	%�U�       WD+:   �       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       wDwDUUUU�       WD:   p�       WD2`XWU�       �1�1UUUU�       �1�1UUUU�       �1&!PPPP�       �1&!�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       m:�1UUU�       WD2�UU�       WD2 
UU�       WD2  UU�       WD2  UU�       WD2 �UU�       WD2�WUU�       m:�1TUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1&!PPPP�    �1&!%5��       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�       �1�1UUUU�  @ 
 �1&!PX\V� 1�I�$�RF!UUUT�    �
�1&!-UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�       �1&!  UU�     5�1&!�xUU� �&N�$�RF!UUU� 	   �1&!V5�       �1&!U   �       �1&!U   �       �1&!U   �       �1&!U   �       �1&!U   �       �1&!U   � `   �1&!�\p@�       �1&!�       �1�1UUUU�       WD2U�55�       WD2URp �       WD2U� �       WD2UW\\�       �1�1UUUU�       �1&!@@@@�       �1&!�       WD2U��       WD25	  �       wDwDUUUU�       wDwDUUUU�       WD2\`  �       WD2U[@��       �1&!@@@@�       �1&!�       WD2	�       ]��R��R�       |��LUUU��       |��LUUU�       ]��R�����       WD2@`pp�       �1&!@@@@�       �1&!�       WD2�       [�IJ\R��       �ƘL�U�       �ΘL��VU�       [�IJ5����       WD2pppp�       �1&!@@@@�       �1&!�       ��+B����       ^ߘTXQ���       �ΘL�	sZ�       �ΘL_`ͥ�       ^ߘT%EK_�       ��+Bp___�       �1&!@@@@�       �1&!�       D2UUU�       WD2 �U�       WD2   U�       WD2   U�       WD2 �^U�       �C2TUUU�       �1&!@@@@�  @ ��1&!5V�       �1&!   U�       �1&!   U�       �1&!   U�       �1&!   U�       �1&!   U�       �1&!   U�   ��&�1&!@p\��D     �1F!��       7D�)UUu��       7D�)UU]B�D�@   �1F!_@���       7D�)�%%5�       ��m:�����       ��m:z��
�       7D�)WXX\�       ���1����       ;��J$�,��       ;��J�8��       ���1VVTV�D   �:G!)��U�       7D�) �UU�       7D�) zUU�C    (�:g)hjjU��     �l�1U�-	��     �l�1U_x`��     Y}�1-	�U��      Y}�1x`^U��   �t�1UA�}�       C�:U   �       �B�BUUUUL���?�1]?[remap]

importer="texture"
type="CompressedTexture2D"
uid="uid://b44ygt3c5e30i"
path.s3tc="res://.godot/imported/icon.svg-218a8f2b3041327d8a5756f3a245f83b.s3tc.ctex"
metadata={
"imported_formats": ["s3tc_bptc"],
"vram_texture": true
}
 )�RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    render_priority 
   next_pass    shader    script       Shader    res://player.gdshader ��������      local://ShaderMaterial_863uq 3         ShaderMaterial                                           RSRC2�extends Node3D
class_name Player

var direction = Vector3(1,0,0)
@export var alpha = PI/2
@export var speed = 8
@export var rotation_speed = .8
@export var collision_mutation = PI/16
@export var pos = Vector3(0,0,0)

var autopilot = false
var next_alpha = 0
var next_position = Vector3(0,0,0)


var TAIL = preload("res://tail.tscn")

var T_SPAWN = 0
var T_AUTO = 0
var elapsed = 0

var seek_position = Vector3(0., 0., 0.)
var seek_time = 0

var search_next_target = true

@export var aID = "0"

func _enter_tree():
	set_multiplayer_authority(name.to_int())
	if name.to_int() == 1:
		autopilot = true
	if is_multiplayer_authority():
		init_position()
		set_visible(true)
	
func get_head():
	return $body

func _process(delta):
	T_SPAWN += delta	
	T_AUTO += delta
	elapsed += delta
	if T_SPAWN > 1:
		T_SPAWN = 0
		if is_multiplayer_authority():
			if $tails.get_child_count() < 3:
				spawn_tail()
#			rpc("spawn_tail")
		
func _physics_process(delta):
	if is_multiplayer_authority():
		if autopilot:
			do_autopilot(delta)
		else:
			if Input.is_action_pressed("ui_right"):
				alpha += delta * PI * rotation_speed

			if Input.is_action_pressed("ui_left"):
				alpha -= delta * PI * rotation_speed
			

	direction.x = sin(alpha)
	direction.y = cos(alpha)
	
	$body.basis = Basis().rotated(Vector3.FORWARD, alpha)

	$body.position += direction * delta * speed
	
	if is_multiplayer_authority():
		get_parent().sync_camera_position($body)

	var collision : KinematicCollision3D = $body.move_and_collide(direction * delta * speed, true)

	if collision:
		var collider = collision.get_collider()
		if !collider.get_parent() is Tail || collider.get_parent().head != $body:
			if collider.get_parent() is Food:
				pass
			else:
				alpha = direction.bounce(collision.get_normal()).signed_angle_to(Vector3.UP, Vector3.BACK)
				alpha += randf_range(-collision_mutation, collision_mutation)
				seek_time = 8.1
			if is_multiplayer_authority():
				if collider.get_parent() is Food:
					spawn_tail()
					search_next_target = true
					collider.get_parent().rpc("eaten")
				else:
					if collider.get_parent() is Tail:
						reset_tail()
	
func reset_tail():
	var index = 0
	for n in $tails.get_children():
		if index > 2:
			$tails.remove_child(n)
			n.queue_free()	
		index += 1
	
func spawn_tail():
	var tail = TAIL.instantiate()
	tail.position = $body.position
	tail.next = $body
	tail.head = $body
	if $tails.get_child_count() > 1:
		var next = $tails.get_child($tails.get_child_count() - 1)
		tail.position = next.position
		tail.next = next
		
	tail.next_position = tail.next.position
	tail.position = Vector3(tail.position)
	$tails.add_child(tail, true)
	seek_time = 0

func init_position():
	pos = Vector3(0, randf_range(-8,8), 0)
	$body.position = pos
	
func do_autopilot(delta):
	for food in get_parent().get_children():
		if food is Food:
			if seek_time > 4:
				seek_time += delta
				if seek_time > 10:
					seek_time = 0
				pass
			else:
				if seek_position != food.position:
					seek_time = 0
				else:
					seek_time += delta
				seek_position = food.position
				var n_direction = direction.lerp(food.position - $body.position, delta * rotation_speed)
				var n_angle = n_direction.signed_angle_to(Vector3.UP, Vector3.BACK)
				alpha = n_angle #\ + sin(elapsed)*(PI/2)*delta
				break
l�,�`�~���shader_type spatial;

void fragment() {
	vec2 uv = UV-vec2(cos(TIME*2.)*.02,sin(TIME*2.)*.08);
	uv.y /= 2.;
//eyes	
	float d = abs(length(uv-.15) - .03);
	float d1 = abs(length(uv-vec2(.15, .35)) - .03);

	ALBEDO = max(vec3(.9, .3, .1)*1.7, .01/pow(d, 1.2)*vec3(.1,.9,.3));
	ALBEDO = max(ALBEDO,  .01/pow(d1, 1.2) * vec3(.1, .9, .9));
	
	ROUGHNESS = 0.;

//nose
//	float d3 = abs(length(uv-.22));
//	float d4 = abs(length(uv-vec2(.22, .274)));	
//	ALBEDO = max(ALBEDO, step(d3, .02));
//	ALBEDO = max(ALBEDO, step(d4, .02));
}
!RSRC                    PackedScene            ��������                                            $      ..    .    alpha    speed    body 	   position    visible    resource_local_to_scene    resource_name    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere    script    custom_solver_bias    margin    properties/0/path    properties/0/spawn    properties/0/sync    properties/0/watch    properties/1/path    properties/1/spawn    properties/1/sync    properties/1/watch    properties/2/path    properties/2/spawn    properties/2/sync    properties/2/watch 	   _bundled       Script    res://player.gd ��������   PackedScene    res://tails.tscn f�#��	   Material    res://m_player.tres %ٕ��%      local://SphereMesh_qgdxa M         local://SphereShape3D_0tqjp x         local://SphereMesh_hgl5e �      %   local://SceneReplicationConfig_8cunk �      %   local://SceneReplicationConfig_re4xi �         local://PackedScene_kx2vj /         SphereMesh    
                     SphereShape3D             SphereMesh          ��>      ���>         SceneReplicationConfig                                                                                                              !          "                   SceneReplicationConfig 	                                                                                                PackedScene    #      	         names "         player    script    Node3D    tails    body    collision_mask    StaticBody3D    head 
   transform    cast_shadow    mesh 	   skeleton    MeshInstance3D    shape    CollisionShape3D    OmniLight3D    shadow_enabled    shadow_opacity    omni_range    omni_attenuation 	   eye_left    visible 
   eye_right    MultiplayerSynchronizerRT    replication_config    MultiplayerSynchronizer     MultiplayerSynchronizerInterval    replication_interval    delta_interval    	   variants                                   1�;�  ����%��p?�j0�?��?�>�k����p?                                                         �?              �?              �?    �|�V@         ff�>     �@   ��n=     �?              �?              �?6���Y�z>5��>                     �?              �?              �?�X�>ףp>5��>              �?               node_count    
         nodes     r   ��������       ����                      ���                            ����                          ����         	      
                             ����                          ����            	      
                                ����               
                       ����               
                        ����                           ����                               conn_count              conns               node_paths              editable_instances              version             RSRC[�%!/z��RSRC                    StandardMaterial3D            ��������                                            n      resource_local_to_scene    resource_name    render_priority 
   next_pass    transparency    blend_mode 
   cull_mode    depth_draw_mode    no_depth_test    shading_mode    diffuse_mode    specular_mode    disable_ambient_light    vertex_color_use_as_albedo    vertex_color_is_srgb    albedo_color    albedo_texture    albedo_texture_force_srgb    albedo_texture_msdf 	   metallic    metallic_specular    metallic_texture    metallic_texture_channel 
   roughness    roughness_texture    roughness_texture_channel    emission_enabled 	   emission    emission_energy_multiplier    emission_operator    emission_on_uv2    emission_texture    normal_enabled    normal_scale    normal_texture    rim_enabled    rim 	   rim_tint    rim_texture    clearcoat_enabled 
   clearcoat    clearcoat_roughness    clearcoat_texture    anisotropy_enabled    anisotropy    anisotropy_flowmap    ao_enabled    ao_light_affect    ao_texture 
   ao_on_uv2    ao_texture_channel    heightmap_enabled    heightmap_scale    heightmap_deep_parallax    heightmap_flip_tangent    heightmap_flip_binormal    heightmap_texture    heightmap_flip_texture    subsurf_scatter_enabled    subsurf_scatter_strength    subsurf_scatter_skin_mode    subsurf_scatter_texture &   subsurf_scatter_transmittance_enabled $   subsurf_scatter_transmittance_color &   subsurf_scatter_transmittance_texture $   subsurf_scatter_transmittance_depth $   subsurf_scatter_transmittance_boost    backlight_enabled 
   backlight    backlight_texture    refraction_enabled    refraction_scale    refraction_texture    refraction_texture_channel    detail_enabled    detail_mask    detail_blend_mode    detail_uv_layer    detail_albedo    detail_normal 
   uv1_scale    uv1_offset    uv1_triplanar    uv1_triplanar_sharpness    uv1_world_triplanar 
   uv2_scale    uv2_offset    uv2_triplanar    uv2_triplanar_sharpness    uv2_world_triplanar    texture_filter    texture_repeat    disable_receive_shadows    shadow_to_opacity    billboard_mode    billboard_keep_scale    grow    grow_amount    fixed_size    use_point_size    point_size    use_particle_trails    proximity_fade_enabled    proximity_fade_distance    msdf_pixel_range    msdf_outline_size    distance_fade_mode    distance_fade_min_distance    distance_fade_max_distance    script    
   Texture2D    res://icon.svg �0h޸�7>   !   local://StandardMaterial3D_71wmb &
         StandardMaterial3D                       ��W?	�|>���>  �?$      ff�>%        �?3         4      ff�@D        �?    ���=  �?Q         ?�{,�{,S      ��@T         m      RSRC�]#��8shader_type sky;

void sky() {
	vec2 uv = fract(abs(SCREEN_UV - POSITION.xy/(PI*10.)) * 10.);
	COLOR = max(step(uv.x, .01) * vec3(1.), step(uv.y, .05) * vec3(1.));
	COLOR = vec3(0.2, 0.6, 1.0);

}
n���:$�R�7extends Node3D
class_name Tail

@export var next : Node3D
@export var head : Node3D
@export var next_position = Vector3(0,0,0)

var T = 0
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	index = get_parent().get_child_count()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	T = get_parent().T
#	position.z = sin(index + T) * 0.2;
#	if !next || next.is_queued_for_deletion():
#		return
#	T += delta
#	position = position + (next.position - position) * delta * get_parent().get_parent().speed * .9

@rpc("any_peer")
func despawn():
	get_parent().remove_child(self)
	call_deferred("queue_free")
	
I9�Nz+i�p��shader_type spatial;

void fragment() {
	// Place fragment code here.
	ALBEDO = vec3(.9,.3,.1);
}
oo鳂�%�o�(|ERSRC                    PackedScene            ��������                                                  ..    . 	   position    resource_local_to_scene    resource_name    render_priority 
   next_pass    shader    script    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    radius    height    radial_segments    rings    is_hemisphere    custom_solver_bias    margin    properties/0/path    properties/0/spawn    properties/0/sync    properties/0/watch 	   _bundled       Script    res://tail.gd ��������   Shader    res://tail.gdshader ��������      local://ShaderMaterial_anuew ?         local://SphereMesh_ywh3c �         local://SphereShape3D_p7rmd �      %   local://SceneReplicationConfig_8yde6 �         local://PackedScene_g8j5v F         ShaderMaterial                                             SphereMesh    
                                        SphereShape3D             SceneReplicationConfig                                                         PackedScene          	         names "         tail    script    Node3D    body    collision_layer    StaticBody3D    mesh 	   skeleton    MeshInstance3D    shape    CollisionShape3D    MultiplayerSynchronizer    replication_config    visibility_update_mode    	   variants                                                                            node_count             nodes     1   ��������       ����                            ����                          ����                          
   	   ����   	                        ����                         conn_count              conns               node_paths              editable_instances              version             RSRCextends Node3D

var T = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	T += delta
	var next = get_parent().get_head()
	var c = get_child_count()
	for i in range(1, c):
		var tail = get_child(i)
		if tail is Tail:
			tail.position = tail.position + (next.position - tail.position) * delta * get_parent().speed * .9
			next = tail


func _on_multiplayer_spawner_spawned(node):
	if node.position.length() == 0:
		if get_child_count() < 3:
			node.position = get_parent().get_head().position
		else:	
			node.position = get_child(get_child_count() - 2).position
|�e��}ͬ1�DRSRC                    PackedScene            ��������                                                  ..    resource_local_to_scene    resource_name 	   _bundled    script       Script    res://tails.gd ��������      local://PackedScene_au8i5          PackedScene          	         names "         tails    script    Node3D    MultiplayerSpawner    _spawnable_scenes    spawn_path     _on_multiplayer_spawner_spawned    spawned    	   variants                 "         res://tail.tscn                 node_count             nodes        ��������       ����                            ����                         conn_count             conns                                      node_paths              editable_instances              version             RSRCb��RSRC                    PackedScene            ��������                                                  resource_local_to_scene    resource_name    lightmap_size_hint 	   material    custom_aabb    flip_faces    add_uv2    uv2_padding    size    subdivide_width    subdivide_height    subdivide_depth    script    custom_solver_bias    margin    data    backface_collision    render_priority 
   next_pass    shader    center_offset    orientation 	   _bundled       Shader    res://board.gdshader ��������      local://BoxMesh_rgwfb q      $   local://ConcavePolygonShape3D_e6oif �      $   local://ConcavePolygonShape3D_q5b58       $   local://ConcavePolygonShape3D_vmg4p a      $   local://ConcavePolygonShape3D_udg67 C	         local://ShaderMaterial_50jp0 %         local://PlaneMesh_0iseo l         local://PackedScene_203xl �         BoxMesh            HB   @   @         ConcavePolygonShape3D       #   $     ��  �?  �>  �A  �?  �>  ��  ��  �>  �A  �?  �>  �A  ��  �>  ��  ��  �>  �A  �?  ��  ��  �?  ��  �A  ��  ��  ��  �?  ��  ��  ��  ��  �A  ��  ��  �A  �?  �>  �A  �?  ��  �A  ��  �>  �A  �?  ��  �A  ��  ��  �A  ��  �>  ��  �?  ��  ��  �?  �>  ��  ��  ��  ��  �?  �>  ��  ��  �>  ��  ��  ��  �A  �?  �>  ��  �?  �>  �A  �?  ��  ��  �?  �>  ��  �?  ��  �A  �?  ��  ��  ��  �>  �A  ��  �>  ��  ��  ��  �A  ��  �>  �A  ��  ��  ��  ��  ��         ConcavePolygonShape3D       #   $     ��  �?  �>  �A  �?  �>  ��  ��  �>  �A  �?  �>  �A  ��  �>  ��  ��  �>  �A  �?  ��  ��  �?  ��  �A  ��  ��  ��  �?  ��  ��  ��  ��  �A  ��  ��  �A  �?  �>  �A  �?  ��  �A  ��  �>  �A  �?  ��  �A  ��  ��  �A  ��  �>  ��  �?  ��  ��  �?  �>  ��  ��  ��  ��  �?  �>  ��  ��  �>  ��  ��  ��  �A  �?  �>  ��  �?  �>  �A  �?  ��  ��  �?  �>  ��  �?  ��  �A  �?  ��  ��  ��  �>  �A  ��  �>  ��  ��  ��  �A  ��  �>  �A  ��  ��  ��  ��  ��         ConcavePolygonShape3D       #   $     ��  �?  �>  �A  �?  �>  ��  ��  �>  �A  �?  �>  �A  ��  �>  ��  ��  �>  �A  �?  ��  ��  �?  ��  �A  ��  ��  ��  �?  ��  ��  ��  ��  �A  ��  ��  �A  �?  �>  �A  �?  ��  �A  ��  �>  �A  �?  ��  �A  ��  ��  �A  ��  �>  ��  �?  ��  ��  �?  �>  ��  ��  ��  ��  �?  �>  ��  ��  �>  ��  ��  ��  �A  �?  �>  ��  �?  �>  �A  �?  ��  ��  �?  �>  ��  �?  ��  �A  �?  ��  ��  ��  �>  �A  ��  �>  ��  ��  ��  �A  ��  �>  �A  ��  ��  ��  ��  ��         ConcavePolygonShape3D       #   $     ��  �?  �>  �A  �?  �>  ��  ��  �>  �A  �?  �>  �A  ��  �>  ��  ��  �>  �A  �?  ��  ��  �?  ��  �A  ��  ��  ��  �?  ��  ��  ��  ��  �A  ��  ��  �A  �?  �>  �A  �?  ��  �A  ��  �>  �A  �?  ��  �A  ��  ��  �A  ��  �>  ��  �?  ��  ��  �?  �>  ��  ��  ��  ��  �?  �>  ��  ��  �>  ��  ��  ��  �A  �?  �>  ��  �?  �>  �A  �?  ��  ��  �?  �>  ��  �?  ��  �A  �?  ��  ��  ��  �>  �A  ��  �>  ��  ��  ��  �A  ��  �>  �A  ��  ��  ��  ��  ��         ShaderMaterial                                           
   PlaneMesh                   
      B   B         PackedScene          	         names "         walls    metadata/dimension    Node3D    bottom 
   transform    mesh    MeshInstance3D    StaticBody3D    CollisionShape3D    shape    top    left    right    background    	   variants       
                �?              �?              �?�{,  @��{,                        �?              �?              �?�{,  �A�{,            1�;�  ����%  �?1�;��ɥ��%��%  �?  ���tA�{,            1�;�  ����%  �?1�;��ɥ��%��%  �?  �A�tA�{,              �?    Es��Es��1�;�  ��      �?1�;��{,��A  ��               node_count             nodes     �   ��������       ����                            ����                                ����                     ����   	                     
   ����                                ����                     ����   	                        ����                                ����                     ����   	                        ����                   
             ����                     ����   	   	                     ����      
                   conn_count              conns               node_paths              editable_instances              version             RSRCz,extends Node3D

var camera
var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var food_scene: PackedScene
var mid = 0

var connected = false

var T = 0

func _ready():
	camera = $camera

func _enter_tree():
	var result = _on_host_pressed()
	if result != OK:
		_on_join_pressed()
		
		
func _process(delta):
	T += delta
	$fps.set_text("FPS " + str(Engine.get_frames_per_second()) + ' / Items: ' + str(get_child_count()))
	if connected:
		if multiplayer.is_server():
			if T > 2:
				spawn_food()
				T = 0
			
func _on_host_pressed():
	var success = peer.create_server(4022)
	
	if success == OK:
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(_add_player)
		mid = multiplayer.get_unique_id()
		$label_type.set_text("SERVER: " + str(mid))
		_init_server()
		_add_player()
		moveWindow()
		connected = true
		
	return success
	
func _init_server():
	print('Init Server!')


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	
func _on_join_pressed():
	peer.create_client("localhost", 4022)
	multiplayer.multiplayer_peer = peer
	mid = multiplayer.get_unique_id()
	$label_type.set_text("CLIENT: " + str(mid))
	connected = true

func moveWindow():
	get_window().position = Vector2(1150,0)

func get_type():
	return $label_type.get_text()


func spawn_food():
	var one = food_scene.instantiate()
	one.set_multiplayer_authority(1)
	call_deferred("add_child", one, true)

func sync_camera_position(body):
#	$camera.position = Vector3(body.position.x, body.position.y, camera.position.z)
	$camera.position = Vector3(min(6.2, max(-6.2, body.position.x)), min(20.5, max(-4, body.position.y)), camera.position.z)
�}hQt,�RSRC                    PackedScene            ��������                                                  ..    resource_local_to_scene    resource_name    line_spacing    font 
   font_size    font_color    outline_size    outline_color    shadow_size    shadow_color    shadow_offset    script 	   _bundled       Script    res://world.gd ��������   PackedScene    res://player.tscn dsֱ}�<;   PackedScene    res://food.tscn ���?�v0   PackedScene    res://walls.tscn _tx袪1Q      local://LabelSettings_6md4k I         local://PackedScene_c4crn s         LabelSettings          0            PackedScene          	         names "         world    script    player_scene    food_scene    Node3D    light 
   transform    light_energy    light_indirect_energy    shadow_enabled 	   sky_mode    DirectionalLight3D    camera    size 	   Camera3D    walls    MultiplayerSpawner    _spawnable_scenes    spawn_path    fps    offset_left    offset_top    offset_right    offset_bottom    text    label_settings    Label    label_type    horizontal_alignment    	   variants                                      �JW�4
�U�=�8���?'�;?¾վ��?�-��u?    �� A      @   ��P@                 �?              �?              �?        ��HA     �A         "         res://player.tscn    res://food.tscn                @A      A     �C     �B      FPS               �2D     �D     �B            node_count             nodes     c   ��������       ����                                        ����                     	      
                        ����            	               ���   
                         ����                                 ����                                                         ����                                                       conn_count              conns               node_paths              editable_instances              version             RSRC�=	��D�$/]�[remap]

path="res://.godot/exported/133200997/export-4cfa184f3667b66afc932584b1bf2358-clear_sky.res"
]�y�<M��[remap]

path="res://.godot/exported/133200997/export-9c8493a753c42d45460d9b93900e0179-food.scn"
�ȸb6�S��1˽�[remap]

path="res://.godot/exported/133200997/export-72e228c7f6bf196d70e576847011330f-m_player.res"
�S	I���~���[remap]

path="res://.godot/exported/133200997/export-36a25e342948d0ceacc500772b5412b3-player.scn"
>'ÉPXN|�iiV[remap]

path="res://.godot/exported/133200997/export-0783e7cbf2b0a1e6505b5629fa6c9082-player_texture.res"
�ʐ
[remap]

path="res://.godot/exported/133200997/export-4fe1464105c47ebb93ca2be69ccaeb47-tail.scn"
�r]�7�E����0�[remap]

path="res://.godot/exported/133200997/export-d5e193774c5ee8e412d6b0813a27ef0b-tails.scn"
_ q�T�?�N �x�[remap]

path="res://.godot/exported/133200997/export-6f9b3841ff273fd663e4d807c75f8c65-walls.scn"
�z�a�$���r�[remap]

path="res://.godot/exported/133200997/export-76e0adcbc83681695885bae615f516ae-world.scn"
%O{���̺����X�list=Array[Dictionary]([{
"base": &"Node3D",
"class": &"Food",
"icon": "",
"language": &"GDScript",
"path": "res://food.gd"
}, {
"base": &"Node3D",
"class": &"Player",
"icon": "",
"language": &"GDScript",
"path": "res://player.gd"
}, {
"base": &"Node3D",
"class": &"Tail",
"icon": "",
"language": &"GDScript",
"path": "res://tail.gd"
}])
x�&���?iaJA��<svg height="128" width="128" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="2" width="124" height="124" rx="14" fill="#363d52" stroke="#212532" stroke-width="4"/><g transform="scale(.101) translate(122 122)"><g fill="#fff"><path d="M105 673v33q407 354 814 0v-33z"/><path fill="#478cbf" d="m105 673 152 14q12 1 15 14l4 67 132 10 8-61q2-11 15-15h162q13 4 15 15l8 61 132-10 4-67q3-13 15-14l152-14V427q30-39 56-81-35-59-83-108-43 20-82 47-40-37-88-64 7-51 8-102-59-28-123-42-26 43-46 89-49-7-98 0-20-46-46-89-64 14-123 42 1 51 8 102-48 27-88 64-39-27-82-47-48 49-83 108 26 42 56 81zm0 33v39c0 276 813 276 813 0v-39l-134 12-5 69q-2 10-14 13l-162 11q-12 0-16-11l-10-65H447l-10 65q-4 11-16 11l-162-11q-12-3-14-13l-5-69z"/><path d="M483 600c3 34 55 34 58 0v-86c-3-34-55-34-58 0z"/><circle cx="725" cy="526" r="90"/><circle cx="299" cy="526" r="90"/></g><g fill="#414042"><circle cx="307" cy="532" r="60"/><circle cx="717" cy="532" r="60"/></g></g></svg>
|�xs��^�K
   ]��7�JZ   res://clear_sky.tres���?�v0   res://food.tscn�0h޸�7>   res://icon.svg%ٕ��%   res://m_player.tresdsֱ}�<;   res://player.tscnz�3.��Cj   res://player_texture.tres�a�ru�o   res://tail.tscnf�#��   res://tails.tscn_tx袪1Q   res://walls.tscn��Ue�fy   res://world.tscn�'���O�ECFG      application/config/name         Snake World    application/run/main_scene         res://world.tscn   application/config/features   "         4.1    Mobile     application/config/icon         res://icon.svg  !   display/window/size/always_on_top         #   rendering/renderer/rendering_method         mobile  ��欄��pY