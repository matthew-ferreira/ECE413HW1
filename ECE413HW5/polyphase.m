function samples = polyphase_analysis(soundIn)
    [C,~] = createCandD();
    X = zeros(1,512);
    index = 1;
    while(index+32 < length(soundIn))
       X(33:512) = X(1:480);
       X(1:32) = soundIn(index:index+31);
       Z = X.*C;
       Y = sum(reshape(Z,64,[]),2);
       
       %MDCT
       
       [j,i] = meshgrid(0:63,0:31);
       M = cos(pi/128 * (2*j + 1 + 32).*(2*i+1));
       
       samples = M*x';
       
    end    

end