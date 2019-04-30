function soundOut = distort(soundIn, gain, tone)
    [b,a] = butter(3, 0.15 + .5*tone);
    s1 = gain .* soundIn;
    s1(s1>1) = 1;
    s1(s1<-1) = -1;
    soundOut = filter(b,a,s1);
    
end