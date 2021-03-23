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
   
    String sol_mas_uid			= request.getParameter("sol_mas_uid");
    
    //-- 검색값 셋팅
    BeanResultMap requestMap             = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);

    String masterDocId                  = requestMap.getString("MASTERDOCID");
    String systemTypeCode               = requestMap.getString("SYSTEMTYPECODE");
    String typeCode                     = requestMap.getString("TYPECODE");
    String defaultFileUids              = requestMap.getString("DEFAULTFILEUIDS");
    String defaultMasterDocIds          = requestMap.getString("DEFAULTMASTERDOCIDS");
    String requiredYn                   = requestMap.getString("REQUIREDYN");
    String requiredHeaderText           = requestMap.getString("REQUIREDHEADERTEXT");    //파일명에 포함해야할 필수 헤더 텍스트
    String maxFileSize                  = requestMap.getString("MAXFILESIZE");
    String maxFileCount                 = requestMap.getString("MAXFILECOUNT");
    String viewType                     = requestMap.getString("VIEWTYPE");
    String fileAddCallbackFunction      = requestMap.getString("FILEADDCALLBACKFUNCTION");
    String fileDeleteCallbackFunction   = requestMap.getString("FILEDELETECALLBACKFUNCTION");
    String fileFilter                   = requestMap.getString("FILEFILTER");
    String fileRFilter                  = requestMap.getString("FILERFILTER");
    String forceInsertYn                = requestMap.getString("FORCEINSERTYN");     //기존 첨부정보를 폐기하고 무조건 신규첨부로 등록시킬지 여부
    String skipInsertYn                 = requestMap.getString("SKIPINSERTYN");      //첨부정보 DB저장작업 SKIP 여부(파일 업로드 전용으로 사용할 경우 = Y)
    String randomFileNameYn             = requestMap.getString("RANDOMFILENAMEYN");  //랜덤 파일명 사용여부 (기본값:Y)
    String overwriteYn                  = requestMap.getString("OVERWRITEYN");       //중복파일 존재시 덮어쓰기 여부 (기본값:N)
    String showImage                    = requestMap.getString("SHOWIMAGE");         //이미지 파일을 보여주기 위한 필드 Y일경우 ShowImage() function이 필요.
    String viewCase                     = requestMap.getString("VIEWCASE");          //WRITE 호출시 VIEW형식으로 보여주는지 여부
    String attachAfterAddMode           = requestMap.getString("ATTACHAFTERADDMODE");//(문서)작성 후 첨부추가 모드인지 여부
    String refColumn					= requestMap.getString("REFCOLUMN");			//컬럼에 파일UID를 저장(기술정보 이미지)에서 사용
    String updateStu					= requestMap.getString("UPDATESTU");			//'Y'인 STATUS_CODE = 'D'로 업데이트
    String singleClass              = (!"1".equals(maxFileCount) ? "" : "single");

    String pdfConvYn					= requestMap.getString("PDFCONVYN");			//PDF로 변환 할것인지 여부
//     singleClass = ""; //REVIEW :  싱글/멀티 첨부 상관없이 멀티로만 첨부하기 위해 값을 없애 놓았음

    //-- 결과값 셋팅
    BeanResultMap responseMap         = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
    SQLResults defaultViewResult    = responseMap.getResult("DEFAULT_VIEW");
    SQLResults viewResult           = responseMap.getResult("VIEW");

    //-- 파라메터 셋팅
    String actionCode           = responseMap.getString(CommonConstants.ACTION_CODE);
    String modeCode             = responseMap.getString(CommonConstants.MODE_CODE);

    //-- 기타값 셋팅
    String ctrlUuid             = StringUtil.getRandomUUID(); //컨트롤을 식별할 고유 아이디 생성!
    
    //-- pdf 변환 boolean
    boolean pdfConv = "Y".equals(pdfConvYn)?true:false;
