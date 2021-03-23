<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 결과값 셋팅
	BeanResultMap responseMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String procResult 		= responseMap.getString("PROC_RESULT");
	String procMessage 		= responseMap.getString("PROC_MESSAGE");

%>
<script type="text/javascript">
//-- 메시지 출력 & 페이지 이동
alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", "KO", "L.추가")%>");
opener.location.reload();
self.close();
</script>