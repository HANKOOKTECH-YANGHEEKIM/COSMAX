<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	BeanResultMap searchMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= searchMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= searchMap.getString(CommonConstants.PAGE_ROWSIZE);
    String userType             = searchMap.getString("USERTYPE");
	String callbackFunction		= searchMap.getString("CALLBACKFUNCTION");
	String authCodes			= searchMap.getString("AUTHCODES");
	String signTypeCode			= searchMap.getString("SIGNTYPECODE");
	String signTypeName			= searchMap.getString("SIGNTYPENAME");
	String signUserCodestr		= searchMap.getString("SIGNUSERCODESTR");
	String jeongyeonAbleYn		= searchMap.getString("JEONGYEONABLEYN");
	String groupTypeCodes		= searchMap.getString("GROUPTYPECODES");
	String rootCodeId			= searchMap.getString("ROOTCODEID");
	String defaultSet			= searchMap.getString("DEFAULTSET");
	String multiSelect			= searchMap.getDefStr("MULTISELECT","Y");

	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult		= resultMap.getResult("VIEW");
	SQLResults listResult		= resultMap.getResult("LIST");

	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);

    String tit                  = "";
    String select               = "";
   /*  if("chamjo".equals(userType)){
        tit = StringUtil.getLocaleWord("L.참조자", siteLocale);
    }else if("susinja".equals(userType)) {
   	 	tit = StringUtil.getLocaleWord(Label.수신자, siteLocale);
    }else {
   		 tit = StringUtil.getLocaleWord(Label.사용자, siteLocale);
    } */
 	tit = StringUtil.getLocaleWord("L.사용자", siteLocale);
 	select = StringUtil.getLocaleWord("L.선택", siteLocale);



	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE",  "|" + StringUtil.getLocaleWord("S.전체",siteLocale));

	String groupCdPath = loginUser.getGroupUuidPath();

    String[] arrGroupPath = StringUtil.split(groupCdPath, CommonConstants.SEPAR_CONNECTPATH);

    String schFieldCodestr 		= "0|"+StringUtil.getLocaleWord("L.성명", siteLocale)+"^1|"+StringUtil.getLocaleWord("L.부서", siteLocale);

%>

<form name="form1" method="post" onsubmit="return false;">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="callbackFunction" value="<%=callbackFunction%>" />
	<input type="hidden" name="signTypeCode" value="<%=signTypeCode%>" />
	<input type="hidden" name="signUserCodestr" value="<%=signUserCodestr%>" />
	<input type="hidden" data-type="search" name="groupTypeCodes" value="<%=groupTypeCodes%>" />
	<input type="hidden" data-type="search" name="rootCodeId" value="<%=rootCodeId%>" />
