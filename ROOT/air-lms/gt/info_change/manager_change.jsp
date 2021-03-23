<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap searchMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= searchMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	String sol_mas_uid 					= resultMap.getString("sol_mas_uid");
	String sol_mas_ids 					= resultMap.getString("sol_mas_ids");
	SQLResults viewResult 				= resultMap.getResult("VIEW");
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 상세보기 값 셋팅
	String gubun_cod			= "";
	String gubun_nam			= "";
	String mas_tit				= "";
	String damdang_id			= "";
	String damdang_nam			= "";
	
	if(viewResult != null && viewResult.getRowCount() > 0){
		gubun_cod				= viewResult.getString(0, "gubun_cod");
		gubun_nam				= viewResult.getString(0, "gubun_nam_" + siteLocale);
		mas_tit					= viewResult.getString(0, "mas_tit");
		damdang_id				= viewResult.getString(0, "damdang_id");
		damdang_nam				= viewResult.getString(0, "damdang_nam_" + siteLocale);
	}
%>
<script type="text/javascript">
/**
 * 목록 페이지로 이동
 */	
function goList(frm) {		
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_GOLIST",siteLocale)%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();	
	}	
}

/**
 * 저장
 */	
function doSubmit(frm) {	
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT",siteLocale, StringUtil.getLocaleWord("L.저장", siteLocale))%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "MANAGER_CHANGE_PROC";
		
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}
}
</script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="gubun_cod" value="<%=gubun_cod%>" />
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="sol_mas_ids" value="<%=sol_mas_ids%>" />
	
	<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
		<td class="td2"><%=gubun_nam%></td>
	</tr>
	<tr>		
		<th class="th2"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
		<td class="td2"><%=StringUtil.convertForView(mas_tit)%></td>
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
		<td class="td2">
			<script type="text/javascript"> 
            function searchDamdang() {
            	var defaultUser = $("#lms_pati_chamjoja_cod").val();
				var param ={};
            	
            	param["groupTypeCodes"]= "IG";
            	param["defaultUser"]= defaultUser;
            	param["multiselect"]= "N";
            	
            	airCommon.popupUserSelect("changeDamdang", param);
            	
            }
            function changeDamdang(data) {                	            	
            	var jsonData = JSON.parse(data);
                
            	document.getElementById("damdang_id").value = jsonData[0].LOGIN_ID;
            	document.getElementById("damdang_nam").value = jsonData[0].NAME_<%=siteLocale%>;
            }
            </script>
			<input type="hidden" id="damdang_id" name="damdang_id" value="<%=StringUtil.convertForInput(damdang_id) %>" />
			<input type="text" id="damdang_nam" name="damdang_nam" value="<%=StringUtil.convertForInput(damdang_nam) %>" class="text" readonly />
			<input type="button" name="btnUserSelect" value=" " class="btn_search" onclick="searchDamdang()" />
		</td>
	</tr>		
	</table>
	<div class="buttonlist">	
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doSubmit(document.form1);"><%=StringUtil.getLocaleWord("B.CONFIRM",siteLocale)%></a></span>	
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0)" onclick="goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
	</div>  
</form>
