<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
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

String popupContentName  = StringUtil.unescape(StringUtil.convertNull(request.getParameter("popupContentName")));
CONTENT_NAME = ("".equals(popupContentName) ? CONTENT_NAME : popupContentName);
CONTENT_NAME = CONTENT_NAME.replaceAll(" ", "");
%>
<!DOCTYPE html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<title><%=CommonProperties.getSystemTitle(siteLocale)%></title>
<meta charset="UTF-8" />
<jsp:include page='<%=systemDefaultContentUrl + "/_include/header.default.jsp"%>' flush='false' />
<style>
.top_line {
	height:5px;
	background:#333;
}
</style>
</head>
<body>
<div id="wrap">
<% 
if (MODE_CODE.indexOf("POPUP") == -1) { 
%>
<div class="template_body wrap">
	<!-- // Top Menu // -->
	<jsp:include page='<%=systemDefaultContentUrl + "/_include/menu.top.jsp"%>' flush='false' />
	<div class="top_line"></div>
		
	<!-- // Content // -->	
	<div class="content_body">
		<!-- // Quick Menu // -->
		<jsp:include page='<%=systemDefaultContentUrl + "/_include/menu.quick.jsp"%>' flush='false' />
		
		<div class="easyui-panel" title="<%=StringUtil.getLocaleWord("L."+CONTENT_NAME.replace("사용자 권한", "사용자권한"), siteLocale)%>" style="padding:5px">
			<jsp:include page='<%=CONTENT_PATH%>' flush='false' />
		</div>
		
	</div>	
	
	<!-- // Footer // -->
	<jsp:include page='<%=systemDefaultContentUrl + "/_include/footer.jsp"%>' flush='false' />	
</div>
<%
} else { 
%>
<!-- // Content // -->
<jsp:include page='<%=CONTENT_PATH%>' flush='false' />
<% 
} 
%>
<!-- // Background Process Frame // -->
<iframe name="airBackgroundProcessFrame" id="airBackgroundProcessFrame" style="display:none;"></iframe>

<%-- WebSecurity 화면보안 --%>
<jsp:include page='<%=systemDefaultContentUrl + "/_include/WebSecurity.jsp"%>' flush='false' />
</div>
</body>
</html>