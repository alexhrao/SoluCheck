function logAny = anyMult(var)
    logAny = any(var);
    if numel(logAny) == 1
        return;
    else
        logAny = anyMult(logAny);
    end
end