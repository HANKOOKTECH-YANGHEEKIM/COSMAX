<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String gbn	=	requestMap.getString("GBN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		EXT_WORKCONT = resultMap.getResult("EXT_WORKCONT");
	
	BeanResultMap masMap = new BeanResultMap();
	if(EXT_WORKCONT != null && EXT_WORKCONT.getRowCount()> 0){
		masMap.putAll(EXT_WORKCONT.getRowResult(0));
	}
	
	String gt_ext_workcont_uid	= masMap.getString("GT_EXT_WORKCONT_UID");
	String temp_gt_ext_workcont_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String uuid = StringUtil.getRandomUUID();
	
	//첨부관련 셋팅
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	
	if(StringUtil.isNotBlank(gt_ext_workcont_uid)){
		att_master_doc_id = gt_ext_workcont_uid;
		att_default_master_doc_Ids = gt_ext_workcont_uid;
	}else{
		att_master_doc_id = temp_gt_ext_workcont_uid;
		att_default_master_doc_Ids 	= "";
	}
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO,SIM_CHA_NM", "");
%>
<br />
<form name="saveForm" id="saveForm" method="post" style="margin:0; padding:0;">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>"/>
	<input type="hidden" name="gt_ext_workcont_uid" value="<%=gt_ext_workcont_uid%>"/>
	<input type="hidden" name="temp_gt_ext_workcont_uid" value="<%=temp_gt_ext_workcont_uid%>"/>
	<table class="basic">
		<tr>
			<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td2" colspan="3"><input type="text" class="text width_max" maxlength="500" name="yocheong_tit" id="yocheong_tit" /></td>
		</tr>
<%if("SS".equals(gbn)){ %>
	   <%--  <tr>
			<th><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></span></th>
			<td colspan="3">
				<%=HtmlUtil.getSelect(request, true, "sim_cha_no", "sim_cha_no", SIM_CODESTR, "", "class=\"select\"")%>
			</td>
		</tr>  --%>
<%} %>
 		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.발신자", siteLocale) %></th>
			<td class="td4">
				<%=StringUtil.convertForInput(loginUser.getName()) %>
				<input type="hidden" class="text width_max" name="balsinja_id" id="balsinja_id" value="<%=StringUtil.convertForInput(loginUser.getLoginId()) %>" />
				<input type="hidden" class="text width_max" name="balsinja_nam" id="balsinja_nam" value="<%=StringUtil.convertForInput(loginUser.getName()) %>" />
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.부서", siteLocale) %></th>
			<td class="td4">
				<%=StringUtil.convertForInput(loginUser.getGroupName()) %>
				<input type="hidden" class="text width_max" name="buseo_id" id="buseo_id" value="<%=StringUtil.convertForInput(loginUser.getGroupCode()) %>" />
				<input type="hidden" class="text width_max" name="buseo_nam" id="buseo_nam" value="<%=StringUtil.convertForInput(loginUser.getGroupName()) %>" />
			</td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.수신자", siteLocale) %></span></th>
	        <td class="td4" colspan="3">
	            <script type="text/javascript"> 
	            function searchChamjoja() {
	            	var defaultUser = $("#susinja_id").val();
					var param ={};
	            	
	            	param["groupTypeCodes"]= "IG";
	            	param["defaultUser"]= defaultUser;
	            	param["userType"]= "chamjo";
	            	
	            	airCommon.popupUserSelect("changeChamjoja", param);
	            }
	            
	            function changeChamjoja(data) {
	            	
	            	var jsonData = JSON.parse(data);
	            	var init_code = "";
	            	var init_name = "";
	            	var init_name_ko = "";
	            	var init_name_en = "";
	            	
	            	for(var i = 0; i< jsonData.length; i++){
	            		if(i > 0){
	            			init_code += ",";
	            			init_name += "\n";
	            			init_name_ko += "\n";
	            			init_name_en += "\n";
	            		}
	            		init_code += jsonData[i].LOGIN_ID;
	           			init_name += jsonData[i].GROUP_NAME_<%=siteLocale%>+" "+jsonData[i].NAME_<%=siteLocale%> +" "+jsonData[i].POSITION_NAME_<%=siteLocale%>;
	           			init_name_ko += jsonData[i].GROUP_NAME_KO +"/"+jsonData[i].NAME_KO;
	           			init_name_en += jsonData[i].GROUP_NAME_EN +"/"+jsonData[i].NAME_EN; 
	            	}
	            	initChamjoja(true, init_code, init_name, init_name_ko, init_name_en);
	            	
	            }
	            
	            function initChamjoja(isForceInit, code, name, name_ko, name_en) {
	            	code = (code == undefined ? "" : code);
	            	name = (name == undefined ? "" : name);
	            	name_ko = (name_ko == undefined ? "" : name_ko);
	            	name_en = (name_en == undefined ? "" : name_en);
	            	
	            	if (!isForceInit && !confirm("<%=StringUtil.getScriptMessage("M.참조자정보를초기화하시겠습니까",siteLocale)%>")) {
	            		return false;
	            	}
	            		
	            	document.getElementById("susinja_id").value = code;
	            	document.getElementById("susinja_nam").value = name;
	            	document.getElementById("susinja_nam_ko").value = name_ko;
	            	document.getElementById("susinja_nam_en").value = name_en;
	            	 
	            	$("#susinja_nam").val().replace("\n", '<br>');
	            	$("#susinja_nam_ko").val().replace("\n", '<br>');
	            	$("#susinja_nam_en").val().replace("\n", '<br>');
	            }                        
	            </script>
	            <input type="hidden" id="susinja_id" name="susinja_id" value="<%=StringUtil.convertForInput(masMap.getDefStr("CHAMJOJA_COD","")) %>" />
	            <input type="hidden" id="susinja_nam_ko" name="susinja_nam_ko" value="<%=StringUtil.convertForInput(masMap.getString("CHAMJOJA_NAM_KO")) %>" />
	            <input type="hidden" id="susinja_nam_en" name="susinja_nam_en" value="<%=StringUtil.convertForInput(masMap.getString("CHAMJOJA_NAM_EN")) %>" />
	            <span style="float:left;"> 
				    <span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="initChamjoja(false)"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
				    <span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchChamjoja()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
	             </span>	
	            <textarea name="susinja_nam" id="susinja_nam" readonly="readonly"  class="width_max"  rows="5"><%=StringUtil.convertForInput(masMap.getDefStr("CHAMJOJA_NAM","")) %></textarea>
	        </td>
	    </tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td colspan="3">
				<%=HtmlUtil.getHtmlEditor(request,true, "balsin_cont", "balsin_cont", masMap.getStringEditor("BALSIN_CONT"), "")%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td colspan="3">
				<input type="hidden" name="DRM_CLEAR" value="N"/>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="CMM/BALSIN" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    	<span style="color:red;">※ "수신자”에게 위 내용 그대로 이메일을 발송합니다.</span>
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.메일발송",siteLocale)%></a></span>
    	<%if(StringUtil.isNotBlank(gt_ext_workcont_uid)){ %>
	    	<span class="ui_btn medium icon"><span class="refresh"></span><a href="javascript:void(0)" onclick="history.back() ;"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
	   	<%}else{ %>
	    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
	   	<%} %>
    </div>
</div>	
<script>
var goProc = function(){
	if ("" == $("#yocheong_tit").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"제목")%>");
		$("#yocheong_tit").focus();
	    return false;	
	}
	
	if ("" == $("#susinja_id").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"수신자")%>");
		$("#susinja_nam").focus();
	    return false;	
	}	

	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			
		<%if(StringUtil.isNotBlank(gt_ext_workcont_uid)){ %>

			try {
				opener.getLmsGtExtWorkNoreCont<%=sol_mas_uid%>(1);
			}catch(e) {
			}
			
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_ext_workcont_uid'>").val("<%=gt_ext_workcont_uid%>"));
			imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
		
	   	<%}else{ %>
			opener.getLmsGtExtWorkNoreCont<%=sol_mas_uid%>(1);
			window.close();
	   <%} %>
		});
	}
}
</script>