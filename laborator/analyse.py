import sys

argc = len(sys.argv)

if argc<3:
   print("Usage: "+sys.argv[0]+" file functionName")
   exit(1)
   
arith = []
movs = []
jmps = []
others = []

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


print(content)