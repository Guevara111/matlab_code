function varargout = gui1(varargin)
% GUI1 MATLAB code for gui1.fig
%      GUI1, by itself, creates a new GUI1 or raises the existing
%      singleton*.
%
%      H = GUI1 returns the handle to a new GUI1 or the handle to
%      the existing singleton*.
%
%      GUI1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1.M with the given input arguments.
%
%      GUI1('Property','Value',...) creates a new GUI1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1

% Last Modified by GUIDE v2.5 03-Feb-2023 23:22:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui1 is made visible.
function gui1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1 (see VARARGIN)

% Choose default command line output for gui1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, cd1] = uigetfile( {'*.avi';'*.mp4;'},'Pick an Video');

if filename
filename = [cd1,filename];
video = vision.VideoFileReader(filename, 'ImageColorSpace', 'RGB');
end
axes(handles.axes1);
set(gca,'Xtick',[]);
set(gca,'Ytick',[]);
box on;
vidObj = VideoReader(filename);
writerObj = VideoWriter('testOut.avi');
open(writerObj);
while hasFrame(vidObj)
    original = readFrame(vidObj);
    original_hsv = rgb2hsv(original);
    axes(handles.axes1)
    imshow(original);

    axes(handles.axes2)
    imshow(original_hsv);

    filter_hsv = (original_hsv(:,:,1))>0.16;
    filter_hsv = filter_hsv.*(original_hsv(:,:,2))>0.5;
    filter_hsv = filter_hsv.*(original_hsv(:,:,2))<0.6;
    filter_hsv = filter_hsv.*(original_hsv(:,:,3))>0.95;

    filter_hsv3(:,:,1) = filter_hsv;
    filter_hsv3(:,:,2) = filter_hsv;
    filter_hsv3(:,:,3) = filter_hsv;

    hsv = double(original).*filter_hsv3;

    hsv = uint8(hsv);

    ratio = 245/180;
    bias = 0.3;

    hsv_gray = rgb2gray(hsv);
    hsv_binary = im2bw(hsv_gray);

    hsv_dilate = hsv_binary;

    [B,L] = bwboundaries(hsv_dilate,'noholes');
    max_ = size(B,1);
    filter_hsv_ = filter_hsv;
    Ck_Threshod = 2;
    if max_ ~= 0
        axes(handles.axes3)
        imshow(hsv_dilate);
        hold on;
            % handle every single situation independently
            for iii=1:max_
                boundary = B{iii};
                tempRatio = range(boundary(:,1))/range(boundary(:,2));
                % not in the range
                if tempRatio < ratio*(1-bias) || tempRatio > ratio*(1+bias)
                    selected = (L == iii);
                    selected = ~selected;
                    filter_hsv=filter_hsv.*selected;
                    plot(boundary(:,2), boundary(:,1),'m','LineWidth',2);
                else
                    plot(boundary(:,2), boundary(:,1),'g','LineWidth',2);
                end
            end

            filter_hsv3(:,:,1) = filter_hsv;
            filter_hsv3(:,:,2) = filter_hsv;
            filter_hsv3(:,:,3) = filter_hsv;

            hsv = double(original).*filter_hsv3;

            hsv = uint8(hsv);

            axes(handles.axes4);
            imshow(hsv);
    end

    hsv_dilate = hsv_dilate.*filter_hsv;
    hsv_dilate = im2bw(hsv_dilate);
    [B,L] = bwboundaries(hsv_dilate,'noholes');
    max_ = size(B,1);
    if max_ ~= 0
        axes(handles.axes5);
        imshow(hsv_dilate);
        hold on;
        for iii=1:max_
            boundary = B{iii};
            stats = regionprops('table',B{iii},'Area','Perimeter');
            Ck = 4*pi*sum(stats.Area)/(sum(stats.Perimeter)).^2;
            if Ck > Ck_Threshod
                selected = (L == iii);
                selected = ~selected;
                filter_hsv=filter_hsv.*selected;
%                 plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);
            else
                plot(boundary(:,2), boundary(:,1),'b','LineWidth',2);
            end
        end
        filter_hsv3(:,:,1) = filter_hsv;
        filter_hsv3(:,:,2) = filter_hsv;
        filter_hsv3(:,:,3) = filter_hsv;

        hsv = double(original).*filter_hsv3;

        hsv = uint8(hsv);

        axes(handles.axes6);
        imshow(hsv);
    end
    hsv_dilate = hsv_dilate.*filter_hsv;
    hsv_dilate = im2bw(hsv_dilate);
    imshow(hsv_dilate);
    [B,L] = bwboundaries(hsv_dilate,'noholes');
    max_ = size(B,1);
    axes(handles.axes7);
    imshow(original);
    hold on;
    if max_ ~= 0
%         subplot(2,3,5);
        
        for iii=1:max_
            boundary = B{iii};
            stats = regionprops('table',B{iii},'Area','Perimeter');
            Ck = 4*pi*sum(stats.Area)/(sum(stats.Perimeter)).^2;
            if Ck > Ck_Threshod
                selected = (L == iii);
                selected = ~selected;
                filter_hsv=filter_hsv.*selected;
%                 plot(boundary(:,2), boundary(:,1),'r','LineWidth',2);
            else
                plot(boundary(:,2), boundary(:,1),'b','LineWidth',2);
            end
         end
    end 
%     writeVideo(writerObj,getframe);
end
close(writerObj);
