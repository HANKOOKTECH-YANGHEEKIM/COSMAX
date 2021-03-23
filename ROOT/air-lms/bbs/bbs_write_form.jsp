<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.util.DateUtil"%>
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	BeanResultMap responseMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	String pageNo = responseMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize = responseMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField  = responseMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod = responseMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
	
	String board_type	=	"";
	String parent_uuid	=	"";
	String parent_board_cd	=	"";
	String reg_date = DateUtil.getCurrentDate();
	String reg_name_ko = loginUser.getName();
	
	//-- 결과값 셋팅
	SQLResults bbsMas = responseMap.getResult("BBS_MAS");
	SQLResults BOARD_MAS = responseMap.getResult("BOARD_MAS");
	
	if(BOARD_MAS != null && BOARD_MAS.getRowCount()> 0){
		board_type = BOARD_MAS.getString(0, "PARENT_CODE_ID");
		parent_uuid = BOARD_MAS.getString(0, "PARENT_UUID");
		parent_board_cd = board_type;
	}
	
	BeanResultMap masMap = new BeanResultMap();
	if(bbsMas != null && bbsMas.getRowCount()> 0){
		masMap.putAll(bbsMas.getRowResult(0));
		
		reg_date	 = masMap.getString("REG_DTE");
		reg_name_ko = masMap.getString("REG_NM");
	}
	
	String uuid	= masMap.getString("UUID");
	String temp_uuid = StringUtil.getRandomUUID();
	
	String board_nm 	= BOARD_MAS.getString(0, "NAME_KO");
	String board_cd 	= request.getParameter("BOARD_CD");
	
	if(null==board_cd || "".equals(board_cd)) {
		board_cd =	responseMap.getString("BOARD_CD");
	}
	
	//-- 파라메터 셋팅
	String actionCode = responseMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = responseMap.getString(CommonConstants.MODE_CODE);

	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids 	= "";
	
	if(StringUtil.isNotBlank(uuid)){
		att_master_doc_id = uuid;
		att_default_master_doc_Ids 	= uuid;
	}else{
		att_master_doc_id = temp_uuid;
		att_default_master_doc_Ids 	= "";
	}
	
	String bbsTypeStr = StringUtil.getCodestrFromSQLResults(responseMap.getResult("LMS_BBS_TYPE"), "CODE,LANG_CODE", "");
%>
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="uuid" value="<%=uuid%>" />
	<input type="hidden" name="temp_uuid" value="<%=temp_uuid%>" />
	<input type="hidden" name="board_cd" value="<%=board_cd%>" />
	<input type="hidden" name="board_type" value="<%=board_type%>" />
	<input type="hidden" name="parent_uuid" value="<%=parent_uuid%>" />
	<input type="hidden" name="parent_board_cd" value="<%=parent_board_cd%>" />
	<table class="basic">
		<caption><%=StringUtil.getLocaleWord("L."+board_nm,siteLocale)%>( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale)%>)</caption>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<td class="td4"><%=reg_date %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<td class="td4"><%=reg_name_ko %></td>
		</tr>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.제목", siteLocale) %></th>
			<td class="td4" colspan="3">
				<input type="text" name="title" id="title" class="text width_max" maxlength="1000" value="<%=masMap.getString("TITLE")%>"/>
			</td>
		</tr>
<%if(responseMap.getResult("LMS_BBS_TYPE") != null && responseMap.getResult("LMS_BBS_TYPE").getRowCount() > 0){ %>
		<tr>
			<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.유형", siteLocale) %></th>
			<td class="td4" colspan="3">
				<%=HtmlUtil.getSelect(request, true, "type_cd1", "type_cd1", bbsTypeStr, masMap.getString("TYPE_CD1"), "class=\"select width_max2\"") %>
				<input type="hidden" name="type_nm1" id="type_nm1" value="<%=masMap.getString("TYPE_NM1")%>" />
			</td>
		</tr>
<%} %>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.내용", siteLocale) %></th>
			<td class="td4" colspan="3">
				<textarea rows="10" name="CONTENT" id="CONTENT" class="text width_max" style="width:99%; height:250px;"><%=masMap.getString("CONTENT")%></textarea>
			</td>
		</tr>
		<tr>
			<th><%=StringUtil.getLocaleWord("L.첨부", siteLocale) %></th>
			<td colspan="3">
				<jsp:include page="/ServletController">
                    <jsp:param value="SYS_ATCH" name="AIR_ACTION" />
                    <jsp:param value="FILE_WRITE" name="AIR_MODE" />
                    <jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
                    <jsp:param value="LMS" name="systemTypeCode" />
					<jsp:param value="LMS/BBS" name="typeCode" />
                    <jsp:param value="N" name="requiredYn" />       
					<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
                </jsp:include>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
<%if(LmsUtil.isBeobmuTeamUser(loginUser) || LmsUtil.isSysAdminUser(loginUser)){ %>
		<script>
			var goProc = function(){
				if ("" == $("#title").val() ) {
					alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"제목")%>");
					$("#title").focus();
				    return false;	
				}
			<%if(responseMap.getResult("LMS_BBS_TYPE") != null && responseMap.getResult("LMS_BBS_TYPE").getRowCount() > 0){ %>
				if ("" == $("#type_cd1").val() ) {
					alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,"제목")%>");
					$("#type_cd1").focus();
				    return false;	
				}else{
					$("#type_nm1").val($("#TYPE_CD1 :selected").text())
				}
			<%} %>
			
				var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
				if(confirm(msg)){
					var data = $("#saveForm").serialize();
					airCommon.callAjax("<%=actionCode%>", "AJAX_WRITE_PROC",data, function(json){
						try {
							opener.doSearch();
						} catch(e) {
						}
						window.close();
					});
				}
			};
		</script>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
<%} %>
    </div>
</div>	