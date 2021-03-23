<%@page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.controller.SysStaticDataController" %>


<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults STATUS_LIST	= resultMap.getResult("STATUS_LIST");
	SQLResults STATUS_COD_LIST	= resultMap.getResult("STATUS_COD_LIST");
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	String munseo_seosig_no = StringUtil.convertNull(request.getParameter("munseo_seosig_no"));
	String munseo_seosig_nam		 = StringUtil.convertNull(request.getParameter("munseo_seosig_nam"));
	String status_gbn		 = StringUtil.convertNull(request.getParameter("status_gbn"));
	
	
	String statusCodGbn = StringUtil.getCodestrFromSQLResults(STATUS_COD_LIST, "CODE,LANG_CODE", "");
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
	
	var obj_deadline_gbn = document.getElementsByName("deadline_gbn");
	var deadline_gbn_chk_yn = "N";
	for(var i=0; i<obj_deadline_gbn.length; i++){
		if(obj_deadline_gbn[i].checked == true){
			deadline_gbn_chk_yn = "Y";
		}
	}
	
	/* if(deadline_gbn_chk_yn == "N"){
		alert("기한관리구분을 선택하세요.");
		return false;
	} */
	
	var obj_status_def_doc_main_uid = document.getElementsByName("status_munseo_seosig_no");
	for(var i=0; i<obj_status_def_doc_main_uid.length; i++){
		if(obj_status_def_doc_main_uid[i].value == ""){
			alert("상태발생문서를 검색하여 선택해 주십시오.");
			return false;
		}
	}
	
	var obj_status_deadline_flow_gbn = document.getElementsByName("status_deadline_flow_gbn");
	for(var i=0; i<obj_status_deadline_flow_gbn.length; i++){
		if(obj_status_deadline_flow_gbn[i].selectedIndex == 0){
			alert("상태발생문서 단계를 선택해주십시오.");
			return false;
		}
	}
	
	
	var mode_code = frm.<%=CommonConstants.MODE_CODE%>.value;
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_SUBMIT",siteLocale, "저장")%>")) {
		if(mode_code == "UPDATE_FORM") {
			frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_PROC";
		} else if(mode_code == "WRITE_FORM") {
			frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_PROC";
		}		
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}
}

/**
 * 저장
 */	
function doDelete(frm) {
	var mode_code = frm.<%=CommonConstants.MODE_CODE%>.value;
	if (confirm("<%=StringUtil.getLocaleWord("M.ALERT_SUBMIT",siteLocale, "삭제")%>")) {
		frm.<%=CommonConstants.MODE_CODE%>.value = "DELETE_PROC";
		frm.action = "/ServletController";
		frm.target = "_self";
		frm.submit();		
	}
}


function doStartAdd(){
	var trCnt = $("#tb_status select[name=status_deadline_flow_gbn]").length;
	var data = [{index:trCnt}]
	$("#TMPL_START").tmpl(data).appendTo($("#tb_status"));
}
function doStartDel(index){
	$("#tb_status [data-meaning='mun_tr"+index+"']").remove();
}

/**
 * 문서 서식 검색 수행
 */	
function doSearchMunseoSeosig(val_item_seq, val_deadline_gbn) {
	window.open('/ServletController?AIR_ACTION=SYS_DEF_DOC_MAIN&AIR_MODE=POPUP_MUNSEO_ONE_SELECT&from_deadline_yn=Y&deadline_gbn='+val_deadline_gbn+'&item_seq='+val_item_seq,'def_doc_main_popup_select','width=900,height=600,left=50,top=20,status=0,scrollbars=yes');
}

</script>
<script id="TMPL_START" type="text/x-jquery-tmpl">
<tr data-meaning="mun_tr\${index}">
	<td>
	<table class="basic">
		<tr>
			<th class="th4">이벤트 활성화 단계</th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "status_deadline_flow_gbn" , "status_deadline_flow_gbn", CommonConstants.CHEORI_TYPE_STR2, "", "") %>
			</td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.상태",siteLocale)%></th>
			<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "status_code_id", "status_code_id", statusCodGbn, "" , "") %>
			</td>
		</tr>
		<tr>
			
			<th class="th4">추가조건(SQL query)</th>
			<td class="td4" colspan="3">
				<textarea name="status_where_query" class="text width_max"></textarea>
			</td>
		</tr>
	</table>
	</td>
	<td style="text-align: center">
		<input type="button" name="btnStartAdd" style="width:50px" value="삭제" onClick="doStartDel('\${index}');">
	</td>
