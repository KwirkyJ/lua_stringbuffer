-- Test suite for stringbuffer

-- (c) 2016 J. KwirkyJ Smith <kwirkyj.smith0@gmail.com>
-- Version 1.0
-- MIT License

local StringBuffer = require 'init'



local b, b2 = StringBuffer.new(), StringBuffer() -- aliased constructors

assert(b:getString() == b2:getString(), 'initial empty strings match')
assert(b ~= b2, 'unique instances')

assert(b:getString() == '',
       'blank buffers are empty')

b:add('\tword')
b:add("\n")
b:add('honey')
assert(b:getString() == '\tword\nhoney', 'additions are concatenated')

assert(b:getString() ~= b2:getString(), 'buffers are separate')

b2:add('\tword\nhoney')
assert(b:getString() == b2:getString(), 'generated strings match')

b = StringBuffer()
b:add(nil)
b:add(5)
b:add(function() end)
assert(b:getString() == '', 'non-string additions are ignored')



---- TEST BATCHED ADDITONS ---------------------------------------------------

b = StringBuffer()
b:add('apples', 'cherries', 'peaches', 'pears', 'kumquats')
assert(b:getString() == 'applescherriespeachespearskumquats',
       'vararg additions are concatenated by default')

b = StringBuffer()
b:add('apples', 'cherries', 5, 'pears', 'kumquats')
assert(b:getString() == 'applescherries',
       'vararg add stops at first non-string')

b = StringBuffer()
b:add{delimiter=', ', 'apples', 'cherries', 'peaches', 'pears', 'kumquats'}
assert(b:getString() == 'apples, cherries, peaches, pears, kumquats',
       'addition via table is possible, and accepts a delimiter argument')

b = StringBuffer()
b:add{'apples', 'cherries', 'peaches', 'pears', 'kumquats'}
assert(b:getString() == 'applescherriespeachespearskumquats',
       'no delimiter defaults to the empty string')

b = StringBuffer()
b:add{delimiter=' ', 'apples', 'cherries', 5, 'pears', 'kumquats'}
assert(b:getString() == 'apples cherries',
       'non-strings will halt addition')

b = StringBuffer()
b:add('apples', 'pears', {'cherries'}, 'kumquats')
assert(b:getString() == 'applespears',
       'tables are a halting element')

b = StringBuffer()
b:add{}
assert(b:getString() == '', 'empty table adds nothing')

b = StringBuffer()
b:add({delimiter = ' ', 'apples', 'cherries'}, {delimiter = ' ', 'pears'})
assert(b:getString() == 'apples cherries', 'uses only first table')



---- TEST DELIMITERS ---------------------------------------------------------

b = StringBuffer('\t')
b:add('pickelbarrel')
b:add('kumquat')
b:add('')
assert(b:getString() == 'pickelbarrel\tkumquat\t\t',
      'constructor accepts global delimiter')

b = StringBuffer()
b:add('1')
b:add('2')
b:setDelimiter('/')
b:add('3')
b:add('4')
b:setDelimiter()
b:add('5')
b:add('6')
b:setDelimiter([=[\]=])
b:add('7')
b:add('8')
b:setDelimiter('')
b:add('9')
assert(b:getString() == [=[123/4/567\8\9]=],
       'demonstrating setter')

b = StringBuffer('  ')
b:add{delimiter = '\n', 'apples', 'oranges', 'kiwis'}
b:add('citrangelos')
assert(b:getString() == 'apples\noranges\nkiwis  citrangelos  ',
       'table-add and preset delimiter interaction')

b = StringBuffer()
b:setDelimiter('  ')
b:add{delimiter = '\n', 'apples', 'oranges', 'kiwis'}
b:add('citrangelos')
assert(b:getString() == 'apples\noranges\nkiwis  citrangelos  ',
       'more table-add and preset delimiter interaction')


print('==== TESTS SUCCESSFUL ====')

