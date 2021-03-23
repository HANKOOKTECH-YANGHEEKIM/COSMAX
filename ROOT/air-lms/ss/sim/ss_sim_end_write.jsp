<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap" %>
<%
//-- 로그인 사용자 정보 셋팅
SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
String siteLocale = loginUser.getSiteLocale();

//-- 검색값 셋팅
BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
String pageNo = requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
String sol_mas_uid =	requestMap.getString("SOL_MAS_UID");
String ss_sim_uid	= requestMap.getString("SS_SIM_UID");
String temp_ss_sim_uid = StringUtil.getRandomUUID();

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
SQLResults rsMas = resultMap.getResult("SS_SIM");

BeanResultMap simMap = new BeanResultMap();
if(rsMas != null && rsMas.getRowCount()> 0){
	simMap.putAll(rsMas.getRowResult(0));
}

//-- 파라메터 셋팅
String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

SQLResults LMSSSMAS= resultMap.getResult("SS_MAS");
String yuhyeong01_cod = "";

if( LMSSSMAS!=null && LMSSSMAS.getRowCount()>0 ){
	if("".equals(simMap.getString("SANGSO_TERM"))){
		//상소/불복기한 항목에 일자 기본세팅의 조건은 
		//국내소송(LMS_SS_GB_UH_GNSS) 민사(LMS_SS_GB_UH_GNSS_MS)의 경우 14일 
		//형사(LMS_SS_GB_UH_GNSS_HS)의 경우 7일 그 외의 경우 빈 칸
		yuhyeong01_cod = LMSSSMAS.getString(0, "YUHYEONG01_COD");
		if("LMS_SS_YUHYEONG_MS".equals(yuhyeong01_cod) ){ //민사
			//simMap.put("SANGSO_TERM", "14");
			simMap.put("SANGSO_TERM", "7");
		}
	}
}

String ss_003_uid = simMap.getString("SS_003_UID");

if("".equals(ss_003_uid)){
	ss_003_uid = StringUtil.getRandomUUID();
}

String new_ss_003_uid   = StringUtil.getRandomUUID();

// 갱신일 경우 UID 생성
if(StringUtil.isNotBlank(ss_sim_uid)){
	ss_003_uid = new_ss_003_uid;
}
	
String PROG_CODESTR = "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^"+StringUtil.getCodestrFromSQLResults(resultMap.getResult("PROG_LIST"), "CODE,LANG_CODE", "");
String SEONGO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SEONGO_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
String GYEOLGWA_CODESTR = "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^"+StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_LIST"), "CODE,LANG_CODE", "");
String GYEOLGWA_CODESTR1 = "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^"+StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_HYEONGSA_LIST"), "CODE,LANG_CODE", "");

//첨부관련 셋팅
String att_master_doc_id = "";
String att_default_master_doc_Ids 	= "";

if(StringUtil.isBlank(ss_sim_uid)){ //신규
	att_master_doc_id = temp_ss_sim_uid;
	att_default_master_doc_Ids = ""; //다른데 있는 첨부파일을 끌어올때 사용
}else{ //수정
	att_master_doc_id = ss_sim_uid;
	att_default_master_doc_Ids = ss_sim_uid;
}
%>
<form name="saveForm" id="saveForm" method="POST">
	<input type="hidden" name="SOL_MAS_UID" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="SS_SIM_UID" value="<%=ss_sim_uid%>" />
	<input type="hidden" name="TEMP_SS_SIM_UID" value="<%=temp_ss_sim_uid%>" />
	<input type="hidden" name="IS_NEW" value="<%=StringUtil.isBlank(ss_sim_uid) ? true : false %>" />
	<input type="hidden" name="ss_003_uid" value="<%=ss_003_uid%>" />
