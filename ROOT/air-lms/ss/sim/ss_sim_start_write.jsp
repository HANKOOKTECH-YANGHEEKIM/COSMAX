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
BeanResultMap requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
String pageOrderByField  	= requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
String pageOrderByMethod 	= requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);
String sol_mas_uid 		=	requestMap.getString("SOL_MAS_UID");
String ss_sim_uid 			= requestMap.getString("SS_SIM_UID");
String temp_ss_sim_uid 		= StringUtil.getRandomUUID(); //새로 생성한 아이디

String updateYn				= requestMap.getString("UPDATE_YN");

//-- 결과값 셋팅
BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
SQLResults sqlrSS_MAS = resultMap.getResult("SS_MAS");

BeanResultMap masMap = new BeanResultMap();
if(sqlrSS_MAS != null && sqlrSS_MAS.getRowCount()> 0){
	masMap.putAll(sqlrSS_MAS.getRowResult(0));
}

SQLResults sqlrSS_SIM = resultMap.getResult("SS_SIM");

BeanResultMap simMap = new BeanResultMap();
if(sqlrSS_SIM != null && sqlrSS_SIM.getRowCount()> 0){
	simMap.putAll(sqlrSS_SIM.getRowResult(0));
}

//-- 파라메터 셋팅
String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

String strCurGubunList = StringUtil.getCodestrFromSQLResults(resultMap.getResult("CUR_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));// + "^SJ/HJ|심급/확정종결";
String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMSSS002_SIM_LIST"), "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
String BEOBWEON_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("LMSSS002_BEOBWEON_LIST"), "CODE,LANG_CODE", "|");

String PROG_CODESTR = "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^"+StringUtil.getCodestrFromSQLResults(resultMap.getResult("PROG_LIST"), "CODE,LANG_CODE", "");
String SEONGO_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SEONGO_LIST"), "CODE,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
String GYEOLGWA_CODESTR = "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^"+StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_LIST"), "CODE,LANG_CODE", "");
String GYEOLGWA_CODESTR1 = "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^"+StringUtil.getCodestrFromSQLResults(resultMap.getResult("GYEOLGWA_HYEONGSA_LIST"), "CODE,LANG_CODE", "");

String ss_003_uid = simMap.getString("SS_003_UID");

if("".equals(ss_003_uid)){
	ss_003_uid = StringUtil.getRandomUUID();
}

String new_ss_003_uid   = StringUtil.getRandomUUID();

// 갱신일 경우 UID 생성
if(StringUtil.isNotBlank(ss_sim_uid)){
	ss_003_uid = new_ss_003_uid;
}

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
	<caption><%=StringUtil.getLocaleWord("L.심급정보등록",siteLocale) %> ( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale) %>)</caption>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></span></th>
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, true, "SIM_COD", "SIM_COD", SIM_CODESTR, simMap.getString("SIM_COD") , "class=\"select \" style=\"width:320px\" onchange=\"setSimNam();\"")%>
			<input type="hidden" name="SIM_NAM" id="SIM_NAM" value="<%=simMap.getString("SIM_NAM") %>" />
			<script>
				var setSimNam = function(){
					$("#SIM_NAM").val($("#SIM_COD option:selected").text());
					if(""==$("#SIM_COD").val()||"01"==$("#SIM_COD").val()) { //준비 또는 1심
						$("#span_damdangja").hide();
					} else {
						$("#span_damdangja").show();
					}
				};
			</script>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관할법원",siteLocale) %></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "beobweon", "beobweon", BEOBWEON_CODESTR, simMap.getString("BEOBWEON_COD"), "class=\"select easyui-combobox\" style=\"width:320px\" ")%>
			<input type="hidden" name="beobweon_cod" id="beobweon_cod" value="<%=StringUtil.convertForInput(simMap.getString("BEOBWEON_COD"))%>" />
			<input type="hidden" name="beobweon_nam" id="beobweon_nam" value="<%=StringUtil.convertForInput(simMap.getString("BEOBWEON_NAM"))%>" />
			<input type="hidden" name="beobweon_type" id="beobweon_type" value="" />
			<script>
			$(function () {
				$("#beobweon").combobox({
					selectOnNavigation:$(this).is(':checked')
				});
			});
			$("#beobweon").combobox().next().children(":text").blur(function(){
				ckBeobweon();
			});
			</script>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.사건번호",siteLocale) %>/<%=StringUtil.getLocaleWord("L.사건명",siteLocale) %></th>
		<td class="td4">
			
			<% 
				String gahab =  StringUtil.getLocaleWord("L.가합",siteLocale);
				String bubwonSagunNm =  StringUtil.getLocaleWord("L.법원_사건명",siteLocale);	
			%>
			
		
			<input type="text" name="SAGEON_NO" class="text" style="width:30%" placeholder="XXXX <%=gahab %> XXXX" value="<%=StringUtil.convertForInput(simMap.getString("SAGEON_NO")) %>" onblur="airCommon.validateSpecialChars(this);airCommon.validateMaxLength(this, 50);this.value = airCommon.getTrim(this.value);">
			/
			<input type="text" name="SAGEON_TIT" id="SAGEON_TIT" placeholder="<%=bubwonSagunNm %>" class="text" style="width:60%" value="<%=StringUtil.convertForInput(simMap.getString("SAGEON_TIT")) %>" maxlength="100" /><br>
			<span style="color:red"><%=StringUtil.getLocaleWord("M.사건번호등록의예",siteLocale) %></span>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.종국일자",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "SEONGO_DTE", "SEONGO_DTE", simMap.getString("SEONGO_DTE"), "") %>
		</td>
		<th class="th4"></span><%=StringUtil.getLocaleWord("L.종국결과",siteLocale) %></th>
		<td class="td4">
			<input type="text" name="GYEOLGWA_VAL" id="GYEOLGWA_VAL" value="<%=StringUtil.convertForInput(simMap.getString("GYEOLGWA_VAL")) %>" maxlength="500" class="text width_max2" />
		</td>
	</tr>
	
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.접수일",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "SOJEGI_DTE", "SOJEGI_DTE", simMap.getString("SOJEGI_DTE"), "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.불복마감일",siteLocale) %></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "SANGSO_DTE", "SANGSO_DTE", simMap.getString("SANGSO_DTE"), "") %>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.원고대리인",siteLocale) %></th>
		<td class="td4">
			<input type="text" name="WEONGO_DAERIIN" id="WEONGO_DAERIIN" value="<%=StringUtil.convertForInput(simMap.getString("WEONGO_DAERIIN")) %>" maxlength="500" class="text width_max2" />
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.피고대리인",siteLocale) %></th>
		<td class="td4">
			<input type="text" name="SANGDAE_DAERIIN" id="SANGDAE_DAERIIN" value="<%=StringUtil.convertForInput(simMap.getString("SANGDAE_DAERIIN")) %>" maxlength="500" class="text width_max2" />
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.대리인평가내용",siteLocale) %></th>
		<td colspan="3">
			<textarea class="memo width_max" name="PANGYEOL_CONT" id="PANGYEOL_CONT" onblur="airCommon.validateMaxLength(this, 4000)" style="height:100px;"><%=simMap.getStringEditor("PANGYEOL_CONT") %></textarea>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.판결문",siteLocale) %>/<%=StringUtil.getLocaleWord("L.결정문",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/JUDGMENT" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.답변서_준비서면",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/ANSWER" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>
	</tr>
	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.소장",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/SOJANG" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부",siteLocale) %></th>			
		<td class="td4">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/SS/SIM_START" name="typeCode" />
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
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
    </div>
