<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String pageNo = requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	String	 sol_mas_uid =  requestMap.getString("SOL_MAS_UID");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
%>
<table class="list" id="TB_CORRESPONDENCE<%=sol_mas_uid%>">
	<caption>
		<span class="left" style="color:darkred;">
		</span>
		<span class="right">
	    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goCorrespondenceWrite<%=sol_mas_uid%>();">통신지 검색</a></span>
		</span>
	</caption>
	<thead>
	<tr>
		<th style="width:auto">제목</th>
		<th style="width:200px">문서번호</th>				
		<th style="width:80px">등록자</th>
		<th style="width:90px">등록일</th>
		<th style="width:65px"></th>
	</tr>
	</thead>
	<tr>
		<td style="text-align:center;">개인명의 업무용폰 신청의 건</td>
		<td style="text-align:center;">준법지원팀-1810-0000</td>				
		<td style="text-align:center;">오법무</td>
		<td style="text-align:center;">2018-10-12</td>
		<td style="text-align:center;">
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goCorrespondenceDel<%=sol_mas_uid%>('\${GT_CORRESPONDENCE_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
		</td>
	</tr>
	<tbody id="LmsGtCorrespondence<%=sol_mas_uid%>Body"></tbody>
</table>
<%-- 페이지 목록 --%>
<div class="pagelist" id="TB_CORRESPONDENCE<%=sol_mas_uid%>Page"></div>
<form name="correForm<%=sol_mas_uid%>" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" data-type="search" value="<%=sol_mas_uid%>"/>
</form>
<script id="LmsGtCorrespondence<%=sol_mas_uid%>Template" type="text/html">
    <tr id="\${GT_CORRESPONDENCE_UID}">
        <td onclick="goCorrespondenceView<%=sol_mas_uid%>('\${ATTRIBUTE3}');" style="text-align:center; cursor:pointer;">\${CORRESPONDENCE_TIT}</td>
        <td onclick="goCorrespondenceView<%=sol_mas_uid%>('\${ATTRIBUTE3}');" style="text-align:center; cursor:pointer;">\${ATTRIBUTE2}</td>
        <td onclick="goCorrespondenceView<%=sol_mas_uid%>('\${ATTRIBUTE3}');" style="text-align:center; cursor:pointer;">\${REG_EMP_NM}</td>
        <td onclick="goCorrespondenceView<%=sol_mas_uid%>('\${ATTRIBUTE3}');" style="text-align:center; cursor:pointer;">\${REG_DATE}</td>
		<td style="text-align:center;">
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goCorrespondenceDel<%=sol_mas_uid%>('\${GT_CORRESPONDENCE_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
		</td>
    </tr>
</script>
<script>
var fileDown = function(fileVal, fileNm){
	var rtnStr = "";
	var arrNm = fileNm.split("/");
	var arrVal = fileVal.split("/");
	if(fileNm != "" && arrNm.length > 0){
		rtnStr += "<ul class='attach_file_view'>"
		$(arrNm).each(function(k,a){
			rtnStr += "<li>"
			rtnStr += "<a href='javascript:airCommon.popupAttachFileDownload(\""+arrVal[k]+"\")'>"+arrNm[k]+"</a>";
			rtnStr += "</li>"
		});
		rtnStr += "</ul>"
	}
	
	return rtnStr;
};

var goCorrespondenceWrite<%=sol_mas_uid%> = function(){
	//var imsiForm = $("<form method='POST'>").attr("action","http://madang.lguplus.co.kr/search/search_approvalDoc.jsp")
	var imsiForm = $("<form method='POST'>").attr("action","http://madangdev.lguplus.co.kr/search/search_approvalDoc.jsp")
	imsiForm.append($("<input type='hidden' name='SOL_MAS_UID'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='sysid'>").val("LEGALSYS"));
	airCommon.openWindow("", "780", "600", "POPUP_WRITE_FORM<%=sol_mas_uid%>", "yes", "yes", "");	
	imsiForm.attr("target","POPUP_WRITE_FORM<%=sol_mas_uid%>");
	imsiForm.appendTo("body");
	imsiForm.submit();
	imsiForm.remove();
};

var goCorrespondenceView<%=sol_mas_uid%> = function(vGt_document_uid){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_document_uid'>").val(vGt_document_uid));
	airCommon.openWindow("", "1024", "650", "POP_VIEW_"+vGt_document_uid, "yes", "yes", "");	
	imsiForm.attr("target","POP_VIEW_"+vGt_document_uid);
	imsiForm.appendTo("body");
	//imsiForm.submit();
	//imsiForm.remove();
};

var goCorrespondenceDel<%=sol_mas_uid%> = function(uuid){
	var data = {};
	data["gt_document_uid"] = uuid;
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			getGtCorrespondence<%=sol_mas_uid%>(1);
		});
	}
};

var getGtCorrespondence<%=sol_mas_uid%> = function(pageNo){
	if(pageNo == undefined) pageNo =1;
	var data = airCommon.getSearchQueryParams(document.correForm<%=sol_mas_uid%>);
	data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
	data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
	
	airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		//airCommon.createTableRow("TB_CORRESPONDENCE<%=sol_mas_uid%>", json, pageNo, 10, "getGtCorrespondence<%=sol_mas_uid%>");
		setLmsCorrespondence<%=sol_mas_uid%>(json);
	});
};

var setLmsCorrespondence<%=sol_mas_uid%> =  function(data){
	$("#LmsGtCorrespondence<%=sol_mas_uid%>Body tr").remove(); // 기존 데이터 삭제
	
	var arrData = data.rows;
   	
   	var tgTbl = $("#LmsGtCorrespondence<%=sol_mas_uid%>Body"); //jquery-tmpl

	$("#LmsGtCorrespondence<%=sol_mas_uid%>Template").tmpl(arrData).appendTo(tgTbl);
};

$(function(){
	getGtCorrespondence<%=sol_mas_uid%>(1);
});
</script>