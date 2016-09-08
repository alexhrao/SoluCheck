%The Solver Function
%This function will, given a function base name, and a variable number of
%inputs, which follow the pattern: Lower value / value, upper value, step
%size, will test the function using all of these numbers/inputs.

function Solver(sFName, iIterations, varargin)
    cArgsOriginal = cell(1, nargin(sFName));
    iStop = length(varargin);
    cArgs = cell(1, nargin(sFName));
    cSteps = cell(1, nargin(sFName));
    cAnswers = cell(1, nargout(sFName));
    cSolutions = cell(1, nargout(strcat(sFName, '_soln')));
    j = 1;
    
    if iStop / 2 ~= nargin(sFName)
        error(strcat('Please enter the correct number of arguments! (', num2str(nargin(sFName)), ')'))
    end
    i = 0;
    while i < iStop / 2
        cSteps{1, i+1} = varargin{2 .* (i + 1)};
        cArgs{1, i+1} = varargin{2 .* i + 1};
        cArgsOriginal{1, i + 1} = varargin{2 .* (i + 1)};
        i = i + 1;
    end
    
    while i < length(cArgs)
        if and(~isnumeric(cArgs{1, i}), cSteps{1, i} ~= 'N/A')
            error(strcat('Please enter a valid argument and step size combination. Specifically, ', cArgs{1, i}, ',', cSteps{1, i}))
        end
    end
    
    iArgs = length(cArgs);
    while j <= iIterations
        [cAnswers{:}] = feval(sFName, cArgs{:});
        [cSolutions{:}] = feval(strcat(sFName, '_soln'), cArgs{:});
        for k = 1:nargout(sFName)
            if isequal(cAnswers{1, k}, cSolutions{1, k})
            i = 1;
                while i < iArgs
                    if isnumeric(cSteps{1, i})
                        cArgs{1, i} = cArgs{1, i} + cSteps{1, i};
                    end
                    i = i + 1;
                end
            else
                s = ' ';
                for i = 1:length(cArgs)
                    s = sprintf('s, %s', cArgs{i});
                end
                error(sprintf('There was a disagreement between your function and the solution. These were the arguments %s.\rAnd the iteration Number was %d', s, j))            
            end
        end
        j = j + 1;
    end
    disp('Passed!')
end

    