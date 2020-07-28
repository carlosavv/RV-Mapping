function [apex]= generateLVApexPoints(lv)

zmin = min(lv(:,3));

[idx,t] =find(lv==min(lv(:,3)))
mx = zeros(length(idx),2);
for i = 1:length(idx)
    idx_id = idx(i);
    mx(i,:) = [lv(idx_id,1),lv(idx_id,2)];
end

xctd = mean(mx(:,1));
yctd = mean(mx(:,2));

apex = [xctd,yctd,zmin]


end