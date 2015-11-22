unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, ExtCtrls, Vcl.Buttons, System.UITypes, FMX.WebBrowser,
  Vcl.OleCtrls, SHDocVw, MSHTML, ActiveX;
const ErrorDelay = 5000;
      ParseDelay=500;
type
  TForm1 = class(TForm)
    Label1: TLabel;
    url: TEdit;
    Label2: TLabel;
    ButtonLinks: TButton;
    list: TMemo;
    Label3: TLabel;
    IdHTTP1: TIdHTTP;
    IdAntiFreeze1: TIdAntiFreeze;
    ButtonParse: TButton;
    Label4: TLabel;
    Edit1: TEdit;
    Label5: TLabel;
    MemoSite: TMemo;
    ButtonSite: TButton;
    ButtonClear: TButton;
    SaveDialog1: TSaveDialog;
    MemoLog: TMemo;
    LabelTimer: TLabel;
    CBChinaText: TCheckBox;
    ButtonVK: TButton;
    MemoVK: TMemo;
    ButtonExit: TButton;
    Memo1: TMemo;
    CheckBoxLocal: TCheckBox;
    procedure ButtonLinksClick(Sender: TObject);
    procedure ButtonParseClick(Sender: TObject);
    procedure ButtonSiteClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure urlChange(Sender: TObject);
    procedure ButtonVKClick(Sender: TObject);
    procedure ButtonExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    LTimer:boolean;
    function StrRemoveText(const S:UnicodeString):UnicodeString;
    function StrRemoveHRef(const S: UnicodeString): UnicodeString;
    procedure Log(const S: string);
    function GetResponse(const GetUrl:string):Utf8String;
//    function ParseStrPage(var StrPage: string): string;
  public
    done:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses RegularExpressionsCore;

procedure Fill(Src:string; SList:TStringList);
begin
if Pos(',', Src)=0 then
  begin SList.Add(Src);exit; end;
while Pos(',',Src)>0 do
  begin
  SList.Add(Copy(Src,1,Pos(',', Src)-1));
  Delete(Src, 1, Pos(',', Src));
  end;
SList.Add(Src);
end;

Function Before (const Src:Utf8String ; S:Utf8string ) : Utf8string ;
Var
  F : integer ;
begin
  F := POS (Src,S) ;
  if F=0 then
    Before := S
  else
    Before := COPY(S,1,F-1) ;
end ;

Function After (const Src:Utf8string ; S:Utf8string ) : Utf8string ;
Var
  F : integer ;
begin
  F := POS (Src,S) ;
  if F=0 then
    After := ''
  else
    After := COPY(S,F+length(src),length(s)) ;
end ;

function Between(const Src:String ; SO1, SO2, SI1:string; P1:integer; SI2:string; P2:integer ) : string ;
// Указывается строка поиска, ограничивающие строки SO1 SO2
// Внутренние строки SI1, SI2 показывают начало и конец искомой строки
// P1 и P2 показывают, насколько нужно отступить от позиций S1 и S2 (может быть отрицательным)
Var
  F1, F2 : integer;
  Where, Tmp:string;
begin
F1 := pos(SO1,Src);
F2 := pos(SO2,Copy(Src,F1+1,length(Src)))+F1;
if (F1=0) or (F2=0) then begin Result:=''; exit; end;
Where:= copy(Src,F1+length(SO1),F2-F1-length(SO1));
F1 := pos(SI1,Where);
Where:=Copy(Where,F1+length(SI1)-P1,length(Where));
F2 := pos(SI2,Where);
Where:=Copy(Where,1,F2-1-P2);
if (F1=0) or (F2=0) then begin Result:=''; exit; end;
Result:= Where;
end ;

function StrReplace(const Str, SFrom, STO: string): string;
// Заменяет в строке Str строку SFrom на строку STO
var
  P, L: Integer;
begin
  Result := str;
  L := Length(SFrom);
  repeat
    P := Pos(SFrom, Result);
    if P > 0 then
    begin
      Delete(Result, P, L);
      Insert(STo, Result, P);
    end;
  until P = 0;
end;

