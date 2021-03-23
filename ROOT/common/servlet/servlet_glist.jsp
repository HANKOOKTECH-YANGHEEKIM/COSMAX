<%--
  - Author : Kang, Se Won
  - Date : 2016.05.04
  -
  - @(#)
  - Description : 법무시스템 계약리스트
  --%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="org.json.simple.*"%>
<%@page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@page import="com.emfrontier.air.common.util.HtmlUtil" %>
<%@page import="com.emfrontier.air.common.util.StringUtil" %>
<%
    SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
    String siteLocale = CommonProperties.getSystemDefaultLocale();

    if (loginUser != null) {
    	siteLocale = loginUser.getSiteLocale();
    }

    String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
    String CONTENT_PATH = (String)request.getAttribute(CommonConstants.CONTENT_PATH);
    String popupContentName  = StringUtil.unescape(StringUtil.convertNull(request.getParameter("popupContentName")));

    //-- 검색값 셋팅
    BeanResultMap requestMap     = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);

    //-- 결과값 셋팅
    BeanResultMap resultMap             = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	String actionCode           = resultMap.getString(CommonConstants.ACTION_CODE);
    String modeCode             = resultMap.getString(CommonConstants.MODE_CODE);
    String contentName          = (String)StringUtil.convertNull(request.getAttribute(CommonConstants.CONTENT_NAME));

    String jsonDataUrl = "/ServletController"
            + "?AIR_ACTION="+ actionCode
            + "&AIR_MODE=JSON_LIST";
%>
<script type="text/javascript">
 /**
  * 검색 수행
  */
 function doSearch(frm, isCheckEnter) {
 	if (isCheckEnter && event.keyCode != 13) {
         return;
     }

 	getList(frm);
 }

 /**
  * 검색항목 초기화
  */
 function doReset(frm) {
 	if (confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale, "L.초기화")%>")) {
 		frm.reset();
 	}
 }

/*
 * 엑셀다운로드
 */
function doExcelDown(frm){
	frm.action = "/ServletController";
	frm.<%=CommonConstants.ACTION_CODE%>.value = "<%=actionCode%>";
	frm.<%=CommonConstants.MODE_CODE%>.value = "JSON_EXCEL";
	frm.target = "airBackgroundProcessFrame";
	frm.submit();
}
var setUpdate = function(uuid){
	var hiddenData = $("input:hidden[data-uid='"+uuid+"']");
	$(hiddenData).each(function(i,d){
		$("#"+$(this).attr("name")).val($(this).val());
	});
}

/**
 * 신규작성 페이지로 이동
 */
var doSubmit = function(frm,saveMode) {

	if(chkVal(saveMode)){
		frm.<%=CommonConstants.MODE_CODE%>.value="AJAX_WRITE_PROC";
		$("#saveMode").val(saveMode);
		if("WRITE" == saveMode){
			$("#UUID").val(airCommon.getRandomUUID());
		}
		$.ajax({
			url: "/ServletController"
			, type: "POST"
			, async: true
			, cache: false
			, data: $(frm).serialize()
			, dataType: "json"
		}).done(function(){
			alert ("<%=StringUtil.getScriptMessage("M.ALERT_DONE",siteLocale,StringUtil.getScriptMessage("L.처리", siteLocale))%>");
			getList(document.form1);
		}).fail(function(){
			alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
		});
	}
}
var chkVal = function(saveMode){
	var rtn = false;
	if($("#ACTION_CODE").val() == ""){
		alert ("<%=StringUtil.getLocaleWord("M.ALERT_INPUT",siteLocale,"ACTION CODE")%>");
		return;
	}
	if($("#MODE_CODE").val() == ""){
		alert ("<%=StringUtil.getLocaleWord("M.ALERT_INPUT",siteLocale,"MODE CODE")%>");
		return;
	}

	if("WRITE" == saveMode){
		var url="/ServletController";
		url += "?<%=CommonConstants.ACTION_CODE%>=<%=actionCode%>";
		url += "&<%=CommonConstants.MODE_CODE%>=JSON_DATA";
		url += "&ACTION="+$("#ACTION_CODE").val();
		url += "&MODE="+$("#MODE_CODE").val();
		$.ajax({
			url: url
			, type: "POST"
			, async: false
			, cache: false
		}).done(function(data){
			if(data.length > 0){
				alert("동일한 Action/Mode code가 존재합니다.");
			}else{
				rtn = true;
			}
		}).fail(function(){
			alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
		});
		return rtn;
	}else{
		return true;
	}
}

