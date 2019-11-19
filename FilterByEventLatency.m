function [dataset] = FilterByEventLatency(dataset, event, min_lat, max_lat)
    dataset = EpochLatencyOf(dataset, event);
    dl = [dataset.epoch.latency];
    ind = dl >= min_lat & dl <= max_lat;
    dataset.epoch = dataset.epoch(ind);
    dataset.data = dataset.data(:,:,ind);
end