</div>	
<script>

//같은 단어이지만 공백들어갔을시, 코드에 등록된 단어로 치환후 저장하도록 수정, beobweon, beobweon_nam
function ckBeobweon(){
	//alert("ckBeobweon");
	var optionText; 
	//var beobweon = $("input[name=beobweon]").val();
	//var inputText  = $("input[name=beobweon]").val().replace(/ /g, ''); //입력한 텍스트 공백제거
	var inputText  = $("#beobweon").combobox("getText").replace(/ /g, '').toUpperCase();
	var i=0;
	
	$('#beobweon > option').each(function() {
		optionText = $(this).text(); //SelectBox Text
		if(inputText == optionText.replace(/ /g, '')){
			++i;	
			$('#beobweon').combobox('setText',optionText);
			$("#beobweon_cod").val($("#beobweon").combobox("getValue").replace(/ /g, '').toUpperCase());
			$("#beobweon_nam").val($("#beobweon").combobox("getText").replace(/ /g, '').toUpperCase());
		}
	});
	//-- 단은 단어가 없다면 명칭만 넣고 초기환
	if(i == 0){
			$("#beobweon_cod").val("");
			$("#beobweon_nam").val(inputText);
	}
}

//법원 코드ID 데이터 타입 확인
function ckBeobweonType(){
	var beobweon_cod = $("#beobweon_cod").val();
	//alert("isNan = "+isNaN(beobweon_cod) +" / " + isNaN(123) );
	var result = isNaN(beobweon_cod);
	
	//숫자는 false, 문자는 true
	if(result){
		//alert("String "+beobweon_cod);
		$("#beobweon_type").val("STRING");
	}else{
		//alert("number "+beobweon_cod);
		$("#beobweon_type").val("INT");
	}
	
	//string, number
}

