%The Solver Function
%This function will, given a function base name, and a variable number of
%inputs, which follow the pattern: Lower value / value, upper value, step
%size, will test the function using all of these numbers/inputs.

function Solver(sFName, iMaximum, varargin)
    iStop = length(varargin);
    cArgs = {};
    cSteps = {};
    cAnswers = {};
    cSolutions = {};
    j = 1;
    if mod(iStop, 2) == 1
        error('Please enter the correct amount of arguments!')
    end
    i = 0;
    while i < iStop / 2
        cSteps{1, i+1} = varargin{2 .* (i + 1)}; %#okGROW
        cArgs{1, i+1} = varargin{2 .* i + 1}; %#okGROW
        i = i + 1;
    end
    
    while i < length(cArgs)
        if and(~isnumeric(cArgs{1, i}), cSteps{1, i} ~= 'N/A')
            error(strcat('Please enter a valid argument and step size combination. Specifically, ', cArgs{1, i}, ',', cSteps{1, i}))
        end
    end
    
    iArgs = length(cArgs);
    while j < iMaximum
        varargout = feval(sFName, cArgs{:});
        for i = 1:nargout(sFName)
            cAnswers{1, i} = varargout(i); %#okGROW
        end
        varargout = feval(strcat(sFName, '_soln'), cArgs{:});
        for i = 1:nargout(strcat(sFName, '_soln'))
            cSolutions{1, i} = varargout(i); %#okGROW
        end
        for k = 1:nargout(sFName)
            if isequal(cAnswers{1, k}, cSolutions{1, k})
            i = 1;
                while i < iArgs
                    if isnumeric(cSteps{1, i})
                        cArgs{1, i} = cArgs{1, i} + cSteps{1, i}; %#okGROW
                    end
                    i = i + 1;
                end
            else
                error(strcat('There was a disagreement between your function and the solution. Please check this sequence of arguments: ', cellstr(cell2mat(cArgs))))
            end
        end
        j = j + 1;
    end
    disp('Passed!')
end

    