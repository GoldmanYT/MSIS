s2 = input()
n = 0
p = 1
i = len(s2) - 1
while i >= 0:
    n = n + int(s2[i]) * p
    p = p * 2
    i = i - 1
c = '012345'
s6 = list('            ')

i = len(s6) - 1
s6[i] = c[n % 6]
n = n // 6
i = i - 1
while n > 0 and i >= 0:
    s6[i] = c[n % 6]
    n = n // 6
    i = i - 1
print(''.join(s6).strip())
