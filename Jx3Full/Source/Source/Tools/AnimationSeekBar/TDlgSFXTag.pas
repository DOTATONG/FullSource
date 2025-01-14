unit TDlgSFXTag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AnimationSeekBarImpl1;
type
  TSFXTagDialog = class(TForm)
    Lable_SFXTagList: TLabel;
    Combo_SFXTagList: TComboBox;
    Group_SFXTagContent: TGroupBox;
    BindEdit: TButton;
    Label_SFXPlayMode: TLabel;
    Combo_PlayMode: TComboBox;
    Label_PlaySpeed: TLabel;
    Edit_PlaySpeed: TEdit;
    Check_AdaptSpeedToMotion: TCheckBox;
    Check_Interruptable: TCheckBox;
    Check_MotionFinishKeep: TCheckBox;
    Check_NotifyRepresent: TCheckBox;
    Button_Delete: TButton;
    Button_Copy: TButton;
    Group_DataContent: TGroupBox;
    Label_BindIndex: TLabel;
    Label_BindFileName: TLabel;
    Edit_BindFileName: TEdit;
    Label_BindIndexNum: TLabel;
    Label_SFXFileName: TLabel;
    Edit_SFXFileName: TEdit;
    Button_New: TButton;
    Label_TagName: TLabel;
    Edit_TagName: TEdit;
    Button_Paste: TButton;
    procedure BindEditClick(Sender: TObject);
    procedure Combo_SFXTagListSelect(Sender: TObject);
    procedure Button_NewClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure Edit_TagNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpdateUIControlState();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_CopyClick(Sender: TObject);
    procedure Button_PasteClick(Sender: TObject);
  private
    { Private declarations }
    procedure UpdateUI(nPlayType: Integer;
      fPlaySpeed: Single;
      nAutoAdaptSpeed: Integer;
      nInterruptable: Integer;
      nKeepMotionFinish: Integer;
      nNotify: Integer;
      nBindIndex: Integer;
      strSFXFileName: WideString;
      strTagName: WideString);
  public
    { Public declarations }
    m_nLastItem : Integer;
    m_nFrame    : Integer;
    m_AnimationSeekBar : TAnimationSeekBar;
    procedure OnInitDialog(nFrame : Integer);
    procedure FillTagList(nFrame : Integer);
  end;

var
  SFXTagDialog: TSFXTagDialog;

implementation

{$R *.dfm}

procedure TSFXTagDialog.BindEditClick(Sender: TObject);
var
  nTagID      : Integer;
begin
  nTagID := Integer(Combo_SFXTagList.Items.Objects[Combo_SFXTagList.ItemIndex]);
  m_AnimationSeekBar.OnSFXFileButton(nTagID);
  ModalResult := mrOK;
end;

procedure TSFXTagDialog.UpdateUI(nPlayType: Integer;
  fPlaySpeed: Single;
  nAutoAdaptSpeed: Integer;
  nInterruptable: Integer;
  nKeepMotionFinish: Integer;
  nNotify: Integer;
  nBindIndex: Integer;
  strSFXFileName: WideString;
  strTagName : WideString);
begin
  UpdateUIControlState();
  if Combo_SFXTagList.ItemIndex <> -1 then
  begin
    Combo_PlayMode.ItemIndex := nPlayType;
    Edit_PlaySpeed.Text := FloatToStr(fPlaySpeed);
    Check_AdaptSpeedToMotion.Checked := BOOL(nAutoAdaptSpeed);
    Check_Interruptable.Checked := BOOL(nInterruptable);
    Check_MotionFinishKeep.Checked := BOOL(nKeepMotionFinish);
    Check_NotifyRepresent.Checked := BOOL(nNotify);
    Edit_BindFileName.Text := 'None';
    Label_BindIndexNum.Caption := IntToStr(nBindIndex);
    Edit_SFXFileName.Text := strSFXFileName;
    Edit_TagName.Text := strTagName;
  end;
end;

