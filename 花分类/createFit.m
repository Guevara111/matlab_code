function [fitresult, gof] = createFit(a, b)
%CREATEFIT(A,B)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : a
%      Y Output: b
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 29-Nov-2022 17:24:28 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( a, b );

% Set up fittype and options.
ft = fittype( 'gauss5' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
opts.Normalize = 'on';
opts.StartPoint = [4 1.56834402166649 0.203336828562656 4 0.0172345496886428 2742.36569300361 1.45596697720407e-06 -1.63728222042106 0.0946946800733619 1.0600688965719e-06 -1.39599852478007 0.0957932668973359 7.31562997135543e-07 -1.25812212727092 0.112045761004157];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
plot( fitresult);
% Label axes
xlabel( 'a', 'Interpreter', 'none' );
ylabel( 'b', 'Interpreter', 'none' );
grid on


