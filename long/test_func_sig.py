aa=''
for i in range(ord('0'),ord('9')+1):
	aa=aa+"'"+chr(i)+"'"+','
print(aa)
def int_printable( int1):
	printable_chars = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','@',' ','.']
	int1_str_hex=hex(int1)[2:]
	len_bytes = len(int1_str_hex)
	if(len_bytes % 2 != 0):
		return False
	len_bytes = len_bytes//2
	for i in range(0,len_bytes,2):
		byte_int = int(int1_str_hex[i:i+2],16)
		byte_char = chr(byte_int)
		if(byte_char not in printable_chars):
			return False
	return True

#print(int_printable(0x414320))
from capstone import *
def disasm_bytes(bytes, addr):
	md = Cs(CS_ARCH_X86, CS_MODE_64)
	md.syntax = CS_OPT_SYNTAX_ATT
	md.detail = True
	return list(md.disasm(bytes, addr))
#FF 24 C5 E0 94 49 00                          jmp     ds:off_4994E0[rax*8] ; switch jump
ins_bytes = b'\xFF\x24\xC5\xE0\x94\x49\x00'
ins_str=disasm_bytes(ins_bytes,0)
instruction = ins_str[0]
if instruction.mnemonic.startswith('jmp') and len(instruction.operands)==1 and instruction.operands[0].type==CS_OP_MEM:
	if instruction.operands[0].mem.scale == 8:
		disp = instruction.operands[0].mem.disp

print('ok')


