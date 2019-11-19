function [X] = MergeSets(X, varargin)
    varmat = cell2mat(varargin);
    X.event = horzcat(X.event, varmat.event);
    X.trials = sum(vertcat(X.trials, varmat.trials));
    X.xmin = min(vertcat(X.xmin, varmat.xmin));
    X.xmax = max(vertcat(X.xmax, varmat.xmax));
    X.data = cat(3, X.data, varmat.data);
    X.epoch = horzcat(X.epoch, varmat.epoch);
end