%% Preprocessing ET data
% First attempt at preprocessing raw ET data. My plan is to chop the signal
% by trials, time-lock the time stamps to the start of each trials and to
% put everything into a single structure with trial info, x and y positions
% and pupil diameter.
clear; close all
%% Import data
% Data folder
if strcmpi(getenv('USER'), 'francescopupillo')
    main_folder = '/Users/francescopupillo/PowerFolders/PE_continuous_rolling/github/pilot_data';
    fun_folder = '/Users/francescopupillo/PowerFolders/PE_continuous_rolling/github/et';

else
    main_folder = '/home/francesco/PowerFolders/Frankfurt_University/EXPRA/Experiments/Analysis/PEmem/';
    fun_folder = '/home/francesco/PowerFolders/Frankfurt_University/EXPRA/Experiments/Analysis/PEmem/et';
end

% Folder with external tools
ext_func_folder = sprintf('%s/external_tools', main_folder);

% Which sub?
sub_folders = dir([main_folder]);

    % create an empty variable for the names of the folders
    which_subs = {};
    % loop through participants to get the participants for whom we have data
    counter = 1;
    for i = 1:length(sub_folders)
        filename = sub_folders(i).name;
        if ~ strcmp(sub_folders(i).name, '.') &&  ~ strcmp(sub_folders(i).name, '..') &&  ~ strcmp(sub_folders(i).name, '.DS_Store')% check if it is an empty file
            which_subs{counter} = filename;
            counter = counter+1;
        end
    end

%subs = cat(1, which_subs{:});

for n = 1:length(which_subs)
    
        % select the current subs
        curr_sub = which_subs{n};

        % check if there is the .edf file
        sub_folder = [main_folder, '/', curr_sub];
        cd(sub_folder);

       if ~ isempty(dir('et'))

            if length(curr_sub)==7
                sub_num = string(curr_sub(5:7));
            else
                sub_num = string(curr_sub(5:6));
            end
            
% Build some names
mat_file = sprintf('%s/sub-%s/et/sub-%s_by-trial_et.mat', main_folder, sub_num, sub_num);

% Load preprocessed data in .mat format
t = load(mat_file);
trial_data = t.data_by_trial;

%% Get fixations during window of interest (WOI)
% Second truck offset
woi_onset = 2500;

% Third truck onset
woi_offset = 3000;

% Loop through trials
for c_trial = 1:length(trial_data)

    % Get fixation data for the current trial
    curr_trial = trial_data(c_trial).fix_data;

    %
    woi_ind = curr_trial.start > woi_onset & curr_trial.start < woi_offset;

    % Grab position data
    woi(c_trial).eye = curr_trial.eye(woi_ind);
    woi(c_trial).x = curr_trial.x(woi_ind);
    woi(c_trial).y = curr_trial.y(woi_ind);
    woi(c_trial).pup = curr_trial.pup(woi_ind);

end

%% Output last fixation to a csv
% Loop through trials
c = 1; d = 1;
for c_trial = 1:length(woi)

    try
        % Get last fixation inside the woi
        if strcmpi(woi(c_trial).eye(end), 'LEFT')
            left_woi(c_trial,1) = c_trial;
            left_woi(c_trial,2) = woi(c_trial).x(end);
            left_woi(c_trial,3) = woi(c_trial).y(end);
            right_woi(c_trial,1) = c_trial;
            right_woi(c_trial,2) = woi(c_trial).x(end-1);
            right_woi(c_trial,3) = woi(c_trial).y(end-1);
            if strcmpi(woi(c_trial).eye(end-1), 'LEFT')
                error('Two final fixations of the same eye')
            end
        elseif strcmpi(woi(c_trial).eye(end), 'RIGHT')
             right_woi(c_trial,1) = c_trial;
            right_woi(c_trial,2) = woi(c_trial).x(end);
            right_woi(c_trial,3) = woi(c_trial).y(end);
            left_woi(c_trial,1) = c_trial;
            left_woi(c_trial,2) = woi(c_trial).x(end-1);
            left_woi(c_trial,3) = woi(c_trial).y(end-1);
             if strcmpi(woi(c_trial).eye(end-1), 'RIGHT')
                error('Two final fixations of the same eye')
             end
        end
    catch
        left_woi(c_trial,1) = c_trial;
        left_woi(c_trial,2) = NaN;
        left_woi(c_trial,3) = NaN;
        right_woi(c_trial,1) = c_trial;
        right_woi(c_trial,2) = NaN;
        right_woi(c_trial,3) = NaN;

    end

end

% Write to file
out = table(sort(repmat([1;2],100,1)), left_woi(:,1), left_woi(:,2), left_woi(:,3), 'VariableNames',...
    {'block';'trial_n'; 'x'; 'y'});
    % Print
out_name = sprintf('%s/sub-%s/et/sub-%s_eye-left_last-fixation_et.csv', main_folder, sub_num, sub_num);
writetable(out, out_name)

out = table(sort(repmat([1;2],100,1)), right_woi(:,1), right_woi(:,2), right_woi(:,3), 'VariableNames',...
    {'block';'trial_n'; 'x'; 'y'});
    % Print
out_name = sprintf('%s/sub-%s/et/sub-%s_eye-right_last-fixation_et.csv', main_folder, sub_num, sub_num);
writetable(out, out_name)
       end

end
