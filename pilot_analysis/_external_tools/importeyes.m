function [eyemat] = importeyes(edf_file)
% Reads .edf to .mat file and renames fields for easier handling -- requires edf2mat toolbox
% Extend as needed to include more Eyelink outputs/events/info
% This script creates .mat in same folder where .edf are
% Original script by BS and JLD (https://doi.org/10.1101/2022.11.17.516917)
% Adapted by JOT (fjavierot@gmail.com).

mdat=[];
%actfile=[edf_file '.edf'];
actfile=[edf_file '.EDF'];
dat = Edf2Mat(actfile);
mdat.evt=dat.Events.Messages.info;
mdat.evT=dat.Events.Messages.time;
mdat.x=dat.Samples.posX;
mdat.y=dat.Samples.posY;
mdat.p=dat.Samples.pupilSize;
mdat.time=dat.Samples.time;
mdat.efix=dat.Events.Efix;
eyemat=[edf_file '.mat'];
save(eyemat, 'mdat');


end