<table class="basic">
	<caption><%=StringUtil.getLocaleWord("L.종결정보",siteLocale) %></caption>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.진행상태",siteLocale) %></span></th> 
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "prog_cod", "prog_cod", PROG_CODESTR, simMap.getString("PROG_COD"), "onchange=\"setRequired();\" class=\"select width_max\"")%>
		</td>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.종결분류",siteLocale) %></span></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "seongo_cod", "seongo_cod", SEONGO_CODESTR, simMap.getString("SEONGO_COD"), "onChange=\"$('#seongo_nam').val($('#seongo_cod option:selected').text());setEctView(this.value,'ZZ','seongo_nam');\" class=\"select width_max\"")%>
			<input type="text" style="display:<%if(!simMap.getString("SEONGO_COD").endsWith("ZZ")){%>none<%} %>;" placeholder="<%=StringUtil.getLocaleWord("L.기타입력사항", siteLocale) %>" name="seongo_nam"  id="seongo_nam" value="<%=simMap.getString("SEONGO_NAM")%>" maxlength="30" class="text width_max" />
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.소송결과", siteLocale)%></span>
		</th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "gyeolgwa_cod", "gyeolgwa_cod", GYEOLGWA_CODESTR, simMap.getString("GYEOLGWA_COD"), "onChange=\"$('#gyeolgwa_nam').val($('#gyeolgwa_cod option:selected').text());setEctView(this.value,'ZZ','gyeolgwa_nam')\" class=\"select width_max\"")%>
			<input type="text" style="display:<%if(!simMap.getString("GYEOLGWA_COD").endsWith("ZZ")){%>none<%} %>;" placeholder="<%=StringUtil.getLocaleWord("L.기타입력사항", siteLocale) %>" name="gyeolgwa_nam"  id="gyeolgwa_nam" value="<%=simMap.getString("GYEOLGWA_NAM")%>" maxlength="25" class="text width_max" />
		</td>
		<th class="th4"><span data-meaning="requiredYn" <%if(simMap.getString("PROG_COD").endsWith("HJ")){%>class="ui_icon required"<%} %>><%=StringUtil.getLocaleWord("L.소송비용청구여부", siteLocale)%></span></th>
		<td class="td4">
			<span id="span_decide" style="display:<%if(!simMap.getString("PROG_COD").endsWith("HJ")){%>none<%} %>;">
			<%=HtmlUtil.getSelect(request, true, "DECIDE_COST_YN", "DECIDE_COST_YN", "|--선택--^Y|Yes^N|No", simMap.getString("DECIDE_COST_YN"), "onChange=\"$('#DECIDE_COST_REASON').val($('#DECIDE_COST_YN option:selected').text());setEctView(this.value,'N','DECIDE_COST_REASON')\" class=\"select width_max_select\" data-type=\"search\" style='width:99.6%;'") %>
			<input type="text"style="display:<%if(!simMap.getString("DECIDE_COST_YN").endsWith("N")){%>none<%} %>;"  name="DECIDE_COST_REASON" id="DECIDE_COST_REASON" placeholder="미진행사유 입력" value="<%=StringUtil.convertForInput(simMap.getString("DECIDE_COST_REASON")) %>" onblur="airCommon.validateSpecialChars(this);airCommon.validateMaxLength(this, 100);" maxlength="50" class="text width_max" /><br />
			<span style="color:red;">※ 관련 통신지 번호 기재</span>
			</span>
		</td>
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.선고일", siteLocale)%></span></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "seongo_dte", "seongo_dte", simMap.getString("SEONGO_DTE"), "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.판결송달일",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "songdal_dte", "songdal_dte", simMap.getString("SONGDAL_DTE"), "") %>
		</td>
	</tr>
	<tr>
<%
	if("000100".equals(simMap.getString("BEOBWEON_COD"))) { //대법원인 경우
%>
<input type="hidden" name="sangso_dte" value="" />
<input type="hidden" name="sangso_term" value="" />
<% 
	} else { 
%>
		<th class="th4 ">
			<span id="" class="ui_icon required"></span>
			<%=StringUtil.getLocaleWord("L.상소불복기한", siteLocale) %>
		</th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "sangso_dte", "sangso_dte", simMap.getString("SANGSO_DTE"), "") %>
			<input type="TEXT" name="sangso_term" value="<%=simMap.getDefStr("SANGSO_TERM", "7")%>" onkeyup="airCommon.validateNumber(this, this.value);" maxlength="3" class="text" style="text-align:right" />
			<%=StringUtil.getLocaleWord("L.일전알람",siteLocale) %>
			<%-- <br /><span style="color:red"><%=StringUtil.getLocaleWord("M.불복기한등록의예",siteLocale) %></span> --%>
		</td>
