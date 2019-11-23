import r2pipe
import json
r2 = r2pipe.open("mytest/mytest_nopic")
r2.cmd("aaa")  
funcs = r2.cmd("aflj~{}")
func1 = r2.cmd('afij sym.func1')
func1_json = json.loads(func1)
print(hex(func1_json[0]['offset']))
print('ok')