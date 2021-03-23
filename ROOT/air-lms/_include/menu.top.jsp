<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>   
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.common.util.StringUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = loginUser.getSiteLocale();

BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
%>
<link rel="stylesheet" href="/common/_lib/jqwidgets/jqwidgets/styles/jqx.base.css" type="text/css" />
<link rel="stylesheet" href="/common/_lib/jqwidgets/jqwidgets/styles/jqx.custom_for_menu.css" type="text/css" />
<script type="text/javascript" src="common/_lib/underscore-min.js"></script>	
<script type="text/javascript">
/**
 * 요청한 페이지로 이동
 */
function goMenuPage(actionCode, modeCode, etcQStr, goType, eobmu) {
	
	if(eobmu == "GY"){
			var url = "/ServletController";
			url += "?<%=CommonConstants.ACTION_CODE%>="+ actionCode;
			url += "&<%=CommonConstants.MODE_CODE%>="+ modeCode;
		 
			if (etcQStr != undefined) url += etcQStr;  
		 
			if (goType == "POPUP") {
				airCommon.openWindow(url, 1024, 800, 'popWrite', 'yes', 'yes' );
		
			} else {
				window.top.location.href = encodeURI(url); 
			}
	}else{
		if (actionCode == "LMS_GUIDE" && modeCode == "USER") {
			airLms.popupUserManualDownload();
		} else if (actionCode == "LMS_GUIDE" && modeCode == "ADMIN") {
			airLms.popupAdminManualDownload();
		} else { 
			var url = "/ServletController";
			url += "?<%=CommonConstants.ACTION_CODE%>="+ actionCode;
			url += "&<%=CommonConstants.MODE_CODE%>="+ modeCode;
		 
			if (etcQStr != undefined) url += etcQStr;  
		 
			if (goType == "POPUP") {
				airCommon.openWindow(url, 1024, 800, 'popWrite', 'yes', 'yes' );
		
			} else {
				window.top.location.href = encodeURI(url); 
			}
		}		
	}
}

/**
 * 로그아웃
 */
function doLogout() {
 window.top.location.href  = "/ServletController?<%=CommonConstants.ACTION_CODE %>=LMS_LOGIN&<%=CommonConstants.MODE_CODE %>=LOGOUT_PROC";
}

/**
 * 홈페이지로 이동
 */
function goHome() {
 window.top.location.href  = "/";
}

/**
 * 권한변경
 */
function changeAuth(val) {
 window.top.location.href  = "/ServletController?<%=CommonConstants.ACTION_CODE%>=LMS_LOGIN&<%=CommonConstants.MODE_CODE%>=CHANGE_AUTH&CAUTH=" + val;
}

/**
 * 사이트 로케일 변경
 */
function changeSiteLocale(val) {
 window.top.location.href  = "/ServletController?<%=CommonConstants.ACTION_CODE%>=LMS_LOGIN&<%=CommonConstants.MODE_CODE%>=CHANGE_SITE_LOCALE&CLOCALE=" + val;
}
 

/**
 * 사용자 비밀번호변경
 */
function doModifyPW(){
 var url = "/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_USER&<%=CommonConstants.MODE_CODE%>=CHANGE_PASSWORD";
 airCommon.openWindow(url, "1024", "200");
}