%>
<input type="hidden" name="_attachFileCtrlUuid" value="<%=StringUtil.convertForInput(ctrlUuid)%>" />
<input type="hidden" name="_attachFileMasterDocId" value="<%=StringUtil.convertForInput(masterDocId)%>" />
<input type="hidden" name="_attachFileSystemTypeCode" value="<%=StringUtil.convertForInput(systemTypeCode)%>" />
<input type="hidden" name="_attachFileTypeCode" value="<%=StringUtil.convertForInput(typeCode)%>" />
<input type="hidden" name="_attachFileRequiredYn" value="<%=StringUtil.convertForInput(requiredYn)%>" />
<input type="hidden" name="_attachFileForceInsertYn" value="<%=StringUtil.convertForInput(forceInsertYn)%>" />
<input type="hidden" name="_attachFileSkipInsertYn" value="<%=StringUtil.convertForInput(skipInsertYn)%>" />
<input type="hidden" name="_attachFileRefColumn" value="<%=StringUtil.convertForInput(refColumn)%>" />
<input type="hidden" name="_attachFileUpdateStu" value="<%=StringUtil.convertForInput(updateStu)%>" />
<div id="file_Element_<%=ctrlUuid%>">
</div>
<%
if("vertical".equals(viewType)){
%>
<table class="none">
    <colgroup>
        <col width="64%" />
        <col width="46%" />
    </colgroup>
    <tr>
        <td align="left" valign="middle">
            <ul class="attach_file_vButton" id="_attachFileList<%=ctrlUuid%>"></ul>
        </td>
        <td align="right" valign="middle">
            <ul class="attach_file_vButton">
                <li><span class="ui_btn small icon"><span class="add"></span><a id="_attachFileAddButton<%=ctrlUuid%>" href="javascript:_attachFileAddButton<%=ctrlUuid%>_Click();"><%=StringUtil.getLocaleWord("B.파일첨부",siteLocale)%></a></span></li>
                <li><span class="ui_btn small icon"><span class="delete"></span><a id="_attachFileDeleteButton<%=ctrlUuid%>" href="javascript:_attachFileDeleteButton<%=ctrlUuid%>_Click();"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span></li>
            </ul>
            
        </td>
    </tr>
</table>
<%
}else{
%>
<%if(!pdfConv){ %>
<ul class="attach_file_<%=singleClass%>button">
    <%if(!"Y".equals(viewCase)){ %>
    <li><span class="ui_btn small icon"><span class="add"></span><a id="_attachFileAddButton<%=ctrlUuid%>" href="javascript:_attachFileAddButton<%=ctrlUuid%>_Click();"><%=StringUtil.getLocaleWord("B.파일첨부",siteLocale)%></a></span></li>
    <li><span class="ui_btn small icon"><span class="delete"></span><a id="_attachFileDeleteButton<%=ctrlUuid%>" href="javascript:_attachFileDeleteButton<%=ctrlUuid%>_Click();"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span></li>
    <%} %>
</ul>
<ul class="attach_file_<%=singleClass%>write" id="_attachFileList<%=ctrlUuid%>" <%if("Y".equals(showImage)){ %>data-meaning="filesOuter"<%} %>  style="line-height: 15px;"></ul>
<%}else{ %>
<script>
	var doConvrt = function(){
		<%-- 
		var msg = "변환을 진행하시겠습니까?";
		if($("input:hidden[data-conv='file_name']").length == 0){
			alert("먼저 변환 할 파일을 첨부하세요.");
			return false;
		}
		if($("#_convertFileList<%=ctrlUuid%>").find("li").length > 0){
			msg = "기존 변환된 파일은 삭제 됩니다. 계속하시겠습니까?";
		}
		if(!confirm(msg)){
			return false;
		}
		 --%>
		var bool = true;
		var sw = "";
		var data = {};
		data["sol_mas_uid"] = "<%=sol_mas_uid %>";
		data["masterDocId"] = "<%=masterDocId%>";
		data["typeCode"] 	= "<%=typeCode%>";
		data["systemTypeCode"] 	= "<%=systemTypeCode%>";
		var cnt				= $("input:hidden[data-conv='file_name']").length;
		var arrfileNm = [];
		var arrfileSaveNm = [];
		
		for(var i=0; i< cnt; i++){
			arrfileNm.push($("input:hidden[data-conv='file_name']").eq(i).val());
			arrfileSaveNm.push($("input:hidden[data-conv='file_savename']").eq(i).val());
		}
		
		data["attFileNm"] 		= arrfileNm;
		data["attSaveFileNm"] 	= arrfileSaveNm;
		airCommon.callAjax("SYS_MULTI_PART", "PDF_CONVERT",data, function(json){
			if(json.length > 0){
				var ul = $("#_convertFileList<%=ctrlUuid%>");
				ul.html("");
				$(json).each(function(i, d){
					
					if(d.RESULT != "ERROR"){
						var li = $("<li>");
						li.css({'cursor':'pointer','color':'blue', 'text-decoration':'underline'});
						li.attr("onClick", "airCommon.popupAttachFileDownload('"+d.UUID+"')");
						li.text(d.FILE_NAME);
						ul.append(li);
						
					}else{
						alert(d.MESSAGE);
						bool = false;
					}
					sw = "complete";
				} );
			}
		});	
		
		
		return bool;
		
	}
</script>
	<input type="hidden" data-meaning="pdf_convert" value="<%=ctrlUuid%>"/>
	<table class="none">
    <colgroup>
        <col width="100%" />
<!--         <col width="50%" /> -->
    </colgroup>
    <tr>
        <td align="left" valign="middle">
	         <ul class="attach_file_<%=singleClass%>button">
			    <%if(!"Y".equals(viewCase)){ %>
			    <li><span class="ui_btn small icon"><span class="add"></span><a id="_attachFileAddButton<%=ctrlUuid%>" href="javascript:_attachFileAddButton<%=ctrlUuid%>_Click();"><%=StringUtil.getLocaleWord("B.파일첨부",siteLocale)%></a></span></li>
			    <li><span class="ui_btn small icon"><span class="delete"></span><a id="_attachFileDeleteButton<%=ctrlUuid%>" href="javascript:_attachFileDeleteButton<%=ctrlUuid%>_Click();"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span></li>
			    <%} %>
			</ul>
			<ul class="attach_file_<%=singleClass%>write" id="_attachFileList<%=ctrlUuid%>" <%if("Y".equals(showImage)){ %>data-meaning="filesOuter"<%} %>  style="line-height: 15px;"></ul>
        </td>
        <td align="right" valign="middle" style="display: none;">
        	<ul class="attach_file_<%=singleClass%>button" style="margin-left: 5px;">
			   <li><span class="ui_btn small icon"><span class="confirm"></span><a href="javascript:void(0)" onClick="doConvrt<%=ctrlUuid%>();">변환</a></span></li>
			</ul>
        	<ul class="attach_file_<%=singleClass%>write" id="_convertFileList<%=ctrlUuid%>"style="line-height: 15px;"></ul>
        </td>
    </tr>
</table>
	
<%} %>
<%
}
%>
<script type="text/javascript">
/**
 * 첨부파일 목록
 */