var getList = function(frm){
	frm.<%=CommonConstants.MODE_CODE%>.value="JSON_DATA";
	$.ajax({
		url: "/ServletController"
		, type: "GET"
		, async: true
		, cache: false
		, dataType: "json"
		, data: $(frm).serialize()
		,error:function(request,status,error){
		    alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		   }

	}).done(function(data){
		$("#ServletBody").html("");
		$("#servletTmpl").tmpl(data).appendTo($("#ServletBody"));
	}).fail(function (jqXHR, textStatus, errorThrown) {
		if (console && console.error) {
			console.error('jQuery Ajax 처리 오류 발생', errorThrown);
			var msg = (errorThrown + '').replaceAll('\n', '').replaceAll('\r', '');
			//window.lastJson = jqXHR.responseText;
			if (msg.indexOf('SyntaxError: Unexpected token  in JSON') >= 0	// Chrome
					|| msg.indexOf('SyntaxError: JSON.parse: bad control character in string') >= 0		// Firefox
					|| msg.indexOf('SyntaxError: 유효하지 않은 문자입니다')	>= 0				// IE11
			) {
				console.error('이 오류가 발생할 경우 응답받은 JSON 문자열이 정상적으로 파싱할 수 있는 형태가 아닌 경우입니다.\nJSON 문자열은 {"키":"값"} 형태이어야 하며, 값에는 캐리지리턴이나 "가 포함되어선 안됩니다.\n아래 서버에서의 응답을 복사하여 https://jsonlint.com/ 에서 확인해보세요.')
				console.log(jqXHR.responseText);
			}
		}
	});
}

var doSysAttch = function(){
	$.ajax({
		url: "/ServletController"
		, type: "POST"
		, dataType: "json"
		, data: {
				"AIR_ACTION":"<%=actionCode%>",
				"AIR_MODE":"SYS_APPEND",
		}

	})
	.done(function(data) {
		alert("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT_DONE", siteLocale) %>");

    })
    .fail(function() {
    	// 도중 에러가 발생했습니다.
        alert("<%=StringUtil.getScriptMessage("M.처리중_오류발생",siteLocale, StringUtil.getLocaleWord("L.수정", siteLocale))%>");
    });
}

$(function(){
	
});
 </script>
 <script id="servletTmpl" type="text/html">
			<tr>
				<td><a href="javascript:void(0);" onClick="setUpdate('\${UUID}')">\${ACTION_CODE}</a>
					<input type="hidden" data-uid="\${UUID}" name="UUID" value="\${UUID}"/>
					<input type="hidden" data-uid="\${UUID}" name="ACTION_CODE" value="\${ACTION_CODE}"/>
					<input type="hidden" data-uid="\${UUID}" name="MODE_CODE" value="\${MODE_CODE}"/>
					<input type="hidden" data-uid="\${UUID}" name="AUTH_CODES" value="\${AUTH_CODES}"/>
					<input type="hidden" data-uid="\${UUID}" name="TEMPLATE_PATH" value="\${TEMPLATE_PATH}"/>
					<input type="hidden" data-uid="\${UUID}" name="CLASS_PATH" value="\${CLASS_PATH}"/>
					<input type="hidden" data-uid="\${UUID}" name="CONTENT_PATH" value="\${CONTENT_PATH}"/>
					<input type="hidden" data-uid="\${UUID}" name="REDIRECTION_CODE" value="\${REDIRECTION_CODE}"/>
					<input type="hidden" data-uid="\${UUID}" name="DESC_STR" value="\${DESC_STR}"/>
					<input type="hidden" data-uid="\${UUID}" name="LANG_CODE" value="\${LANG_CODE}"/>
				</td>
				<td>\${MODE_CODE}</td>
				<td>\${DESC_STR}</td>
				<td>\${LANG_CODE}</td>
				<td style="text-align:center;"><a href="/ServletController?AIR_ACTION=\${ACTION_CODE}&AIR_MODE=\${MODE_CODE}" target="_blank">보기</a></td>
			</tr>
