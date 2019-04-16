function soundOut = singleTapDelay(soundIn, depth, delayTime, feedbackGain)
%delay time given in mSec
delaySamples = floor(44100*delayTime);

if(feedbackGain == 0 || depth == 0)
    sound1 = [soundIn, zeros(1,delaySamples)];
    sound2 = [zeros(1,delaySamples), soundIn];
    soundOut = sound1 + depth*sound2;

elseif(feedbackGain > 0)
    soundOut = zeros(1, length(soundIn) * 10);
    delayBuffer = soundOut;
    soundOut(1:delaySamples) = soundIn(1:delaySamples);
    delayBuffer(1:delaySamples) = soundIn(1:delaySamples);
    
    for count = (delaySamples + 1):(length(soundOut))
        if(count <= length(soundIn))
            delayBuffer(count) = soundIn(count);
            soundOut(count) = soundIn(count);
        end
        delayBuffer(count) = delayBuffer(count) + feedbackGain * delayBuffer(count - delaySamples);
        soundOut(count) = soundOut (count) + depth * delayBuffer(count - delaySamples);
    end
end    

end

