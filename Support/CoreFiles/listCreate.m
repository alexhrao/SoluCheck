function strProper = listCreate(cellList)
if ~iscell(cellList)
    cellList = num2cell(cellList);
end
if numel(cellList) == 0
    strProper = '';
elseif numel(cellList) == 1
    strProper = [num2str(cellList{1})];
elseif numel(cellList) == 2
    strProper = [num2str(cellList{1})   , ' and ', num2str(cellList{2})];
else
    strProper = strjoin(cellfun(@(num)(num2str(num)), cellList(1:end-1), 'uni', false), ', ');
    strProper = [strProper, ', and ', num2str(cellList{end})];
end
end
