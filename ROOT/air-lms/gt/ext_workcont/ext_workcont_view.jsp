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
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String			sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String gbn	=	requestMap.getString("GBN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	SQLResults		rsMas = resultMap.getResult("MAS");
	
	BeanResultMap masMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		masMap.putAll(rsMas.getRowResult(0));
	}
	
	String gt_ext_workcont_uid	= masMap.getString("GT_EXT_WORKCONT_UID");
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO,SIM_CHA_NM", "");
	
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

<br />
	<table class="basic">
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td2" colspan="3"><%=masMap.getStringView("YOCHEONG_TIT") %></td>
		</tr>
<%if("SS".equals(gbn)){ %>
	    <%-- <tr>
			<th><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></th>
			<td colspan="">
				<%=HtmlUtil.getSelect(request, false, "sim_cha_no", "sim_cha_no", SIM_CODESTR, masMap.getString("SIM_CHA_NO"), "class=\"select\"")%>
			</td>
		</tr>  --%>
<%} %>
 		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.발신자", siteLocale) %></th>
			<td class="td4">
	        	 <%=masMap.getString("BALSINJA_NAM") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.부서", siteLocale) %></th>
			<td class="td4">
	        	 <%=masMap.getString("BUSEO_NAM") %>
			</td>
		</tr>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.수신자", siteLocale) %></th>
	        <td class="td4">
	        	 <%=masMap.getStringView("SUSINJA_NAM") %>
<%-- 	        	 <%=StringUtil.replace(masMap.getString("SUSINJA_NAM"), "\n", ",")  %> --%>
	        </td>
	        <th class="th4"><%=StringUtil.getLocaleWord("L.참조자", siteLocale) %></th>
	        <td class="td4">
	            <%=masMap.getDefStr("CHAMJOJA_NAM","") %>
	        </td>
	    </tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td colspan="3">
				<%=masMap.getString("BALSIN_CONT")%>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=gt_ext_workcont_uid%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="CMM/BALSIN" name="typeCode" />
                </jsp:include>
			</td>
		</tr>
		<tr>
			<th>첨부파일 DRM 해제</th>
			<td colspan="3">
				<%=masMap.getString("DRM_CLEAR")%>
			</td>
		</tr>
	</table>
	
<div id="modify" style="display:<%if(isAuths && StringUtil.isBlank(masMap.getString("SUSIN_DTE"))  ){%><%}else{%>none;<%}%>">
	<br/>
	<form id="saveForm">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>"/>
	<input type="hidden" name="gt_ext_workcont_uid" value="<%=gt_ext_workcont_uid%>"/>
	<table class="basic">
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.회신일", siteLocale) %></th>
			<td class="td2"><%=HtmlUtil.getInputCalendar(request, true, "SUSIN_DTE", "SUSIN_DTE", masMap.getStringView("SUSIN_DTE"), "")%> </td>
		</tr>
<%if(!"SS".equals(gbn)){ %>
		<tr>
			<th><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.외부자문표시제목", siteLocale) %></th>
			<td>
				<input type="text" name="EXT_TITLE" id="EXT_TITLE" class="text width_max"  value="<%=masMap.getString("EXT_TITLE")%>">
				<span style="color:red;">※ 외부자문표시제목에 기재한 내용이 "외부자문 제목"으로 목록에 표시됩니다.</span>
			</td>
		</tr>
<%} %>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td><%=HtmlUtil.getHtmlEditor(request,true, "REPLAY_CONTENT", "REPLAY_CONTENT", masMap.getStringEditor("REPLAY_CONTENT"), "")%></td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=gt_ext_workcont_uid%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="CMM/SUSIN" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=gt_ext_workcont_uid%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
	</table>
	</form>
	<div class="buttonlist">
	    <div class="left">
	    </div>
	    <div class="rigth">
	    <%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="goReplay();"><%=StringUtil.getLocaleWord("L.답변",siteLocale)%> <%=StringUtil.getLocaleWord("B.REG",siteLocale)%></a></span>
	    <%} %>
	    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
	    </div>
	</div>	
</div>
<div id="modify_view" style="display:<%if( StringUtil.isNotBlank(masMap.getString("SUSIN_DTE"))){%><%}else{%>none;<%}%>">
 	<br/>
 	<table class="basic">
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.회신일", siteLocale) %></th>
			<td class="td2"><%=masMap.getStringView("SUSIN_DTE")%> </td>
		</tr>
<%if(!"SS".equals(gbn)){ %>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.외부자문표시제목", siteLocale) %></th>
			<td><%=masMap.getStringView("EXT_TITLE")%> </td>
		</tr>
<%} %>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td><%=masMap.getStringView("REPLAY_CONTENT")%> </td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td>
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_VIEW" name="AIR_MODE" />
                    <jsp:param value="<%=gt_ext_workcont_uid%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="CMM/SUSIN" name="typeCode" />
                </jsp:include>
			</td>
		</tr>
	</table>
	<div class="buttonlist">
	    <div class="left">
	    </div>
	    <div class="rigth">
	    <%if(isAuths){ %>
	    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" onclick="updateReplay();"><%=StringUtil.getLocaleWord("L.답변",siteLocale)%> <%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
	    <%} %>
	    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
	    </div>
	</div>	
</div>	

<%if(isAuths){ %>
<script>
var updateReplay = function(){
	$("#modify_view").hide();
	$("#modify").show();
}
var goReplay = function(){

	<%if(!"SS".equals(gbn)){ %>
	if($("#EXT_TITLE").val() == ""){
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.외부자문표시제목",siteLocale))%>");
		$("#EXT_TITLE").focus();
		return false;
	}
	<%} %>
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){

		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $("#saveForm").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			
			try {
				opener.getLmsGtExtWorkCont<%=sol_mas_uid%>(1);
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
			
		});
	}
}
</script>
<%} %>