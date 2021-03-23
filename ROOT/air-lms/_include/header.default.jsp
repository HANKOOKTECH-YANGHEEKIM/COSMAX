<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.config.CommonProperties"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = loginUser == null ? CommonProperties.getSystemDefaultLocale() : loginUser.getSiteLocale();
String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();
String systemEditor			=CommonProperties.load("system.editor");
%>

<meta http-equiv="X-UA-Compatible" content="IE=edge">

<%-- jQuery --%>
<script type="text/javascript" src="/common/_lib/jquery/jquery.js"></script>
<script type="text/javascript" src="/common/_lib/jquery.tmpl.js"></script>
<%-- YuHan 임시저장 처리를 위한 플러그인 --%>
<script type="text/javascript" src="/common/_lib/jquery.form/jquery.form.js"></script>

<%-- jQuery - UI --%>
<link rel="stylesheet" type="text/css" href="/common/_lib/jquery-ui/themes/default/jquery-ui.custom.css" />
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui.custom.js"></script>

<%-- 	amplify   --%>
<script type="text/javascript" src="/common/_lib/amplify.min.js"></script>


<%-- Easy - UI --%>
<link rel="stylesheet" type="text/css" href="/common/_lib/jquery-easyui/themes/default/easyui.custom.css" />
<link rel="stylesheet" type="text/css" href="/common/_lib/jquery-easyui/themes/icon.custom.css" />
<script type="text/javascript" src="/common/_lib/jquery-easyui/jquery.easyui.js"></script>

<%-- 2016.07.12 easyui 로케일 설정.	신현삼 --%>
<script type="text/javascript" src="/common/_lib/jquery-easyui/locale/easyui-lang-<%=siteLocale.toLowerCase()%>.js"></script>
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-detailview.js"></script>
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-scrollview.js"></script>

<!-- EDITOR -->
<%if("NAMO".equals(systemEditor)){ %>
<script type="text/javascript" src="/common/_lib/crosseditor/js/namo_scripteditor.js"></script>
<%}else{ %>
<script type="text/javascript" src="/common/_lib/ckeditor/ckeditor.js"></script>
<%} %>

<%-- jQwidgets --%>
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxcore.js"></script>
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxdata.js"></script>
<script type="text/javascript" src="/common/_lib/jqwidgets/jqwidgets/jqxmenu.js"></script>
<%-- 2018.06.27 신현삼. jqxMenu에서 마우스오버시 팝업창의 포커스를 잃는 버그 픽스 --%>
<script type="text/javascript" src="/common/_lib/jqwidgets/jqxmenu-ext.js"></script>

<%-- 공통 스크립트 --%>
<script type="text/javascript" src="/common/_js/air-common.js"></script>

<%-- 솔루션 스크립트 --%>
<script type="text/javascript" src="<%=systemDefaultContentUrl %>/_js/<%=systemDefaultContentUrl %>.js?ver=2017-02-09"></script>

<%-- 기본 CSS --%>
<link rel="stylesheet" type="text/css" href="<%=systemDefaultContentUrl %>/_css/style.default.css" />
<%-- YuHan 디자인 적용 : reset.css를 삽입하면 easy-ui가 깨짐 --%>
<link rel="stylesheet" type="text/css" href="/air-lms/_css/default.css" />

