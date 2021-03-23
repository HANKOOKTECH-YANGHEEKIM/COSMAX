<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = CommonProperties.getSystemDefaultLocale();
if (loginUser != null) {
	siteLocale = loginUser.getSiteLocale();
}
BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
SQLResults masInfo =  resultMap.getResult("MAS_INFO");
String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();

String ACTION_CODE 	= request.getParameter(CommonConstants.ACTION_CODE);
String MODE_CODE 	= request.getParameter(CommonConstants.MODE_CODE);

String CONTENT_PATH = (String)request.getAttribute(CommonConstants.CONTENT_PATH);
String CONTENT_NAME = (String)request.getAttribute(CommonConstants.CONTENT_NAME);

String popupContentName  = StringUtil.unescape(StringUtil.convertNull(request.getParameter("popupContentName")));
// CONTENT_NAME = ("".equals(popupContentName) ? CONTENT_NAME : popupContentName);
CONTENT_NAME = ("".equals(popupContentName) ? StringUtil.getLocaleWord("L."+StringUtil.replace(CONTENT_NAME, " ", ""), siteLocale)  : popupContentName);

if(masInfo != null && masInfo.getRowCount() > 0){
	CONTENT_NAME = CONTENT_NAME + " [" + masInfo.getString(0, "title_no")+"]";
}


%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title><%=CommonProperties.getSystemTitle(siteLocale)%></title>
<meta charset="UTF-8" />
<jsp:include page='<%=systemDefaultContentUrl + "/_include/header.default.jsp"%>' flush='false' />
</head>
<body style="margin:0;padding:0;text-align:left;" onload="window.focus();">
<!-- // Content Name // -->
<div class="popup_content_name">
	<%if(CONTENT_NAME.equals("L.:KO")){CONTENT_NAME = "외부변호사";} %>
	<span class="name"><%=CONTENT_NAME%></span>
	<span class="tools"><a href="javascript:self.close();" class="ui_icon close_popup" title="<%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%>"></a></span>
</div>
	
<!-- // Content // -->
<div class="popup_content_body">
<jsp:include page='<%=CONTENT_PATH%>' flush='false' />
</div>

<!-- // Background Process Frame // -->
<iframe name="airBackgroundProcessFrame" id="airBackgroundProcessFrame" style="display:none;"></iframe>

<%-- WebSecurity 화면보안 --%>
<jsp:include page='<%=systemDefaultContentUrl + "/_include/WebSecurity.jsp"%>' flush='false' />
</body>
</html>