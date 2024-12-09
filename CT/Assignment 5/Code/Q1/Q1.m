
clear;
close all;

numSamples = 100;
noiseStdDev = [0.1, 0.3, 0.5];
signalEnergy = 1;

figure;

% Iterate over each noise standard deviation
for idx = 1:length(noiseStdDev)
    stdDev = noiseStdDev(idx);
    
    % Generate noise components
    noiseComp1 = stdDev * randn(numSamples, 1);
    noiseComp2 = stdDev * randn(numSamples, 1);

    % Compute received signals for two scenarios
    receivedSignalA1 = noiseComp1;
    receivedSignalA2 = sqrt(signalEnergy) + noiseComp2;

    receivedSignalB1 = sqrt(signalEnergy) + noiseComp1;
    receivedSignalB2 = noiseComp2;
    
    % Plotting
    subplot(1, 3, idx);
    plot(receivedSignalA1, receivedSignalA2, 'bo', 'MarkerSize', 4);
    hold on;
    plot(receivedSignalB1, receivedSignalB2, 'r*', 'MarkerSize', 4);
    xlabel('Component 1');
    ylabel('Component 2');
    legend({'Scenario 1', 'Scenario 2'}, 'Location', 'best');
    title(sprintf('\\sigma = %.1f', stdDev));
    axis equal;

    % Calculate error probability for scenario 1
    errorProb1 = sum(receivedSignalA1 > receivedSignalA2) / numSamples;
    fprintf('Error Probability for Scenario 1 (\sigma=%.1f): %.2f\n', stdDev, errorProb1);

    % Calculate error probability for scenario 2
    errorProb2 = sum(receivedSignalB1 < receivedSignalB2) / numSamples;
    fprintf('Error Probability for Scenario 2 (\sigma=%.1f): %.2f\n', stdDev, errorProb2);
end

% Add a title to the figure
sgtitle('Noise Impact on Binary Communication System Across Different \sigma Values');
