#include<iostream>

using namespace std;
const double pi = 3.1415926;
void capacitor()
{
	cout << "��ʼ����ݡ�ȷ��CH1���Դ����ab��CH2����ac��\n";
	cout << "����ac���Ԫ�����ͣ�   0-R     1-C\n";
	int choice = -1;
	double CH1, CH2, MATH, i, R, f, C, L;
	R = 97.5;//���������Ҫ�ģ�
	cin >> choice;
	cout << "����CH2��Чֵ��mV����";
	cin >> CH2;
	cout << "����MATH��Чֵ��mV����";
	cin >> MATH;
	cout << "�����ԴƵ�ʣ�kHz����";
	cin >> f;
	//��Ȼ�����ֵ��λ��һ���ǹ��ʵ�λ�����ڲ������ù��ʵ�λ
	f = f * 1000;
	CH2 = CH2 / 1000;
	MATH = MATH / 1000;
	switch (choice)
	{
	case 1:
		cout << "ȷ��ac��Ϊ����\n";
		i = MATH / R;
		C = i / f / CH2 / 2 / pi;
		cout << "����ֵΪ" << C * 1E9 << "nF\n";
		break;
	case 0:
		cout << "ȷ��ac��Ϊ����\n";
		i = CH2 / R;
		C = i / f / MATH / 2 / pi;
		cout << "����ֵΪ" << C * 1E9 << "nF\n";
		break;
	default:
		cout << "default being called!\n";
		break;
	}
}

void inductor()
{
	cout << "��ʼ���С�ȷ��CH1���Դ����bc��CH2����ac��\n";
	cout << "����ac���Ԫ�����ͣ�   0-R     1-C\n";
	int choice = -1;
	double CH1, CH2, MATH, i, R, f, C, L;
	R = 97.5;//���������Ҫ�ģ�
	cin >> choice;
	cout << "����CH2��Чֵ��mV����";
	cin >> CH2;
	cout << "����MATH��Чֵ��mV����";
	cin >> MATH;
	cout << "�����ԴƵ�ʣ�kHz����";
	cin >> f;
	//��Ȼ�����ֵ��λ��һ���ǹ��ʵ�λ�����ڲ������ù��ʵ�λ
	f = f * 1000;
	CH2 = CH2 / 1000;
	//����ȫ��ת�ɹ��ʵ�λ
	MATH = MATH/1000;
	switch (choice)
	{
	case 1:
		cout << "ȷ��ac��Ϊ����\n";
		cout << "�������ֵ(û�е����㲻����)��nF��:\n";
		cin >> C;
		C = C * 1E-9;
		i = CH2* f * C;
		L = MATH / f / i / 2 / pi;
		cout << "���ֵΪ" << L * 1E6 << "uH\n";
		break;
	case 0:
		cout << "ȷ��ac��Ϊ����\n";
		i = CH2 / R;
		L = MATH / f / i / 2 / pi;
		cout << "���ֵΪ" << L * 1E6 << "uH\n";
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
		cout << "ѡ�����Ԫ�����ࣺ   0-C   1-L   2-quit\n";
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