function _attachFileList<%=ctrlUuid%>_AddNode(uuid, fileSaveName, fileName, fileSize, defaultFileUid,file_conv_url) {
    if (uuid == undefined || uuid == null) { uuid = ""; }
    if (defaultFileUid == undefined || defaultFileUid == null) { defaultFileUid = ""; }

    //console.log("uuid is '"+ uuid +"'");
    //console.log("fileSaveName is '"+ fileSaveName +"'");
    //console.log("fileName is '"+ fileName +"'");
    //console.log("fileSize is '"+ fileSize +"'");
    //console.log("defaultFileUid is '"+ defaultFileUid +"'");

    //-- 단일 첨부모드일 경우 새로운 첨부가 생기면 기존 첨부 전체 삭제
    if ("<%=maxFileCount%>" == "1") {
        _attachFileDeleteAll<%=ctrlUuid%>();
    }
    //-- 필수 헤더 텍스트 값이 있으면 파일명 앞에 해당 텍스트 삽입!
    var header_text = "<%=StringUtil.convertForJavascript(requiredHeaderText)%>";
    if (header_text != "" && fileName.substring(0, header_text.length) != header_text) {
        fileName = header_text + fileName;
    }

    var list_obj    = document.getElementById("_attachFileList<%=ctrlUuid%>");
    var node_obj    = document.createElement("li");
    var node_html   =  "<input type='hidden'name='_attachFileUuid<%=ctrlUuid%>' value='"+ uuid +"' />";
    node_html       += "<input type='hidden'<%if(pdfConv)out.print("data-conv='file_savename'");%> name='_attachFileSaveName<%=ctrlUuid%>' value='"+ airCommon.convertForInput(fileSaveName) +"' />";
    node_html       += "<input type='hidden'<%if(pdfConv)out.print("data-conv='file_name'");%> name='_attachFileName<%=ctrlUuid%>' value='"+ airCommon.convertForInput(fileName) +"' />";
    node_html       += "<input type='hidden' name='_attachFileSize<%=ctrlUuid%>' value='"+ fileSize +"' />";
    node_html       += "<input type='hidden' name='_attachFileConvUrl<%=ctrlUuid%>' value='"+ file_conv_url +"' />";
    <%if(!"Y".equals(viewCase)){%>
    node_html       += "<input type='checkbox' name='_attachFileCheck<%=ctrlUuid%>' value='Y' />";
    <%}%>
    <%if("Y".equals(showImage)){%>
    node_html       += "<input type='radio' name='_attachFileRadio<%=ctrlUuid%>' value='"+ airCommon.convertForInput('/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_SRC&type_code=<%=typeCode%>&file_savename='+fileSaveName) +"' onclick='javascript:showImage(this.value)'/>";
    <%}%>
    if (uuid == "" && defaultFileUid == "") {
        node_html       += "&nbsp;"+ fileName;
    } else {
        var download_uid = (uuid != "" ? uuid : defaultFileUid);
        node_html       += "&nbsp;<a href=\"javascript:airCommon.popupAttachFileDownload('"+ download_uid +"')\">"+ fileName +"</a>";
    }

    node_obj.innerHTML = node_html;
    list_obj.appendChild(node_obj);

    var callback_func = unescape("<%=fileAddCallbackFunction%>");
    if (callback_func != "") {
        //-- 콜백 함수의 파라메타 태그->값 치환!
        var func = callback_func;
        func = func.replace(/\[UUID\]/g, uuid);
        func = func.replace(/\[FILE_SAVENAME\]/g, fileSaveName);
        func = func.replace(/\[FILE_NAME\]/g, fileName);
        func = func.replace(/\[FILE_SIZE\]/g, fileSize);
        func = func.replace(/\[FILE_SRC\]/g, "/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_SRC&type_code=<%=typeCode%>&file_savename="+ fileSaveName);

        //-- 콜백 함수 호출!
        eval(func);
    }
}

