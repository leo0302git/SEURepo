#include<iostream>

using namespace std;
const double pi = 3.1415926;
void capacitor()
{
	cout << "开始测电容。确认CH1与电源连在ab，CH2连在ac！\n";
	cout << "输入ac间的元件类型：   0-R     1-C\n";
	int choice = -1;
	double CH1, CH2, MATH, i, R, f, C, L;
	R = 97.5;//后面可能需要改；
	cin >> choice;
	cout << "输入CH2有效值（mV）：";
	cin >> CH2;
	cout << "输入MATH有效值（mV）：";
	cin >> MATH;
	cout << "输入电源频率（kHz）：";
	cin >> f;
	//虽然输入的值单位不一定是国际单位，但内部运算用国际单位
	f = f * 1000;
	CH2 = CH2 / 1000;
	MATH = MATH / 1000;
	switch (choice)
	{
	case 1:
		cout << "确定ac间为电容\n";
		i = MATH / R;
		C = i / f / CH2 / 2 / pi;
		cout << "电容值为" << C * 1E9 << "nF\n";
		break;
	case 0:
		cout << "确定ac间为电阻\n";
		i = CH2 / R;
		C = i / f / MATH / 2 / pi;
		cout << "电容值为" << C * 1E9 << "nF\n";
		break;
	default:
		cout << "default being called!\n";
		break;
	}
}

void inductor()
{
	cout << "开始测电感。确认CH1与电源连在bc，CH2连在ac！\n";
	cout << "输入ac间的元件类型：   0-R     1-C\n";
	int choice = -1;
	double CH1, CH2, MATH, i, R, f, C, L;
	R = 97.5;//后面可能需要改；
	cin >> choice;
	cout << "输入CH2有效值（mV）：";
	cin >> CH2;
	cout << "输入MATH有效值（mV）：";
	cin >> MATH;
	cout << "输入电源频率（kHz）：";
	cin >> f;
	//虽然输入的值单位不一定是国际单位，但内部运算用国际单位
	f = f * 1000;
	CH2 = CH2 / 1000;
	//这里全部转成国际单位
	MATH = MATH/1000;
	switch (choice)
	{
	case 1:
		cout << "确定ac间为电容\n";
		cout << "输入电容值(没有电容算不出来)（nF）:\n";
		cin >> C;
		C = C * 1E-9;
		i = CH2* f * C;
		L = MATH / f / i / 2 / pi;
		cout << "电感值为" << L * 1E6 << "uH\n";
		break;
	case 0:
		cout << "确定ac间为电阻\n";
		i = CH2 / R;
		L = MATH / f / i / 2 / pi;
		cout << "电感值为" << L * 1E6 << "uH\n";
		break;
	default:
		cout << "default being called!\n";
		break;
	}
}
int main()
{
	int choose = -1;
	int quit = 1;
	while (quit)
	{
		cout << "选择待测元件种类：   0-C   1-L   2-quit\n";
		cin >> choose;
		switch (choose)
		{
		case 0:
			capacitor();
			break;
		case 1:
			inductor();
			break;
		case 2:
			cout << "over!\n";
			quit = 0;
			break;
		default:
			cout << "default!\n";
			break;
		}
	}

	
}