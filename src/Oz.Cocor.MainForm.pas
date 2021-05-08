unit Oz.Cocor.MainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI,
  System.Classes, System.SysUtils,
  System.Actions, System.ImageList, System.UITypes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.StdActns, Vcl.ActnList, Vcl.ImgList, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.ToolWin,
  grdRegAuto, grdHLEdPropDlg, grdEditor, grdHLEditor,
  Oz.Cocor.AboutForm, Oz.Cocor.Options, Oz.Cocor.OptionsForm, Oz.Cocor.Tab,
  Oz.Cocor.Lib, Oz.Cocor.Rsc, Oz.Cocor.Scanner, Oz.Cocor.Parser, Oz.Cocor.Compiler;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miNew: TMenuItem;
    miOpen: TMenuItem;
    miSave: TMenuItem;
    miSaveAs: TMenuItem;
    miFileSep1: TMenuItem;
    miPrintSetup: TMenuItem;
    miPrint: TMenuItem;
    miFileSep2: TMenuItem;
    miExit: TMenuItem;
    miEditItem: TMenuItem;
    miUndo: TMenuItem;
    miEditSep1: TMenuItem;
    miSelectAll: TMenuItem;
    miCut: TMenuItem;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    miDelete: TMenuItem;
    miEditSep2: TMenuItem;
    miFind: TMenuItem;
    miReplace: TMenuItem;
    miSearchAgain: TMenuItem;
    miEditSep3: TMenuItem;
    miFont: TMenuItem;
    miToolsItem: TMenuItem;
    miEditOptions: TMenuItem;
    miCompileOptions: TMenuItem;
    miToolSep: TMenuItem;
    miCompileSource: TMenuItem;
    miHelpItems: TMenuItem;
    miContents: TMenuItem;
    miSepHelp: TMenuItem;
    miAbout: TMenuItem;
    // Actions
    ActionList: TActionList;
    // File actions
    FileNewAction: TAction;
    FileOpenAction: TAction;
    FileSaveAction: TAction;
    FileSaveAsAction: TAction;
    FilePrintSetupAction: TAction;
    FilePrintAction: TAction;
    FileExitAction: TAction;
    // Edit actions
    UndoAction: TEditUndo;
    RedoAction: TAction;
    SelectAllAction: TEditSelectAll;
    CutAction: TEditCut;
    CopyAction: TEditCopy;
    PasteAction: TEditPaste;
    DeleteAction: TEditDelete;
    FindAction: TAction;
    ReplaceAction: TAction;
    SearchAgainAction: TAction;
    FontAction: TAction;
    EditOptionsAction: TAction;
    // Tools actions
    CompileOptionsAction: TAction;
    CompileAction: TAction;
    // Help actions
    HelpAboutAction: TAction;
    HelpContentsAction: THelpContents;
    // ToolBar
    ToolBar: TToolBar;
    tbNew: TToolButton;
    tbFileOpen: TToolButton;
    tbSave: TToolButton;
    tbPrint: TToolButton;
    tbSep1: TToolButton;
    tbCut: TToolButton;
    tbCopy: TToolButton;
    tbPaste: TToolButton;
    tbDelete: TToolButton;
    tbSep2: TToolButton;
    tbCompile: TToolButton;
    ToolButton12: TToolButton;
    tbCompileOptions: TToolButton;
    tbOptions: TToolButton;
    tbSep3: TToolButton;
    tbFontName: TComboBox;
    tbFontSize: TEdit;
    tbUpDown: TUpDown;
    // Dialogs
    OpenDialog: TOpenDialog;
    DdlSaveDialog: TSaveDialog;
    LstSaveDialog: TSaveDialog;
    SqlSaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    PrinterSetupDialog: TPrinterSetupDialog;
    FindDialog: TFindDialog;
    ReplaceDialog: TReplaceDialog;
    FontDialog: TFontDialog;
    // other
    ImageList: TImageList;
    PageControl: TPageControl;
    tsSource: TTabSheet;
    JvHLEdPropDlg: TJvHLEdPropDlg;
    JvRegAuto: TJvRegAuto;
    tsListing: TTabSheet;
    tsScripts: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet7: TTabSheet;
    SourceEditor: TJvHLEditor;
    ListingEditor: TJvHLEditor;
    TableEditor: TJvHLEditor;
    MetadataEditor: TJvHLEditor;
    DropTableEditor: TJvHLEditor;
    EmptyTableEditor: TJvHLEditor;
    TabSheet1: TTabSheet;
    IndexEditor: TJvHLEditor;
    TabSheet2: TTabSheet;
    DropIndexEditor: TJvHLEditor;
    SqlPageControl: TPageControl;
    tsTable: TTabSheet;
    StatusBar: TStatusBar;
    // редактирование
    procedure EditCut(Sender: TObject);
    procedure EditCopy(Sender: TObject);
    procedure EditPaste(Sender: TObject);
    procedure EditDelete(Sender: TObject);
    procedure EditSelectAll(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure EditRedo(Sender: TObject);
    procedure EditSearch(Sender: TObject);
    procedure EditSearchAgain(Sender: TObject);
    procedure EditReplace(Sender: TObject);
    procedure EditFont(Sender: TObject);
    // работа с файлами
    procedure FileNew(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure FilePrint(Sender: TObject);
    procedure FilePrintSetup(Sender: TObject);
    procedure FileExit(Sender: TObject);
    // инструменты и справка
    procedure ToolsCompile(Sender: TObject);
    procedure ToolsCompileOptions(Sender: TObject);
    procedure ToolsEditorOptions(Sender: TObject);
    procedure HelpContents(Sender: TObject);
    procedure HelpAbout(Sender: TObject);
    // прочие
    procedure EditorChange(Sender: TObject);
    procedure EditorSelectionChange(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FontSizeChange(Sender: TObject);
    procedure FontNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PageControlsChange(Sender: TObject);
    procedure ReplaceDialogReplace(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FFileName: string;
    FUpdating: Boolean;
    FInit: Boolean;
    FOptions: TOptions;
    FFindDialog: Boolean; // или поиск или замена
    FEditor: TJvHLEditor; // текущий редактор
    procedure GetFontNames;
    procedure SetFileName(const FileName: string);
    procedure CheckFileSave;
    procedure UpdateCursorPos;
    procedure WMDropFiles(var Msg: TWMDropFiles); message WM_DROPFILES;
    procedure PerformFileOpen(const AFileName: string);
    procedure SetModified(Value: Boolean);
    // Update the status of the edit commands
    procedure UpdateEditStatus;
    procedure ShowHint(Sender: TObject);
    procedure SelectionChange(Sender: TObject);
  public
    procedure LocateErrorPos;
    property Options: TOptions read FOptions;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

procedure TMainForm.LocateErrorPos;
var
  errorPos: Integer;
  row, col: Integer;
begin
  PageControl.ActivePage := tsListing;
  errorPos := Pos('^', ListingEditor.Lines.Text);
  ListingEditor.SetFocus;
  ListingEditor.SelStart := errorPos;
  row := ListingEditor.CaretY - 1;
  col := ListingEditor.CaretX - 5;
  SourceEditor.CaretY := row;
  SourceEditor.CaretX := col;
end;

procedure TMainForm.HelpAbout(Sender: TObject);
var
  AboutBox: TAboutBox;
begin
  AboutBox := TAboutBox.Create(nil);
  try
    AboutBox.ShowModal;
  finally
    AboutBox.Free;
  end;
end;

procedure TMainForm.ToolsEditorOptions(Sender: TObject);
begin
  with JvHLEdPropDlg do
    if Execute then
    begin
      ListingEditor.Colors.Assign(SourceEditor.Colors);
      TableEditor.Colors.Assign(SourceEditor.Colors);
      MetadataEditor.Colors.Assign(SourceEditor.Colors);
      IndexEditor.Colors.Assign(SourceEditor.Colors);
      DropTableEditor.Colors.Assign(SourceEditor.Colors);
      EmptyTableEditor.Colors.Assign(SourceEditor.Colors);
      DropIndexEditor.Colors.Assign(SourceEditor.Colors);
      FEditor.Repaint;
      SaveHighlighterColors(SourceEditor, hlDDL);
      Save;
    end;
end;

procedure TMainForm.FilePrint(Sender: TObject);
var
  re: TRichEdit;
begin
  if PrintDialog.Execute then
  begin
    re := TRichEdit.Create(nil);
    try
      re.Visible := False;
      re.Parent := Self;
      re.Font.Name := FEditor.Font.Name;
      re.Font.Size := FEditor.Font.Size - 2;
      re.Lines.Text := FEditor.Lines.Text;
      re.Print(FFileName);
    finally
      re.Free;
    end;
  end;
end;

procedure TMainForm.FilePrintSetup(Sender: TObject);
begin
  PrinterSetupDialog.Execute;
end;

procedure TMainForm.EditCut(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.ClipBoardCut;
end;

procedure TMainForm.EditCopy(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.ClipBoardCopy;
end;

procedure TMainForm.EditPaste(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.ClipBoardPaste;
end;

procedure TMainForm.EditDelete(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.Command(ecDelete);
end;

procedure TMainForm.EditSelectAll(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.Command(ecSelAll);
end;

procedure TMainForm.EditUndo(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.Command(ecUndo);
end;

procedure TMainForm.EditRedo(Sender: TObject);
begin
  if FEditor.Focused then
    FEditor.Command(ecRedo);
end;

procedure TMainForm.EditSearch(Sender: TObject);
begin
  FindDialog.Position := FEditor.ClientOrigin;
  FFindDialog := True;
  FindDialog.Execute;
end;

procedure TMainForm.EditSearchAgain(Sender: TObject);
var
  startPos, FoundAt: Integer;
  find: string;
  matchCase: Boolean;

  function FindText(const s: string): Integer;
  var
    i, startX, startY, atX, atY: Integer;
    ss: string;
  begin
    FEditor.CaretFromPos(startPos, startX, startY);
    for i := startY to FEditor.Lines.Count - 1 do
    begin
      ss := FEditor.Lines[i];
      if not matchCase then
        ss := UpperCase(ss);

      if i = startY then
        ss := Copy(ss, startX, 256);
      atX := AnsiPos(s, ss) - 1;
      if atX >= 0 then
      begin
        if i = startY then
          inc(atX, startX - 1);
        atY := i;
        Result := FEditor.PosFromCaret(atX, atY);
        exit;
      end;
    end;
    Result := -1;
  end;

begin
  if FEditor.SelLength <> 0 then
    startPos := FEditor.SelStart
  else
    startPos := 0;
  if FFindDialog then
  begin
    find := FindDialog.FindText;
    matchCase := frMatchCase in FindDialog.Options;
  end
  else
  begin
    find := ReplaceDialog.FindText;
    matchCase := frMatchCase in ReplaceDialog.Options;
  end;
  if not matchCase then
    find := UpperCase(find);

  FoundAt := FindText(find);
  if FoundAt < 0 then
    ShowMessage(Format(sCannotFind, [find]))
  else
  begin
    FEditor.SetFocus;
    FEditor.SelStart := FoundAt;
    FEditor.SelLength := Length(find);
  end;
end;

procedure TMainForm.EditReplace(Sender: TObject);
begin
  ReplaceDialog.Position := FEditor.ClientOrigin;
  FFindDialog := False;
  ReplaceDialog.Execute;
end;

procedure TMainForm.ReplaceDialogReplace(Sender: TObject);
var
  findStr: string;
  selPos: Integer;
  doReplace: Boolean;
  matchCase: Boolean;
  cnt: Integer;
  txt: string;
begin
  cnt := 0;
  doReplace := frReplaceAll in ReplaceDialog.Options;
  matchCase := frMatchCase in ReplaceDialog.Options;
  findStr := ReplaceDialog.FindText;
  if not matchCase then
  begin
    findStr := UpperCase(findStr);
  end;
  repeat
    inc(cnt);
    if not matchCase then
      txt := UpperCase(FEditor.Lines.Text)
    else
      txt := FEditor.Lines.Text;
    selPos := Pos(findStr, txt);
    if selPos > 0 then
    begin
      FEditor.SelStart := selPos - 1;
      FEditor.SelLength := Length(findStr);
      FEditor.SelText := ReplaceDialog.ReplaceText;
    end
    else
    begin
      if not doReplace then
        MessageDlg(Format(sCannotFind, [ReplaceDialog.FindText]), mtError,
          [mbOk], 0);
      doReplace := False;
    end;
  until (not doReplace) or (cnt > 100);
end;

procedure TMainForm.ToolsCompile(Sender: TObject);
var
  compiler: TCompiler;
//  tab: TTab;
begin
  TableEditor.Lines.Clear;
  compiler := TCompiler.Create(SourceEditor.Lines.Text, ListingEditor.Lines);
  try
    compiler.Compile;
    if not compiler.Ok then
    begin
      LocateErrorPos;
      ShowMessage('Programm has errors');
    end
    else
    begin
//      tab := compiler.Parser.tab;
//      TableEditor.Lines.Text := tab.WriteScript(ssTable);
//      MetadataEditor.Lines.Text := tab.WriteScript(ssMeta);
//      IndexEditor.Lines.Text := tab.WriteScript(ssIndex);
//      EmptyTableEditor.Lines.Text := tab.WriteScript(ssEmptyTable);
//      DropTableEditor.Lines.Text := tab.WriteScript(ssDropTable);
//      DropIndexEditor.Lines.Text := tab.WriteScript(ssDropIndex);
      PageControl.ActivePage := tsScripts;
      SqlPageControl.ActivePage := tsTable;
      PageControlsChange(SqlPageControl);
      ShowMessage('Programm compiled');
    end;
  finally
    compiler.Free;
  end;
end;

procedure TMainForm.HelpContents(Sender: TObject);
begin
  ShowMessage('not implemented');
end;

procedure TMainForm.ToolsCompileOptions(Sender: TObject);
var
  Form: TOptionsForm;
begin
  Form := TOptionsForm.Create(nil);
  try
    if Form.ShowModal = mrOk then
      Form.SaveToIni;
  finally
    Form.Free;
  end;
end;

procedure TMainForm.FileNew(Sender: TObject);
begin
  SetFileName(sUntitled);
  SourceEditor.Lines.Clear;
  SourceEditor.Modified := False;
  SetModified(False);
end;

procedure TMainForm.FileOpen(Sender: TObject);
begin
  CheckFileSave;
  if OpenDialog.Execute then
  begin
    PerformFileOpen(OpenDialog.FileName);
    SourceEditor.ReadOnly := ofReadOnly in OpenDialog.Options;
  end;
end;

procedure TMainForm.PerformFileOpen(const AFileName: string);
begin
  SourceEditor.Lines.LoadFromFile(AFileName);
  SetFileName(AFileName);
  PageControl.ActivePage := tsSource;
  SourceEditor.SetFocus;
  SourceEditor.Modified := False;
  SetModified(False);
end;

procedure TMainForm.FileSave(Sender: TObject);
begin
  if FFileName = sUntitled then
    FileSaveAs(Sender)
  else
  begin
    SourceEditor.Lines.SaveToFile(FFileName);
    SourceEditor.Modified := False;
    SetModified(False);
  end;
end;

procedure TMainForm.FileSaveAs(Sender: TObject);
begin
  if DdlSaveDialog.Execute then
  begin
    if FileExists(DdlSaveDialog.FileName) then
      if MessageDlg(Format(sOverWrite, [DdlSaveDialog.FileName]),
        mtConfirmation, mbYesNoCancel, 0) <> idYes then
        exit;
    SourceEditor.Lines.SaveToFile(DdlSaveDialog.FileName);
    SetFileName(DdlSaveDialog.FileName);
    SourceEditor.Modified := False;
    SetModified(False);
  end;
end;

procedure TMainForm.CheckFileSave;
var
  SaveResp: Integer;
begin
  if not SourceEditor.Modified then
    exit;
  SaveResp := MessageDlg(Format(sSaveChanges, [FFileName]), mtConfirmation,
    mbYesNoCancel, 0);
  case SaveResp of
    idYes:
      FileSave(Self);
    idNo:
      { Nothing };
    idCancel:
      Abort;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CheckFileSave;
end;

procedure TMainForm.FileExit(Sender: TObject);
begin
  Close;
end;

function EnumFontsProc(var LogFont: TLogFont; var TextMetric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
begin
  TStrings(Data).Add(LogFont.lfFaceName);
  Result := 1;
end;

procedure TMainForm.GetFontNames;
var
  DC: HDC;
begin
  DC := GetDC(0);
  EnumFonts(DC, nil, @EnumFontsProc, Pointer(tbFontName.Items));
  ReleaseDC(0, DC);
  tbFontName.Sorted := True;
end;

procedure TMainForm.SetFileName(const FileName: string);
begin
  FFileName := FileName;
  Caption := Format('%s - %s', [ExtractFileName(FileName), Application.Title]);
end;

procedure TMainForm.SetModified(Value: Boolean);
begin
  if Value then
    StatusBar.Panels[1].Text := sModified
  else
    StatusBar.Panels[1].Text := '';
end;

procedure TMainForm.UpdateCursorPos;
var
  CharPos: TPoint;
begin
  CharPos.Y := FEditor.CaretY;
  CharPos.X := FEditor.CaretX;
  inc(CharPos.Y);
  inc(CharPos.X);
  StatusBar.Panels[0].Text := Format(sColRowInfo, [CharPos.Y, CharPos.X]);
end;

procedure TMainForm.UpdateEditStatus;
var
  e: Boolean;
begin
  { Update the status of the edit commands }
  if FEditor.Focused then
  begin
    e := FEditor.SelLength > 0;
    CutAction.Enabled := e;
    CopyAction.Enabled := e;
    if FEditor.HandleAllocated then
    begin
//      UndoAction.Enabled := FEditor.UndoBuffer.CanUndo;
//      PasteAction.Enabled := FEditor.CanPaste;
    end;
  end;
end;

procedure TMainForm.WMDropFiles(var Msg: TWMDropFiles);
var
  CFileName: array [0 .. MAX_PATH] of Char;
begin
  try
    if DragQueryFile(Msg.Drop, 0, CFileName, MAX_PATH) > 0 then
    begin
      CheckFileSave;
      PerformFileOpen(CFileName);
      Msg.Result := 0;
    end;
  finally
    DragFinish(Msg.Drop);
  end;
end;

procedure TMainForm.EditorChange(Sender: TObject);
begin
  SetModified(FEditor.Modified);
end;

procedure TMainForm.EditorSelectionChange(Sender: TObject);
begin
  try
    FUpdating := True;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if FInit then
    exit;
  FInit := True;
  PageControl.ActivePage := tsSource;
  UpdateCursorPos;
  DragAcceptFiles(Handle, True);
  EditorSelectionChange(Self);
  FEditor.SetFocus;
  { Check if we should load a file from the command line }
  if (ParamCount > 0) and FileExists(ParamStr(1)) then
    PerformFileOpen(ParamStr(1));
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  UpdateEditStatus;
end;

procedure TMainForm.EditFont(Sender: TObject);
begin
  FontDialog.Font.Assign(FEditor.Font);
  if FontDialog.Execute then
  begin
    tbFontSize.Text := IntToStr(FontDialog.Font.Size);
    tbFontName.Text := FontDialog.Font.Name;
    FontSizeChange(nil);
    FontNameChange(nil);
  end;
  FEditor.SetFocus;
end;

procedure TMainForm.FontSizeChange(Sender: TObject);
var
  s: Integer;
begin
  if FUpdating then
    exit;
  s := StrToInt(tbFontSize.Text);
  SourceEditor.Font.Size := s;
  ListingEditor.Font.Size := s;
  MetadataEditor.Font.Size := s;
  DropTableEditor.Font.Size := s;
  EmptyTableEditor.Font.Size := s;
  IndexEditor.Font.Size := s;
  DropIndexEditor.Font.Size := s;
  TableEditor.Font.Size := s;
//  SaveToIni(Options);
end;

procedure TMainForm.FontNameChange(Sender: TObject);
var
  s: string;
begin
  if FUpdating then
    exit;
  s := tbFontName.Items[tbFontName.ItemIndex];
  SourceEditor.Font.Name := s;
  ListingEditor.Font.Name := s;
  MetadataEditor.Font.Name := s;
  DropTableEditor.Font.Name := s;
  EmptyTableEditor.Font.Name := s;
  IndexEditor.Font.Name := s;
  DropIndexEditor.Font.Name := s;
  TableEditor.Font.Name := s;
//  SaveToIni(Options);
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  if Length(Application.Hint) > 0 then
  begin
    StatusBar.SimplePanel := True;
    StatusBar.SimpleText := Application.Hint;
  end
  else
    StatusBar.SimplePanel := False;
end;

procedure TMainForm.SelectionChange(Sender: TObject);
begin
  try
    FUpdating := True;
    UpdateCursorPos;
  finally
    FUpdating := False;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  GetFontNames;
  FOptions := GetOptions;
  tbFontName.OnChange := FontNameChange;
  tbFontSize.OnChange := FontSizeChange;
  JvHLEdPropDlg.Restore;
  JvHLEdPropDlg.LoadHighlighterColors(SourceEditor, hlDDL);
  Application.OnHint := ShowHint;
  OpenDialog.InitialDir := ExtractFilePath(ParamStr(0));
  DdlSaveDialog.InitialDir := OpenDialog.InitialDir;
  SetFileName(sUntitled);
  FEditor := SourceEditor;
  SelectionChange(Self);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  PageControlsChange(nil);
end;

procedure TMainForm.PageControlsChange(Sender: TObject);
begin
  case PageControl.ActivePageIndex of
    0:
      FEditor := SourceEditor;
    1:
      FEditor := ListingEditor;
    2:
      case SqlPageControl.ActivePageIndex of
        0:
          FEditor := TableEditor;
        1:
          FEditor := MetadataEditor;
        2:
          FEditor := IndexEditor;
        3:
          FEditor := DropTableEditor;
        4:
          FEditor := DropIndexEditor;
        5:
          FEditor := EmptyTableEditor;
      end;
  end;
  FEditor.SetFocus;
  UpdateEditStatus;
end;

end.
