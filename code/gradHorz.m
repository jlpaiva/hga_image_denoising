function dirHorz = gradHorz(img)
dirHorz = zeros(size(img));
dirHorz(:,1:end-1,:) = img(:,2:end,:) - img(:,1:end-1,:);
end

