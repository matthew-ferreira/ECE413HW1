function [soundSample] = create_sound(instrument, notes, constants)

duration = (notes.duration)/constants.fs;
switch notes.note
    case{'A4'}
        rootFreq = 220;
    case{'B4'}
        rootFreq = 246.9417;
    case{'C4'}
        rootFreq = 261.6256;
    case{'D4'}
        rootFreq = 293.6648;
    case{'E4'}
        rootFreq = 329.6276;
    case{'F4'}
        rootFreq = 349.2282;
    case{'G4'}
        rootFreq = 391.9954;
    otherwise
        rootFreq = notes.note
        
end

switch instrument.sound
    case{'Additive'}
        AMP = [1 0.67 1 1.8 2.67 1.67 1.46 1.33 1.33 1 1.33];
        DUR = [1 0.9 0.65 0.55 0.325 0.35 0.25 0.2 0.15 0.1 0.075] .* duration;
        FREQ = [0.56 0.56 0.92 0.92 1.19 1.7 2 2.74 3 3.76 4.07].*rootFreq + [0 1 0 1.7 0 0 0 0 0 0 0];
        % e^-6.93 ~ 2^-10
        signal = zeros(1, notes.duration);
        for i = 1:11
            t = 0 : 1/constants.fs : DUR(i) - 1/constants.fs;
            envelope = exp(-6.93 * t / DUR(i));
            sinusoid = sin(2 * pi * FREQ(i) * t);
            signal = signal + [AMP(i).*envelope.*sinusoid, zeros(1,notes.duration - length(t))];
        end
        soundSample = signal;
     
    case{'Subtractive'}
        t = 0 : 1/constants.fs : duration-1/constants.fs;
        signal = square(2*pi*rootFreq*t);
        if(mod(length(signal),100) ~= 0)
            signal = [signal zeros(1, 100 - mod(length(signal),100))];
        end
        signal = reshape(signal,[],100);
        b = 1;
        blocks = size(signal,1);
        theta = linspace(pi/2, 0, blocks);
        sound = zeros(blocks,100);
        for i = 1:blocks
            a = [0.9^2, -2 * 0.9 * cos(theta(i)), 1];
            s = filter(b, a, signal(i,:));
            sound(i,:) = s;
        end
        soundSample = reshape(sound',1,[]);
        
    case{'FM'}
        t = 0 : 1/constants.fs : duration-1/constants.fs;
        fm = rootFreq * 7/5;
        envelope = exp(-6.93 * t / duration);
        soundSample = envelope.*sin((2*pi*t*rootFreq) + (2*pi*envelope.*cos(2*pi*fm*t)));
    case{'Waveshaper'}
        t = 0: 1/constants.fs : duration-1/constants.fs;
        e1 = (0 : 1/constants.fs : 0.085) * (1/0.085);
        e3 = flip(0 : 1/constants.fs : 0.64) * (1/0.64);
        e2 = ones(1, length(t) - (length(e1) + length(e3)));
        env = 255 * [e1 e2 e3];
        
        s = sin(2 * pi * rootFreq * t);
        s = env(1:length(s)).*s;
        s = s + 256;
        
        for i = 1:length(s)
           if(s(i) < 200)
               s(i) = s(i) *(0.5/200) - 1;
           elseif((s(i) >= 200) && (s(i) < 312))
               s(i) = (s(i)-200)*(1/112) - 0.5;
           else
               s(i) = 0.5 + (s(i)-312)*(0.5/200);
           end
        end
        
        soundSample = s;
        
        
end
end

