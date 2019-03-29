classdef midiPlayer
    %UNTITLED5 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        arrayNotes
        
    end
    
    methods
        function obj = midiPlayer(notes)
            for i=1:length(notes)
                arrayNotes(i) = objNote(notes(i));
            end
        end
    end
    
end

