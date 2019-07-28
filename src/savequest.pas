unit savequest;

interface

{$I list.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ComCtrls, ShellCtrls, ExtCtrls,
  TntExtCtrls, TntDialogs,tntinifiles;

type
  TSaveForm = class(TTntForm)
    HardGroup: TTntGroupBox;
    StoreHard: TTntButton;
    SDGroup: TTntGroupBox;
    StoreSecure: TTntButton;
    DriveSel: TShellComboBox;
    DriveLabel: TTntLabel;
    CncButton: TTntButton;
    StoreTo: TTntPanel;
    SaveDialog: TTntSaveDialog;
    procedure StoreHardClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure DriveSelChange(Sender: TObject);
    procedure StoreSecureClick(Sender: TObject);
  private
    { Private declarations }
  public
    outfile:WideString;
    outname:WideString;
    StoreIni:TTntIniFile;
    procedure SetUpDialog(Extension,FileType:WideString);
    { Public declarations }
  end;

var
  SaveForm: TSaveForm;

implementation

{$R *.DFM}

uses tntsysutils,langdata,mform
{$IFNDEF NOGOSLIST}
 ,geckooslist
{$ENDIF}
 ;

procedure TSaveForm.DriveSelChange(Sender: TObject);
var path:WideString;
begin
 path:=DriveSel.Path;
 if path<>WideIncludeTrailingBackSlash(ExtractFileDrive(path)) then
  begin
   outfile:='';
   StoreTo.Caption:=GetLangString('NOVALIDDRIVE','Invalid drive selected!');
  end
 else
  begin
   outfile:=WideIncludeTrailingBackSlash(ExtractFileDrive(path))+outname;

   StoreIni.WriteString('Main','SDCard',UTF8Encode(WideIncludeTrailingBackSlash(ExtractFileDrive(path))));

   StoreTo.Caption:=WideFormat(GetLangString('STORINGTO','Storing to: %s'),
    [outfile]);
  end;
end;

procedure TSaveForm.SetUpDialog(Extension, FileType: WideString);
begin
 SaveDialog.Filter:=FileType+' (*'+Extension+')|*'+Extension+'|'+
  GetLangString('ALLFILES','All files')+' (*.*)|*.*';
 MWindow.OpenDia.Filter:=FileType+' (*'+Extension+')|*'+Extension+'|'+
  GetLangString('ALLFILES','All files')+' (*.*)|*.*';
{$IFNDEF NOGOSLIST}
 GOSList.OpenGoSList.Filter:=FileType+' (*'+Extension+')|*'+Extension+'|'+
  GetLangString('ALLFILES','All files')+' (*.*)|*.*';
{$ENDIF}
end;

procedure TSaveForm.StoreHardClick(Sender: TObject);
begin
 if SaveDialog.Execute then
  begin
   outfile:=SaveDialog.FileName;
   ModalResult:=mrOk;
  end
 else
  ModalResult:=mrCancel;
end;

procedure TSaveForm.StoreSecureClick(Sender: TObject);
begin
 if outfile='' then
  begin
   WideShowMessage(GetLangString('NOVALIDDRIVE','Invalid drive selected!'));
  end
 else
  begin
   //if not WideDirectoryExists(WideExtractFilePath(outfile)) then
    //CreateDirRecursive(WideExtractFilePath(outfile));
   WideForceDirectories(WideExtractFilePath(outfile));
   ModalResult:=mrOk;
  end;
end;

procedure TSaveForm.TntFormShow(Sender: TObject);
var path:WideString;
begin
 DriveSel.Refresh;
 outfile:='';

 path:=StoreIni.ReadString('Main','SDCard','');
 if path<>'' then
  DriveSel.Path:=path;

 DriveSelChange(Sender);
end;

end.