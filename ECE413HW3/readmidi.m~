function midi = readmidi(filename)
    fp = fopen(filename);
    if(~fp)
        error('Invalid filename');
    end
    
    A = fread(fp);
    
    %TODO: check for header ID
    
    %compute header length
    headerLength = convertInt(A(5:8));
    
    %computer format; the only valid formats are 0, 1, or 2
    format = convertInt(A(9:10));
    if (format==0 || format==1 || format==2)
        midi.format = format;
    else    
        error('Format does not equal 0,1,or 2');
    end
    
    %find number of tracks
    trackCount = convertInt(A(11:12))
    
    %TODO: format zero is required to only have 1 track - add exception handling
    
    division = convertInt(A(13:14)); %time unites per quarter note

    ctr = headerLength + 9; %starting place for track 1
    
    
    for i=1:trackCount
  
        if ~isequal(A(ctr:ctr+3)',[77 84 114 107])  % double('MTrk')
            disp(['Chunk ' num2str(i) ' is not of type MTrk and is being ignored']);
        
        else
            ctr = ctr+4;
  
            trackLength = convertInt(A(ctr:ctr+3));
            ctr = ctr+4;
  
            trackRaw{i} = A((ctr-8):(ctr+trackLength-1));
  
            ctr = ctr+trackLength;
        end
    end
    eventCount = 1;
    
    for i = 1:trackCount
        track = trackRaw{i};
        ctr = 9;
        prev_event = '';
        if(format == 1)
            aTime = 0; %absolute time since start
        end
        while(ctr < length(track))
            %compute variable length value of delta time
            [dTime,ctr] = computeVariableLength(track,ctr);
            aTime = aTime + dTime;
            
            %check for Meta Events
            if(track(ctr) == 255)
               disp('Meta events not currently supported; skipping')
               ctr = ctr + 2;
               [len,ctr] = computeVariableLength(track,ctr);
               ctr = ctr + len;
               prev_event = '';
            else
                if(track(ctr) < 128) %check for running mode
                   if(~strcmp('',prev_event)) %prev_event exists
                       event.time = aTime;
                       event.type = prev_event;
                       event.data1 = track(ctr);
                       ctr = ctr + 1;
                       if(track(ctr) < 128)
                           event.data2 = track(ctr+1);
                           ctr = ctr + 1;
                       end
                   end    
                else %new event
                    event.time = aTime;
                    if((track(ctr) >= 128) || (track(ctr) <= 143)) %note off
                        event.type = 'noteoff';
                        event.data1 = track(ctr + 1);
                        event.data2 = track(ctr + 2);
                        prev_event = event.type;
                        ctr = ctr + 3;
                    elseif((track(ctr) >= 144) || (track(ctr) <= 159)) %note on
                        event.type = 'noteon'
                        event.data1 = track(ctr + 1);
                        event.data2 = track(ctr + 2);
                        prev_event = event.type;
                        ctr = ctr + 3;
                        if(event.data2 == 0) %zero velocity = note off
                            event.type = 'noteoff';
                        end
                    else
                        %event not currently supported
                        prev_event = '';
                        clear event;
                        while(track(ctr) < 128)
                            ctr = ctr + 1;
                        end
                    end
                
                end
            end
            if(~strcmp('',prev_event))
                events(eventCount) = event; %store event
                eventCount = eventCount + 1;
            end
        end
    end
    
    %convert events to array of notes
    
    
end

function x = convertInt(A)
%convert array of bytes to integer
    p = (0:length(A)-1)';
    x = sum(256.^flip(p) .* A);
end


function [val,ctr] = computeVariableLength(track,ctr)
%computes the value of a variable length number
%returns the value & ptr to the next byte in the data
    val = 0;
    while(track(ctr) > 127)
       val = 128*(val + (track(ctr)-127));
       ctr = ctr + 1;
    end
    val = val + track(ctr);
    ctr = ctr + 1;
end