</script>
<div id="listTabsTools-LIST">
	<a href="javascript:void(0)" onclick="doSearch(document.form1)" class="icon-mini-refresh"></a>
</div>

<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="Servlet List" style="padding-top:5px">
<form id="form1" name="form1" method="post" onsubmit="return false;">
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<div class="table_cover">
		<table class="box">
		<tr>
			<td class="corner_lt"></td><td class="border_mt"></td><td class="corner_rt"></td>
		</tr>
		<tr>
			<td class="border_lm"></td>
			<td class="body">
				<table>
					<colgroup>
						<col width="10%" />
						<col width="35%" />
						<col width="10%" />
						<col width="35%" />
						<col width="10%" />
					</colgroup>
					<tr>
						<th>Action code</th>
						<td>
							<input type="text" name="schActionCd" id="schActionCd" class="text width_max" onkeydown="doSearch(document.form1, true)" maxlength="100" />
						</td>
						<th>Mode code</th>
						<td>
							<input type="text" name="schModeCd" id="schModeCd" class="text width_max" onkeydown="doSearch(document.form1, true)" maxlength="100" />
						</td>
						<td rowspan="3">
							<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
							<span class="ui_btn medium icon" id=""><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
						</td>
					</tr>
					<tr>
						<th>Class</th>
						<td>
							<input type="text" name="schClass" id="schClass" class="text width_max" onkeydown="doSearch(document.form1, true)" maxlength="200" />
						</td>
						<th>JSP</th>
						<td>
							<input type="text" name="schContent" id="schContent" class="text width_max" onkeydown="doSearch(document.form1, true)" maxlength="200" />
						</td>
					</tr>
					<tr>
						<th>Servlet Name</th>
						<td colspan="3">
							<input type="text" name="schContentNm" id="schContentNm" class="text width_max" onkeydown="doSearch(document.form1, true)" style="width:98.3%;" maxlength="200" />
						</td>
					</tr>
				</table>
			</td>
			<td class="border_rm"></td>
		</tr>
		<tr>
			<td class="corner_lb"></td><td class="border_mb"></td><td class="corner_rb"></td>
		</tr>							
		</table>
	</div>
</form>
	<br />
