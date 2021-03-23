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
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult 				= resultMap.getResult("VIEW");
	
	SQLResults sysPatiGbnList	= resultMap.getResult("SYS_PATI_GBN_LIST");
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 상세보기 값 셋팅
	String mng_pati_uid          = viewResult.getString(0,"mng_pati_uid");
	String pati_gwanri_no        = viewResult.getString(0,"pati_gwanri_no");
	String pati_gbn_sys_cod_id1  = viewResult.getString(0,"pati_gbn_sys_cod_id1");
	String pati_gbn_cod1         = viewResult.getString(0,"pati_gbn_cod1");
	String pati_gbn_nam1         = viewResult.getString(0,"pati_gbn_nam1");
	String pati_gbn_sys_cod_id2  = viewResult.getString(0,"pati_gbn_sys_cod_id2");
	String pati_gbn_cod2         = viewResult.getString(0,"pati_gbn_cod2");
	String pati_gbn_nam2         = viewResult.getString(0,"pati_gbn_nam2");
	String pati_nam              = viewResult.getString(0,"pati_nam");
	String pati_memo             = viewResult.getString(0,"pati_memo");
	String pati_class            = viewResult.getString(0,"pati_class");
	String pati_wrt_jsp          = viewResult.getString(0,"pati_wrt_jsp");
	String pati_view_jsp         = viewResult.getString(0,"pati_view_jsp");
	String pati_use_tbl          = viewResult.getString(0,"pati_use_tbl");
	String pati_src_regen_yn     = viewResult.getString(0,"pati_src_regen_yn");
	String pati_view_only        = viewResult.getString(0,"pati_view_only");
	
	//-- 코드정보 문자열 셋팅
	String sysPatiGbnStr = StringUtil.getCodestrFromSQLResults(sysPatiGbnList, "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
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

function goParticleTestInput(){
	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_MNG_PATI&<%=CommonConstants.MODE_CODE%>=WRITE_TEST&mng_pati_uid=<%=mng_pati_uid%>','write_test','width=1024,height=700,left=50,top=20,status=0,scrollbars=yes');
}

function goParticleTestView(){
	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_MNG_PATI&<%=CommonConstants.MODE_CODE%>=VIEW_TEST&mng_pati_uid=<%=mng_pati_uid%>','view_test','width=1024,height=700,left=50,top=20,status=0,scrollbars=yes');
}

function goPatiCreateSource(frm){
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_SUBMIT",siteLocale,"생성")%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "SOURCE_CREATE";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}
}

function goPatiCreateTable(frm){
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_SUBMIT",siteLocale,"생성")%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "TABLE_CREATE";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();
	}
}

function goDefDocView(def_doc_main_uid) {	
	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_DEF_DOC_MAIN&<%=CommonConstants.MODE_CODE%>=VIEW&def_doc_main_uid='+def_doc_main_uid,'view_test','width=1024,height=700,left=50,top=20,status=0,scrollbars=yes');
}

</script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode %>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="mng_pati_uid" value="<%=mng_pati_uid%>" />
	
<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><%=StringUtil.convertFor(pati_gwanri_no, "VIEW") %></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><%=StringUtil.convertFor(pati_nam, "VIEW")%></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=StringUtil.convertFor(pati_gbn_nam1, "VIEW")%> - <%=StringUtil.convertFor(pati_gbn_nam2, "VIEW")%> 
		</td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_Class",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><%=StringUtil.convertFor(pati_class, "VIEW")%></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_입력_JSP",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><%=StringUtil.convertFor(pati_wrt_jsp, "VIEW")%></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_조회_JSP",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><%=StringUtil.convertFor(pati_view_jsp, "VIEW")%></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_설명",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=StringUtil.convertFor(pati_memo,"VIEW")%>
		</td>		
	</tr>		
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.파티클_사용_테이블",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=StringUtil.convertFor(pati_use_tbl,"VIEW")%>
		</td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.VIEW_전용_파티클여부",siteLocale)%></th> 
		<td class="td2">
			<%if("Y".equals(pati_view_only)){%>
				VIEW전용
			<%}else{%>
				일반
			<%}%>
		</td>		
	</tr>
</table>	
	<div class="buttonlist">
		<div class="right">
			<input type="button" name="btnModify" value="파티클소스코드 생성" class="btn140" onclick="goPatiCreateSource(this.form)" <%if("Y".equals(pati_src_regen_yn)){%>disabled<%}%> />
			<input type="button" name="btnModify" value="파티클서브테이블 생성" class="btn140" onclick="goPatiCreateTable(this.form)" <%if(!"Y".equals(pati_src_regen_yn) || "Y".equals(pati_view_only)){%>disabled<%}%> />
			<input type="button" name="btnModify" value="<%=StringUtil.getLocaleWord("B.파티클_입력테스트",siteLocale)%>" class="btn140" onclick="goParticleTestInput(this.form)" <%if("Y".equals(pati_view_only)){%>disabled<%}%> />
			<input type="button" name="btnModify" value="<%=StringUtil.getLocaleWord("B.파티클_조회테스트",siteLocale)%>" class="btn140" onclick="goParticleTestView(this.form)" />
			<input type="button" name="btnModify" value="<%=StringUtil.getLocaleWord("B.수정",siteLocale)%>" class="btn70" onclick="goModify(this.form)" />		
			<input type="button" name="btnList" value="<%=StringUtil.getLocaleWord("B.목록",siteLocale)%>" class="btn70" onclick="goList(this.form)" /><br /><br />
			<%if("Y".equals(pati_src_regen_yn)){%>
			<font color="red">※파티클 소스코드 및 테이블이 이미 생성되어 있어 파티클 소스코드를 생성할 수 없습니다. <br>다시 소스코드 및 테이블을 생성하시려면, 파티클관리 테이블의 소스코드 생성여부유무를 N으로 변경 및 테이블을 삭제하신 후 
			진행하시기 바랍니다.</font>  
			<%}%>
		</div>
	</div>  
</form>
