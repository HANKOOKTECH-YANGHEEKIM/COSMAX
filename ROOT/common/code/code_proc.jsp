<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>

<%
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String procResult 		= resultMap.getString("PROC_RESULT");
	String procMessage 		= resultMap.getString("PROC_MESSAGE");
	String parent_uuid 		= resultMap.getString("PARENT_UUID");

	//-- 파라메터 셋팅
	String action_code	= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code	= resultMap.getString(CommonConstants.MODE_CODE);
	String uuid			= resultMap.getString("uuid");
	String sel_uuid_path			= requestMap.getString("SEL_UUID_PATH");
%>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name="uuid" />
	<input type="hidden" name="parent_uuid" value="<%=parent_uuid%>"/>
	<input type="hidden" name="sel_uuid_path" value="<%=sel_uuid_path%>"/>
</form>

<script type="text/javascript">
/**
 * 목록 페이지로 이동
 */
function goList(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
}

//-- 메시지 출력 & 페이지 이동
alert("<%=StringUtil.convertFor(procMessage, "JAVASCRIPT")%>");
var proc_result = "<%=procResult%>";
if (proc_result == "ERROR") {
	//-- 에러 발생시 이전 페이지로 이동!
	history.back();

} else {
	//-- 완료시 목록 페이지로 이동!
	goList(document.form1);
}
</script>
