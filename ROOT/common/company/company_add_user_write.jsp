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
	SQLResults compList	= responseMap.getResult("COMP_LIST");

	//-- 파라메터 셋팅
	String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode	= responseMap.getString(CommonConstants.MODE_CODE);

	//-- 코드정보 문자열 셋팅
	String userAuthListStr	= StringUtil.getCodestrFromSQLResults(userAuthListResults, "CODE,LANG_CODE","");
	String userStatListStr	= StringUtil.getCodestrFromSQLResults(userStatListResults, "CODE,LANG_CODE","");

	String sysUserPosStr	= StringUtil.getCodestrFromSQLResults(sysUserPos, "CODE,LANG_CODE",	"|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String sysUserGrdStr	= StringUtil.getCodestrFromSQLResults(sysUserGrd, "CODE,LANG_CODE",	"|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String sysUserDutyStr	= StringUtil.getCodestrFromSQLResults(sysUserDuty, "CODE,LANG_CODE","|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));
	String compListStr		= StringUtil.getCodestrFromSQLResults(compList, "UUID,NAME_"+ siteLocale,"|"+StringUtil.getLocaleWord("L.CBO_SELECT", siteLocale));

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
%>
<script type="text/javascript">
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
		if(frm.group_uuid.value == ""){
			alert("업체를 선택해 주세요.");
			return;
		}
		if(frm.name_ko.value == ""){
			alert("성명(한글)을 입력해주십시오.");
			return;
		}
<%-- 
	<%if(!"OG".equals(userType)){%>
		<%if("WRITE_FORM_ADD_USER".equals(modeCode)){%>
		if(frm.login_id_exist_yn.value == ""){
			alert("ID 중복확인을 수행해 주십시오.");
			return;
		}

		if(frm.login_id_exist_yn.value == "Y"){
			alert("동일한 ID가 존재합니다. 다른 아이디를 입력 후 중복확인을 수행해주십시오.");
			return;
		}
		if(frm.password.value == "") {
			//PASSWORD를 입력해주십시오
			alert("<%=StringUtil.getScriptMessage("M.입력해주세요",siteLocale, StringUtil.getScriptMessage("L.Password", siteLocale))%>");
			return;
		}
		<%}%>
	<%}%>
	 --%>
		if(frm.email.value == ""){
			//EMAIL을 입력해주십시오
			alert("<%=StringUtil.getScriptMessage("M.입력해주세요",siteLocale, StringUtil.getScriptMessage("L.EMAIL", siteLocale))%>");
			return;
		}
<%--
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
 --%>
	<%if("OG".equals(userType)){%>
		if(frm.jumin1.value == "" || frm.jumin2.value == ""){
			if(confirm("입력하는 사용자가 내국인 일 경우 주민번호는 필히 입력해야 합니다.\n 입력하시겠습니까?")){
				frm.jumin1.focus();
				return;
			}
		}
	<%}%>

		if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT",siteLocale,"L.저장")%>")) {
			if (frm.current_mode_code.value == "UPDATE_FORM_ADD_USER") {
				frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_PROC_ADD_USER";
			} else {
				frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_PROC_ADD_USER";
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
</script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="current_mode_code" value="<%=modeCode%>" />
	<input type="hidden" name="login_id_exist_yn" value="" />
	<input type="hidden" name="uuid" value="<%=uuid%>" />
	<input type="hidden" name="userType" value="<%=userType%>" />
<div class="table_cover">
	<table class="basic">
		<tr>
			<th class="th2"><Input type="button" class="required" tabindex="-1">로펌명<%-- <%=StringUtil.getLocaleWord("L.업체명", siteLocale) %> --%></th>
			<td class="td2" colspan="3">
				<%if(StringUtil.isNotBlank(group_uid)){ %>
					<%//=StringUtil.getCodestrValue(request,userMap.getDefStr("GROUP_UID", group_uid), compListStr)%>
					<%=StringUtil.convertForInput(compList.getRowResult(0).get("NAME_KO"))%>
					<input type="hidden" name="COMPANY_NAME_KO" id="COMPANY_NAME_KO" value="<%=userMap.getDefStr("COMPANY_NAME_KO", group_uid)%>"/>
					<input type="hidden" name="company_uid" id="company_uid" value="<%=userMap.getDefStr("COMPANY_UID", company_uid)%>"/>
					<input type="hidden" name="group_uuid" id="group_uuid" value="<%=userMap.getDefStr("GROUP_UUID", group_uid)%>"/>
				<%}else{ %>
				<%=HtmlUtil.getSelect(request,  true, "group_uuid", "group_uuid", compListStr, userMap.getDefStr("GROUP_UUID",group_uid), "") %>
				<%}%>
			</td>
		</tr>
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1">성명</th>
			<td class="td4"><input type="text" name="name_ko" class="text width_max" value="<%=userMap.getStringEditor("NAME_KO")%>"></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.성명", siteLocale)%>(<%=StringUtil.getLocaleWord("L.영문", siteLocale)%>)</th>
			<td class="td4"><input type="text" name="name_en" class="text width_max" value="<%=userMap.getStringEditor("NAME_EN")%>"></td>
		</tr>
<%-- 
		<tr>
			<th class="th2"><%=StringUtil.getLocaleWord("L.직책", siteLocale) %></th>
			<td class="td2" colspan="3">
				<input type="text" name="jigchaeg" class="text" value="<%=StringUtil.convertForInput(jigchaeg)%>">
			</td>
		</tr> 
--%>
		<%
		if("OG".equals(userType)){
		%>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.소속", siteLocale)%></th>
			<td class="td4">
				<input type="text" name="sosock_tit" class="text width_max" value="<%=userMap.getStringEditor("SOSOCK_TIT")%>">
			</td>
			<th class="th4"><Input type="button" class="required" tabindex="-1">주민번호</th>
			<td class="td4">
<%-- 				
				<input type="text" name="jumin1" class="text" value="<%=StringUtil.convertForInput(jumin1)%>" maxlength="6">
				<input type="password" name="jumin2" class="text" value="<%=StringUtil.convertForInput(jumin2)%>" maxlength="7"> 
--%>
			</td>
		</tr>
		<%
			}else{
				%>
					<%-- 
					<tr>
						<th class="th4"><Input type="button" class="required" tabindex="-1">ID</th>
						<td class="td4" style="vertical-align:middle;">
							<%if("WRITE_FORM_ADD_USER".equals(modeCode)){%>
							<input type="text" name="login_id" id="login_id" class="text" style="width:60%; margin-top:1px;">
							<span class="ui_btn medium icon" style="margin-top:0px; margin-left:2px"><span class="confirm"></span><a href="javascript:doLoginIdCheck(document.form1)"><%=StringUtil.getLocaleWord("B.중복확인",siteLocale)%></a></span>
							<%}else{%>
							<input type="text" name="login_id" class="text" style="width:90%;border:0px" readonly value="<%=userMap.getStringEditor("LOGIN_ID")%>">
							<%}%>
						</td>
						<th class="th4">
							<%if("WRITE_FORM_ADD_USER".equals(modeCode)){%>
								<Input type="button" class="required" tabindex="-1">PASSWORD
							<%}else{ %>
								PASSWORD
							<%} %>
						</th>
						<td class="td4"><input type="password" name="password" class="text width_max" value="<%=userMap.getStringEditor("LOGIN_PWD") %>" /></td>
					</tr>
					 --%>
				<%
			}
		%>
		<%-- <tr>
			<th class="th4">직급</th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request,  true, "duty_code", "duty_code", sysUserDutyStr, userMap.getString("DUTY_CODE"), "style='width:98%;'") %>
			</td>
			<th class="th4">직책</th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request,  true, "position_code", "position_code", sysUserPosStr, userMap.getString("POSITION_CODE"), "style='width:98%;'") %>
			</td>
		</tr> --%>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.전화번호", siteLocale)%></th>
			<td class="td4"><input type="text" name="telephone_no" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("TELEPHONE_NO"))%>"></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.휴대전화번호", siteLocale)%></th>
			<td class="td4"><input type="text" name="mobile_no" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("MOBILE_NO"))%>"></td>
		</tr>
		<tr>
			<%-- 
			<th class="th4"><%=StringUtil.getLocaleWord("L.모바일", siteLocale)%></th>
			<td class="td4"><input type="text" name="fax_no" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("FAX_NO"))%>"></td>
			 --%>
			<th class="th2"><Input type="button" class="required" tabindex="-1"><%=StringUtil.getLocaleWord("L.이메일", siteLocale)%></th>
			<td class="td2" colspan="3"><input type="text" name="email" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("EMAIL"))%>"></td>
		</tr>
		<tr>
			<th class="th2">특이사항</th>
			<td class="td2" colspan="3"><input type="text" name="etc" class="text width_max" value="<%=StringUtil.convertForInput(userMap.getString("ETC"))%>"></td>
		</tr>
