<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>    
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap searchMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= searchMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= searchMap.getString(CommonConstants.PAGE_ROWSIZE);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults typeListResult 	= resultMap.getResult("SCH_TYPE_LIST");
	
	//-- 파라메터 셋팅
	String actionCode 		= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
	
	SQLResults		rsMas = resultMap.getResult("VIEW");
	
	BeanResultMap masMap = new BeanResultMap();
	if(rsMas != null && rsMas.getRowCount()> 0){
		masMap.putAll(rsMas.getRowResult(0));
	}
	
	//-- 상세보기 값 셋팅
	String scdl_uid				= masMap.getString("SCDL_UID");
	String temp_scdl_uid		 = StringUtil.getRandomUUID();
	
	String scdl_type_code		= masMap.getString("SCDL_TYPE_CODE");
	String scdl_type_name		= masMap.getString("SCDL_TYPE_NAME");
	String scdl_tit				= masMap.getString("SCDL_TIT");
	String scdl_plce			= masMap.getString("SCDL_PLCE");
	String scdl_memo			= masMap.getString("SCDL_MEMO");
	String scdl_bgn_date		= masMap.getDefStr("SCDL_BGN_DATE", searchMap.getString("SCHFROMDATE"));	
	String scdl_bgn_time		= masMap.getDefStr("SCDL_BGN_TIME", "09:00");	
	String scdl_end_date		= masMap.getDefStr("SCDL_END_DATE", searchMap.getString("SCHFROMDATE"));
	String scdl_end_time		= masMap.getDefStr("SCDL_END_TIME", "18:00");
	String scdl_noti_yn			= masMap.getDefStr("SCDL_NOTI_YN", "Y");
	String scdl_noti_term		= masMap.getDefStr("SCDL_NOTI_TERM", "3");
	String scdl_ins_grp_name	= masMap.getDefStr("SCDL_INS_GRP_NAME", loginUser.getGroupName());
	String scdl_ins_user_name	= masMap.getDefStr("SCDL_INS_USER_NAME", loginUser.getName());
	String scdl_ins_date		= masMap.getDefStr("SCDL_INS_DATE", DateUtil.getCurrentDate());

	String[] scdl_bgn_time_arr	= scdl_bgn_time.split(":");
	String[] scdl_end_time_arr	= scdl_end_time.split(":");
	String scdl_bgn_hour 	= scdl_bgn_time_arr[0];
	String scdl_bgn_min 		= scdl_bgn_time_arr[1];
	String scdl_end_hour 	= scdl_end_time_arr[0];
	String scdl_end_min 		= scdl_end_time_arr[1];
		
	//-- 코드정보 문자열 셋팅
	String typeCodestr 		= StringUtil.getCodestrFromSQLResults(typeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String notiTermCdStr 	= "Y|"+StringUtil.getLocaleWord("L.YES",siteLocale)+"^N|"+StringUtil.getLocaleWord("L.NO",siteLocale);

	String hourCodestr  	= "";
	for (Integer h = 0; h < 24; h++) {
		if (h != 0) hourCodestr += "^";
		
		String hh = StringUtil.leftPad(h.toString(), 2, "0");
		hourCodestr += hh +"|"+ hh;
	}
	String minuteCodestr  	= "";
	for (Integer m = 0; m < 60; m++) {
		if (m != 0) minuteCodestr += "^";
		
		String mm = StringUtil.leftPad(m.toString(), 2, "0");
		minuteCodestr += mm +"|"+ mm;
	}
	
	String 제목 = StringUtil.getLocaleWord("L.제목",siteLocale);
	String 등록자 = StringUtil.getLocaleWord("L.등록자",siteLocale);
	String 등록일 = StringUtil.getLocaleWord("L.등록일",siteLocale);
	String 기간 = StringUtil.getLocaleWord("L.기간",siteLocale);
	String 유형 = StringUtil.getLocaleWord("L.유형",siteLocale);
	String 알람 = StringUtil.getLocaleWord("L.알람",siteLocale);
	String 일전알람 = StringUtil.getLocaleWord("L.일전알람",siteLocale);
    String 장소 = StringUtil.getLocaleWord("L.장소",siteLocale);
	String 메모 = StringUtil.getLocaleWord("L.메모",siteLocale);
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
	
	if (frm.scdl_tit.value == "") {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, StringUtil.getScriptMessage("L.제목", siteLocale))%>");
		frm.scdl_tit.focus();
		return;
	}
	
	if (frm.scdl_bgn_date.value == "") {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, StringUtil.getScriptMessage("L.시작일", siteLocale))%>");
		frm.scdl_bgn_date.focus();
		return;
	}
	
	if (frm.scdl_end_date.value == "") {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, StringUtil.getScriptMessage("L.종료일", siteLocale))%>");
		frm.scdl_end_date.focus();
		return;
	}
	
	if (frm.scdl_bgn_date.value > frm.scdl_end_date.value) {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_REINPUT", siteLocale, StringUtil.getScriptMessage("L.종료일이시작일보다작습니다_종료일", siteLocale))%>");
		frm.scdl_end_date.focus();
		return;
	}
	
	if (frm.scdl_type_code.value == "") {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getScriptMessage("L.유형",siteLocale))%>");
		frm.scdl_type_code.focus();
		return;
	}
	
	if (frm.scdl_type_name.value == "") {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, StringUtil.getScriptMessage("L.유형의명칭",siteLocale))%>");
		frm.scdl_type_name.focus();
		return;
	}
	
	frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_PROC"; 
		
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		
		//--에디터 서브밋 처리
		airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
		var data = $(frm).serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			
			var url = "/ServletController?AIR_ACTION=<%=actionCode%>&AIR_MODE=LIST";
			location.href = url;
			
		});
	}	
		
}

