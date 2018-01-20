dataPath = '../../../benchmark';
objectPath = '../../ros-packages/catkin_ws/src/pose_estimation/src/models/objects';

load(fullfile(dataPath, 'labels.mat'));
load(fullfile(dataPath, 'scenes.mat'));
load(fullfile(dataPath, 'objects.mat'));

% load object ply models
objectFiles = dir(fullfile(objectPath, '*.ply'));
objectsNum = size(objects, 1);
if size(objectFiles) < objectsNum
    print 'mising object models, should be ', size(objects)
end
objectsName = cell(1, objectsNum);
for i = 1:objectsNum
    objects{i}.cloud = pcread(fullfile(objectPath, objectFiles(i).name));
    objectsName{i} = objects{i}.name;
end
objectsMap = containers.Map(objectsName, [1:objectsNum]);

% sort labes based on scene
scenesNum = size(scenes, 2);
scenesLabels = cell(1, scenesNum);
mapObj = containers.Map({scenes{[1:scenesNum]}}, [1:scenesNum]);
for i = 1:size(labels)
    id = mapObj(labels{i}.sceneName);
    scenesLabels{id}(end+1) = i;
end

for i = 190%:scenesNum
    i
    scenePath = fullfile(dataPath, scenes{i});
    sceneData = loadScene(scenePath);
    framesNum = size(sceneData.colorFrames, 2);
    frameObjectNum = size(scenesLabels{i}, 2);
    for j = 1:framesNum
        % generate hha
        hha = getHHA(sceneData.env, sceneData.depthFrames{j}, sceneData.colorK, sceneData.extCam2World{j}, sceneData.extBin2World);
        hhaSaveName = sprintf('frame-%06d.hha.png', j-1);
        imwrite(hha, fullfile(scenePath, hhaSaveName));
        % deal with labels
        label = cell(1, frameObjectNum);
        frameLabels = scenesLabels{i};
        clouds = cell(1, frameObjectNum);
        cMos = cell(1, frameObjectNum);
        for k = 1:frameObjectNum
            objectLabel = labels{frameLabels(k)};
            label{k}.objectName = objectLabel.objectName;
            % calculate cMo, object pose under camera coordinate
            label{k}.cMo = inv(sceneData.extCam2World{j}) * labels{frameLabels(k)}.objectPose;
            cMos{k} = label{k}.cMo;
            clouds{k} = objects{objectsMap(label{k}.objectName)}.cloud;
        end
        [masks, bboxes] = getMasks(clouds, cMos, sceneData.colorK, size(sceneData.depthFrames{1}));
        for k = 1:frameObjectNum
            label{k}.mask = masks{k};
            label{k}.bbox = bboxes{k};
        end
        % remove coverd object
        coverdObjectId = cellfun(@isempty, masks);
        label(coverdObjectId) = [];
        labelSaveName = sprintf('frame-%06d.label.mat', j-1);
        save(fullfile(scenePath, labelSaveName), 'label');
    end
end