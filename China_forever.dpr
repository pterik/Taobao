program China_forever;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  PerlRegEx in 'PerlRegEx.pas',
  pcre in 'pcre.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
