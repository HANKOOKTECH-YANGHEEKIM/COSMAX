<%--
  - Author : Kang, Se Won
  - Date : 2016.04.19
  - 
  - @(#)
  - Description : 법무시스템 법무DB,게시판  View
  --%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="com.emfrontier.air.common.util.DateUtil"%>
<%@page import="org.json.simple.*"%>
<%@page import="java.lang.reflect.*"%>  
<%@page import="com.emfrontier.air.lms.config.LmsConstants" %>
<%@page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults" %>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@page import="com.emfrontier.air.common.util.StringUtil" %>
<%
SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale			= loginUser.getSiteLocale();

//-- 검색값 셋팅
BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);


//-- 파라메터 셋팅
String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);

SQLResults viewResult 	= resultMap.getResult("VIEW"); 

String menuTitle = "";

String uuid			= "";
String board_code	= "";
String upper_board_code = "";
String code_id	 		= "";

if(viewResult != null && viewResult.getRowCount() > 0){
	uuid			= viewResult.getString(0, "uuid");
}

//권한세팅
boolean isAdmin	 		= LmsUtil.isSysAdminUser(loginUser); // SysServletModel.isServletAdmin(sqlExe, actionCode, "LIST", loginUser.getAdminAuthCodes());
boolean isBeobmuTeam	= LmsUtil.isBeobmuTeamUser(loginUser);
boolean isWriter		= (viewResult.getString(0, "REG_LOGIN_ID").equals(loginUser.getUUID()) ? true : false);

boolean isWritable = false;
	
/**
* 관리버튼 보이기 유무
*/
boolean isShowButtonMng	= (isAdmin || isWriter || isBeobmuTeam ? true : false);

isShowButtonMng = (isAdmin || isWritable || isWriter || isBeobmuTeam ? true : false);

%>
<script type="text/javascript">
/**
 * 개정 - 수정
 */	
function goPopupUpdateVer(frm) {
	var UUID = frm.uuid.value;
	var BOARD_CODE = frm.board_code.value;
	
	var url = "/ServletController";
	url += "?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&uuid="+UUID;
	
	airCommon.openWindow(url, "1024", "800", "POPUP_WRITE_FORM", "yes", "yes", "");		
}

/**
 * 상세보기 페이지로 이동
 */
function goView(frm, uuid, board_code) {
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_BOARD";
	url += "&AIR_MODE=HISTORY_VIEW";
	url += "&uuid="+uuid;
	url += "&board_code="+board_code;
	
	airCommon.openWindow(url, "1024", "360", "HISTORY_VIEW", "yes", "yes", "");		
}

/**
 * 페이지 이동
 */	 
	function goPage(frm, pageNo, rowSize) {		
		frm.<%=CommonConstants.MODE_CODE%>.value = "VIEW";
		frm.<%=CommonConstants.PAGE_NO%>.value = pageNo;
		frm.<%=CommonConstants.PAGE_ROWSIZE%>.value = rowSize;
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}
</script>
<form name="form1" method="post">
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
<input type="hidden" name="uuid" value="<%=uuid%>" />
<input type="hidden" name="PARENT_UUID" value="<%=uuid%>" />
			<table class="basic">
				<caption>자주하는 질문</caption>
				<tr>
					<th class="th2"><%=StringUtil.getLocaleWord("L.질문",siteLocale) %></th>
					<td class="td2" colspan="3"><%=StringUtil.convertForView(viewResult.getString(0, "title"))%></td>
				</tr>
				<tr>
					<th class="th2"><%=StringUtil.getLocaleWord("L.유형",siteLocale) %></th>
					<td class="td2" colspan="3"><%=viewResult.getString(0, "type_nm")%></td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.등록일",siteLocale) %></th>
					<td class="td4"><%=viewResult.getString(0, "reg_date")%></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.등록자",siteLocale) %></th>
					<td class="td4"><%=viewResult.getString(0, "reg_name_ko")%></td>
				</tr>
				<tr style="height:400px">
				    <th class="th2"><%=StringUtil.getLocaleWord("L.답변",siteLocale) %></th>
					<td class="td2" colspan="3" style="vertical-align:top;"><%=StringUtil.convertForView(viewResult.getString(0, "content"))%></td>
				</tr>		
				<tr>
					<th class="th2"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %></th>
					<td class="td2" colspan="3">
						<jsp:include page="/ServletController">
							<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
							<jsp:param value="FILE_VIEW" name="AIR_MODE" />
							<jsp:param value="<%=uuid%>" name="masterDocId" />
							<jsp:param value="LMS" name="systemTypeCode" />
							<jsp:param value='LMS/GY/STD' name="typeCode" />
						</jsp:include>
					</td>
				</tr>
			</table>
			
		<%-- 버튼 목록 --%>
			<div class="buttonlist">
				<div class="right">
		<% if ( "VIEW".equals(modeCode) ) { //일반 뷰일 경우에만 각종 버튼을 보여줌 %>	
<script>
function goUpdate(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "POPUP_WRITE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();	
}

function doDelete(frm) {		
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.삭제", siteLocale))%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "DELETE";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();			
	}
}

function goList(frm) {		
	frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();		
}
</script>
					<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goUpdate(document.form1);"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span> 
					<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:doDelete(document.form1);"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
					<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
		<% } else if ( "POPUP_VIEW".equals(modeCode) || "HISTORY_VIEW".equals(modeCode) ) { //팝업 뷰일 경우 닫기 버튼을 보여줌 %>
				<% if(isShowButtonMng) { %>  
<script>
function goUpdate(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "POPUP_WRITE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();	
}

function doDeleteVer(frm) {		
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getScriptMessage("L.삭제", siteLocale))%>")) {
		var data = $(frm).serialize();
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>");
			try {
				opener.doSearch(opener.document.form1);
			} catch(exception) {
			}
			window.close();
		});
	}
}
</script>
					<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goUpdate(document.form1);"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span> 
					<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:doDeleteVer(document.form1);"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span> 
				<% } %>
					<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:self.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
		<% } %>		
				</div>
			</div>  
</form>