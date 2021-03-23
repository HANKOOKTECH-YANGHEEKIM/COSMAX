<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
    //-- 로그인 사용자 정보 셋팅
    SysLoginModel loginUser     = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
    String siteLocale           = loginUser.getSiteLocale();

    //-- 검색값 셋팅
    BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
    String callbackFunction     = requestMap.getString("CALLBACKFUNCTION");
    String masterDocId          = requestMap.getString("MASTERDOCID");
    String systemTypeCode       = requestMap.getString("SYSTEMTYPECODE");
    String typeCode             = requestMap.getString("TYPECODE");
    String maxFileSize          = requestMap.getString("MAXFILESIZE");
    String maxFileCount         = requestMap.getString("MAXFILECOUNT");
//  String fileFilter           = requestMap.getString("fileFilter");    //첨부 가능한 파일 필터
    String fileFilter           = CommonProperties.load("attachment.defaultAllowFileExt");  //첨부 가능한 파일 필터
    String fileRFilter          = StringUtil.convertNullDefault(requestMap.getString("FILERFILTER"), "asp;php;aspx;jsp;cs;html;htm;xml;js"); //첨부 불가한 파일 필터
    String randomFileNameYn     = requestMap.getString("RANDOMFILENAMEYN");  //랜덤 파일명 사용여부 (기본값:Y)
    String overwriteYn          = requestMap.getString("OVERWRITEYN");       //중복파일 존재시 덮어쓰기 여부 (기본값:N)

    //-- 결과값 셋팅
    BeanResultMap responseMap     = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

    //-- 파라메터 셋팅
    String actionCode           = responseMap.getString(CommonConstants.ACTION_CODE);
    String modeCode             = responseMap.getString(CommonConstants.MODE_CODE);
%>
<script type="text/javascript" src="/common/_lib/NFUpload/nfupload.js"></script>
<script type="text/javascript">
//-----------------------------------------------------------------------------
// Globals
// -----------------------------------------------------------------------------
var _NF_MaxFileSize = <%=maxFileSize%>;                                 // 업로드 제한 용량 (기본값: 10,240 Kb) (단위는 Kb)
var _NF_MaxFileCount = <%=maxFileCount%>;                               // 업로드 파일 제한 갯수 (기본값: 10)

//업로드 소스파일 경로 (반드시 입력해야함)
var _NF_UploadUrl = "/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_UPLOAD_PROC";
_NF_UploadUrl += "&systemTypeCode="+ encodeURIComponent("<%=systemTypeCode%>");
_NF_UploadUrl += "&typeCode="+ encodeURIComponent("<%=typeCode%>");
_NF_UploadUrl += "&randomFileNameYn=<%=randomFileNameYn%>";
_NF_UploadUrl += "&overwriteYn=<%=overwriteYn%>";

var _NF_FileFilter = (function() {
    // 파일 필터링 값 ex> 이미지|:|*.jpg;*.jpeg;*.gif;*.png;*.bmp;*.ico;*.tiff
    return  "*|:|*." + "<%=fileFilter%>".split(';').join(';*.');
})();
var _NF_DataFieldName = "DataFieldName";                                    // 업로드 폼에 사용되는 값 (기본값(UploadData))
var _NF_Flash_Url = "/common/_lib/NFUpload/nfupload.swf?d=20081028";        // 업로드 컴포넌트 플래쉬 파일명
var _NF_File_Overwrite = <%=("Y".equals(overwriteYn) ? "true" : "false")%>; // 업로드시 파일명 처리방법(true : 원본파일명 유지, 덮어씌우기 모드 / false : 유니크파일명으로 변환, 중복방지)
var _NF_Limit_Ext = "<%=fileRFilter%>";                                     // 파일 제한 확장자 ex> asp;php;aspx;jsp;cs;html;htm;xml;js

