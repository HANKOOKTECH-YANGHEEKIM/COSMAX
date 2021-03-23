<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap responseMap 		= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult 			= responseMap.getResult("VIEW");
	SQLResults natListResult 		= responseMap.getResult("NAT_LIST");
	SQLResults bankListResult 		= responseMap.getResult("BANK_LIST");
	SQLResults typeListResult 		= responseMap.getResult("TYPE_LIST");
	SQLResults classListResult 		= responseMap.getResult("CLASS_LIST");
	SQLResults statusListResult 	= responseMap.getResult("STATUS_LIST");
	SQLResults gugnaeoeListResult 	= responseMap.getResult("GUGNAEOE_LIST");

	//-- 파라메터 셋팅
	String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode	= responseMap.getString(CommonConstants.MODE_CODE);
	BeanResultMap masMap = new BeanResultMap();

	if(viewResult != null && viewResult.getRowCount() > 0){
		masMap.putAll(viewResult.getRowResult(0));
	}

	//-- 상세보기 값 셋팅
	String company_uid		= masMap.getDefStr("COMPANY_UID", StringUtil.getRandomUUID())  ;
	String group_uid		= masMap.getDefStr("GROUP_UID", StringUtil.getRandomUUID())  ;
	String code				= masMap.getString("CODE")  ;

	//-- 코드정보 문자열 셋팅
	String natCodestr 		= StringUtil.getCodestrFromSQLResults(natListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String bankCodestr 		= StringUtil.getCodestrFromSQLResults(bankListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String typeCodestr 		= StringUtil.getCodestrFromSQLResults(typeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String classCodestr 	= StringUtil.getCodestrFromSQLResults(classListResult, "CODE,LANG_CODE", "");
	String statusCodestr 	= StringUtil.getCodestrFromSQLResults(statusListResult, "CODE,LANG_CODE", "");
	String gugnaeoeCodestr 	= StringUtil.getCodestrFromSQLResults(gugnaeoeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
%>
<script type="text/javascript">
	/**
	 * 목록 페이지로 이동
	 */
	function goList(frm) {
		if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_GOLIST",siteLocale)%>")) {
			frm.<%=CommonConstants.MODE_CODE%>.value = "VIEW";
			frm.action = "/ServletController";
			frm.target = "_self";
			frm.submit();
		}
	}

	/**
	 * 저장
	 */
	function doSubmit(frm) {
		if (frm.name_ko.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, "L.기관명")%>");
			frm.name_ko.focus();
			return;
		}
<%--
		if (frm.short_name.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale,"L.약어")%>");
			frm.short_name.focus();
			return;
		}
--%>
// 		if (frm.biz_no.value != "" && frm.biz_no.value.length != 12) {
<%-- 			alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, "구분자(-)를 포함한 사업자등록번호")%>"); --%>
// 			frm.biz_no.focus();
// 			return;
// 		}

// 		if (frm.type_code.value == "") {
<%-- 			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale,"L.업체유형")%>"); --%>
// 			frm.type_code.focus();
// 			return;
// 		}

// 		if (frm.nat_code.value == "") {
<%-- 			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale,"L.국가")%>"); --%>
// 			frm.nat_code.focus();
// 			return;
// 		}


// 		if ($("input:checkbox[name='class_codes']:checked").length == 0) {
<%-- 			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale,"L.업체분류")%>"); --%>
// 			$("input:checkbox[name='class_codes']").eq(0).focus();
// 			return;
// 		}

// 		if (frm.post_no.value != "" && frm.post_no.value.length != 7) {
<%-- 			alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale, "구분자(-)를 포함한 우편번호")%>"); --%>
// 			frm.post_no.focus();
// 			return;
// 		}

// 		if (frm.vend_no.value == "") {
<%-- 			alert("<%=StringUtil.getScriptMessage("M.ALERT_INPUT",siteLocale,"L.거래처코드")%>"); --%>
// 			frm.vend_no.focus();
// 			return;
// 		}


