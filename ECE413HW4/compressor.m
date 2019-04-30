function [soundOut, gain] = compressor(soundIn, threshold, slope, len)

soundOut = zeros(1, length(soundIn));
gain = ones(1,length(soundIn));

    for i = 1:length(soundIn)
        if(i <= len)
            pow = rms(soundIn(1:i))^2;
        else
            pow = rms(soundIn(i-len:i))^2;
        end
        
        if(pow > threshold)
            gain(i) = ((pow - threshold)*slope + threshold)/pow;
        end
        
        soundOut(i) = soundIn(i) * gain(i);        
    end
end