// 플래시 업로더 화면 구성 설정 변수
var _NF_Width = 550;                                    // 업로드 컴포넌트 넓이 (기본값 480)
var _NF_Height = 170;                                   // 업로드 컴포넌트 폭 (기본값 150)
var _NF_ColumnHeader1 = '<%=StringUtil.getLocaleWord("L.파일명", siteLocale)%>';                       // 컴포넌트에 출력되는 파일명 제목 (기본값: File Name)
var _NF_ColumnHeader2 = '<%=StringUtil.getLocaleWord("L.용량", siteLocale)%>';                        // 컴포넌트에 출력되는 용량 제목 (기본값: File Size)
var _NF_FontFamily = "<%=StringUtil.getLocaleWord("L.굴림", siteLocale)%>";                            // 컴포넌트에서 사용되는 폰트 (기본값: Times New Roman)
var _NF_FontSize = "11";                                // 컴포넌트에서 사용되는 폰트 크기 (기본값: 11)

// [2008-10-28] Flash 10 support
var _NF_Img_FileBrowse = "/common/_lib/NFUpload/images/btn_file_browse.gif";  // 파일찾기 이미지
var _NF_Img_FileBrowse_Width = "59";                    // 파일찾기 이미지 넓이 (기본값 59)
var _NF_Img_FileBrowse_Height = "22";                   // 파일찾기 이미지 폭 (기본값 22)
var _NF_Img_FileDelete = "/common/_lib/NFUpload/images/btn_file_delete.gif";  // 파일삭제 이미지
var _NF_Img_FileDelete_Width = "59";                    // 파일삭제 이미지 넓이 (기본값 59)
var _NF_Img_FileDelete_Height = "22";                   // 파일삭제 이미지 폭 (기본값 22)
var _NF_TotalSize_Text = "<%=StringUtil.getLocaleWord("L.전체용량", siteLocale)%>";                   // 파일용량 텍스트
var _NF_TotalSize_FontFamily = "<%=StringUtil.getLocaleWord("L.굴림", siteLocale)%>";                  // 파일용량 텍스트 폰트
var _NF_TotalSize_FontSize = "12";                      // 파일용량 텍스트 폰트 크기

var uploadForm, uploadSelf, uploadOpener;

/*****************************************************************************
/* 업로드가 완료 되었을 때 사용되는 함수
/* (주의: 이 함수명은 변경하면 안됩니다.)
/*
/* 함수명을 변경하게 되면 업로드가 완료된 다음 다른 작업을 진행할 수 없습니다.
/* value: 파일명들 (배열로 리턴됨. 단, 업로드가 진행되지 않으면 null값 리턴)
/*****************************************************************************/
function NFU_Complete(value) {
    if (value == null || value.length == 0) {
        alert("<%=StringUtil.getScriptMessage("M.ALERT_NOTEXIST",siteLocale,"L.업로드할첨부")%>");
        return;
    }
    var callback_func = unescape(uploadForm.callbackFunction.value);
    if (callback_func != "") {
        for (var i = 0; i < value.length; i++)
        {
            var fileSavename    = airCommon.convertForJavascript(value[i].name);
            var fileName        = airCommon.convertForJavascript(value[i].realName);
            var fileSize        = airCommon.convertForJavascript(value[i].size);

            //console.log("fileSavename is "+ fileSavename);
            //console.log("fileName is "+ fileName);
            //console.log("fileSize is "+ fileSize);

         // 파일 확장자로 필터  
	        var docIdx = fileName.toUpperCase().lastIndexOf(".");
	        
			if(docIdx > -1){
				fileExt = fileName.substring(docIdx + 1);	        	
	        }
	        
	        if(_NF_Limit_Ext.indexOf(fileExt) > -1) {
	        	alert("<%=StringUtil.getScriptMessage("M.ALERT_DENY_FILEEXT", siteLocale) %>");
	        	return;
	        }
	        
	        // 파일사이즈 0일 때 오류
	        if(fileSize == 0) {
	        	alert("<%=StringUtil.getScriptMessage("M.INFO_NOATTACHFILE", siteLocale) %>");
	        	return;
	        }
            
            //-- 덮어쓰기 기능을 사용할 경우 realName만 리턴되므로 저장파일명을 업로드파일명과 같게 처리함
            fileSavename = (fileSavename != null && fileSavename != "" ? fileSavename : fileName);

            //-- 콜백 함수의 파라메타 태그->값 치환!
            var func = callback_func;
            func = func.replace(/\[FILE_SAVENAME\]/g, fileSavename);
            func = func.replace(/\[FILE_NAME\]/g, fileName);
            func = func.replace(/\[FILE_SIZE\]/g, fileSize);
            //-- 콜백 함수 호출!
            eval("uploadOpener."+ func);
        }
    }

    //-- 창 닫기
    uploadSelf.close();
}

