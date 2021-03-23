<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String callbackFunction		= requestMap.getString("callbackFunction");
	
	String yyyy					= requestMap.getString("YYYY");
	String mm					= requestMap.getString("MM");
	String currentDate			= requestMap.getString("CURRENTDATE");
		
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	SQLResults listResult 		= resultMap.getResult("LIST");
	
	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
%>
<script type="text/javascript">
/**
 * 이전 해로 이동
 */
function goPrevYear() {
	var frm 	= document.form1;
	
	var yyyy	= frm.yyyy.value;
	
	frm.yyyy.value	= parseInt(yyyy, 10) - 1;
	frm.submit();
}

/**
 * 다음 해로 이동
 */
function goNextYear() {
	var frm 	= document.form1;
	
	var yyyy	= frm.yyyy.value;
	
	frm.yyyy.value	= parseInt(yyyy, 10) + 1;
	frm.submit();
}

/**
 * 이전 달로 이동
 */
function goPrevMonth() {
	var frm 	= document.form1;
	
	var yyyy	= frm.yyyy.value;
	var mm 		= frm.mm.value;
	
	if (mm == "01") {
		yyyy	= parseInt(yyyy, 10) - 1;
		mm 		= "12";	
	} else {
		mm		= "0"+ (parseInt(mm, 10) - 1);
		mm		= mm.substr(mm.length - 2, 2);
	}
	frm.yyyy.value	= yyyy;
	frm.mm.value 	= mm;
	frm.target="_self";
	frm.submit();
} 


/**
 * 다음 달로 이동
 */
function goNextMonth() {
	var frm 	= document.form1;
	
	var yyyy	= frm.yyyy.value;
	var mm 		= frm.mm.value;
	
	if (mm == "12") {
		yyyy	= parseInt(yyyy, 10) + 1;
		mm 		= "01";	
	} else {
		mm		= "0"+ (parseInt(mm, 10) + 1);
		mm		= mm.substr(mm.length - 2, 2);
	}
	
	frm.yyyy.value	= yyyy;
	frm.mm.value 	= mm;
	frm.submit();
}


/**
 * 사용자 선택 이벤트 처리
 */
function doSelect(date) {
// 	var frm 		= document.form1;
	
<%-- 	var mode_code	= frm.<%=CommonConstants.MODE_CODE%>.value; --%>
// 	var func		= unescape(frm.callbackFunction.value);
	
	mainScdl_goList(date);
// 	try {
// 	if (func != "") {
// 		var temp_arr = date.split("-");
// 		func = func.replace(/\[DATE\]/g, date);
// 		func = func.replace(/\[YYYY\]/g, temp_arr[0]);
// 		func = func.replace(/\[MM\]/g, temp_arr[1]);
// 		func = func.replace(/\[DD\]/g, temp_arr[2]);
		
// 		if (mode_code.indexOf("POPUP_") > -1) {
// 			if (eval("opener."+ func) != false) {
// 				//-- 콜백함수 실행결과가 false가 아니면 현재 창을 닫음 (※ false일 경우 다시 선택할 수 있게 구현한 것임)
// 				self.close();
// 			}
// 		} else {
// 			eval("parent."+ func);			
// 		}
// 	}
// 	} catch (e) {
// 		alert(e.message);
// 	}
}

function openViewSchedule(scdlUid){
	var url = "/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=VIEW";
	url += "&scdl_uid="+ scdlUid;
	
	airCommon.openWindow(url, "1024", "450", "popupScheduleList", "yes", "yes");	
}

var openCal = function(){
	var url = "/ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=POPUP_CALENDAR";
	
	airCommon.openWindow(url, "1024", "900", "CALENDAR", "yes", "yes");
}
/**
 * 일정 보여주기
 */
function mainScdl_goList(date) {
	airCommon.popupScdlList("", date, date);
}
</script>
<link rel="stylesheet" type="text/css" href="/air-lms/_css/themes/default/scdl.css" />
<form name="form1" method="post" action="/ServletController" style="display:block;margin:0;padding:0">	
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="yyyy" id="yyyy" value="<%=yyyy%>" />
	<input type="hidden" name="mm" id="mm" value="<%=mm%>" />
	<input type="hidden" name="currentDate" id="currentDate" value="<%=currentDate%>" />
	
	<div id="scdlSelectLayer">
		<span class="panel_header" style="margin-left:10px;cursor:pointer;" onclick="openCal()" ><%=StringUtil.getLocaleWord("L.일정", siteLocale) %>(<%=StringUtil.getLocaleWord("L.큰화면", siteLocale) %>)</span>
		<span class="date">
<%-- 
			<a href="#"  onclick="goPrevMonth()" onfocus="this.blur();"><img src="/air-lms/_css/themes/hanmi/images/main/arrow_left.png"></a>
			<strong style="cursor: pointer;" onclick="openCal()"><%=yyyy%>.<%=mm%></strong>
			<a href="#" onclick="goNextMonth()" onfocus="this.blur();"><img src="/air-lms/_css/themes/hanmi/images/main/arrow_right.png"></a> 
