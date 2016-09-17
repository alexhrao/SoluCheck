function audit(intIt, cArgs, cAns, cSol, fid)
    cAns = cAns(cellfun(@(d)(~isempty(d)), cAns));
    cSol = cSol(cellfun(@(d)(~isempty(d)), cSol));
    fprintf(fid, '%%%% Iteration #%d:\n%%\n', intIt);
    fprintf(fid, '%% Input Arguments:\n%%\n');
    cellInts = num2cell(1:numel(cArgs));
    cellfun(@(vd, in)(printCell(fid, vd, in)), cArgs, cellInts);
    fprintf(fid, '%% Output Answers:\n%%\n');
    cellInts = num2cell(1:numel(cAns));
    cellfun(@(vd, in)(printCell(fid, vd, in)), cAns, cellInts);
    fprintf(fid, '%% Output Solutions:\n%%\n');
    cellInts = num2cell(1:numel(cSol));
    cellfun(@(vd, in)(printCell(fid, vd, in)), cSol, cellInts);
    fprintf(fid, '%%\n');
end

function printCell(fid, varData, intArg)
    if isempty(varData)
        strData = sprintf('Empty variable of class %s', class(varData));
    else
        strData = evalc('disp(varData)');
    end
    cellData = strsplit(strData, char(10));
    cellData(cellfun(@isempty, cellData)) = [];
    fprintf(fid, '%%     Argument %d:\n%%\n', intArg);
    for k = 1:numel(cellData)
        fprintf(fid, '%%         %s\n%%\n', cellData{k});
    end
end