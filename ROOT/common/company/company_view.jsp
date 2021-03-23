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
	BeanResultMap responseMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult 			= responseMap.getResult("VIEW");
	SQLResults natListResult 		= responseMap.getResult("NAT_LIST");
	SQLResults bankListResult 		= responseMap.getResult("BANK_LIST");
	SQLResults typeListResult 		= responseMap.getResult("TYPE_LIST");
	SQLResults classListResult 		= responseMap.getResult("CLASS_LIST");
	SQLResults statusListResult 	= responseMap.getResult("STATUS_LIST");
	SQLResults gugnaeoeListResult 	= responseMap.getResult("GUGNAEOE_LIST");
	
	SQLResults VIEW_USER = responseMap.getResult("VIEW_USER");

	//-- 파라메터 셋팅
	String actionCode	= responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= responseMap.getString(CommonConstants.MODE_CODE);

	BeanResultMap masMap = new BeanResultMap();

	if(viewResult != null && viewResult.getRowCount() > 0){
		masMap.putAll(viewResult.getRowResult(0));
	}

	//-- 상세보기 값 셋팅
	String company_uid		= masMap.getDefStr("COMPANY_UID", StringUtil.getRandomUUID())  ;
	String group_uid		= masMap.getDefStr("GROUP_UID", StringUtil.getRandomUUID())  ;
	String code				= masMap.getString("CODE")  ;

	//-- 코드정보 문자열 셋팅
	String classCodestr 	= StringUtil.getCodestrFromSQLResults(classListResult, "CODE,LANG_CODE", "");

	String typeCodestr 		= StringUtil.getCodestrFromSQLResults(typeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String natCodestr 		= StringUtil.getCodestrFromSQLResults(natListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String statusCodestr 	= StringUtil.getCodestrFromSQLResults(statusListResult, "CODE,LANG_CODE", "");
	String bankCodestr 		= StringUtil.getCodestrFromSQLResults(bankListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String gugnaeoeCodestr 	= StringUtil.getCodestrFromSQLResults(gugnaeoeListResult, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
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
 * 수정등록 페이지로 이동
 */
function goModify(frm) {
	frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_FORM";
	frm.action = "/ServletController";
	frm.target = "_self";
	frm.submit();
}

/**
 * 삭제 처리
 */
function doDelete(frm) {

	var msg = "<%=StringUtil.getLocaleWord("M.삭제시사용자제거알림",siteLocale)%>\n" + "<%=StringUtil.getLocaleWord("M.ALERT_SUBMIT",siteLocale,"L.삭제")%>";
	msg = "삭제하시면 소속된 시스템 및 사용자 정보도 같이 삭제 됩니다. 계속 하시겠습니까?";
	if (confirm(msg)) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "DELETE";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}
}

/*
 * 사용자 추가
 */

function doAddUser(frm){
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_COMPANY&AIR_MODE=WRITE_FORM_ADD_USER&group_uid=<%=group_uid%>&company_uid=<%=company_uid%>&company_name_ko=<%=masMap.getStringView("NAME_KO")%>', 1024, 520, 'company_add_user', 'yes', 'yes');
}

var doAddSystem = function(){
	var url = "/ServletController?AIR_ACTION=SD_SYSTEM&AIR_MODE=POPUP_WRITE_FORM&group_uid=<%=group_uid%>&company_uid=<%=company_uid%>&group_code=<%=code%>";
	airCommon.openWindow(url, 1024, 520, 'company_add_user', 'yes', 'yes');
}
/*
 * 사용자 수정
 */
function doEditUser(frm, user_uid){
	airCommon.openWindow('/ServletController?AIR_ACTION=SYS_COMPANY&AIR_MODE=UPDATE_FORM_ADD_USER&group_uid=<%=group_uid%>&company_uid=<%=company_uid%>&user_uid='+user_uid, 1024, 520, 'company_edit_user', 'yes', 'yes');
}
</script>
<form name="form1" method="post">
<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" />
<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
<input type="hidden" name="current_mode_code" value="<%=modeCode%>" />
<input type="hidden" name="company_uid" value="<%=company_uid%>" />
<input type="hidden" name="group_uid" value="<%=group_uid%>" />
<input type="hidden" name="code" id="code" value="<%=code%>" />
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
				<th>로펌명(국문)<%-- <%=StringUtil.getLocaleWord("L.업체명_국문", siteLocale) %> --%></th>
				<td><%=masMap.getStringView("NAME_KO")%></td>
				<th>로펌명(영문)<%-- <%=StringUtil.getLocaleWord("L.업체명_영문", siteLocale) %> --%></th>
				<td colspan="3"><%=masMap.getStringView("NAME_EN")%></td>
				<%-- <th><%=StringUtil.getLocaleWord("L.업체명", siteLocale)%>(<%=StringUtil.getLocaleWord("L.영문", siteLocale)%>)</th>
				<td><input type="text" name="name_en" value="<%=StringUtil.convertFor(name_en, "INPUT")%>" maxlength="50" class="text width_max" /></td>
				<th><%=StringUtil.getLocaleWord("L.업체명", siteLocale)%>(<%=StringUtil.getLocaleWord("L.약어", siteLocale)%>)</th>
				<td><input type="text" name="short_name" value="<%=StringUtil.convertFor(short_name, "INPUT")%>" maxlength="50" class="text width_max" /></td> --%>
			</tr>
			<tr>
				<%-- <th><%=StringUtil.getLocaleWord("L.사업자등록번호", siteLocale)%></th>
				<td><%=masMap.getStringView("BIZ_NO")%></td> --%>
				<th><%=StringUtil.getLocaleWord("L.Contact변호사", siteLocale)%></th>
				<td><%=masMap.getStringView("CEO_NAME")%></td>
				<th><%=StringUtil.getLocaleWord("L.전화번호", siteLocale)%></th>
				<td><%=masMap.getStringView("TELEPHONE_NO")%></td>
				<th>이메일</th>
				<td><%=masMap.getStringView("EMAIL")%></td>
			</tr>
<%-- 
			<tr>
				<th>업체유형</th>
				<td><%=StringUtil.getCodestrValue(request,masMap.getStringView("TYPE_CODE"), typeCodestr)%></td>
				<th><%=StringUtil.getLocaleWord("L.업태", siteLocale)%></th>
				<td><%=masMap.getStringView("BIZ_PART")%></td>
				<th><%=StringUtil.getLocaleWord("L.종목", siteLocale)%></th>
				<td><%=masMap.getStringView("BIZ_GUBUN")%></td>
			</tr> 
--%>
			<tr>
				<th><%=StringUtil.getLocaleWord("L.국내국제", siteLocale)%></th>
				<td><%=StringUtil.getCodestrValue(request,masMap.getStringView("GUGNAEOE_CODE"), gugnaeoeCodestr)%></td>
				<th>국가</th>
				<td><%=StringUtil.getCodestrValue(request,masMap.getStringView("NAT_CODE"), natCodestr)%></td>
				<th><%=StringUtil.getLocaleWord("L.팩스", siteLocale)%></th>
				<td><%=masMap.getStringView("FAX_NO")%></td>
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
				<td colspan="5"><%=masMap.getStringView("HOMEPAGE")%></td>
			</tr>
			<tr>
				<th><%=StringUtil.getLocaleWord("L.주소", siteLocale)%></th>
				<td colspan="5">
					(우편번호 : <%=masMap.getStringView("POST_NO")%>)
					<br />
					<%=masMap.getStringView("ADDRESS")%>
				</td>
			</tr>
<%--
			<tr>
				<th><%=StringUtil.getLocaleWord("L.은행", siteLocale)%></th>
				<td><%=StringUtil.getCodestrValue(request,masMap.getStringView("BANK_CODE"), bankCodestr)%></td>
				<th><%=StringUtil.getLocaleWord("L.계좌번호", siteLocale)%></th>
				<td><%=masMap.getStringView("BANK_ACNT_NO")%></td>
				<th><%=StringUtil.getLocaleWord("L.예금주", siteLocale)%></th>
				<td><%=masMap.getStringView("BANK_ACNT_NAME")%></td>
			</tr>
--%>
			<tr>
				<th><%=StringUtil.getLocaleWord("L.분류", siteLocale)%></th>
				<td colspan="5"><%=StringUtil.getCodestrValue(request,masMap.getStringView("CLASS_CODES"), classCodestr)%></td>
<%-- 				
				<th>거래처코드</th>
				<td>
					<input type="text" name="vend_no" value="<%=masMap.getStringView("VEND_NO")%>" maxlength="400" class="text width_max" style="margin-top:5px;" />
				</td> 
--%>
			</tr>
			<tr>
				<th>시작일 / 종료일</th>
				<td colspan="3">
					<%= masMap.getStringView("BIZ_BGN_DATE")%>
					~
					<%=masMap.getStringView("BIZ_END_DATE")%>
				</td>
				<th><%=StringUtil.getLocaleWord("L.상태", siteLocale)%></th>
				<td><%=StringUtil.getCodestrValue(request,masMap.getStringView("STATUS_CODE"), statusCodestr)%></td>
			</tr>
<%--
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
				<td colspan="5"><%=masMap.getString("MEMO")%></td>
			</tr>
		</table>
	</div>
			
	<div class="buttonlist">
		<div class="right">
			<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:goModify(document.form1)">로펌정보 <%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
		</div>
	</div>
			
	<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="padding-left:0px;padding-right:0px;height:auto">
		<div id="listTabs-LIST" title="대리인 정보" style="padding-top:5px;" data-options="selected:true">
			<div class="buttonlist">
				<div class="right">
					<span class="ui_btn medium icon" style="float:right;"><span class="add"></span><a href="javascript:doAddUser(document.form1)"><%=StringUtil.getLocaleWord("B.대리인추가",siteLocale)%></a></span>
				</div>
			</div>	
			
			<table class="list">
				<colgroup>
					<col style="width:8%" />		
					<col style="width:15%" />
					<col style="width:15%" />
					<col style="width:22%" />
					<col style="width:auto" />
				</colgroup>
					<tr>
<%--
						<th>ID</th>
--%>			
						<th style="text-align:center">성명</th>
						<th style="text-align:center">연락처</th>
						<th style="text-align:center">휴대전화</th>
						<th style="text-align:center">이메일</th>
						<th style="text-align:center">특이사항</th>
<%--
						<th>사용자권한</th>			
						<th>상태</th>
--%>			
					</tr>
<%if(VIEW_USER != null && VIEW_USER.getRowCount() > 0){%>
<% 
					   for(int i=0; i<VIEW_USER.getRowCount(); i++){
						   String usrEmail = "";
						   String serTelephone_no = "";
						   String sosock_tit = VIEW_USER.getString(i,"sosock_tit");
						   String etc = VIEW_USER.getString(i,"etc");
						   serTelephone_no = VIEW_USER.getString(i,"telephone_no");
						   String MOBILE_NO = VIEW_USER.getString(i,"MOBILE_NO");
						   usrEmail = VIEW_USER.getString(i,"email");
%>	
					<tr onclick="javascript:doEditUser(document.form1,'<%=VIEW_USER.getString(i,"uuid")%>')" style="cursor:pointer;">
<%--		
						<td align="center"><%=StringUtil.convertForView(VIEW_USER.getString(i,"login_id"))%></td>
--%>
						<td align="center"><%=StringUtil.convertForView(VIEW_USER.getString(i,"name_ko"))%></td>
						<td align="center"><%=StringUtil.convertForView(serTelephone_no)%></td>
						<td align="center"><%=StringUtil.convertForView(MOBILE_NO)%></td>
						<td align="center"><%=StringUtil.convertForView(usrEmail)%></td>
						<td><%=StringUtil.convertForView(etc)%></td>
<%--			
						<td><%=StringUtil.getCodestrValue(request,VIEW_USER.getString(i,"user_auth_codes"), userAuthListStr)%></td>
						<td align="center"><%=StringUtil.getCodestrValue(request,VIEW_USER.getString(i,"status_code"), userStatListStr)%></td>
--%>	
					</tr>
					<%
					   } // end of for
					%>
				<%}else{%>
				<tr height="50px">	
					<td colspan="10" style="text-align:center;'">등록된 사용자 정보가 없습니다.</td>
				</tr>
				<%}%>
			</table>
			<div class="buttonlist">
				<div class="right">
<%-- 				
					<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:doAddUser(document.form1)"><%=StringUtil.getLocaleWord("B.대리인추가",siteLocale)%></a></span>
					<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:doDelete(document.form1)">업체<%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span> 
					<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:goModify(document.form1)">업체<%=StringUtil.getLocaleWord("B.MODIFY",siteLocale)%></a></span>
--%>
					<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
				</div>
			</div>
		</div>
	</div>
</form>