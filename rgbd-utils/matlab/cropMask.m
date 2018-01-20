function [ masks, bboxes ] = cropMask( mask, num )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    masks = cell(1, num);
    bboxes = cell(1, num);
    [rows, cols] = size(mask);
    for i = 1:num
        bboxes{i} = [cols, rows, 1, 1];
    end
    
    % generate bbox
    for y = 1:rows
        for x = 1:cols
            if mask(y, x) > 0
                id = mask(y, x);
                bboxes{id}(1) = min(bboxes{id}(1), y);
                bboxes{id}(2) = min(bboxes{id}(2), x);
                bboxes{id}(3) = max(bboxes{id}(3), y);
                bboxes{id}(4) = max(bboxes{id}(4), x);
            end
        end
    end
    
    % crop mask
    for i = 1:num
        bbox = bboxes{i};
        if bbox(1) >= bbox(3) || bbox(2) >= bbox(4)
            continue;
        end
        masks{i} = mask(bbox(1):bbox(3), bbox(2):bbox(4));
        for y = 1:size(masks{i}, 1)
            for x = 1:size(masks{i}, 2)
                if masks{i}(y, x) ~= i
                    masks{i}(y, x) = 0;
                else
                    masks{i}(y, x) = 1;
                end
            end
        end
        % filter mask
        se = strel('line', 5, 5);
        masks{i} = imerode(masks{i}, se);
        se = strel('line', 11, 11);
        masks{i} = imdilate(masks{i}, se);
        % refine bbox
        maskSize = size(masks{i});
        bbox = [maskSize(1), maskSize(2), 1, 1];
        for y = 1:maskSize(1)
            for x = 1:maskSize(2)
                if masks{i}(y, x) > 0
                    bbox(1) = min(bbox(1), y);
                    bbox(2) = min(bbox(2), x);
                    bbox(3) = max(bbox(3), y);
                    bbox(4) = max(bbox(4), x);
                end
            end
        end
        masks{i} = masks{i}(bbox(1):bbox(3), bbox(2):bbox(4));
        bbox(1) = bboxes{i}(1) + bbox(1);
        bbox(2) = bboxes{i}(2) + bbox(2);
        bbox(3) = bboxes{i}(1) + bbox(3);
        bbox(4) = bboxes{i}(2) + bbox(4);
        bboxes{i} = bbox;
    end
    
end

