function [strStatus, strPath] = readySubmit()
strPath = '';
    function fCopy(str)
        try %#ok<TRYNC>
            copyfile(str, 'HW_FilesToSubmit');
        end
    end
try
    fidInfo = fopen('SoluCheckInfo.txt', 'r');
    while fidInfo == -1
        userPrefs;
        uiwait();
        fidInfo = fopen('SoluCheckInfo.txt', 'r');
    end
    cellInfo = textscan(fidInfo, '%s', 5, 'Whitespace', '\n');
    fclose(fidInfo);
    [strName, strID, strEmail, strCID, strSID] = deal(cellInfo{1}{:});
    stcFiles = dir();
    cellFiles = {stcFiles.name};
    cellInd = regexp(cellFiles, 'hw\d\d\.m');
    fstFile = cellFiles{~cellfun(@isempty, cellInd)};
    if isempty(fstFile)
        strStatus = 'Failed to prepare - no HW file found!';
        strPath = '';
        return;
    end
    fidMaster = fopen(fstFile, 'r');
    intLines = 0;
    strLine = fgetl(fidMaster);
    while ischar(strLine)
        intLines = intLines + 1;
        strLine = fgetl(fidMaster);
    end
    fclose(fidMaster);
    cellLines = cell(1, intLines);
    fidMaster = fopen(fstFile, 'r');
    for intLine = 1:intLines
        cellLines{intLine} = fgetl(fidMaster);
    end
    fclose(fidMaster);
    strNLine = cellLines{strFound(cellLines, '% Name', [], [], 1)};
    strILine = cellLines{strFound(cellLines, '% T-square ID', [], [], 1)};
    strELine = cellLines{strFound(cellLines, '% GT Email', [], [], 1)};
    strHLine = cellLines{strFound(cellLines, '% Homework', [], [], 1)};
    strCLine = cellLines{strFound(cellLines, '% Course', [], [], 1)};
    strSLine = cellLines{strFound(cellLines, '% Section', [], [], 1)};
    strDLine = cellLines{strFound(cellLines, '% Collaboration', [], [], 1   )};
    if ~isempty(strNLine)
        intPosn = strfind(strNLine, ':');
        strNLine = [strNLine(1:intPosn) ' ' strName];
        cellLines{strFound(cellLines, '% Name', [], [], 1)} = strNLine;
    end
    if ~isempty(strILine)
        intPosn = strfind(strILine, ':');
        strILine = [strILine(1:intPosn) ' ' strID];
        cellLines{strFound(cellLines, '% T-square ID', [], [], 1)} = strILine;
    end
    if ~isempty(strELine)
        intPosn = strfind(strELine, ':');
        strELine = [strELine(1:intPosn) ' ' strEmail];
        cellLines{strFound(cellLines, '% GT Email', [], [], 1)} = strELine;
    end
    if ~isempty(strHLine)
        intPosn = strfind(strHLine, ':');
        if weekday(datetime) > 2 && weekday(datetime) < 7
            strSub = 'Original';
        else
            strSub = 'Resubmission';
        end
        strHLine = [strHLine(1:intPosn) ' ' fstFile(3:strfind(fstFile, '.') - 1) '/' strSub];
        cellLines{strFound(cellLines, '% Homework', [], [], 1)} = strHLine;
    end
    if ~isempty(strCLine)
        intPosn = strfind(strCLine, ':');
        strCLine = [strCLine(1:intPosn) ' ' strCID];
        cellLines{strFound(cellLines, '% Course', [], [], 1)} = strCLine;
    end
    if ~isempty(strSLine)
        intPosn = strfind(strSLine, ':');
        strSLine = [strSLine(1:intPosn) ' ' strSID];
        cellLines{strFound(cellLines, '% Section', [], [], 1)} = strSLine;
    end
    if ~isempty(strDLine)
        intPosn = strfind(strDLine, ':');
        strDLine = [strDLine(1:intPosn) ' ' 'I worked on the homework assignment alone, using only course materials.'];
        cellLines{strFound(cellLines, '% Collaboration', [], [], 1)} = strDLine;
        intSPosn = find(strFound(cellLines, '% Collaboration', [], [], 1));
        intEPosn = find(strFound(cellLines, '% Files provided with this homework:', [], [], 1));
        cellLines(intSPosn+1:intEPosn-1) = [];
        cellLines = [cellLines(1:intSPosn) {'% '} cellLines(intSPosn+1:end)];
    end
    mkdir('HW_FilesToSubmit');
    strCurrFolder = cd;
    strPath = [strCurrFolder '\HW_FilesToSubmit'];
    intStart = find(strFound(cellLines, 'Files to submit:', [], [], 1)) + 1;
    intFinish = find(strFound(cellLines, 'Instructions:', [], [], 1)) - 2;
    cellFiles = cellLines(intStart:intFinish);
    cellPosn = num2cell(cellfun(@(c)(c(1)), cellfun(@(str)(regexp(str, '\w')), cellFiles, 'uni', false)));
    cellFiles = cellfun(@(str, pos)(str(pos:end)), cellFiles, cellPosn, 'uni', false);
    cellfun(@(str)(fCopy(str)), cellFiles, 'uni', false);
    fidMaster = fopen(['HW_FilesToSubmit\' fstFile], 'w');
    for k = 1:numel(cellLines)
        fprintf(fidMaster, '%s\n', cellLines{k});
    end
    fclose(fidMaster);
    strStatus = 'Files Ready to Submit!';
catch ME %#ok<NASGU>
    strStatus = 'Unable to ready files. Please select a valid folder!';
end
end