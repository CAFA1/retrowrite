#long
import os
import sys
sys.path.append(os.getcwd())

import argparse
from collections import defaultdict

from capstone import CS_OP_IMM, CS_GRP_JUMP, CS_GRP_CALL, CS_OP_MEM, CS_OP_REG
from capstone.x86_const import X86_REG_RIP

from elftools.elf.descriptions import describe_reloc_type
from elftools.elf.enums import ENUM_RELOC_TYPE_x64
#long
import r2pipe 
import json
import IPython
import string

class Rewriter():
	GCC_FUNCTIONS = [
		"_start",
		"__libc_start_main",
		"__libc_csu_fini",
		"__libc_csu_init",
		"__lib_csu_fini",
		"_init",
		"__libc_init_first",
		"_fini",
		"_rtld_fini",
		"_exit",
		"__get_pc_think_bx",
		"__do_global_dtors_aux",
		"__gmon_start",
		"frame_dummy",
		"__do_global_ctors_aux",
		"__register_frame_info",
		"deregister_tm_clones",
		"register_tm_clones",
		"__do_global_dtors_aux",
		"__frame_dummy_init_array_entry",
		"__init_array_start",
		"__do_global_dtors_aux_fini_array_entry",
		"__init_array_end",
		"__stack_chk_fail",
		"__cxa_atexit",
		"__cxa_finalize",
	]
	#long
	#DATASECTIONS = [".rodata", ".data", ".bss", ".data.rel.ro", ".init_array"]
	DATASECTIONS = [".text",".rodata", ".data", ".bss", ".data.rel.ro", ".init_array"]
	def __init__(self, fname, container, outfile):
		#long
		self.r2 = r2pipe.open(fname)
		self.r2.cmd("aaa") 

		self.container = container
		self.outfile = outfile

		for sec, section in self.container.sections.items():
			section.load()

		for _, function in self.container.functions.items():
			if function.name in Rewriter.GCC_FUNCTIONS:
				continue
			function.disasm()

	def symbolize(self):
		symb = Symbolizer()
		symb.symbolize_text_section(self.container, None)
		symb.symbolize_data_sections(self.container, None)
	#long
	def is_in_list(self,addr,init_call_funcs_list):
		for init_call in init_call_funcs_list:
			if(addr>=init_call[0] and addr<=init_call[1]):
				return True
		return False
	def dump(self):
		results = list()
		text_base = self.container.sections['.text'].base
		text_size = self.container.sections['.text'].sz
		for sec, section in sorted(
				self.container.sections.items(), key=lambda x: x[1].base):
			#long
			if(section.name != '.text'):
				results.append("%s" % (section))

		#long
		results.append("	.section\t.text")
		results.append(".align 16")
		#long find call .init section function
		init_call_funcs_list=list()
		for (call_site,target_str) in self.container.missed_call_list:
			func1 = self.r2.cmd('afij '+hex(call_site))
			print('missed_call_site: '+hex(call_site))
			func1_json = json.loads(func1)
			if(func1_json!=[]):
				print('ignore func: '+hex(func1_json[0]['offset']),hex(func1_json[0]['size']))
				init_call_funcs_list.append((func1_json[0]['offset'],func1_json[0]['offset']+func1_json[0]['size']))
			else:
				#init func
				try:
					target_int = int(target_str,16)
					if self.container.is_in_section(".init", target_int):
						init_sig_start = b'\x41\x57\x41\x56\x41\x89\xff\x41\x55\x41\x54\x4c'
						init_sig_end = b'\x48\x83\xc4\x08\x5b\x5d\x41\x5c\x41\x5d\x41\x5e\x41\x5f\xc3'

						init_sig_start_pos = self.container.sections['.text'].bytes.find(init_sig_start,call_site-55-text_base,call_site-text_base)
						end_pos =   (text_base+ text_size) if (call_site+62)>(text_base+ text_size) else (call_site+62)
						init_sig_end_pos = self.container.sections['.text'].bytes.find(init_sig_end,call_site-text_base,end_pos-text_base)
						assert init_sig_start_pos!=-1 and init_sig_end_pos!=-1
						init_call_funcs_list.append((init_sig_start_pos+text_base,init_sig_end_pos+text_base+len(init_sig_end)))

				except Exception as e:
					pass
				
				
				

		#long find main
		last_instruction = self.container.disa_list[0]
		mov_main_instruction = last_instruction
		for instruction in self.container.disa_list:
			if(instruction.mnemonic.startswith('call') and instruction.op_str.startswith('__libc_start_main')):
				mov_main_instruction=last_instruction
			last_instruction=instruction

		#movq $0x400687, %rdi
		main_address=0
		if(mov_main_instruction.mnemonic.startswith('mov')):
			main_address=int(mov_main_instruction.op_str.split(',')[0][3:],16)
		assert main_address!=0

		for instruction in self.container.disa_list:
			
			if(instruction.address==main_address):
				results.append('.globl main\nmain:\n')
			#long init call
			#init_call
			if(self.is_in_list(instruction.address,init_call_funcs_list)):
				continue

			if(instruction.address in self.container.tags_set):
				results.append(".L%x:" % (instruction.address))
				results.append(".LC%x:" % (instruction.address))
			else:
				results.append(".LC%x:" % (instruction.address))
			results.append("\t%s %s" % (instruction.mnemonic,instruction.op_str))
			

		with open(self.outfile, 'w') as outfd:
			outfd.write("\n".join(results + ['']))


