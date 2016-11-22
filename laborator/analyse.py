import sys
import re

argc = len(sys.argv)

if argc<3:
   print("Usage: "+sys.argv[0]+" file functionName")
   exit(1)
   
arith = ['sub', 'add', 'addq', 'mul', 'div']
movs = ['mov']
jmps = ['jmp', 'jne', 'jge', 'call']
others = ['xor','and','or']

fileName = sys.argv[1] 
funcName = sys.argv[2] + ":"

with open(fileName) as f:
    content = f.readlines()


startOfFunc = -1
endOfFunc = -1
line = 0

for s in content:
    line+=1
    index = s.find(funcName)
    if index != -1:
        startOfFunc = line
        break
        
if startOfFunc < 0 :
    print("function not found")
    exit(1)
    
    
content = content[startOfFunc:]      

line = 0
for s in content:
    line+=1
    index = s.find("ret")
    index2 = s.find("leave",0)
    if (index2 != -1) or (index != -1):
        endOfFunc = line-1
        break

if endOfFunc < 0 :
    print("No end of file")
    exit(1)
    
content = content[:endOfFunc]

count = 0 
for s in content:    
    m = re.search('\.\w+', s)
    if m is not None:
        #print(m.group(0))
        if s.startswith(('.', '\t.', ' .')) :
            #print("Deleted!:" + content.pop(count))
            content.pop(count)
    #print(m.group(0))
    #content.remove(m.group(0))
    comIndex = s[1:].find("\t")
    #print("comIndex " + str(comIndex))    
    if comIndex > 0:
        content[count] = (content[count])[:comIndex+1]    
    count+=1

for s in content:
    if s in jmps:
        print('arith:')
    print(s)