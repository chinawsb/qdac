unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses qfilemapstream;
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  fs: TQFileStream;
begin
  fs := TQFileStream.Create('c:\temp\³ÌÐò.txt', fmOpenReadWrite);
  try
    Memo1.Lines.LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  fs: TStream;
  b: PByte;
  T: Cardinal;
const
  ASize = 400 * 1024 * 1024;
begin
  GetMem(b, ASize);
  FillChar(b^, ASize, 65);
  T := GetTickCount;
  fs := TQFileStream.Create('c:\temp\ms1.txt', fmCreate);
  try
    fs.WriteBuffer(b^, ASize);
  finally
    FreeAndNil(fs);
    T := GetTickCount - T;
    Memo1.Lines.Add('FileStream used :' + IntToStr(T) + 'ms');
  end;
  T := GetTickCount;
  fs := TQFileStream.Create('c:\temp\ms.txt', fmCreate);
  try
    fs.WriteBuffer(b^, ASize);
  finally
    FreeAndNil(fs);
    T := GetTickCount - T;
    Memo1.Lines.Add('FileMap used :' + IntToStr(T) + 'ms');
  end;

  FreeMem(b);
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  fs: TStream;
  b: Byte;
  T: Cardinal;
  I:Integer;
const
  ASize = 400 * 1024 * 1024;
begin
  b:=65;
  T := GetTickCount;
  fs := TQFileStream.Create('c:\temp\ms1.txt', fmCreate);
  try
    for I := 0 to ASize-1 do
      fs.WriteBuffer(b, 1);
  finally
    FreeAndNil(fs);
    T := GetTickCount - T;
    Memo1.Lines.Add('FileStream used :' + IntToStr(T) + 'ms');
  end;
  T := GetTickCount;
  fs := TQFileStream.Create('c:\temp\ms.txt', fmCreate);
  try
    for I := 0 to ASize-1 do
      fs.WriteBuffer(b, 1);
  finally
    FreeAndNil(fs);
    T := GetTickCount - T;
    Memo1.Lines.Add('FileMap used :' + IntToStr(T) + 'ms');
  end;
end;

end.