<script>
//-- 크로스 에디터 처리
var CrossEditor = [];
var OnInitCompleted = function(e){
	e.editorTarget.SetValue($("#"+e.editorName).val());
};
var toolEvent = function(){
	var tooltip = $("[data-type='ALERT']");
	$(tooltip).each(function(i,d){
		var id = $(this).attr("title");
		console.log(id);
		$(d).tooltip({
            position: 'right',
            content: $("#"+id).html(),
            onShow: function(){
                $(this).tooltip('tip').css({
                    backgroundColor: '#ffffff',
                    borderColor: '#666'
                });
            }
		});
	});
};
var addEventWriter = function(){
	var textObj = $("input:text");
	
 	$(document).on("keyup","[data-length][data-length!='']",function(){

 		var length = $(this).data("length");
 		var id = $(this).attr("id");
 		if( id == undefined ){
 			id = $(this).attr("name");
 		}
		/*
			2017.06.15 김형종 IF문으로 감싸는 작업 추가.
			'id' 가 없고 'name' 만 존재하는 태그가 있을지 모르므로 감싸준다. 'id'가 없으면 스트립트 에러가 남..
			ex) 동적으로 추가되는 input 태그는 동일한 name값을 가지되, id가 없을 수도 있음.
		*/
 		if( id != undefined ){

 			//초기화
 			$(this).removeAttr("style");
 			$(this).removeAttr("onKeyUp");
 			$(this).removeAttr("onBlur");
 			$("#span_"+id).remove();

 			var objWidth = $(this).width();
 			var preWidth = $(this).parent().width();
 			var tarWidth = $(this).width()-65;

 			var lastWidth = (tarWidth/preWidth)*100;


 			//설정 시작
 			$(this).css("width",lastWidth.toFixed(0)+"%");//소수점이하 버림
 			$(this).attr("onKeyUp","airCommon.displayByte('"+id+"')");
 			$(this).parent().append("<span id=\"span_"+id+"\">(<span id=\"byte_"+id+"\">0</span>/"+length+")</span>")
 			airCommon.displayByte(id);

 		}

 		airCommon.validateSpecialChars(this);
 		
 	}).on("blur","[data-length][data-length!='']",function(){
 		var length = $(this).attr("data-length");
 		
 		airCommon.validateMaxLength(this,length);
 		airCommon.getTrim(this.value);
 	});
	
	$(document).on("keyup",".cost",function(){

		airCommon.getFormatCurrency(this,2,true)
	});
	$(document).on("keyup",".number",function(){

		airCommon.validateNumber(this,$(this).val());
	});
	
	$("[data-length][data-length!='']").trigger("keyup");
};

