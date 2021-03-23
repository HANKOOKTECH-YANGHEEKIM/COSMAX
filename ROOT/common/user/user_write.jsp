<%@page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo = requestMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap responseMap 		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewUserResults		= responseMap.getResult("VIEW_USER");
	SQLResults userAuthListResults	= responseMap.getResult("USER_AUTH_LIST");
	SQLResults userStatListResults	= responseMap.getResult("USER_STAT_LIST");

	SQLResults sysUserPos	= responseMap.getResult("SYS_USER_POS");
	SQLResults sysUserGrd	= responseMap.getResult("SYS_USER_GRD");
	SQLResults sysUserDuty	= responseMap.getResult("SYS_USER_DUTY");
	SQLResults hoesaList	= responseMap.getResult("HOESA_LIST");
	SQLResults compList		= responseMap.getResult("COMP_LIST");
	
	
	//-- 파라메터 셋팅
	String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode	= responseMap.getString(CommonConstants.MODE_CODE);
	
	//-- 코드정보 문자열 셋팅
	String userAuthListStr	= StringUtil.getCodestrFromSQLResults(userAuthListResults, "CODE,LANG_CODE","");
	String userStatListStr	= StringUtil.getCodestrFromSQLResults(userStatListResults, "CODE,LANG_CODE","");

	String sysUserPosStr	= StringUtil.getCodestrFromSQLResults(sysUserPos, "CODE,LANG_CODE",	"|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String sysUserGrdStr	= StringUtil.getCodestrFromSQLResults(sysUserGrd, "CODE,LANG_CODE",	"|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String sysUserDutyStr	= StringUtil.getCodestrFromSQLResults(sysUserDuty, "CODE,LANG_CODE","|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String hoesaListStr		= StringUtil.getCodestrFromSQLResults(hoesaList, "CODE_ID,LANG_CODE","|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String compListStr		= StringUtil.getCodestrFromSQLResults(compList, "CODE,LANG_CODE","|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));

	BeanResultMap userMap = new BeanResultMap();

	if(viewUserResults != null && viewUserResults.getRowCount() > 0){
		userMap.putAll(viewUserResults.getRowResult(0));
	}

	String uuid = userMap.getDefStr("UUID", StringUtil.getRandomUUID());
	String group_uid 	= StringUtil.convertNull(request.getParameter("group_uid"));
	String company_uid	= StringUtil.convertNull(request.getParameter("company_uid"));
	String userType		= StringUtil.convertNull(request.getParameter("userType"));  //OG 외부발명자
	
	if("OG".equals(userType)){
		group_uid = "3__99990000000000000000000000000";
		company_uid = "3DV48J9CALXMISI8KAJNGZP2KHQM78O6";
	}
	
	String readOnly = "";
	String nameKoYn = "";
	boolean selectEnabled = false;
	boolean companyCmm = false;
	
	if(loginUser.isCmmAdmin()){	// 시스템 관리자 이고, 
		
		// 인터페이스 업체가 아닐 경우
		if(!userMap.getDefStr("HOESA_COD",group_uid).equals("SYS_COM_GROUP_001") 
				&& !userMap.getDefStr("HOESA_COD",group_uid).equals("SYS_COM_GROUP_002") 
				&& !userMap.getDefStr("HOESA_COD",group_uid).equals("SYS_COM_GROUP_003") 
				&& !userMap.getDefStr("HOESA_COD",group_uid).equals("SYS_COM_GROUP_004"))
		{
			readOnly =  "";
			selectEnabled = true;
			companyCmm = true;
		}else{
			readOnly = "disabled=\"disabled\"";
			nameKoYn = "N";
			selectEnabled = true;
		}
	}else{
		readOnly = "disabled=\"disabled\"";
		nameKoYn = "N";
		selectEnabled = false;
	}
	
%>
<script type="text/javascript">

	var chkAdmin = <%= loginUser.isCmmAdmin() %>;
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

	/**
	 * 저장
	 */
	function doSubmit(frm) {
		
		var chkAdmin = <%= loginUser.isCmmAdmin() %>;
		
		if(!chkAdmin){
			
			if((frm.change_login_pwd.value != frm.change_login_pwd_chk.value) || (frm.change_login_pwd.value == "" || frm.change_login_pwd_chk.value == "")){
				alert("변경할 비밀번호가 일치하지 않습니다");
				frm.change_pwd_chk.focus();
				return;
			}
		
		}else{
			
			if(<%= modeCode.equals("INSERT_FORM")%>){
				
				if(frm.login_id.value == ""){
					alert("사용자 ID를 입력해 주십시오.");
					return;
				}
				
				if(frm.hoesa_cod.value == ""){
					alert("업체명을 선택해 주세요.");
					return;
				}
				
				if(frm.name_ko.value == ""){
					alert("성명(한글)을 입력해주십시오.");
					return;
				}
				
				var objAuth = document.getElementsByName("auth_codes");
				var checkYn = "N";
				if(objAuth.length > 0){
					for(var i=0; i<objAuth.length; i++){
						if(objAuth[i].checked == true){
							checkYn = "Y";
						}
					}
				}
	
				if(checkYn == "N"){
					alert("사용자 권한에 체크된 값이 없습니다.");
					return;
				}
			}
			<%if(userMap.getString("LOGIN_ID").equals(loginUser.getLoginId())
					|| Boolean.valueOf(modeCode.equals("INSERT_FORM"))
					){%>
			if(frm.login_pwd.value == ""){
				alert("비밀번호를 입력해주십시오.");
				return;
			}
			<%}%>
		}

		if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT",siteLocale,"L.저장")%>")) {
			
			frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_PROC";
			
			if (frm.current_mode_code.value == "UPDATE_FORM") {
				frm.insertOrUpdate.value = "U";
			}else if (frm.current_mode_code.value == "INSERT_FORM") {
				frm.insertOrUpdate.value = "I";
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
				try{
					opener.doSearch();
				}catch(e){
					opener.location.href = opener.location.href;
				}
				window.close();
			}).fail(function(){
				alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
			});

		}
	}

	function doLoginIdCheck(frm){
		var login_id = frm.login_id.value;
		if("" == login_id){
			alert("ID를 입력 후 중복확인을 수행해 주십시오.");
			return;
		}
		
		$.ajax({
			url: "/ServletController"
			, type: "POST"
			, async: true
			, cache: false
			, data: {
				"AIR_ACTION":"SYS_USER"
				,"AIR_MODE":"LOGIN_ID_CHK"
				,"LOGIN_ID":login_id
			}
			, dataType: "json"
		}).done(function(data){

			var exist_yn = data.EXIST_YN;
			frm.login_id_exist_yn.value = exist_yn;

			if("N"==exist_yn){
				alert("사용가능한 ID 입니다.");
			}
		}).fail(function(){
			alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
		});
	}
	
	function doResetPw(frm){
		
		var data = {"LOGIN_ID":frm.login_id.value};
		var msg = "<%=StringUtil.getScriptMessage("M.초기화하시겠습니까", siteLocale,"L.비밀번호")%>";

		if(confirm(msg)){
			airCommon.callAjax("SYS_USER", "INIT_PASSWORD",data, function(json){
				alert("<%=StringUtil.getScriptMessage("M.처리_되었습니다", siteLocale)%>");
			});
		}
	}
	
	function doPasswordChk(frm){
		
		if(chkAdmin){
			doSubmit(frm);
		}else{
			
			var login_id = frm.login_id.value;
			var login_login_pwd_chk = frm.login_pwd_chk.value;
			$.ajax({
				url: "/ServletController"
				, type: "POST"
				, async: true
				, cache: false
				, data: {
					"AIR_ACTION":"SYS_USER"
					,"AIR_MODE":"CHK_PASSWORD"
					,"LOGIN_ID":login_id
					,"LOGIN_PWD_CHK":login_login_pwd_chk
				}
				, dataType: "json"
			}).done(function(data){

				var exist_yn = data.EXIST_YN;

				if("N"==exist_yn){
					alert("<%=StringUtil.getScriptMessage("M.비밀번호확인", siteLocale)%>");
				}else{
					doSubmit(frm);
				}
			}).fail(function(){
				alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
			});
			
		}
	}
	
	function checkCopy(){
		alert("복사가 불가능합니다.");
		event.preventDefault();
	}
	function checkPaste(){
		alert("붙여넣기가 불가능합니다.");
		event.preventDefault();
	}

	
