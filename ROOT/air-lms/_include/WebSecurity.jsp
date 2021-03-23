<%--
  - Description : 
  -    WebSecurity 화면보안
  -    <body> 아래에 <jsp:include page='<%=systemDefaultContentUrl + "/_include/WebSecurity.jsp"%>' flush='false' />
  -    형태로 추가
  --%>
<%@page import="com.emfrontier.air.common.config.CommonProperties"%>
<%@page import="org.apache.commons.lang3.BooleanUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    boolean webSecurityFlag = BooleanUtils.toBoolean(CommonProperties.load("system.useWebSecurityYN"));

    if(webSecurityFlag){
%>
<script type="text/javascript" src="/common/_lib/WebSecurity/03_Sample/scwebsc.js"></script>
<OBJECT ID="WebSecurer" CLASSID="CLSID:6687DEFA-B8AB-4895-B3BD-68DBEEF569DC" codebase=/common/_lib/WebSecurity/03_Sample/SCWCS.cab#version=1,0,18,19 height=0 Width=0 >
<PARAM NAME="PageAcl" VALUE="0000000">
<PARAM NAME="CategoryId" VALUE="0000001">
<PARAM NAME="PageOption" VALUE="000001">
</OBJECT>
<script>
$(window).load(function(){
	SecuCheck();
});
</script>
<% 
    } 
%>