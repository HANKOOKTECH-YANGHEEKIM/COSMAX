<%@page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants"%>
<%@ page import="com.emfrontier.air.common.config.CommonProperties"%>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel"%>
<%@ page import="com.emfrontier.air.common.util.StringUtil"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>

<%
	//-- 파라메터 셋팅
	String actionCode = request.getParameter(CommonConstants.ACTION_CODE);
	String modeCode = request.getParameter(CommonConstants.MODE_CODE);

	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);

	String systemDefaultContentUrl = CommonProperties.getSystemDefaultContentUrl();

	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"),
			"CODE_ID,NAME_" + "KO", "|" + StringUtil.getLocaleWord("L.CBO_ALL", "KO"));

	//-- 테스트 사용자 로그인 기능 사용여부
	String testLoginYn = StringUtil.convertNull(request.getParameter("testLoginYn"));

	if (loginUser == null) {
		loginUser = new SysLoginModel();
	}

	if ("".equals(loginUser.getUUID())) {
%>
<script type="text/javascript">
/**
 * 로그인 처리
 */
function doSubmit(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	if (frm.loginHoesa.value == "") {
		alert("회사를 선택해 주세요.");
		frm.loginHoesa.focus();
		return;
	}	
	
	if (frm.loginId.value == "") {
		alert("ID를 입력해주세요.");
		frm.loginId.focus();
		return;
	}
		
	if (frm.loginPwd.value == "") {
		alert("Password를 입력해주세요.");
		frm.loginPwd.focus();
		return;
	}	
	
	//아이디 저장 체크
	if (frm.chkSaveId.checked) {
		airCommon.setCookie("loginHoesa", frm.loginHoesa.value, 4);
		airCommon.setCookie("loginId", frm.loginId.value, 7);
	} else {
		airCommon.setCookie("loginId", "", 7);
	}
	
	
	form1.target = "_self";	
	form1.submit();
}

/**
 * 아이디 focus
 */
$(document).ready(function() {
//	document.form1.loginId.focus();
// 	bgChgPw(document.form1.loginPwd);

   var login_Hoesa	= airCommon.getCookie("loginHoesa");
   var login_id	= airCommon.getCookie("loginId");
	
	if (login_id == "") {
		document.form1.loginId.focus();
	} else {
		document.form1.chkSaveId.checked = true;
		document.form1.loginHoesa.value = login_Hoesa;
		document.form1.loginId.value = login_id;
		document.form1.loginPwd.focus();	
	}
});
</script>
<div id="wrap_login">
	<div id="loginForm">
		<div id="log_wrap_bg">
			<div class="alt_txt">You need to login to use the legal system.</div>
			<div id="log_wrap">
				<form name="form1" method="post" action="/ServletController"
					onsubmit="return false;">
					<div id="login_wrap">
						<input type="hidden" name="AIR_ACTION" value="LMS_LOGIN" /> <input
							type="hidden" name="AIR_MODE" value="LOGIN_PROC" />
						<!-- 아이디 패스워드 이미지 -->
						<ul class="id_pw">
							<li>Company</li>
							<li>ID</li>
							<li>PW</li>
						</ul>
						<!-- 입력창 -->
						<ul class="in_out_put">
							<li><%=HtmlUtil.getSelect(request, true, "loginHoesa", "loginHoesa", HOESA_CODESTR, "",
						"data-type=\"search\" class=\"select width_half\" style=\"width:140px\"")%></li>
							<li><input type="text" name="loginId" id="loginId" value=""
								placeholder="ID" title="ID" class="login_id"
								onkeydown="doSubmit(document.form1, true)" tabindex="1"
								autocomplete="off" maxlength="30" /></li>
							<li><input type="password" name="loginPwd" id="loginPwd"
								value="" placeholder="Password" title="Password"
								class="login_pwd" onkeydown="doSubmit(document.form1, true)"
								tabindex="2" autocomplete="off" /></li>
						</ul>
						<!-- 로그인 이미지 -->
						<ul>
							<li class="login_btn" onclick="doSubmit(document.form1);"><span
								class="button">Login</span></li>
						</ul>
					</div>

					<!-- 체크박스 -->
					<div id="checklogin">
						<input type="checkbox" name="chkSaveId" id="chkSaveId" value="Y"
							title="아이디 저장" class="input" tabindex="3" /> <label
							for="chkSaveId" title="ID Save" class="label">ID Save</label>
					</div>
				</form>
			</div>
		</div>
		<br />
		<%
			if ("DEV".equals(CommonProperties.getSystemMode()) || "127.0.0.1".equals(request.getRemoteAddr())) {
		%>
		<div style="position: relative; width: 700px; margin: 0 auto;">
			<table
				style="position: relative; width: 100%; background: #F0F0F0; border: 1px solid #CCCCCC; margin: 0 auto; font-size: 12px;">
				<colgroup>
					<col style="width: 15%;" />
					<col style="width: auto;" />
				</colgroup>
				<tr>
					<th>코스맥스 의뢰부서</th>
					<td style="padding: 5px;"><a href="#"
						onClick="javascript:autoLog('t1','')"> 의뢰자 (현업 의뢰)</a>
						&nbsp;|&nbsp; <a href="#"
						onClick="javascript:autoLog('t2','')"> 결재자 (현업 의뢰)</a></td>
				</tr>
				<tr>
					<th>코스맥스 법무</th>
					<td style="padding: 5px;"><a href="#"
						onClick="javascript:autoLog('t3','')"> 담당자 (법무 담당)</a>
						&nbsp;|&nbsp; <a href="#"
						onClick="javascript:autoLog('t4','')"> 배당자 (법무 배당)</a>
						&nbsp;|&nbsp; <a href="#"
						onClick="javascript:autoLog('t5','')"> 법무임원 (법무 임원)</a></td>
				</tr>
				<!-- <tr>
				<th>의뢰 부서</th>
				<td style="padding:5px;">
					<a href="#" onClick="javascript:autoLog('GW77771','')">현의뢰 (현업 의뢰)</a> 
					&nbsp;|&nbsp;	
					<a href="#" onClick="javascript:autoLog('GW77773','')">현팀장 (현업 결재)</a>
					&nbsp;|&nbsp;	
					<a href="#" onClick="javascript:autoLog('GW77775','')">현참조 (현업 참조)</a>
				</td>
			</tr>
			<tr>
				<th>법무 부서</th>
				<td style="padding:5px;">
					<a href="#" onClick="javascript:autoLog('2016048','')">오법무 (법무 담당)</a>
					&nbsp;|&nbsp;
					<a href="#" onClick="javascript:autoLog('2017039','')">법팀장 (법무 배당)</a>
					&nbsp;|&nbsp;
					<a href="#" onClick="javascript:autoLog('2017006','')">법임원 (법무 임원)</a>				
					&nbsp;|&nbsp;
					<a href="#" onClick="javascript:autoLog('2016068','')">장법무 (법무 담당)</a>
				</td>
			</tr> -->
				<!-- tr>
				<th>인장 부서</th>
				<td style="padding:5px;"><a href="#" onClick="javascript:autoLog('2017159','')">이법무 (인감담당)</a>	</td>
			</tr-->
				<!-- 
			<tr>
				<th>임원</th>
				<td style="padding:5px;">
					<a href="#" onClick="javascript:autoLog('2017006','')">법임원 (법무 임원)</a>		
				</td>
			</tr> 
			-->
				<tr>
					<th>관리 부서</th>
					<!-- td style="padding: 5px;"><a href="#"
						onClick="javascript:autoLog('Slugger','')">관리자 (시스템 관리)</a></td-->
					<td style="padding: 5px;"><a href="#"
						onClick="javascript:autoLog('t9','')">관리자 (시스템 관리)</a></td>
				</tr>
			</table>
		</div>
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<br />
		<script type="text/javascript">
	function autoLog(no_str){
		var frm = document.form1 ;
	
		frm.loginId.value   = no_str;
		frm.loginPwd.value  = "empass10!";
		frm.submit();
	}
</script>
		<%
			}
		%>
	</div>
</div>
<%
	} else {
%>
<script type="text/javascript"> 
	location.replace('<%=CommonProperties.getSystemDefaultUrl()%>
	');
</script>
<%
	}
%>