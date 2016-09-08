function [cellInArgs, cellOutArgs] = getArgs(fstCode, ~)
% getArgs returns the arguments of a MATLAB file
%   Given a MATLAB code file (.m), getArgs will return the arguments for
%   the file.
%
% Example:
% Code File: function out = funcy(in)
%
%   [a, b] = getArgs('funcy.m')
%   a -> {'in'}; b -> {'out'}


fidCode = fopen(fstCode, 'r');
intLines = 0;
strLine = fgetl(fidCode);
while ischar(strLine)
    intLines = intLines + 1;
    strLine = fgetl(fidCode);
end
fclose(fidCode);
fidCode = fopen(fstCode, 'r');
cellLines = cell(1, intLines);
for k = 1:intLines
    cellLines{k} = fgetl(fidCode);
end
fclose(fidCode);

[cellLines, ~, ~] = cleanLines(cellLines);
% function is defined in the first line; need to, however, make sure we
% have a function!
strLine = cellLines{1};
logFunc = strfind(lower(strLine), 'function');
if ~logFunc
    cellInArgs = {'Not a function!'};
    cellOutArgs = {'Not a function!'};
    return;
end

% find the end parenthesis sign (this is the end of the function def):
cellOutArgs = strfind(cellLines, ')');
for k = 1:numel(cellLines)
    if ~isempty(cellOutArgs{k})
        intLine = k;
        break;
    end
end

cellDef = cellLines(1:intLine);
intNumel = 0;
for k = 1:numel(cellDef)
    intEllips = strfind(cellDef{k}, '...');
    if ~isempty(intEllips)
        strLine = cellDef{k};
        strLine(intEllips+1:end) = [];
        strLine(end) = ' ';
        cellDef{k} = strLine;
    end
    intNumel = intNumel + numel(cellDef{k});
end

strDef = char(zeros(1, intNumel));
intChar = 1;
for k = 1:numel(cellDef)
    strDef(intChar:(intChar + numel(cellDef{k}) - 1)) = cellDef{k};
    intChar = intChar + numel(cellDef{k});
end
intFuncStart = strfind(strDef, 'function');
strDef = strDef(intFuncStart:end);

intInStart = strfind(strDef, '(');
intInEnd = strfind(strDef, ')');
strIn = strDef((intInStart + 1):(intInEnd - 1));
strIn(strIn == ' ') = [];
if numel(strIn) == 0
    cellInArgs = {};
else
    cellInArgs = strsplit(strIn, ',');
end
strFName = textscan(fstCode, '%s', 'Delimiter', '\');
strFName = strFName{1}{end};
[strFName, ~] = strtok(strFName, '.');
strDefTest = strDef;
strDefTest(strDefTest == ' ') = [];
if strncmpi(strDefTest, ['function' strFName], numel(['function' strFName]))
    cellOutArgs = {};
else
    intOutStart = strfind(strDef, '[');
    if ~isempty(intOutStart)
        intOutEnd = strfind(strDef, ']');
    else
        intOutStart = strfind(strDef, ' ');
        intOutEnd = intOutStart(2);
        intOutStart = intOutStart(1);
    end
    strOut = strDef((intOutStart + 1):(intOutEnd - 1));
    strOut(strOut == ' ') = [];
    cellOutArgs = strsplit(strOut, ',');
end
end
    