<%if(StringUtil.isNotBlank(authCodes)){ %>
	<input type="hidden" data-type="search" name="auth_codes" value="<%=authCodes%>" />
<%} %>
	<table class="none">
		<colgroup>
			<col width="54%" />
			<col width="46%" />
		</colgroup>
		<tr>
			<td align="left" valign="top">
				<table class="basic">
				<caption><%=tit%> <%=select %></caption>
					<tr>
						<td>
						<div class="table_cover">
							<table class="box">
								<tr>
									<%-- <th width="15%"><%=HtmlUtil.getSelect(request,  true, "USR_SEQ", "USR_SEQ", schFieldCodestr, "", "data-type=\"search\"")%></th>	 --%>
									<td width="80%">
										<input type="text" name="sch_name" id="sch_name" value=""  class="text width_max" data-type="search"  onkeydown="doSearch(true)" maxlength="30" />
										<%if("INVENT".equals(userType)){ %>
											<input type="hidden" name="userType" id="userType" data-type="search" value="<%=userType%>" />
										<%} %>
									</td>
									<td rowspan="3" style="text-align: center;">
					            			<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();" ><%=StringUtil.getLocaleWord("L.검색",siteLocale)%></a></span>
				            		</td>
				            	</tr>
							</table>
						</div>

						<table class="list" style="width:98%">
							<colgroup>
								<col width="32%" />
								<col width="20%" />
								<col width="40%" />
							</colgroup>
							<thead>
							<tr>
								<td colspan="4">
									<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="User_DeleteNode();"><%=StringUtil.getLocaleWord("L.삭제",siteLocale)%></a></span>
							<%if("INVENT".equals(userType)){ %>
<%-- 											<span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="goInsertUser();"><%=StringUtil.getLocaleWord("L.외부발명자추가",siteLocale)%></a></span> --%>
							<%} %>
								</td>
							</tr>
							<tr>
								<th><%=StringUtil.getLocaleWord("L.성명",siteLocale)%></th>
								<th><%=StringUtil.getLocaleWord("L.호칭",siteLocale)%></th>
								<th><%=StringUtil.getLocaleWord("L.부서",siteLocale)%></th>
							</tr>
							</thead>
							<tbody id="treeArea"> </tbody>
						</table>
						</td>
					</tr>
				</table>

			</td>
			<td align="right" valign="top">
				<table class="basic">
					<caption>
						<%=tit%>
					</caption>
					<tr>
						<td>
							<div class="table_cover" style="height:412px;">
								<table class="list" style="width:98%">
									<colgroup>
										<col width="8%" />
										<col width="32%" />
										<col width="20%" />
										<col width="40%" />
									</colgroup>
									<thead>
									<tr>
										<td colspan="4">
											<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="User_DeleteNode();"><%=StringUtil.getLocaleWord("L.삭제",siteLocale)%></a></span>
									<%if("INVENT".equals(userType)){ %>
<%-- 											<span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="goInsertUser();"><%=StringUtil.getLocaleWord("L.외부발명자추가",siteLocale)%></a></span> --%>
									<%} %>
										</td>
									</tr>
									<tr>
										<th><input type="checkbox" name="chkSignListAll" id="chkSignListAll" /></th>
										<th><%=StringUtil.getLocaleWord("L.성명",siteLocale)%></th>
										<th><%=StringUtil.getLocaleWord("L.호칭",siteLocale)%></th>
										<th><%=StringUtil.getLocaleWord("L.부서",siteLocale)%></th>
									</tr>
									</thead>
									<tbody id="tbodyUserList">

<%
	if(listResult != null && listResult.getRowCount()> 0){
		for(int i=0; i< listResult.getRowCount(); i++){
			String login_id 	= listResult.getString(i, "login_id");
			String user_no	 	= listResult.getString(i, "user_no");
			String uuid			= listResult.getString(i, "uuid");
			String name				= listResult.getString(i, "name_"+siteLocale);
			String name_ko			= listResult.getString(i, "name_ko");
			String name_en			= listResult.getString(i, "name_en");
			String position_name			= listResult.getString(i, "position_name_"+siteLocale);
			String position_name_ko			= listResult.getString(i, "position_name_ko");
			String position_name_en			= listResult.getString(i, "position_name_en");
			String position_code			= listResult.getString(i, "position_code");
			String group_name				= listResult.getString(i, "group_name_"+siteLocale);
			String group_name_ko			= listResult.getString(i, "group_name_"+siteLocale);
			String group_name_en			= listResult.getString(i, "group_name_en");
			String parent_group_name_ko			= listResult.getString(i, "parent_group_name_ko");
			String group_code			= listResult.getString(i, "group_code");
			String group_uuid			= listResult.getString(i, "group_uuid");
			String address_ko			= listResult.getString(i, "address_ko");
			String address_en			= listResult.getString(i, "address_en");
			String telephone_no			= listResult.getString(i, "telephone_no");
			String email				= listResult.getString(i, "email");
			String registration_no		= listResult.getString(i, "registration_no");
			String group_type_code		= listResult.getString(i, "group_type_code");
			String type_code		= listResult.getString(i, "type_code");
			String nation_code		= listResult.getString(i, "nation_cod");
			String nation_name		= listResult.getString(i, "nation_name");
			String hoesa_cod		= listResult.getString(i, "hoesa_cod");
			String rel_psn_no		= listResult.getString(i, "rel_psn_no");
			String birth = "";
			if(!"".equals(registration_no) && registration_no != null){
				birth = registration_no.substring(0,6);
			}
%>
									<tr data-meaning="apvr_tr" id="sel_<%=uuid%>">
										<td style="text-align:center">
											<input type="checkbox" name="chkSignList"  value="sel_<%=uuid%>">
									        <input type="hidden" name="uuid" value="<%=uuid%>"/>
									        <input type="hidden" name="user_no" value="<%=user_no%>"/>
											<input type="hidden" name="name_ko" value="<%=name_ko%>"/>
											<input type="hidden" name="name_en" value="<%=name_en%>"/>
											<input type="hidden" name="login_id" value="<%=login_id%>"/>
											<input type="hidden" name="position_code" value="<%=position_code%>"/>
											<input type="hidden" name="position_name_ko" value="<%=position_name_ko%>"/>
											<input type="hidden" name="position_name_en" value="<%=position_name_en%>"/>
											<input type="hidden" name="group_name_ko" value="<%=group_name_ko%>"/>
											<input type="hidden" name="group_name_en" value="<%=group_name_en%>"/>
											<input type="hidden" name="group_code" value="<%=group_code%>"/>
											<input type="hidden" name="group_uuid" value="<%=group_uuid%>"/>
											<input type="hidden" name="address_ko" value="<%=address_ko%>"/>
											<input type="hidden" name="address_en" value="<%=address_en%>"/>
											<input type="hidden" name="telephone_no" value="<%=telephone_no%>"/>
											<input type="hidden" name="email" value="<%=email%>"/>
											<input type="hidden" name="registration_no" value="<%=registration_no%>"/>
											<input type="hidden" name="group_type_code" value="<%=group_type_code%>"/>
											<input type="hidden" name="type_code" value="<%=type_code%>"/>
											<input type="hidden" name="birth" value="<%=birth%>"/>
											<input type="hidden" name="nation_code" value="<%=nation_code%>"/>
											<input type="hidden" name="nation_name" value="<%=nation_name%>"/>
									        <input type="hidden" name="hoesa_cod" value="<%=hoesa_cod%>"/>
									        <input type="hidden" name="rel_rsn_no" value="<%=rel_psn_no%>"/>
										</td>
										<td style="text-align:center"><%=name%></td>
										<td style="text-align:center"><%=position_name%></td>
										<td style="text-align:center"><%=group_name_ko%></td>
									</tr>
<%
		}
	}
