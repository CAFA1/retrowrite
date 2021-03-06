#!/usr/bin/env python

import argparse
from collections import defaultdict

from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection
from elftools.elf.relocation import RelocationSection

from container import Container, Function, DataSection
from disasm import disasm_bytes
#long
from container import InstructionWrapper
import re

class Loader():
	def __init__(self, fname):
		self.fd = open(fname, 'rb')
		self.elffile = ELFFile(self.fd)
		self.container = Container()
		

	def load_functions(self, fnlist):
		section = self.elffile.get_section_by_name(".text")
		data = section.data()
		base = section['sh_addr'] #the base addrs of .text section
		for faddr, fvalue in fnlist.items(): #the symbol addrs and value
			section_offset = faddr - base
			bytes = data[section_offset:section_offset + fvalue["sz"]] #get the function's machine bytes

			function = Function(fvalue["name"], faddr, fvalue["sz"], bytes,
								fvalue["bind"])
			self.container.add_function(function)
	#long
	#liner disassemble
	def load_text(self):
		section = self.elffile.get_section_by_name(".text")
		data = section.data() #bytes
		text_base = section['sh_addr'] #the base addrs of .text section
		text_size = section['sh_size']
		entries = disasm_bytes(data, text_base)
		tmpfile=open('/tmp/text.s','w')
		for i in list(entries):
			self.container.inst_addrs_set.add(i.address)
			tmpfile.write("0x%x:\t%s\t%s\n" % (i.address, i.mnemonic, i.op_str))
		tmpfile.close()
		for decoded in entries:
			self.container.disa_list.append(InstructionWrapper(decoded))
		
		#print('load_text')
	def load_data_sections(self, seclist, section_filter=lambda x: True):
		for sec in [sec for sec in seclist if section_filter(sec)]:
			sval = seclist[sec]
			section = self.elffile.get_section_by_name(sec)
			data = section.data()
			more = bytearray()
			if sec == ".init_array":
				if len(data) > 8:
					data = data[8:]
				else:
					data = b''
				more.extend(data)
			else:
				more.extend(data)
				if len(more) < sval['sz']:
					more.extend(
						[0x0 for _ in range(0, sval['sz'] - len(more))])

			bytes = more
			ds = DataSection(sec, sval["base"], sval["sz"], bytes,
							 sval['align'])#data section

			self.container.add_section(ds)

		# Find if there is a plt section
		for sec in seclist:
			if sec == '.plt':
				self.container.plt_base = seclist[sec]['base']
			if sec == ".plt.got":
				section = self.elffile.get_section_by_name(sec)
				data = section.data()
				entries = list(
					disasm_bytes(section.data(), seclist[sec]['base'])) #disasm based on capstone
				self.container.gotplt_base = seclist[sec]['base']
				self.container.gotplt_sz = seclist[sec]['sz']
				self.container.gotplt_entries = entries

	def load_relocations(self, relocs):
		for reloc_section, relocations in relocs.items():
			section = reloc_section[5:]

			if reloc_section == ".rela.plt":
				self.container.add_plt_information(relocations)

			if section in self.container.sections:
				self.container.sections[section].add_relocations(relocations)
			else:
				print("[*] Relocations for a section that's not loaded:",
					  reloc_section)
				self.container.add_relocations(section, relocations) # add the .dyn section

	def reloc_list_from_symtab(self):
		relocs = defaultdict(list)

		for section in self.elffile.iter_sections():
			if not isinstance(section, RelocationSection):
				continue

			symtable = self.elffile.get_section(section['sh_link']) #symtable

			for rel in section.iter_relocations():
				symbol = None
				if rel['r_info_sym'] != 0:
					symbol = symtable.get_symbol(rel['r_info_sym']) # get the symbol based on the rel index

				if symbol:
					if symbol['st_name'] == 0:
						symsec = self.elffile.get_section(symbol['st_shndx'])
						symbol_name = symsec.name
					else:
						symbol_name = symbol.name
				else:
					symbol = dict(st_value=None)
					symbol_name = None

				reloc_i = {
					'name': symbol_name,
					'st_value': symbol['st_value'],
					'offset': rel['r_offset'],
					'addend': rel['r_addend'],
					'type': rel['r_info_type'],
				}

				relocs[section.name].append(reloc_i)

		return relocs

	def flist_from_symtab(self):
		symbol_tables = [
			sec for sec in self.elffile.iter_sections()
			if isinstance(sec, SymbolTableSection)
		]

		function_list = dict()
		#long
		f1=open('/tmp/funcs.txt','w')
		for section in symbol_tables:
			if not isinstance(section, SymbolTableSection):
				continue

			if section['sh_entsize'] == 0:
				continue

			for symbol in section.iter_symbols():
				#f1.write('longfunc:'+symbol.name+'\t'+hex(symbol['st_value'])+'\n'+'\t'+repr(symbol['st_other']['visibility'])+'\t'+repr(symbol['st_info']['type'])+'\t'+repr(symbol['st_shndx'])+'\t'+repr(symbol['st_size'])+'\n')
				if symbol['st_other']['visibility'] == "STV_HIDDEN":
					pass
					#continue

				if (symbol['st_info']['type'] == 'STT_FUNC'
						and symbol['st_shndx'] != 'SHN_UNDEF'): #get function sysmbol
					
					f1.write('longfunc:'+symbol.name+'\t'+hex(symbol['st_value'])+'\n'+'\t'+repr(symbol['st_other']['visibility'])+'\t'+repr(symbol['st_info']['type'])+'\t'+repr(symbol['st_shndx'])+'\t'+repr(symbol['st_size'])+'\n')
					function_list[symbol['st_value']] = {
						'name': symbol.name,
						'sz': symbol['st_size'],
						'visibility': symbol['st_other']['visibility'],
						'bind': symbol['st_info']['bind'],
					}
		f1.close()
		return function_list
	def flist_from_symtab1(self):
		symbol_tables = [
			sec for sec in self.elffile.iter_sections()
			if isinstance(sec, SymbolTableSection)
		]

		function_list = dict()
		#long
		f1=open('/tmp/funcs.txt','w')
		for section in symbol_tables:
			if not isinstance(section, SymbolTableSection):
				continue

			if section['sh_entsize'] == 0:
				continue

			for symbol in section.iter_symbols():
				f1.write('longfunc:'+symbol.name+'\t'+hex(symbol['st_value'])+'\n'+'\t'+repr(symbol['st_other']['visibility'])+'\t'+repr(symbol['st_info']['type'])+'\t'+repr(symbol['st_shndx'])+'\t'+repr(symbol['st_size'])+'\n')
				if symbol['st_other']['visibility'] == "STV_HIDDEN":
					pass
					#continue

				if (symbol['st_info']['type'] == 'STT_FUNC'
						and symbol['st_shndx'] != 'SHN_UNDEF'): #get function sysmbol
					pass
				if (symbol['st_info']['type'] == 'STT_FUNC'):
					function_list[symbol['st_value']] = {
						'name': symbol.name,
						'sz': symbol['st_size'],
						'visibility': symbol['st_other']['visibility'],
						'bind': symbol['st_info']['bind'],
					}
		f1.close()
		return function_list
	def slist_from_symtab(self):
		sections = dict()
		for section in self.elffile.iter_sections():
			sections[section.name] = {
				'base': section['sh_addr'],
				'sz': section['sh_size'],
				'offset': section['sh_offset'],
				'align': section['sh_addralign'],
			}

		return sections

	def load_globals_from_glist(self, glist):
		self.container.add_globals(glist)

	def global_data_list_from_symtab(self):
		symbol_tables = [
			sec for sec in self.elffile.iter_sections()
			if isinstance(sec, SymbolTableSection)
		]  # two symbol_table .dynsym and .symtab

		global_list = defaultdict(list)
		#long
		f1=open('/tmp/data.txt','w')
		for section in symbol_tables:
			if not isinstance(section, SymbolTableSection):
				continue

			if section['sh_entsize'] == 0:
				continue

			for symbol in section.iter_symbols():
				# XXX: HACK
				if "@@GLIBC" in symbol.name:
					continue
				if symbol['st_other']['visibility'] == "STV_HIDDEN":
					continue
				if symbol['st_size'] == 0:
					continue

				if (symbol['st_info']['type'] == 'STT_OBJECT'
						and symbol['st_shndx'] != 'SHN_UNDEF'):
					
					f1.write('name: '+symbol.name+"\tsize: "+repr(symbol['st_size'])+'\tvisual: '+symbol['st_other']['visibility']+'\tbind: '+symbol['st_info']['bind'] +'\n')
					myname="{}".format(symbol.name)
					if(myname=='_IO_stdin_used'):
						myname=myname+'_1'
					global_list[symbol['st_value']].append({
						'name':
						"{}_{:x}".format(symbol.name, symbol['st_value']),
						#myname,
						'sz':
						symbol['st_size'],
					})
		f1.close()
		return global_list


if __name__ == "__main__":
	from .rw import Rewriter

	argp = argparse.ArgumentParser()

	argp.add_argument("bin", type=str, help="Input binary to load")
	argp.add_argument(
		"--flist", type=str, help="Load function list from .json file")

	args = argp.parse_args()

	loader = Loader(args.bin)

	flist = loader.flist_from_symtab()
	loader.load_functions(flist)

	slist = loader.slist_from_symtab()
	loader.load_data_sections(slist, lambda x: x in Rewriter.DATASECTIONS)

	reloc_list = loader.reloc_list_from_symtab()
	loader.load_relocations(reloc_list)

	global_list = loader.global_data_list_from_symtab()
	loader.load_globals_from_glist(global_list)