function TForm1.GetResponse(const GetUrl:string):Utf8String;

var  vResponse: TStringStream;
 Hlt:integer;
 IdHTTP:TIdHTTP;
begin
IdHTTP:=TIdHTTP.Create(Application);
IDHTTP.HandleRedirects:=true;
IdHTTP.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; rv:22.0) Gecko/20100101 Firefox/22.0';
IdHTTP.Request.Accept:='*/*';
IdHTTP.Request.AcceptEncoding:='deflate';
IdHTTP.Request.Referer:=url.Text;
vResponse := TStringStream.Create('', TEncoding.GetEncoding(936)); //китайцы рулят!
Ltimer:=not Ltimer;
if LTimer then LabelTimer.Caption:='-' else LabelTimer.Caption:='+';
try
Sleep(ParseDelay);
IdHTTP.Get(GetUrl,vResponse);
except
  begin
  Sleep(ErrorDelay);
  try
    IdHTTP.Get(GetUrl,vResponse);
  except on E:Exception do
    Log(GetUrl+' Ошибка '+E.Message);
  end; //try
  end;//begin
end;//except
Result:=vResponse.DataString;
vResponse.Free;
IdHttp.Destroy;
end;

procedure TForm1.ButtonLinksClick(Sender: TObject);
var StrPage, NextURL:string;
P, Hlt, StrNum:integer;
begin
if url.Text ='' then exit;
Hlt:=0;
StrNum:=0;
Done:=false;
url.Enabled:=False;
ButtonLinks.Enabled:=False;
repeat
  inc(StrNum);
  Log('Получаем '+url.Text + '/search.htm?pageNo='+IntToStr(StrNum));
  StrPage := GetResponse(url.Text + '/search.htm?pageNo='+IntToStr(StrNum));
  if Pos('class="item-not-found"', StrPage)>0 then break; //Выход из repeat
  if StrNum>500 then break;
  while Pos('a class="item-name"', StrPage) > 0 do
    begin
    StrPage := Copy(StrPage, P + length('a class="item-name"'), length(StrPage));
    P := Pos('a class="item-name"', StrPage);
    NextUrl:=Between(StrPage, 'a class="item-name"', 'target="_blank"','href="', 0, '"', 0);
    if length(nextURL)>0 then list.Lines.Add(NextURL);
    inc(Hlt);
    if Hlt > 100 then break;
    end;
  application.ProcessMessages;
  Label3.Caption := 'Найдено ' + IntToStr(list.Lines.Count) + ' товаров';
until false;
application.ProcessMessages;
url.Enabled := True;
ButtonLinks.Enabled := True;
Label3.Caption := Label3.Caption + '. Сбор окончен';
end;

procedure TForm1.ButtonParseClick(Sender: TObject);
var
userid, artikul, kartinka, dostavka, oldcena: string;
cena: real;
StrPage, Str1, temp2, temp3, razmer, cvet, nazvanie, opisanie, opisanie2: Utf8String;
opisanieU: UnicodeString;
cveta, razmery: TStringList;
i, r, c, ccc: integer;
vResponse: TStringStream;
prices, Price1, price2:string;
AF:TFormatSettings;
ParamWebBrowser: TWebBrowser;
Headers: OleVariant;
Doc:IHTMLDocument2;
DocSelect:IHTMLElementCollection;
DocElement:IHtmlElement;
DocElementSelect:IHTMLSelectElement;

Window: IHTMLWindow2;
oRange1: variant;
//IdHTTP:TIdHTTP;
begin
//IDHTTP1:=TIDHTTP.Create(Application);
IDHTTP1.HandleRedirects:=true;
IdHTTP1.Request.UserAgent:='Mozilla/5.0 (Windows NT 6.1; rv:22.0) Gecko/20100101 Firefox/21.0';
IdHTTP1.Request.Accept:='*/*';
IdHTTP1.Request.AcceptEncoding:='deflate';

