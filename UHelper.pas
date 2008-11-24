unit UHelper;

////////////////////////////////////////////////////////////////////////////////
interface
uses
  Classes, Windows, Dialogs, ExtCtrls, SQLiteTable3, SysUtils, Math, 
  FreeImage,
  //FreeBitmap,
  jpeg,
  UJPGStreamFix,
  Graphics;

procedure alert(s:String);
function doLoadImage(fpath: String; img: TImage; angle: Integer = 0; fi:TObject = nil; db: TSQLiteDatabase = nil; thumbsdb: TSQLiteDatabase = nil; importingThumbs: Boolean = false): Boolean;
procedure saveThumb(db,thumbsdb: TSQLiteDatabase; fi:TObject; img: TImage);

////////////////////////////////////////////////////////////////////////////////
implementation
uses UFileinfo;

procedure alert(s:String);
begin
  messageDlg(s,mtInformation,[mbOK],0);
end;

function doLoadImage(fpath: String; img: TImage; angle: Integer = 0; fi:TObject = nil; db: TSQLiteDatabase = nil; thumbsdb: TSQLiteDatabase = nil; importingThumbs: Boolean = false): Boolean;
var
  dib,dib2,tmp : PFIBITMAP;
  PBH : PBITMAPINFOHEADER;
  PBI : PBITMAPINFO;
  t : FREE_IMAGE_FORMAT;
  Ext : string;
  BM : TBitmap;
  DC : HDC;
  Handle : Integer;
begin
  handle:=0;
  result:=true;
  try
    t := FreeImage_GetFileTypeU(PWideChar(fpath), 16);
    if t = FIF_UNKNOWN then begin
      // Check for types not supported by GetFileType
      Ext := UpperCase(ExtractFileExt(fpath));
      if (Ext = '.TGA') or(Ext = '.TARGA') then
        t := FIF_TARGA
      else if Ext = '.MNG' then
        t := FIF_MNG
      else if Ext = '.PCD' then
        t := FIF_PCD
      else if Ext = '.WBMP' then
        t := FIF_WBMP
      else if Ext = '.CUT' then
        t := FIF_CUT
      else
        raise Exception.Create('The file "' + fpath + '" cannot be displayed because SFM does not recognise the file type.');
    end;

    dib := FreeImage_LoadU(t, PWideChar(fpath), 0);
    tmp:=dib;
    if importingThumbs then
      dib2 := FreeImage_MakeThumbnail(dib,200)
    else
      dib2 := FreeImage_MakeThumbnail(dib,min(img.width,img.height));

    dib:=dib2;
    FreeImage_unload(tmp);

    if angle<>0 then begin
      tmp:=dib;
      dib2 := FreeImage_RotateClassic(dib,angle);
      dib:=dib2;
      FreeImage_unload(tmp);
    end;

//    if Dib = nil
//    then Close;

    PBH := FreeImage_GetInfoHeader(dib);
    PBI := FreeImage_GetInfo(dib^);
    BM := TBitmap.Create;
    BM.Assign(nil);
    DC := GetDC(handle);
    BM.handle := CreateDIBitmap(DC,
                                PBH^,
                                CBM_INIT,
                                PChar(FreeImage_GetBits(dib)),
                                PBI^,
                                DIB_RGB_COLORS);
    img.picture.Bitmap.Assign(BM);

    // Falls ein Fileinfo übergeben wurde,
    // den Thumb in der Datenbank speichern, falls noch nicht vorhanden:
    if fi<>nil then saveThumb(db,thumbsdb,fi,img);

    BM.Free;
    ReleaseDC(Handle, DC);
    FreeImage_Unload(dib);
  except
    result:=false;
  end;
end;


procedure saveThumb(db, thumbsdb: TSQLiteDatabase; fi:TObject; img: TImage);
var
  jp : TJPEGImage;
  data: TMemoryStream;
  tbl: TSQLiteTable;
begin
if false then begin // REDO!!
  tbl:=thumbsdb.GetTable('SELECT data FROM thumbs WHERE fileinfo_id="'+inttostr(TFileinfo(fi).id)+'" LIMIT 1');
  if (tbl.RowCount=0) then begin
    jp:=TJPEGImage.create;
    jp.Assign(img.Picture.Bitmap);
    jp.CompressionQuality:=50;
    jp.compress;
    data:=TMemoryStream.create;
    jp.SaveToStream(data);
    thumbsdb.UpdateBlob('INSERT INTO thumbs (fileinfo_id,data) VALUES ("'+inttostr(TFileinfo(fi).id)+'", ?)',data);
    data.Free;
  end;
end;  
end;

end.
 