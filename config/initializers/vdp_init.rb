
module VDP
	class Init
		attr_accessor :data

		def initialize
			@data = gen_vdp_hash
		end

		def self.build
			vdp = VDP::Init.new
			vdp.add_image_numbers

			vdp
		end

		def gen_vdp_hash
			{
				meta: 
				{
					cover_images: [1,2,3],
					names: { 
						bride: 4,
						groom: 5,
						title: 6
					},
					images: (7..120).to_a
				},
				organization: 
				{
					"column_1"=>"Cover_Image1",
					"column_2"=>"Cover_Image2",
					"column_3"=>"Cover_Image3",
					"column_4"=>"BrideName",
					"column_5"=>"GroomName",
					"column_6"=>"BookTitle",
					"column_7"=>"2_1",
					"column_8"=>"3_1",
					"column_9"=>"3_2",
					"column_10"=>"3_3",
					"column_11"=>"4_1",
					"column_12"=>"4_2",
					"column_13"=>"4_3",
					"column_14"=>"5_1",
					"column_15"=>"5_2",
					"column_16"=>"5_3",
					"column_17"=>"6_1",
					"column_18"=>"7_1",
					"column_19"=>"7_2",
					"column_20"=>"7_3",
					"column_21"=>"8_1",
					"column_22"=>"8_2",
					"column_23"=>"8_3",
					"column_24"=>"9_1",
					"column_25"=>"9_2",
					"column_26"=>"9_3",
					"column_27"=>"9_4",
					"column_28"=>"10_1",
					"column_29"=>"10_2",
					"column_30"=>"10_3",
					"column_31"=>"10_4",
					"column_32"=>"11_1",
					"column_33"=>"12_1",
					"column_34"=>"12_2",
					"column_35"=>"12_3",
					"column_36"=>"13_1",
					"column_37"=>"13_2",
					"column_38"=>"13_3",
					"column_39"=>"13_4",
					"column_40"=>"14_1",
					"column_41"=>"14_2",
					"column_42"=>"14_3",
					"column_43"=>"15_1",
					"column_44"=>"15_2",
					"column_45"=>"15_3",
					"column_46"=>"15_4",
					"column_47"=>"16_1",
					"column_48"=>"16_2",
					"column_49"=>"16_3",
					"column_50"=>"16_4",
					"column_51"=>"17_1",
					"column_52"=>"17_2",
					"column_53"=>"17_3",
					"column_54"=>"17_4",
					"column_55"=>"18_1",
					"column_56"=>"18_2",
					"column_57"=>"18_3",
					"column_58"=>"18_4",
					"column_59"=>"19_1",
					"column_60"=>"20_1",
					"column_61"=>"20_2",
					"column_62"=>"20_3",
					"column_63"=>"21_1",
					"column_64"=>"21_2",
					"column_65"=>"21_3",
					"column_66"=>"21_4",
					"column_67"=>"22_1",
					"column_68"=>"22_2",
					"column_69"=>"22_3",
					"column_70"=>"22_4",
					"column_71"=>"23_1",
					"column_72"=>"23_2",
					"column_73"=>"23_3",
					"column_74"=>"23_4",
					"column_75"=>"24_1",
					"column_76"=>"24_2",
					"column_77"=>"24_3",
					"column_78"=>"24_4",
					"column_79"=>"25_1",
					"column_80"=>"25_2",
					"column_81"=>"25_3",
					"column_82"=>"26_1",
					"column_83"=>"26_2",
					"column_84"=>"26_3",
					"column_85"=>"27_1",
					"column_86"=>"27_2",
					"column_87"=>"27_3",
					"column_88"=>"28_1",
					"column_89"=>"28_2",
					"column_90"=>"28_3",
					"column_91"=>"29_1",
					"column_92"=>"30_1",
					"column_93"=>"30_2",
					"column_94"=>"30_3",
					"column_95"=>"30_4",
					"column_96"=>"31_1",
					"column_97"=>"31_2",
					"column_98"=>"31_3",
					"column_99"=>"31_4",
					"column_100"=>"32_1",
					"column_101"=>"32_2",
					"column_102"=>"32_3",
					"column_103"=>"33_1",
					"column_104"=>"33_2",
					"column_105"=>"33_3",
					"column_106"=>"34_1",
					"column_107"=>"34_2",
					"column_108"=>"34_3",
					"column_109"=>"34_4",
					"column_110"=>"35_1",
					"column_111"=>"35_2",
					"column_112"=>"35_3",
					"column_113"=>"35_4",
					"column_114"=>"36_1",
					"column_115"=>"36_2",
					"column_116"=>"36_3",
					"column_117"=>"36_4",
					"column_118"=>"37_1",
					"column_119"=>"37_2",
					"column_120"=>"37_3"
				}
			}
		end

		def add_image_numbers
			unless @data.nil?
				@data[:meta][:no_of_images] = @data[:meta][:cover_images].length + @data[:meta][:images].length
			end
		end

		def build_header_row
			@data[:organization].values.reduce(Array.new) { |acc, val| acc << val }
		end
	end
end

VDP_FORMAT = VDP::Init.build