ParamWebBrowser := TWebBrowser.Create(Application.mainForm);
TWinControl(ParamWebBrowser).Name:= 'ParamWebBrowser'+IntToStr(Application.mainform.ComponentCount);
TWinControl(ParamWebBrowser).Parent:= Application.mainForm;
ParamWebBrowser.Height := 300;
ParamWebBrowser.Width := 300;
ParamWebBrowser.Visible := true;
//ParamWebBrowser.Align := alTop;
//ParamWebBrowser.Silent := true;
//ParamWebBrowser.Update;
paramWebBrowser.Navigate('about:blank');
repeat
Application.HandleMessage;
Sleep(10);
until paramWebBrowser.ReadyState >= READYSTATE_COMPLETE;
paramWebBrowser.Navigate('http://detail.tmall.com/item.htm?id=19637453872&rn=efd02cfeea82137b3f377a4b59d7cc00', EmptyParam, EmptyParam, EmptyParam, Headers);
repeat
Application.HandleMessage;
Sleep(100);
until paramWebBrowser.ReadyState >= READYSTATE_COMPLETE;
    if paramWebBrowser.Document <> nil then
    begin
      paramWebBrowser.Document.QueryInterface(IHTMLDocument2, Doc);
      DocSelect := (Doc.all.tags('SELECT')as IHTMLElementCollection);
      for i := 0 to DocSelect.length - 1 do
        begin
          DocElement := DocSelect.Item(i,EmptyParam) as IHTMLElement;
          DocElementSelect := DocElement as IHTMLSelectElement;
          Log(DocElementSelect.Name+'-'+DocElementSelect.Value);
        end;
    end;
AF:=TFormatSettings.Create();
cveta:=TStringList.Create();
razmery:=TStringList.Create();
edit1.Enabled:=False;
ButtonParse.Enabled:=False;
if CheckBoxLocal.Checked=true then
  begin
  List.Lines.Clear;
  List.Lines.Add('http://detail.tmall.com/item.htm?spm=a1z10.3.w4011-2911433707.80.iFRYml&id=21272824563&rn=59aaf7400e6e00e26721ed6a2cbd8077');
  List.Lines.Add('http://detail.tmall.com/item.htm?id=19637453872&rn=efd02cfeea82137b3f377a4b59d7cc00');
  end;

