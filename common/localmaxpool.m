function [ od,ol ] = localmaxpool( desc, loc, k )

xsort = sort(unique(loc(1,:)));
ysort = sort(unique(loc(2,:)));

maxPooler = lmPoolerMax();

mats = cell(0);
matsl = cell(0);
ind = 1;

for i=1:k:length(xsort)
    for j=1:k:length(ysort)
        xs = xsort(i:min(i+k-1,length(xsort)));
        ys = ysort(j:min(j+k-1,length(ysort)));
        
        iminx = min(xs);
        imaxx = max(xs);
        iminy = min(ys);
        imaxy = max(ys);
        
        matsl{ind} = [floor(mean(xs));floor(mean(ys))];
        
        mats{ind} = maxPooler.pool(desc(:,((loc(1,:)>=iminx)&(loc(1,:)<=imaxx)...
            &(loc(2,:)>=iminy)&(loc(2,:)<=imaxy))));
        ind = ind+1;
    end
end

od = MergeMats(mats);
ol = MergeMats(matsl);

end

