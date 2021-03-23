<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title><%=CommonProperties.getSystemTitle(siteLocale)%></title>
<meta charset="UTF-8" />
<jsp:include page='<%=systemDefaultContentUrl + "/_include/header.main.jsp"%>' flush='false' />
</head>
<body>
<div id="wrap">
<jsp:include page='<%=systemDefaultContentUrl + "/_include/menu.top.jsp"%>' flush='false' />
<jsp:include page='<%=CONTENT_PATH%>' flush='false' />
<jsp:include page='<%=systemDefaultContentUrl + "/_include/footer.jsp"%>' flush='false' />
<iframe name="airBackgroundProcessFrame" id="airBackgroundProcessFrame" style="display:none;"></iframe>
<jsp:include page='<%=systemDefaultContentUrl + "/_include/WebSecurity.jsp"%>' flush='false' />
</div>
</body>
</html>