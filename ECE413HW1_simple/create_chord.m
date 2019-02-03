function [soundOut] = create_chord( chordType,temperament, root, constants )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [ soundOut ] = create_scale( chordType,temperament, root, constants )
% 
% This function creates the sound output given the desired type of chord
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   chordType = Must support 'Major' and 'Minor' at a minimum
%   temperament = may be 'just' or 'equal'
%   root = The Base frequeny (expressed as a letter followed by a number
%       where A4 = 440 (the A above middle C)
%       See http://en.wikipedia.org/wiki/Piano_key_frequencies for note
%       numbers and frequencies
%   constants = the constants structure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0:1/constants.fs:constants.durationChord;

switch root
    case{'A'}
        rootFreq = 220;
    case{'B'}
        rootFreq = 246.9417;
    case{'C'}
        rootFreq = 261.6256;
    case{'D'}
        rootFreq = 293.6648;
    case{'E'}
        rootFreq = 329.6276;
    case{'F'}
        rootFreq = 349.2282;
    case{'G'}
        rootFreq = 391.9954;
    otherwise
        error('Improper root');
end

switch chordType
    case {'Major','major','M','Maj','maj'}
        notes = [1 5 8];
    case {'Minor','minor','m','Min','min'}
        notes = [1 4 8];
    case {'Power','power','pow'}
        notes = [1 8];
    case {'Sus2','sus2','s2','S2'}
        notes = [1 3 8];
    case {'Sus4','sus4','s4','S4'}
        notes = [1 6 8];
    case {'Dom7','dom7','Dominant7', '7'}
        notes = [1 5 8 11];
    case {'Min7','min7','Minor7', 'm7'}
        notes = [1 4 8 11];
    otherwise
        error('Inproper chord specified');
end

switch temperament
    case {'equal','Equal'}
        freqRatios = [1 2^(1/12) 2^(1/6) 2^(1/4) 2^(1/3) 2^(5/12) 2^(1/2) 2^(7/12) 2^(2/3) 2^(3/4) 2^(5/6) 2^(11/12) 2];
    case {'just','Just'}
        freqRatios = [1 16/15 9/8 6/5 5/4 4/3 64/45 3/2 8/5 5/3 9/5 15/8 2];
    otherwise
        error('Inproper temperament specified')
end


% Complete with chord vectors
sound = sin(2 * pi * (freqRatios(notes) .* rootFreq)' * t);
soundOut = sum(sound);

end
