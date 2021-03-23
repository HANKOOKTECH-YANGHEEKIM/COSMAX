<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>    
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>    
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%
	//-- 결과값 셋팅
	BeanResultMap resultMap	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	String procResult 		= resultMap.getString("PROC_RESULT");
	String procMessage 		= resultMap.getString("PROC_MESSAGE");
	String loginId			= resultMap.getString("loginId");
	String loginPwd			= resultMap.getString("loginPwd");
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	System.out.println("login_proc.jsp >> SOL_MAS_UID : "+request.getParameter("SOL_MAS_UID"));
%>
<form name="form1" method="post" action="/ServletController">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="loginId" value="<%=StringUtil.convertForInput(loginId)%>" />
	<input type="hidden" name="loginPwd" value="<%=StringUtil.convertForInput(loginPwd)%>" />
</form>
<script type="text/javascript">  
<%
	if ("DONE".equals(procResult)) {
		//-- 로그인 완료 처리
		//out.println("location.replace('"+ CommonProperties.getSystemDefaultUrl() +"');");
		out.println("location.replace('"+ CommonProperties.getSystemDefaultUrl() +"/air-lms/index.jsp?SOL_MAS_UID="+request.getParameter("SOL_MAS_UID")+"');");
%>
<%--
	     document.form1.<%=CommonConstants.ACTION_CODE%>.value = 'LMS_MAIN';
	     document.form1.<%=CommonConstants.MODE_CODE%>.value = 'USR_INDEX';
	     document.form1.submit();
--%>
		<%
	} else if ("LOGIN_SELECT".equals(procResult)) {
		//-- 겸직 사용자 선택 처리
		out.println("document.form1."+ CommonConstants.MODE_CODE +".value = 'LOGIN_SELECT';");
		out.println("document.form1.submit();");
	
	} else if ("CAUTH_FAILED".equals(procResult)) {
		out.println("alert('"+ StringUtil.convertForJavascript(procMessage) +"');");
		out.println("self.close();");
		//out.println("location.replace('"+ CommonProperties.getSystemDefaultUrl() +"');");
	} else {
		out.println("alert('"+ StringUtil.convertForJavascript(procMessage) +"');");
		out.println("self.close();");
		//out.println("location.replace('"+ CommonProperties.getSystemSecurityUrl() + "/ServletController?AIR_ACTION=LMS_LOGIN&AIR_MODE=LOGIN_FORM" +"');");
	}
%>
</script>