// 		if (!fn_emailChk(frm.email.value)) {
// 			frm.email.focus();
// 			return;
// 		}

		if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT",siteLocale,"L.저장")%>")) {
			
<%-- 			frm.<%=CommonConstants.ACTION_CODE%>.value = "SYS_COMPANY"; --%>
			var mode = "";
			if (frm.current_mode_code.value == "UPDATE_FORM") {
<%-- 				frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_PROC"; --%>
				mode = "UPDATE_PROC";
			} else {
<%-- 				frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_PROC"; --%>
				mode = "WRITE_PROC";
			}

// 			frm.action = "/ServletController";
// 			frm.target = "_self";
// 			frm.submit();
			
			//--에디터 서브밋 처리
			airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
		
			airCommon.callAjax("SYS_COMPANY",mode, $(frm).serialize(), function(){
				alert("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT_DONE", siteLocale)%>");
				try{
					opener.doSearch(opener.document.form1);
				}catch(e){
					
				}
// 				opener.location.href = opener.location.href;
				window.close();
			});
			
		}
	}

	function fn_emailChk(email){
		var bol = true;
		var exptext = /^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/;
		if (exptext.test(email)!=true){
			alert("<%=StringUtil.getScriptMessage("M.이메일형식오류",siteLocale)%>");
			bol = false;
		}
		return bol;     // bol 값을 반환 . 이메일 형식이 아니면 false
	}

	//--디지스트 사무소 계좌검색
	var popupIf = function(){
		var url = "/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_COMPANY&<%=CommonConstants.MODE_CODE%>=POPUP_SELECT_IF_AGENT";
		url += "&callbackFunction=setIfinfo"
		airCommon.openWindow(url,"1024","500",'if_select',true,true);
	}

	var setIfinfo = function(REL_PSN_NO, BACCT_IDTF_NO){
		$("#vend_no").val(REL_PSN_NO);
		$("#bank_acnt_no").val(BACCT_IDTF_NO);
	}
</script>

