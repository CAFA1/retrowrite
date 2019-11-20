from capstone import *
from elftools.elf.elffile import ELFFile
def disasm_bytes(bytes, addr):
	md = Cs(CS_ARCH_X86, CS_MODE_64)
	md.syntax = CS_OPT_SYNTAX_ATT
	md.detail = True
	return list(md.disasm(bytes, addr))

class Loader():
	def __init__(self, fname):
		self.fd = open(fname, 'rb')
		self.elffile = ELFFile(self.fd)
		self.dis_dict={}
	def get_text(self):
		section = self.elffile.get_section_by_name(".text")
		data = section.data()
		text_base = section['sh_addr'] #the base addrs of .text section
		text_size = section['sh_size']
		entries = list(disasm_bytes(data, text_base))
		tmpfile=open('/tmp/text.s','w')
		for i in entries:
			tmpfile.write("0x%x:\t%s\t%s\n" % (i.address, i.mnemonic, i.op_str))
		tmpfile.close()
		print('here')
def disasm_bytes(bytes, addr):
	md = Cs(CS_ARCH_X86, CS_MODE_64)
	md.syntax = CS_OPT_SYNTAX_ATT
	md.detail = True
	return list(md.disasm(bytes, addr))

loader = Loader("mytest/mytest/mytest/mytest")
loader.get_text()

