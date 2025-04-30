function Tot = createMatrixFromTopRight(topRightQuadrant)


Q3= flipud(fliplr(topRightQuadrant));Q3=Q3(1:end-1,:); % Bottom Left
Q4 = flipud(topRightQuadrant);Q4=Q4(1:end-1,2:end);  % Bottom Right
Q2 = fliplr(topRightQuadrant);  % Top Left
topRightQuadrant=topRightQuadrant(:,2:end); % Top Right

Tot=[Q3 Q4;Q2 topRightQuadrant];
end
