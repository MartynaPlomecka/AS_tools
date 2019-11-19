function [dataset] = EpochLatencyOf(dataset, event)
    for i=1:length(dataset.epoch)
        sacc_idx = strcmp(dataset.epoch(i).eventtype, event);
        if sum(sacc_idx) == 1
            dataset.epoch(i).latency = dataset.epoch(i).eventlatency{sacc_idx};
        else
            dataset.epoch(i).latency = -1;
        end
    end
end
