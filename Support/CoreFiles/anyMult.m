function logAny = anyMult(var)
    % Same as any(var(:)), but works on things that are unlinearizable!
    logAny = any(var);
    if numel(logAny) == 1
        return;
    else
        logAny = anyMult(logAny);
    end
end