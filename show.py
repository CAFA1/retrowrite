import sys
import re
file_name=sys.argv[1]
f1=open(file_name,'r')
line_num=1
for line in f1.readlines():
	reg_node=re.search('0x4(?P<num>.*),',line)
	if(reg_node):
		num=reg_node.group('num')
		print(str(line_num)+':0x4'+num)
	line_num+=1