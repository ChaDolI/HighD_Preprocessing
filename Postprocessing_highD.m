%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Postprocessing highD dataset by ChaDolI
% https://github.com/ChaDolI/HighD_Preprocessing
% only change the setting!!!!!
clear
clc
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Setting
% Number of XX_track.csv data
track_data_number = '01';
% Switch on = 1 / off = 0
plot_switch = 1;
make_video_switch = 1;

%% Load data
% highD data set
% [frame id x y width height xVelocity yVelocity xAcceleration yAcceleration frontSightDistance backSightDistance dhw thw ttc precedingXVelocity
% precedingId followingId leftPrecedingId leftAlongsideId leftFollowingId
% rightPrecedingId rightAlongsideId rightFollowingId laneId]
highD_track                       = readtable([track_data_number '_tracks.csv']);
highD_recordingMeta               = readtable([track_data_number '_recordingMeta.csv']);

%% Post processing
% Coordinate(x : horizontal rightside is plus, y : vetical downwards is  plus)
data_length                       = size(highD_track);
data_length                       = data_length(1);
frame                             = [];
id                                = [];
x                                 = [];
y                                 = [];
vehicle_width                     = [];
vehicle_height                    = [];
xVelocity                         = [];
yVelocity                         = [];
yaw                               = [];
x_center                          = [];
y_center                          = [];
upperLaneMark                     = strsplit(cell2mat(table2array(highD_recordingMeta(1,14))),';');
lowerLaneMark                     = strsplit(cell2mat(table2array(highD_recordingMeta(1,15))),';');

for data_index = 1 : data_length
    if highD_track.x(data_index) >= 0 || highD_track.y(data_index) >= 0
        frame(end+1)              = highD_track.frame(data_index);
        id(end+1)                 = highD_track.id(data_index);
        x(end+1)                  = highD_track.x(data_index);
        y(end+1)                  = highD_track.y(data_index);
        vehicle_width(end+1)      = highD_track.width(data_index);
        vehicle_height(end+1)     = highD_track.height(data_index);
        xVelocity(end+1)          = highD_track.xVelocity(data_index);
        yVelocity(end+1)          = highD_track.yVelocity(data_index);

        % Calculate yaw, center x, center y
        yaw(end+1)                = atan(yVelocity(end)/xVelocity(end));
        x_center(end+1)           = x(end) + vehicle_width(end)/2;
        y_center(end+1)           = y(end) + vehicle_height(end)/2;
    end
end

frame                             = frame';
id                                = id';
x                                 = x';
y                                 = y';
vehicle_width                     = vehicle_width';
vehicle_height                    = vehicle_height';
xVelocity                         = xVelocity';
yVelocity                         = yVelocity';
yaw                               = yaw';
x_center                          = x_center';
y_center                          = y_center';

%% Plot data
if plot_switch == 1
    
    f = figure;
    f.Position = [0 600 1920 200];
    grid on;
    axis ij
    axis equal
    xlim([0,400]);
    ylim([0,35]);

    % plot lane
    for line_number = 1 : length(upperLaneMark)
        yline(str2double(upperLaneMark{line_number}));
        yline(str2double(lowerLaneMark{line_number}));
    end

    for frame_IDX = 1 : data_length
        title(['Frame : ' num2str(frame_IDX)]);
        frame_number             = [];
        car_bbox                  = [];
        % get all vehicle in the same frame
        for frame_index = 1 : data_length
            if frame(frame_index) == frame_IDX
                frame_number(end+1) = frame_index;
            end
        end
        % plot vehicle
        for car_number = 1 : length(frame_number)
            theta = yaw(frame_number(car_number));
            L = vehicle_width(frame_number(car_number));
            H = vehicle_height(frame_number(car_number));
            center_point = [x_center(frame_number(car_number)),y_center(frame_number(car_number))];
            draw_rectangle(center_point,L,H,theta,'b');
        end
        % save frame
        F(frame_IDX) = getframe(f);
        % delete vehicle bbox
        delete(findobj('type', 'patch'));
    end
end

%% Make video
if make_video_switch == 1
    writerObj = VideoWriter([track_data_number '_track_video.avi']);
    writerObj.FrameRate = highD_recordingMeta.frameRate;
    open(writerObj);
    for i=1:length(F)
        frame = F(i) ;
        writeVideo(writerObj, frame);
    end
    writeVideo(writerObj, frame_IDX);
    close(writerObj);
end