<%
	}
%>
		<th class="th4"><span data-meaning="requiredYn" <%if(simMap.getString("PROG_COD").endsWith("HJ")){%>class="ui_icon required"<%} %> ><%=StringUtil.getLocaleWord("L.종결확정일_심급종결일",siteLocale) %></span></th>
		<td class="td4"<%="000100".equals(simMap.getString("BEOBWEON_COD")) ? " colspan='3'" : "" %>>
			<%= HtmlUtil.getInputCalendar(request, true, "hwagjeong_dte", "hwagjeong_dte", simMap.getString("HWAGJEONG_DTE"), "") %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.비고",siteLocale) %></th>
		<td class="td4" colspan="3">
			<input type="text" name="sim_memo" id="sim_memo" class="text width_max" value="<%=StringUtil.convertForInput(simMap.getString("SIM_MEMO")) %>" onblur="airCommon.validateSpecialChars(this);airCommon.validateMaxLength(this, 100);">
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.내용",siteLocale) %></th>
		<td class="td4" colspan="3">
			<textarea class="memo width_max" name="pangyeol_cont" id="pangyeol_cont" onblur="airCommon.validateMaxLength(this, 4000)" style="height:100px;"><%=simMap.getStringEditor("PANGYEOL_CONT") %></textarea>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.판결문",siteLocale)%></th>			
		<td class="td4" colspan="3">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/PANGYEOLMUN" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
				<jsp:param value="1" name="maxFileCount" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
			<span style="color:red;">※ 판결문은 1개의 파일만 업로드 가능합니다.</span>
		</td>
	</tr>
<%-- 
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.승소율",siteLocale) %></th>
		<td class="td4" colspan="3">
			<input type="hidden" name="ss_sim_uid" value="<%=ss_sim_uid%>"/>
			<input type="text" style="width:50px;" class="number" name="win_rate" id="win_rate" maxlength="3" value="<%=simMap.getString("WIN_RATE")%>"/>%<br />
		</td>
	</tr>
	<tr>
		<th class="th4"><%=지급금액 %></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "jigeub_gubun", "jigeub_gubun", strCurGubunList, jigeub_gubun, "")%>
			<input type="text" name="jigeub_cost" onkeyup="airCommon.getFormatCurrency(this);" style="text-align: right"  class="text" value="<%=StringUtil.getFormatCurrency(jigeub_cost,-1) %>">
		</td>
	</tr>
	<tr>
		<th class="th4"><%=벌금_과료 %></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "beolgeum_gwaryo_gubun", "beolgeum_gwaryo_gubun", strCurGubunList, beolgeum_gwaryo_gubun, "")%>
			<input type="text" name="beolgeum_gwaryo" onkeyup="airCommon.getFormatCurrency(this);" style="text-align: right"  class="text" value="<%=StringUtil.getFormatCurrency(beolgeum_gwaryo,-1) %>">
		</td> 
		<th class="th4"><%=StringUtil.getLocaleWord("L.승소_패소금", siteLocale) %></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "pangyeol_gubun", "pangyeol_gubun", strCurGubunList, simMap.getString("pangyeol_gubun"), "")%>
			<input type="text" name="pangyeol_cost" onkeyup="airCommon.getFormatCurrency(this);" style="text-align: right"  class="text" value="<%=StringUtil.getFormatCurrency(simMap.getString("PANGYEOL_COST"),-1) %>">
		</td>
--%>
</table>
</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    </div>
</div>	
<script type="text/javascript">
var frm = document.saveForm;

var setEctView = function(val, endsWith, id){

	 if(val.endsWith(endsWith)){
		 $("#"+id).val("");
		 $("#"+id).show();
	 }else {
		 $("#"+id).hide();
	 }

}
//확정종결 선택시 필수 체크 기호 추가
var setRequired = function(){
	var prog_cd = $("#prog_cod").val();
	if(prog_cd == "HJ"){
		$("span[data-meaning='requiredYn']").attr("class","ui_icon required");
		$("#span_decide").show();
	}else{
		$("span[data-meaning='requiredYn']").attr("class","");
		$("#span_decide").hide();
	}
}

