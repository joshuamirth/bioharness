function [ theta ] = AccelToPosture( x , y , z )
%AccelToPosture -- Compute posture angle from x,y,z acceleration data.
%   The inputs must all be equal length vectors.
%   x is assumed to be the vertical componenet of acceleration.
%   y is the lateral acceleration.
%   z is the sagittal acceleration.
%   theta is the posture angle, output in degrees.

% Validate input:
len = length(x);
if abs(len - length(y)) > 0 | abs(len - length(z)) > 0
    error('X,Y,Z acceleration vectors must be same size!');
    return
end

% Compute the magnitude of the acceleration:
a = zeros(1,len);
theta = zeros(1,len);
a = sqrt(x.^2 + y.^2);
theta = atan(a./z);      % Note: atan between -pi/2 and pi/2
theta = 360*theta./(2*pi);  % Convert to degrees.
%theta = -90*ones(len,1) - theta; % Want angle down from vertical.

end