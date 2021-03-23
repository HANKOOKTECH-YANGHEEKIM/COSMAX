<%@page import="com.emfrontier.air.common.config.CommonConstants"%>
<%@page import="com.emfrontier.air.common.model.SysLoginModel"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
%>
<%-- <%=loginUser.getMenuStr()%> --%>