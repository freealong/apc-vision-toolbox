function [ mask ] = combineMasks( masks, dists )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    assert(size(masks, 2) == size(dists, 2));
    maskNum = size(masks, 2);
    assert(maskNum > 0);
    mask = masks{1};
    dist = dists{1};
    [rows, cols] = size(mask);
    for y = 1:rows
        for x = 1:cols
            for i = 2:size(masks, 2)
                if masks{i}(y, x) == 1 && dists{i}(y, x) < dist(y, x)
                    dist(y, x) = dists{i}(y, x);
                    mask(y, x) = i;
                end
            end
        end
    end
end