/**
 * 유형 변경 이벤트 처리
 */
function changeScdlType(val, txt) {
	var cod = document.getElementById("scdl_type_code");
	var nam = document.getElementById("scdl_type_name");						
	if (val == "ZZ") {
		nam.style.display = "";
	} else {
		nam.style.display = "none";			
	}
	
	nam.value = (txt == undefined || txt == "" ? cod.options[cod.selectedIndex].text : txt);
}

/**
 * 시작 기간 변경 이벤트 처리
 */
function changeScdlBgnDte(val) {
	
	if(val != ""){
		$("#scdl_end_date").val(val);
	}
}

</script>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="temp_scdl_uid" value="<%=temp_scdl_uid%>" />
	<input type="hidden" name="scdl_uid" value="<%=scdl_uid%>" />
	<input type="hidden" name="scdl_sys_type_code" value="LMS" /><!-- 지우면 에러남 -->
	
	<table class="basic">	
	<tr>
		<th class="th2"><span class="ui_icon required"><%=제목 %></span></th>
		<td class="td2" colspan="3"><input type="text" name="scdl_tit" id="scdl_tit" value="<%=StringUtil.convertForInput(scdl_tit)%>" maxlength="120" class="text width_max" /></td>
	</tr>
	<tr>
		<th class="th4"><%=등록자 %></th>
		<td class="td4"><%=scdl_ins_grp_name +" "+ scdl_ins_user_name%></td>
		<th class="th4"><%=등록일 %></th>
		<td class="td4"><%=scdl_ins_date%></td>
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=기간 %></span></th>
		<td class="td2" colspan="3">
			<%=HtmlUtil.getInputCalendar(request, true, "scdl_bgn_date", "scdl_bgn_date", scdl_bgn_date, "onchange=\"changeScdlBgnDte(this.value)\" class='select'")%>
			<%=HtmlUtil.getSelect(request, true, "scdl_bgn_hour", "scdl_bgn_hour", hourCodestr, scdl_bgn_hour, "class='select' style=\"width:45px;\"")%>시
			<%=HtmlUtil.getSelect(request, true, "scdl_bgn_min", "scdl_bgn_min", minuteCodestr, scdl_bgn_min, "class='select' style=\"width:45px;\"")%>분
			~
			<%=HtmlUtil.getInputCalendar(request, true, "scdl_end_date", "scdl_end_date", scdl_end_date, "")%>
			<%=HtmlUtil.getSelect(request, true, "scdl_end_hour", "scdl_end_hour", hourCodestr, scdl_end_hour, "class='select' style=\"width:45px;\"")%>시
			<%=HtmlUtil.getSelect(request, true, "scdl_end_min", "scdl_end_min", minuteCodestr, scdl_end_min, "class='select' style=\"width:45px;\"")%>분
		</td>		
	</tr>
	
	<tr>
		<th class="th4"><span class="ui_icon required"><%=유형 %></span></th>
		<td class="th4">
			<%=HtmlUtil.getSelect(request, true, "scdl_type_code", "scdl_type_code", typeCodestr, scdl_type_code, "onchange=\"changeScdlType(this.value)\" class=\"select width_max_select\"")%>
			<input type="text" name="scdl_type_name" id="scdl_type_name" value="" class="text" style="width:200px; display:none" />
			<script>changeScdlType("<%=StringUtil.convertForJavascript(scdl_type_code)%>", "<%=StringUtil.convertForJavascript(scdl_type_name)%>")</script>		
		</td>
		<th class="th4"><%=알람 %></th>
		<td class="th4">
			<%=HtmlUtil.getSelect(request, true, "scdl_noti_yn", "scdl_noti_yn", notiTermCdStr, scdl_noti_yn, "onchange=\"changeScdlNotiYn(this.value)\" class='select'")%>
			<span id="scdl_noti_term_layer">
				&nbsp;(<input name="scdl_noti_term" id="scdl_noti_term" value="<%=StringUtil.convertForInput(scdl_noti_term)%>" type="TEXT" class="text" size="3" onkeyup="airCommon.validateNumber(this, this.value);" style="text-align: right" />
				<%=일전알람 %>)<span style="color:red;">※최대 999일까지 설정 가능</span>
			</span>
			<script>
				changeScdlNotiYn("<%=StringUtil.convertForJavascript(scdl_noti_yn)%>");
				
				function changeScdlNotiYn(val) {
					var layer = document.getElementById("scdl_noti_term_layer");
					var term = document.getElementById("scdl_noti_term");
					
					if (val == "N") {
						layer.style.display = "none";
						term.value = "";
					} else {
						layer.style.display = "";
						term.value = "<%=StringUtil.convertForJavascript(scdl_noti_term)%>";
					}
				}
			</script>
		</td>
	</tr>
	<tr>
		<th class="th2"><%=장소 %></th>
		<td class="td2" colspan="3"><input type="text" name="scdl_plce" id="scdl_plce" value="<%=StringUtil.convertForInput(scdl_plce)%>" maxlength="120" class="text width_max" /> </td>
	</tr>
	
	<tr>
		<th class="th2"><%=메모%></th>
		<td class="td2" colspan="3">
			<textarea name="scdl_memo" rows="5" onblur="airCommon.validateMaxLength(this, 4000);" class="scdl_memo width_max" style="height:220px;"><%=StringUtil.convertForInput(scdl_memo)%></textarea>
		</td>
	</tr>		
	</table>

	<div class="buttonlist">
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doSubmit(document.form1);"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
		<span class="ui_btn medium icon"><span class="list"></span><a href="javascript:void(0)" onclick="goList(document.form1);"><%=StringUtil.getLocaleWord("B.LIST",siteLocale)%></a></span>
	</div> 
</form>