var goProc = function(){
	if ("" == frm.prog_cod.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getScriptMessage("L.진행상태", siteLocale))%>");
		frm.prog_cod.focus();
		return false;
	}
	
	if ("" == frm.seongo_cod.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.종결분류", siteLocale))%>");
		frm.seongo_cod.focus();
		return false;
	}else if ("ZZ" == frm.seongo_cod.value ) {
		if("" == $("#seongo_nam").val()){
			alert("종결분류가 기타일경우 기타입력사항은 필수 입력 입니다.");
			$("#seongo_nam").focus()
			return false;
		}
	}
	
	if ("" == frm.gyeolgwa_cod.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getScriptMessage("L.소송결과", siteLocale))%>");
		frm.gyeolgwa_cod.focus();
		return false;
	}else if ("ZZ" == frm.gyeolgwa_cod.value ) {
		if("" == $("#gyeolgwa_nam").val()){
			alert("소송결과가 기타일경우 기타입력사항은 필수 입력 입니다.");
			$("#gyeolgwa_nam").focus()
			return false;
		}
	}
	if ("HJ" == frm.prog_cod.value ) {
		if("" == $("#DECIDE_COST_YN").val()){
			alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getScriptMessage("L.소송비용청구여부", siteLocale))%>");
			$("#DECIDE_COST_YN").focus();
			return false;
		} else if("N" == $("#DECIDE_COST_YN").val()){
			if("" == $("#DECIDE_COST_REASON").val()){
				alert("소송비용청구여부가 No일경우 미진행사유 입력은 필수 사항 입니다.");
				$("#DECIDE_COST_REASON").focus()
				return false;
			}
		}
	}
	
	if ("" == frm.seongo_dte.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getScriptMessage("L.선고일", siteLocale))%>");
		frm.seongo_dte.focus();
		return false;
	}
<%
	if(!"000100".equals(simMap.getString("BEOBWEON_COD"))) { //대법원이 아닌 경우
%>
	if ("" == frm.sangso_dte.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getScriptMessage("L.상소불복기한", siteLocale))%>");
		frm.sangso_dte.focus();
		return false;
	}
<%
	}
%>	

	//확정 종결일때만 체크
	if($("#prog_cod").val() == "HJ"){
		if ("" == frm.hwagjeong_dte.value ) {
			alert ("<%=StringUtil.getScriptMessage("M.입력해주세요",siteLocale,"L.종결확정일_심급종결일")%>");
			frm.hwagjeong_dte.focus();
			return false;
		}
	}

<%-- 
	if("" != $("#win_rate").val()){
		var rate = $("#win_rate").val();
		if(parseInt(rate) > 100){
			alert ("<%=StringUtil.getLocaleWord("M.승소율초과",siteLocale)%>");
			$("#win_rate").val("");
			return false;
		}
	}
	var winObj = $("input:text[name='win_rate']");
	var winBool = true;
	$(winObj).each(function(){
		if($(this).val() == ""){
			alert ("<%=StringUtil.getLocaleWord("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.승소_해결율", siteLocale))%>");
			$(this).focus();
			winBool =  false;
		}
	});
	if(winBool == false){
		return false;
	}
--%>

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		var data = $("#saveForm").serialize();
		
		airCommon.callAjax("<%=actionCode%>", "SIM_END_WRITE_PROC",data, function(json){

			try{
				opener.refreshWindow();
				opener.opener.doSearch();	//--리스트 대응
			}catch(e){
				try{
					opener.opener.initMain(); //--메인화면일때 대응
				}catch(e){
					
				}
			}
<%-- 			opener.parent.parent.getSimList<%=sol_mas_uid%>(); --%>
<%-- 			opener.$('#accordion-SimView<%=sol_mas_uid%>').panel('open').panel('refresh'); --%>
			window.close();
		});
	}
}
</script>