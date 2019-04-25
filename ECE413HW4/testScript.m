%HW4 Test Script
%% Compressor

fs = 44100;
t = 0:1/fs:4;
soundIn = t .* sin(2*pi*240*t);
[soundOut, gain] = compressor(soundIn', 0.5, 0.1, 10000);
figure
hold on
plot(t,soundIn)
plot(t,soundOut)
plot(t,gain)
legend('input','output','gain')

soundsc(soundOut,fs)
pause(4);

%% Ring Modulator

[soundIn, fs] = audioread('song2.wav');
soundOut = ringMod(soundIn(:,1)', 200, 0.5);
soundsc(soundOut, fs)
pause(length(soundOut) / fs)

%% Stereo Tremolo

[soundIn, fs] = audioread('song2.wav');
soundOut = stereoTremolo(soundIn(:,1)', 'sin', 2, 200, 0.5);
soundsc(soundOut, fs)
pause(length(soundOut) / fs)

%% Distortion
[soundIn, fs] = audioread('song.wav');
soundOut = distort(soundIn(:,1)', 10, 0.25);

sound(soundOut, fs)
pause(length(soundOut) / fs)

figure
hold on
plot(soundOut)
plot(distort(soundIn(:,1)', 1, 0.25))

%paragraph here

%% Single Tap Delay
[soundIn, fs] = audioread('song.wav');

%Slapback 
soundOut1 = singleTapDelay(soundIn(:,1)', 0.3, 0.3, 0);
sound(soundOut1, fs)
pause(length(soundOut1) / fs)

%Cavern
[soundIn, fs] = audioread('Hello-SoundBite.wav');
soundOut2 = singleTapDelay(soundIn(:,1)', 0.5, 1, 0.5);
sound(soundOut2, fs)
pause(length(soundOut2)/fs)

%On beat repeat
[soundIn, fs] = audioread('guitar_riff_acoustic.wav');
soundOut3 = singleTapDelay(soundIn(:,1)', 1, 0.18, 0);
sound(soundOut3, fs)
pause(length(soundOut3)/fs)


%% Flanger
depth = 0.8;
delay = .001;   
width = .002;   
LFO_Rate = 0.5;   
[soundIn, fs] = audioread('song2.wav');

soundOut = flanger(soundIn, depth, delay, width, LFO_Rate);
sound(soundOut, fs)
pause(length(soundOut)/fs)

%% Chorus
depth = 0.9;
delay = .03;   
width = 0.1;   
LFO_Rate = 0.5;

soundOut = flanger(soundIn, depth, delay, width, LFO_Rate);
sound(soundOut, fs)
pause(length(soundOut)/fs)
