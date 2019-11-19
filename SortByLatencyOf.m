function [dataset_out] = SortByLatencyOf(dataset, event)
    dataset_out = EpochLatencyOf(dataset, event);
    [B,I] = sort([dataset_out.epoch.latency]);
    dataset_out.epoch_sorted = dataset_out.epoch(I);
    dataset_out.data_sorted = dataset_out.data(:,:,I);
end