if (list.Lines.Count>0) then
  begin
  for i := 0 to List.Lines.Count - 1 do
     begin
     //sleep(ParseDelay);
     artikul:=After('id=',List.Lines[i]);
     IdHTTP1.Request.Referer:=List.Lines[i];
     vResponse := TStringStream.Create('', TEncoding.GetEncoding(936)); //китайцы рулят!
     try
     Sleep(ParseDelay);
     IdHTTP1.Get(List.Lines[i],vResponse);
     except
       begin
       Sleep(ErrorDelay);
       try
       IdHTTP1.Get(List.Lines[i],vResponse);
       except on E:Exception do
       Log('При получении List '+List.Lines[i]+' Ошибка '+E.Message);
       end;
       end;
     end;
     StrPage:=vResponse.DataString;
     vResponse.SaveToFile('tmall'+IntToStr(Random(1000))+'.htm');
     //if CheckBox1.Checked then begin Memo1.Lines.LoadFromFile('page.htm');StrPage:=Memo1.Text;end;
     Str1:=After('userid=',StrPage);
     userid:=Before(';',Str1);
     //Log('userID='+'!'+userid+'!');
     Str1:=After('<title>',StrPage);
     nazvanie:=Before('</title>',Str1);
     Log('Nazvanie='+'!'+nazvanie+'!');
     //Str1:=After('true;s.src="',StrPage);
     //oplink:=Before('"',Str1);
     //Log('Oplink='+'!'+oplink+'!');
     //kartinka:=Between(StrPage, '<img id="J_ImgBooth"','<span class', 'http',0, '.jpg', 0);
     kartinka:=Between(StrPage, '<span id="J_ImgBooth"','</span>', 'src="',0, 'jpg', -3);
     Log('Kartinka='+'!'+kartinka+'!');
     //Str1:=After('<em class="tb-rmb-num">',StrPage);
     //oldcena:=Before('</em>',Str1);
     oldcena:=Between(StrPage, 'J_CurPrice','/strong', '>',0, '<',0);
     if oldcena = '' then oldcena:=Between(StrPage, 'id="J_StrPrice" class="J_CurPrice"','/strong', '>',0, '<',0);
     //<strong id="J_StrPrice" class="J_CurPrice del">78.00</strong>
     //<strong class="J_CurPrice">63.90</strong>
     Log('oldcena='+'!'+oldcena+'!');
     temp2:=After('<dl class="tb-prop J_Prop tb-clearfix J_TMySizeProp">',Str1);
     temp2:=Before('</ul></dd></dl>',temp2);
     razmer:='';
     while temp2<>'' do
     begin
     temp2:=After('<span>',temp2);
     temp3:=Before('</span>',temp2);
     if temp3<>'' then razmer:=razmer+temp3+', ';
     end;
     razmer:=Copy(razmer,0, length(razmer)-2);
     if razmer<>'' then
     Str1:=After('</ul></dd></dl>',Str1);
     Str1:=After('tb-clearfix J_TSaleProp',Str1);
     temp2:=Before('</ul></dd></dl>',Str1);
     cvet:='';
     while temp2<>'' do
     begin
     temp2:=After('<span>',temp2);
     temp3:=Before('</span>',temp2);
     if temp3<>'' then cvet:=cvet+temp3+', ';
     end;
     cvet:=Copy(cvet,0, length(cvet)-2);
     Str1:=After('<div id="attributes" class="attributes">',Str1);
     opisanie:=Before('</div>',Str1);
     //opisanieU:=Utf8ToUnicodeString(Opisanie);
     //StrRemoveChina(opisanieU);
     opisanie:=StringReplace(opisanieU,#13,'',[rfReplaceAll]);
     opisanie:=StringReplace(opisanieU,#10,'',[rfReplaceAll]);
     opisanie:=StringReplace(opisanieU,'  ',' ', [rfReplaceAll]);
     opisanie:=StringReplace(opisanieU,'  ',' ', [rfReplaceAll]);
     opisanie:=StringReplace(opisanieU,'  ',' ', [rfReplaceAll]);
     //Delete(opisanieU,1,Pos('<br><hr><br>',opisanieU)-1);
     if CBChinaText.Checked then opisanie:=StrRemoveText(opisanie);
     opisanie:=StrRemoveHRef(opisanie);
     //UnicodeToUTF8(PAnsiChar(Opisanie),length(Opisanie), PWideChar(OpisanieU),length(OpisanieU));
     vResponse.Free;
     vResponse := TStringStream.Create('', TEncoding.GetEncoding(936)); //китайцы рулят!
     try
     Sleep(ParseDelay);
     IdHTTP1.Get('http://ajax.tbcdn.cn/json/umpStock.htm?itemId='+artikul+'&p=1&sellerId='+userid,vResponse);
     except
       try
       Sleep(ErrorDelay);
       IdHTTP1.Get('http://ajax.tbcdn.cn/json/umpStock.htm?itemId='+artikul+'&p=1&sellerId='+userid,vResponse);
       except on E:EXception do
       Memolog.Lines.Add('При получении'+'http://ajax.tbcdn.cn/json/umpStock.htm?itemId='+artikul+'&p=1&sellerId='+userid+' ошибка '+E.Message);
     end;
     end;
     Str1:=vResponse.DataString;
     Str1:=After('price:"',Str1);
     if Before('"',Str1)<>''
      then
      begin
      try
      cena:=StrToFloat(StringReplace(Before('"',Str1),'.',AF.DecimalSeparator,[rfReplaceAll]));
        except on E:EconvertError do
          begin
          Prices:=StringReplace(Before('"',Str1),'.',AF.DecimalSeparator,[rfReplaceAll]);
          Prices:=StringReplace(Prices,',',AF.DecimalSeparator,[rfReplaceAll]);
          Price1:=trim(Copy(Prices,1,Pos('-',Prices)-1));
          Price2:=trim(Copy(Prices,Pos('-',Prices)+1,length(prices)));
          try
          if StrToFloat(Price1,AF)>StrToFloat(Price2,AF) then cena:=StrToFloat(Price1,AF) else cena:=StrToFloat(Price2,AF);
          except
          cena:=0;
          end;
          //MemoLog.lines.Add('Для артикула '+artikul+'Строка '+Prices+',две цены !'+Price1+'! и !'+Price2+'!,выбрали '+FloatToStr(cena));
         end;
        end;
      end
      else
      begin
      try
      //cena:=StrToFloat(StrReplace(oldcena,'.',','));
      cena:=StrToFloat(StringReplace(oldcena,'.',AF.DecimalSeparator,[rfReplaceAll]));
        except on E:EconvertError do
          begin
          Prices:=StringReplace(oldcena,'.',AF.DecimalSeparator,[rfReplaceAll]);
          Prices:=StringReplace(Prices,',',AF.DecimalSeparator,[rfReplaceAll]);
          Price1:=trim(Copy(Prices,1,Pos('-',Prices)-1));
          Price2:=trim(Copy(Prices,Pos('-',Prices)+1,length(prices)));
          try
          if StrToFloat(Price1,AF)>StrToFloat(Price2,AF) then cena:=StrToFloat(Price1,AF) else cena:=StrToFloat(Price2,AF);
          except
          cena:=0;
          end;
          //MemoLog.lines.Add('Строка '+Prices+',две цены !'+Price1+'! и !'+Price2+'!,выбрали '+FloatToStr(cena));
          end;
        end;
      end;
     cena:=cena*(100+StrToFloat(edit1.Text))/100;
     vResponse.Free;
     vResponse := TStringStream.Create('', TEncoding.GetEncoding(936)); //китайцы рулят!
     try
     IdHTTP1.Get('http://ajax.tbcdn.cn/json/ifq.htm?id='+artikul+'&sid='+userid+'&p=1',vResponse);
     except
     try
     Sleep(ErrorDelay);
     IdHTTP1.Get('http://ajax.tbcdn.cn/json/ifq.htm?id='+artikul+'&sid='+userid+'&p=1',vResponse);
     except on E:Exception do
     Memolog.Lines.Add('При получении '+'http://ajax.tbcdn.cn/json/ifq.htm?id='+artikul+'&sid='+userid+'&p=1'+' ошибка '+E.Message);
     end;
     end;
     Str1:=vResponse.DataString;
     Str1:=After('<em class="tb-rmb-num">',Str1);
     dostavka:=Before('</em>',Str1);
     vResponse.Free;
     vResponse := TStringStream.Create('', TEncoding.GetEncoding(936)); //китайцы рулят!
     //try
     //IdHTTP1.Get(oplink,vResponse);
     //except
     //try
     //Sleep(ErrorDelay);
     //IdHTTP1.Get(oplink,vResponse);
     //except
     //Memolog.Lines.Add('LINE='+List.Lines[i]+'   Error while getting link '+oplink);
     //end;
     //end;
     //Str1:=vResponse.DataString;
     Str1:=After('desc=''',Str1);
     opisanie2:=Before(''';',Str1);
     opisanie2:=StrReplace(opisanie2,'\','');
     opisanie2:=StrReplace(opisanie2,#13, '');
     opisanie2:=StrReplace(opisanie2,#10, '');
     opisanie2:=StrReplace(opisanie2,'  ', ' ');
     opisanie2:=StrReplace(opisanie2,'  ', ' ');
     opisanie2:=StrReplace(opisanie2,'  ', ' ');
     if CBChinaText.Checked then opisanie2:=StrRemoveText(opisanie2);
     opisanie2:=StrRemoveHRef(opisanie2);
     vResponse.Free;
     opisanie:=opisanie+'<br><hr><br>'+opisanie2;
     opisanie2:='';
     if length(opisanie)>32500 then
     begin
     opisanie2:=Copy(opisanie,32501,length(opisanie));
     opisanie:=Copy(opisanie,0,32500);
     end;
     memoVK.Lines.Add(artikul+'; '+StrReplace(nazvanie,';',' ')+'; '
        +kartinka+'; '+FloatToStrF(cena,fffixed,10,2)+'; '
        +cvet+'; '+razmer);
     cveta.Clear;
     razmery.Clear;
     Fill(cvet, cveta);
     Fill(razmer, razmery);
     for r := 0 to razmery.Count-1 do
       for c := 0 to cveta.Count-1 do
       memoSite.Lines.Add(artikul+'; '+StrReplace(nazvanie,';',' ')+'; '
        +kartinka+'; '+FloatToStrF(cena,fffixed,10,2)+'; '+dostavka+'; '
        +cveta[c]+'; '+razmery[r]+'; '
        +'; '+StrReplace(opisanie,';',' ')+'; '+StrReplace(opisanie2,';',' ')+'; ; ');
     application.ProcessMessages;
     label5.Caption:='Собрано '+inttostr(i+1)+' товаров:';
     end; //for
  end; //if
edit1.Enabled:=True;
ButtonParse.Enabled:=True;
Done:=true;
cveta.Destroy;
razmery.Destroy;
//IDHTTP1.Destroy;
end;

procedure TForm1.ButtonSiteClick(Sender: TObject);
begin
if not Done then
    if MessageDlg('Идет скачивание. Всё равно сохранить?', mtWarning, [mbYes, mbNo],0) = mrNo then exit;

SaveDialog1.FileName:=Before('.taobao.com',After('http://',url.Text))+'_Site'+'.csv';
if SaveDialog1.Execute then  memoSite.Lines.SaveToFile(SaveDialog1.FileName,TEncoding.UTF8);
end;

procedure TForm1.ButtonVKClick(Sender: TObject);
begin
if not Done then
    if MessageDlg('Идет скачивание. Всё равно сохранить?', mtWarning, [mbYes, mbNo],0) = mrNo then exit;

SaveDialog1.FileName:=Before('.taobao.com',After('http://',url.Text))+'_VK'+'.csv';
if SaveDialog1.Execute then  memoVK.Lines.SaveToFile(SaveDialog1.FileName,TEncoding.UTF8);
end;

procedure TForm1.ButtonClearClick(Sender: TObject);
var
StrPage, Str2:String;
Where:integer;
begin
memoSite.Clear;
memoVK.Clear;
memoLog.Clear;
Memo1.Lines.LoadFromFile('page.htm',TEncoding.UTF8);
StrPage:=Memo1.Text;
Where:=Pos('a class="item-name"',StrPage);
MemoLog.Lines.Add(IntToStr(Where));
StrPage:=Copy(StrPage,Where,length(StrPage));
Memo1.Text:=StrPage;
Where:=Pos('target="_blank"',StrPage);
MemoLog.Lines.Add(IntToStr(Where));
Str2:=Between(StrPage,'a class="item-name"', 'target="_blank"','href="',0,'"',0);
MemoLog.Lines.Add(Str2);
end;

procedure TForm1.ButtonExitClick(Sender: TObject);
begin
Close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
LTimer:=true;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
Close;
end;

function TForm1.StrRemoveText(const S:UnicodeString):UnicodeString;
var RegExp : TPerlRegEx;
begin
Result:='';
RegExp := TPerlRegEx.Create();
try
RegExp.RegEx:= '<([^<]*)>';
RegExp.Subject:=S;
if regexp.Match then
  repeat
  Result:=Result+'<'+Regexp.Groups[1]+'>';
  until not regexp.MatchAgain;
finally
  RegExp.Free;
end;
end;

function TForm1.StrRemoveHRef(const S:UnicodeString):UnicodeString;
var PH, PK:integer;
begin
Result:=Copy(S, 1, length(S));
while Pos('href="',Result)>0 do
  begin
  PH:=Pos('href="',Result);
  PK:=PH+6+Pos('"',Copy(Result,PH+7, length(Result)));
  Result:=Copy(Result,1,PH-1)+copy(Result,PK+1, length(Result));
  end;
end;

procedure TForm1.urlChange(Sender: TObject);
begin
// http://gdcase.taobao.com/
// http://shop68059979.taobao.com/
// http://z8888.taobao.com/
end;

procedure TForm1.Log(const S:string);
begin
  Memolog.Lines.Add(S);
end;
end.
