function logFound = strFound(varStr, varPattern, logAnd, logGoal)
% STRFOUND Find patterns in strings.
%
%   F = strFound(STRING, PATTERN, COMPARISON, GOAL);
%   Given STRING and PATTERN, strFound will return a logical of whether the
%   PATTERN was found within STRING.
%
%   If STRING is a cell array, then strFound will return a logical array, 
%   where each index is the corresponding entry in the STRING cell array.
%
%   If PATTERN is a cell array, then strFound will return true if any of
%   the patterns are found within the STRING.
%
%   If PATTERN and STRING are both cell arrays of strings, then strFound
%   will perform an entry-by-entry execution for each of the entries in
%   STRING, using all the entries in PATTERN, and will return a logical
%   array of size STRING.
%
%   If COMPARISON is present and true, then strFound will return true only
%   if ALL of the patterns are found within the string. If COMPARISON is
%   not present, then the ANY operator is assumed.
%
%   If GOAL is present and false, then strFound will return a logical array
%   that is the same number of elements as PATTERN is. Each element will be
%   a logical as to whether that pattern was found AT LEAST once within the
%   given set of strings. If GOAL is true, strFound will instead act as if
%   just given STRING and PATTERN. If GOAL is present, this supersedes
%   COMPARISON.
%
%   strFound is case-sensitive, and only accepts strings or cell arrays of
%   strings as its first two arguments. In addition, the last two arguments
%   must either be omitted or be logicals.
%
%   Examples:
%       logF1 = strFound('hello', 'o')
%       logF1 = true;
%
%       logF2 = strFound('hello', 'y')
%       logF2 = false;
%
%       strs = {'hello', 'goodbye'};
%       logF3 = strFound(strs, 'oo')
%       logF3 = [false true]
%
%       strPs = {'ll', 'oo'};
%       logF4 = strFound('hello', strPs)
%       logF4 = true;
%
%       strs = {'hello', 'goodbye'};
%       strPs = {'yy', 'll', 'fdsa'};
%       logF5 = strFound(strs, strPs)
%       logF5 = [true false]
%
%       strs = {'hello', 'goodbye'};
%       strPs = {'oo', 'll'};
%       logF6 = strFound(strs, strPs, true)
%       logF6 = [false false]
%
%       strs = {'Test1', 'Test2', 'Test3', 'fdsa'};
%       strPs = {'1', '2', '4'};
%       logF7 = strFound(strs, strPs, false, false)
%       logF7 = [true true false]

    if ischar(varStr)
        varStr = {varStr};
    end
    if ischar(varPattern)
        varPattern = {varPattern};
    end
    if ~exist('logAnd', 'var')
        logAnd = false;
    end
    if ~exist('logGoal', 'var')
        logGoal = true;
    end
    if logGoal
        logFound = cellfun(@(str)(strfind2(str, varPattern, logAnd)), varStr);
    else
        logFound = cellfun(@(str)(any(strFound(varStr, str, logAnd))), varPattern);
    end
end

function logFound = strfind2(strStr, cellPattern, logAnd)
    if logAnd
        logFound = all(cellfun(@(str)(~isempty(strfind(strStr, str))), cellPattern));
    else
        logFound = any(cellfun(@(str)(~isempty(strfind(strStr, str))), cellPattern));
    end
end