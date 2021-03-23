<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%@ page import="java.util.Map"%>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale				= loginUser.getSiteLocale();
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	SQLResults viewResult 		= resultMap.getResult("gyOldInfo");
	
	String sSEQ = viewResult.getString(0, "ATTRIBUTE6");

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String sSeq = requestMap.getString("SEQ");
%>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
<!-- Code Start -->
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.요청서",siteLocale) %></caption>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서번호",siteLocale)%></th>
		<td class="td4" colspan="3"><%=viewResult.getString(0, "TAD1_ATTRIBUTE5") %></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
		<td class="td4" colspan="3"><%=viewResult.getString(0, "TAD1_ATTRIBUTE6") %></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4"><%=viewResult.getString(0, "TAD1_ATTRIBUTE28") %></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.요청자",siteLocale)%></th>
		<td class="td4"><%=viewResult.getString(0, "TAD1_ATTRIBUTE10") %></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.요청내용",siteLocale) %> </th>
		<td class="td4" colspan="3" style="height:100px; vertical-align:top;">
			<%=viewResult.getString(0, "TADV_TAD1_HTML_DATA") %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %> </th>
		<td class="td4" colspan="3" id="AttachRequest<%=viewResult.getString(0, "REQ_DOC_SEQ") %>Body">
		</td>
	</tr>
	</table>
	
	<table class="basic" style="margin-top:30px;">
	<caption><%=StringUtil.getLocaleWord("L.답변서",siteLocale) %></caption>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서번호",siteLocale)%></th>
		<td class="td4"><%=viewResult.getString(0, "TAD2_ATTRIBUTE5") %></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.답변자",siteLocale)%></th>
		<td class="td4"><%=viewResult.getString(0, "TAD2_ATTRIBUTE10") %></td>
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.답변내용",siteLocale) %> </th>
		<td class="td4" colspan="3" style="height:100px; vertical-align:top;">
			<%=viewResult.getString(0, "TADV_TAD2_HTML_DATA") %>
		</td>
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %> </th>
		<td class="td4" colspan="3" id="AttachRequest<%=viewResult.getString(0, "ANSWER_DOC_SEQ") %>Body">
		</td>
	</tr>				
</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>
<script id="AttachRequest<%=sSeq%>Template" type="text/html">
    <tr id="\${GT_DOCUMENT_UID}">
        <td style="text-align:left; cursor:pointer;">{{html fileDown(ATTACH_FILE_ID,FILE_NAME)}}</td>
    </tr>
</script>
<script>
/**
 * 첨부파일 다운로드 팝업
 * @param uuid
 */
popupAttachFileDownload = function (vATTACH_FILE_ID)
{
	var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=FILE_DOWNLOAD";
	url += "&ATTACH_FILE_ID="+ vATTACH_FILE_ID;

	//this.openWindow(url, '50', '50', '', 'no', 'no');
	document.getElementById("airBackgroundProcessFrame").src = url;
};

var fileDown = function(fileVal, fileNm){
	var rtnStr = "";
	var arrNm = fileNm.split("/");
	var arrVal = fileVal.split("/");
	if(fileNm != "" && arrNm.length > 0){
		rtnStr += "<ul class='attach_file_view'>"
		$(arrNm).each(function(k,a){
			rtnStr += "<li>"
			rtnStr += "<a href='javascript:popupAttachFileDownload(\""+arrVal[k]+"\")'>"+arrNm[k]+"</a>";
			rtnStr += "</li>"
		});
		rtnStr += "</ul>"
	}
	
	return rtnStr;
};

var getAttach<%=sSeq%> = function(vAPPV_DOC_SEQ){
	var data = airCommon.getSearchQueryParams(document.documentForm<%=sSeq%>);
	
	data["APPV_DOC_SEQ"] = vAPPV_DOC_SEQ;
	
	airCommon.callAjax("<%=actionCode%>", "JSON_ATTACH_LIST",data, function(json){
		setAttach<%=sSeq%>(vAPPV_DOC_SEQ, json);
	});
};

var setAttach<%=sSeq%> =  function(vAPPV_DOC_SEQ, data){
	$("#AttachRequest"+vAPPV_DOC_SEQ+"Body tr").remove(); // 기존 데이터 삭제
	
	var arrData = data.rows;
   	
   	var tgTbl = $("#AttachRequest"+vAPPV_DOC_SEQ+"Body"); //jquery-tmpl

	$("#AttachRequest<%=sSeq%>Template").tmpl(arrData).appendTo(tgTbl);
};

$(function(){
	getAttach<%=sSeq%>("<%=viewResult.getString(0, "REQ_DOC_SEQ") %>");
	getAttach<%=sSeq%>("<%=viewResult.getString(0, "ANSWER_DOC_SEQ") %>");	
});
</script>
