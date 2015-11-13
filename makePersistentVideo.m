%% Ben Conrad - Video Manipulate - 20151113
clc; close all; clear all; format compact;

%In this code I had a laser dot and wanted to make it's position persist between frames so that the path could be visualized and compared to an ellipse
%Resulting version is at []

%% Load
vid = VideoReader('D:\flat\20140918_conference_ICRA2015\20150515_conference_ICRA2015_presentation\cleanedVideo\20150521_DSC_0049.MOV'); %input
wr = VideoWriter('D:\flat\20140918_conference_ICRA2015\20150515_conference_ICRA2015_presentation\cleanedVideo\20150521_DSC_0049_ghosted.avi','Motion JPEG AVI'); %output
int = 1; %change framerate
    wr.FrameRate = vid.FrameRate/int;
    wr.open;

%% Make Movie
t1 = now;
tic
nframes = vid.NumberOfFrames;
clear mov; close all;

% Preallocate                   V-   make room    - V
movtemp = struct('cdata', zeros(vid.Width, vid.Height, 3, 'uint8'),'colormap',[]); %movie template
mov = movtemp;

dotRed = 254; 
dotGB = .95;
hist = ones(vid.NumberOfFrames, 2);
% for k = 3850:1:3950; %try it on small subsets, this is single-core cpu only!
for k = 1:int:vid.NumberOfFrames;
    if mod(k-1,100)==0; fprintf('Frame %d of %d after %3.4f\n',k,vid.NumberOfFrames, etime(t1,now)); end;
    %movie
        img = vid.read(k); %read frame k
        [m,n,~] = size(img);

        %can adjust some curves as if it were an image
        ima = img;
        % for i = 1:3; ima(:,:,i) = imadjust(img(:,:,i)); end; %too white
        % for i = 1:3; ima(:,:,i) = imadjust(img(:,:,i), [0,200/255], []); end; % ratio from imshow(img(:,:,1)); imcontrast(gca);
        % ima = imadjust(img, [0,0,0; .8,.75,.65],[]);
        % ima = imfilter(ima, fspecial('disk',3));
        
        for i = 1:m;
            for j = 1:n;
                if img(i,j,1) > dotRed && img(i,j,2) < 150 && img(i,j,3) < 150
                    ima(i,j,1) = 255; %make it more red
                    ima(i,j,2) = dotGB*ima(i,j,2);
                    ima(i,j,2) = dotGB*ima(i,j,2);
                    hist(end+1,:) = [i,j]; %#ok<SAGROW>
                end
            end
        end
        %apply history to this frame
        for i = 1:size(hist,1);
            ima(hist(i,1),hist(i,2),1) = 255;
            ima(hist(i,1),hist(i,2),2) = dotGB*ima(hist(i,1),hist(i,2),2);
            ima(hist(i,1),hist(i,2),3) = dotGB*ima(hist(i,1),hist(i,2),3);
        end
        
        mov.cdata = ima; %copy the color data into the movie frame
    wr.writeVideo(mov.cdata);
end

wr.close;
disp(['Made ',num2str(k),' frames in:']);
toc