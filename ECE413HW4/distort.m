function soundOut = distort(soundIn, gain, tone)
    [b,a] = butter(3, 0.15 + .5*tone);
    s1 = gain * soundIn;
    
    s2 = 16*s1.^5 - 8*s1.^3 + s1;
    
    s3 = filter(b,a,s2);
    
    soundOut = s3 + 0.5*s2;
end