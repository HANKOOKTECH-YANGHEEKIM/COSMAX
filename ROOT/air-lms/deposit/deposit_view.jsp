<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	SQLResults viewResult = resultMap.getResult("VIEW");
	BeanResultMap viewMap = new BeanResultMap();

	if(viewResult != null && viewResult.getRowCount()> 0){
		viewMap.putAll(viewResult.getRowResult(0));
	}
	
	String sol_mas_uid = viewMap.getString("SOL_MAS_UID");
	
	//-- 파라메터 셋팅
	String action_code = resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code	= resultMap.getString(CommonConstants.MODE_CODE);
	
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();

	//-- 코드정보 문자열 셋팅
	String sHOESA_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sDPT_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DPT_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sYUHYEONG_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sBEOBWEON_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("BEOBWEON_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sDEPOSIT_BEOBWEON_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DEPOSIT_BEOBWEON_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));	
	String sSANGTAE_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SANGTAE_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));

	String att_master_doc_id = viewMap.getString("DEPOSIT_MAS_UID");
	
	boolean isAuths = false;
	
	if(
			loginUser.getLoginId().equals(viewMap.getString("DAMDANGJA_ID")) ||
			loginUser.isUserAuth("LMS_SSM") ||
			LmsUtil.isSysAdminUser(loginUser)
	){
		isAuths = true;
	}
%>
<form name="form1" id="form1" method="POST">
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=mode_code%>" />
<input type="hidden" name="current_mode_code" value="<%=mode_code%>" />
	<table class="basic">
		<caption>
			<%=StringUtil.getLocaleWord("L.공탁내역", siteLocale) %>
			<div style="float:right;">
				<span class="ui_btn small icon"><span class="print"></span><a href="javascript:void(0)" onclick="window.print();"><%=StringUtil.getLocaleWord("B.PRINT",siteLocale)%></a></span>
			</div>
		</caption>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<td class="td4"><%=viewMap.getString("REG_DTE") %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<td class="td4"><%=viewMap.getString("REG_NAM") %></td>
		</tr>	
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.사건명",siteLocale) %></th>
			<td class="td4">
				<%=viewMap.getString("DEPOSIT_TIT") %>
			</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁서송달일",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("DELIVERY_DTE") %>
		</td>
		</tr>
	<tr>
	    <th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("HOESA_NAM") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th>
		<td class="td4">
			<%= viewMap.getString("YUHYEONG_COD").endsWith("ZZ") ? "기타<br />("+viewMap.getString("YUHYEONG_NAM")+")" : viewMap.getString("YUHYEONG_NAM") %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁번호",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("DEPOSIT_NO") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁법원",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("DEPOSIT_BEOBWEON_NAM") %>
		</td>	
	</tr>		
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁자",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("DEPOSIT_MAN") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁일자",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("DEPOSIT_DTE") %>
		</td>	
	</tr>			
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁금액",siteLocale)%></th>
		<td class="td4" colspan="3">
			KRW <%=StringUtil.getFormatCurrency(viewMap.getString("DEPOSIT_COST"), -1) %>
		</td>	
	</tr>		
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관할법원",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("BEOBWEON_NAM") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.사건번호",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("SAGEON_NO") %>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.현업부서",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=viewMap.getString("REL_DPT_NAM") %>
		</td>	
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_소송",siteLocale)%></th>
		<td class="td4" colspan="3">
			<table class="list">
		    <%
			String[] REL_SOL = jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS");
			if(REL_SOL != null && REL_SOL.length > 0){
		 	%>
    	    <tr>
		        <th width="12%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
		        <th width="13%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
		        <th width="75%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
		    </tr>
   		   	<%
				for(int i=0; i< REL_SOL.length; i++){
					String funNm = ""+StringUtil.capitalize(jsonMap.getArrStr("LMS_PATI_REL_GUBUN")[i])+"";
			%>
			<tr onclick="airLms.goGwanRyeonPopup('<%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN")[i]%>','<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i] %>')" style="cursor:pointer;">
		        <td align="center"><%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN_NAME")[i]%></td>
		        <td align="center"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE_NO")[i]%></td>
		        <td align="left"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE")[i]%></td>
		    </tr>
			<%
				}
			}
			%>
            </table>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=StringUtil.convertForView(viewMap.getString("DAMDANGJA_NAM")) %>	
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁원인사실",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=viewMap.getString("DEPOSIT_WONIN") %>
		</td>	
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.상태",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("SANGTAE01_NAM") %><%=viewMap.getString("SANGTAE02_NAM") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.종결일",siteLocale)%></th>
		<td class="td4">
			<%=viewMap.getString("END_DTE") %>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.처리결과",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=viewMap.getString("RESULT") %>
		</td>	
	</tr>	
	<tr>
<%String requiredYn = "Y"; %>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th>
		<td class="td4" colspan="3">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_VIEW" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/DEPOSIT/PUT" name="typeCode" />
			</jsp:include>
		</td>
	</tr>	
	</table>

	<div class="buttonlist">
		<div class="right">
<% if(isAuths){ %>
			<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:goWriteForm(document.form1);"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:goMasDelete<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
<% } %>
		</div>
	</div>
</form>
<script type="text/javascript">
var setBunryu = function(){ 
	$("#bunryu_nam").val($("#bunryu_cod :selected").text()); 
};

/**
 * 목록 페이지로 이동
 */	
function goList(frm) {	
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_GOLIST",siteLocale)%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "LIST";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}
}

var goWriteForm = function(){
	var url = "/ServletController";
	url += "?AIR_ACTION=LMS_DEPOSIT";
	url += "&AIR_MODE=WRITE_FORM";
	url += "&SOL_MAS_UID=<%=viewMap.getString("SOL_MAS_UID") %>";
	url += "&GB_DOC_MAS_UID=<%=viewMap.getString("GB_DOC_MAS_UID") %>";
	
	airCommon.openWindow(url, "1024", "650", "LMS_DEPOSIT_WRITE_FORM", "yes", "yes", "");			
};

function goMasDelete<%=sol_mas_uid%>() {		
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
	
	if(confirm(msg)){
		var data = {};
		data["sol_mas_uid"] = "<%=sol_mas_uid%>";
		
		airCommon.callAjax("LMS_DEPOSIT", "DELETE_PROC", data, function(json){
			$("#listTabsLayer").tabs('close','<%=viewMap.getString("GWANRI_NO")%>');
			try{
				opener.doSearch();
			}catch(e){
			}
			window.close();
		});
	}
}	
</script>