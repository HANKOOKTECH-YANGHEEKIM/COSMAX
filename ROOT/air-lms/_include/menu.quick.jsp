<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
%>
<%	
// 퀵메뉴 기능 사용 && 법무팀 사용자일 경우에만 보여줌
if("Y".equals(CommonProperties.load("fnc.quickMenu")) && (LmsUtil.isBeobmuOfiUser(loginUser) || LmsUtil.isSysAdminUser(loginUser))) {
%>
<jsp:include page="/air-lms/_include/menu_quick.jsp" flush='true' />
<%-- <jsp:include page="/ServletController" flush="false" >
	<jsp:param value="LMS_MENU" name="AIR_ACTION" />
	<jsp:param value="QUICK" name="AIR_MODE" />
</jsp:include> --%>
<%
}
%>	