<form name="form1" method="post">
<%-- 	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" /> --%>
<%-- 	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" /> --%>
<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
<input type="hidden" name="current_mode_code" value="<%=modeCode%>" />
<input type="hidden" name="company_uid" value="<%=company_uid%>" />
<input type="hidden" name="group_uid" value="<%=group_uid%>" />
<input type="hidden" name="code" value="<%=code%>" />
<input type="hidden" name="mig_id" value="<%=masMap.getString("MIG_ID")%>" />
<div class="table_cover">
	<table class="basic">
		<caption style="padding: 2px 2px 7px 14px;">로펌/변호사 정보</caption>
		<colgroup>
			<col style="width:12%" />
			<col style="width:21%" />
			<col style="width:12%" />
			<col style="width:21%" />
			<col style="width:12%" />
			<col style="width:auto" />
		</colgroup>
		<tr>
			<th><input type="button" class="required" tabindex="-1" />로펌명(국문)<%-- <%=StringUtil.getLocaleWord("L.업체명_국문", siteLocale) %> --%></th>
			<td><input type="text" name="name_ko" value="<%=masMap.getStringEditor("NAME_KO")%>" maxlength="50" class="text width_max" /></td>
			<th>로펌명(영문)<%-- <%=StringUtil.getLocaleWord("L.업체명_영문", siteLocale)%> --%></th>
			<td colspan="3"><input type="text" name="name_en" value="<%=masMap.getStringEditor("NAME_EN")%>" maxlength="50" class="text width_max" /></td>
			<%-- 	
			<th><input type="button" class="required" tabindex="-1" /><%=StringUtil.getLocaleWord("L.업체명", siteLocale)%>(영문<%=StringUtil.getLocaleWord("L.약어", siteLocale)%> 2자리)</th>
			<td><input type="text" name="short_name" value="<%=masMap.getStringEditor("SHORT_NAME")%>" maxlength="2" onkeyup="airCommon.validateAlpha(this, this.value);" style="text-transform: uppercase;" class="text width_max" /></td>
			<th><%=StringUtil.getLocaleWord("L.상태", siteLocale)%></th>
			<td><%=HtmlUtil.getSelect(request,  true, "status_code", "status_code", statusCodestr, masMap.getStringEditor("STATUS_CODE"), "")%></td>
		 	--%>
		</tr>
		<tr>
			<%-- 
			<th><%=StringUtil.getLocaleWord("L.사업자등록번호", siteLocale)%></th>
			<td><input type="text" name="biz_no" value="<%=masMap.getStringEditor("BIZ_NO")%>" size="20" maxlength="20" class="text width_max" /></td>
			 --%>
			<th><%=StringUtil.getLocaleWord("L.Contact변호사", siteLocale)%></th>
			<td><input type="text" name="ceo_name" value="<%=masMap.getStringEditor("CEO_NAME")%>" maxlength="30" class="text width_max" /></td>
			<th><%=StringUtil.getLocaleWord("L.전화번호", siteLocale)%></th>
			<td><input type="text" name="telephone_no" value="<%=masMap.getStringEditor("TELEPHONE_NO")%>" maxlength="50" class="text width_max" /></td>
			<th>이메일</th>
			<td><input type="text" name="email" value="<%=masMap.getStringEditor("EMAIL")%>" maxlength="50" class="text width_max" /></td>
		</tr>
		<%-- 
		<tr>
			<th><input type="button" class="required" tabindex="-1" />업체유형</th>
			<td><%=HtmlUtil.getSelect(request,  true, "type_code", "type_code", typeCodestr, masMap.getDefStr("TYPE_CODE","OU"), "")%></td>
			<th><%=StringUtil.getLocaleWord("L.업태", siteLocale)%></th>
			<td><input type="text" name="biz_part" value="<%=masMap.getStringEditor("BIZ_PART")%>" maxlength="50" class="text width_max" /></td>
			<th><%=StringUtil.getLocaleWord("L.종목", siteLocale)%></th>
			<td><input type="text" name="biz_gubun" value="<%=masMap.getStringEditor("BIZ_GUBUN")%>" maxlength="50" class="text width_max" /></td>
		</tr>
		 --%>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.국내국제", siteLocale)%></th>
			<td><%=HtmlUtil.getSelect(request, true, "gugnaeoe_code", "gugnaeoe_code", gugnaeoeCodestr, masMap.getStringEditor("GUGNAEOE_CODE"), "class=\"select width_max\"")%></td>
			<th>국가</th>
			<td><%=HtmlUtil.getSelect(request,  true, "nat_code", "nat_code", natCodestr, masMap.getStringEditor("NAT_CODE"), "class=\"select width_max\"")%></td>
			<th><%=StringUtil.getLocaleWord("L.팩스", siteLocale)%></th>
			<td><input type="text" name="fax_no" value="<%=masMap.getStringEditor("FAX_NO")%>" maxlength="50" class="text width_max" /></td>
		</tr>
	
		<%--
		<tr>
			<th><%=StringUtil.getLocaleWord("L.기본송금료", siteLocale)%></th>
			<td><input type="text" name="trans_cost" value="<%=StringUtil.convertFor(trans_cost, "INPUT")%>" maxlength="50" class="text width_max" /></td>
	<!-- 		<th><%=StringUtil.getLocaleWord("L.지급방식", siteLocale)%></th> -->
			<td><input type="text" name="pay_gubun" value="<%=StringUtil.convertFor(pay_gubun, "INPUT")%>" maxlength="50" class="text width_max" /></td>
		</tr>
		 --%>
	
		<tr>
			<th><%=StringUtil.getLocaleWord("L.홈페이지", siteLocale)%></th>
			<td colspan="5"><input type="text" name="homepage" value="<%=masMap.getStringEditor("HOMEPAGE")%>" maxlength="200" class="text width_max" /></td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.주소", siteLocale)%></th>
			<td colspan="5">
				(우편번호 : <input type="text" name="post_no" value="<%=masMap.getStringEditor("POST_NO")%>" size="7" maxlength="7" class="text" />)
				<br />
				<input type="text" name="address" value="<%=masMap.getStringEditor("ADDRESS")%>" maxlength="400" class="text width_max" style="margin-top:5px;" />
			</td>
		</tr>
		<%--
		<tr>
			<th><%=StringUtil.getLocaleWord("L.은행", siteLocale)%></th>
			<td><%=HtmlUtil.getSelect(request,  true, "bank_code", "bank_code", bankCodestr, masMap.getStringEditor("BANK_CODE"), "")%></td>
			<th><%=StringUtil.getLocaleWord("L.계좌번호", siteLocale)%></th>
			<td><input type="text" name="bank_acnt_no" value="<%=masMap.getStringEditor("BANK_ACNT_NO")%>" maxlength="20" class="text width_max" /></td>
			<th><%=StringUtil.getLocaleWord("L.예금주", siteLocale)%></th>
			<td><input type="text" name="bank_acnt_name" value="<%=masMap.getStringEditor("BANK_ACNT_NAME")%>" maxlength="30" class="text width_max" /></td>
		</tr>
		 --%>
		<tr>
			<th><input type="button" class="required" tabindex="-1" /><%=StringUtil.getLocaleWord("L.분류", siteLocale)%></th>
			<td colspan="5"><%=HtmlUtil.getInputCheckbox(request,  true, "class_codes", classCodestr, masMap.getStringEditor("CLASS_CODES"), "BS", "") %></td>
		</tr>
		<tr>
			<th>시작일 / 종료일</th>
			<td colspan="3">
				<%=HtmlUtil.getInputCalendar(request, true, "biz_bgn_date", "biz_bgn_date", masMap.getStringEditor("BIZ_BGN_DATE"), "")%>
				~
				<%=HtmlUtil.getInputCalendar(request, true, "biz_end_date", "biz_end_date", masMap.getStringEditor("BIZ_END_DATE"), "")%>
			</td>
			<th><%=StringUtil.getLocaleWord("L.상태", siteLocale)%></th>
			<td><%=HtmlUtil.getSelect(request,  true, "status_code", "status_code", statusCodestr, masMap.getStringEditor("STATUS_CODE"), "class='width_max'")%></td>
		</tr>
		<%--
		<tr>
			<th>거래처코드</th>
			<td>
				<input type="text" name="vend_no" id="vend_no" value="<%=masMap.getStringEditor("VEND_NO")%>" maxlength="400" readonly class="text width_max" />
				<input type="hidden" name="bank_acnt_no" id="bank_acnt_no" value="<%=masMap.getStringEditor("BANK_ACNT_NO")%>" />
				<span class="ui_btn small icon"><span class="search"></span><a href="javascript:popupIf()">계좌검색</a></span>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.협력업체이름", siteLocale)%></th>
			<td><input type="text" name="vendor_local_name" value="<%=StringUtil.convertFor(vendor_local_name, "INPUT")%>" maxlength="20" class="text width_max" /></td>
			<th><%=StringUtil.getLocaleWord("L.협력업체코드", siteLocale)%></th>
			<td><input type="text" name="vendor_site_code" value="<%=StringUtil.convertFor(vendor_site_code, "INPUT")%>" maxlength="20" class="text width_max" /></td>
			<th><%=StringUtil.getLocaleWord("L.관계사코드", siteLocale)%></th>
			<td><input type="text" name="affiliate_code" value="<%=StringUtil.convertFor(affiliate_code, "INPUT")%>" maxlength="30" class="text width_max" /></td>
		</tr>
	
	
		<tr>
			<th><%=StringUtil.getLocaleWord("L.거래시작일", siteLocale)%> / <%=StringUtil.getLocaleWord("L.종료일", siteLocale)%></th>
			<td>
				<%=HtmlUtil.getInputCalendar(request, true, "biz_bgn_date", "biz_bgn_date", biz_bgn_date, "")%>
				~
				<%=HtmlUtil.getInputCalendar(request, true, "biz_end_date", "biz_end_date", biz_end_date, "")%>
			</td>
			<th><%=StringUtil.getLocaleWord("L.평가점수", siteLocale)%></th>
			<td><input type="text" name="eval_point" value="<%=StringUtil.convertFor(eval_point, "INPUT")%>" size="10" maxlength="10" class="text" style="text-align:right" onblur="airCommon.validateNumber(this, this.value)" /></td>
			<th><%=StringUtil.getLocaleWord("L.상태", siteLocale)%></th>
			<td><%=HtmlUtil.getSelect(request,  true, "status_code", "status_code", statusCodestr, status_code, "")%></td>
		</tr>
		--%>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.메모", siteLocale)%></th>
			<td colspan="5"><%=HtmlUtil.getHtmlEditor(request,true, "memo", "memo", masMap.getStringEditor("MEMO"), "") %></td>
		</tr>
	</table>
</div>
<div class="buttonlist">
	<span class="ui_btn medium icon"><span class="save"></span><a href="javascript:doSubmit(document.form1)"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
</div>
</form>