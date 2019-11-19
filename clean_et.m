function [dataset] = clean_et(dataset, odl)
%tym razem patrzymy na et i jesli przed wydarzeniem ktore po zmergowaniu
%juz tak jak robia to kody mamy sytuacje ze 500ms przed
%L_saccade_10,11,12,13 jest event saccade lub event blink to wywalamy tamte
%dane
%odl = 500
for ind = false(1,size(dataset.data, 3));
if |L_saccade_10 - L_saccade| > odl ms && |L_blink-  - L_saccade|< odl . %loopojemy po wszystkich takich wyfarzeniach z et
        ind(i) = true;
    end
end

dataset.epoch = dataset.epoch(ind);
dataset.data = dataset.data(:,:,ind);