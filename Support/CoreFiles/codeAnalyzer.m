function stcFlags = codeAnalyzer(fstCode)
% CODEANALYZER
% codeAnalyzer will, given a filename, display warnings to the user about
% potentially slow, or dangerous, or otherwise faulty parts of their code.
% While this will be an ever changing project (ie, new checks will always
% be added), this will be a good start.
% Right now, we will be checking for the following:
%       Using i or j as a variable
%       Using a FOR or WHILE loop
%       Using str2num instead of str2double, or using any form of eval
%       Having an fopen with no fclose
% Again, more will be added in the future.
% In addition, codeAnalyzer is in full compliance with CS 1371 Practices,
% and any functions deemed dangerous by 1371 officials are also flagged.
stcFlags = struct('imgVar', [], 'loop', [], 'badFun', [], 'noClose', [], ...
    'unsuppressed', [], 'total', []);
fidCode = fopen(fstCode, 'r');
if fidCode == -1
    stcFlags = struct('Error', fstCode);
    return;
end
intLines = 0;
strLine = fgetl(fidCode);
while ischar(strLine)
    intLines = intLines + 1;
    strLine = fgetl(fidCode);
end
fclose(fidCode);
cellLines = cell(intLines, 1);
fidCode = fopen(fstCode, 'r');
for intLine = 1:intLines
    cellLines{intLine} = fgetl(fidCode);
end
fclose(fidCode);
[cellLines, ~, vecTrans] = cleanLines(cellLines);
if ischar(cellLines)
    stcFlags = struct('Error', 'You''ve forgotten to end a comment');
    return;
end
cellLines = cellfun(@(str)(str(str ~= ' ')), cellLines, 'uni', false);
stcFlags.imgVar = vecTrans(strFound(cellLines, {'i=', 'j='}));
stcFlags.loop = vecTrans(strFound(cellLines, {'while', 'for'}));
stcFlags.badFun = vecTrans(strFound(cellLines, {'str2num', 'eval', 'evalin', 'evalc',...
    'feval', 'clc', 'clear', 'close all', 'solve', 'input', 'disp'}));
cellOpen = strfind(cellLines, 'fopen');
cellNames = cellfun(@(str, int)(str(int:end)), cellLines, cellOpen, 'uni', false);
cellComma = strfind(cellNames, ',');
cellNames = cellfun(@(str, int)(str(7:int-1)), cellNames, cellComma, 'uni', false);
cellOpen = cellfun(@(str, int)(str(1:int-2)), cellLines, cellOpen, 'uni', false);
logFull = ~cellfun(@isempty, cellOpen);
cellOpen = cellOpen(logFull);
cellNames = cellNames(logFull);
cellOpen = cellfun(@(str)(['fclose(' str ')']), cellOpen, 'uni', false);
cellOpen = cellOpen(~cellfun(@isempty, cellfun(@(str)(str(7:end-1)), cellOpen, 'uni', false)));
logClosed = strFound(cellLines, cellOpen, false, false);
stcFlags.noClose = cellNames(~logClosed);
logUnsuppressed = ~strFound(cellLines, ';');
logUnsuppressed(strFound(cellLines, {'if', 'switch', 'case', 'return', ...
    'break', '...', 'function', 'for', 'while', 'try', 'catch'})) = false;
logUnsuppressed(strcmp(cellLines, 'end')) = false;
stcFlags.unsuppressed = vecTrans(logUnsuppressed);
stcFlags.total = stcNumel(stcFlags);
end