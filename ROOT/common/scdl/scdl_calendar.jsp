<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="org.json.simple.*" %>
<%@ page import="java.lang.reflect.*" %>
<%@ page import="java.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	
	String LAW_DEPT_LISTStr		= StringUtil.getCodestrFromSQLResults(resultMap.getResult("LAW_DEPT_LIST"), "CODE,LANG_CODE", ""); //계약유형
	String USER_LISTStr		= StringUtil.getCodestrFromSQLResults(resultMap.getResult("USER_LIST"), "LOGIN_ID,NAME_KO", "|"+StringUtil.getLocaleWord("L.CBO_ALL", siteLocale)); //계약유형
%>
	<table class="box table_cover" style="position:fixed; top:50px;">
		<colgroup>
			<col width="auto">
			<col width="100px">
			<col width="100px">
			<col width="170px">
		</colgroup>
		<tr>
			<td></td>
			<th style="text-align:right; padding:5px;"><%=StringUtil.getLocaleWord("L.담당자", siteLocale) %></th>
			<%-- <td style="text-align:left; padding:5px;" class="input-target">
				<%=HtmlUtil.getSelect(request, true, "group_code", "group_code", LAW_DEPT_LISTStr, loginUser.getGroupCode(), "onChange=\"getDamDangList('damdang_id', this.value);\" class='width_max'") %>
			</td> --%>
			<td style="text-align:left; padding:5px;" class="input-target">
				<%=HtmlUtil.getSelect(request, true, "damdang_id", "damdang_id", USER_LISTStr, loginUser.getLoginId(), "class='width_max'") %>
			</td>
			<td></td>
		</tr>
	</table>
<div id='calendar'></div>
<link href='/common/_lib/fullcalendar/fullcalendar.css' rel='stylesheet' />
<link href='/common/_lib/fullcalendar/fullcalendar.print.css' rel='stylesheet' media='print' />
<style>
.category-wrap {
	line-height:22px;
	float:left;
	margin-right:10px;
	padding-left:5px;
	padding-right:5px;
	width:150px;
	font-size:12px;
	cursor:pointer;
}
#target { width:850px; }
#calendar {
	margin: 0px auto;
	padding-top:10px;
	border-top:1px solid #cecece;
	border-left:1px solid #cecece;
	border-right:1px solid #cecece;
	border-bottom:1px solid #cecece;
	background:#fafafa;
}
</style>
<script src='/common/_lib/fullcalendar/lib/moment.min.js'></script>
<script src='/common/_lib/fullcalendar/fullcalendar.js'></script>
<script src='/common/_lib/fullcalendar/gcal.js'></script>
<script src='/common/_lib/fullcalendar/lang-all.js'></script>
<script type="x-underscore-template" id="tpl-category">
<@ _.each(data, function(item, idx) { @>
	<div class="category-wrap" data-index="<@= idx @>">
		<i class="fa <@= item.checked ? 'fa-check-square' : 'fa-square-o' @>"></i> <@= item.title @>
	</div>
<@})@>
</script>
<script type="text/javascript" src="common/_lib/underscore-min.js"></script>
<script type="x-jquery-tmpl" id="preview-tmpl_DU">
<div style="position:absolute;z-index:9000;padding:6px;border:3px solid #eee;background-color:#fff;width:400px;" id="preview-layer">
<table class="basic">
	<tr height="20"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.담당자", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${damdang_name}</td>
	</tr>
	<tr height="20"> 
		<th class="td" align="center" width="70"><%=StringUtil.getLocaleWord("L.관리번호", siteLocale)%></th>
		<td class="margin_comment4" align="left"  colspan="3">\${gwanri_no}</td>
	</tr>
	<tr height="20"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.제목", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${scdl_tit}</td>
	</tr>
	<tr height="20"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.종류", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${scdl_type_name}</td>
	</tr>
	<tr height="20"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.시간", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${scdl_time}</td>
	</tr>
	<tr height="20"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.장소", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${scdl_plce}</td>
	</tr>
	<tr height="25"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.소송가액", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${sosongga_cost}</td>
	</tr>
