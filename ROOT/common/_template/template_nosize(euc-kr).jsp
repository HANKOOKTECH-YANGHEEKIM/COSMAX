<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}

String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();

String ACTION_CODE 	= request.getParameter(CommonConstants.ACTION_CODE);
String MODE_CODE 	= request.getParameter(CommonConstants.MODE_CODE);

String CONTENT_PATH = (String)request.getAttribute(CommonConstants.CONTENT_PATH);
String CONTENT_NAME = (String)request.getAttribute(CommonConstants.CONTENT_NAME);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<title><%=CommonProperties.getSystemTitle(siteLocale)%></title>	
<meta charset="EUC-KR" />
<jsp:include page='<%=systemDefaultContentUrl + "/_include/header.default.jsp"%>' flush='false' />
</head>
<body style="margin:0;padding:0;text-align:left;">
<!-- // Content // -->	
<jsp:include page='<%=CONTENT_PATH%>' flush='false' />

<!-- // Background Process Frame // -->
<iframe name="airBackgroundProcessFrame" id="airBackgroundProcessFrame" style="display:none;"></iframe>
</body>
</html>