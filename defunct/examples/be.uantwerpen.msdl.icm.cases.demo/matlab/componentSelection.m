addpath('D:\GitHub\msdl\ICM\examples\be.uantwerpen.msdl.icm.cases.demo\matlab\libs');

if string('%{args['componentType'].value}%') == string('battery')
	[Ceff, batteryMass, batteryLength, batteryWidth, batteryHeight] = BatterySelection(CdesV, %{args['batteryDbName'].value}%);
else
	[Peff, motorMass, motorLength, motorRadius] = MotorSelection(PdesV, %{args['motorDbName'].value}%);
end