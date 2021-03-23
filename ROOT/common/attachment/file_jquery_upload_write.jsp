
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<!-- 
@최초작성일 2018.08.16
@최초작성작 : 김재순
@설명 : html5를 이용한 jquery file upload 모듈
 -->
<%
     //-- 로그인 사용자 정보 셋팅
     SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
     String siteLocale           = loginUser.getSiteLocale();

     //-- 검색값 셋팅
     BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
     String callbackFunction     = requestMap.getString("CALLBACKFUNCTION");
     String masterDocId          = requestMap.getString("MASTERDOCID");
     String systemTypeCode       = requestMap.getString("SYSTEMTYPECODE");
     String typeCode             = requestMap.getString("TYPECODE");
     String maxFileSize          = requestMap.getString("MAXFILESIZE");
     String maxFileCount         = requestMap.getString("MAXFILECOUNT");
//   String fileFilter           = requestMap.getString("fileFilter");    //첨부 가능한 파일 필터
     String fileFilter           = StringUtil.convertNullDefault(requestMap.getString("FILEFILTER"), CommonProperties.load("attachment.defaultAllowFileExt")); //첨부 가능한 파일 필터
  	 String fileRFilter          = StringUtil.convertNullDefault(requestMap.getString("FILERFILTER"), CommonProperties.load("attachment.defaultDenyFileExt")); //첨부 불가한 파일 필터
     String randomFileNameYn     = requestMap.getString("RANDOMFILENAMEYN");  //랜덤 파일명 사용여부 (기본값:Y)
     String overwriteYn          = requestMap.getString("OVERWRITEYN");       //중복파일 존재시 덮어쓰기 여부 (기본값:N)
     String pdfConvYn            = requestMap.getString("PDFCONVYN");       //LGU 전용 PDF 변환 여부
     String sol_mas_uid          = requestMap.getString("SOL_MAS_UID");       //LGU 전용 PDF 변환 여부

     //-- 결과값 셋팅
     BeanResultMap responseMap     = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

     //-- 파라메터 셋팅
     String actionCode           = responseMap.getString(CommonConstants.ACTION_CODE);
     String modeCode             = responseMap.getString(CommonConstants.MODE_CODE);
