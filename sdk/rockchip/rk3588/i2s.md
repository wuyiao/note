# i2s左右对齐、大小端及主从关系配置-《Rockchip_Developer_Guide_Audio_CN》

	dummy_codec: dummy-codec {
 		status = "okay";
 		compatible = "rockchip,dummy-codec";
 		#sound-dai-cells = <0>;
		pinctrl-names = "default";
		pinctrl-0 = <&i2s1m0_mclk>;
	};

	i2s1_sound: i2s1-sound {
		compatible = "simple-audio-card";
		simple-audio-card,format = "i2s";
		simple-audio-card,name = "rockchip,i2s1-codec";
		simple-audio-card,bitclock-master = <&master_codec>;
		simple-audio-card,frame-master = <&master_codec>;//master_codec做主提供位时钟和帧时钟

		simple-audio-card,cpu {
			sound-dai = <&i2s1_8ch>; //配置i2s1为slave
		};

		master_codec: simple-audio-card,codec {
			sound-dai = <&dummy_codec>;//配置dummy_codec为主
		};
	};