</script>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.사용자정보", siteLocale) %>" data-options="tools:'#listTabsTools-LIST'" style="padding-top:5px">
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="current_mode_code" value="<%=modeCode%>" />
	<input type="hidden" name="login_id_exist_yn" value="" />
	<input type="hidden" name="uuid" value="<%=uuid%>" />
	<input type="hidden" name="userType" value="<%=userType%>" />
	<input type="hidden" name="insertOrUpdate" value="" />
	
<div class="table_cover">
	
<%if(loginUser.isCmmAdmin()){%>
	
	<table class="basic">
		<tr>
			<th class="th2"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.사용자ID", siteLocale) %></th>
			<td class="td4"><input type="text" name="login_id" class="text width_max" <%if("N".equals(nameKoYn)){%> style="background-color: #EAEAEA"  readonly="readonly" <%}%> value="<%=userMap.getStringEditor("LOGIN_ID")%>" ></td>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.비밀번호", siteLocale) %></th>
			<td class="td4">
				<input size="10%" type="password" name="login_pwd" class="text" value="">
				<%if(loginUser.isCmmAdmin() || !Boolean.valueOf(modeCode.equals("INSERT_FORM"))){	 %>
				<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:doResetPw(document.form1)"><%=StringUtil.getLocaleWord("L.초기화", siteLocale) %></a></span>
				<%}	 %>
			</td>
		</tr>
		<tr>
			<th class="th2"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.업체명", siteLocale) %></th>
			<td class="td2" colspan="3">
				<%if(StringUtil.isNotBlank(group_uid)){ %>
					<%=StringUtil.getCodestrValue(request,userMap.getDefStr("HOESA_COD", loginUser.gethoesaCod()), hoesaListStr)%>
					<input type="hidden" name="hoesa_cod" id="hoesa_cod" value="<%=userMap.getDefStr("HOESA_COD", loginUser.gethoesaCod())%>"/>
				<%}else{ %>
					<%=HtmlUtil.getSelect(request, true, "hoesa_cod", "hoesa_cod", hoesaListStr, userMap.getDefStr("HOESA_COD",loginUser.gethoesaCod()), "")%>
				<%}%>
				<script>
<%-- 					if(<%//= companyCmm %> == true){  --%>
// 						$("#hoesa_cod option[value=SYS_COM_GROUP_001]").remove();
// 						$("#hoesa_cod option[value=SYS_COM_GROUP_002]").remove();
// 						$("#hoesa_cod option[value=SYS_COM_GROUP_003]").remove();
// 						$("#hoesa_cod option[value=SYS_COM_GROUP_004]").remove();
// 					}
				</script>
			</td>
		</tr>
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.성명", siteLocale) %></th>
			<td class="td4">
				<input type="text" name="name_ko" <%if("N".equals(nameKoYn)){%> style="background-color: #EAEAEA"  readonly="readonly" <%}%>  class="text width_max" value="<%=userMap.getStringEditor("NAME_KO")%>" >
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.전화번호", siteLocale)%></th>
			<td class="td4"><input type="text" name="telephone_no" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("TELEPHONE_NO"))%>"></td>
		</tr>
		 
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.이메일", siteLocale)%></th>
			<td class="td2" colspan="3"><input type="text" name="email" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("EMAIL"))%>"></td>
		</tr>
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.비고", siteLocale) %></th>
			<td class="td2" colspan="3"><input type="text" name="etc" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("ETC"))%>"></td>
		</tr>

		
		<%if (selectEnabled){ %>
		
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.사용자권한", siteLocale) %></th>
			<td class="td4" colspan="3" style="line-height:20px;">
				<%=HtmlUtil.getInputCheckboxBr(request, selectEnabled, "auth_codes", userAuthListStr, userMap.getStringEditor("AUTH_CODES"), "", "",4).replace("C.", "") %>
			</td>
		</tr>
		<%-- <%//if (Boolean.valueOf(companyCmm)){ %>
		<tr>
			<th class="th4"><%//=StringUtil.getLocaleWord("L.팀장여부", siteLocale) %></th>
			<td class="td4" colspan="3" style="line-height:20px;">
				<%//=HtmlUtil.getSelect(request, true, "CHIEF_YN", "CHIEF_YN", LmsUtil.getYnCodStr(), userMap.getDefStr("CHIEF_YN","N"), "") %>
			</td>
		</tr>
		<%} %> --%>
		<%} %>
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.사용유무", siteLocale) %></th>
			<td class="td4" colspan="3">
				<%=HtmlUtil.getSelect(request,  selectEnabled, "status_code", "status_code", userStatListStr, userMap.getStringEditor("STATUS_CODE"), "") %>
			</td>
		</tr>
	</table>

<%}else{%>	

	<table class="basic">
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.현재비밀번호", siteLocale) %></th>
			<td class="td4">
				<input type="hidden" name="login_id" class="text width_max" value="<%=userMap.getStringEditor("LOGIN_ID")%>">
				<input size="10%" type="password" name="login_pwd_chk" class="text" value="" >
			</td>
		</tr>
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.변경비밀번호", siteLocale) %> </th>
			<td class="td4">
				<input size="10%" type="password" name="change_login_pwd"  onpaste="checkPaste()" class="text" value="">
			</td>
		</tr>
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.변경비밀번호_확인", siteLocale) %></th>
			<td class="td4">
				<input size="10%" type="password" name="change_login_pwd_chk" onpaste="checkPaste()" class="text" value="">
			</td>
		</tr>
	</table>	

<% }%>
</div>
	<div class="buttonlist">
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:doPasswordChk(document.form1)"><%=StringUtil.getLocaleWord("B.저장",siteLocale)%></a></span>
	</div>
</form>
</div>
</div>