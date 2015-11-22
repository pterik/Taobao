unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, RegularExpressions;

type
  TForm2 = class(TForm)
    MemoLog: TMemo;
    BitBtn1: TBitBtn;
    Memo1: TMemo;
    Button1: TButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.BitBtn1Click(Sender: TObject);
var
i,j:integer;
StrPage, Str2:String;
Where:integer;
begin
Memo1.Lines.LoadFromFile('page.htm',TEncoding.UTF8);
StrPage:=Memo1.Text;
Where:=Pos('a class="item-name"',StrPage);
MemoLog.Lines.Add(IntToStr(Where));
StrPage:=Copy(StrPage,Where,length(StrPage));
Memo1.Text:=StrPage;

Where:=Pos('href="',StrPage);
StrPage:=Between()
Copy(StrPage,Where+lenght('href="'),length(StrPage));
//MemoLog.Lines.Add(IntToStr(Where));
 target="_blank">
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
MemoLog.Clear;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
Memo1.Lines.LoadFromFile('page.htm',TEncoding.UTF8);
end;

procedure TForm2.FormDblClick(Sender: TObject);
begin
Memo1.Lines.LoadFromFile('page.htm',TEncoding.UTF8);
end;

end.
