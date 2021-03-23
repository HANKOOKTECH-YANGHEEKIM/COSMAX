<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);

	//-- 결과값 셋팅
	BeanResultMap responseMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String actionCode 	= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 	= responseMap.getString(CommonConstants.MODE_CODE);

	String masterDocId  	= StringUtil.convertNull(request.getParameter("masterDocId"));
	String systemTypeCode	= StringUtil.convertNull(request.getParameter("systemTypeCode"));
	String typeCode			= StringUtil.convertNull(request.getParameter("typeCode"));
%>
<script type="text/javascript">
	function doSave(frm){
		frm.action = "/ServletController";
		frm.<%=CommonConstants.ACTION_CODE%>.value 	= "SYS_ATCH";
		frm.<%=CommonConstants.MODE_CODE%>.value 	= "POPUP_AFTER_ADD_WRITE_PROC";
		frm.target = "_self";
		frm.submit();
	}
</script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="attachAfterAddMode" value="Y" />

	<table class="table-wrap">
		<tr>
			<td style="vertical-align: top; width:45%;">
				<jsp:include page="/ServletController">
					<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
					<jsp:param value="FILE_WRITE" name="AIR_MODE" />
					<jsp:param value="" name="AIR_PARTICLE" />
					<jsp:param value="N" name="requiredYn" />
					<jsp:param value="Y" name="attachAfterAddMode" />
				</jsp:include>
			</td>
		</tr>
	</table>
	<div class="buttonlist">
		<div class="right">
			<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:doSave(document.form1);"><%=StringUtil.getLocaleWord("L.저장",siteLocale)%></a></span>
		</div>
	</div>
</form>
<p></p>