class Symbolizer():
	def __init__(self):
		self.bases = set()
		self.pot_sw_bases = defaultdict(set)
		self.symbolized = set()

	# TODO: Use named symbols instead of generic labels when possible.
	# TODO: Replace generic call labels with function names instead
	def symbolize_text_section(self, container, context):
		# Symbolize using relocation information.
		for rel in container.relocations[".text"]:
			fn = container.function_of_address(rel['offset'])
			if not fn or fn.name in Rewriter.GCC_FUNCTIONS:
				continue

			inst = fn.instruction_of_address(rel['offset'])
			if not inst:
				continue

			# Fix up imports
			if "@" in rel['name']:
				suffix = ""
				if rel['st_value'] == 0:
					suffix = "@PLT"

				if len(inst.cs.operands) == 1:
					inst.op_str = "%s%s" % (rel['name'].split("@")[0], suffix)
				else:
					# Figure out which argument needs to be
					# converted to a symbol.
					if suffix:
						suffix = "@PLT"
					mem_access, _ = inst.get_mem_access_op()
					if not mem_access:
						continue
					value = hex(mem_access.disp)
					inst.op_str = inst.op_str.replace(
						value, "%s%s" % (rel['name'].split("@")[0], suffix))
			else:
				mem_access, _ = inst.get_mem_access_op()
				if not mem_access:
					# These are probably calls?
					continue

				if (rel['type'] in [
						ENUM_RELOC_TYPE_x64["R_X86_64_PLT32"],
						ENUM_RELOC_TYPE_x64["R_X86_64_PC32"]
				]):

					value = mem_access.disp
					ripbase = inst.address + inst.sz
					inst.op_str = inst.op_str.replace(
						hex(value), ".LC%x" % (ripbase + value))
					if ".rodata" in rel["name"]:
						self.bases.add(ripbase + value)
						self.pot_sw_bases[fn.start].add(ripbase + value)
				else:
					print("[*] Possible incorrect handling of relocation!")
					value = mem_access.disp
					inst.op_str = inst.op_str.replace(
						hex(value), ".LC%x" % (rel['st_value']))

			self.symbolized.add(inst.address)

		self.symbolize_cf_transfer(container, context)
		#long
		self.symbolize_text_long(container, context)
		# Symbolize remaining memory accesses
		self.symbolize_mem_accesses(container, context)
		self.symbolize_switch_tables(container, context)
		self.symbolize_switch_tables_long(container, context)
		self.symbolize_data_long(container, context)
		self.symbolize_rodata_long(container, context)
		
		
	def int_printable(self,int1):
		if(int1<0):
			return False
		int1_str_hex=hex(int1)[2:]
		len_bytes = len(int1_str_hex)
		if(len_bytes % 2 != 0):
			return False
		#len_bytes = len_bytes//2
		for i in range(0,len_bytes,2):
			byte_int = int(int1_str_hex[i:i+2],16)
			byte_char = chr(byte_int)
			if(byte_char not in string.printable):
				return False
		return True
	def symbolize_mov_imm(self, container,instruction):
		if instruction.mnemonic.startswith('mov'):
			if(instruction.cs.operands[0].type == CS_OP_IMM) :
				target = instruction.cs.operands[0].imm
				#str
				if(self.int_printable(target)):
					if(container.is_in_section(".rodata", target) and not self.rodata_is_string(container,target)):
						return False
					elif(not container.is_in_section(".rodata", target)):
						return False

				# Check if the target is in .text section.
				if container.is_in_section(".text", target):
					container.tags_set.add(target)
					instruction.op_str = instruction.op_str.replace(hex(target),".L"+hex(target)[2:]) #add tag!!!!
				elif container.is_in_section(".rodata", target):
					instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				elif container.is_in_section(".data", target):
					instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				elif container.is_in_section(".bss", target):
					instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!

				#print("mov: 0x%x:\t%s\t%s" % (instruction.address, instruction.mnemonic, instruction.op_str))
				return True

		else:
			return False
	#
	def symbolize_mov_imm_mem(self, container,instruction):
		#movq 0x400888(, %rax, 8), %rax
		if instruction.mnemonic.startswith('mov') and instruction.cs.operands[0].type == CS_OP_IMM and instruction.cs.operands[1].type == CS_OP_MEM:
			target = instruction.cs.operands[1].mem.disp
			
			if container.is_in_section(".rodata", target) or container.is_in_section(".data", target) or container.is_in_section(".bss", target):
				instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				return True
		return False
	
	def symbolize_mov_mem_reg(self, container,instruction):
		#movq 0x400888(, %rax, 8), %rax
		if instruction.mnemonic.startswith('mov') and instruction.cs.operands[0].type == CS_OP_MEM and instruction.cs.operands[1].type == CS_OP_REG:
			target = instruction.cs.operands[0].mem.disp
			if container.is_in_section(".rodata", target):
				instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				container.switch_addrs_set.add(target)
				return True
			if container.is_in_section(".data", target) or container.is_in_section(".bss", target):
				instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				return True
		#movq %rax, 0x400888(, %rax, 8)
		elif instruction.mnemonic.startswith('mov') and instruction.cs.operands[0].type == CS_OP_REG and instruction.cs.operands[1].type == CS_OP_MEM:
			target = instruction.cs.operands[1].mem.disp
			if container.is_in_section(".rodata", target) or container.is_in_section(".data", target) or container.is_in_section(".bss", target):
				instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				return True
		return False
	#long: jmpq	*0x4994e0(, %rax, 8)
	def symbolize_jmp_switch(self, container,instruction):
		if instruction.mnemonic.startswith('jmp') and len(instruction.cs.operands)==1 and instruction.cs.operands[0].type==CS_OP_MEM:
			if instruction.cs.operands[0].mem.scale == 8:
				target = instruction.cs.operands[0].mem.disp
				if container.is_in_section(".rodata", target):
					instruction.op_str = instruction.op_str.replace(hex(target),".LC"+hex(target)[2:]) #add tag!!!!
				
					#print("jmp off(): 0x%x:\t%s\t%s" % (instruction.address, instruction.mnemonic, instruction.op_str))
					container.switch_addrs_set.add(target)
					return True

		return False
	#long
	def symbolize_cf_transfer(self, container, context=None):
		for instruction in container.disa_list:
			
			is_jmp = CS_GRP_JUMP in instruction.cs.groups
			is_call = CS_GRP_CALL in instruction.cs.groups
			if not (is_jmp or is_call):
				continue
			if instruction.cs.operands[0].type == CS_OP_IMM:
				target = instruction.cs.operands[0].imm
				# Check if the target is in .text section.
				if container.is_in_section(".text", target):
					container.tags_set.add(target)
					instruction.op_str = ".L%x" % (target) #add tag!!!!
				elif target in container.plt:
					instruction.op_str = "{}@PLT".format(
						container.plt[target])
					#long: omit _start function
					if(instruction.op_str.startswith('__libc_start_main')):
						container.missed_call_list.append((instruction.address,instruction.op_str))
				else:
					#long
					#print('this instruction: '+hex(instruction.address))
					container.missed_call_list.append((instruction.address,instruction.op_str))
					gotent = container.is_target_gotplt(target)
					if gotent:
						found = False
						for relocation in container.relocations[".dyn"]:
							if gotent == relocation['offset']:
								instruction.op_str = "{}@PLT".format(
									relocation['name'])
								found = True
								break
						if not found:
							print("[x] Missed GOT entry!")
					else:
						
						print("[x] Missed call target: %x" % (target))
				#print("0x%x:\t%s\t%s" % (instruction.address, instruction.mnemonic, instruction.op_str))
				

	def symbolize_switch_tables(self, container, context):
		rodata = container.sections.get(".rodata", None)
		if not rodata:
			return
		all_bases = container.rodata_tags_set
		for swbase in sorted(all_bases, reverse=True):
			value = rodata.read_at(swbase, 4)
			if not value:
				continue

			value = (value + swbase) & 0xffffffff
			if not container.is_in_section(".text", value):
				continue
			if value not in container.inst_addrs_set:
				continue

			# We have a valid switch base now.
			swlbl = ".LC%x-.LC%x" % (value, swbase)
			#print ('swlbl: '+swlbl+'\n')
			rodata.replace(swbase, 4, swlbl)

			# Symbolize as long as we can
			for slot in range(swbase + 4, rodata.base + rodata.sz, 4):
				if any([x in all_bases for x in range(slot, slot + 4)]):
					break

				value = rodata.read_at(slot, 4)
				if not value:
					break
				value = (value + swbase) & 0xFFFFFFFF
				if not container.is_in_section(".text", value):
					break
				if value not in container.inst_addrs_set:
					break

				swlbl = ".LC%x-.LC%x" % (value, swbase)
				#print ('swlbl: '+swlbl+'\n')
				rodata.replace(slot, 4, swlbl)
	def symbolize_switch_tables_long(self, container, context):
		rodata = container.sections.get(".rodata", None)
		
		if not rodata:
			return
		all_bases = container.switch_addrs_set
		for swbase in sorted(all_bases, reverse=True):
			value = rodata.read_at_qword(swbase, 8)
			if not value:
				continue

			value = value  & 0xffffffffffffffff
			if not container.is_in_section(".text", value):
				continue
			if value not in container.inst_addrs_set:
				continue

			# We have a valid switch base now.
			swlbl = ".LC%x" % value
			#print ('long switch: '+swlbl+'\n')
			rodata.replace(swbase, 8, swlbl)

			# Symbolize as long as we can
			for slot in range(swbase + 8, rodata.base + rodata.sz, 8):
				if slot in all_bases:
					break

				value = rodata.read_at_qword(slot, 8)
				if not value:
					break
				value = value  & 0xffffffffffffffff
				if not container.is_in_section(".text", value):
					break
				if value not in container.inst_addrs_set:
					break

				swlbl = ".LC%x" % value
				#print ('long switch: '+swlbl+'\n')
				rodata.replace(slot, 8, swlbl)
	def char_printable(self,char1):
		if chr(char1[0]) in string.printable:
			return True
		return False
	def rodata_is_string(self,container,value):
		rodata = container.sections.get(".rodata", None)
		rodata_section = container.sections['.rodata']
		max_string = 30
		count_string = 0 
		final_count = 0
		badchars = 0
		for i in range(0,max_string):
			value1 = rodata.read_at_byte(value+i)
			if(value1==0):
				return False
			if(self.char_printable(value1)):
				count_string = count_string+1
			elif(value1[0]==0):
				final_count = count_string
				break
			else:
				badchars = 1
				break
		if(final_count>=0 and final_count<max_string and badchars==0): #null chars
			return True
		else:
			return False

	def symbolize_data_long(self, container, context):
		data = container.sections.get(".data", None)
		data_section = container.sections['.data']
		if not data:
			return
		for swbase in range(0,data_section.sz,1):
			#print('data processing '+str(swbase)+' --> '+str(data_section.sz))
			value = data.read_at_qword_offset(swbase, 8)
			if not value:
				continue
			value = value  & 0xffffffffffffffff
			if  container.is_in_section(".text", value) and (value in container.inst_addrs_set):
				# We have a valid switch base now.
				swlbl = ".LC%x" % value
				#print ('data switch: '+swlbl+'\n')
				data.replace_offset(swbase, 8, swlbl)
			elif container.is_in_section(".rodata", value):
				#print('rodata: '+hex(swbase+data_section.base))
				if(self.rodata_is_string(container,value)):
					swlbl = ".LC%x" % value
					#print ('data ref rodata: '+hex(swbase+data_section.base)+' '+swlbl)
					data.replace_offset(swbase, 8, swlbl)
			elif container.is_in_section(".data", value):
				#print('rodata: '+hex(swbase+data_section.base))
				swlbl = ".LC%x" % value
				#print ('data ref rodata: '+hex(swbase+data_section.base)+' '+swlbl)
				data.replace_offset(swbase, 8, swlbl)
			elif container.is_in_section(".bss", value):
				#print('rodata: '+hex(swbase+data_section.base))
				swlbl = ".LC%x" % value
				#print ('data ref rodata: '+hex(swbase+data_section.base)+' '+swlbl)
				data.replace_offset(swbase, 8, swlbl)
	def symbolize_rodata_long(self, container, context):
		data = container.sections.get(".rodata", None)
		data_section = container.sections['.rodata']
		if not data:
			return
		for swbase in range(0,data_section.sz,1):
			#print('data processing '+str(swbase)+' --> '+str(data_section.sz))
			value = data.read_at_qword_offset(swbase, 8)
			if not value:
				continue
			value = value  & 0xffffffffffffffff
			if  container.is_in_section(".text", value) and (value in container.inst_addrs_set):
				# We have a valid switch base now.
				swlbl = ".LC%x" % value
				#print ('data switch: '+swlbl+'\n')
				data.replace_offset(swbase, 8, swlbl)
			elif container.is_in_section(".rodata", value):
				#print('rodata: '+hex(swbase+data_section.base))
				if(self.rodata_is_string(container,value)):
					swlbl = ".LC%x" % value
					#print ('data ref rodata: '+hex(swbase+data_section.base)+' '+swlbl)
					data.replace_offset(swbase, 8, swlbl)
			elif container.is_in_section(".data", value):
				#print('rodata: '+hex(swbase+data_section.base))
				swlbl = ".LC%x" % value
				#print ('data ref rodata: '+hex(swbase+data_section.base)+' '+swlbl)
				data.replace_offset(swbase, 8, swlbl)
			elif container.is_in_section(".bss", value):
				#print('rodata: '+hex(swbase+data_section.base))
				swlbl = ".LC%x" % value
				#print ('data ref rodata: '+hex(swbase+data_section.base)+' '+swlbl)
				data.replace_offset(swbase, 8, swlbl)
	def _adjust_target(self, container, target):
		# Find the nearest section
		sec = None
		for sname, sval in sorted(
				container.sections.items(), key=lambda x: x[1].base):
			if sval.base >= target:
				break
			sec = sval

		assert sec is not None

		end = sec.base  # + sec.sz - 1
		adjust = target - end

		assert adjust > 0

		return end, adjust

	def _is_target_in_region(self, container, target):
		for sec, sval in container.sections.items():
			if sval.base <= target < sval.base + sval.sz:
				return True

		for fn, fval in container.functions.items():
			if fval.start <= target < fval.start + fval.sz:
				return True

		return False
	#long
	def symbolize_mem_accesses(self, container, context):
		for inst in container.disa_list:
			if inst.address in self.symbolized:
				continue

			mem_access, _ = inst.get_mem_access_op()
			if not mem_access:
				continue

			# Now we have a memory access,
			# check if it is rip relative. #long
			base = mem_access.base
			if base == X86_REG_RIP:
				value = mem_access.disp
				ripbase = inst.address + inst.sz
				target = ripbase + value

				is_an_import = False

				for relocation in container.relocations[".dyn"]:
					if relocation['st_value'] == target:
						is_an_import = relocation['name']
						sfx = ""
						break
					elif target in container.plt:
						is_an_import = container.plt[target]
						sfx = "@PLT"
						break
					elif relocation['offset'] == target:
						is_an_import = relocation['name'] #get the relocation name
						sfx = "@GOTPCREL"
						break

				if is_an_import:
					inst.op_str = inst.op_str.replace(
						hex(value), "%s%s" % (is_an_import, sfx))
				else:
					# Check if target is contained within a known region
					in_region = self._is_target_in_region(
						container, target)
					if in_region:
						inst.op_str = inst.op_str.replace(
							hex(value), ".LC%x" % (target)) #replace the 0x1e1 to .LCa75
					else:
						target, adjust = self._adjust_target(
							container, target)
						#inst.op_str = inst.op_str.replace(hex(value), "%d+.LC%x" % (adjust, target))
						print("[*] Adjusted: %x -- %d+.LC%x" %
							  (inst.address, adjust, target))

				if container.is_in_section(".rodata", target):
					container.rodata_tags_set.add(target) #This function has the LC tag

				#print("mem 0x%x:\t%s\t%s" % (inst.address, inst.mnemonic, inst.op_str))


	def _handle_relocation(self, container, section, rel):
		print('_handle_relocation secname: '+section.name)
		reloc_type = rel['type']
		if reloc_type == ENUM_RELOC_TYPE_x64["R_X86_64_PC32"]:
			swbase = None
			for base in sorted(self.bases):
				if base > rel['offset']:
					break
				swbase = base
			value = rel['st_value'] + rel['addend'] - (rel['offset'] - swbase)
			swlbl = ".LC%x-.LC%x" % (value, swbase)
			section.replace(rel['offset'], 4, swlbl)
		elif reloc_type == ENUM_RELOC_TYPE_x64["R_X86_64_64"]:
			value = rel['st_value'] + rel['addend']
			label = ".LC%x" % value
			section.replace(rel['offset'], 8, label)
		elif reloc_type == ENUM_RELOC_TYPE_x64["R_X86_64_RELATIVE"]:
			value = rel['addend']
			label = ".LC%x" % value
			section.replace(rel['offset'], 8, label)
		elif reloc_type == ENUM_RELOC_TYPE_x64["R_X86_64_COPY"]:
			# NOP
			pass
		else:
			print("[*] Unhandled relocation {}".format(
				describe_reloc_type(reloc_type, container.loader.elffile)))

	def symbolize_data_sections(self, container, context=None):
		# Section specific relocation
		for secname, section in container.sections.items():
			for rel in section.relocations:
				self._handle_relocation(container, section, rel)

		# .dyn relocations
		dyn = container.relocations[".dyn"]
		for rel in dyn:
			section = container.section_of_address(rel['offset'])
			if section:
				self._handle_relocation(container, section, rel)
			else:
				print("[x] Couldn't find valid section {:x}".format(
					rel['offset']))
	def symbolize_text_long(self, container, context=None):
		for instruction in container.disa_list:
			self.symbolize_mov_imm(container,instruction)
			self.symbolize_mov_imm_mem(container,instruction)

			#switch case 1 : mov
			self.symbolize_mov_mem_reg(container, instruction)
			
			#switch case 2: jmp
			self.symbolize_jmp_switch(container, instruction)
			


if __name__ == "__main__":
	#long
	from loader import Loader
	#from librw.loader import Loader
	from analysis import register
	#from librw.analysis import register

	argp = argparse.ArgumentParser()

	argp.add_argument("bin", type=str, help="Input binary to load")
	argp.add_argument("outfile", type=str, help="Symbolized ASM output")

	args = argp.parse_args()

	loader = Loader(args.bin)
	
	#flist = loader.flist_from_symtab()
	#loader.load_functions(flist)
	loader.load_text()

	slist = loader.slist_from_symtab()
	loader.load_data_sections(slist, lambda x: x in Rewriter.DATASECTIONS)

	reloc_list = loader.reloc_list_from_symtab()
	#print(reloc_list)
	loader.load_relocations(reloc_list)
	

	global_list = loader.global_data_list_from_symtab()
	loader.load_globals_from_glist(global_list)

	loader.container.attach_loader(loader)

	rw = Rewriter(args.bin,loader.container, args.outfile)
	rw.symbolize()
	rw.dump()