$(function() {
	$.getJSON('ServletController?AIR_ACTION=SYS_MENU&AIR_MODE=LIST_MENU_JSON').success(function(d){
		var menuMap = (function(){
			var t0 = {};
			$.each(d, function(i,v) { t0[v.MENU_ID] = v; });
			return t0;
		})();
		var nameMap = (function() {
			var t0 = {};
			$("form[name='menuForm'] input").each(function() {
				var name = $(this).attr('name');
				var uppercasedName = name.toUpperCase();
				var idx = name.indexOf('menuParam');
				if ( idx != -1 ) uppercasedName = uppercasedName.substr(9);
				t0[uppercasedName] = name;
			});
			return t0;
		})();
		

		// jsp 문자열
		// jsp scriptlet 문자열 replace 처리
		// replace 처리 될 문자열은 다음과 같다 
		// wJudamId, wDaeriCod, wDaeriJudamId, wDaeriGwanriNo, DAERI_GWANRI_NO
		function replaceExpr(s) {
			if ( !s ) return s;
			
			var regex = /\<\%\=(.+?)\%\>/gim
			,idMap = {
				wJudamId : "",
				wDaeriCod :"",
				wDaeriJudamId : "",
				wDaeriGwanriNo :"",
				DAERI_GWANRI_NO : ""
			}
			,t0;
			while((t0 = regex.exec(s)) != null || s.indexOf('%') != -1) {
				if ( !t0 ) continue;
				s = s.replace(new RegExp(t0[0], 'gi'), idMap[t0[1]]);
			}
			return s;
		}
		
	/**
	* top menu 링크 함수
	**/
	function goToMenu(data) {
// 		var $form = $("form[name='menuForm']");
		
// 		[].forEach.call( Object.keys( data ), function( key ){  
// 			if(key == "JSON_PARAMETER"){
// 				var jsonData = JSON.parse(data[key]);
// 				$(jsonData).each(function(i, v){
// 					var html ="<input type=\"hidden\" name=\""+v.key+"\" value=\""+v.val+"\"\>";
// 					$("#menuForm").html($("#menuForm").html() + html);
// 				});
// 			}else{
// 				var html ="<input type=\"hidden\" name=\""+key+"\" value=\""+data[key]+"\"\>";
// 				$("#menuForm").html($("#menuForm").html() + html);
// 			}
// 		});

// 		$form.attr('action','ServletController');
// 		$form.submit();
		
		var $form = $("form[name='menuForm']");
		[].forEach.call( Object.keys( data ), function( key ){  
			console.log(key +":"+ data[key]);
			if(key == "JSON_PARAMETER"){
				var jsonData = JSON.parse(data[key]);
				$(jsonData).each(function(i, v){
					var html ="<input type=\"hidden\" name=\""+v.key+"\" value=\""+v.val+"\"\>";
					$("#menuForm").html($("#menuForm").html() + html);
				});
			}else{
				var html ="<input type=\"hidden\" name=\""+key+"\" value=\""+data[key]+"\"\>";
				$("#menuForm").html($("#menuForm").html() + html);
			}
		});
		if($form.find("input:hidden[name='open_type']").val() == "POPUP" 	
		){
			airCommon.openWindow('' , 1024, 700, 'open_doc_write', 'yes', 'yes');
			$form.attr("target","open_doc_write");
		}
		if($form.find("input:hidden[name='open_type']").val() == "URL" 	
		){
			//airCommon.openWindow(data["AIR_ACTION"], 1024, 700, 'open_doc_write', 'yes', 'yes');
			$form.attr('action', data["AIR_ACTION"]);
			$form.attr('target', '_blank');
			$form.submit();
			$("#menuForm").html("");
			return false;
		}
		$form.attr('action','ServletController');
		$form.submit();
		$("#menuForm").html("");
		$form.attr('target','_self');
	}
	
	/**
	* jqxMenu로 메뉴를 그리기위한 기본데이터 준비
	**/
	var source = {
		datatype:'json',
		datafields: [
			{name:'MENU_ID'},
			{name:'PARENT_ID'},
			{name:'KO'},
			{name:'EN'},
			{name:'JA'},
			{name:'ZH'},
			{name:'MENU_NAME_KO'},
			{name:'MENU_NAME_EN'},
			{name:'AIR_ACTION'},
			{name:'AIR_MODE'},
			{name:'READ_AUTHS'},
			{name:'JSON_PARAMETER'}
		],
		localdata:d
	};
	
	var dataAdapter = new $.jqx.dataAdapter(source);
	dataAdapter.dataBind();
	var records = dataAdapter.getRecordsHierarchy('MENU_ID', 'PARENT_ID', 'items', [{ name: '<%=siteLocale%>', map: 'label'}]);

	function renderTreeHTML(target, arr) { 
		var data = arr || records;
		var ul = $('<ul>');
		for ( var i=0, n = data.length; i<n;i++ ) {
			var li = $('<li />').text(data[i].<%=siteLocale%>).data('data', data[i]);
			if ( data[i].items ) renderTreeHTML(li, data[i].items)
			ul.append(li);
		}
		target.append(ul);
	}
	// 하이라키 구조로 ul > li 생성후 jqxMenu 렌더링
	renderTreeHTML($('#jqxMenu'), records);
	$("#jqxMenu").css('visibility', 'visible');
	//$("#jqxMenu").jqxMenu({ theme: 'custom_for_menu', animationShowDuration: 0, animationHideDuration: 0, animationShowDelay: 0, autoOpen: true, width: '850px' });
	$("#jqxMenu").jqxMenu({ animationShowDuration: 0, animationHideDuration: 0, animationShowDelay: 0, autoOpen: true });
	$("#jqxMenu").show().find('ul:first').addClass('gnb');
	$('#jqxMenu').on('itemclick', function (e) {
		var o = $(e.args).data('data');
		if ( !o.AIR_ACTION || !o.AIR_MODE )return;
		goToMenu(o);
	});
});
});

