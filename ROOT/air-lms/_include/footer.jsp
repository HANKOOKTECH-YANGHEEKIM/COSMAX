<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>   
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);

	if (loginUser == null) { loginUser = new SysLoginModel(); }
	
	String siteLocale = loginUser.getSiteLocale();
	
	String layerClass = "usr";
	boolean isBeobmuTeamUser = LmsUtil.isBeobmuTeamUser(loginUser);
	
	if (isBeobmuTeamUser) {
		layerClass = "chr";
	}
	
	String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
%>
<div id="footer">
	<div class="footer_sub">
		<span class="f_logo"></span>
		<span class="copyright">Copyright © <%=CommonProperties.load("system.organization_en")%> All Rights Reserved. </span>
	</div>
</div>
