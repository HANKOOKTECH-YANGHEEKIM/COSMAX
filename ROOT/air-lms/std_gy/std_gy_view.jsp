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
<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
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
String parent_uuid	= "";
String board_code	= "";
String upper_board_code = "";
String code_id	 		= "";

if(viewResult != null && viewResult.getRowCount() > 0){
	uuid			= viewResult.getString(0, "uuid");
	parent_uuid		= viewResult.getString(0, "parent_uuid");
}

String GY_YUHYEONG_LIST_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("GY_YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
String HOESA_LIST_STR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));


//권한세팅
boolean isAdmin	 		= loginUser.isCmmAdmin(); // SysServletModel.isServletAdmin(sqlExe, actionCode, "LIST", loginUser.getAdminAuthCodes());
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
 * 목록 페이지로 이동
 */	
function goList(frm) {		
	frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();		
}

/**
 * 수정
 */	
function goUpdate(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "POPUP_WRITE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();	
}


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
 * 개정
 */	
function goUpdateVer(frm) { 
	frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_VER_FORM"; 
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();	
}


/**
 * 개정 - 삭제
 */	
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
	
	
	<%-- frm.<%=CommonConstants.MODE_CODE%>.value = "VIEW";
	frm.uuid.value = uuid;
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit(); --%>

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

	var getLmsStdList = function(pageNo){
		if(pageNo == undefined) pageNo =1;
		var data = airCommon.getSearchQueryParams(document.stdHisForm);
		data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
		data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
		
		airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
			airCommon.createTableRow("TB_STD_HIS", json, pageNo, 10, "getLmsStdList");
		});
	};
	
	var goStdDel = function(uuid){
		var data = {};
		data["uuid"] = uuid;
		if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale,"L.삭제")%>")){
			airCommon.callAjax("<%=actionCode%>", "DELETE_HIS_PROC",data, function(json){
				alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
				getLmsStdList(1);
			});
		}
	};
	$(function(){
		getLmsStdList(1);
	});
</script>
		<form name="form1" method="post">
			<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
			<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
			<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
			<input type="hidden" name="uuid" value="<%=uuid%>" />
			<input type="hidden" name="parent_uuid" value="<%=parent_uuid%>" />
			<table class="basic">
				<caption><%=StringUtil.getLocaleWord("L.표준계약서", siteLocale) %></caption>
				<tr>
					<th class="th2"><%=StringUtil.getLocaleWord("L.계약서명",siteLocale) %></th>
					<td class="td2" colspan="3"><%=StringUtil.convertForView(viewResult.getString(0, "title"))%></td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale) %></th>
					<td class="td4"><%=viewResult.getString(0, "hoesa_nam")%></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.유형",siteLocale) %></th>
					<td class="td4"><%=viewResult.getString(0, "type_nm")%></td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.등록일",siteLocale) %></th>
					<td class="td4"><%=viewResult.getString(0, "reg_date")%></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.등록자",siteLocale) %></th>
					<td class="td4"><%=viewResult.getString(0, "reg_name_ko")%></td>
				</tr>
				<tr>
				    <th class="th2"><%=StringUtil.getLocaleWord("L.해설",siteLocale) %></th>
					<td class="td2" colspan="3" style="height:100px; vertical-align:top;">
					<%=StringUtil.convertForView(viewResult.getString(0, "content"))%>
					</td>
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
				<div class="left">
				</div>
				<div class="right">
<% if(isShowButtonMng) { %>
					<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goUpdate(document.form1);"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span> 
					<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:goUpdateVer(document.form1);"><%=StringUtil.getLocaleWord("B.개정",siteLocale)%></a></span> 
					<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:doDeleteVer(document.form1);"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span> 
<% } %>
				</div>
			</div>  
		</form>
		
		<%
		if(!"HISTORY_VIEW".equals(modeCode) && LmsUtil.isBeobmuTeamUser(loginUser)){
		%>
		
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.개정이력", siteLocale)%>" style="padding-top:5px" data-options="selected:true">
		<form name="stdHisForm" style="margin:0; padding:0;">
			<input type="hidden" name="uuid__neq" data-type="search" value="<%=uuid%>" />
			<input type="hidden" name="parent_uuid__eq" data-type="search" value="<%=parent_uuid%>" />
			<input type="hidden" name="del_yn__neq" data-type="search" value="Y" />
			<input type="hidden" name="singyu_yn__eq" data-type="search" value="N" />
		</form>
		<table class="list" id="TB_STD_HIS" style="width:990px;">
		<caption>
			<span class="left" style="color:darkred;">※ 본 탭은 법무팀만 볼 수 있습니다.</span>
		</caption>
		<thead>
		<tr>
			<th style="width:28%" data-opt='{"align":"left","col":"TITLE"}'><%=StringUtil.getLocaleWord("L.계약서명", siteLocale) %></th>
			<th style="width:10%" data-opt='{"align":"center","col":"REG_DATE"}'><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<th style="width:8%" data-opt='{"align":"center","col":"REG_NAME_KO"}'><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<th style="width:18%" data-opt='{"align":"center","col":"HOESA_NAM"}'><%=StringUtil.getLocaleWord("L.회사", siteLocale) %></th>
			<th style="width:*" data-opt='{"align":"left"
			,"html":{"type":"fileDown"
					,"name":"FILE_NAME"
					,"value":"FILE_UID"
					}
			}'><%=StringUtil.getLocaleWord("L.계약서", siteLocale) %></th>
			<th style="width:10px" data-opt='{"align":"center","html":{"type":"BTN","class":"delete","callback":"goStdDel(\"@{UUID}\")","title":"<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>"}}'></th>
		</tr>
		</thead>
		<tbody id="TB_STD_HISBody"></tbody>
	
	</table>
	<%-- 페이지 목록 --%>
	<div class="pagelist" id="TB_STD_HISPage"></div> 
	</div>
</div>
<%
		}
%>
<div class="buttonlist">
	<div class="left">
	</div>
	<div class="right">
<% if ( "VIEW".equals(modeCode) ) { //일반 뷰일 경우에만 각종 버튼을 보여줌 %>	
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
<% } else if ( "POPUP_VIEW".equals(modeCode) || "HISTORY_VIEW".equals(modeCode) ) { //팝업 뷰일 경우 닫기 버튼을 보여줌 %>
		<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:self.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
<% } %>
	</div>
</div>