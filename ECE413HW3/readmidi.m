function midi = readmidi(filename)
    addpath('../ECE413HW1_realtime');
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
    trackCount = convertInt(A(11:12));
    
    %TODO: format zero is required to only have 1 track - add exception handling
    
    division = convertInt(A(13:14)); %time units per quarter note
    
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
    
    aTime = 0;
    eventCount = 0;  
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
            % need to add support for key setting
            % add tempo
            if(track(ctr) == 255)
               if(track(ctr+1) == 81) %set tempo
                   event.time = aTime;
                   event.type = 'tempo';
                   prev_event = '';
                   event.data1 = convertInt(track(ctr+3:ctr+5));
                   event.data2 = 0;
                   ctr = ctr + 6;
                   eventCount = eventCount + 1;
                   events(eventCount) = event; %store event
               elseif(track(ctr + 1) == 89) %set key
                   event.time = aTime;
                   event.type = 'key';
                   prev_event = '';
                   event.data1 = track(ctr+3);
                   event.data2 = track(ctr+4);
                   ctr = ctr + 5;
                   eventCount = eventCount + 1;
                   events(eventCount) = event; %store event
               else
                   disp('Most meta events not currently supported; skipping')
                   disp(track(ctr+1))
                   ctr = ctr + 2;
                   [len,ctr] = computeVariableLength(track,ctr);
                   ctr = ctr + len;
                   prev_event = '';
               end    
               
            else
                if(track(ctr) < 128) %check for running mode
                   if(~strcmp('',prev_event)) %prev_event exists
                       event.time = aTime;
                       event.type = prev_event;
                       event.data1 = track(ctr);
                       ctr = ctr + 1;
                       if(strcmp(event.type,'noteon') || strcmp(event.type,'noteoff'))
                           event.data2 = track(ctr+1);
                           ctr = ctr + 1;
                       else
                           event.data2 = 0;
                       end
                   end  
                   
                else %new event
                    event.time = aTime;
                    if((track(ctr) >= 128) && (track(ctr) <= 143)) %note off
                        event.type = 'noteoff';
                        event.data1 = track(ctr + 1);
                        event.data2 = track(ctr + 2);
                        prev_event = event.type;
                        ctr = ctr + 3;
                    elseif((track(ctr) >= 144) && (track(ctr) <= 159)) %note on
                        event.type = 'noteon';
                        event.data1 = track(ctr + 1);
                        event.data2 = track(ctr + 2);
                        prev_event = event.type;
                        ctr = ctr + 3;
                        if(event.data2 == 0) %zero velocity = note off
                            event.type = 'noteoff';
                        end
                    %ignore all of the following
                    else
                        prev_event = '';
                        if((track(ctr) >= 160) && (track(ctr) <= 191))
                            ctr = ctr + 3;
                        elseif((track(ctr) >= 192) && (track(ctr) <= 223))
                            ctr = ctr + 2;
                        elseif((track(ctr) >= 224) && (track(ctr) <= 239))
                            ctr = ctr + 3;
                        elseif(track(ctr) == 240)
                            while(track(ctr) ~= 247)
                                ctr = ctr + 1;
                            end
                            ctr = ctr + 1;
                        elseif(track(ctr) == 241 || (track(ctr) >= 244) && (track(ctr) <= 255))
                            ctr = ctr + 1;
                        elseif(track(ctr) == 242)
                            ctr = ctr + 3;
                        elseif(track(ctr) == 243)
                            ctr = ctr + 2;
                        end
                    end
                
                end
            end
            if(~strcmp('',prev_event))
                eventCount = eventCount + 1;
                events(eventCount) = event; %store event
            end
        end
    end
    
    noteCount = 0;
    temperament = 'equal';
    key = 'C';
    
    keyOptions = {'Cb','Gb','Db','Ab','Eb','Bb','F','C','G','D','A','E','B','F#','C#'};
    %convert events to array of notes
    for i = 1:eventCount
       if(strcmp(events(i).type,'noteon'))
          j = i+1;
          while((j<=eventCount) && (~strcmp(events(j).type,'noteoff')) && (events(j).data1 ~= events(i).data1))
             j = j + 1;
          end
          if(j > eventCount)
             disp('unmatched note on... ignoring')
          else
             startTime = events(i).time / division * tempo / 1000000;
             endTime = events(j).time / division * tempo / 1000000;
             note = objNote(events(i).data1, temperament, key, startTime, endTime, 1);
             noteCount = noteCount + 1;
             notes(noteCount) = note;
          end 
       elseif(strcmp(events(i).type,'key'))
           key = keyOptions{events(i).data1 + 8};
       elseif(strcmp(events(i).type,'tempo'))
           tempo = events(i).data1;
       end 
    end  
    
    midi.arrayNotes = notes;
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
    while(track(ctr) >= 128)
       val = 128*(val + (track(ctr)-128));
       ctr = ctr + 1;
    end
    val = val + track(ctr);
    ctr = ctr + 1;
end