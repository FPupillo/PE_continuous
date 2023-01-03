function [trial] = maketrials_eyetracking(mdat)

%First input = data after importeyes; second input = trigger
event_labels=mdat.evt;
trial_indices = find(startsWith(event_labels, 'TRIALID'));
onset_truck = find(startsWith(event_labels, 'onset_trucks_trial'));
%trial_onsets = mdat.evT(trial_indices);
trial_onsets = mdat.evT(onset_truck);
trial_end = find(startsWith(event_labels, 'onset_object_indout'));
trial_offsets = mdat.evT(trial_end);

% Make epochs
for c_trial = 1:length(trial_indices)

    % Current trial
    trial_ind = trial_indices(c_trial);
    trial_onset_timestamp=find(mdat.time==trial_onsets(c_trial));
    trial_offset_timestamp=find(mdat.time==trial_offsets(c_trial));

    % Quick check in case the event timestamp is one millisecond before the
    % gaze recorded time
    if isempty(trial_onset_timestamp)
        trial_onset_timestamp=find(mdat.time==trial_onsets(c_trial)+1);
    end
    if isempty(trial_offset_timestamp)
        trial_offset_timestamp=find(mdat.time==trial_offsets(c_trial)+1);
    end

    % Grab the trial info
    trial(c_trial).n = str2num(event_labels{trial_ind}(9:end));
    trial(c_trial).map = event_labels{trial_ind+1};
    if c_trial < 101
        trial(c_trial).block = 1;
    else
        trial(c_trial).block = 2;
    end

    % Grab eye data
    trial(c_trial).x = mdat.x(trial_onset_timestamp:trial_offset_timestamp,:);
    trial(c_trial).y = mdat.y(trial_onset_timestamp:trial_offset_timestamp,:);
    trial(c_trial).pup = mdat.p(trial_onset_timestamp:trial_offset_timestamp,:);
    trial(c_trial).time = mdat.time(trial_onset_timestamp:trial_offset_timestamp);

    % Time-lock data to the onset of the trial
    trial(c_trial).time = trial(c_trial).time - mdat.time(trial_onset_timestamp);

    % Grab fixation info. I'm taking only fixation which start within the
    % trial
    fixation_ind_trial = mdat.efix.start > mdat.time(trial_onset_timestamp) & ...
        mdat.efix.start <= mdat.time(trial_offset_timestamp);
    trial(c_trial).fix_data.eye = mdat.efix.eye(fixation_ind_trial);
    trial(c_trial).fix_data.start = mdat.efix.start(fixation_ind_trial);
    trial(c_trial).fix_data.end = mdat.efix.end(fixation_ind_trial);
    trial(c_trial).fix_data.durations = mdat.efix.duration(fixation_ind_trial);
    trial(c_trial).fix_data.x = mdat.efix.posX(fixation_ind_trial);
    trial(c_trial).fix_data.y = mdat.efix.posY(fixation_ind_trial);
    trial(c_trial).fix_data.pup = mdat.efix.pupilSize(fixation_ind_trial);

    % Time-lock fixation data to the onset of the trial
    trial(c_trial).fix_data.start = trial(c_trial).fix_data.start - mdat.time(trial_onset_timestamp);
    trial(c_trial).fix_data.end = trial(c_trial).fix_data.end - mdat.time(trial_onset_timestamp);
end

% Check trial duration distribution. I'll store the trial numbers of those
% with too long durations
c = 1;temp=[];too_long=[];
for i = 1:length(trial)
    temp(i) = max(trial(i).time);
    if temp(i)>9000
        too_long(c)= i;
        c = c+1;
    end
end
hist(temp); title('Histogram of recorded trial durations');
text(8500, 100, sprintf('Duration above 9s:'))
pos_y = 95;
for i = 1:length(too_long)
    text(8500, pos_y, sprintf('Trial %d', too_long(i)))
    pos_y=pos_y - 3;
end

end