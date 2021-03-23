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
String ss_biyong_uid 		= requestMap.getString("SS_BIYONG_UID");
String sim_cha_no 		= requestMap.getString("SIM_CHA_NO");

String temp_ss_biyong_uid 	= StringUtil.getRandomUUID(); //새로 생성한 아이디

String sol_mas_uid = requestMap.getString("SOL_MAS_UID");

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);

SQLResults sqlrSS_SIM = resultMap.getResult("SS_BIYONG");

BeanResultMap simMap = new BeanResultMap();
if(sqlrSS_SIM != null && sqlrSS_SIM.getRowCount()> 0){
	simMap.putAll(sqlrSS_SIM.getRowResult(0));
}

String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,NAME_"+ siteLocale, "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));// + "^SJ/HJ|심급/확정종결";
//-- 파라메터 셋팅
String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

String ss_003_uid = simMap.getString("SS_003_UID");

if("".equals(ss_003_uid)){
	ss_003_uid = StringUtil.getRandomUUID();
}

String new_ss_003_uid   = StringUtil.getRandomUUID();

// 갱신일 경우 UID 생성
if(StringUtil.isNotBlank(ss_biyong_uid)){
	ss_003_uid = new_ss_003_uid;
}

//첨부관련 셋팅
String att_master_doc_id = "";
String att_default_master_doc_Ids 	= "";

if(StringUtil.isBlank(ss_biyong_uid)){ //신규
	att_master_doc_id = temp_ss_biyong_uid;
	att_default_master_doc_Ids = ""; //다른데 있는 첨부파일을 끌어올때 사용
}else{ //수정
	att_master_doc_id = ss_biyong_uid;
	att_default_master_doc_Ids = ss_biyong_uid;
}
%>
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="SS_BIYONG_UID" value="<%=ss_biyong_uid%>" />
	<input type="hidden" name="SS_SIM_UID" value="<%=ss_sim_uid%>" />
	<input type="hidden" name="TEMP_SS_BIYONG_UID" value="<%=temp_ss_biyong_uid%>" />
	<input type="hidden" name="IS_NEW" value="<%=StringUtil.isBlank(ss_biyong_uid) ? true : false %>" />
	<input type="hidden" name="sqlrSS_SIM" value="" />
	<input type="hidden" name="SIM_CHA_NO" value="<%=sim_cha_no %>" />
	<input type="hidden" name="ss_003_uid" value="<%=ss_003_uid%>" />
	
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.비용내역",siteLocale) %></caption>
	<tr>
		<th class="th3"><%=StringUtil.getLocaleWord("L.입/출금일",siteLocale) %></th>
		<td class="td3">
			<%= HtmlUtil.getInputCalendar(request, true, "JIGEUB_DTE", "JIGEUB_DTE", simMap.getDefStr("JIGEUB_DTE",""), "") %>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.지급금액",siteLocale) %></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "JIGEUB_GUBUN", "JIGEUB_GUBUN", strCurGubunList, simMap.getDefStr("JIGEUB_GUBUN","KRW"), "class=\"select \" ") %>
			<input type="text" name="JIGEUB_COST" id="JIGEUB_COST" value="<%=StringUtil.getFormatCurrency(simMap.getString("JIGEUB_COST"),-1) %>" maxlength="20" onKeyUp="airCommon.getFormatCurrency(this,2,true)" style="width:230px" />
		</td>
	</tr>
	
	<tr>
		<th class="th3"><%=StringUtil.getLocaleWord("L.내역",siteLocale) %></th>
		<td>
			<textarea class="memo width_max" name="NAEYEOK" id="NAEYEOK" onblur="airCommon.validateMaxLength(this, 4000)" style="height:100px;"><%=simMap.getStringEditor("NAEYEOK") %></textarea>
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
				<jsp:param value="LMS/SS/BIYONG" name="typeCode" />
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
    	if(!StringUtil.isBlank(ss_biyong_uid)){
    	%>
    	<span class="ui_btn medium icon" style="float: right;"><span class="delete"></span><a href="javascript:void(0)" onclick="goBiyongDel();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
    	<%} %>
    	<span class="ui_btn medium icon" style="float: right;"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    </div>
</div>	

<script >
var goProc = function(){

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		
		var data = $("#saveForm").serialize();
		
		airCommon.callAjax("LMS_SS_MAS", "POPUP_WRITE_BIYONG_PROCESS",data, function(json){
			opener.getSimBiyongList<%=sol_mas_uid%>();
			window.close();
		});
	}
};

var goBiyongDel = function(){
	
	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>")){
		
		var data = {};
		data["SS_SIM_UID"] = "<%=simMap.getString("SS_SIM_UID")%>";
		//삭제할 BIYOUNG UID
		data["SS_BIYONG_UID"] = "<%=ss_biyong_uid%>";
		
		airCommon.callAjax("LMS_SS_MAS", "POPUP_DELETE_BIYONG_PROCESS",data, function(json){
			//opener.refreshWindow();
			opener.getSimBiyongList<%=sol_mas_uid%>();
			window.close();
			
		});
	}
}
</script>