$(function() {
	//-- 작성 이벤트 삽입
	addEventWriter();
	
	var isopen = true; // true: 열림, false: 닫힘
	$("#menu_view2").click(function() {
		$(".box").css ({ display:isopen ? "none" : "" });
		$(".menu_view2 a img").attr ({src: isopen ? "<%=systemDefaultContentUrl %>/_css/themes/basic/images/menu_open_form.png" : "<%=systemDefaultContentUrl %>/_css/themes/basic/images/menu_close_form.png" });
		isopen = isopen ? false : true;
	});

	toolEvent();

	if(top.opener){
		$(document).keyup(function(e) {
		    if (e.keyCode == 27) { // escape key maps to keycode `27`
		    	if(confirm("<%=StringUtil.getScriptMessage("M.창을닫습니다", siteLocale)%>")){
			      top.window.close();
		    	}
		   }
		});
	}
	
}).ajaxStart(function(){
	airCommon.showBackDrop();
	
}).ajaxStop(function(){
	airCommon.hideBackDrop();
});
<%if(!"DEV".equals(CommonProperties.getSystemMode())){%>
window.onerror = function(msg, url, line, col, error) {
	   // Note that col & error are new to the HTML 5 spec and may not be 
	   // supported in every browser.  It worked for me in Chrome.
	   var extra = !col ? '' : '\ncolumn: ' + col;
	   extra += !error ? '' : '\nerror: ' + error;
	   console.error(error);

	   // You can view the information in an alert to see things working like this:
// 	   alert("Error: " + msg + "\nurl: " + url + "\nline: " + line + extra);
	   alert("처리하는 동안 문제가 발생했습니다.\n관리자에게  문의하세요.\nError : "+msg+ "\nline: " + line + extra);
	   airCommon.hideBackDrop();
	   // TODO: Report this error via ajax so you can keep track
	   //       of what pages have JS issues

	   var suppressErrorAlert = true;
	   // If you return true, then error alerts (like in older versions of 
	   // Internet Explorer) will be suppressed.
	   return suppressErrorAlert;
};
<%}%>
</script>
<script id="addTreeTmpl_USER" type="text/x-jquery-tmpl">
	<div id="\${UUID}" data-id="div_\${PARENT_UUID}" style="padding-left:\${setPadding(LEVEL_NO)}px;" class="treeNode">
		{{if CHILD_CNT > 0 }}
			<img id="img_\${UUID}" src="common/_lib/jqwidgets/jqwidgets/styles/images/icon-right.png" style="vertical-align:middle" onClick="nodeOpenClick('\${UUID}');">
			<img src="/common/_images/folder.gif" style="vertical-align:middle" alt="">
			<span style="margin-left:-4px;cursor:pointer;{{if STATUS_CODE != 'N' && STATUS_CODE != 'S'}}color:red{{/if}}" onClick="nodeOpenClick('\${UUID}');">\${GROUP_NM_<%=siteLocale%>}</span>
		{{else}}
				<img src="/common/_images/empty.gif" style="vertical-align:middle" alt="">
			{{if USR_SEQ == '0' }}
				<img id="img_\${UUID}" src="/common/_images/page.gif" style="vertical-align:middle" onClick="treeDrawChild('\${UUID}','\${UUID}','')">
				<span onClick="selectNode('\${UUID}')" style="margin-left:-4px;cursor:pointer;{{if STATUS_CODE != 'N' && STATUS_CODE != 'S'}}color:red{{/if}}">\${GROUP_NM_<%=siteLocale%>} [\${POSITION_NAME_<%=siteLocale%>} /\${GROUP_NAME_<%=siteLocale%>}]</span>
			{{else}}
				<img src="/common/_images/folder.gif" style="vertical-align:middle" alt="">
				<span style="margin-left:-4px;cursor:pointer;{{if STATUS_CODE != 'N' && STATUS_CODE != 'S'}}color:red{{/if}}">\${GROUP_NM_<%=siteLocale%>}</span>
			{{/if}}
		{{/if}}

		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="name_en" value="\${NAME_EN}"/>
		<input type="hidden" name="user_no" value="\${USER_NO}"/>
		<input type="hidden" name="login_id" value="\${LOGIN_ID}"/>
		<input type="hidden" name="parent_uuid" value="\${PARENT_UUID}"/>
		<input type="hidden" name="parent_code" value="\${PARENT_DEPT_CD}"/>
		<input type="hidden" name="parent_group_name_ko" value="\${PARENT_DEPT_NAME_KO}"/>
		<input type="hidden" name="parent_group_name_en" value="\${PARENT_DEPT_NAME_EN}"/>
		<input type="hidden" name="duty_code" value="\${DUTY_CODE}"/>
		<input type="hidden" name="position_code" value="\${POSITION_CODE}"/>
		<input type="hidden" name="position_name_ko" value="\${POSITION_NAME_KO}"/>
		<input type="hidden" name="position_name_en" value="\${POSITION_NAME_EN}"/>
		<input type="hidden" name="group_name_path_ko" value="\${DEPT_NAME_PATH_KO}"/>
		<input type="hidden" name="group_name_path_en" value="\${DEPT_NAME_PATH_EN}"/>
		<input type="hidden" name="group_name_ko" value="\${GROUP_NAME_KO}"/>
		<input type="hidden" name="group_name_en" value="\${GROUP_NAME_EN}"/>
		<input type="hidden" name="group_code" value="\${GROUP_CODE}"/>
		<input type="hidden" name="group_uuid" value="\${GROUP_UUID}"/>
		<input type="hidden" name="address_ko" value="\${ADDRESS_KO}"/>
		<input type="hidden" name="address_en" value="\${ADDRESS_EN}"/>
		<input type="hidden" name="telephone_no" value="\${TELEPHONE_NO}"/>
		<input type="hidden" name="email" value="\${EMAIL}"/>
		<input type="hidden" name="registration_no" value="\${REGISTRATION_NO}"/>
		<input type="hidden" name="group_type_code" value="\${GROUP_TYPE_CODE}"/>
		<input type="hidden" name="nation_cod" value="\${NATION_COD}"/>
		<input type="hidden" name="nation_name" value="\${NATION_NAME}"/>
		<input type="hidden" name="rel_psn_no" value="\${REL_PSN_NO}"/>
		<input type="hidden" name="status_name_ko" value="\${STATUS_NAME_KO}"/>
		<input type="hidden" name="status_name_en" value="\${STATUS_NAME_EN}"/>

	</div>
