function init( pathRoot )


incl = {'context', 'bbox_pred', 'fv_cache', ...
      'bin', 'gdetect', 'utils', ...
      'car_grammar', 'person_grammar', ...
      'model', 'features', 'vis', ...
      'data', 'train', 'test', ...
      'external', 'star-cascade'};
for i = 1:length(incl)
addpath(genpath(fullfile(pathRoot,incl{i})));
end

conf = voc_config();
fprintf('%s is set up\n', conf.version);
  
end

