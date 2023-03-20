%% Preprocessing ET data
% First attempt at preprocessing raw ET data. My plan is to chop the signal
% by trials, time-lock the time stamps to the start of each trials and to
% put everything into a single structure with trial info, x and y positions
% and pupil diameter.
clear; close all
%% Import data
% Data folder
if strcmpi(getenv('USER'), 'francescopupillo')
    main_folder = '~/PowerFolders/PreCont_analysis/YA/';
    fun_folder = '~/PowerFolders/PreCont_analysis/YA/et';

else if strcmpi(getenv('USER'), 'ata')
    main_folder = '~/PowerFolders/PreCont_analysis/YA/';
    fun_folder = '~/PowerFolders/PreCont_analysis/YA/et';
else
    main_folder = '/home/francesco/PowerFolders/Frankfurt_University/EXPRA/Experiments/Analysis/PEmem/';
    fun_folder = '/home/francesco/PowerFolders/Frankfurt_University/EXPRA/Experiments/Analysis/PEmem/et';
end
end

addpath(fun_folder);

% Folder with external tools
ext_func_folder = sprintf('%s/_external_tools', fun_folder);

% Which sub?
sub_folders = dir([main_folder, 'clean_data']);

% create an empty variable for the names of the folders
which_subs = {};
% loop through participants folder and get the files of 
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
    sub_folder = [main_folder, 'clean_data/', curr_sub];
    cd(sub_folder);

    if ~ isempty(dir('et'))

        sub_num = string(curr_sub(5:7));

        % Build some names
        % sub_folder = sprintf('%s/sub_%d', data_folder, which_sub);
        edf_file = sprintf('%s/clean_data/%s/et/%s', main_folder, curr_sub, sub_num);
        mat_file = sprintf('%s/clean_data/%s/et/%s.mat', main_folder, curr_sub, sub_num);

        % Convert EDF file to .mat
        if ~exist(mat_file)
            % Add edf2mat toolbox
            addpath(genpath(fun_folder));
            addpath(genpath(sprintf('%s/edf-converter-master/', ext_func_folder)));

            % Create it
            importeyes(edf_file)
            sprintf('Data converted for sub-%s', sub_num)

        else
            sprintf('Data for sub-%s already exists in .mat format, will load it now.', sub_num)
        end

        % Load data in .mat format
        t = load(mat_file);
        raw_data = t.mdat;

        %% Chop data into epochs
        % I'm putting this into a separate function to keep it cleaner
        data_by_trial = maketrials_eyetracking(raw_data);

        %% Save it for later use
        output_name = sprintf('%s/clean_data/%s/et/sub-%s_by-trial_et.mat', main_folder, curr_sub, sub_num);
        save(output_name, 'data_by_trial');
    end
end

cd(main_folder);