%The Solver Function
%This function will, given a function base name, and a variable number of
%inputs, which follow the pattern: Lower value / value, upper value, step
%size, will test the function using all of these numbers/inputs.

function cArgs = Solver(sFName, iIterations, varargin)
    iStop = length(varargin);
    cArgs = cell(1, nargin(sFName));
    cSteps = cell(1, nargin(sFName));
    cAnswers = cell(1, nargout(sFName));
    cSolutions = cell(1, nargout(strcat(sFName, '_soln')));
    j = 1;
    
    if iStop / 2 ~= nargin(sFName)
        disp(strcat('Please enter the correct number of arguments! (', num2str(nargin(sFName)), ')'))
    end
    i = 0;
    while i < iStop / 2
        cSteps{1, i+1} = varargin{2 .* (i + 1)};
        cArgs{1, i+1} = varargin{2 .* i + 1};
        i = i + 1;
    end
    
    while i < length(cArgs)
        if and(iscell(cArgs{1, i}), cSteps{1, i} ~= 'N/A')
            disp(strcat('Please enter a valid argument and step size combination. Specifically, ', cArgs{1, i}, ',', cSteps{1, i}))
        end
    end
    
    iArgs = length(cArgs);
    sFNameSoln = [sFName, '_soln'];
    while j <= iIterations
        [cAnswers{:}] = feval(sFName, cArgs{:});
        [cSolutions{:}] = feval(sFNameSoln, cArgs{:});
        if isequal(cAnswers, cSolutions)
            i = 1;
            while i <= iArgs
                if isnumeric(cSteps{1, i})
                    cArgs{1, i} = cArgs{1, i} + cSteps{1, i};
                end
                i = i + 1;
            end
        else
            s = ' ';
            for i = 1:length(cArgs)
                s = sprintf('%s, %s',s,cArgs{i});
            end
            fprintf('There was a disagreement between your function and the solution. These were the arguments:%s.\rAnd the iteration Number was %d', s, j)            
            return
        end
        j = j + 1;
    end
    disp('Passed!')
end

    