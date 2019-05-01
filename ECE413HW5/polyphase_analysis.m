function samples = polyphase_analysis(soundIn)
    [C,~] = createCandD();
    X = zeros(1,512);
    [j,i] = meshgrid(0:63,0:31);
    M = cos(pi/128 * (2*j + 33).*(2*i+1));
    index = 0;
    while((index+1)*32 <= length(soundIn))
       X(33:512) = X(1:480);
       X(1:32) = flip(soundIn((index*32 + 1):((index+1)*32)));
       Z = X.*C;
       Y = sum(reshape(Z,64,[]),2);
       samples(:,index+1) = M*Y;
       index = index + 1;
    end

end