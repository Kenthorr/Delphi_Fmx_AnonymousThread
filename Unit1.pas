unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm6 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    AniIndicator1: TAniIndicator;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }

    FMyThread1IsStart : boolean ;

  public
    { Déclarations publiques }
  end;

var
  Form6: TForm6;

implementation

{$R *.fmx}

procedure TForm6.Button1Click(Sender: TObject);
begin

  Memo1.Lines.Clear ;

  FMyThread1IsStart := True ;
  Memo1.Visible := False ;

  // Démarrer le Thread Anonyme
  TThread.CreateAnonymousThread(
  procedure()
  var
    I: Integer;
  begin
    for I := 0 to 10000 do begin

      Memo1.Lines.Add('lines : ' + I.ToString) ;

      //Synchrnisation avec l'application principale pour pouvoir stopper le Thread Anonyme
      TThread.Synchronize(TThread.CurrentThread,
      procedure()
      begin

        if FMyThread1IsStart = False then begin
          Memo1.Visible := True ;
          Memo1.Lines.Add('Thread Arrèté') ;
          TThread.Current.Terminate ;
        end;

      end);

    end;

    //Synchrnisation avec l'application principale pour signaler la fin du Thread Anonyme
    TThread.Synchronize(TThread.CurrentThread,
    procedure()
    begin

      Memo1.Lines.Add('Thread Fini') ;
      Memo1.Visible := True ;

    end);

  end).Start;

end;

procedure TForm6.Button2Click(Sender: TObject);
begin
  FMyThread1IsStart := False ;
end;

procedure TForm6.FormShow(Sender: TObject);
begin
  FMyThread1IsStart := False ;
end;

end.
