function soundOut = ringMod(soundIn, mixFreq, depth)
%Ring modulator

timeVec = 0:1/44100:(size(soundIn)-1)/44100;
mix = sin(2*pi*mixFreq*timeVec);
soundOut = depth * (soundIn .* mix) + soundIn;


end

