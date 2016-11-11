function [ neutral_bin , moderate_bin , severe_bin , len ] = PostureBin( posture )
%PostureBin -- Classify posture data into neutral, moderate, and severe.
%   Input must be a vector of posture data.
%   Return values are the size of each bin and the overall length of the
%   data.

% Set parameter values:
moderate_point = 20;
severe_point = 45;
len = length(posture);

% We are only interested in magnitude of bending.
posture = abs(posture);

% Compute bin sizes.
neutral_bin = length(find(posture < moderate_point));    % < 20 degrees of bending in any direction.
moderate_bin = length(find(posture < severe_point)) - neutral_bin; % 21 - 45 degrees of bending.
severe_bin = len - (moderate_bin + neutral_bin);  % > 45 degrees of bending.

end

