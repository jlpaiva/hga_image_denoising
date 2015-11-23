function batch(originalFile, noisyFile, outputName, sizePop, localSearchRate, numRuns, maxTime, numIter, beta, tournSize)
  
    file = fopen('output_log.data','a');
    
    printFileStdOut(file, sprintf('\n\n------------------------------ %s ------------------------------\n\n', datestr(clock)));
    printFileStdOut(file, sprintf('Population size: %d\t Local search rate: %g \n', sizePop, localSearchRate));
    printFileStdOut(file, sprintf('Execution time: %d\t Max restart iterations: %g \n', maxTime, numIter));
    printFileStdOut(file, sprintf('Beta: %g\t Tournament Size: %d \t Number of runs: %d \n', beta, tournSize, numRuns));
    
    imgOriginal = imread(originalFile);
    fedge = edge(imgOriginal, 'sobel');
        
    noisyImage = imread(noisyFile);  
    psnrs = zeros(1, numRuns);
    ssims= zeros(1, numRuns);
    foms = zeros(1, numRuns);
    tempos = zeros(1, numRuns);
        
    for k = 1:numRuns
        
        tmp = tic;
        f = execHGA(sizePop, noisyImage, localSearchRate, maxTime, numIter, beta, tournSize);
        [psnr, ssim, fom] = metrics(f, imgOriginal, fedge);
        
        outFile = strcat(outputName);
        
        imwrite(uint8(f), outFile);
        
        endTime = toc(tmp);
        
        psnrs(k) = psnr;
        ssims(k) = ssim;
        foms(k) = fom;
        tempos(k) = endTime;
        
        strWrite = sprintf('Run #: %d\tElapsed time: %f\tPSNR: %f\tSSIM: %f\tFigure of merit: %f\n', k, endTime, psnr, ssim, fom);
        
        printFileStdOut(file, strWrite);
        
    end
    
    printFileStdOut(file, '\n\nMETRIC \tAVG \tMAX \tMIN \tSTD\n');   
    ps = sprintf('PSNR: \t%f \t%f \t%f \t%f\n', mean(psnrs),max(psnrs),min(psnrs),std(psnrs));
    ss = sprintf('SSIM: \t%f \t%f \t%f \t%f\n', mean(ssims),max(ssims),min(ssims),std(ssims));
    fo = sprintf('FOM:  \t%f \t%f \t%f \t%f\n', mean(foms),max(foms),min(foms),std(foms));
    ti = sprintf('TIME: \t%f \t%f \t%f \t%f\n', mean(tempos),max(tempos),min(tempos),std(tempos));
    
    printFileStdOut(file, ps);
    printFileStdOut(file, ss);
    printFileStdOut(file, fo);
	printFileStdOut(file, ti);

    printFileStdOut(file, sprintf('\n\nEnd: %s\n', datestr(clock)));
    
    fclose(file);
    
end

function printFileStdOut(file, str)

fprintf(str);
fprintf(file, str);

end

function [psnr, ssim, fom] = metrics(imgAvaliada, imgOriginal, fedge)

psnr = calc_psnr(uint8(imgAvaliada), uint8(imgOriginal));
ssim = ssim_index(uint8(imgAvaliada), uint8(imgOriginal));
gedge = edge(imgAvaliada, 'sobel');

fom = figuremerit(fedge,gedge);

end