/**
 * 대리인 오픈창
 */
$('#BTN_SCH_DAERIIN').click(function(){
	var url = "/ServletController";
	url += "?<%=CommonConstants.ACTION_CODE%>=SYS_COMPANY";
	url += "&<%=CommonConstants.MODE_CODE%>=POPUP_SELECT_BS";
	url += "&classCodes=BS";
	url += "&callbackFunction=" + escape("callbackDaeriin(\'[CODE]\',\'[NAME]\')");
	
	airCommon.openWindow(url, 800, 500, 'popCTP', 'yes', 'no', '');
});

/**
 * 대리인 오픈창 callback function
 */
function callbackDaeriin(code, name){
    var init_code = document.getElementById("DAERIIN_COD").value;	
	var init_name = document.getElementById("DAERIIN_NAM").value;
	
	init_code = (init_code == "" ? code : init_code +","+ code);
	init_name = (init_name == "" ? name : init_name +","+ name);
	
	initDaeriin(true, init_code, init_name);
}

function initDaeriin(isForceInit, code, name) {
	code = (code == undefined ? "" : code);
	name = (name == undefined ? "" : name);

	if (!isForceInit && !confirm("<%=StringUtil.getLocaleWord("M.초기화하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.상대방", siteLocale))%>")) {
		return false;
	}
		
	document.getElementById("DAERIIN_COD").value = code;
	document.getElementById("DAERIIN_NAM").value = name;
}

//daeriin_nam
//상대방 항목 빈칸 입력방지
$('#DAERIIN_NAM').blur(function() {
	$('#DAERIIN_NAM').val($('#DAERIIN_NAM').val().replace(/\s/gi, ''));
});

var frm = document.form1;
    
function addIn_<%=ss_sim_uid%>(inGbn, inName, inBigo) {	
	inName = (inName == undefined ? "" : inName);
	inBigo = (inBigo == undefined ? "" : inBigo);
	
	var body = document.getElementById("InBody_"+ inGbn+"<%=ss_sim_uid%>");
	var row = body.insertRow(-1);
	var cell;
	
	cell = row.insertCell(0);
	cell.align = "center";
	cell.innerHTML = '<input type="checkbox" name="in_chk_'+ inGbn +'" class="checkbox" />';
	
	cell = row.insertCell(1);
	cell.align = "center";
	cell.innerHTML = '<input type="text" name="in_name_'+ inGbn +'" class="text width_max" value="'+ airCommon.convertForInput(inName) +'" />';
	
	cell = row.insertCell(2);
	cell.align = "left";
	cell.innerHTML = '<input type="text" name="in_bigo_'+ inGbn +'" class="text width_max" value="'+ airCommon.convertForInput(inBigo) +'" />';				
}

function delIn_<%=ss_sim_uid%>(inGbn) {
	var body = document.getElementById("InBody_"+ inGbn+"<%=ss_sim_uid%>");		
	var rows = body.rows;
	var cnt = rows.length;
		
	var chk = document.getElementsByName("in_chk_"+ inGbn);
	
	if (!airCommon.isCheckedInput(chk)) {
		alert("<%=StringUtil.getLocaleWord("M.삭제할대상을선택해주세요",siteLocale)%>");
		return;
	}
	
	for(var i=chk.length-1; i>=0; i--) {
		if (chk[i].checked == true ) {
			body.deleteRow(i);					
		}
	}
}	


var goProc = function(){

	if ("" == $("#SIM_COD").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.심급",siteLocale))%>");
		$("#SIM_COD").focus();
	    return false;
	}
	if ("" == $("#SOJEGI_DTE").val() ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.접수일",siteLocale))%>");
		$("#SOJEGI_DTE").focus();
	    return false;
	}
	
	ckBeobweon();
	ckBeobweonType();

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		var data = $("#saveForm").serialize();
		
		airCommon.callAjax("<%=actionCode%>", "SIM_START_WRITE_PROC",data, function(json){
			try {
				
				opener.refreshWindow();	
				<%-- opener.$('#accordion-SimView<%//=sol_mas_uid%>').panel('open').panel('refresh'); --%>	
 				
				/* opener.opener.doSearch();	//--리스트 대응 */
			} catch(Exception) {
				try{
					opener.opener.initMain(); //--메인화면일때 대응
				}catch(e){
					
				}
			}
			window.close();
		});
	}
};
</script>