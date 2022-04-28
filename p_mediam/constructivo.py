import numpy as np
import math
import time
import os
import openpyxl

start = time.time()

fil = 'pmedcap10.txt'
with open(fil) as f:
    firstline = f.readline().rstrip()
firstline=np.array(firstline.split(' '))
dat = np.loadtxt(fil, delimiter = ' ', skiprows = 1)

a = int(firstline[1])
b = int(firstline[0])
ans = np.array([[0]*(int(b/2))]*(a+1))
datAux = dat
N = 10000

for i in range(a):
  aux = datAux[i][2] - datAux[i][3]
  ans[i][0] = i + 1
  ans[i][2] = i + 1
  ind = 3
  count = 1
  for j in range(a,b):
    if (aux - datAux[j][3]) < 0:
      continue
    aux = aux - datAux[j][3]
    if (aux >= 0):
      ans[i][ind] = j + 1
      ind = ind + 1
      count = count + 1
      datAux[j][3] = N
  ans[i][1] = count

dat = np.loadtxt(fil, delimiter = ' ', skiprows = 1)
aux = 0
for i in range(a):
  var = 0
  ult = ans[i][1]
  for j in range(3, len(ans[i])):
    if ans[i][j] == 0:
      break
    ind = ans[i][j]-1
    dist = int(math.sqrt((dat[i][0] - dat[ind][0])**2 + ((dat[i][1] - dat[ind][1])**2)))
    aux = aux + dist
    var = var + dist
  ans[i][ult+2] = var

ans[a][0] = aux
ans[a][1] = 1
answer = [[]]*(a+1)
zero = [0]

for i in range(a+1):
  answer[i] = np.setdiff1d(ans[i], zero, assume_unique = True)
end = time.time()
answer[a][1] = (end - start) * 1000

for x in range(a+1):
  answer[x] = answer[x].tolist()

wb = openpyxl.Workbook()
hoja = wb.active
for i in answer:
    # producto es una tupla con los valores de un producto 
    hoja.append(i)
wb.save('constructivo10.xlsx')
print(answer)