<%--
		<tr>
		<th class="th4"><Input type="button" class="required" tabindex="-1">사용자 권한</th>
		<td class="td4" colspan="3" style="line-height:20px;">
			<%
			if("OG".equals(userType)){
				%>
					<input type="radio" name="auth_codes" id="auth_codes0"  value="CMM/GSJ" checked >
					<label for="auth_codes0" title="<%=StringUtil.getLocaleWord("L.공통게스트사용자", siteLocale)%>" style="cursor:pointer;" ><%=StringUtil.getLocaleWord("L.공통게스트사용자", siteLocale)%></label>
				<%
			}else{
				%>
						<%=HtmlUtil.getInputCheckboxBr(request, true, "auth_codes", userAuthListStr, userMap.getStringEditor("AUTH_CODES"), "", "",4) %>
				<%
			}
			%>
			</td>
		</tr>
--%>
		<tr>
			<th class="th4"><Input type="button" class="required" tabindex="-1">사용유무</th>
			<td class="td4" colspan="3">
				<%=HtmlUtil.getSelect(request,  true, "status_code", "status_code", userStatListStr, userMap.getStringEditor("STATUS_CODE"), "") %>
			</td>
		</tr>
	</table>
</div>
	<div class="buttonlist">
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:doSubmit(document.form1)"><%=StringUtil.getLocaleWord("B.저장",siteLocale)%></a></span>
	</div>
</form>