/******************************************************************************
/* 파일 선택한 뒤 용량을 반환해 주는 함수
/* (주의: 이 함수명은 변경하면 안됩니다.)
/*
/* 함수명을 변경하게 되면 업로드가 완료된 다음 다른 작업을 진행할 수 없습니다.
/* value: 선택한 파일 용량 (용량은 KB, MB, GB 단위)
/*****************************************************************************/
function NF_ShowUploadSize(value) {
    // value값에 실제 업로드된 용량이 넘어온다.
    sUploadSize.innerHTML = value;
}

function NFUpload_Debug(value)
{
    Debug("업로드 오류!!!\r\n\r\n" + value);
}

function Cancel()
{
    // 초기화 할때는 첨부파일 리스트도 같이 초기화 시켜 준다.
    NfUpload.AllFileDelete();
    uploadForm.reset();
}

/**
 * 업로드 수행
 */
function doUpload(frm) {
    NfUpload.FileUpload();
}

/**
 * 윈도우 로드시 초기화 작업 수행
 */
window.onload = function () {
    //-- 플래시 컨트롤에서 아래 객체를 직접 참조할 수 없으므로 변수에 담아서 쓴다!!
    uploadForm      = document.form1;
    uploadSelf      = self;
    uploadOpener    = opener;
}
</script>

<div align="center">
    <script type="text/javascript">
    // Flash 업로더 객체를 생성하는 자바 스크립트 입니다.
    // 이 스크립트는 Form 태그내에 들어가게 되면 오류가 발생하기 때문에
    // 반드시 Form 태그 밖에서 사용해야 합니다.
    // [2008-10-28] Flash 10 support
    NfUpload = new NFUpload({
        nf_upload_id : _NF_Uploader_Id,
        nf_width : _NF_Width,
        nf_height : _NF_Height,
        nf_field_name1 : _NF_ColumnHeader1,
        nf_field_name2 : _NF_ColumnHeader2,
        nf_max_file_size : _NF_MaxFileSize,
        nf_max_file_count : _NF_MaxFileCount,
        nf_upload_url : _NF_UploadUrl,
        nf_file_filter : _NF_FileFilter,
        nf_data_field_name : _NF_DataFieldName,
        nf_font_family : _NF_FontFamily,
        nf_font_size : _NF_FontSize,
        nf_flash_url : _NF_Flash_Url,
        nf_file_overwrite : _NF_File_Overwrite,
        nf_limit_ext : _NF_Limit_Ext,
        nf_img_file_browse : _NF_Img_FileBrowse,
        nf_img_file_browse_width : _NF_Img_FileBrowse_Width,
        nf_img_file_browse_height : _NF_Img_FileBrowse_Height,
        nf_img_file_delete : _NF_Img_FileDelete,
        nf_img_file_delete_width : _NF_Img_FileDelete_Width,
        nf_img_file_delete_height : _NF_Img_FileDelete_Height,
        nf_total_size_text : _NF_TotalSize_Text,
        nf_total_size_font_family : _NF_TotalSize_FontFamily,
        nf_total_size_font_size : _NF_TotalSize_FontSize
    });
    </script>
</div>
<form name="form1" method="post">
    <input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
    <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />

    <input type="hidden" name="callbackFunction" value="<%=StringUtil.convertForInput(callbackFunction)%>" />
    <input type="hidden" name="masterDocId" value="<%=StringUtil.convertForInput(masterDocId)%>" />
    <input type="hidden" name="systemTypeCode" value="<%=StringUtil.convertForInput(systemTypeCode)%>" />
    <input type="hidden" name="typeCode" value="<%=StringUtil.convertForInput(typeCode)%>" />

    <div class="buttonlist">
        <span class="ui_btn medium icon" id="btnUpload"><span class="confirm"></span><a href="javascript:void(0)" onclick="doUpload(document.form1);"><%=StringUtil.getLocaleWord("B.UPLOAD",siteLocale)%></a></span>
    </div>
</form>