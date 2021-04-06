[s, fs] = audioread('song2.wav');

sample = [s(:,1)', zeros(1,514)];
samples = polyphase_analysis(sample);
audio = polyphase_synthesis(samples);

figure
hold on
plot(audio(481:length(audio)))
plot(sample)