Core._diff = (str1, str2) ->
  i = 0
  j = 0

  i_end = str1.length
  j_end = str2.length
  additions =
    t: "i"
    c: ""
  deletions =
    t: "d"
    c: ""

  if str1[i_end - 1] == str2[j_end - 1]
    i_end -= 1
    j_end -= 1
    while i_end >= 0 and j_end >= 0 and str1[i_end] == str2[j_end]
      i_end -= 1
      j_end -= 1
    i_end += 1
    j_end += 1

  while i < i_end and j < j_end
    if str1[i] == str2[j]
      j += 1
      i += 1
    else
      additions.p ?= i
      additions.c += str1[i]
      i += 1

  while i < i_end
    additions.p ?= i
    additions.c += str1[i]
    i += 1
  while j < j_end
    deletions.p ?= j
    deletions.c += str2[j]
    j += 1

  while str1[i] and str2[j] and str1[i] == str2[j]
    j += 1
    i += 1
  while str1[i]
    additions.p ?= i
    additions.c += str1[i]
    i += 1
  while str2[j]
    deletions.p ?= j
    deletions.c += str2[j]
    j += 1

  [deletions, additions]