</script>
<!--
	2016.07.14 김형종 수정
	영문화 작업으로 인해 템플릿을 아래 템플릿을 수정함.
	NAME_KO 만 가져왔던 것을 siteLocale 을 이요해서 태그의 'name'값은 'name_ko'이지만 siteLocale 에 따라 영어 또는 한국어 등으로
	유저의 선택에 따라 변경된다. name_ko 값을 바꾸지 않은 이유는 다른팝업 JSP들에서 그대로 name='name_ko' 로 받어오는 곳이 여러군데 있어
	일일이 수정해주면 번거로워 템플릿에서만 이름을 같게하여 변경하였음..
-->
<script id="addTreeTmpl_SKILL" type="text/x-jquery-tmpl">
	<div id="\${CODE_ID}" data-id="div_\${PARENT_CODE_ID}" style="padding-left:\${setPadding(LEVEL_NO)}px;" class="treeNode">
		{{if CHILD_CNT > 0 }}
			<img id="img_\${CODE_ID}" src="common/_lib/jqwidgets/jqwidgets/styles/images/icon-right.png" style="border:0:cursor:pointer;" onClick="nodeOpenClick('\${CODE_ID}');">
			<span onClick="nodeOpenClick('\${CODE_ID}');" style="margin-left:-4px;cursor:pointer;">\${NAME_<%=siteLocale%>}</span>
		{{else}}
			<img src="/common/_images/empty.gif" style="vertical-align:middle" alt="">
			<img id="img_\${CODE_ID}" src="/common/_images/page.gif" style="border:0:cursor:pointer;" onClick="treeDrawChild('\${CODE_ID}','\${CODE_ID}','')">
			<span onClick="selectNode('\${CODE_ID}')" style="margin-left:-4px;cursor:pointer;">\${NAME_<%=siteLocale%>}</span>
		{{/if}}
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="name_en" value="\${NAME_EN}"/>
		<input type="hidden" name="code_id" value="\${CODE_ID}"/>
		<input type="hidden" name="code" value="\${CODE}"/>
		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="parent_code_id" value="\${PARENT_CODE_ID}"/>
		<input type="hidden" name="code_id_path" value="\${CODE_ID_PATH}"/>
		<input type="hidden" name="name_path_ko" value="\${NAME_PATH_KO}"/>
		<input type="hidden" name="name_path_en" value="\${NAME_PATH_EN}"/>
	</div>
</script>
<!--<script id="addTreeTmpl_GROUP" type="text/x-jquery-tmpl">
	<div id="\${CODE}" data-id="div_\${PARENT_CODE}" style="padding-left:\${setPadding(LEVEL_NO)}px;" class="treeNode">
		{{if CHILD_CNT > 0 }}
			<img id="img_\${CODE}" src="/common/_images/nolines_plus.gif" style="border:0:cursor:pointer;" onClick="nodeOpenClick('\${CODE}');">
		{{else}}
			<img id="img_\${CODE}" src="/common/_images/page.gif" style="border:0:cursor:pointer;" onClick="treeDrawChild('\${CODE}','\${CODE}','')">
		{{/if}}
		<span onClick="selectNode('\${CODE}')" style="margin-left:-4px;cursor:pointer;">\${NAME_KO}</span>
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="code" value="\${CODE}"/>
		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="parent_code" value="\${PARENT_CODE}"/>
		<input type="hidden" name="code_path" value="\${CODE_PATH}"/>
		<input type="hidden" name="name_path_ko" value="\${NAME_PATH_KO}"/>
	</div>
