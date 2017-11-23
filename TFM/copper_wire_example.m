%% Load data and set parameters
filename = 'FMC-copper-wiresFRD';

% Transducer parameters
fmc = {};
fmc.cfg.NumXelements = 64;
fmc.cfg.ElementXpitchmm = 0.5;
fmc.cfg.ElementXwidthmm = 0.4;
fmc.cfg.SampleOffset = 811;
fmc.cfg.Velocityms = 1480;
fmc.cfg.FreqMHz = 40;
fmc.cfg.NumSamples = 4324;
fmc.cfg.NumTx = 64;

fmc.x = (0:fmc.cfg.NumXelements-1)*fmc.cfg.ElementXpitchmm*1e-3;


fmc.Ascans = single(imread([filename,'.png'])');
fmc.Ascans = fmc.Ascans - repmat(mean(fmc.Ascans),size(fmc.Ascans,1),1);
fmc.Ascans = hilbert(fmc.Ascans);
fmc.Ascans = reshape(fmc.Ascans,size(fmc.Ascans,1),...
                     size(fmc.Ascans,2)/fmc.cfg.NumTx,...
                     fmc.cfg.NumXelements);
%% Set image domain
zMin = 0;
zMax = 90;
zResolution = 10; % pixels per mm in z direction
xResolution = 2;  % pixels per mm in x direction
domain = image_domain(fmc, zMin, zMax, zResolution, xResolution);

%% zero pad Ascans
fmc.Ascans = [ zeros(2*domain.min, size(fmc.Ascans,2),size(fmc.Ascans,3));
               fmc.Ascans;
               zeros(domain.max, size(fmc.Ascans,2),size(fmc.Ascans,3))
             ];
fmc.cfg.NumSamples = length(fmc.Ascans);

%% Total focusing method
tic
image = tfm(fmc, domain);
toc

%% Plot image

% transform data to dB scale
normalize = @(x) x./max(x(:));
fun = @(x) 20*log10(normalize(abs(x)));

% dB range in image
dB = [-60,0];

figure
imagesc(image.xRange*1000,image.zRange*1000,fun(image.image),dB)
xlabel('mm')
ylabel('mm')
colormap('jet')

