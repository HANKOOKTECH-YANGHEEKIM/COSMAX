<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>

<%
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String procResult 		= resultMap.getString("PROC_RESULT");
	String procMessage 		= resultMap.getString("PROC_MESSAGE");
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 신규등록/삭제 작업일 경우 무조건 첫 페이지로 이동!
	if (modeCode.equals("WRITE_PROC") || modeCode.equals("DELETE")) pageNo = "1";
%>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
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
	try{
		//-- 완료시 목록 페이지로 이동!
		opener.doSearch(opener.document.form1);
		window.close();
	}catch(e){
		goList(document.form1);
	}
}	
</script>    