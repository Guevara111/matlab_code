function createFit1(a, b)
%CREATEFIT1(A,B)
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

%  由 MATLAB 于 29-Nov-2022 20:00:25 自动生成


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( a, b );

% Set up fittype and options.
ft = fittype( 'gauss3' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
opts.StartPoint = [4 100 9.76459633526581 4 40 3803.00970838912 0.000358418705164176 4 7.31991209309139];

% Fit model to data.
[fitresult, ~] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'untitled fit 1' );
h = plot( fitresult );
legend( h, 'b vs. a', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'a', 'Interpreter', 'none' );
ylabel( 'b', 'Interpreter', 'none' );
grid on


