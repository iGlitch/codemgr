program codemanager;

{$I list.inc}

uses
  Forms,
  TntForms,
  mform in 'src\mform.pas' {MWindow},
  list in 'src\list.pas',
  codelistmgmt in 'src\codelistmgmt.pas',
  savequest in 'src\savequest.pas' {SaveForm: TTntForm},
  langdata in 'src\langdata.pas',
  WideDialogs in 'src\WideDialogs.pas',
  geckooslist in 'src\geckooslist.pas' {GOSList: TTntForm},
  goscodes in 'src\goscodes.pas',
  {$IFNDEF NOGOSLIST} gosmgmt in 'src\gosmgmt.pas',{$ENDIF}
  SwapFunctions in 'src\SwapFunctions.pas';

{$R *.res}

begin
  Application.Initialize;
  TntApplication.Title:='Wii Cheat Code Manager';
  Application.Title := 'Wii Cheat Code Manager';
  Application.CreateForm(TMWindow, MWindow);
  Application.CreateForm(TSaveForm, SaveForm);
  {$IFNDEF NOGOSLIST}Application.CreateForm(TGOSList, GOSList); {$ENDIF}
  Application.Run;
end.