</tr>
</script>

<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode %>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="status_munseo_seosig_no" value="<%=munseo_seosig_no%>" />
	<input type="hidden" name="status_munseo_seosig_nam" value="<%=munseo_seosig_nam%>" />
	<input type="hidden" name="status_gbn" value="<%=status_gbn%>" />
<br>	
<br>
<table class="basic">
	<caption>상태문서정보</caption>
	<tr>
		<th class="th2">문서명</th>
		<td class="td2"><%=munseo_seosig_nam %>
		</td>
	<tr>
	<tr>
		<th class="th2">문서번호</th>
		<td class="td2"><%=munseo_seosig_no %>
		</td>
	<tr>
	<tr>
		<th class="th2">
			상태변경 발생문서<br>
			<input type="button" name="btnStartAdd" style="width:50px" value="추가" onClick="doStartAdd();">
		</th>
		<td class="td2">
			<table class="basic" >
				<tbody id="tb_status">
			<%if(STATUS_LIST != null && STATUS_LIST.getRowCount() > 0){ %>
				<%for(int i=0; i< STATUS_LIST.getRowCount(); i++){ %>
				<tr data-meaning="mun_tr<%=i%>">
					<td>
						<table class="basic">
							<tr>
								<th class="th4">이벤트 활성화 단계</th>
								<td class="td4">
									<%=HtmlUtil.getSelect(request, true, "status_deadline_flow_gbn" , "status_deadline_flow_gbn", CommonConstants.CHEORI_TYPE_STR2, STATUS_LIST.getString(i, "flow_gbn"), "") %>
								</td>
								<th class="th4"><%=StringUtil.getLocaleWord("L.상태",siteLocale)%></th>
								<td class="td4">
									<%=HtmlUtil.getSelect(request, true, "status_code_id", "status_code_id", statusCodGbn, STATUS_LIST.getString(i, "STATUS_CODE_ID"), "") %>
								</td>
							</tr>
							<tr>
								<th class="th4">추가조건(SQL query)</th>
								<td class="td4" colspan="3">
									<textarea name="status_where_query" class="text width_max"><%=STATUS_LIST.getString(i, "where_qry")%></textarea>
								</td>
							</tr>
						</table>
					</td>
					<td style="text-align: center">
						<input type="button" name="btnStartAdd" style="width:50px" value="삭제" onClick="doStartDel('<%=i%>');">
					</td>
				</tr>
				<%} %>
			<%}else{ %>
				<tr data-meaning="mun_tr0">
					<td>
						<table class="basic">
							<tr>
								<th class="th4">이벤트 활성화 단계</th>
								<td class="td4">
									<%=HtmlUtil.getSelect(request, true, "status_deadline_flow_gbn" , "status_deadline_flow_gbn", CommonConstants.CHEORI_TYPE_STR2, "", "") %>
								</td>
								<th class="th4"><%=StringUtil.getLocaleWord("L.상태",siteLocale)%></th>
								<td class="td4">
									<%=HtmlUtil.getSelect(request, true, "status_code_id", "status_code_id", statusCodGbn,"", "") %>
								</td>
							</tr>
							<tr>
								<th class="th4">추가조건(SQL query)</th>
								<td class="td4" colspan="3">
									<textarea name="status_where_query" class="text width_max"></textarea>
								</td>
							</tr>
						</table>
					</td>
					<td style="text-align: center">
					</td>
				</tr>
			<%} %>
				</tbody>
			</table>
		</td>
	</tr>
</table>	

<div class="buttonlist">
	<div class="right">
		<input type="button" name="btnSave" value="<%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%>" class="btn70" onclick="doSubmit(document.form1)" />		
		<input type="button" name="btnList" value="<%=StringUtil.getLocaleWord("B.LIST",siteLocale)%>" class="btn70" onclick="goList(document.form1)" />
	</div>
</div>  

	
</form>