</script>-->

<!--
	2016.07.14 김형종 수정
	영문화 작업으로 인해 템플릿을 아래 템플릿을 수정함.
	NAME_KO 만 가져왔던 것을 siteLocale 을 이요해서 태그의 'name'값은 'name_ko'이지만 siteLocale 에 따라 영어 또는 한국어 등으로
	유저의 선택에 따라 변경된다. name_ko 값을 바꾸지 않은 이유는 다른팝업 JSP들에서 그대로 name='name_ko' 로 받어오는 곳이 여러군데 있어
	일일이 수정해주면 번거로워 템플릿에서만 이름을 같게하여 변경하였음..
-->
<script id="addTreeTmpl_GROUP" type="text/x-jquery-tmpl">
	<div id="\${UUID}" data-id="div_\${PARENT_UUID}" style="padding-left:\${setPadding(LEVEL_NO)}px;" class="treeNode">
		{{if CHILD_GROUP_CNT > 0 }}
			<img id="img_\${UUID}" src="common/_lib/jqwidgets/jqwidgets/styles/images/icon-right.png" style="vertical-align:middle" onClick="nodeOpenClick('\${UUID}');">
			<img src="/common/_images/folder.gif" style="vertical-align:middle" alt="">
			<span style="margin-left:-4px;cursor:pointer;" onClick="nodeOpenClick('\${UUID}');">\${GROUP_NM_<%=siteLocale%>}</span>
		{{else}}
				<img src="/common/_images/empty.gif" style="vertical-align:middle" alt="">
			{{if USR_SEQ == '1' }}
				<img id="img_\${UUID}" src="/common/_images/page.gif" style="vertical-align:middle" onClick="treeDrawChild('\${UUID}','\${UUID}','')">
				<span onClick="selectNode('\${UUID}')" style="margin-left:-4px;cursor:pointer;">\${GROUP_NM_<%=siteLocale%>}</span>
			{{else}}
				<img src="/common/_images/folder.gif" style="vertical-align:middle" alt="">
				<span style="margin-left:-4px;cursor:pointer;">\${GROUP_NM_<%=siteLocale%>}</span>
			{{/if}}
		{{/if}}

		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="name_en" value="\${NAME_EN}"/>
		<input type="hidden" name="login_id" value="\${LOGIN_ID}"/>
		<input type="hidden" name="code" value="\${DEPT_CD}"/>
		<input type="hidden" name="parent_uuid" value="\${PARENT_UUID}"/>
		<input type="hidden" name="parent_code" value="\${PARENT_DEPT_CD}"/>
		<input type="hidden" name="parent_name_ko" value="\${PARENT_DEPT_NAME_KO}"/>
		<input type="hidden" name="parent_name_en" value="\${PARENT_DEPT_NAME_EN}"/>
		<input type="hidden" name="name_path_ko" value="\${DEPT_NAME_PATH_KO}"/>
		<input type="hidden" name="name_path_en" value="\${DEPT_NAME_PATH_EN}"/>
	</div>