</table>
</div>
</script>
<script type="x-jquery-tmpl" id="preview-tmpl">
<div style="position:absolute;z-index:9000;padding:6px;border:3px solid #eee;background-color:#fff;width:400px;" id="preview-layer">
<table class="basic">
	<tr height="25"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.일정종류", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${scdl_type_name}</td>
	</tr>
	<tr height="25"> 
		<th class="td" align="center" width="70"><%=StringUtil.getLocaleWord("L.관리번호", siteLocale)%></th>
		<td class="margin_comment4" align="left"  colspan="3">\${gwanri_no}</td>
	</tr>
	<tr height="25"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.제목", siteLocale)%></th>
		<td class="td" align="left" colspan="3">\${scdl_tit}</td>
	</tr>
	<tr height="25"> 
		<th class="th" align="center"><%=StringUtil.getLocaleWord("L.메모", siteLocale)%></th>
		<td class="td" align="left" colspan="3">{{html airCommon.convertForView(scdl_memo)}}</td>
	</tr>
</table>
</div>
</script>
<script>
function getDamDangList(targetId, val){
	var data = {};
	data["GROUP_CODE"] = val;
	airCommon.callAjax("SYS_USER", "JSON_LIST",data, function(json){
		
		airCommon.initializeSelectJson(targetId, json.rows, "|-- 전체 --", "LOGIN_ID", "NAME_KO");
	});
	
}
$(document).ready(function() {
	_.templateSettings = {
		interpolate: /\<\@\=(.+?)\@\>/gim,
		evaluate: /\<\@(.+?)\@\>/gim,
		escape: /\<\@\-(.+?)\@\>/gim
	};
	
	<%-- (function createUserSelectBox() {
		var currentUser = "<%=loginUser.getLoginId() %>";
		var userList = <%=resultMap.get("userListJson")%>;
		var target = $('.input-target');
		var el = $("<select />").attr({
			id:"damdang_id",
			name:"damdang_id"
		});
		for ( var i = 0, n = userList.length; i < n; i++ ){
			var t0 = $("<option />").attr("value", userList[i].LOGIN_ID).text(userList[i].NAME_KO);
			if ( currentUser == userList[i].LOGIN_ID ) t0.attr("selected","selected");
			el.append(t0);
		}
		target.append(el);
	})(); --%>
	
	$("#damdang_id").change(function(){
		$('#calendar').fullCalendar('refetchEvents');
	});
	
	$("#group_code").change(function(){
		$('#calendar').fullCalendar('refetchEvents');
	});
	
	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay'
		},
		lang:'<%=siteLocale.toLowerCase()%>', //'ko' 대림산업의 경우 코드페이지가 UTF-8을 사용함으로 한글이 깨짐. 
		// 인자로 start, end date가 3달치로 패러미터로 나간다.
		events:{
			url:'ServletController?AIR_ACTION=CMM_SCDL&AIR_MODE=CALENDAR_DATA'
			/* ,data:'' */
			, data:function() {
				return {
					uids: (function() {
						return $("#damdang_id option:selected").val();
					})()
					,dept:(function() {
						return $("#group_code option:selected").val();
					})()
				}
			}
		},
		eventClick: function(event) {
			//airIps.popupTepIndex(event.doc_mas_uid || "", event.sol_mas_uid, event.doc_flow_uid || "");
			//airIps.popupRelSelect(event.last_doc_mas_uid, event.sol_mas_uid, "");
			if(event.url){
				
// 				var org_actoin = "LMS_"+event.gbn+"_TEP";
// 				var url = "/ServletController";
// 				url += "?AIR_ACTION=LMS_REL_MAS";
// 				url += "&AIR_MODE=REL_TEP_INDEX";
// 				url += "&sol_mas_uid="+event.sol_mas_uid;
// 				url += "&org_action="+org_actoin;
// 				url += "&org_mode=POPUP_INDEX";
// 				url += "&gwanri_mas_uid="+event.gwanri_mas_uid;
// 				url += "&title_no="+event.gwanri_no;
				
				airCommon.openWindow(event.url, "1024", "650", "POPUP_VIEW_FORM", "yes", "no", "");
			}
			return false;
		},
		eventMouseover: function(event, jsEvent, view) {
			var $target = $(jsEvent.target);
			var offset = $target.offset();
			var maxwidth = $(window).width();
			var id = "preview-tmpl";
			if(event.scdl_type_code == "DU")id += "_DU";
			$("#"+id).tmpl(event).appendTo("body");
			$("#preview-layer").css({
				top:(offset.top + 63) + 'px',
				left:(((offset.left + 400) > maxwidth) ? (offset.left - 400) : offset.left) +'px'
			});
		},
		eventRender: function(event, element, view) {
			console.log(event)
			console.log(element)
			console.log(view)
		},
		eventMouseout: function(event, jsEvent, view) {
			$("#preview-layer").remove();
		}/* ,
		loading: function(bool) {
			if ( bool ) airCommon.showBackDrop();
			else airCommon.hideBackDrop();
		} */
	});
});
</script>