function [cellLines, vecS2F, vecF2S] = cleanLines(cellLines)
% CLEANLINES will, given a cell array of text lines, remove all blank lines
% and all comments. In addition, it will give a vector of indices of the
% remaining lines.
% EXAMPLES:
%   cellLines = {'helloWorld', '', '% This is a comment', 'This is not'};
%   [cellClean, vecTrans1, vecTrans2] = cleanLines(cellLines);
%   cellClean = {'helloWorld', 'This is not'};
%   vecTrans1 = [1 0 0 2];
%   vecTrans2 = [1 4];
if numel(cellLines) ~= length(cellLines)
    cellClean = cell(size(cellLines, 1), 1);
    vecS2F = cellClean;
    for k = 1:numel(cellClean)
        [cellClean{k}, vecS2F{k}] = cleanLines(cellLines(k, :));
    end
    return;
end
cellLines = cellLines(:);
vecS2F = 1:numel(cellLines);
vecF2S = 1:numel(cellLines);
[cellLines, cellRest] = cellfun(@(str)(strtok(str, ' ')), cellLines, 'uni', false);
cellLines = cellfun(@(str1, str2)([str1 str2]), cellLines, cellRest, 'uni', false);
logBlank = cellfun(@isempty, cellLines);
vecPosns = find(logBlank);
for k = vecPosns'
    vecS2F(k:end) = vecS2F(k:end) - 1;
end
logCommentBrO = cellfun(@(str)(strcmp(str, '%{')), cellLines);
logCommentBrC = cellfun(@(str)(strcmp(str, '%}')), cellLines);
if numel(logCommentBrC) ~= numel(logCommentBrO);
    cellLines = 'CommentClosureMismatch';
    return;
end
vecOpen = find(logCommentBrO);
vecClose = find(logCommentBrC);
for k = 1:numel(vecOpen)
    vecS2F(vecOpen(k):vecClose(k)) = vecS2F(vecOpen(k):vecClose(k)) - 1;
end
cellCommentLines = arrayfun(@(int1, int2)(int1:int2), vecOpen, vecClose, 'uni', false);
logComments = cellfun(@(str)(strncmp(str, '%', 1)), cellLines);
logComments([cellCommentLines{:}]) = true;
vecPosns = find(logComments);
for k = vecPosns'
    vecS2F(k:end) = vecS2F(k:end) - 1;
end
cellLines(logComments | logBlank) = [];
vecF2S(logComments | logBlank) = [];
vecS2F(logBlank | logComments) = 0;

cellComments = cellfun(@(str)(strfind(str, '%')), cellLines, 'uni', false);
logComments = cellfun(@isempty, cellComments);
cellLines(~logComments) = cellfun(@(str, int)(str(1:int-1)),...
    cellLines(~logComments), cellComments(~logComments), 'uni', false);
end