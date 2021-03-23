<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%
//-- 로그인 사용자 정보 셋팅
SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = loginUser.getSiteLocale();

//-- 검색값 셋팅
BeanResultMap requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField  	= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod 	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
String ss_sim_uid 			= requestMap.getString("SS_SIM_UID");
String ss_gwanryeon_uid 	= requestMap.getString("SS_GWANRYEON_UID");
String sim_cha_no 			= requestMap.getString("SIM_CHA_NO");

String temp_ss_gwanryeon_uid 	= StringUtil.getRandomUUID(); //새로 생성한 아이디

String sol_mas_uid = requestMap.getString("SOL_MAS_UID");

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

SQLResults sqlrSS_SIM = resultMap.getResult("SS_GWANRYEON");

BeanResultMap simMap = new BeanResultMap();
if(sqlrSS_SIM != null && sqlrSS_SIM.getRowCount()> 0){
	simMap.putAll(sqlrSS_SIM.getRowResult(0));
}

//-- 파라메터 셋팅
String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

String ss_003_uid = simMap.getString("SS_003_UID");

if("".equals(ss_003_uid)){
	ss_003_uid = StringUtil.getRandomUUID();
}

String new_ss_003_uid   = StringUtil.getRandomUUID();

// 갱신일 경우 UID 생성
if(StringUtil.isNotBlank(ss_gwanryeon_uid)){
	ss_003_uid = new_ss_003_uid;
}

//첨부관련 셋팅
String att_master_doc_id = "";
String att_default_master_doc_Ids 	= "";

if(StringUtil.isBlank(ss_gwanryeon_uid)){ //신규
	att_master_doc_id = temp_ss_gwanryeon_uid;
	att_default_master_doc_Ids = ""; //다른데 있는 첨부파일을 끌어올때 사용
}else{ //수정
	att_master_doc_id = ss_gwanryeon_uid;
	att_default_master_doc_Ids = ss_gwanryeon_uid;
}
%>
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="SS_GWANRYEON_UID" value="<%=ss_gwanryeon_uid%>" />
	<input type="hidden" name="SS_SIM_UID" value="<%=ss_sim_uid%>" />
	<input type="hidden" name="TEMP_SS_GWANRYEON_UID" value="<%=temp_ss_gwanryeon_uid%>" />
	<input type="hidden" name="IS_NEW" value="<%=StringUtil.isBlank(ss_gwanryeon_uid) ? true : false %>" />
	<input type="hidden" name="sqlrSS_SIM" value="" />
	<input type="hidden" name="SIM_CHA_NO" value="<%=sim_cha_no %>" />
	<input type="hidden" name="ss_003_uid" value="<%=ss_003_uid%>" />
	
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.진행내역",siteLocale) %></caption>
	<tr>
		<th class="th3"><%=StringUtil.getLocaleWord("L.일자",siteLocale) %></th>
		<td class="td3">
			<%= HtmlUtil.getInputCalendar(request, true, "JAGSEONG_DTE", "JAGSEONG_DTE", simMap.getDefStr("JAGSEONG_DTE",""), "") %>
		</td>
	</tr>
	<tr>
		<th class="th3"><%=StringUtil.getLocaleWord("L.내역",siteLocale) %></th>
		<td>
			<textarea class="memo width_max" name="JARYOGAEYO" id="JARYOGAEYO" onblur="airCommon.validateMaxLength(this, 4000)" style="height:100px;"><%=simMap.getStringEditor("JARYOGAEYO") %></textarea>
		</td>
	</tr>
	<th class="th3"><%=StringUtil.getLocaleWord("L.첨부",siteLocale) %></th>			
		<td class="td3">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/GWANRYEON" name="typeCode" />
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
    	<%
    	if(!StringUtil.isBlank(ss_gwanryeon_uid)){
    	%>
    	<span class="ui_btn medium icon" style="float: right;"><span class="delete"></span><a href="javascript:goGwanryeonDel()"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
    	<%
    	}
    	%>
    	
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    </div>
</div>	

<script>
var goProc = function(){

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		
		var data = $("#saveForm").serialize();
		
		airCommon.callAjax("LMS_SS_MAS", "POPUP_WRITE_GWANRYEON_PROCESS",data, function(json){
			//opener.refreshWindow();
			opener.getSimGwanryeonList<%=sol_mas_uid%>();
			window.close();
		});
	}
};

var goGwanryeonDel = function(){
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>")){
		
		var data = {};
		data["SS_SIM_UID"] = "<%=simMap.getString("SS_SIM_UID")%>";
		//삭제할 BIYOUNG UID
		data["SS_GWANRYEON_UID"] = "<%=ss_gwanryeon_uid%>";
		
		airCommon.callAjax("LMS_SS_MAS", "POPUP_DELETE_GWANRYEON_PROCESS",data, function(json){
			//opener.refreshWindow();
			opener.getSimGwanryeonList<%=sol_mas_uid%>();
			window.close();
			
		});
	}
}
</script>