function soundOut = polyphase_synthesis(samples)
    soundOut = zeros(1,size(samples,2)*32);
    [j,i] = meshgrid(0:63,0:31);
    M = cos(pi/128 * (2*j + 1 - 32).*(2*i+1));
    [~,D] = createCandD();
    v = M' * samples;
    V = zeros(64,16);
    index = 1;
    while(index <= size(v,2))
       V(:,2:16) = V(:,1:15); 
       V(:,1) = v(:,index);
       U = [V(1:32,1)', V(33:64,2)', V(1:32,3)', V(33:64,4)', ...
           V(1:32,5)', V(33:64,6)', V(1:32,7)', V(33:64,8)', ...
           V(1:32,9)', V(33:64,10)', V(1:32,11)', V(33:64,12)', ...
           V(1:32,13)', V(33:64,14)', V(1:32,15)', V(33:64,16)'];
       W = U.*D;
       soundOut(((index-1)*32 + 1):(index*32)) = sum(reshape(W,32,[]),2)';
       index = index + 1;
    end
end