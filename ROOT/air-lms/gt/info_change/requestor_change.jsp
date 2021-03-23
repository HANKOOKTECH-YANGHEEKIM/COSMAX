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
	String yocheong_dpt_cod		= "";
	String yocheong_dpt_nam		= "";
	String yocheong_id			= "";
	String yocheong_nam			= "";
	
	if(viewResult != null && viewResult.getRowCount() > 0){
		gubun_cod				= viewResult.getString(0, "gubun_cod");
		gubun_nam				= viewResult.getString(0, "gubun_nam_" + siteLocale);
		mas_tit					= viewResult.getString(0, "mas_tit");
		yocheong_dpt_cod		= viewResult.getString(0, "yocheong_dpt_cod");
		yocheong_dpt_nam		= viewResult.getString(0, "yocheong_dpt_nam_" + siteLocale);
		yocheong_id				= viewResult.getString(0, "yocheong_id");
		yocheong_nam			= viewResult.getString(0, "yocheong_nam_" + siteLocale);
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
		frm.<%=CommonConstants.MODE_CODE%>.value = "REQUESTOR_CHANGE_PROC";
		
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
		<th class="th4"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
		<td class="td4" colspan="3"><%=gubun_nam%></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.제목",siteLocale)%></th>
		<td class="td4" colspan="3"><%=StringUtil.convertForView(mas_tit)%></td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰부서",siteLocale)%></th>
		<td class="td4"><input type="hidden" id="yocheong_dpt_cod" name="yocheong_dpt_cod" value="<%=StringUtil.convertForInput(yocheong_dpt_cod) %>" />
			<input type="text" id="yocheong_dpt_nam" name="yocheong_dpt_nam" value="<%=StringUtil.convertForInput(yocheong_dpt_nam) %>" class="text" readonly />
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
		<td class="td4">
			<script type="text/javascript"> 
            function searchYocheong() {
            	var defaultUser = $("#lms_pati_chamjoja_cod").val();
				var param ={};
            	
            	param["groupTypeCodes"]= "IG";
            	param["defaultUser"]= defaultUser;
            	param["multiselect"]= "N";
            	
            	airCommon.popupUserSelect("changeYocheong", param);
            }
            function changeYocheong(data) {                	            	
            	var jsonData = JSON.parse(data);
            	var login_id = "";
            	var name_ko = "";
            	var dpt_cod = "";
            	var dpt_nam = "";
            	
            	for(var i = 0; i< jsonData.length; i++){
            		if(i > 0){
            			init_code += ",";
            			init_name += "\n";
            			init_name_ko += "\n";
            			init_name_en += "\n";
            		}
            		login_id += jsonData[i].LOGIN_ID;
            		name_ko += jsonData[i].NAME_<%=siteLocale%>;
           			dpt_cod += jsonData[i].GROUP_CODE; 
           			dpt_nam += jsonData[i].GROUP_NAME_<%=siteLocale%>;
            	}
                
                document.getElementById("yocheong_dpt_cod").value = dpt_cod;
                document.getElementById("yocheong_dpt_nam").value = dpt_nam;
            	document.getElementById("yocheong_id").value = login_id;
            	document.getElementById("yocheong_nam").value = name_ko;
            }
            </script>
			<input type="hidden" id="yocheong_id" name="yocheong_id" value="<%=StringUtil.convertForInput(yocheong_id) %>" />
			<input type="text" id="yocheong_nam" name="yocheong_nam" value="<%=StringUtil.convertForInput(yocheong_nam) %>" class="text" readonly />
			<input type="button" name="btnUserSelect" value=" " class="btn_search" onclick="searchYocheong()" />
		</td>
	</tr>		
	</table>
	<div class="buttonlist">	
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doSubmit(document.form1);"><%=StringUtil.getLocaleWord("B.CONFIRM",siteLocale)%></a></span>	
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0)" onclick="goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
	</div>  
</form>