%>

									</tbody>
								</table>
							</div>
						</td>
					</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
	<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doConfirm(document.form1);" ><%=StringUtil.getLocaleWord("L.확인",siteLocale)%></a></span>
</div>
<script id="addUserListTmpl" type="text/x-jquery-tmpl">
<tr data-meaning="apvr_tr" >
	<td style="text-align:center" id="\${UUID}">
		<a href="javascript:void(0)" onClick="selectNode('\${UUID}')">\${NAME_<%=siteLocale.toUpperCase()%>}</a>
		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="user_no" value="\${USER_NO}"/>
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="name_en" value="\${NAME_EN}"/>
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
		<input type="hidden" name="type_code" value="\${TYPE_CODE}"/>
		<input type="hidden" name="birth" value="\${BIRTH}"/>
		<input type="hidden" name="nation_code" value="\${NATION_CODE}"/>
		<input type="hidden" name="nation_name" value="\${NATION_NAME}"/>
		<input type="hidden" name="hoesa_cod" value="\${HOESA_COD}"/>
		<input type="hidden" name="rel_psn_no" value="\${REL_PSN_NO}"/>
		<input type="hidden" name="status_name_ko" value="\${STATUS_NAME_KO}"/>
		<input type="hidden" name="status_name_en" value="\${STATUS_NAME_EN}"/>
	</td>
	<td align="center">
		\${POSITION_NAME_<%=siteLocale.toUpperCase()%>}
	</td>
	<td align="center">
		\${GROUP_NAME_<%=siteLocale.toUpperCase()%>}
	</td>
</tr>
</script>
<script id="addUserSelctTmpl" type="text/x-jquery-tmpl">
<tr data-meaning="apvr_tr" id="sel_\${UUID}">
	<td align="center">
		<input type="checkbox"  value="sel_\${UUID}" name="chkSignList" >
	</td>
	<td style="text-align:center">
		\${NAME_<%=siteLocale.toUpperCase()%>}
		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="user_no" value="\${USER_NO}"/>
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="name_en" value="\${NAME_EN}"/>
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
		<input type="hidden" name="type_code" value="\${TYPE_CODE}"/>
		<input type="hidden" name="birth" value="\${BIRTH}"/>
		<input type="hidden" name="nation_code" value="\${NATION_CODE}"/>
		<input type="hidden" name="nation_name" value="\${NATION_NAME}"/>
		<input type="hidden" name="hoesa_cod" value="\${HOESA_COD}"/>
		<input type="hidden" name="rel_psn_no" value="\${REL_PSN_NO}"/>
		<input type="hidden" name="status_name_ko" value="\${STATUS_NAME_KO}"/>
		<input type="hidden" name="status_name_en" value="\${STATUS_NAME_EN}"/>
	</td>
	<td align="center">
		\${POSITION_NAME_<%=siteLocale.toUpperCase()%>}
	</td>
	<td align="center">
		\${GROUP_NAME_<%=siteLocale.toUpperCase()%>}
	</td>
