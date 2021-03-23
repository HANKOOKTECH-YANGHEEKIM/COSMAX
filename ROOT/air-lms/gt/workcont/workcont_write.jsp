<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
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
	String parent_work_cont_uid	= requestMap.getString("PARENT_WORK_CONT_UID");

	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		WORK_MAS = resultMap.getResult("WORK_MAS");
	SQLResults		DEFAULT_SUSIN	 = resultMap.getResult("DEFAULT_SUSIN");
	SQLResults		PARENT_WORK_MAS = resultMap.getResult("PARENT_WORK_MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(WORK_MAS != null && WORK_MAS.getRowCount()> 0){
		masMap.putAll(WORK_MAS.getRowResult(0));
		
	}
	
	BeanResultMap parentMap = new BeanResultMap();
	if(PARENT_WORK_MAS != null && PARENT_WORK_MAS.getRowCount()> 0){
		parentMap.putAll(PARENT_WORK_MAS.getRowResult(0));
		
	}
	
	String work_cont_uid	= masMap.getString("WORK_CONT_UID");
	String temp_work_cont_uid = StringUtil.getRandomUUID();
	
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String uuid = StringUtil.getRandomUUID();
	
	
	//첨부관련 셋팅
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	if(StringUtil.isNotBlank(work_cont_uid)){
		att_master_doc_id 			= work_cont_uid;
		att_default_master_doc_Ids 	= work_cont_uid;
	}else{
		att_master_doc_id 			= temp_work_cont_uid;
		att_default_master_doc_Ids 	= masMap.getString("WORK_CONT_UID");
	}
	
	//-- 기본 수신자
	String susinja_ids = "";
	String susinja_nms = "";
	if(DEFAULT_SUSIN != null && DEFAULT_SUSIN.getRowCount() > 0){
		susinja_ids = DEFAULT_SUSIN.getString(0, "LOGIN_ID");
		susinja_nms = DEFAULT_SUSIN.getString(0, "GROUP_NAME_KO") +" "+ DEFAULT_SUSIN.getString(0, "NAME_KO") +" "+ DEFAULT_SUSIN.getString(0, "POSITION_NAME_KO");
	}
	
%>
<br />
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="parent_work_cont_uid" value="<%=parent_work_cont_uid %>" />
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>"/>
	<input type="hidden" name="work_cont_uid" value="<%=work_cont_uid%>"/>
	<input type="hidden" name="temp_work_cont_uid" value="<%=temp_work_cont_uid%>"/>
	<table class="basic">
		<tr>
			<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td2"><input type="text" class="text width_max" maxlength="255" name="work_title" id="work_title" value="<%=masMap.getString("WORK_TITLE")%>"/></td>
		</tr>
		<tr>
			<th><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.수신자", siteLocale) %></th>
			<td>
		<%if(StringUtil.isBlank(parent_work_cont_uid)){ %>
				<script>
					var searchSusin = function(){
						var defaultUser = $("#susinja_ids").val();
						var param ={};
		            	
		            	param["groupTypeCodes"]= "IG";
		            	param["defaultUser"]= defaultUser;
		            	param["userType"]= "susin";
		            	
		            	airCommon.popupUserSelect("changeChamjoja", param);
					}
					var changeChamjoja = function(json){
						var data = JSON.parse(json);
						var ids = [];
						var nms = [];
						$(data).each(function(i, d){
							ids.push(d.LOGIN_ID);
							nms.push(d.GROUP_NAME_<%=siteLocale%>+" "+d.NAME_<%=siteLocale%> +" "+d.POSITION_NAME_<%=siteLocale%>);
							
						});
						
						$("#susinja_ids").val(ids);
						$("#susinja_nms").val(nms);
					}
				</script>
				
				<input type="hidden" id="susinja_ids" name="susinja_ids" value="<%=StringUtil.convertForInput(masMap.getDefStr("SUSINJA_IDS", susinja_ids)) %>">
	            <input type="text" name="susinja_nms" id="susinja_nms" value="<%=masMap.getDefStr("SUSINJA_NMS", susinja_nms)%>" readonly class="text" style="width:80%" />	
			    <span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchSusin()"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
		<%}else{ %>
			<input type="hidden" id="susinja_ids" name="susinja_ids" value="<%=StringUtil.convertForInput(parentMap.getString("WORK_WRITE_ID")) %>">
            <input type="text" name="susinja_nms" id="susinja_nms" value="<%=parentMap.getString("WORK_WRITE_NM")%>" readonly class="text" style="width:80%" />
		<%} %>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td>
				<%=HtmlUtil.getHtmlEditor(request,true, "WORK_CONTENT", "WORK_CONTENT", masMap.getStringEditor("WORK_CONTENT"), "")%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="CMM" name="systemTypeCode" />
                    <jsp:param value="CMM/CMM" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<span style="color: red;text-align:left;">
<%=StringUtil.getLocaleWord("M.업무연락안내", siteLocale) %>
</span>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
    </div>
</div>	
<script>
var goProc = function(){

	if ("" == $("#work_title").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"제목")%>");
		$("#work_title").focus();
	    return false;	
	}

	if ("" == $("#susinja_ids").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"수신자")%>");
		$("#susinja_nms").focus();
	    return false;	
	}
	
	<%-- 
	if ("" == airCommon.getEditorValue('lms_pati_rvw_rsl', "<%=CommonProperties.load("system.editor")%>") ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.검토결과", siteLocale))%>");
		
		airCommon.getEditorFocus('lms_pati_rvw_rsl', "<%=CommonProperties.load("system.editor")%>");
		
		return false;
	} 
	--%>
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.REG")%>";
	if(confirm(msg)){
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>");
			try{
				opener.opener.getLmsGtWorkCont<%=sol_mas_uid%>(1);
			}catch(e){
				try{
					opener.getLmsGtWorkCont<%=sol_mas_uid%>(1);
					opener.window.colse();
				}catch(e){
				
				}
			}
			window.close();
		});
	}
}
</script>