function soundOut = stereoTremolo(soundIn, LFO_type, LFO_rate, lag, depth)

timeVec = 0:1/44100:(length(soundIn)-1)/44100;
timeVecR = timeVec + lag/1000;

if(strcmp(LFO_type, 'sin'))
    mix = sin(2*pi*LFO_rate*timeVec);
    mixR = sin(2*pi*LFO_rate*timeVecR);
elseif(strcmp(LFO_type, 'triangle'))
    mix = tripuls(timeVec, 1/(2*pi*LFO_rate));
    mixR = tripuls(timeVecR, 1/(2*pi*LFO_rate));
elseif(strcmp(LFO_type, 'square5'))
    mix = square(2*pi*LFO_rate*timeVec);
    mixR = square(2*pi*LFO_rate*timeVecR);
else
    error('invalid LFO type')
end

soundOut1 = depth * (soundIn .* mix) + (1-depth) * soundIn;
soundOut2 = depth * (soundIn .* mixR) + (1-depth) * soundIn;
soundOut = [soundOut1; soundOut2];

end

