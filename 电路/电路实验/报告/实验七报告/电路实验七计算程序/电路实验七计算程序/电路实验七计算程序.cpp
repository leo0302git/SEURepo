#include<iostream>
#include<math.h>
using namespace std;
void experiment_4_2()
{
	double u = 60.0;//�����ѹ�����˵�ѹ������Ϊ60V
	double R = 50;//��֪����ĵ�ѹ������Ϊ50ŷķ
	double omega = 100 * 3.1415926;
	cout << "ȷ����ѹ�����˵�ѹΪU=60V������u1��";
	double u1,u2;
	cin >> u1;
	cout << "����u2��";
	cin >> u2;
	double cos_theta = (u * u - u1 * u1 - u2 * u2) / (2 * u1 * u2);
	double sine = sqrt(1 - cos_theta * cos_theta);
	double ur = u2 * cos_theta;
	double ux = u2 * sine;
	double r = R * ur / u1;
	double L = R * ux / omega / u1 *1000;
	double C = u1 / omega / R / ux *1000000;
	double cos_varphi = (u1 + ur) / u;
	cout << "ѡ�����������迹 Z1:0   Z2:1\n";
	bool i;
	cin >> i;
	cout << "���������\n";
	if (i)
	{
		cout << "Z2\t" << "U(V):" << u << "\tU1(V):" << u1 << "\tU2(V):" << u2;
		cout << "\tcos_theta:" << cos_theta << "\tur(V)" << ur << "\tux(V):" << ux << endl;
		cout << "r(��):" << r << "\tC(uF):" << C  << endl;
		//cout << "Z2�еĵ���ֵΪ" << C*1000000<<"uF";
	}
	else
	{
		cout << "Z1\t" << "U(V):" << u << "\tU1(V):" << u1 << "\tU2(V):" << u2 ;
		cout << "\tcos_theta:" << cos_theta << "\tur(V)" << ur << "\tux(V):" << ux<<endl;
		cout << "r(��):" << r << "\tL(mH):" << L <<endl;
		//cout << "Z1�еĵ��ֵΪ" << L * 1000 << "mH";
	}
	return;
}
void experiment_4_3()
{
	double i = 0.3;//���û�·����Ϊ0.3A
	double R0 = 50;//��֪����ĵ�ѹ������Ϊ50ŷķ
	double omega = 100 * 3.1415926;
	cout << "ȷ��������ʾ��Ϊ0.3A��ѡ�����������迹��Z1:0   Z2:1   Z1+Z2:2   Z1//Z2:3\n";
	int choice;
	cin>> choice;
	double u;
	double p;
	double z, cos_varphi, r, r0, x, L, C;//z���迹����Чֵ
	cout << "�����ѹֵU��V��\n";
	cin >> u;
	cout << "���빦��ֵP��W��\n";
	cin >> p;
	z = u / i;
	cos_varphi = p / u / i;
	r = p / i / i;
	x = sqrt(z * z - r * r);
	L = x / omega *1000;
	C = 1 / x / omega *1000000;
	//r0 = r - R0;
	if (choice == 0)
	{
		cout << "Z1\t" <<"I(A):"<<i << "\tU(V):" << u << "\tP(W):" << p << "\tz(��):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\t��·�ܵ���(��)" << r << "\tx(��):" << x ;
		cout << "\tL(mH):" << L  << endl;
		return;
	}
	if (choice == 1)
	{
		cout << "Z2\t" << "I(A):" << i << "\tU(V):" << u << "\tP(W):" << p << "\tz(��):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\tr(��)" << r << "\tx(��):" << x;
		cout << "\tC(uF):" << C  << endl;
		return;
	}
	if (choice == 2)
	{
		cout << "Z1+Z2\t" << "I(A):" << i << "\tU(V):" << u << "\tP(W):" << p << "\tz(��):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\tr(��)" << r << "\tx(��):" << x;
		cout << "\tL(mH):" << L  << "\tC(uF):" << C  << endl;
		cout << "���ǵ�·�����ԣ�����Lֵ��ʵ������\n";
		return;
	}
	if (choice == 3)
	{
		cout << "Z1+Z2\t" << "I(A):" << i << "\tU(V):" << u << "\tP(W):" << p << "\tz(��):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\tr(��)" << r << "\tx(��):" << x;
		cout << "\tL(mH):" << L  << "\tC(uF):" << C  << endl;
		cout << "���ǵ�·�ʸ��ԣ�����Cֵ��ʵ������\n";
		return;
	}

}
void cal_cos_varphi()
{
	double i, u, p;
	cout << "�������ֵI��A����\n";
	cin >> i;
	cout << "�����ѹֵU��V����\n";
	cin >> u;
	cout << "���빦��ֵP��W����\n";
	cin >> p;
	double cos_varphi = p / i / u;
	cout << "����ֵI��A����" << i << "\t��ѹֵU��V����" << u << "\t����ֵP��W����" << p << "\t��������cos�գ�" << cos_varphi << endl;
	return;
}
int main()
{
	while (1)
	{
		cout << "------------------------------------------------------------------------\n";
		cout << "ѡ���������  ʵ��4-2:0   ʵ��4-3:1   ͨ��������������������2  �˳���3\n";
		int i;
		cin >> i;
		if (i == 0)
		{
			experiment_4_2();
		}
		if (i == 1)
		{
			experiment_4_3();
		}
		if (i == 2)
		{
			cal_cos_varphi();
		}
		if (i == 3)
		{
			cout << "������\n";
			break;
		}
	}

}
