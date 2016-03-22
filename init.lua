-- Module for efficiently building up a string.
-- More efficient than repeated '..', according to PiL?
-- It has probably been implemented many times, but I put this together
-- from scratch because I wasn't about to go searching for extant libs.
--
-- Author: J. 'KwirkyJ' Smith <kwirkyj.smith0@gmail.com>
-- Date: 2016
-- Version: 1.0.0-0
-- License: MIT License



local stringbuffer = {_VERSION = "1.0.0-0"}

local bufferobj = {}



---(StringBuffer):add(...)
-- Add strings to the end of the buffer; can be either: 
-- (1) one or more strings, or 
-- (2) a list with an optional delimiter key;
-- first non-string element in the sequence terminates addition;
-- if provided tablehas a delimiter, then its delimiter is interspersed 
-- between the elements added from that list;
-- if the StringBuffer object has a delimiter set that is not '', then
-- its delimiter is appended at the end of all additions made by the call.
-- @param ... One or more {Strings} 
--            or a {Table} indexed (1..n) with optional ['delimiter'].
bufferobj.add = function(self, ...)
    local list, delimiter, len
    list = {...}
    if type(list[1]) == 'table' then
        list = list[1]
    end
    delimiter = list['delimiter']
    len = #self[1]
    for i=1, #list do
        if type(list[i]) ~= 'string' then break end
        len = len+1
        self[1][len] = list[i]
        if delimiter then
            len = len+1
            self[1][len] = delimiter
        end
    end
    if delimiter then
        self[1][#self[1]] = nil
    end
    if self[2] and self[2] ~= '' then
        self[1][#self[1]+1] = self[2]
    end
end

---(StringBuffer):getString()
-- Convert the buffer to a string literal.
-- @return {String}
bufferobj.getString = function(self)
    return table.concat(self[1])
end

---(StringBuffer):setDelimiter(s)
-- Set delimiter added at end of each add() call.
-- @param s {String} (default '')
-- @error Raised iff provided delimiter is not a string.
bufferobj.setDelimeter = function(self, s)
    s = s or ''
    assert(type(s) == 'string', 'delimiter must be string but was '.. type(string))
    self[2] = s
end



---StringBuffer.new(delim)
-- Get a new StringBuffer table/object.
-- @param delim {String} Optional delimiter to add at the end of each add() call.
-- @error Raised if delim is not a string or nil.
-- @return {StringBuffer}
stringbuffer.new = function(delim)
    delim = delim or ''
    assert(type(delim) == 'string', 'delimiter must be string but was '.. type(string))
    
    return {[1] = {},
            [2] = delim,
            add          = bufferobj.add,
            getString    = bufferobj.getString,
            setDelimiter = bufferobj.setDelimeter,
           }
end



return stringbuffer

