function [ letters ] = extractletters( swtMap, swtLabel, ccNum )

letters = zeros(size(swtLabel));
maxLetterHeight = 300;
minLetterHeight = 10;

for i=1:ccNum
    [r,c] = find(swtLabel==i);
    idx = sub2ind(size(swtMap),r,c);
    componentSW = swtMap(idx);
    varianceSW = var(componentSW);
    meanSW = mean(componentSW);
    width = max(c) - min(c);
    height = max(r) - min(r);
    aspectRatio = width/height;
    diameter = sqrt(width^2+height^2);
    medianSW = median(componentSW);
    maxSW = max(componentSW);
   
    if height>maxLetterHeight | height<minLetterHeight, 
        continue, 
    end
    
    if varianceSW/meanSW > 35, 
        continue, 
    end

    if diameter/medianSW >= 20, 
        continue, 
    end
 
    if aspectRatio < 0.1 && aspectRatio > 10, 
        continue, 
    end
    
    if size(componentSW,1)/maxSW < 11, 
        continue, 
    end
    
    if width > height*4, 
        continue, 
    end
    
    letters(idx) = 1;  
end
end