<form name="form2" method="post">
		<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	    <input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
		<input type="hidden" name="saveMode" id="saveMode" value=""/>
		<input type="hidden" name="UUID" id="UUID" value=""/>
		<div class="table_cover">
		<table class="basic">
		<caption>Write/Update</caption>
			<tr>
				<th>Action</th>
				<td><input type="text" name="ACTION_CODE" id="ACTION_CODE" class="text width_max" value="" maxlength="200" /></td>
				<th>Mode</th>
				<td><input type="text" name="MODE_CODE" id="MODE_CODE" class="text width_max" value="" maxlength="200" /></td>
				<th>Desc</th>
				<td><input type="text" name="DESC_STR" id="DESC_STR" class="text width_max" value="" maxlength="200" /></td>
				<th>Lang Code</th>
				<td><input type="text" name="LANG_CODE" id="LANG_CODE" class="text" value="" style="width:96%;" maxlength="200" /></td>
			</tr>
			<tr>
				<th>Redirection</th>
				<td colspan="3"><select name="REDIRECTION_CODE" id="REDIRECTION_CODE" class="select width_max" style="width:99.8%;"><option value="00">FORWARD</option><option value="10">INCLUDE</option><option value="99">BACK</option></select></td>
				<th>Class Path</th>
				<td colspan="3"><input type="text" name="CLASS_PATH" id="CLASS_PATH" class="text width_max" value="" style="width:98%;" maxlength="200" /></td>
			</tr>
			<tr>
				<th>Template Path</th>
				<td  colspan="3">
					<select name="TEMPLATE_PATH" id="TEMPLATE_PATH" class="select width_max" style="width:99.8%;">
						<option value="">없음</option>
						<option value="/common/_template/template_excel.jsp">template_excel.jsp</option>
						<option value="/common/_template/template_json.jsp">template_json.jsp</option>
						<option value="/common/_template/template_login.jsp">template_login.jsp</option>
						<option value="/common/_template/template_main.jsp">template_main.jsp</option>
						<option value="/common/_template/template_nosize.jsp">template_nosize.jsp</option>
						<option value="/common/_template/template_nosize(euc-kr).jsp">template_nosize(euc-kr).jsp</option>
						<option value="/common/_template/template_poi_excel.jsp">template_poi_excel.jsp</option>
						<option value="/common/_template/template_poi_excel_tg.jsp">template_poi_excel_tg.jsp</option>
						<option value="/common/_template/template_poi_excel_total.jsp">template_poi_excel_total.jsp</option>
						<option value="/common/_template/template_popup.jsp">template_popup.jsp</option>
						<option value="/common/_template/template_popup_notitle.jsp">template_popup_notitle.jsp</option>
						<option value="/common/_template/template_print.jsp">template_print.jsp</option>
						<option value="/common/_template/template_sub.jsp">template_sub.jsp</option>
						<option value="/common/_template/template_sub_notitle.jsp">template_sub_notitle.jsp</option>
						<option value="/common/_template/template_xml.jsp">template_xml.jsp</option>
					</select>
				</td>
				<th>Content Path</th>
				<td colspan="3"><input type="text" name="CONTENT_PATH" id="CONTENT_PATH" class="text width_max" value="" style="width:98%;" maxlength="200" /></td>
			</tr>
			<tr>
				<th>Auth Code</th>
				<td colspan="7"><input type="text" name="AUTH_CODES" id="AUTH_CODES" class="text" value="" style="width:99%;" maxlength="200" /></td>
			</tr>
		</table>
		</div>
</form>
		
		<div class="buttonlist" style="width:98%;">
		    <div class="right" style="padding-right:5px;">
		    	<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:void(0);" onClick="doSysAttch();">시스템적용</a></span>
		    	<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form2);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
				<span class="ui_btn medium icon" id="btnWrite"><span class="write"></span><a href="javascript:void(0)" onclick="doSubmit(document.form2,'WRITE');"><%=StringUtil.getLocaleWord("L.등록",siteLocale)%></a></span>
				<span class="ui_btn medium icon" id="btnModify"><span class="modify"></span><a href="javascript:void(0)" onclick="doSubmit(document.form2,'UPDATE');"><%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
				<span class="ui_btn medium icon" ><span class="delete"></span><a href="javascript:void(0)" onclick="doSubmit(document.form2,'DELETE');"><%=StringUtil.getLocaleWord("L.삭제",siteLocale)%></a></span>
			</div>
		</div>
		
		<div class="table_cover" style="margin-top:30px;">
		<table class="list">
		<caption>List</caption>
		<colgroup>
			<col style="width:20%" />
			<col style="width:20%" />
			<col style="width:30%" />
			<col style="width:auto" />
			<col style="width:6%" />
		</colgroup>
			<tr>
				<th>Action Code</th>
				<th>Mode Code</th>
				<th>Servlet Name(KO)</th>
				<th>Servlet Name(EN)</th>
				<th>PopUp</th>
			</tr>
			<tbody id="ServletBody">
			</tbody>
		</table>
		</div>
		
	</div>
</div>
<script>
if(opener){
	$("body").css("overflow-y","scroll");
}else if(parent.opener){
}
</script>