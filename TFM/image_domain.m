function out = image_domain(fmc, zMin, zMax, zResolution, xResolution)
% out = image_domain(fmc, zMin, zMax, zResolution, xResolution)
%==========================================================================
% Calculates the distances between the array elements and the specified 
% domain pixels assuming a homogeneous media.
% 
% Input: 
%   fmc     struct
%   zMin   [mm]
%   zMax   [mm]
%   zResolution    pixels/[mm]
%   xResolution    pixels/[mm]
%
%
% Output: 
%   domain  struct
%
% Example:
%   zMin = 25;
%   zMax = 50;
%   zResolution = 10;
%   xResolution = 2;
%   domain = image_domain(fmc, zMin, zMax, zResolution, xResolution);

%==========================================================================
% Created: September 14, 2015, by Philip Lindbad
% Last modified: November 8, 2015, by Philip Lindbad
%==========================================================================

% Transducer coordinates
transducer = [fmc.x'+0.5*fmc.cfg.ElementXwidthmm*1e-3, zeros(length(fmc.x),1)];

% Pixel coordinates
xRange = interp(transducer(:,1), xResolution);
zRange = linspace(zMin*1e-3,zMax*1e-3, round(zResolution*(zMax-zMin)) )';
pixels = [kron(xRange,ones(length(zRange),1)), ...
    repmat(zRange,[length(xRange),1])];

Rx = pdist2(pixels,transducer); % Find distances between pixels and transducer coordinates

% Change Rx from a matrix of distances to number of samples, i.e. indices
% in the Ascans.
Rx = Rx - 0.5 * fmc.cfg.SampleOffset*fmc.cfg.Velocityms/(fmc.cfg.FreqMHz*1e6);
Rx = round(Rx/(fmc.cfg.Velocityms / (fmc.cfg.FreqMHz*1e6)));

out.min = abs(min(Rx(:)));
out.max = 2 * max(Rx(:)) - length(fmc.Ascans);
out.Rx = Rx + out.min + 1;
out.xRange = xRange;
out.zRange = zRange;

end