/**
 * 첨부파일 추가 버튼 클릭
 */
function _attachFileAddButton<%=ctrlUuid%>_Click() {
    airCommon.popupAttachJQueryFileUpload("_attachFileList<%=ctrlUuid%>_AddNode(\'\', \'[FILE_SAVENAME]\', \'[FILE_NAME]\', \'[FILE_SIZE]\', '', \'[FILE_CONV_URL]\')", "<%=StringUtil.convertForJavascript(masterDocId)%>", "<%=systemTypeCode%>", "<%=typeCode%>", "<%=maxFileSize%>", "<%=maxFileCount%>", "<%=fileFilter%>", "<%=fileRFilter%>", "<%=randomFileNameYn%>", "<%=overwriteYn%>");
}

/**
 * 첨부파일 삭제 버튼 클릭
 */
function _attachFileDeleteButton<%=ctrlUuid%>_Click() {
    var list_obj        = document.getElementById("_attachFileList<%=ctrlUuid%>");
    var check_obj       = document.getElementsByName("_attachFileCheck<%=ctrlUuid%>");
    var uuid_obj        = document.getElementsByName("_attachFileUuid<%=ctrlUuid%>");
    var name_obj        = document.getElementsByName("_attachFileName<%=ctrlUuid%>");
    var savename_obj    = document.getElementsByName("_attachFileSaveName<%=ctrlUuid%>");
    var size_obj        = document.getElementsByName("_attachFileSize<%=ctrlUuid%>");

    if (!airCommon.isCheckedInput(check_obj)) {
        alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale,StringUtil.getScriptMessage("L.삭제할파일",siteLocale))%>");
        return;
    }

    if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT", siteLocale, StringUtil.getScriptMessage("M.선택하신파일을목록에서삭제", siteLocale))%>")) {
        for (var i = check_obj.length-1; i >= 0; i--) {

            if (check_obj[i].checked) {
                var callback_func = unescape("<%=fileDeleteCallbackFunction%>");
                if (callback_func != "") {
                    //-- 콜백 함수의 파라메타 태그->값 치환!
                    var func = callback_func;
                    func = func.replace(/\[UUID\]/g, uuid_obj[i]);
                    func = func.replace(/\[FILE_SAVENAME\]/g, savename_obj[i]);
                    func = func.replace(/\[FILE_NAME\]/g, name_obj[i]);
                    func = func.replace(/\[FILE_SIZE\]/g, size_obj[i]);

                    //-- 콜백 함수 호출!
                    eval(func);
                }
                //$(check_obj[i]).parent().remove();
                list_obj.removeChild(list_obj.childNodes[i]);
            }
        }
    }
}

