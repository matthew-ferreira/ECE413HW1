%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SCRIPT
%    hw1
% 
% This script runs questions 2 through 4 of the HW1 from ECE313:Music and
% Engineering.
%
% This script was adapted from hw1 recevied in 2012
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setup
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all
clear functions
clear variables
dbstop if error


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constants.fs=44100;                 % Sampling rate in samples per second
constants.durationScale=0.5;        % Duration of notes in a scale
constants.durationChord=3;          % Duration of chords



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Question 2 - scales
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[soundMajorScaleJust]=create_scale('Major','Just','A',constants);
[soundMajorScaleEqual]=create_scale('Major','Equal','A',constants);
[soundMinorScaleJust]=create_scale('Minor','Just','A',constants);
[soundMinorScaleEqual]=create_scale('Minor','Equal','A',constants);

disp('Playing the Just Tempered Major Scale');
soundsc(soundMajorScaleJust,constants.fs);
pause(5)
disp('Playing the Equal Tempered Major Scale');
soundsc(soundMajorScaleEqual,constants.fs);
pause(5)
disp('Playing the Just Tempered Minor Scale');
soundsc(soundMinorScaleJust,constants.fs);
pause(5)
disp('Playing the Equal Tempered Minor Scale');
soundsc(soundMinorScaleEqual,constants.fs);
pause(5)
fprintf('\n');

% EXTRA CREDIT - Melodic and Harmonic scales
[soundHarmScaleJust]=create_scale('Harmonic','Just','A',constants);
[soundHarmScaleEqual]=create_scale('Harmonic','Equal','A',constants);
%[soundMelScaleJust]=create_scale('Melodic','Just','A',constants);
%[soundMelScaleEqual]=create_scale('Melodic','Equal','A',constants);

disp('Playing the Just Tempered Harmonic Scale');
soundsc(soundHarmScaleJust,constants.fs);
pause(5)
disp('Playing the Equal Tempered Harmonic Scale');
soundsc(soundHarmScaleEqual,constants.fs);
pause(5)
%disp('Playing the Just Tempered Melodic Scale');
%soundsc(soundMelScaleJust,constants.fs);
%disp('Playing the Equal Tempered Melodic Scale');
%soundsc(soundMelScaleEqual,constants.fs);
fprintf('\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 3 - chords
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fund = 'A'; % need this to determine wavelength for plots

% major and minor chords
[soundMajorChordJust]=create_chord('Major','Just',fund,constants);
[soundMajorChordEqual]=create_chord('Major','Equal',fund,constants);
[soundMinorChordJust]=create_chord('Minor','Just',fund,constants);
[soundMinorChordEqual]=create_chord('Minor','Equal',fund,constants);

disp('Playing the Just Tempered Major Chord');
soundsc(soundMajorChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Major Chord');
soundsc(soundMajorChordEqual,constants.fs);
pause(4)
disp('Playing the Just Tempered Minor Chord');
soundsc(soundMinorChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Minor Chord');
soundsc(soundMinorChordEqual,constants.fs);
pause(4)
fprintf('\n');

% assorted other chords
[soundPowerChordJust]=create_chord('Power','Just',fund,constants);
[soundPowerChordEqual]=create_chord('Power','Equal',fund,constants);
[soundSus2ChordJust]=create_chord('Sus2','Just',fund,constants);
[soundSus2ChordEqual]=create_chord('Sus2','Equal',fund,constants);
[soundSus4ChordJust]=create_chord('Sus4','Just',fund,constants);
[soundSus4ChordEqual]=create_chord('Sus4','Equal',fund,constants);
[soundDom7ChordJust]=create_chord('Dom7','Just',fund,constants);
[soundDom7ChordEqual]=create_chord('Dom7','Equal',fund,constants);
[soundMin7ChordJust]=create_chord('Min7','Just',fund,constants);
[soundMin7ChordEqual]=create_chord('Min7','Equal',fund,constants);


disp('Playing the Just Tempered Power Chord');
soundsc(soundPowerChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Power Chord');
soundsc(soundPowerChordEqual,constants.fs);
pause(4)
disp('Playing the Just Tempered Sus2 Chord');
soundsc(soundSus2ChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Sus2 Chord');
soundsc(soundSus2ChordEqual,constants.fs);
pause(4)
disp('Playing the Just Tempered Sus4 Chord');
soundsc(soundSus2ChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Sus4 Chord');
soundsc(soundSus2ChordEqual,constants.fs);
pause(4)
disp('Playing the Just Tempered Dom7 Chord');
soundsc(soundDom7ChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Dom7 Chord');
soundsc(soundDom7ChordEqual,constants.fs);
pause(4)
disp('Playing the Just Tempered Min7 Chord');
soundsc(soundMin7ChordJust,constants.fs);
pause(4)
disp('Playing the Equal Tempered Min7 Chord');
soundsc(soundMin7ChordEqual,constants.fs);
pause(4)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 4 - plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine fundamental frequency


figure()
subplot(2,2,1)
plot(soundMajorChordJust(1:1000))
title('Major Chord Just Temperment')
subplot(2,2,2)
plot(soundMajorChordEqual(1:1000))
title('Major Chord Equal Temperment')

subplot(2,2,3)
plot(soundMajorChordJust(1:20000))
title('Major Chord Just Temperment')
subplot(2,2,4)
plot(soundMajorChordEqual(1:20000))
title('Major Chord Equal Temperment')



figure()
subplot(2,2,1)
plot(soundMinorChordJust(1:1000))
title('Minor Chord Just Temperment')
subplot(2,2,2)
plot(soundMinorChordEqual(1:1000))
title('Minor Chord Equal Temperment')

subplot(2,2,3)
plot(soundMinorChordJust(1:10000))
title('Minor Chord Just Temperment')
subplot(2,2,4)
plot(soundMinorChordEqual(1:10000))
title('Minor Chord Equal Temperment')


% Major chords
%   Single Wavelength
%     just tempered
%     equal tempered
%   Tens of Wavelengths
%     just tempered
%     equal tempered

% Minor chords
%   Single Wavelength
%     just tempered
%     equal tempered
%   Tens of Wavelengths
%     just tempered
%     equal tempered
