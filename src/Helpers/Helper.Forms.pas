unit Helper.Forms;

interface

uses
  Vcl.Forms,
  System.SysUtils,
  scStyledForm,
  Vcl.Controls;

/// <summary>
/// Classe auxiliar para manipula��o de formul�rios em aplica��es Delphi.
/// </summary>
/// <remarks>
/// Esta classe fornece m�todos �teis para criar formul�rios modais, exibir
/// formul�rios em modo de guias (MDI), mostrar e ocultar efeitos de desfoque
/// em formul�rios.
/// </remarks>
type
  TFormHelper = class
  private
    class var BlurForm: TscStyledForm;

  public
    /// <summary>
    /// Cria um formul�rio modal e o exibe.
    /// </summary>
    /// <typeparam name="Form">
    /// Tipo de formul�rio a ser criado.
    /// </typeparam>
    /// <returns>
    /// Resultado do m�todo ShowModal do formul�rio criado.
    /// </returns>
    class function CreateModalForm<Form: TForm>: TModalResult;

    /// <summary>
    /// Cria um formul�rio em modo de guias (MDI) e o exibe.
    /// </summary>
    /// <typeparam name="FormClass">
    /// Tipo de formul�rio a ser criado.
    /// </typeparam>
    /// <param name="MDIParent">
    /// Formul�rio principal em modo de guias (MDI).
    /// </param>
    /// <param name="CheckIsOpened">
    /// Indica se deve verificar se o formul�rio j� est� aberto.
    /// </param>
    class procedure CreateTabForm<FormClass: TForm>(MDIParent: TForm;
      CheckIsOpened: Boolean);

    /// <summary>
    /// Oculta o efeito de desfoque em um formul�rio.
    /// </summary>
    /// <param name="Form">
    /// Formul�rio ao qual o efeito de desfoque ser� aplicado.
    /// </param>
    class procedure HideFormBlur(Form: TForm);

    /// <summary>
    /// Exibe um efeito de desfoque em um formul�rio.
    /// </summary>
    /// <param name="Form">
    /// Formul�rio ao qual o efeito de desfoque ser� aplicado.
    /// </param>
    class procedure ShowFormBlur(Form: TForm);

  end;

implementation

{ TFormHelper }

class function TFormHelper.CreateModalForm<Form>: TModalResult;
var
  LForm: Form;
begin
  Application.CreateForm(Form, LForm);

  try
    result := LForm.ShowModal;
  finally
    LForm.Release;
  end;
end;

class procedure TFormHelper.CreateTabForm<FormClass>(MDIParent: TForm;
  CheckIsOpened: Boolean);
begin
  var
  FormCount := 0;
  if CheckIsOpened then
  begin
    for VAR i := 0 to MDIParent.MDIChildCount - 1 do
      if (MDIParent.MDIChildren[i] is FormClass) then
      begin
        MDIParent.MDIChildren[i].BringToFront;
        Exit;
      end;
  end
  else
  begin
    for VAR i := 0 to MDIParent.MDIChildCount - 1 do
      if (MDIParent.MDIChildren[i] is FormClass) then
        FormCount := i + 1
  end;
  var
  LForm := FormClass.Create(Application);
  if FormCount > 0 then
    LForm.Caption := LForm.Caption + format(' (%s)', [FormCount.tostring]);
  LForm.FormStyle := fsMDIChild;
  LForm.Show;
end;

class procedure TFormHelper.HideFormBlur(Form: TForm);
begin
  BlurForm.HideClientInActiveEffect;
  if assigned(BlurForm) then
    BlurForm.Free
end;

class procedure TFormHelper.ShowFormBlur(Form: TForm);
begin
  BlurForm := TscStyledForm.Create(Form);
  BlurForm.InActiveClientColor := $00343434;
  BlurForm.ShowClientInActiveEffect;
end;

end.
