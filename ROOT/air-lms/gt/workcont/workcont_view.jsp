<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>

<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	String parent_work_cont_uid	= requestMap.getString("PARENT_WORK_CONT_UID");

	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String			gbn	=	requestMap.getString("GBN");
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		WORK_MAS = resultMap.getResult("WORK_MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(WORK_MAS != null && WORK_MAS.getRowCount()> 0){
		masMap.putAll(WORK_MAS.getRowResult(0));
	}
	
	String work_cont_uid	= masMap.getString("WORK_CONT_UID");
	
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0)lmsMap.putAll(LMS_MAS.getRowResult(0));
	boolean isAuths = false;
	if(loginUser.getLoginId().equals(lmsMap.getString("YOCHEONG_ID")) ||
			loginUser.getLoginId().equals(lmsMap.getString("DAMDANG_ID")) ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
	
	if("SS".equals(gbn) && loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	
	}else if(loginUser.isUserAuth("LMS_BCD")){
		isAuths = true;
		
	}
	
%>
<table class="basic">
	<caption id="ip_nm">
		<%=StringUtil.getLocaleWord("L.업무연락", siteLocale)%> :<%=masMap.getStringView("WORK_NO") %>
	</caption>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.작성자", siteLocale)%></th>
		<td class="td4"><%=masMap.getStringView("WORK_WRITE_NM") %> / <%=masMap.getStringView("WORK_WRITE_GROUP_NM") %></td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.작성일", siteLocale)%></th>
		<td class="td4"><%=masMap.getStringView("WORK_WRITE_DTE") %></td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
		<td class="td2" colspan="3"><%=masMap.getStringView("WORK_TITLE")%></td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.수신자", siteLocale) %></th>
		<td class="td2" colspan="3"><%=masMap.getStringView("SUSINJA_NMS")%></td>
	</tr>
	<tr>
		<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
		<td colspan="3">
			<div style="min-height: 100px;">
				<%=masMap.getString("WORK_CONTENT") %>
			</div>
		</td>
	</tr>
	<tr>
		<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
		<td colspan="3">
			<jsp:include page="/ServletController">
                   <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                   <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                   <jsp:param value="<%=work_cont_uid%>" name="masterDocId" />
                   <jsp:param value="CMM" name="systemTypeCode" />
                   <jsp:param value="CMM/CMM" name="typeCode" />
               </jsp:include>
		</td>
	</tr>
</table>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
<%--     	<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="goReadChk()"><%=StringUtil.getLocaleWord("L.CONFORM",siteLocale)%></a></span> --%>
<%if(masMap.getString("SUSINJA_IDS").indexOf(loginUser.getLoginId()) > -1){ %>
<script>
var goReplay = function(){
	
	var url = "/ServletController?AIR_ACTION=<%=actionCode%>";
	url += "&AIR_MODE=POPUP_WRITE_FORM";
	url += "&parent_work_cont_uid=<%=masMap.getString("WORK_CONT_UID")%>";
	url += "&sol_mas_uid=<%=masMap.getString("SOL_MAS_UID")%>";
	
	airCommon.openWindow(url, "1024", "650", "POPUP_REPLAY_FORM", "yes", "yes", "");
	
}
</script>
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="goReplay()"><%=StringUtil.getLocaleWord("L.답글",siteLocale)%></a></span>
<%}%>
		<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="self.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	