var goSearch = function(isCheckEnter) {
 	if (isCheckEnter && event.keyCode != 13) {         
        return;
    }
//-->2016.10.28 SSJ 서치시에 파라메터가 포스트로 넘어가도록 변경.
// 	var url = "/ServletController";
// 	url += "?AIR_ACTION=LMS_SEARCH";
// 	url += "&AIR_MODE=SEARCH";
// 	url += "&p_CONTENTS="+$("#p_CONTENTS").val();
	var search = document.search_form;
	airCommon.openWindow("", "1024", "800", "POPUP_SEARCH", "yes", "yes", "");
	search.method = "post"
	search.target = "POPUP_SEARCH";
	search.p_CONTENTS = $("#p_CONTENTS").val();
	search.submit();
	
	//openWindow("", "POPUP_SEARCH", );
};

function scEnCode(sParam) {							// 이름 파라미터 깨짐 방지
	sParam = sParam.replace(/(^\s*)|(\s*$)/gi, ""); //trim

	var encode = '';

	for(var iIndex=0; iIndex<sParam.length; iIndex++) {
		var sLength  = ''+sParam.charCodeAt(iIndex);
		var sToken = '' + sLength.length;
		encode  += sToken + sParam.charCodeAt(iIndex);
	}

	return encode;
}

function openWindow(theURL, winName, myWidth, myHeight, isCenter) { //v3.0
	if(window.screen)if(isCenter)if(isCenter=="true"){
		var myLeft = (screen.width-myWidth)/2;
		var myTop = (screen.height-myHeight)/2;
		var vStyle= "'toolbar=0,location=0,directories=0,status=Yes,menubar=0,scrollbars=Yes,resizable=Yes, width=" + myWidth + ",height=" + myHeight + ",top=" + myTop +",left=" + myLeft + "'";
	} else {
		 vStyle= "'toolbar=0,location=0,directories=0,status=Yes,menubar=0,scrollbars=Yes,resizable=Yes, width=" + myWidth + ",height=" + myHeight + ",top=100,left=100'";
	}

	window.open(theURL, winName, vStyle);//팝업창 모니터 중간에 띄우기
}

function openServiceDesk(){
	var vParams = "";

	vParams += "compky="+"COM-000008";		// 지정한 고객사 고정코드 (helpdesk에서 고객사 등록 후 확인)
	vParams += "&id="+"COM0008001";		// 지정한 고객사 고정계정 (helpdesk에서 고객사 등록 후 확인)
	vParams += "&name="+scEnCode("<%=loginUser.getName()%>");	// 이름
	vParams += "&email="+"<%=loginUser.getEmail()%>"; // 이메일

	//openWindow("http://sd.emfrontier.com/main/ssoLogin2.do?"+vParams, "ServiceDesk", "1250", "700", "true");
	openWindow("http://sd.hankook-networks.com/main/ssoLogin2.do?"+vParams, "ServiceDesk", "1250", "700", "true");
}

function menuDown(){
<% if (loginUser.isCmmAdmin()) { %>    
	airLms.popupAdminManualDownload();
<% }else if (LmsUtil.isBeobmuTeamUser(loginUser)) { %>
	airLms.popupManagerManualDownload();
<% }else  { %>
	airLms.popupUserManualDownload();
<% } %>
}

function goFAQ(vForm) {
	vForm.action = "/ServletController";
	vForm.<%=CommonConstants.ACTION_CODE%>.value = "LMS_BBS_FAQ";
	vForm.<%=CommonConstants.MODE_CODE%>.value = "GLIST";
	vForm.submit();
}