%>
<link rel="stylesheet" type="text/css" href="/common/_lib/jqueryFileUpload/css/jquery.fileupload-ui.css" />
<link rel="stylesheet" type="text/css" href="/common/_lib/jqueryFileUpload/css/jquery.fileupload.css" />
<link rel="stylesheet" type="text/css" href="/common/_lib/jqueryFileUpload/css/jquery-ui.css" />
<style type="text/css">
	button.button_fileupload { padding: 6px 12px; }
	table.table_fileupload_list { margin-top:10px; width:100%; border-spacing:0px;}
	table.table_fileupload_list tr td { border-bottom:2px solid #FFFFFF; background-color:#EFEFEF;}
</style>
<div class="container" style="text-align:center;">
<!-- The file upload form used as target for the file upload widget -->
<form id="fileupload" action="" method="POST" enctype="multipart/form-data" style="margin:0; padding:0;">
    <input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
    <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
    <input type="hidden" name="callbackFunction" value="<%=StringUtil.convertForInput(callbackFunction)%>" />
    <input type="hidden" name="masterDocId" value="<%=StringUtil.convertForInput(masterDocId)%>" />
    <input type="hidden" name="systemTypeCode" value="<%=StringUtil.convertForInput(systemTypeCode)%>" />
    <input type="hidden" name="typeCode" value="<%=StringUtil.convertForInput(typeCode)%>" />
    <input type="hidden" name="pdfConvYn" value="<%=StringUtil.convertForInput(pdfConvYn)%>" />
    <input type="hidden" name="sol_mas_uid" value="<%=StringUtil.convertForInput(sol_mas_uid)%>" />
    
    <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->
    <div class="fileupload-buttonbar">
		<div class="fileupload-buttons">
            <!-- The fileinput-button span is used to style the file input field as button -->
            <span class="fileinput-button ui-button ui-corner-all ui-widget" role="button">
                <span><%=StringUtil.getLocaleWord("L.파일추가", siteLocale) %></span>
            	<input type="file" name="files[]" multiple>
            </span>
            
            <button type="submit" class="start button_fileupload"><%=StringUtil.getLocaleWord("L.업로드시작", siteLocale) %></button>
<%-- 
            <button type="reset" class="cancel button_fileupload">Cancel upload</button>
--%>            
<%-- 
            <button type="button" class="delete">Delete</button>
            <input type="checkbox" class="toggle">
--%>
            <!-- The global file processing state -->
            <span class="fileupload-process"></span>
        </div>
        <!-- The global progress state -->
        <div class="fileupload-progress fade" style="display:none">
            <!-- The global progress bar -->
            <div class="progress" role="progressbar" aria-valuemin="0" aria-valuemax="100"></div>
            <!-- The extended global progress state -->
            <div class="progress-extended">&nbsp;</div>
        </div>
    </div>
    <!-- The table listing the files available for upload/download -->
    <table role="presentation" class="table_fileupload_list">
       	<colgroup>
    		<col style="width:auto;" />
    		<col style="width:150px;" />
    		<col style="width:115px;" />
    	</colgroup>
    	<tbody class="files" style="border:0;">
    	<tr id="notice">
    	<td style="height:340px; font-size:14px;">
    	<%=StringUtil.getLocaleWord("M.파일업로드안내", siteLocale) %>
<!-- "파일 추가"버튼을 클릭하여 파일을 불러올 수 있습니다.<br /> -->
<!-- (파일 추가시 URL 보내기는 불가하고, 원문 보내기만 가능합니다) <br /> -->
<!-- "업로드 시작"버튼을 클릭하여 불러온 파일을 업로드 해주세요<br /> -->
    	</td>
    	</tr>
    	</tbody>
    </table>
</form>
<%--
<button type="button" id="CloseButton">닫기</button>
 --%>
</div>
<!-- The template to display files available for upload -->
<script id="template-upload" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-upload fade">
        <td style="text-align:left; padding-left:20px;">
            {%=file.name%}
            <strong class="error" style="color:red"></strong>
        </td>
        <td>
            <p class="size">Processing...</p>
        </td>
        <td>
            {% if (!i && !o.options.autoUpload) { %}
                <button class="start" disabled style="visibility:hidden; margin:0; padding:0; width:0; height:0;">Start</button>
            {% } %}
            {% if (!i) { %}
                <button class="cancel"><%=StringUtil.getLocaleWord("L.삭제", siteLocale) %></button>
            {% } %}
        </td>
    </tr>
{% } %}
</script>
<!-- The template to display files available for download -->
<script id="template-download" type="text/x-tmpl">
{% for (var i=0, file; file=o.files[i]; i++) { %}
    <tr class="template-download fade">
        <td>
            <p class="name">
				<!--
                <a href="{%=file.url%}" title="{%=file.name%}" download="{%=file.name%}" {%=file.thumbnailUrl?'data-gallery':''%}>{%=file.name%}</a>
				-->
				{%=file.name%}
            </p>
            {% if (file.error) { %}
                <div><span class="error"  style="color:red">Error</span> {%=file.error%}</div>
            {% } %}
        </td>
        <td>
            <span class="size">{%=o.formatFileSize(file.size)%}</span>
        </td>
        <td>
			<!--
            <button class="delete" data-type="{%=file.deleteType%}" data-url="{%=file.deleteUrl%}"{% if (file.deleteWithCredentials) { %} data-xhr-fields='{"withCredentials":true}'{% } %}>Delete</button>
            <input type="checkbox" name="delete" value="1" class="toggle">
			-->
        </td>
    </tr>
{% } %}
</script>
<script src="/common/_lib/jquery-ui/jquery-ui.js"></script>
<!-- The Templates plugin is included to render the upload/download listings -->
<script src="/common/_lib/jqueryFileUpload/js/tmpl.min.js"></script>
<!-- The Iframe Transport is required for browsers without support for XHR file uploads -->
<script src="/common/_lib/jqueryFileUpload/js/jquery.iframe-transport.js"></script>
<!-- The basic File Upload plugin -->
<script src="/common/_lib/jqueryFileUpload/js/jquery.fileupload.js"></script>
<!-- The File Upload processing plugin -->
<script src="/common/_lib/jqueryFileUpload/js/jquery.fileupload-process.js"></script>
<!-- The File Upload validation plugin -->
<script src="/common/_lib/jqueryFileUpload/js/jquery.fileupload-validate.js"></script>
<!-- The File Upload user interface plugin -->
<script src="/common/_lib/jqueryFileUpload/js/jquery.fileupload-ui.js"></script>
<!-- The File Upload jQuery UI plugin -->
<script src="/common/_lib/jqueryFileUpload/js/jquery.fileupload-jquery-ui.js"></script>
<!-- The XDomainRequest Transport is included for cross-domain file deletion for IE 8 and IE 9 -->
<!--[if (gte IE 8)&(lt IE 10)]>
<script src="js/cors/jquery.xdr-transport.js"></script>
<![endif]-->
<script type="text/javascript">
/* global $, window */
 var vMaxFileSize = <%=maxFileSize%> * 1024;                          // 업로드 제한 용량 (기본값: 10,240 Kb) (단위는 Kb)
 var vMaxFileCount = <%=maxFileCount%>+1;                               // 업로드 파일 제한 갯수 (기본값: 10)

