object MainForm: TMainForm
  Left = 309
  Top = 197
  Caption = 'Coco/R - Editor'
  ClientHeight = 575
  ClientWidth = 807
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ToolBar: TToolBar
    Left = 0
    Top = 0
    Width = 807
    Height = 29
    Caption = 'ToolBar'
    Images = ImageList
    TabOrder = 1
    object ToolButton12: TToolButton
      Left = 0
      Top = 0
      Width = 8
      Caption = 'tbSeparator1'
      ImageIndex = 24
      Style = tbsSeparator
    end
    object tbNew: TToolButton
      Left = 8
      Top = 0
      Action = FileNewAction
    end
    object tbFileOpen: TToolButton
      Left = 31
      Top = 0
      Action = FileOpenAction
    end
    object tbSave: TToolButton
      Left = 54
      Top = 0
      Action = FileSaveAction
    end
    object tbPrint: TToolButton
      Left = 77
      Top = 0
      Action = FilePrintAction
    end
    object tbSep1: TToolButton
      Left = 100
      Top = 0
      Width = 8
      Caption = 'tbSeparator2'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object tbCut: TToolButton
      Left = 108
      Top = 0
      Action = CutAction
    end
    object tbCopy: TToolButton
      Left = 131
      Top = 0
      Action = CopyAction
    end
    object tbPaste: TToolButton
      Left = 154
      Top = 0
      Action = PasteAction
    end
    object tbDelete: TToolButton
      Left = 177
      Top = 0
      Action = DeleteAction
    end
    object tbSep2: TToolButton
      Left = 200
      Top = 0
      Width = 8
      Caption = 'tbSeparator3'
      ImageIndex = 1
      Style = tbsSeparator
    end
    object tbCompile: TToolButton
      Left = 208
      Top = 0
      Action = CompileAction
    end
    object tbOptions: TToolButton
      Left = 231
      Top = 0
      Action = EditOptionsAction
    end
    object tbCompileOptions: TToolButton
      Left = 254
      Top = 0
      Action = CompileOptionsAction
    end
    object tbSep3: TToolButton
      Left = 277
      Top = 0
      Width = 8
      Caption = 'tbSeparator4'
      ImageIndex = 18
      Style = tbsSeparator
    end
    object tbFontName: TComboBox
      Left = 285
      Top = 0
      Width = 173
      Height = 21
      Hint = 'Font Name|Select font name'
      Ctl3D = False
      DropDownCount = 10
      ParentCtl3D = False
      TabOrder = 0
    end
    object tbFontSize: TEdit
      Left = 458
      Top = 0
      Width = 26
      Height = 22
      Hint = 'Font Size|Select font size'
      TabOrder = 1
      Text = '10'
    end
    object tbUpDown: TUpDown
      Left = 500
      Top = 0
      Width = 15
      Height = 22
      Associate = tbFontSize
      Min = 4
      Position = 10
      TabOrder = 2
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 556
    Width = 807
    Height = 19
    Panels = <
      item
        Width = 80
      end
      item
        Alignment = taCenter
        Width = 80
      end
      item
        Width = 50
      end>
  end
  object PageControl: TPageControl
    Left = 0
    Top = 29
    Width = 807
    Height = 527
    ActivePage = tsSource
    Align = alClient
    MultiLine = True
    TabOrder = 0
    OnChange = PageControlsChange
    object tsSource: TTabSheet
      Caption = 'Source'
      object SourceEditor: TJvHLEditor
        Left = 0
        Top = 0
        Width = 799
        Height = 499
        Cursor = crIBeam
        GutterWidth = 0
        RightMargin = 96
        RightMarginColor = clSilver
        Completion.ItemHeight = 13
        Completion.Interval = 800
        Completion.ListBoxStyle = lbStandard
        Completion.CaretChar = '|'
        Completion.CRLF = '/n'
        Completion.Separator = '='
        TabStops = '3 5'
        SelForeColor = clHighlightText
        SelBackColor = clHighlight
        OnChange = EditorChange
        OnSelectionChange = EditorSelectionChange
        Align = alClient
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabStop = True
        HighLighter = hlCocoR
        Colors.Comment.Style = [fsItalic]
        Colors.Comment.ForeColor = clOlive
        Colors.Comment.BackColor = clWindow
        Colors.Number.Style = []
        Colors.Number.ForeColor = clNavy
        Colors.Number.BackColor = clWindow
        Colors.Strings.Style = []
        Colors.Strings.ForeColor = clGreen
        Colors.Strings.BackColor = clWindow
        Colors.Symbol.Style = []
        Colors.Symbol.ForeColor = clBlue
        Colors.Symbol.BackColor = clWindow
        Colors.Reserved.Style = [fsBold]
        Colors.Reserved.ForeColor = clWindowText
        Colors.Reserved.BackColor = clWindow
        Colors.Identifer.Style = []
        Colors.Identifer.ForeColor = clWindowText
        Colors.Identifer.BackColor = clWindow
        Colors.Preproc.Style = []
        Colors.Preproc.ForeColor = clGreen
        Colors.Preproc.BackColor = clWindow
        Colors.FunctionCall.Style = []
        Colors.FunctionCall.ForeColor = clWindowText
        Colors.FunctionCall.BackColor = clWindow
        Colors.Declaration.Style = []
        Colors.Declaration.ForeColor = clFuchsia
        Colors.Declaration.BackColor = clWindow
        Colors.Statement.Style = [fsBold]
        Colors.Statement.ForeColor = clWindowText
        Colors.Statement.BackColor = clWindow
        Colors.PlainText.Style = []
        Colors.PlainText.ForeColor = clWindowText
        Colors.PlainText.BackColor = clWindow
      end
    end
    object tsListing: TTabSheet
      Caption = 'Listing'
      ImageIndex = 1
      object ListingEditor: TJvHLEditor
        Left = 0
        Top = 0
        Width = 799
        Height = 499
        Cursor = crIBeam
        GutterWidth = 0
        RightMargin = 96
        RightMarginColor = clSilver
        Completion.ItemHeight = 13
        Completion.Interval = 800
        Completion.ListBoxStyle = lbStandard
        Completion.CaretChar = '|'
        Completion.CRLF = '/n'
        Completion.Separator = '='
        TabStops = '3 5'
        SelForeColor = clHighlightText
        SelBackColor = clHighlight
        OnChange = EditorChange
        OnSelectionChange = EditorSelectionChange
        Align = alClient
        Ctl3D = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabStop = True
        HighLighter = hlDDL
        Colors.Comment.Style = [fsItalic]
        Colors.Comment.ForeColor = clOlive
        Colors.Comment.BackColor = clWindow
        Colors.Number.Style = []
        Colors.Number.ForeColor = clNavy
        Colors.Number.BackColor = clWindow
        Colors.Strings.Style = []
        Colors.Strings.ForeColor = clGreen
        Colors.Strings.BackColor = clWindow
        Colors.Symbol.Style = []
        Colors.Symbol.ForeColor = clBlue
        Colors.Symbol.BackColor = clWindow
        Colors.Reserved.Style = [fsBold]
        Colors.Reserved.ForeColor = clWindowText
        Colors.Reserved.BackColor = clWindow
        Colors.Identifer.Style = []
        Colors.Identifer.ForeColor = clWindowText
        Colors.Identifer.BackColor = clWindow
        Colors.Preproc.Style = []
        Colors.Preproc.ForeColor = clGreen
        Colors.Preproc.BackColor = clWindow
        Colors.FunctionCall.Style = []
        Colors.FunctionCall.ForeColor = clWindowText
        Colors.FunctionCall.BackColor = clWindow
        Colors.Declaration.Style = []
        Colors.Declaration.ForeColor = clFuchsia
        Colors.Declaration.BackColor = clWindow
        Colors.Statement.Style = [fsBold]
        Colors.Statement.ForeColor = clWindowText
        Colors.Statement.BackColor = clWindow
        Colors.PlainText.Style = []
        Colors.PlainText.ForeColor = clWindowText
        Colors.PlainText.BackColor = clWindow
      end
    end
    object tsScripts: TTabSheet
      Caption = 'SQL Scripts'
      ImageIndex = 2
      object SqlPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 799
        Height = 499
        ActivePage = tsTable
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        MultiLine = True
        ParentFont = False
        Style = tsFlatButtons
        TabOrder = 0
        OnChange = PageControlsChange
        object tsTable: TTabSheet
          Caption = 'Table'
          object TableEditor: TJvHLEditor
            Left = 0
            Top = 0
            Width = 791
            Height = 468
            Cursor = crIBeam
            GutterWidth = 0
            RightMargin = 96
            RightMarginColor = clSilver
            ReadOnly = True
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            OnChange = EditorChange
            OnSelectionChange = EditorSelectionChange
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabStop = True
            HighLighter = hlSql
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clGreen
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clFuchsia
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
        object TabSheet4: TTabSheet
          Caption = 'Metadata'
          ImageIndex = 3
          object MetadataEditor: TJvHLEditor
            Left = 0
            Top = 0
            Width = 791
            Height = 468
            Cursor = crIBeam
            GutterWidth = 0
            RightMargin = 96
            RightMarginColor = clSilver
            ReadOnly = True
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            OnChange = EditorChange
            OnSelectionChange = EditorSelectionChange
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabStop = True
            HighLighter = hlSql
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clGreen
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clFuchsia
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
        object TabSheet1: TTabSheet
          Caption = 'Index'
          ImageIndex = 7
          object IndexEditor: TJvHLEditor
            Left = 0
            Top = 0
            Width = 791
            Height = 468
            Cursor = crIBeam
            GutterWidth = 0
            RightMargin = 96
            RightMarginColor = clSilver
            ReadOnly = True
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            OnChange = EditorChange
            OnSelectionChange = EditorSelectionChange
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabStop = True
            HighLighter = hlSql
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clGreen
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clFuchsia
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
        object TabSheet5: TTabSheet
          Caption = 'Drop Tables'
          ImageIndex = 4
          object DropTableEditor: TJvHLEditor
            Left = 0
            Top = 0
            Width = 791
            Height = 468
            Cursor = crIBeam
            GutterWidth = 0
            RightMargin = 96
            RightMarginColor = clSilver
            ReadOnly = True
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            OnChange = EditorChange
            OnSelectionChange = EditorSelectionChange
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabStop = True
            HighLighter = hlSql
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clGreen
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clFuchsia
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'Drop Indexes'
          ImageIndex = 8
          object DropIndexEditor: TJvHLEditor
            Left = 0
            Top = 0
            Width = 791
            Height = 468
            Cursor = crIBeam
            GutterWidth = 0
            RightMargin = 96
            RightMarginColor = clSilver
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            OnChange = EditorChange
            OnSelectionChange = EditorSelectionChange
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabStop = True
            HighLighter = hlSql
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clGreen
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clFuchsia
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
        object TabSheet7: TTabSheet
          Caption = 'Empty Tables'
          ImageIndex = 6
          object EmptyTableEditor: TJvHLEditor
            Left = 0
            Top = 0
            Width = 791
            Height = 468
            Cursor = crIBeam
            GutterWidth = 0
            RightMargin = 96
            RightMarginColor = clSilver
            ReadOnly = True
            Completion.ItemHeight = 13
            Completion.Interval = 800
            Completion.ListBoxStyle = lbStandard
            Completion.CaretChar = '|'
            Completion.CRLF = '/n'
            Completion.Separator = '='
            TabStops = '3 5'
            SelForeColor = clHighlightText
            SelBackColor = clHighlight
            OnChange = EditorChange
            OnSelectionChange = EditorSelectionChange
            Align = alClient
            Ctl3D = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -13
            Font.Name = 'Courier New'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabStop = True
            HighLighter = hlSql
            Colors.Comment.Style = [fsItalic]
            Colors.Comment.ForeColor = clOlive
            Colors.Comment.BackColor = clWindow
            Colors.Number.Style = []
            Colors.Number.ForeColor = clNavy
            Colors.Number.BackColor = clWindow
            Colors.Strings.Style = []
            Colors.Strings.ForeColor = clGreen
            Colors.Strings.BackColor = clWindow
            Colors.Symbol.Style = []
            Colors.Symbol.ForeColor = clBlue
            Colors.Symbol.BackColor = clWindow
            Colors.Reserved.Style = [fsBold]
            Colors.Reserved.ForeColor = clWindowText
            Colors.Reserved.BackColor = clWindow
            Colors.Identifer.Style = []
            Colors.Identifer.ForeColor = clWindowText
            Colors.Identifer.BackColor = clWindow
            Colors.Preproc.Style = []
            Colors.Preproc.ForeColor = clGreen
            Colors.Preproc.BackColor = clWindow
            Colors.FunctionCall.Style = []
            Colors.FunctionCall.ForeColor = clWindowText
            Colors.FunctionCall.BackColor = clWindow
            Colors.Declaration.Style = []
            Colors.Declaration.ForeColor = clFuchsia
            Colors.Declaration.BackColor = clWindow
            Colors.Statement.Style = [fsBold]
            Colors.Statement.ForeColor = clWindowText
            Colors.Statement.BackColor = clWindow
            Colors.PlainText.Style = []
            Colors.PlainText.ForeColor = clWindowText
            Colors.PlainText.BackColor = clWindow
          end
        end
      end
    end
  end
  object JvHLEdPropDlg: TJvHLEdPropDlg
    JvHLEditor = SourceEditor
    RegAuto = JvRegAuto
    ColorSamples.Strings = (
      '[MODULE SYSTEM;'
      ''
      'TYPE'
      ''
      '  /* '#1087#1088#1080#1084#1077#1088' '#1087#1077#1088#1077#1095#1080#1089#1083#1080#1084#1086#1075#1086' '#1090#1080#1087#1072' */'
      '  TTypMode    = ('
      
        '                '#39'Enumerate'#39', '#39'BLOB'#39',     '#39'Boolean'#39', '#39'Integer'#39', '#39 +
        'Long'#39','
      
        '                '#39'String'#39',    '#39'Currency'#39', '#39'Single'#39',  '#39'Double'#39',  '#39 +
        'TimeStamp'#39','
      
        '                '#39'Date'#39',      '#39'Time'#39',     '#39'Record'#39',  '#39'Set'#39',     '#39 +
        'Array'#39
      '                );'
      ''
      '  // '#1052#1086#1076#1091#1083#1100' '#1089#1080#1089#1090#1077#1084#1099
      '  MODUL ['#1052#1086#1076#1091#1083#1100' '#1089#1080#1089#1090#1077#1084#1099'] = RECORD'
      '    NAME ['#1085#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077'] : string(40);'
      '  END;'
      ''
      ''
      'COLLECTION'
      '  "NULL Collection"             : SET OF COLL0 RS '#39'Coll0'#39';'
      '  "'#1052#1086#1076#1091#1083#1080'"                      : SET OF MODUL RS '#39'Modul'#39';'
      '  "'#1058#1080#1087#1099'"                        : SET OF TYP RS '#39'Typ'#39';'
      ''
      'CONSTRAINT'
      
        '  FKTyp_Scope        : ASSOCIATION FROM "'#1058#1080#1087#1099'" ON (SCOPE) TO "'#1052#1086 +
        #1076#1091#1083#1080'";'
      
        '  FKTyp_BaseTyp      : ASSOCIATION FROM "'#1058#1080#1087#1099'" ON (BASETYP) TO "' +
        #1058#1080#1087#1099'";'
      ''
      'END.'
      '')
    Pages = [epEditor, epColors]
    Left = 36
    Top = 249
  end
  object JvRegAuto: TJvRegAuto
    RegPath = 'Software\Unknown Delphi Application'
    Storage = raIniFile
    IniFile = 'ddl.ini'
    AutoMode = False
    Left = 36
    Top = 190
  end
  object ImageList: TImageList
    Left = 124
    Top = 134
    Bitmap = {
      494C010113001800040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000005000000001002000000000000050
      00000000000000000000000000000000000000000000C0C0C000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C0008080800000000000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C0008080800000000000000000000000000080808000FFFF
      FF008080800080808000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C0008080800080808000C0C0C000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF000000
      0000FFFFFF008080800080808000808080008080800080808000808080008080
      8000FFFFFF00C0C0C0008080800000000000000000000000000080808000FFFF
      FF008080800080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF008080800080808000FFFFFF00000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00080808000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      000000FF00000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C00000000000FFFF
      FF00000000000000000080808000808080008080800080808000808080008080
      8000FFFFFF00C0C0C0008080800000000000000000000000000080808000FFFF
      FF00C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C0008080800000000000000000000000000080808000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      000000FF00000000000000FF00000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF000000
      0000FFFFFF008080800080808000808080008080800080808000808080008080
      8000FFFFFF00C0C0C00080808000000000000000000080000000C0C0C0008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00080808000000000008000000080000000800000000000
      0000000000000000000080808000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000FF00000000000000FF00000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C00000000000FFFF
      FF00000000000000000080808000808080008080800080808000808080008080
      8000FFFFFF00C0C0C00080808000000000008000000000000000800000008000
      0000000000000000000000000000808080008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000FF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00C0C0C00080808000000000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000FF00000000000000FF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF008080800080808000808080008080800080808000FFFFFF008080
      8000808080008080800080808000000000000000000080000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF00000000000000FF00000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0
      C000FFFFFF008080800000000000000000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000FF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C0C0
      C000808080000000000000000000000000008000000000000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080008000800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008000800080008000FFFFFF00FFFFFF00C0C0C000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF0000FFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      800080008000FFFFFF00FFFFFF000000000000000000C0C0C000C0C0C0008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080008080800080808000000000000000
      000000000000000000000000000000000000808080008000800080008000FFFF
      FF00FFFFFF000000000000000000800080008000800000000000C0C0C000C0C0
      C000808080000000000000000000000000000000000000000000000000000000
      00000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080008000FFFFFF000000
      000000000000800080008000800080008000800080008000800000000000C0C0
      C000C0C0C0008080800000000000000000000000000000000000000000000000
      0000000000008080800080808000808080008080800080808000808080000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000808080008080800080808000808080008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000008000
      800080008000800080000080800000FFFF008000800080008000800080000000
      0000C0C0C000C0C0C00080808000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000FF0000008000000000000000
      0000000000000000000080808000000080000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080008000800080008000
      8000800080008000800080008000008080008000800080008000800080008000
      800000000000C0C0C00000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000FF000000FF00000000008080
      800080808000000000000000000000000000000000000000FF00000080000000
      00000000000000000000000080000000FF00000000000000FF000000FF000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFFFF00FFFFFF008080800000FF00000000
      0000000000000000000000000000000000000000000080008000FFFFFF008000
      80008000800080008000800080008000800000FFFF0000FFFF00800080008000
      8000800080000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000FF000000FF00000000008080
      80008080800000000000000000000000000000000000000000000000FF000000
      800000000000000080000000FF0000000000000000000000FF000000FF000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000080008000FFFF
      FF0080008000800080008000800080008000800080000080800000FFFF0000FF
      FF00800080008000800000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      FF00000080000000FF0080808000000000000000000000000000000000000000
      0000808080008080800000000000000000000000000000000000000000000000
      00000000000000000000000000008080800000FF00000000000000FF00000000
      0000000000000000000000000000000000000000000000000000000000008000
      8000FFFFFF00800080008000800080008000008080008000800000FFFF0000FF
      FF008000800080008000800080000000000000000000000000000000000000FF
      0000008000000000000080808000FFFFFF00FFFFFF00FFFFFF00FFFFFF008080
      8000808080000000000000000000000000000000000000000000000000000000
      80000000FF00000080008080800080808000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00808080008080800000000000000000000000000000000000000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000080008000FFFFFF00800080008000800000FFFF0000FFFF0000FFFF008000
      800080008000800080000000000000000000000000000000000000FF00000080
      000000FF00000080000000000000808080000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000080000000
      FF00000000000000FF0000008000808080008080800000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000080008000FFFFFF00800080008000800080008000800080008000
      8000000000000000000000000000000000000000000000FF0000008000000080
      00000000000000FF000000800000000000008080800080808000808080008080
      80008080800000000000000000000000000000000000000080000000FF000000
      000000000000000000000000FF00000080000000000080808000808080008080
      8000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080008000FFFFFF008000800080008000000000000000
      0000000000000000000000000000000000000000000000800000008000000000
      0000000000000000000000FF0000008000000000000000000000000000000000
      000000000000000000000000000000000000000080000000FF00000000000000
      00000000000000000000000000000000FF000000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800080008000800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FF00000080000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000008000000080808000000000000000000000000000000000008000
      0000808080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000080808000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF000000FF00000080000000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000808080008000
      0000000000000000000000000000000000000000000080000000800000008000
      000080000000800000000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000FF0000008000000080808000000000000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FF00
      0000800000000000000080000000808080000000000000000000000000000000
      0000000000000000000080000000000000000000000000000000800000000000
      000000000000000000000000000000000000000000000000000080808000FF00
      0000FF0000008000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000000000000800000008000000000000000000000000000
      0000000000008000000080808000000000000000000000000000800000000000
      0000000000000000000000000000000000000000000080808000800000000000
      0000FF0000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008080800080000000800000008000
      0000800000008080800000000000000000000000000000000000808080008000
      0000000000000000000000000000000000008000000080000000000000000000
      0000000000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008000000080000000800000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000000000000080000000800000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000800000008000000080000000800000008000
      0000800000008000000080000000800000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF008000000080000000800000008000
      00008000000080000000FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000000000000000000080000000000000008000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00800000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000008000000080000000000000008000000000000000000000008000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00800000008000000080000000FFFF
      FF00800000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000008000000080000000800000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF0000000000000000000000
      00000000000000000000FFFFFF00800000000000000000808000808080000080
      8000808080000080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000000000008000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00800000000000000080808000008080008080
      8000008080008080800080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF000000000000000000FFFF
      FF00800000008000000080000000800000000000000000808000808080000080
      8000808080000080800080000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0080000000FFFFFF0080000000000000000000000080808000008080008080
      8000008080008080800000808000808080000080800080808000008080008080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00800000008000000000000000000000000000000000808000808080000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF000000
      000000000000FFFFFF0000000000800000008000000080000000800000008000
      0000800000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000008080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000808000808080000080
      80000000000000FFFF00000000000000000000FFFF0000000000808080000080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00000000000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000000000000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      0000008080000080800000000000000000000000000000000000000000000080
      8000008080000000000000000000000000000000000000000000008080000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF000000
      000000FFFF000000000000FFFF000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF000000000000FF
      FF000000000000FFFF000000000000FFFF000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000080
      800000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000FFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000080800000000000000000000000000000000000000000000080
      8000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000500000000100010000000000800200000000000000000000
      000000000000000000000000FFFFFF008001C000FFFF00008001C000F3FF0000
      8001C000F5FF00008001C000FAFF00008001C000F57F00008001C000FABF0000
      8001C000F55F000080018000FAAF000080011C0FF55F000080014E1FFABF0000
      8001E7FFF57F00008001B3FFFAFF000080031FFFF5FF000080074FFFFBFF0000
      800FE7FFF7FF0000FFFFF3FFFFFF0000FFFFFFFFFC07FE03C007FE3FFBE7FDF3
      BFEBF81FF803FC010005E00FF803FC017E318007FBE3FDF17E350003F803FC01
      00060001F803FC017FEA0000FBE33CF180140001FB239C91DE0A8001FB23C991
      E001C001F3E3E1F1EE07E000E003E001F017F000C0F3C879F03BF80388079C83
      F803FC0F9C7F3E7FFFFFFE3FFE3FFFFFFFFFFE49FFFFFFFF83E0FE49FFFFFFFF
      83E0FFFFFFFFFFFF83E0FFFFFFFFFFFF8080C7C7FFF3FFFF8000D7D7E0F9E7FF
      8100C387E1FDCF838100C007E1FDDFC3C001D087E4FDDFC3E083D087EE79DF93
      E083C007FF03CF3BF1C7C007FFFFE07FF1C7F39FFFFFFFFFF1C7F39FFFFFFFFF
      FFFFF39FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3FFFFFFFC00DFFB
      ED9FFE0080008FFFED6FFE00000087F7ED6FFE000000C7EFF16F80000000E3CF
      FD1F80000001F19FFC7F80000003F83FFEFF80000003FC7FFC7F80010003F83F
      FD7F80030003F19FF93F80070FC3C3CFFBBF807F000387E7FBBF80FF80078FFB
      FBBF81FFF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFDFFFFFFFFC0017FFF
      C007001F8031E007C007000F8031C047C00740078031C047C00720038001C007
      C00750018001C007C007280180014007C007555F8FF1C7C5C0072A9F8FF1C7C7
      C007501F8FF1C7C7C0078FF18FF1C7D7C00FFFF98FF1C007C01FFF758FF5FFFF
      C03FFF8F80017EFBFFFFFFFFFFFFFEFD00000000000000000000000000000000
      000000000000}
  end
  object MainMenu: TMainMenu
    Images = ImageList
    Left = 40
    Top = 78
    object miFile: TMenuItem
      Caption = '&File'
      object miNew: TMenuItem
        Action = FileNewAction
      end
      object miOpen: TMenuItem
        Action = FileOpenAction
      end
      object miSave: TMenuItem
        Action = FileSaveAction
      end
      object miSaveAs: TMenuItem
        Action = FileSaveAsAction
      end
      object miFileSep1: TMenuItem
        Caption = '-'
      end
      object miPrint: TMenuItem
        Action = FilePrintAction
      end
      object miPrintSetup: TMenuItem
        Action = FilePrintSetupAction
      end
      object miFileSep2: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Action = FileExitAction
      end
    end
    object miEditItem: TMenuItem
      Caption = '&Edit'
      object miUndo: TMenuItem
        Action = UndoAction
      end
      object miEditSep1: TMenuItem
        Caption = '-'
      end
      object miCut: TMenuItem
        Action = CutAction
      end
      object miCopy: TMenuItem
        Action = CopyAction
      end
      object miPaste: TMenuItem
        Action = PasteAction
      end
      object miDelete: TMenuItem
        Action = DeleteAction
      end
      object miSelectAll: TMenuItem
        Action = SelectAllAction
      end
      object miEditSep2: TMenuItem
        Caption = '-'
      end
      object miFind: TMenuItem
        Action = FindAction
      end
      object miReplace: TMenuItem
        Action = ReplaceAction
      end
      object miSearchAgain: TMenuItem
        Action = SearchAgainAction
      end
      object miEditSep3: TMenuItem
        Caption = '-'
      end
      object miFont: TMenuItem
        Action = FontAction
      end
    end
    object miToolsItem: TMenuItem
      Caption = '&Tools'
      object miEditOptions: TMenuItem
        Action = EditOptionsAction
      end
      object miCompileOptions: TMenuItem
        Action = CompileOptionsAction
      end
      object miToolSep: TMenuItem
        Caption = '-'
      end
      object miCompileSource: TMenuItem
        Action = CompileAction
      end
    end
    object miHelpItems: TMenuItem
      Caption = '&Help'
      object miContents: TMenuItem
        Action = HelpContentsAction
      end
      object miSepHelp: TMenuItem
        Caption = '-'
      end
      object miAbout: TMenuItem
        Action = HelpAboutAction
      end
    end
  end
  object ActionList: TActionList
    Images = ImageList
    OnUpdate = ActionListUpdate
    Left = 40
    Top = 134
    object FileNewAction: TAction
      Category = 'File'
      Caption = 'New'
      Hint = #1053#1086#1074#1099#1081' '#1092#1072#1081#1083
      ImageIndex = 0
      ShortCut = 16462
      OnExecute = FileNew
    end
    object CutAction: TEditCut
      Category = 'Edit'
      Caption = 'Cu&t'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1089#1090' '#1080' '#1087#1086#1084#1077#1089#1090#1080#1090#1100' '#1077#1075#1086' '#1074' '#1073#1091#1092#1077#1088' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 4
      ShortCut = 16472
      OnExecute = EditCut
    end
    object CopyAction: TEditCopy
      Category = 'Edit'
      Caption = '&Copy'
      Hint = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1090#1077#1082#1089#1090' '#1074' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 5
      ShortCut = 16451
      OnExecute = EditCopy
    end
    object PasteAction: TEditPaste
      Category = 'Edit'
      Caption = '&Paste'
      Enabled = False
      Hint = #1042#1089#1090#1072#1074#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1080#1079' '#1073#1091#1092#1077#1088#1072' '#1086#1073#1084#1077#1085#1072
      ImageIndex = 6
      ShortCut = 16470
      OnExecute = EditPaste
    end
    object DeleteAction: TEditDelete
      Category = 'Edit'
      Caption = '&Delete'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1099#1076#1077#1083#1077#1085#1085#1099#1081' '#1090#1077#1089#1090
      ImageIndex = 7
      ShortCut = 46
      OnExecute = EditDelete
    end
    object SelectAllAction: TEditSelectAll
      Category = 'Edit'
      Caption = 'Select &All'
      Hint = #1042#1099#1076#1077#1083#1080#1090#1100' '#1074#1077#1089#1100' '#1090#1077#1082#1089#1090
      ShortCut = 16449
      OnExecute = EditSelectAll
    end
    object UndoAction: TEditUndo
      Category = 'Edit'
      Caption = '&Undo'
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1086#1089#1083#1077#1076#1085#1102#1102' '#1086#1087#1077#1088#1072#1094#1080#1102
      ImageIndex = 10
      ShortCut = 16474
      OnExecute = EditUndo
    end
    object RedoAction: TAction
      Category = 'Edit'
      Caption = 'Redo'
      Hint = #1042#1077#1088#1085#1091#1090#1100' '#1086#1090#1084#1077#1085#1077#1085#1085#1091#1102' '#1086#1087#1077#1088#1072#1094#1080#1102
      ImageIndex = 11
      ShortCut = 24666
      OnExecute = EditRedo
    end
    object HelpContentsAction: THelpContents
      Category = 'Help'
      Caption = '&Contents'
      Hint = #1057#1087#1088#1072#1074#1082#1072
      ImageIndex = 13
      ShortCut = 112
      OnExecute = HelpContents
    end
    object FileOpenAction: TAction
      Category = 'File'
      Caption = 'Open ...'
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 1
      ShortCut = 16463
      OnExecute = FileOpen
    end
    object FileSaveAction: TAction
      Category = 'File'
      Caption = 'Save'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 2
      ShortCut = 16467
      OnExecute = FileSave
    end
    object FileSaveAsAction: TAction
      Category = 'File'
      Caption = 'Save As ...'
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1092#1072#1081#1083' '#1087#1086#1076' '#1076#1088#1091#1075#1080#1084' '#1080#1084#1077#1085#1077#1084
      ImageIndex = 3
      OnExecute = FileSaveAs
    end
    object FilePrintAction: TAction
      Category = 'File'
      Caption = 'Print ...'
      Hint = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1092#1072#1081#1083
      ImageIndex = 12
      ShortCut = 16464
      OnExecute = FilePrint
    end
    object FilePrintSetupAction: TAction
      Category = 'File'
      Caption = 'Print Setup ...'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1080#1085#1077#1090#1088#1072
      OnExecute = FilePrintSetup
    end
    object FileExitAction: TAction
      Category = 'File'
      Caption = 'Exit'
      Hint = #1042#1099#1093#1086#1076' '#1080#1079' '#1087#1088#1086#1088#1072#1084#1084#1099
      OnExecute = FileExit
    end
    object FindAction: TAction
      Category = 'Edit'
      Caption = 'Find ...'
      Hint = #1055#1086#1080#1089#1082' '#1090#1077#1082#1089#1090#1072
      ImageIndex = 8
      ShortCut = 16454
      OnExecute = EditSearch
    end
    object SearchAgainAction: TAction
      Category = 'Edit'
      Caption = 'Search Again'
      Hint = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1087#1086#1080#1089#1082
      ImageIndex = 9
      ShortCut = 114
      OnExecute = EditSearchAgain
    end
    object HelpAboutAction: TAction
      Category = 'Help'
      Caption = 'About ...'
      Hint = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnExecute = HelpAbout
    end
    object EditOptionsAction: TAction
      Category = 'Tools'
      Caption = 'Edit Options ...'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1088#1077#1076#1072#1082#1090#1086#1088#1086#1074#1072#1085#1080#1103
      ImageIndex = 16
      OnExecute = ToolsEditorOptions
    end
    object CompileOptionsAction: TAction
      Category = 'Tools'
      Caption = 'Compile Options ...'
      Hint = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1086#1084#1087#1080#1083#1103#1094#1080#1080
      ImageIndex = 17
      OnExecute = ToolsCompileOptions
    end
    object CompileAction: TAction
      Category = 'Tools'
      Caption = 'Compile source'
      Hint = #1050#1086#1084#1087#1080#1083#1080#1088#1086#1074#1072#1090#1100' '#1080#1089#1093#1086#1076#1085#1099#1081' '#1082#1086#1076' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ImageIndex = 18
      ShortCut = 120
      OnExecute = ToolsCompile
    end
    object ReplaceAction: TAction
      Category = 'Edit'
      Caption = 'Replace ...'
      Hint = #1047#1072#1084#1077#1085#1072' '#1090#1077#1082#1089#1090#1072
      ShortCut = 16466
      OnExecute = EditReplace
    end
    object FontAction: TAction
      Category = 'Edit'
      Caption = 'Font ...'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1096#1088#1080#1092#1090#1072
      OnExecute = EditFont
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'DDL'
    Filter = 'Data Definition Language (*.ddl)|*.ddl'
    Left = 124
    Top = 78
  end
  object DdlSaveDialog: TSaveDialog
    DefaultExt = 'DDL'
    Filter = 'Data Definition Language (*.ddl)|*.ddl'
    Left = 196
    Top = 78
  end
  object LstSaveDialog: TSaveDialog
    DefaultExt = 'LST'
    Filter = 'DDL listing (*.lst)|*.lst'
    Left = 196
    Top = 134
  end
  object SqlSaveDialog: TSaveDialog
    DefaultExt = 'SQL'
    Filter = 'SQL script (*.sql)|*.sql'
    Left = 196
    Top = 190
  end
  object PrintDialog: TPrintDialog
    Left = 124
    Top = 249
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 196
    Top = 249
  end
  object FindDialog: TFindDialog
    Options = [frDown, frFindNext, frHideWholeWord, frHideUpDown]
    OnFind = EditSearchAgain
    Left = 196
    Top = 305
  end
  object ReplaceDialog: TReplaceDialog
    FindText = 'REGION'
    Options = [frDown, frFindNext, frHideWholeWord, frHideUpDown, frReplace]
    OnFind = EditSearchAgain
    ReplaceText = 'Area'
    OnReplace = ReplaceDialogReplace
    Left = 124
    Top = 305
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 124
    Top = 190
  end
end
