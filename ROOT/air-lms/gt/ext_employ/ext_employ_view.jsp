<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 		= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String sol_mas_uid		=	requestMap.getString("SOL_MAS_UID");
	String gubun			=	requestMap.getString("GUBUN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO,SIM_CHA_NM", "");
	
	SQLResults rsMas = resultMap.getResult("MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		masMap.putAll(rsMas.getRowResult(0));
	}
	
	String gt_ext_uid	= masMap.getString("GT_EXT_UID");
	String temp_gt_ext_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	String	 gbn = requestMap.getString("GBN");
	SQLResults LMS_MAS = resultMap.getResult("LMS_MAS");
	BeanResultMap lmsMap = new BeanResultMap();  
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0)lmsMap.putAll(LMS_MAS.getRowResult(0));
	boolean isAuths = false;
	if(loginUser.getLoginId().equals(lmsMap.getString("YOCHEONG_ID")) ||
			loginUser.getLoginId().equals(lmsMap.getString("DAMDANG_ID")) ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
	
	if("SS".equals(gbn) && loginUser.isUserAuth("LMS_SSM")){
		isAuths = true;
	
	}else if(loginUser.isUserAuth("LMS_BCD")){
		isAuths = true;
		
	}
%>
	<table class="basic" style="margin-top:5px;">   
<%if("SS".equals(gubun)){ %>
		<tr>
			<th><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></span></th>
			<td>
				<%=HtmlUtil.getSelect(request, false, "sim_cha_no", "sim_cha_no", SIM_CODESTR, masMap.getString( "SIM_CHA_NO"), "class=\"select\"")%>
			</td>
		</tr>
<%} %>
		<tr>
		  	<th class="th4"><%=StringUtil.getLocaleWord("L.이름",siteLocale)%></th>
		  	<td class="td4" colspan="3"><%=masMap.getString( "BYEONHOSA_NAM")%></td>
		</tr>
		<tr>
		  	<th class="th4"><%=StringUtil.getLocaleWord("L.소속",siteLocale)%></th>
		  	<td class="td4" colspan="3"><%=masMap.getString( "SOSOG_NAM")%></td>
		</tr>
		<tr>
		  	<th class="th4"><%=StringUtil.getLocaleWord("L.위임일",siteLocale)%></th>
		  	<td class="td4" colspan="3"><%=masMap.getString( "PLUS_DATE")%></td>
		</tr>
		<tr>
		  	<th class="th4"><%=StringUtil.getLocaleWord("L.위임종료일",siteLocale)%></th>
		  	<td class="td4" colspan="3"><%=masMap.getString( "MINUS_DATE")%></td>
		</tr>	
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.주요검토자",siteLocale)%></th>
			<td class="td4" colspan="3"><%=masMap.getString( "PGL_YN_TEXT")%></td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.위임계약조건",siteLocale)%></th>
			<td class="td4" style="height:120px; vertical-align:top;"><%=StringUtil.convertForView( masMap.getString("MEMO")) %></td>     
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.위임계약서날인본",siteLocale) %></th>
			<td class="td4" colspan="3">
					<jsp:include page="/ServletController" flush="true">
						<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
						<jsp:param value="FILE_VIEW" name="AIR_MODE" />
						<jsp:param value="<%=gt_ext_uid%>" name="masterDocId" />
						<jsp:param value="CMM" name="systemTypeCode" />
						<jsp:param value="CMM/CMM" name="typeCode" />
					</jsp:include>
			</td>	
		</tr>        
    </table>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    <%if(isAuths){ %>
    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goUpdate();"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
    <%} %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<%if(isAuths){ %>
<script>
var goUpdate = function(){

	var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
	imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
	imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_WRITE_FORM"));
	imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
	imsiForm.append($("<input type='hidden' name='gt_ext_uid'>").val("<%=gt_ext_uid%>"));
	imsiForm.attr("target","_self");
	imsiForm.appendTo("body");
	imsiForm.submit();
}
</script>
<%} %>