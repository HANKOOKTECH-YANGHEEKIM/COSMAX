<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>   
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>    
<%
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	if (loginUser == null) { loginUser = new SysLoginModel(); }
	String siteLocale = loginUser.getSiteLocale();
%>
<script type="text/javascript">	
	window.top.location.href = "<%=CommonProperties.getSystemDefaultUrl()%>/";
</script>