function goModiUser(vForm) {
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_USER&AIR_MODE=UPDATE_FORM&user_uid=<%=loginUser.getUUID()%>', 1024, 420, 'company_edit_user', 'yes', 'yes');
}

</script>
<form name="menuForm"  method="post" style="margin:0; padding:0;">
<div id="menuForm" >
</div>
</form>
	<!--header 시작-->
    <div class="header">
    	<div class="header_area">
    		<div class="header_top">
<% if (StringUtil.isNotBlank(CommonProperties.getSystemMode())){ %>
				<div style="padding-top:6px; position:absolute;">
					<span class="ui_btn small icon"><span class="list"></span><a href="javascript:void(0)" onclick="javascript:airCommon.openWindow('/ServletController?AIR_ACTION=SYS_SERVLET&AIR_MODE=POPUP_LIST',1024,600,'Serverlet',true,true);">Servlet</a></span>
					<span class="ui_btn small icon"><span class="list"></span><a href="javascript:void(0)" onclick="javascript:airCommon.openWindow('/ServletController?AIR_ACTION=SYS_LANG&AIR_MODE=POPUP_GLIST',1024,600,'Lang List',true,true);">언어사전</a></span>
<%--
					<span class="ui_btn small icon"><span class="list"></span><a href="javascript:void(0)" onclick="javascript:airCommon.openWindow('/ServletController?AIR_ACTION=SYS_DEF_DOC_REL&AIR_MODE=LIST',1280,800,'DOC REL List',true,true);">문서간관계</a></span>
					<span class="ui_btn small icon"><span class="list"></span><a href="javascript:void(0)" onclick="javascript:airCommon.SM();">SM</a></span>
--%>
				</div>
<% } %>
				<span>
					<strong style="padding-right: 2px;"><%=loginUser.getGroupName()%></strong>&nbsp;<strong><%=loginUser.getName()%></strong> &nbsp; &nbsp; <%=StringUtil.getLocaleWord("L.로그인",siteLocale) %> 
				</span>
<form action="/ServletController?AIR_ACTION=LMS_SEARCH&AIR_MODE=SEARCH" name="search_form" method="post" style="margin:0; padding:0;">
<input type="text" name="hidden" id="hidden" style="display:none; margin:0; padding:0;" />
<input type="hidden" name="AIR_ACTION" />
<input type="hidden" name="AIR_MODE" />
 				<%-- <% if (loginUser.isCmmAdmin() || LmsUtil.isBeobmuOfiUser(loginUser)) { %>
				<span class="color00" style="vertical-align:top; padding:0px 4px 0px 4px;">
					<input type="text" class="search"  name="p_CONTENTS" id="p_CONTENTS" onKeyUp="goSearch(true)" />
					<img class="search" src="/air-lms/_css/themes/default/images/menu_top/search.png" onClick="goSearch()" />
				</span>
				<% } %> --%>
				<% if (loginUser.isCmmAdmin()) { %>
					<a href="javascript:void(0)" onclick="openServiceDesk();" class="color01">
						<%=StringUtil.getLocaleWord("L.고객센터",siteLocale) %>
					</a>
				<% } %>
<%-- 					<a href="javascript:void(0);" onclick="goFAQ(document.search_form)" class="color02"><%=StringUtil.getLocaleWord("L.FAQ",siteLocale) %></a> --%>
					<a href="javascript:void(0);" onclick="goModiUser(document.search_form)" class="color02"><%=StringUtil.getLocaleWord("L.사용자정보변경",siteLocale) %></a>
					<a href="javascript:void(0);" onclick="doLogout();" class="color03"><%=StringUtil.getLocaleWord("L.로그아웃",siteLocale) %></a>
				<% if("Y".equals(CommonProperties.load("fnc.changeLocale"))){ %>
					<%=HtmlUtil.getSelect(request,  true, "schSiteLocale", "schSiteLocale", "KO|한국어^EN|English^ZH|中文", siteLocale, "style='heigth:30px;' onchange='changeSiteLocale(this.options[this.selectedIndex].value);'")%>
				<% } %>
</form>
			</div>
			<div id="jqxMenu" class="menu">
				<h1><img src="/air-lms/_css/themes/default/images/menu_top/logo.png" onclick="goHome();" style="border:none; margin-top:13px; cursor:pointer;" title="Go Home" /></h1>
			</div>
		</div>
	</div>