procedure TSFXTagDialog.Combo_SFXTagListSelect(Sender: TObject);
var
nLastTagID       : Integer;
nCurrentTagID    : Integer;
nPlayType        : Integer;
fPlaySpeed       : Single;
nAdapt           : Integer;
nInterruptable   : Integer;
nMotionKeep      : Integer;
nNotify          : Integer;
nBindIndex       : Integer;
strSFXFileName   : WideString;
strTagName       : WideString;
nLastItem        : Integer;
begin
   if Combo_SFXTagList.ItemIndex = -1 then
    Exit;
   nLastItem := Combo_SFXTagList.ItemIndex;
   nCurrentTagID := Integer(Combo_SFXTagList.Items.Objects[Combo_SFXTagList.ItemIndex]);
   if m_nLastItem <> -1 then
   begin
     nLastTagID    := Integer(Combo_SFXTagList.Items.Objects[m_nLastItem]);
     nPlayType := Combo_PlayMode.ItemIndex;
     fPlaySpeed := StrtoFloat(Edit_PlaySpeed.Text);
     nAdapt     := Integer(Check_AdaptSpeedToMotion.Checked);
     nInterruptable := Integer(Check_Interruptable.Checked);
     nMotionKeep := Integer(Check_MotionFinishKeep.Checked);
     nNotify := Integer(Check_NotifyRepresent.Checked);
     strTagName := WideString(Edit_TagName.Text);
     m_AnimationSeekBar.FEvents.OnSFXTagSave(nLastTagID,
       nPlayType,
       fPlaySpeed,
       nAdapt,
       nInterruptable,
       nMotionKeep,
       nNotify,
       strTagName,
       StrToInt(Label_BindIndexNum.Caption));
   end;
   m_AnimationSeekBar.FEvents.OnSFXTagLoad(nCurrentTagID,
     nPlayType,
     fPlaySpeed,
     nAdapt,
     nInterruptable,
     nMotionKeep,
     nNotify,
     nBindIndex,
     strSFXFileName,
     strTagName);
   UpdateUI(nPlayType,
     fPlaySpeed,
     nAdapt,
     nInterruptable,
     nMotionKeep,
     nNotify,
     nBindIndex,
     strSFXFileName,
     strTagName);
   m_nLastItem := nLastItem;
end;



procedure TSFXTagDialog.Button_NewClick(Sender: TObject);
var
  nID              : Integer;
begin
  m_AnimationSeekBar.FEvents.OnSFXTagNew(nID, m_nFrame);
  FillTagList(m_nFrame);
  Combo_SFXTagList.ItemIndex := Combo_SFXTagList.Items.Count - 1;
  Combo_SFXTagListSelect(nil);
end;

procedure TSFXTagDialog.Button_DeleteClick(Sender: TObject);
var
  nID : Integer;
  nItemIndex : Integer;
begin
  begin
    if Combo_SFXTagList.ItemIndex = -1 then
      Exit;
    nItemIndex := Combo_SFXTagList.ItemIndex - 1;
    if nItemIndex = -1 then
      nItemIndex := 0;
    nID := Integer(Combo_SFXTagList.Items.Objects[Combo_SFXTagList.ItemIndex]);
    if m_nLastItem = Combo_SFXTagList.ItemIndex then
      m_nLastItem := -1;
    m_AnimationSeekBar.FEvents.OnSFXTagDelete(nID);
    FillTagList(m_nFrame);
    if Combo_SFXTagList.Items.Count <> 0 then
    begin
      Combo_SFXTagList.ItemIndex := nItemIndex;
      Combo_SFXTagListSelect(nil);
    end;
  end
end;

procedure TSFXTagDialog.OnInitDialog(nFrame : Integer);
begin
  m_AnimationSeekBar := TAnimationSeekBar(Owner);
  Combo_SFXTagList.Clear();
  m_nLastItem := -1;
  m_nFrame := nFrame;
  FillTagList(nFrame);
  Edit_BindFileName.Enabled := false;
  Edit_SFXFileName.Enabled := false;
