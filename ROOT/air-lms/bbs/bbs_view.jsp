<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.util.DateUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
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
	
	String board_type	=	"";
	String parent_uuid	=	"";
	String parent_board_cd	=	"";
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults bbsMas = resultMap.getResult("BBS_MAS");
	SQLResults BOARD_MAS = resultMap.getResult("BOARD_MAS");
	
	if(BOARD_MAS != null && BOARD_MAS.getRowCount()> 0){
		board_type = BOARD_MAS.getString(0, "PARENT_CODE_ID");
		parent_uuid = BOARD_MAS.getString(0, "PARENT_UUID");
		parent_board_cd = board_type;
	}
	
	BeanResultMap masMap = new BeanResultMap();
	if(bbsMas != null && bbsMas.getRowCount()> 0){
		masMap.putAll(bbsMas.getRowResult(0));
	}
	
	String uuid	= masMap.getString("UUID");
	
	String board_cd =	masMap.getString("BOARD_CD");
	String board_nm = 	masMap.getString("BOARD_NM");
	
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String bbsTypeStr = StringUtil.getCodestrFromSQLResults(requestMap.getResult("LMS_BBS_TYPE"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	
	boolean isWriter = false;
	
	if(loginUser.getLoginId().equals(masMap.getString("REG_ID"))){
		isWriter = true;
	}
	
	//-- 게시판 관리자는 모든 권한이 있음
	if(loginUser.isCmmBbs()){
		isWriter = true;
	}
%>
	<table class="basic">
		<caption><%=board_nm %></caption>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<td class="td4"><%=masMap.getString("REG_DTE")%></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<td class="td4"><%=masMap.getString("REG_NM")%></td>
		</tr>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td2" colspan="3">
				<%=masMap.getStringView("TITLE")%>
			</td>
		</tr>
<%if(requestMap.getResult("LMS_BBS_TYPE") != null && requestMap.getResult("LMS_BBS_TYPE").getRowCount() > 0){ %>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.유형", siteLocale) %></th>
			<td class="td2">
				<%=StringUtil.getCodestrValue(request,masMap.getString("TYPE_CD1"), bbsTypeStr) %>
<%-- 				<%=HtmlUtil.getSelect(request, true, "type_cd1", "type_cd1", bbsTypeStr, masMap.getString("TYPE_CD1"), "class=\"select width_max\"") %> --%>
<%-- 				<input type="hidden" name="type_nm1" id="type_nm1" value="<%=masMap.getString("TYPE_NM1")%>"/> --%>
			</td>
		</tr>
<%} %>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td class="td2" colspan="3" style="height:320px; vertical-align:top;">
				<%=masMap.getStringView("CONTENT")%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=uuid%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="LMS/BBS" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
                </jsp:include>
			</td>
		</tr>
	</table>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
<%if(isWriter){ %>
<script>
var doUpdate = function(){
	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='BOARD_TYPE'>").val("<%=board_type%>"));
	imsiForm.append($("<input type='hidden' name='BOARD_CD'>").val("<%=board_cd%>"));
	imsiForm.append($("<input type='hidden' name='BAORD_NM'>").val("<%=board_nm%>"));
	imsiForm.append($("<input type='hidden' name='UUID'>").val("<%=uuid%>"));	
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
};

var doDelete = function(){
	var data = {};
	data["uuid"] = "<%=uuid%>";
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>")){
		airCommon.callAjax("<%=actionCode%>", "DELETE_PROC", data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			opener.doSearch();
			window.close();
		});
	}
};
</script>
		<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:doUpdate()"><%=StringUtil.getLocaleWord("B.MODIFY", siteLocale) %></a></span>
		<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:doDelete()"><%=StringUtil.getLocaleWord("B.DELETE", siteLocale) %></a></span>
<%} %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>