--%>
			<a onclick="goPrevMonth()" onfocus="this.blur();" style="cursor:pointer;"><</a>
			<strong><%=yyyy%>.<%=mm%></strong>
			<a onclick="goNextMonth()" onfocus="this.blur();" style="cursor:pointer;">></a>
		</span>
<%-- 
			<table class="scdlSelector">
			<tr>
				<td width="10%" align="left"><a href="#" class="goPrevYear" title="<%=StringUtil.getLocaleWord("L.이전해",siteLocale)%>" onclick="goPrevYear()" onfocus="this.blur();"></a></td>
				<td width="10%" align="right"><a href="#" class="goPrevMonth" title="<%=StringUtil.getLocaleWord("L.이전달",siteLocale)%>" onclick="goPrevMonth()" onfocus="this.blur();"></a></td>
				<td width="*" align="center"><%=yyyy%>.<%=mm%><span class="ui_btn small icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="openCal()">달력</a></span></td>
				<td width="10%" align="left"><a href="#" class="goNextMonth" title="<%=StringUtil.getLocaleWord("L.다음달",siteLocale)%>" onclick="goNextMonth()" onfocus="this.blur();"></a></td>
				<td width="10%" align="right"><a href="#" class="goNextYear" title="<%=StringUtil.getLocaleWord("L.다음해",siteLocale)%>" onclick="goNextYear()" onfocus="this.blur();"></a></td>
			</tr>
		</table>
--%>
		<table class="scdlCalendar">
			<colgroup>
				<col width="15%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="14%" />
				<col width="15%" />
			</colgroup>
			<thead>
			<tr>
				<th class="sun"><%=StringUtil.getLocaleWord("L.일",siteLocale)%></th>
				<th><%=StringUtil.getLocaleWord("L.월",siteLocale)%></th>
				<th><%=StringUtil.getLocaleWord("L.화",siteLocale)%></th>
				<th><%=StringUtil.getLocaleWord("L.수",siteLocale)%></th>
				<th><%=StringUtil.getLocaleWord("L.목",siteLocale)%></th>
				<th><%=StringUtil.getLocaleWord("L.금",siteLocale)%></th>
				<th class="sat"><%=StringUtil.getLocaleWord("L.토",siteLocale)%></th>
			</tr>
			</thead>
			<tbody>
			<%
				Integer day = 1;
				while (day <= DateUtil.lastDay(Integer.parseInt(yyyy, 10), Integer.parseInt(mm, 10))) {
					out.println("\n <tr>");
					for (int i = 1; i <= 7; i++) {
						String dd	= StringUtil.leftPad(day.toString(), 2, "0");
						String date = yyyy +"-"+ mm +"-"+ dd;
						String week_class = "";
						if (i == 1) week_class = " class=\"sun\"";
						else if (i == 7) week_class = " class=\"sat\"";
						
						try {
							int which_day	= DateUtil.whichDay(date);
							////System.out.println("##### ["+ date +"] which_day => "+ which_day);
							if (i == which_day) {
								int schedule_cnt = 0;
								if (listResult != null && listResult.getRowCount() > 0) {
									schedule_cnt = listResult.getInt(0, "CNT_"+ dd);
								}
								
								if (date.equals(currentDate)) {
									//-- 선택된 날짜와 같을 경우
									out.println("\n  <td><a id=\"date_"+ date +"\" title=\"총 "+ schedule_cnt +"건의 일정이 있습니다.\" class=\"current\" onclick=\"doSelect('"+ date +"');\" style='cursor:pointer;'><span>"+ day +"</span></a></td>");	
								} else {
									//-- 그밖의 날짜일 경우 스케쥴 유무에 따라 스타일을 다르게 표시!
									String date_class = (schedule_cnt == 0 ? week_class : " class=\"scheduled\"");
									
									out.println("\n  <td><a id=\"date_"+ date +"\" title=\"총 "+ schedule_cnt +"건의 일정이 있습니다.\""+ date_class +" onclick=\"doSelect('"+ date +"');\" style='cursor:pointer;'><span>"+ day +"</span></a></td>");
								}
								
								day++;
							} else {
								//-- 시작일 앞 요일일 경우 빈칸만 출력!
								out.println("\n  <td></td>");
							}
						} catch (Exception ex) {
							//-- 마지막 날짜를 초과했을 경우 빈칸만 출력!
							out.println("\n  <td></td>");
						}
					}
					out.println("\n </tr>");
				}
			%>			
			</tbody>
		</table>
	</div>	
	
<% if (modeCode.indexOf("POPUP_") > -1) { //팝업 모드일 경우에만 닫기 버튼 보여주기 %>	
	<div class="buttonlist">
		<input type="button" name="btnClose" class="btn70" value="<%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%>" onclick="self.close();" />
	</div>
<% } %>
</form>  