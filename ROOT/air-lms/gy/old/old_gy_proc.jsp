<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String page_no 			= requestMap.getString(CommonConstants.PAGE_NO);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String procResult 		= resultMap.getString("PROC_RESULT");
	
	//-- 파라메터 셋팅
	String action_code	= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code	= resultMap.getString(CommonConstants.MODE_CODE);
	String gy_old_uid			= requestMap.getString("GY_OLD_UID");
	String gwanri_no			= requestMap.getString("GWANRI_NO");
	
	//-- 신규등록/삭제 작업일 경우 무조건 첫 페이지로 이동!
	if (mode_code.equals("WRITE_PROC") || mode_code.equals("DELETE")) page_no = "1";
%>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=page_no%>" />
	<input type="hidden" name="gy_old_uid" />
	<input type="hidden" name="gwanri_no" />
</form>

<script type="text/javascript">
	/**
	 * 목록 페이지로 이동
	 */
	function goList(frm) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "GLIST";		
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}
	
	/**
	 * 상세보기 페이지로 이동
	 */
	function goView(frm, uuid) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "POPUP_VIEW";
		frm.gy_old_uid.value = uuid;
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}
	
	//-- 완료 메시지 & 페이지 이동
	alert("<%=StringUtil.convertFor(procResult, "JAVASCRIPT")%>");	
<% if ("UPDATE_PROC".equals(mode_code)) { %>
 if(opener){
	opener.doSearch(opener.document.form1);
 }
	goView(document.form1, "<%=gy_old_uid%>");
<% } else { %>
	self.close();
	opener.doSearch(opener.document.form1);
// 	goList(document.form1);
<% } %>
</script>