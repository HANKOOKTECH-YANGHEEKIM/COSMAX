<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%
	String forward_page = CommonProperties.getSystemDefaultContentUrl() + "/index.jsp";
%>
<jsp:forward page="<%=forward_page%>"></jsp:forward>