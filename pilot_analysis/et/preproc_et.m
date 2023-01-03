%% Preprocessing ET data
% First attempt at preprocessing raw ET data. My plan is to chop the signal
% by trials, time-lock the time stamps to the start of each trials and to
% put everything into a single structure with trial info, x and y positions
% and pupil diameter.
clear; close all
%% Import data
% Data folder
if strcmpi(getenv('USER'), 'javierortiz')
    main_folder = '/Users/javierortiz/PowerFolders/PE_continuous_rolling (Francesco Pupillo)/pilot_data/';
elseif strcmpi(getenv('USER'), 'francesco')
    main_folder = '/home/francesco/PowerFolders/PE_continuous_rolling/pilot_data/';
else 
    main_folder = '/Users/francescopupillo/PowerFolders/PE_continuous_rolling/pilot_data/';
    fun_folder = '/Users/francescopupillo/PowerFolders/PE_continuous_rolling/pilot_analysis/'
end

% Folder with external tools
ext_func_folder = sprintf('%s_external_tools', fun_folder);

% Which sub?
which_sub = 193;

% Build some names
% sub_folder = sprintf('%s/sub_%d', data_folder, which_sub);
edf_file = sprintf('%s/sub_%d/et/%d', main_folder, which_sub, which_sub);
mat_file = sprintf('%s/sub_%d/et/%d.mat', main_folder, which_sub, which_sub);

% Convert EDF file to .mat
if ~exist(mat_file)
    % Add edf2mat toolbox
    addpath(genpath(fun_folder));
    addpath(genpath(sprintf('%s/edf-converter/', ext_func_folder)));

    % Create it
    importeyes(edf_file)
    sprintf('Data converted for sub-%d', which_sub)

else
    sprintf('Data for sub-%d already exists in .mat format, will load it now.', which_sub)
end

% Load data in .mat format
t = load(mat_file);
raw_data = t.mdat;

%% Chop data into epochs
% I'm putting this into a separate function to keep it cleaner
data_by_trial = maketrials_eyetracking(raw_data);

%% Save it for later use
output_name = sprintf('%s/sub_%d/et/sub-%d_by-trial_et.mat', main_folder, which_sub, which_sub);
save(output_name, 'data_by_trial');
