function [dataset] = ClipToBounds(dataset, min_val, max_val)
% EYE_ELECTRODE = 107;

ind = false(1,size(dataset.data, 3));
for i=1:size(dataset.data, 3)
    if all(dataset.data(107,:,i) < max_val) && all(dataset.data(107,:,i) > min_val)
        ind(i) = true;
    end
end

dataset.epoch = dataset.epoch(ind);
dataset.data = dataset.data(:,:,ind);

end

