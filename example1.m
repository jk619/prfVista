clc
clear
close all

%% File setup

%load example stim and data
load(fullfile(prfRootPath, 'local', 'data.mat'));
load(fullfile(prfRootPath, 'local', 'stim.mat'));

datafiles{1} = data;
stimfiles{1} = stim;
stimradius = 10; % in degrees
tr = 1.5; % in seconds

whos

% <data> -> consists of 8 timecourses (x,t) where (t)ime is the second
% dimension and it describes the number of acquired volumes (TRs)

% Size of data has two dimensions (commonly this is the shape of data
% extracted from the surface, number of vertices X number of TRs)

% stim -> provides the apertures as a cell vector of R x C x time values
% should be in [0,1].  The number of time points can differ across runs

% If you're using more runs, each of them should be stored in datafiles and
% stimfiles as next cells i.e
% datafiles{2} = data2
% stimfiles{2}= stim2;

% Data in each cell of datafiles has to be a matrix where last dimension
% is time
% 1) for surfcae (nVertex x nTRs)
% 2) for volume (X x Y x Z x nTRs)

% Stimuli aperture in stimfiles has to be a 3D matrix where last dimension
% is time.

fprintf('There are %d runs in total.\n',length(datafiles));
fprintf('The dimensions of the data for the first run are %s.\n',mat2str(size(datafiles{1})));
fprintf('The stimulus radius is %.0f seconds.\n',stimradius);
fprintf('The sampling rate (TR) is %.3f seconds.\n',tr);
fprintf('Stimulus size is %i X %i X %i.\n',size(stimfiles{1}));


%% Example data from one vertex
figure(1); clf
plot(datafiles{1}(1,:),'-')
xlabel('TRs')
ylabel('BOLD signal')
set(gca,'FontSize',15)

%% Example stimulus aperture
figure(2);clf
show_frames = [20 25 35 50];

for s = 1 : length(show_frames)
    
    subplot(2,2,s)
    imagesc(stimfiles{1}(:,:,show_frames(s))); colormap gray; axis off
    title(sprintf('Frame %i/%i from stimulus sequence',show_frames(s),size(stimfiles{1},3)))
    
end

%% We will now run pRFVista on the surface data

results = prfVistasoft(stimfiles, datafiles, stimradius,'tr',tr);

%%
% These are the results from fitting pRFs with vistasoft on 8 vertices.
results.model{1}
%% We will now run pRFVista on the volumetric data

datafiles{1} = reshape(data,[2 2 2 200]); % reshape data to volume
stimfiles{1} = stim;
results = prfVistasoft(stimfiles, datafiles, stimradius,'tr',tr);

% Size of data has four dimensions (commonly this is the shape of data
% extracted from the volume (X x Y x Z x nTRs)



%%
% These are the results from fitting pRFs with vistasoft on 8 voxels.

results.model{1}

