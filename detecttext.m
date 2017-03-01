
image = imread('035.jpg');
swtMap = swt(image,-1);
[swtLabel, numCC ] = swtlabel(swtMap, 8);
final = extractletters(swtMap, swtLabel, numCC);
figure, imshow(final);