$(function () {
	// 닫기버튼 클릭시
	$("#CloseButton").click(function() {
		//-- 창 닫기
        window.close();
	});
	
    'use strict';
    
  //업로드 소스파일 경로 (반드시 입력해야함)
    var url = "/ServletController?AIR_ACTION=SYS_ATCH&AIR_MODE=FILE_JQUERY_UPLOAD_PROC";
    url += "&systemTypeCode="+ encodeURIComponent("<%=systemTypeCode%>");
    url += "&typeCode="+ encodeURIComponent("<%=typeCode%>");
    url += "&randomFileNameYn=<%=randomFileNameYn%>";
    url += "&overwriteYn=<%=overwriteYn%>";
<%if("Y".equals(pdfConvYn)){%>
    url += "&pdfConvYn=<%=pdfConvYn%>";
    url += "&sol_mas_uid=<%=sol_mas_uid%>";
<%}%>
    // Initialize the jQuery File Upload widget:
    $("#fileupload").attr('action', url);	
    	
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        xhrFields: {withCredentials: true},
        url: url,
        dataType: 'json',
        autoUpload: false,
        //acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,
        //acceptFileTypes: /(\.|\/)(?:(?!asp|php|aspx|jsp|cs|html|htm|xml|js)\w)+/i,
        limitMultiFileUploadSize: vMaxFileSize,
        //maxFileSize: vMaxFileSize,
        minFileSize: 1,
        maxNumberOfFiles : vMaxFileCount
    });
    
    $('#fileupload')
    .bind('fileuploadadd', function (e, data) {

//     	console.log(data.files[0].name);
    	//console.log(data);
    	var arrFiles = [];
    	$.each(data.files, function (index, file) {
    		var validation = true;
    		var fileName        = airCommon.convertForJavascript(file.name);
            var fileSize        = airCommon.convertForJavascript(file.size);
    		
         	// 파일 확장자로 필터  
 	        var docIdx = fileName.toUpperCase().lastIndexOf(".");
 	        var fileExt = '';
         	
 			if(docIdx > -1){
 				fileExt = fileName.substring(docIdx + 1);	        	
 	        }
	        
 			// 파일 확장자 불허용허용 리스트
 	        if(fileRFilter.toUpperCase().indexOf(fileExt.toUpperCase()) > -1) {
 	        	validation = false;
 	        	alert("<%=StringUtil.getScriptMessage("M.ALERT_DENY_FILEEXT", siteLocale) %>");
 	        }
 			if( fileFilter !="" &&fileFilter.toUpperCase().indexOf(fileExt.toUpperCase()) < 0) {
 			// 파일 확장자 허용 리스트
 	        	validation = false;
 	        	alert("<%=StringUtil.getScriptMessage("M.ALERT_DENY_FILEEXT", siteLocale) %>");
 	        }
	        
	        // 파일사이즈 0일 때 오류
	        if(fileSize == 0) {
				validation = false;
	        	alert("<%=StringUtil.getScriptMessage("M.INFO_NOATTACHFILE", siteLocale) %>");
	        } 
	    	if(validation){
	    		arrFiles.push(file);
	    	}
    	});
    	data["files"] = arrFiles;
    	// console.log(data);
    	/* 
    	for(var i = delidx.length; i> -1; i--){
    		$(data.files).eq(i).remove();
    	} */
    	$("#notice").hide();
    })

    var fileFilter = "<%=fileFilter%>";
    var fileRFilter = "<%=fileRFilter%>";
    var callback_func = unescape($('input[name=callbackFunction]').val());

    $('#fileupload').on('fileuploaddone', function(e, data) {
    	
    	$.each(data.result.files, function (index, file) {
    		//console.info('done file: ' + file.name + ':' + file.size + ':' + file.saveName);
    		
    		var fileSavename    = airCommon.convertForJavascript(file.saveName);
            var fileName        = airCommon.convertForJavascript(file.name);
            var fileSize        = airCommon.convertForJavascript(file.size);

//             console.log("file is "+ file.PDF);
            //console.log("fileSavename is "+ fileSavename);
            //console.log("fileName is "+ fileName);
            //console.log("fileSize is "+ fileSize);

          	// 파일 확장자로 필터  
 	        var docIdx = fileName.toUpperCase().lastIndexOf(".");
 	        var fileExt = '';
         	
 			if(docIdx > -1){
 				fileExt = fileName.substring(docIdx + 1);	        	
 	        }
	        
 			// 파일 확장자 허용 리스트
 	        if(fileFilter != "" && fileFilter.indexOf(fileExt) < 0) {
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
			var pdf = [];
            if(file.PDF){
            	pdf = JSON.parse(file.PDF);
	            
            	if(pdf[0].RESULT == "ERROR"){
            		alert(pdf[0].ALARM_MESSAGE);
            	}else{
	            	//-- 콜백 함수의 파라메타 태그->값 치환!
		            var func = callback_func;
		            func = func.replace(/\[FILE_SAVENAME\]/g, fileSavename);
		            func = func.replace(/\[FILE_NAME\]/g, fileName);
		            func = func.replace(/\[FILE_SIZE\]/g, fileSize);
		            func = func.replace(/\[FILE_CONV_URL\]/g, file.PDF);
		            //-- 콜백 함수 호출!
		            eval("opener."+ func);
            	}
			}else{
	            //-- 콜백 함수의 파라메타 태그->값 치환!
	            var func = callback_func;
	            func = func.replace(/\[FILE_SAVENAME\]/g, fileSavename);
	            func = func.replace(/\[FILE_NAME\]/g, fileName);
	            func = func.replace(/\[FILE_SIZE\]/g, fileSize);
	            //-- 콜백 함수 호출!
	            eval("opener."+ func);
			}
        });
    	
        var activeUploads = $('#fileupload').fileupload('active');
        	
        if(activeUploads == 1) {
        	//-- 창 닫기
            window.close();
        }
    });

    // Enable iframe cross-domain access via redirect option:
//     $('#fileupload').fileupload(
//         'option',
//         'redirect',
//         window.location.href.replace(
//             /\/[^\/]*$/,
//             '/cors/result.html?%s'
//         )
//     );

    // Load existing files:
	$('#fileupload').addClass('fileupload-processing');
	$.ajax({
	     // Uncomment the following to send cross-domain cookies:
	     //xhrFields: {withCredentials: true},
	     url: $('#fileupload').fileupload('option', 'url'),
	     dataType: 'json',
	     context: $('#fileupload')[0]
	 }).always(function () {
	     $(this).removeClass('fileupload-processing');
	 }).done(function (result) {
		 $(this).fileupload('option', 'done')
	         .call(this, $.Event('done'), {result: result});
	 });
});
</script>