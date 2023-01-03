%% Gaze pattern for the entire trial duration
% First attempt at looking at the eye position during the entire trial.
clear; close all
%% Import data
% Data folder
if strcmpi(getenv('USER'), 'javierortiz')
    main_folder = '/Users/javierortiz/PowerFolders/PE_continuous_rolling (Francesco Pupillo)/pilot_data/';
else
    main_folder = '/home/francesco/PowerFolders/PE_continuous_rolling/pilot_data/';
end

% Which sub?
which_sub = 991;

% Build some names
mat_file = sprintf('%s/sub_%d/et/sub-%d_by-trial_et.mat', main_folder, which_sub, which_sub);

% Load preprocessed data in .mat format
t = load(mat_file);
trial_data = t.data_by_trial;

% Folder with task data
data_folder = sprintf('%s/sub_%d/beh', main_folder, which_sub);

% Load csv files with the task data
task_data = readtable(sprintf('%s/%d_test3_2022-11-25_14h12.08.665.csv', data_folder, which_sub));
task_data = task_data(6:end,:);

%% Get fixations during window of interest (WOI)
% Second truck offset
woi_onset = 3000;

% Third truck onset
woi_offset = 3500;

truck_time = [500,1500,2500];

c=1;
% Loop through trials
for c_trial = 31:50 %length(trial_data)

    % Get fixation data for the current trial
    et_trial = trial_data(c_trial);

    % Task data for current trial
    task_trial = task_data(c_trial,:);

    % Positions
    truck_pos(1) = deg2rad(task_trial.pos_1);
    truck_pos(2) = deg2rad(task_trial.pos_2);
    truck_pos(3) = deg2rad(task_trial.degrees);

    % Trial duration
%     for c_timepoint = 1:length(et_trial.x)
% 
%         pos(c_timepoint) = cart2pol(et_trial.x(c_timepoint), et_trial.y(c_timepoint));
% 
%     end

    % Screen info
    screen_size = [1920, 1080];
    gray_col = [1 1 1];
    % Plot raw gaze
    for c_timepoint = 1:length(et_trial.x)
%         subplot(4,5,c), 
        scatter(et_trial.x(c_timepoint,1), ...
            et_trial.y(c_timepoint,1), MarkerFaceColor=[gray_col], MarkerEdgeColor=[gray_col]); hold on
        gray_col = gray_col - (1/length(et_trial.x));
        if c_timepoint == 1
             scatter(et_trial.x(c_timepoint,1), ...
            et_trial.y(c_timepoint,1), MarkerFaceColor=[0,1,0], LineWidth=20, Marker="o");
        elseif c_timepoint == length(et_trial.x)
            scatter(et_trial.x(c_timepoint,1), ...
            et_trial.y(c_timepoint,1), MarkerFaceColor=[1,0,0], LineWidth=20, Marker="+");
        end
    end
    xlim([100,screen_size(1)-100]);ylim([100,screen_size(2)-100])


    if strcmpi(task_trial.type, 'low')
        title_color = 'k';
    elseif strcmpi(task_trial.type, 'medium')
        title_color = 'b';
    elseif strcmpi(task_trial.type, 'high')
        title_color = 'r';
    else
        title_color = 'g';
    end
    title(sprintf('Trial %d', c_trial), 'Color', title_color)

    % Plot trucks
    for i = 1:3
        [x, y] = pol2cart(truck_pos(i), 330);
        x = x+screen_size(1)/2;
        y = y + screen_size(2)/2;
        text(x, y, sprintf('truck %d', i), "Color", 'k', 'FontSize',15)
    end


    %     subplot(5,5,c),plot(pos);ylim([0,pi*2]);
    %     for c_truck = 1:3
    %         text(truck_time(c_truck),truck_pos(c_truck), num2str(truck_pos(c_truck)));
    %     end
    c=c+1;

end