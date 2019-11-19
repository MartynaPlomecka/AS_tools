function [EEG] = InvalidateDistracted(EEG)
    previous = 'L_fixation';
    for e = 1:length(EEG.event)
        if strcmp(EEG.event(e).type,'10  ') ...
        || strcmp(EEG.event(e).type,'11  ')
            if ~contains(previous, 'L_fixation')
                EEG.event(e).type = 'INVALIDATED';
            end
        end
        previous = EEG.event(e).type;
    end
end

