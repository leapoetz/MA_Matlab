function [data_extracted] = extractData(subjData)

%% Extract Data
% kinetic
F_left = subjData.kinetic.left.force;
F_right = subjData.kinetic.right.force;
M_left = subjData.kinetic.left.torque;
M_right = subjData.kinetic.right.torque;
Angle_left = subjData.kinetic.left.angle_rad; 
Angle_right = subjData.kinetic.right.angle_rad; 
Speed_left = subjData.kinetic.left.speed;
Speed_right = subjData.kinetic.right.speed;

% % change signs
% F_left(:,3) = - F_left(:,3); 
% F_left(:,2) = - F_left(:,2); 
% F_right(:,2) = - F_right(:,2); 
% M_left(:,3) = M_left(:,3); 
% M_left(:,2) = - M_left(:,2); 

% kinematic
LFIN2_markerNr = find(strcmp(subjData.kinematic.markerNames,'LFIN2'));
LFIN2 = squeeze(subjData.kinematic.markerData(:,LFIN2_markerNr,:));
RFIN2_markerNr = find(strcmp(subjData.kinematic.markerNames,'RFIN2'));
RFIN2 = squeeze(subjData.kinematic.markerData(:,RFIN2_markerNr,:));
RWCENTRE_markerNr = find(strcmp(subjData.kinematic.markerNames,'RWCENTRE'));
RWCENTRE = squeeze(subjData.kinematic.markerData(:,RWCENTRE_markerNr,:));
LWCENTRE_markerNr = find(strcmp(subjData.kinematic.markerNames,'LWCENTRE'));
LWCENTRE = squeeze(subjData.kinematic.markerData(:,LWCENTRE_markerNr,:));

data_extracted.F_left = F_left; 
data_extracted.F_right = F_right; 
data_extracted.M_left = M_left; 
data_extracted.M_right = M_right; 
data_extracted.Angle_left = Angle_left; 
data_extracted.Angle_right = Angle_right; 
data_extracted.Speed_left = Speed_left; 
data_extracted.Speed_right = Speed_right; 
data_extracted.LFIN2 = LFIN2; 
data_extracted.RFIN2 = RFIN2; 
data_extracted.LWCENTRE = LWCENTRE; 
data_extracted.RWCENTRE = RWCENTRE; 

end