</script>
<script id="addTreeTmpl_CODE" type="text/x-jquery-tmpl">
	<div id="\${UUID}" data-id="div_\${PARENT_UUID}" style="padding-left:\${setPadding(LEVEL_NO)}px;" class="treeNode">
		{{if CHILD_CNT > 0 }}
			<img id="img_\${UUID}" src="common/_lib/jqwidgets/jqwidgets/styles/images/icon-right.png" style="vertical-align:middle" onClick="nodeOpenClick('\${UUID}');">
			<img src="/common/_images/folder.gif" style="vertical-align:middle" alt="">
			<span style="margin-left:-4px;cursor:pointer;{{if STATUS_CODE != 'N' && STATUS_CODE != 'S'}}color:red{{/if}}" onClick="selectNode('\${UUID}')">\${NAME_<%=siteLocale%>}</span>
		{{else}}
				<img src="/common/_images/empty.gif" style="vertical-align:middle" alt="">
				<img src="/common/_images/page.gif" style="vertical-align:middle" alt="">
				<span style="margin-left:-4px;cursor:pointer;{{if STATUS_CODE != 'N' && STATUS_CODE != 'S'}}color:red{{/if}}" onClick="selectNode('\${UUID}')">\${NAME_<%=siteLocale%>}</span>
		{{/if}}
		<input type="hidden" name="uuid"	        value="\${UUID}">
		<input type="hidden" name="code_id"	        value="\${CODE_ID}">
		<input type="hidden" name="code"	        value="\${CODE}">
		<input type="hidden" name="seq_no"	        value="\${SEQ_NO}">
		<input type="hidden" name="order_no"	    value="\${ORDER_NO}">
		<input type="hidden" name="name_ko"	        value="\${NAME_KO}">
		<input type="hidden" name="name_en"	        value="\${NAME_EN}">
		<input type="hidden" name="name_ja"	        value="\${NAME_JA}">
		<input type="hidden" name="name_zh"	        value="\${NAME_ZH}">
		<input type="hidden" name="memo_ja"	        value="\${MEMO_JA}">
		<input type="hidden" name="memo_zh"	        value="\${MEMO_ZH}">
		<input type="hidden" name="memo_ko"	        value="\${MEMO_KO}">
		<input type="hidden" name="memo_en"	        value="\${MEMO_EN}">
		<input type="hidden" name="parent_uuid"	    value="\${PARENT_UUID}">
		<input type="hidden" name="parent_name_ko"	value="\${PARENT_NAME_KO}">
		<input type="hidden" name="parent_name_en"	value="\${PARENT_NAME_EN}">
		<input type="hidden" name="parent_code_id"	value="\${PARENT_CODE_ID}">
		<input type="hidden" name="parent_code"	    value="\${PARENT_CODE}">
		<input type="hidden" name="parent_seq_no"	value="\${PARENT_SEQ_NO}">
		<input type="hidden" name="level_no"	    value="\${LEVEL_NO}">
		<input type="hidden" name="child_cnt"	    value="\${CHILD_CNT}">
		<input type="hidden" name="uuid_path"	    value="\${UUID_PATH}">
		<input type="hidden" name="code_id_path"	value="\${CODE_ID_PATH}">
		<input type="hidden" name="code_path"	    value="\${CODE_PATH}">
		<input type="hidden" name="name_path_ko"	value="\${NAME_PATH_KO}">
		<input type="hidden" name="name_path_en"	value="\${NAME_PATH_EN}">
		<input type="hidden" name="code_attr1"	    value="\${CODE_ATTR1}">
		<input type="hidden" name="code_attr2"	    value="\${CODE_ATTR2}">
		<input type="hidden" name="code_attr3"	    value="\${CODE_ATTR3}">
		<input type="hidden" name="code_attr4"	    value="\${CODE_ATTR4}">
		<input type="hidden" name="code_data"	    value="\${CODE_DATA}">
		<input type="hidden" name="status_code"	    value="\${STATUS_CODE}">
		<input type="hidden" name="status_name_ko"	value="\${STATUS_NAME_KO}">
		<input type="hidden" name="status_name_en"	value="\${STATUS_NAME_EN}">
		<input type="hidden" name="insert_date"	    value="\${INSERT_DATE}">
		<input type="hidden" name="update_date"	    value="\${UPDATE_DATE}">
		<input type="hidden" name="code_attr1_desc"	value="\${CODE_ATTR1_DESC}">
		<input type="hidden" name="code_attr2_desc"	value="\${CODE_ATTR2_DESC}">
		<input type="hidden" name="code_attr3_desc"	value="\${CODE_ATTR3_DESC}">
		<input type="hidden" name="code_attr4_desc"	value="\${CODE_ATTR4_DESC}">
	</div>
</script>