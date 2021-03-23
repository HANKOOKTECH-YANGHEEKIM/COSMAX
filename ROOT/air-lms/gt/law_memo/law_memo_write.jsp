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
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String			gbn	=	requestMap.getString("GBN");
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		rsMas = resultMap.getResult("MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		masMap.putAll(rsMas.getRowResult(0));
	}
	
	String gt_memo_uid	= masMap.getString("GT_MEMO_UID");
	String temp_gt_memo_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids 	= "";
	
	if(StringUtil.isNotBlank(gt_memo_uid)){
		att_master_doc_id = gt_memo_uid;
		att_default_master_doc_Ids = gt_memo_uid;
	}else{
		att_master_doc_id = temp_gt_memo_uid;
		att_default_master_doc_Ids 	= "";
	}
%>
<br />
<form name="saveForm" id="saveForm">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>"/>
	<input type="hidden" name="gt_memo_uid" value="<%=gt_memo_uid%>"/>
	<input type="hidden" name="temp_gt_memo_uid" value="<%=temp_gt_memo_uid%>"/>
	<table class="basic">
		<tr>
			<th class="th2"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td2"><input type="text" class="text width_max" data-length="255" name="title" id="title" value="<%=masMap.getString("TITLE") %>" /></td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td>
				<%=HtmlUtil.getHtmlEditor(request,true, "CONTENT", "CONTENT", masMap.getStringEditor("CONTENT"), "")%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
                    <jsp:param value="LMS/GT/MEMO" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
   	<%if(StringUtil.isNotBlank(gt_memo_uid)){ %>
    	<span class="ui_btn medium icon"><span class="refresh"></span><a href="javascript:void(0)" onclick="history.back() ;"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
   	<%}else{ %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
   	<%} %>
    </div>
</div>	
<script>
var goProc = function(){

	if ("" == $("#title").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"제목")%>");
		$("#form_no").focus();
	    return false;	
	}

	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			
			<%if(StringUtil.isNotBlank(gt_memo_uid)){ %>
			try {
				opener.getLmsGtLawMemo<%=sol_mas_uid%>(1);
			} catch(exception) {
			}
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_memo_uid'>").val("<%=gt_memo_uid%>"));
			imsiForm.append($("<input type='hidden' name='gbn'>").val("<%=gbn%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
			
			<%}else{ %>
				opener.getLmsGtLawMemo<%=sol_mas_uid%>(1);
				window.close();
	   		<%} %>
		});
	}
}
</script>