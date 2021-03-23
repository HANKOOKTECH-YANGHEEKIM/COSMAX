<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.util.FileUtil" %>
<%@ page import="com.emfrontier.air.common.util.DateUtil" %>
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
	
String filename = StringUtil.convertNullDefault(request.getParameter("filename"), DateUtil.getCurrentDate()) + ".xls";
response.setHeader("Content-Disposition", "attachment; filename=\""+ FileUtil.getAttachmentFilename(request, filename, "UTF-8") +"\"");		
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title><%=CommonProperties.getSystemTitle(siteLocale)%></title>
<style type="text/css">
<%=FileUtil.getInputStreamString(FileUtil.getInputStreamByURL(CommonProperties.getSystemDefaultUrl() +"/common/_css/themes/default/common.excel.css"))%>
</style>
</head>
<body topmargin="0" leftmargin="0">
<%--// 페이지 내용 출력 //--%>	
<div class="content_name"><h2><%=CONTENT_NAME%></h2></div>
<jsp:include page="<%=CONTENT_PATH%>" flush="false" />
</body>
</html>