function [soundOut] = create_scale( scaleType,temperament, root, constants )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION
%    [ soundOut ] = create_scale( scaleType,temperament, root, constants )
% 
% This function creates the sound output given the desired type of scale
%
% OUTPUTS
%   soundOut = The output sound vector
%
% INPUTS
%   scaleType = Must support 'Major' and 'Minor' at a minimum
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
% TODO: Add all relavant constants 
double rootFreq;
t = 0:1/constants.fs:constants.durationScale;

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

switch scaleType
    case {'Major','major','M','Maj','maj'}
        notes = [1 3 5 6 8 10 12 13];
        %intervals = [2 2 1 2 2 2 1];
    case {'Minor','minor','m','Min','min'}
        notes = [1 3 4 6 8 9 11 13];
        %intervals = [2 1 2 2 1 2 2];
    case {'Harmonic', 'harmonic', 'Harm', 'harm'}
        notes = [1 3 4 6 8 9 12 13];
        %intervals = [2 1 2 2 1 3 1]
    %case {'Melodic', 'melodic', 'Mel', 'mel'}
	% EXTRA CREDIT
    otherwise
        error('Inproper scale specified');
end

switch temperament
    case {'equal','Equal'}
        freqRatios = [1 2^(1/12) 2^(1/6) 2^(1/4) 2^(1/3) 2^(5/12) 2^(1/2) 2^(7/12) 2^(2/3) 2^(3/4) 2^(5/6) 2^(11/12) 2];
    case {'just','Just'}
        freqRatios = [1 16/15 9/8 6/5 5/4 4/3 64/45 3/2 8/5 5/3 9/5 15/8 2];
    otherwise
        error('Improper temperament specified')
end


% Create the vector based on the notes
sound = sin(2 * pi * (freqRatios(notes) .* rootFreq)' * t);
envelope = abs(sin(pi / constants.durationScale * t)) .^ 0.2;
envelope = [envelope envelope envelope envelope envelope envelope envelope envelope];
soundOut = envelope .* reshape(sound',1,[]);

end
