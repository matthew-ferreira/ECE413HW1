function soundOut = flanger(soundIn, depth, delayTime, sweepDepth, LFO)
%delay time given in mSec
%sweepDepth in mSec

    %soundOut = zeros(1, length(soundIn) * 2);
    t = 0:1/44100:(length(soundIn)-1)/44100;
    delay = sweepDepth/1000 * tripuls(2*pi*LFO*t) + delayTime/1000;
    soundOut = zeros(1, ceil(length(soundIn) + max(delay)*44100));
    
    for i = 1:length(soundIn)
        soundOut(i) = soundIn(i);
        if(ceil(delay(i) * 44100) < i)
            soundOut(i) = soundOut(i) + depth * soundIn(floor(i - 44100*delay(i)));
        end
    end

end
