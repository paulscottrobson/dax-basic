# *****************************************************************************
# *****************************************************************************
#
#		Name:		definitions.rb
#		Author:		Paul Robson (paul@robsons.org.uk)
#		Date:		1st April 2022
#		Reviewed: 	No
#		Purpose:	Class for substitute definitions.
#
# *****************************************************************************
# *****************************************************************************

# *****************************************************************************
#
#  					Class encapsulating standard ROM
#
# *****************************************************************************

class StandardROM
	def initialize(binary_file)
		@data = open(binary_file,"rb").each_byte.collect { |a| a }
	end 

	def export_include(include_file)
		bytes = @data.collect { |b| b.to_s }.join(",")
		open(include_file,"w").write(bytes+"\n")
		self
	end

	def export_binary(binary_file) 
		h = open(binary_file,"wb")
		@data.each { |b| h.write(b.chr) }
		self 
	end
	#
	# 		Import CH8 font file replacing stock Aquarius font, char rom only
	#
	def import_font(font_file)
		font = open(font_file,"rb").each_byte.collect { |a| a }
		(0..font.length-1-8).each { |n| @data[n+32*8] = font[n] }
		self
	end
end

# *****************************************************************************
#
#  					Class encapsulating encrypted ROM
#
# *****************************************************************************

class EncodedROM < StandardROM
	def initialize(binary_file)
		super
		decode_rom_image
	end 

	def decode_rom_image
		check_signature_match
		xor = calculate_signature
		@data = @data.collect { |a| a ^ xor }
		rom_ident = [ 0x9C,0xB0,0x6C,0x64,0xA8,0x70 ]
		(0..5).each { |i| @data[0x2005+i*2] = rom_ident[i] }
	end 

	def check_signature_match 	
		decode_table = [43,55,36,36,51,44]
		(0..5).each do |e|
			byte = decode_table[e] - @data[0x200F-e*2]/4
			raise "Not an encrypted ROM " if byte != 15-e*2
		end
	end

	def calculate_signature
		total = 78 
		(3..14).each { |a| total = total + @data[0x2000+a]  }
		(total & 0xFF) ^ @data[0x200F]		
	end

end 

# *****************************************************************************
#
# 						Kernel ROM with patches
#
# *****************************************************************************

class KernelROM < StandardROM
	def initialize(binary_file)
		super
		general_patches
		keyboard_patches
		tape_input_patches
		new_prompt
	end

	#
	# 		General changes to the ROM.
	#
	def general_patches
		#
		# 		Patches a CALL xxxx to a dummy LD HL,xxxx to disable the initial boot up beep.
		#
		patch(0x50,0x21)
		#
		# 		Disables the beep entirely. Changes CALL xxxx to a dummy LD DE,xxxx
		#
		patch(0x1E1A,0x11)
		#
		# 		Skips the start screen, always Cold Starts 	JMP $00FD (Cold Start)
		#
		patch(0x89,0xC3)
		patch(0x8A,0xFD)
		patch(0x8B,0x00)
		#
		# 		Disables printing
		#
		patch(0x1AE8,0xC9)
		#
		# 		Disables Poke/Peek limits
		#
		patch(0x0B88,0xC9)
		#
	end

	#
	# 		Patch in new prompt.
	#
	def new_prompt
		patch(0x1FF2,0xED)
		patch(0x1FF3,0xF3)
		patch(0x1FF4,0x00)
	end
	#
	# 		Patch shifted characters to approximately match a standard PC keyboard rather than an Aquarius one.
	#
	def keyboard_patches
		key_fixes = {
			"6"=>"^",
			"7"=>"&",
			"8"=>"*",
			"9"=>"(",
			"0"=>")",
			"/"=>"?",
			";"=>":",
			":"=>"@" 																# note colon is a seperate key, we use the single quote.
		}
		key_fixes.each { |unshift,shift| patch_keyboard(unshift,shift) }
	end

	#
	# 		Fix Tape stuff so Set Name,Header Read and Byte Read work with pseudo-instructions that do the work
	# 		of whole Aquarius subroutines
	#
	def tape_input_patches
		#
		# 		Replace Skip Header routine
		#
		patch(0x1BCE,0xED);
		patch(0x1BCF,0xF0);
		patch(0x1BD0,0xC9);
		#
		# 		Replace Read byte routine
		#
		patch(0x1B4D,0xED);
		patch(0x1B4E,0xF1);
		patch(0x1B4F,0xC9);	
		#
		# 		Patch 'give name' routine
		#	
		patch(0x1C4B,0xED);
		patch(0x1C4C,0xF2);
		patch(0x1C4D,0x00);	
		#
		# 		Disable the Tape Load, Hit any Key routine, which isn't needed.
		#
		patch(0x1B2E,0xC9);
		#
		# 		Stop printing "Found" files
		#
		patch(0x1c6f,0x21);	
	end 	
	#
	# 		Patch ROM byte
	#
	def patch(addr,byte)
		@data[addr] = byte 
	end
	#
	# 		Patch keyboard shift/unshift table.
	#
	def patch_keyboard(unshift,shift)
		unshift_table = 0x1F38 														# table of unshifted characters
		shift_table = 0x1F66  														# table of shifted characters
		table_size = 0x1F66-0x1F38 	 												# table length.
		fixed = false
		(0..table_size-1).each do |p|
			if @data[unshift_table+p] == unshift.ord
				@data[shift_table+p] = shift.ord 
				fixed = true
			end
		end
		raise "Couldn't find unshifted #{unshift}" unless fixed
	end
end 

class CharacterROM < StandardROM
	def initialize(binary_file)
		super
		base = 0xA5 * 8
		@data[base+6] = 0
		@data[base+7] = 0
	end
end

if __FILE__ == $0 
	CharacterROM.new("aquarius.chr").import_font("carton.ch8").export_include("character_rom.h")
	KernelROM.new("aquarius.rom").export_include("kernel_rom.h")
end
