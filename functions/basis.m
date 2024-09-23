function b = basis(K, t, varargin)

% BASIS Generate basis functions based on the specified type.
%
%   b = BASIS(K, x) generates the Fourier basis functions with parameter K and input x.
%
%   b = BASIS(K, x, type) specifies the type of basis to generate.
%   Valid options for type are 'Fourier', 'Cosine', and 'Meyer'.
%
%   Inputs:
%       K          - Parameter for the basis functions (scalar or vector)
%       x          - Input vector
%       type - (Optional) Type of basis to generate ('Fourier', 'Cosine', 'Meyer')
%
%   Output:
%       b          - Matrix of basis functions evaluated at x

    % Default basis type
    type = 'Fourier';

    % Parse optional arguments
    if ~isempty(varargin)
        type = varargin{1};
    end

    % Validate 'K' based on 'type'
    switch lower(type)
        case {'fourier', 'cosine'}
            if ~isscalar(K)
                error('For basis type ''%s'', K must be a scalar.', type);
            end
        case 'meyer'
            if ~isvector(K) || length(K) ~= 2
                error('For basis type ''Meyer'', K must be a 1x2 vector.');
            end
        otherwise
            error('Unknown basis type: %s', type);
    end

    % Generate basis functions based on 'type'
    if strcmpi(type, 'Fourier')
        k = 1:K;
        sb = @(k, x) sqrt(2) * sin(2 * pi * k' * x);
        cb = @(k, x) sqrt(2) * cos(2 * pi * k' * x);
        
        % Preallocate b for efficiency
        b = zeros(2 * K, length(t));
        % Compute sine and cosine terms
        b(1:2:end, :) = cb(k, t);
        b(2:2:end, :) = sb(k, t);

    elseif strcmpi(type, 'Cosine')
        k = 1:K;
        cb = @(k, x) sqrt(2) * cos(pi * k' * x);

        % Compute cosine terms
        b = cb(k, t);

    elseif strcmpi(type, 'Meyer')

        b = meyerbasisgenerator(K(1), K(2), t);
    
    end

end