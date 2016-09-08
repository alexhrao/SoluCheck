function intTotal = stcNumel(stcVar)
cellFields = fieldnames(stcVar);
intTotal = sum(cellfun(@(str)(numel(stcVar.(str))), cellFields));
end