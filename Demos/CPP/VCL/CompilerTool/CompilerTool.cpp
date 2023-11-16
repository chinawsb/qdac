//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
#include <tchar.h>
//---------------------------------------------------------------------------
#include <Vcl.Styles.hpp>
#include <Vcl.Themes.hpp>
USEFORM("Unit1.cpp", Form_Main);
USEFORM("Unit2.cpp", Form_PathSetup);
USEFORM("Unit3.cpp", Frame_Compiler); /* TFrame: File Type */
//---------------------------------------------------------------------------
int WINAPI _tWinMain(HINSTANCE, HINSTANCE, LPTSTR, int)
{
	try
	{
    if(FindCmdLineSwitch("?",TSysCharSet()<<'\\'<<'/'<<'-',true))
      {
       UnicodeString HelpStr=L"�����б��빤�������в�����\n";
	   HelpStr+=ExtractFileName(Application->ExeName)+L" [����Ԥ�����ļ�]\n";
	   HelpStr+=L"���ò�����\n";
	   HelpStr+=L"/C ����Ԥ�����ļ�,��: /C C:\\QDAC3.CompilerCfg\n";
	   HelpStr+=L"/NU ����ʱ����ʾ�������Զ��˳�����\n";
	   HelpStr+=L"/Q ������ɺ��˳�����\n";
	   HelpStr+=L"/LR ������ɺ���ʾ���뱨��\n";
	   HelpStr+=L"/I Դ��·���б�,��: /I C:\\QDAC3\\Source;D:\\1.pas\n";
	   HelpStr+=L"/SID �Ự����,��: /SID swish\n";
	   HelpStr+=L"/M Դ���ļ�����,��: /M *.pas;*21*.dpk\n";
	   HelpStr+=L"/O Ŀ��·��(���Զ�����Bin��Include��LibĿ¼),��: /O C:\\QDAC3\n";
	   HelpStr+=L"/V ���԰汾�б�,��: /V C6;D6;D7;RS2006;RS2007;RS2010;RSXE8\n";
	   HelpStr+=L"/P Ŀ��ƽ̨�б�,��: /P win32;win64;android;ios;ios64;osx;osx64\n";
	   HelpStr+=L"/D ����ΪDebug�汾(Ĭ��ΪRelease�汾)\n";
	   HelpStr+=L"/A ��������,��: /A WinTypes=Winapi.Windows\n";
	   HelpStr+=L"/XI ��չ��Include·��,��: /XI C:\\BCB\\Include\n";
	   HelpStr+=L"/XL ��չ��Lib����·��,��: /XL C:\\BCB\\Lib \n";
	   HelpStr+=L"/XS ��չ������·��,��: /XS C:\\BCB\\Source\n";
	   HelpStr+=L"/NN ���ɵ�Hpp�в����������ռ�\n";
	   HelpStr+=L"/LS ��DPK�ļ������IDE�汾��\n\n";
	   HelpStr+=L"�����к������ļ�ͬʱ����ʱ�������в����Ḳ�������ļ���Ӧ�Ĳ�����\n";
	   HelpStr+=L"����I/M/V/P/A/XI/XL/XS�ж��ֵ���м���;�ָ���\n·�����пո�ģ�����·��ǰ���\"\"\n";
       HelpStr+=L"��: /I \"C:\\QDAC3;D:\\AAA BBB;X:\\Dev\"";
       MessageBox(NULL,HelpStr.c_str(), L"����",MB_OK+MB_ICONINFORMATION+MB_TOPMOST);
      }
    else
	  {
		Application->Initialize();
		Application->MainFormOnTaskBar = true;
		Application->Title = L"�����б��빤��";
		TStyleManager::TrySetStyle(L"Luna");
		Application->CreateForm(__classid(TForm_Main), &Form_Main);
		Application->Run();
      }
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	catch (...)
	{
		try
		{
			throw Exception("");
		}
		catch (Exception &exception)
		{
			Application->ShowException(&exception);
		}
	}
	return 0;
}
//---------------------------------------------------------------------------
