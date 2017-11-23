function out = tfm(fmc,domain)
% out = tfm(fmc,domain)
%==========================================================================
% Total focusing method
% 
% Input: 
%   fmc struct 
%   domain struct
%
% Output:
%   out struct
%
%==========================================================================
% Created: September 14, 2015, by Philip Lindbad
% Last modified: November 5, 2015, by Philip Lindbad
%==========================================================================

% Pre load variables
w = ones(fmc.cfg.NumXelements,1);
image = 0*domain.Rx(:,1);
Rx = domain.Rx;
Ascans = fmc.Ascans;

Q = 0:fmc.cfg.NumSamples:fmc.cfg.NumSamples*(fmc.cfg.NumXelements-1);

% For each element transmission
for i = 1:fmc.cfg.NumXelements
    IMG = Ascans(:,:,i);                            % get B-scan from transmit element i
    Rx_Tx = bsxfun(@plus, Rx, Rx(:,i));             % find delays
    Rx_Tx = bsxfun(@plus, Rx_Tx, Q);                % Correction for linear indexing
    TMP = IMG(Rx_Tx);                               % Extract data from B-scan using delays
    image = image + TMP*w;                          % Sum and add to image
end

out.image = reshape(image,[length(domain.zRange),length(domain.xRange)]);
out.xRange = domain.xRange;
out.zRange = domain.zRange;