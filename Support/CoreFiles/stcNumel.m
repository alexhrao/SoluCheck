function intTotal = stcNumel(stcVar)
% Get the number of elements in a structure.
cellFields = fieldnames(stcVar);
intTotal = sum(cellfun(@(str)(numel(stcVar.(str))), cellFields));
end