</tr>
</script>
<script type="text/javascript">
var jsonData = {};
var doSearch = function(isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {
		return;
	}

	$("#treeArea").html("");
	getUserJsonList();
}
var getUserJsonList = function(){


	airSd.callAjax("SYS_USER","JSON_LIST", airCommon.getSearchQueryParams(), function(data){

		$("#addUserListTmpl").tmpl(data).appendTo("#treeArea");

	});

}
/**
 * 사용자 선택 이벤트 처리
 */
 function User_AddNode(json)
 {
	//-- 이미 선택된 사용자인지 여부 체크!
	if(chkUserId(json)){
		var data = JSON.parse(json);
		 if("N" == "<%=multiSelect%>"){
			 $("#tbodyUserList").html("");
		 }
		$("#addUserSelctTmpl").tmpl(data).appendTo("#tbodyUserList");
	}


 }
 /**
 *	같은 사용자 선택 했는지 체크
 */
 function chkUserId(json){
	 var data = JSON.parse(json);
	 var arrObj = $("input:hidden[name='uuid']","#tbodyUserList");
	 var rtnBool = true;
	 arrObj.each(function(i, d){
		 if(data.UUID == $(d).val()){
			 rtnBool = false;
		 }
	 });

	 return rtnBool;

 }

 /**
  * 참조자 삭제
  */
 function User_DeleteNode() {
	 var list_obj	= document.getElementById("tbodyUserList");
	 var chk_obj 	= document.getElementsByName("chkSignList");

	 if ( chk_obj.length == 0 || !airCommon.isCheckedInput(chk_obj) ) {
		 alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale, "L.삭제할대상")%>");
		 return;
	 }
	 for (var i = chk_obj.length-1; i >= 0; i--) {
		 if (chk_obj[i].checked){
			 list_obj.deleteRow(i);
		 }
	 }
	 $("#chkSignListAll").removeAttr("checked");

 }

 /**
  * 확인 처리
  */
 function doConfirm(frm) {
	var mode_code	= frm.<%=CommonConstants.MODE_CODE%>.value;
 	var func_src 	= unescape(frm.callbackFunction.value);

 	//-- 부서 선택 여부 체크!
 	var chkBox = $("input:checkbox[name='chkSignList']");
 	if(chkBox.length == 0){
 		alert("<%=StringUtil.getScriptMessage("M.선택건없음",siteLocale)%>");
 		return;
 	}

 	var data = [];
 	chkBox.each(function(i, e){

 		var codGrp = $("#"+$(this).val());
 		var obj = codGrp.find("input:hidden");
 		var jsonData = {};

 		$(obj).each(function(i, d){
 			jsonData[$(d).attr("name").toUpperCase()] = $(d).val();
 		});
 		data.push(jsonData);
 	});
 	if (mode_code.indexOf("POPUP_") > -1) {
 		opener.<%=callbackFunction%>(JSON.stringify(data));
 	} else {
 		parent.<%=callbackFunction%>(JSON.stringify(data));
 	}
	self.close();

 }


$('input[name=chkSignListAll]').click(function(){
	var o_tar = $('input:checkbox[name=chkSignList]');
	var tarChecked;

	tarChecked = $('input:checkbox[name=chkSignListAll]').prop('checked');

	$('input:checkbox[name=chkSignList]').each(function(idx, elem){
		if(!$(this).prop('disabled')){
			if(tarChecked){
				$(this).prop("checked",true);
			}else{
				$(this).prop("checked",false);
			}
		}
	});

});
var selectNode = function(code_id){

	var codGrp = $("#"+code_id);
	var obj = codGrp.children("input:hidden");
	var jsonData = {};
	$(obj).each(function(i, d){
		jsonData[$(d).attr("name").toUpperCase()] = $(d).val();
	});
	User_AddNode(JSON.stringify(jsonData));

};

$(function(){
});


</script>