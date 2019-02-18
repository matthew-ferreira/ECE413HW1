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
        signal = reshape(signal,[],100);
        b = 1;
        a = [1.2^2 0 1];
        blocks = ceil(notes.duration/100);
        theta = linspace(pi/2-0.2,0,blocks);
        sound = zeros(blocks,100);
        for i = 1:blocks
            a(2) = -2 * 1.2 * cos(theta(i));
            s = filter(b, a, signal(i,:));
            sound(i,:) = s;
        end
        soundSample = reshape(sound',1,[]);
        
    case{'FM'}
        t = 0 : 1/constants.fs : duration-1/constants.fs;
        fm = rootFreq * 7/5;
        envelope = exp(-6.93 * t / duration);
        soundSample = envelope.*sin((2*pi*t*rootFreq) + (2*pi*envelope.*cos(2*pi*fm*t)));
end
end

