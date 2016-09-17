function [strStatus, strPath] = readySubmit()
try
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
    mkdir('HW_FilesToSubmit');
    strCurrFolder = cd;
    strPath = [strCurrFolder '\HW_FilesToSubmit'];
    intStart = find(strFound(cellLines, 'Files to submit:')) + 1;
    intFinish = find(strFound(cellLines, 'Instructions:')) - 2;
    cellFiles = cellLines(intStart:intFinish);
    cellPosn = num2cell(cellfun(@(c)(c(1)), cellfun(@(str)(regexp(str, '\w')), cellFiles, 'uni', false)));
    cellFiles = cellfun(@(str, pos)(str(pos:end)), cellFiles, cellPosn, 'uni', false);
    fCopy = @(str)(copyfile(str, 'HW_FilesToSubmit'));
    cellfun(fCopy, cellFiles, 'uni', false);
    strStatus = 'Files Ready to Submit!';
catch ME
    strStatus = 'Unable to ready files. Please select a valid folder!';
    strPath = '';
end
end