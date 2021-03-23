<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>

<%@page import="com.emfrontier.air.lms.def.util.StuUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();


	//-- 요청값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String sol_mas_uid		= requestMap.getString("SOL_MAS_UID");
	
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults STU_DOC_REL_LIST = resultMap.getResult("STU_DOC_REL_LIST");
	
	String stu_id			= requestMap.getString("STU_ID");
	String doc_stu			= requestMap.getString("DOC_STU");
	String isNextForm		= requestMap.getString("ISNEXTFORM");
%>
<%if(STU_DOC_REL_LIST != null && STU_DOC_REL_LIST.getRowCount() > 0){ %>
<script>
var isDoStuProc = true;
//-- 문서 저장처리 없이 상태변경만 할 경우
var doStuProc<%=sol_mas_uid%> = function(next_stu_id, proc_gbn,last_doc_uid, msg){
	//-- 더블클릭 방지 처리
	if(!isDoStuProc) return false;
	else isDoStuProc = false;
	
	
<%-- 	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.처리")%>"; --%>
	if("T" == "<%=doc_stu%>"  && "P" != proc_gbn){
		msg  = "<%=StringUtil.getScriptMessage("M.임시저장삭제_알림", siteLocale)%>";
	}
	<%if(Boolean.valueOf(isNextForm)){%>
		msg  = "<%=StringUtil.getScriptMessage("M.작성내용삭제_알림", siteLocale)%>";
	<%}%>
	
	if(confirm(msg)){
		var data = {};
		data["stu_gbn"]=$("#stuGbn<%=sol_mas_uid%>").val();
		data["sol_mas_uid"]="<%=sol_mas_uid%>";
		data["last_doc_uid"]=last_doc_uid;
		data["proc_gbn"]= proc_gbn;
		data["stu_id"]="<%=stu_id%>";
		data["next_stu_id"]=next_stu_id;
		data["be_doc_stu"]="<%=doc_stu%>";
		
		airCommon.callAjax("SYS_FORM", "STU_PROC",data, function(json){
<%-- 				alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>"); --%>
			
			try{
				opener.doSearch(opener.document.form1);
			}catch(e){
				try{
					opener.initMain();
				}catch(e){
					
				}
			}
			
			if(json.rows && json.rows.length > 0){
				
				var row = json.rows[0];
			
				if(row.NEXT_STU_ID.indexOf("DISCARD") > -1){
					window.close();
				}
				
				var action_code = "LMS_"+row.STU_GBN+"_LIST_MAS";
				var mode_code = "POPUP_INDEX";
				if("SS" ==  row.STU_GBN){
					action_code = "LMS_SS_MAS";
					mode_code = "POPUP_INDEX";
				}else if(row.STU_GBN.indexOf("OLD") > -1){
					action_code = "LMS_GY_OLD";
				}
				
				//-- 임시저장이면서 팝업상태이면 닫지 않고 TEP를 띄워 준다.
				var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
				imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val(action_code));
				imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val(mode_code));
				imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
				imsiForm.attr("target","_self");
				imsiForm.appendTo("body");
				imsiForm.submit();
			}
			
		});
	}else{
		isDoStuProc = true;
	}
};

</script>
<div id="divTODO<%=sol_mas_uid%>" style="border: 1px solid #dcdcdc; padding:5px;">
<table class="none">
<caption><%=StringUtil.getLocaleWord("L.처리업무선택", siteLocale) %></caption>
<tr>
	<td style="text-align: right;">
	<%
		for(int i=0; i < STU_DOC_REL_LIST.getRowCount(); i++ ){ 
			BeanResultMap rowMap = STU_DOC_REL_LIST.getRowResult(i);
			StringBuffer event = new StringBuffer();
			String authCd = rowMap.getString("AUTH_CD");
			
			String title = rowMap.getString("CMM_ISJ");
			if(StringUtil.isBlank(title)){
				title  = StringUtil.getLang(rowMap.getString("LANG_CODE"), siteLocale);
			}else{
				title = StringUtil.getLang(title, siteLocale);
			}
			
			String msg = StringUtil.getScriptMessage("M.진행하시겠습니까", siteLocale, title);
			
			event.append("doStuProc").append(sol_mas_uid).append("('")
					.append(rowMap.getString("NEXT_STU_ID")).append("','")
					.append(rowMap.getString("PROC_GBN")).append("','")
					.append(rowMap.getString("LAST_DOC_UID")).append("','")
					.append(msg).append("');")
			;
			if("K".equals(rowMap.getString("PROC_GBN"))){
				event = new StringBuffer();
				event.append("openFormNoStu").append(sol_mas_uid).append("('")
						.append(rowMap.getString("FORM_NO")).append("','")
						.append(rowMap.getString("NEXT_FORM_NO")).append("','")
						.append(rowMap.getString("NEXT_STU_ID")).append("','")
						.append(rowMap.getString("STU_GBN")).append("');");
			}

	%>
		<%if("DEV".equals(CommonProperties.getSystemMode()))out.print("<font color=\"#DDDDDD\">"+rowMap.getString("STU_ID")+"</font>"); %><span class="ui_btn medium icon" id="proc_<%=rowMap.getString("NEXT_STU_ID")%>"><span class="confirm"></span><a href="javascript:void(0)" onclick="<%=event%>"><%=title%></a></span>
	<%
		} 
	%>
	</td>
</tr>
</table>
</div>
<%} %>