end;

procedure TSFXTagDialog.FillTagList(nFrame : Integer);
var
  nReturn : Integer;
  strTagName : WideString;
  nID : Integer;
  nCount : Integer;
begin
  nReturn := 0;
  nCount := 0;
  Combo_SFXTagList.Clear();
  if m_AnimationSeekBar.FEvents <> nil then
  begin
    m_AnimationSeekBar.FEvents.OnSFXTagFillTagList(nFrame, nCount, strTagName, nID, nReturn);
    while nReturn <> 0 do
    begin
      nCount := nCount + 1;
      Combo_SFXTagList.AddItem(strTagName, TObject(nID));
      m_AnimationSeekBar.FEvents.OnSFXTagFillTagList(nFrame, nCount, strTagName, nID, nReturn);
    end;
    if Combo_SFXTagList.Items.Count <> 0 then
    begin
      Combo_SFXTagList.ItemIndex := 0;
      Combo_SFXTagListSelect(nil);
    end;
  end;
  UpdateUIControlState();
end;

procedure TSFXTagDialog.UpdateUIControlState();
var
  bTagSelected : boolean;
begin
  bTagSelected := true;
  if Combo_SFXTagList.ItemIndex = -1 then
    bTagSelected := false;
  Combo_PlayMode.Enabled := bTagSelected;
  Edit_PlaySpeed.Enabled := bTagSelected;
  Check_AdaptSpeedToMotion.Enabled := bTagSelected;
  Check_Interruptable.Enabled := bTagSelected;
  Check_MotionFinishKeep.Enabled := bTagSelected;
  Check_NotifyRepresent.Enabled := bTagSelected;
  Edit_TagName.Enabled := bTagSelected;
end;


procedure TSFXTagDialog.Edit_TagNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  nCurrentID, nID, nPlayType, nAdapt, nInterruptable, nMotionKeep, nNotify : Integer;
  fPlaySpeed : Single;
  strTagName : WideString;
begin
  if Combo_SFXTagList.ItemIndex = -1 then
    Exit;
  if Key = VK_RETURN then
  begin
    nID := Integer(Combo_SFXTagList.Items.Objects[Combo_SFXTagList.ItemIndex]);
    if m_AnimationSeekBar.FEvents <> nil then
    begin
      nPlayType := Combo_PlayMode.ItemIndex;
      fPlaySpeed := StrToFloat(Edit_PlaySpeed.Text);
      nAdapt     := Integer(Check_AdaptSpeedToMotion.Checked);
      nInterruptable := Integer(Check_Interruptable.Checked);
      nMotionKeep := Integer(Check_MotionFinishKeep.Checked);
      nNotify := Integer(Check_NotifyRepresent.Checked);
      strTagName := WideString(Edit_TagName.Text);
      m_AnimationSeekBar.FEvents.OnSFXTagSave(nID,
        nPlayType,
        fPlaySpeed,
        nAdapt,
        nInterruptable,
        nMotionKeep,
        nNotify,
        strTagName,
        StrToInt(Label_BindIndexNum.Caption));
      nCurrentID := Combo_SFXTagList.ItemIndex;
      FillTagList(m_nFrame);
      Combo_SFXTagList.ItemIndex := nCurrentID;
      Combo_SFXTagListSelect(nil);
    end
  end
end;

procedure TSFXTagDialog.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  Key : Word;
begin
  Key := VK_RETURN;
  Edit_TagNameKeyDown(nil, Key, []);
end;


procedure TSFXTagDialog.Button_CopyClick(Sender: TObject);
begin
  m_AnimationSeekBar.m_nSFXTagSrCFrame := m_nFrame;
end;

procedure TSFXTagDialog.Button_PasteClick(Sender: TObject);
begin
  if m_AnimationSeekBar.FEvents <> nil then
    m_AnimationSeekBar.FEvents.OnSFXTagCopy(m_AnimationSeekBar.m_nSFXTagSrcFrame, m_nFrame);
end;

end.

