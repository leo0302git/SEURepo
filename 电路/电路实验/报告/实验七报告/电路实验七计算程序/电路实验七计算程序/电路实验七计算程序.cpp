#include<iostream>
#include<math.h>
using namespace std;
void experiment_4_2()
{
	double u = 60.0;//自耦变压器两端电压，设置为60V
	double R = 50;//已知电阻的电压，设置为50欧姆
	double omega = 100 * 3.1415926;
	cout << "确保变压器两端电压为U=60V后，输入u1：";
	double u1,u2;
	cin >> u1;
	cout << "输入u2：";
	cin >> u2;
	double cos_theta = (u * u - u1 * u1 - u2 * u2) / (2 * u1 * u2);
	double sine = sqrt(1 - cos_theta * cos_theta);
	double ur = u2 * cos_theta;
	double ux = u2 * sine;
	double r = R * ur / u1;
	double L = R * ux / omega / u1 *1000;
	double C = u1 / omega / R / ux *1000000;
	double cos_varphi = (u1 + ur) / u;
	cout << "选择所测量的阻抗 Z1:0   Z2:1\n";
	bool i;
	cin >> i;
	cout << "测量结果：\n";
	if (i)
	{
		cout << "Z2\t" << "U(V):" << u << "\tU1(V):" << u1 << "\tU2(V):" << u2;
		cout << "\tcos_theta:" << cos_theta << "\tur(V)" << ur << "\tux(V):" << ux << endl;
		cout << "r(Ω):" << r << "\tC(uF):" << C  << endl;
		//cout << "Z2中的电容值为" << C*1000000<<"uF";
	}
	else
	{
		cout << "Z1\t" << "U(V):" << u << "\tU1(V):" << u1 << "\tU2(V):" << u2 ;
		cout << "\tcos_theta:" << cos_theta << "\tur(V)" << ur << "\tux(V):" << ux<<endl;
		cout << "r(Ω):" << r << "\tL(mH):" << L <<endl;
		//cout << "Z1中的电感值为" << L * 1000 << "mH";
	}
	return;
}
void experiment_4_3()
{
	double i = 0.3;//设置回路电流为0.3A
	double R0 = 50;//已知电阻的电压，设置为50欧姆
	double omega = 100 * 3.1415926;
	cout << "确保电流表示数为0.3A。选择所测量的阻抗：Z1:0   Z2:1   Z1+Z2:2   Z1//Z2:3\n";
	int choice;
	cin>> choice;
	double u;
	double p;
	double z, cos_varphi, r, r0, x, L, C;//z是阻抗的有效值
	cout << "输入电压值U（V）\n";
	cin >> u;
	cout << "输入功率值P（W）\n";
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
		cout << "Z1\t" <<"I(A):"<<i << "\tU(V):" << u << "\tP(W):" << p << "\tz(Ω):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\t电路总电阻(Ω)" << r << "\tx(Ω):" << x ;
		cout << "\tL(mH):" << L  << endl;
		return;
	}
	if (choice == 1)
	{
		cout << "Z2\t" << "I(A):" << i << "\tU(V):" << u << "\tP(W):" << p << "\tz(Ω):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\tr(Ω)" << r << "\tx(Ω):" << x;
		cout << "\tC(uF):" << C  << endl;
		return;
	}
	if (choice == 2)
	{
		cout << "Z1+Z2\t" << "I(A):" << i << "\tU(V):" << u << "\tP(W):" << p << "\tz(Ω):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\tr(Ω)" << r << "\tx(Ω):" << x;
		cout << "\tL(mH):" << L  << "\tC(uF):" << C  << endl;
		cout << "但是电路呈容性，所以L值无实际意义\n";
		return;
	}
	if (choice == 3)
	{
		cout << "Z1+Z2\t" << "I(A):" << i << "\tU(V):" << u << "\tP(W):" << p << "\tz(Ω):" << z << endl;
		cout << "\tcos_varphi:" << cos_varphi << "\tr(Ω)" << r << "\tx(Ω):" << x;
		cout << "\tL(mH):" << L  << "\tC(uF):" << C  << endl;
		cout << "但是电路呈感性，所以C值无实际意义\n";
		return;
	}

}
void cal_cos_varphi()
{
	double i, u, p;
	cout << "输入电流值I（A）：\n";
	cin >> i;
	cout << "输入电压值U（V）：\n";
	cin >> u;
	cout << "输入功率值P（W）：\n";
	cin >> p;
	double cos_varphi = p / i / u;
	cout << "电流值I（A）：" << i << "\t电压值U（V）：" << u << "\t功率值P（W）：" << p << "\t功率因数cosφ：" << cos_varphi << endl;
	return;
}
int main()
{
	while (1)
	{
		cout << "------------------------------------------------------------------------\n";
		cout << "选择操作类型  实验4-2:0   实验4-3:1   通过三表法测量功率因数：2  退出：3\n";
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
			cout << "结束！\n";
			break;
		}
	}

}