/**
 * 전체 노드 삭제
 */
function _attachFileDeleteAll<%=ctrlUuid%>() {
    var list_obj    = document.getElementById("_attachFileList<%=ctrlUuid%>");
    if (list_obj.childNodes.length > 0) {
        for (var i = list_obj.childNodes.length-1; i >= 0; i--) {
            list_obj.removeChild(list_obj.childNodes[i]);
        }
    }
}

/**
 * 기존 첨부 전체 출력
 */
function _attachFilePrintAll<%=ctrlUuid%>() {
<%
if(!"Y".equals(attachAfterAddMode)){
    //-- 등록된 첨부가 있으면 보여줌
    if (viewResult != null && viewResult.getRowCount() > 0) {
        for (int i = 0; i < viewResult.getRowCount(); i++) {
            out.println("_attachFileList"+ ctrlUuid + "_AddNode('"+ viewResult.getString(i, "uuid") +"', '"+ StringUtil.convertForJavascript(viewResult.getString(i, "file_savename")) +"', '"+ StringUtil.convertForJavascript(viewResult.getString(i, "file_name")) +"', '"+ viewResult.getString(i, "file_size") +"');");
        }
    }
    else
    //-- 디폴트 첨부가 있으면 보여줌
    if (defaultViewResult != null && defaultViewResult.getRowCount() > 0) {
        for (int i = 0; i < defaultViewResult.getRowCount(); i++) {
            out.println("_attachFileList"+ ctrlUuid + "_AddNode('', '"+ StringUtil.convertForJavascript(defaultViewResult.getString(i, "file_savename")) +"', '"+ StringUtil.convertForJavascript(defaultViewResult.getString(i, "file_name")) +"', '"+ defaultViewResult.getString(i, "file_size") +"', '"+ defaultViewResult.getString(i, "uuid") +"');");
        }
    }

}
%>
}

var createFormElementsForSubmitByIE<%=ctrlUuid%> = function() {
    createInputTypeOfHiddenElementsForIE<%=ctrlUuid%>("_attachFileUuid<%=ctrlUuid%>");
    createInputTypeOfHiddenElementsForIE<%=ctrlUuid%>("_attachFileSaveName<%=ctrlUuid%>");
    createInputTypeOfHiddenElementsForIE<%=ctrlUuid%>("_attachFileName<%=ctrlUuid%>");
    createInputTypeOfHiddenElementsForIE<%=ctrlUuid%>("_attachFileSize<%=ctrlUuid%>");
}

var createInputTypeOfHiddenElementsForIE<%=ctrlUuid%> = function(name) {

    var elementsVal = [];
    var frm = document.form1;

    var objElement = document.getElementsByName(name);
    for(var i=0; i< objElement.length; i++){
        elementsVal.push(objElement[i].value);
    }
    $(objElement).remove();

    for(var i=0; i< elementsVal.length; i++ ){
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = name;
        input.value = elementsVal[i];

        document.getElementById("file_Element_<%=ctrlUuid%>").appendChild(input);
    }
}

// 기존 첨부 전체 출력 실행

/*
 *
 * !!NOTICE!!
 *  2014.08.06 강세원
 * _attachFilePrintAll 함수 앞에 무조건 3칸 스페이스바가 있어야 함.
 * ips_gr_001_write.jsp Line No:125 에서 _attachFilePrintAll와 연계된 스크립트가 사용됨.
 */

    _attachFilePrintAll<%=ctrlUuid%>();
</script>