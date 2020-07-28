%% Set up recording parameters (optional), and record

OptionZ.FrameRate=10;OptionZ.Duration=5;OptionZ.Periodic=true;
% CaptureFigVid([0,10;360,10], 'Co_plot.avi',OptionZ)
CaptureFigVid([-20,10;-110,10;-110,50;-200,50;-200,10;-380,10], 'Co_plot.avi',OptionZ)
