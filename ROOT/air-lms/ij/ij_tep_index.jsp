<%--
  - Author : Yang, Ki Hwa
  - Date : 2014.01.08
  - 
  - @(#)
  - Description : 법무시스템 계약TEP
  --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}
//-- 검색값 셋팅
BeanResultMap searchMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);

String sol_mas_uid = searchMap.getString("SOL_MAS_UID");

//-- 결과값 셋팅
BeanResultMap responseMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
//-- 본 건 권한 체크 로직
SQLResults LMS_MAS		= responseMap.getResult("LMS_MAS");
BeanResultMap masMap  = new BeanResultMap();
if(LMS_MAS == null || LMS_MAS.getRowCount() == 0){
	out.print("<script>");
	out.print("alert('"+StringUtil.getScriptMessage("M.접근권한이_없습니다", siteLocale)+"');");
	out.print("if(opener){");
	out.print("self.close();");
	out.print("}");
	out.print("</script>");
}else{
	masMap.putAll(LMS_MAS.getRowResult(0));
}
%>
<jsp:include page="/ServletController">
	<jsp:param value="SYS_FORM" name="AIR_ACTION" />
	<jsp:param value="FORM_TOTAL_INCLUDE" name="AIR_MODE" />
	<jsp:param value="<%=sol_mas_uid%>" name="sol_mas_uid" />
</jsp:include>

<script>
<%-- 팝업으로 열릴때 세로 스크롤바 때문에 버튼이 짤려 보이는 부분을 방지하기 위한 방어 코드--%>
if(opener){
	<%-- $("#tepIndexLayer").css("padding-right","15px");--%>
	$("body").css("overflow","scroll");
}else if(parent.opener){
}
</script>