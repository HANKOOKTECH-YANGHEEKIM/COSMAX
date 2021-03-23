<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*"%>
<%@ page import="com.emfrontier.air.common.config.*"%>
<%@ page import="com.emfrontier.air.common.jdbc.*"%>
<%@ page import="com.emfrontier.air.common.model.*"%>
<%@ page import="com.emfrontier.air.common.util.*"%>
<%


	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();


	//-- 요청값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	SQLResults FORM_MAS 	= resultMap.getResult("FORM_MAS");
	SQLResults PATI_LIST 	= resultMap.getResult("PATI_LIST");
	SQLResults DEF_DOC_MAS 	= resultMap.getResult("DEF_DOC_MAS");
	SQLResults DEF_STU	 	= resultMap.getResult("DEF_STU");
	SQLResults LMS_MAS	 	= resultMap.getResult("LMS_MAS");
	SQLResults CUBE_MAS	 	= resultMap.getResult("CUBE_MAS");
	
	
	//-- 파라메터 셋팅
	String actionCode		= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode			= resultMap.getString(CommonConstants.MODE_CODE);
	
	
	BeanResultMap defDocMas = new BeanResultMap();
	if(DEF_DOC_MAS != null && DEF_DOC_MAS.getRowCount()> 0){
		defDocMas.putAll(DEF_DOC_MAS.getRowResult(0));
	}
	
	BeanResultMap formMas = new BeanResultMap();
			
	
	if(FORM_MAS != null && FORM_MAS.getRowCount()> 0){
		formMas.putAll(FORM_MAS.getRowResult(0));
	}
	
	String munseo_seosig_no 		= requestMap.getString("MUNSEO_SEOSIG_NO");
	String doc_mas_uid 				= requestMap.getString("DOC_MAS_UID");
	String group_uid 				= requestMap.getString("GROUP_UID");
	String sol_mas_uid 				= requestMap.getString("SOL_MAS_UID");
	String next_stu_id				= requestMap.getString("NEXT_STU_ID");
	String stu_id					= requestMap.getString("STU_ID");
	String doc_stu					= requestMap.getString("DOC_STU");
	String new_doc_mas_uid   		= StringUtil.getRandomUUID();
	
	boolean isNew = false;
	if(StringUtil.isBlank(doc_mas_uid)){
		doc_mas_uid = StringUtil.getRandomUUID();
		isNew = true;
	}
	
	
	BeanResultMap defStu = new BeanResultMap();
	if(DEF_STU != null && DEF_STU.getRowCount() > 0){
		defStu.putAll(DEF_STU.getRowResult(0));
	}
	
	BeanResultMap lmsMas = new BeanResultMap();
	if(LMS_MAS != null && LMS_MAS.getRowCount() > 0){
		lmsMas.putAll(LMS_MAS.getRowResult(0));
	}
	
	BeanResultMap cubeMas = new BeanResultMap();
	if(CUBE_MAS != null && CUBE_MAS.getRowCount() > 0){
		cubeMas.putAll(CUBE_MAS.getRowResult(0));
	}
%>
<form name="saveForm<%=sol_mas_uid%>" id="saveForm<%=sol_mas_uid%>">
	<input type="hidden" name="group_uid" value="<%=group_uid%>" />
	<input type="hidden" name="doc_mas_uid" value="<%=doc_mas_uid%>" />
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="munseo_seosig_no" value="<%=munseo_seosig_no%>" />
	<input type="hidden" name="is_new" value="<%=isNew%>" />
	<input type="hidden" name="doc_stu" id="doc_stu" value="" />
	<input type="hidden" name="wrt_id" id="wrt_id" value="<%=cubeMas.getString("WRT_ID") %>" />
	<input type="hidden" name="wrt_dte" id="wrt_dte" value="<%=cubeMas.getString("WRT_DTE") %>" />
	<input type="hidden" name="stu_gbn" id="stu_gbn" value="<%=lmsMas.getDefStr("STU_GBN", defStu.getString("STU_GBN")) %>" />
	<input type="hidden" name="stu_id" id="stu_id" value="<%=stu_id %>" />
	<input type="hidden" name="next_stu_id" id="next_stu_id" value="<%=next_stu_id %>" />
	<input type="hidden" name="munseo_bunryu_gbn_sys_cod_id1" value="<%=formMas.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID1") %>" />
	<input type="hidden" name="munseo_bunryu_gbn_sys_cod_id2" value="<%=formMas.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID2") %>" />
	
	<div id="aprDiv"></div>
	<div id="refDiv"></div>
	
<%if("DEV".equals(CommonProperties.getSystemMode())){%>	
<font color="#DDDDDD">++No : <%= munseo_seosig_no %></font><br>
<%}%>	
	
<% if(!PATI_LIST.isEmptyRow()){%>
	<%for(int i=0; i<PATI_LIST.getRowCount(); i++){%>
		<%String mng_pati_uid = PATI_LIST.getString(i,"mng_pati_uid");%>
		<%String pati_johoe_auth_codes = PATI_LIST.getString(i,"pati_johoe_auth_codes");%>
		<%if(loginUser.isUserAuth(pati_johoe_auth_codes)){%>	
			<%if("DEV".equals(CommonProperties.getSystemMode())){%>	
		<font color="#DDDDDD">++시작 : <%= PATI_LIST.getString(i, "PATI_GWANRI_NO") %>++</font><br>
			<%}%>
		<input type="hidden" name="mng_pati_uid" value="<%=mng_pati_uid%>">
		<jsp:include page="/ServletController" flush="false">
			<jsp:param value="<%=mng_pati_uid%>" 	    name="AIR_PARTICLE"/>
			<jsp:param value="<%=sol_mas_uid%>" 	    name="sol_mas_uid"/>
			<jsp:param value="<%=doc_mas_uid%>" 	    name="doc_mas_uid"/>
			<jsp:param value="<%=new_doc_mas_uid%>"     name="new_doc_mas_uid"/>
			<jsp:param value="<%=modeCode%>"		   name="doc_mas_mode_code"/>
			<jsp:param value="<%=munseo_seosig_no%>" 	name="munseo_seosig_no"/>
			<jsp:param value="<%=isNew%>" 				name="isNew"/>
			<jsp:param value="WRITE" name="AIR_MODE"/>
		</jsp:include>
		<%}else{%>
			<%if("DEV".equals(CommonProperties.getSystemMode())){%>
			<div style="line-height:80px;background-color:#f7f7f7;border: 1px solid #999;text-align:center; ">
				<span>
				   열람권한이 없습니다.
				</span>
			</div>
			<%}%>
		<%}%>
	<%}%>
<%}%>
<% if("Y".equals(formMas.getString("GIBON_MEMO_DSP_YN"))){%>
	<table class="basic">
		<%if(StringUtil.isNotBlank(defStu.getString("STU_BASE_NM"))){ %>
		<caption><%=defStu.getString("STU_BASE_NM") %></caption>
		<%} %>
		<tr>
			<th class="th2">
				<input type="hidden" name="lms_pati_base_caption" value="<%=defStu.getString("STU_BASE_NM")%>"/>
				<input type="hidden" name="lms_pati_base_label" value="<%=defDocMas.getDefStr("GIBON_MEMO_DSP_LABEL", StringUtil.getLocaleWord("L.메모", siteLocale))%>"/>
				<%=defDocMas.getDefStr("GIBON_MEMO_DSP_LABEL", StringUtil.getLocaleWord("L.메모", siteLocale)) %>
			</th>
			<td class="td2">
				<textarea rows="5" class="text width_max" maxlength="1000" name="lms_pati_base_memo"></textarea>
			</td>
		</tr>
	</table>
<%}%>

</form>
<div class="buttonlist">
    <div class="left">
    </div>
    <div class="right">
   <%
    	if(DEF_STU != null && DEF_STU.getRowCount() > 0){
    		if(DEF_STU.getString(0, "PROC_GBN").indexOf("D") > -1 && "T".equals(doc_stu)){
    %>
    	<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)"  onclick="doSubmit<%=sol_mas_uid%>('D');">
    		<%if("T".equals(doc_stu)){ %>
    		<%=StringUtil.getLocaleWord("L.삭제",siteLocale)%>
    		<%}else{ %>
    		<%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%>
    		<%} %>
    	</a></span>
    <%
    		}
    		if(DEF_STU.getString(0, "PROC_GBN").indexOf("T") > -1){
    %>
    	<span class="ui_btn medium icon"><span class="modify"></span><a href="javascript:void(0)" data-meaning="TEMP"   onclick="doSubmit<%=sol_mas_uid%>('T');"><%=StringUtil.getLocaleWord("L.임시저장",siteLocale)%></a></span>
    <%
    		}
    		if(DEF_STU.getString(0, "PROC_GBN").indexOf("A") > -1){
    %>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="selAprvLine<%=sol_mas_uid%>();"><%=StringUtil.getLocaleWord("L.결재요청",siteLocale)%></a></span>
    <%
    		}
    		if(DEF_STU.getString(0, "PROC_GBN").indexOf("S") > -1){
    %>
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="doSubmit<%=sol_mas_uid%>('S');"><%=StringUtil.getLocaleWord("L.처리",siteLocale)%></a></span>
    <%
    		}
    	}
    
    %>
    </div>
</div>



<script type="text/javascript">
var _dataCheck<%=sol_mas_uid%> = function(){
	<% if(!PATI_LIST.isEmptyRow()){%>
		<%for(int i=0; i<PATI_LIST.getRowCount(); i++){%>
		<%String mng_pati_uid = PATI_LIST.getString(i,"mng_pati_uid");%>
			if(<%="Parti"+mng_pati_uid%>_dataCheck()==false){return false;}
		<%}%>
	<%}%>
	return true;
}
var _tmpDataCheck<%=sol_mas_uid%> = function(){
	<% if(!PATI_LIST.isEmptyRow()){%>
		<%for(int i=0; i<PATI_LIST.getRowCount(); i++){%>
		<%String mng_pati_uid = PATI_LIST.getString(i,"mng_pati_uid");%>
			if(<%="Parti"+mng_pati_uid%>_tmpDataCheck()==false){alert("false");return false;}
		<%}%>
	<%}%>
	return true;
}

var validate = false;
var chkVal<%=sol_mas_uid%> = function(mode){

	if(!validate){
		if("T" == mode){
			if(!_tmpDataCheck<%=sol_mas_uid%>()) return false;
		}else if("D" == mode){
			return true;
		}else{
			if(!_dataCheck<%=sol_mas_uid%>()) return false;
		}
		validate = true;
		return true;
	}else{
		return true;
	}
	
}
var isDoSubmit = true;
var doSubmit<%=sol_mas_uid%> = function(mode){
	
	
	if(!chkVal<%=sol_mas_uid%>(mode)) return false;
	
	//-- 중복클릭 방어 코드
	if(!isDoSubmit) return false;
	else isDoSubmit = false;

	$("#doc_stu").val(mode);

	
	var msg1 = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.TEMP_SAVE")%>";
	var msg2 = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.처리")%>";
	var msg3 = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "L.결재요청")%>";
	<%if("T".equals(doc_stu)){ %>
	var msg4 = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.삭제")%>";
	<%}else{ %>
	var msg4 = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.CANCEL")%>";
	<%}%>
	var msg = "";
	
	if("T" == mode){
		msg = msg1;
	}else if("F" == mode){
		msg = msg3;
	}else if("D" == mode){
		msg = msg4;
	}else{
		msg = msg2;
	}
	
	setTimeout(function(){ 
		if(confirm(msg)){
			
			//--에디터 서브밋 처리
			airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
			
			var data = $("#saveForm<%=sol_mas_uid%>").serialize();
			airCommon.callAjax("SYS_FORM", "WRITE_PROC",data, function(json){

<%-- 				alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.처리")%>"); --%>
				if(opener){
					//-- 최조장성인경우 메인거나 부모창이 리스트가 아닐경우를 위해 try catch로 묶음
					try{
						//--그리드 리스트 refresh
						opener.doSearch(opener.document.form1);
					}catch(e){
						try{
							//-- 메인 화면 refresh
							opener.initMain();
						}catch(e){
							
						}
					}
					if(json.DOC_STU == "T" || (json.DOC_STU == "D" && !json.NEXT_STU_ID.endsWith("_REQ") && !json.NEXT_STU_ID.endsWith("_PUM2")) ){
						
						var action_code = "LMS_"+json.STU_GBN+"_LIST_MAS";
						var mode_code = "POPUP_INDEX";
						if("SS" ==  json.STU_GBN){
							action_code = "LMS_SS_MAS";
							mode_code = "POPUP_INDEX";
						}else if(json.STU_GBN.indexOf("OLD") > -1){
							action_code = "LMS_GY_OLD";
						}
						
						//-- 임시저장이면서 팝업상태이면 닫지 않고 TEP를 띄워 준다.
						var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
						imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val(action_code));
						imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val(mode_code));
						imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val(json.SOL_MAS_UID));
						imsiForm.attr("target","_self");
						imsiForm.appendTo("body");
						imsiForm.submit();
						
					}else{
						window.close();
					}
				}else{
					selectTabRefresh();
				}
			},function(){
				isDoSubmit = true;
				$("#aprDiv").html("");
				$("#refDiv").html("");
			});
			
		}else{
			isDoSubmit = true;
			$("#aprDiv").html("");
			$("#refDiv").html("");
			
		}	
	}, 500);
	
		
	
	
}
//-- 결재선 선택
var selAprvLine<%=sol_mas_uid%> = function(){
	
	if(!chkVal<%=sol_mas_uid%>("S")) return false;
	
	var url = "/ServletController";
	url += "?AIR_ACTION=SYS_USER";
	url += "&AIR_MODE=POPUP_SIGN_SELECT";
	url += "&groupTypeCodes=IG";
	url += "&callbackFunction=setAprvCallBack<%=sol_mas_uid%>";
	
	airCommon.openWindow(url, "1024", "700", "POPUP_SIGN_SELECT", "yes", "yes", "");	
}
//-- 결재선 셋팅
var setAprvCallBack<%=sol_mas_uid%> = function(data){
	
	var apr = JSON.parse(data)["APR"]; 
	var ref = JSON.parse(data)["REF"]; 
	var apr_memo = JSON.parse(data)["APR_MEMO"]; 
	var none_apr_yn = JSON.parse(data)["NONE_APR_YN"]; 
	
	$("#aprDiv").html("");
	//-- 결재자 데이터 추가
	$(apr).each(function(i, d){
		$("#aprDiv").append($("<input type='hidden' name='_APR_UUIDS'>").val(d.UUID));
		$("#aprDiv").append($("<input type='hidden' name='_APR_LOGIN_ID'>").val(d.LOGIN_ID));
		$("#aprDiv").append($("<input type='hidden' name='_APR_NAME_KO'>").val(d.NAME_KO));
		$("#aprDiv").append($("<input type='hidden' name='_APR_TYPE'>").val(d.APR_TYPE));
		$("#aprDiv").append($("<input type='hidden' name='_APR_NAME_EN'>").val(d.NAME_EN));
		$("#aprDiv").append($("<input type='hidden' name='_APR_POSITION_NAME_KO'>").val(d.POSITION_NAME_KO));
		$("#aprDiv").append($("<input type='hidden' name='_APR_POSITION_NAME_EN'>").val(d.POSITION_NAME_EN));
		$("#aprDiv").append($("<input type='hidden' name='_APR_GROUP_UUID'>").val(d.GROUP_UUID));
		$("#aprDiv").append($("<input type='hidden' name='_APR_GROUP_CODE'>").val(d.GROUP_CODE));
		$("#aprDiv").append($("<input type='hidden' name='_APR_GROUP_NAME_KO'>").val(d.GROUP_NAME_KO));
		$("#aprDiv").append($("<input type='hidden' name='_APR_GROUP_NAME_EN'>").val(d.GROUP_NAME_EN));
		$("#aprDiv").append($("<input type='hidden' name='_APR_TELEPHONE_NO'>").val(d.TELEPHONE_NO));
		$("#aprDiv").append($("<input type='hidden' name='_APR_EMAIL'>").val(d.EMAIL));
		$("#aprDiv").append($("<input type='hidden' name='_APR_HOESA_COD'>").val(d.HOESA_COD));
	});
	//-- 전결처리여부
	$("#aprDiv").append($("<input type='hidden' name='_none_apr_yn'>").val(none_apr_yn));
	//-- 상신 메모
	$("#aprDiv").append($("<input type='hidden' name='_apr_memo'>").val(apr_memo));
	
	
	$("#refDiv").html("");
	//-- 참조자 데이터 추가
	$(ref).each(function(i, d){
		$("#refDiv").append($("<input type='hidden' name='_REF_UUIDS'>").val(d.UUID));
		$("#refDiv").append($("<input type='hidden' name='_REF_LOGIN_ID'>").val(d.LOGIN_ID));
		$("#refDiv").append($("<input type='hidden' name='_REF_NAME_KO'>").val(d.NAME_KO));
		$("#refDiv").append($("<input type='hidden' name='_REF_NAME_EN'>").val(d.NAME_EN));
		$("#refDiv").append($("<input type='hidden' name='_REF_APR_TYPE'>").val(d.APR_TYPE));
		$("#refDiv").append($("<input type='hidden' name='_REF_POSITION_NAME_KO'>").val(d.POSITION_NAME_KO));
		$("#refDiv").append($("<input type='hidden' name='_REF_POSITION_NAME_EN'>").val(d.POSITION_NAME_EN));
		$("#refDiv").append($("<input type='hidden' name='_REF_GROUP_UUID'>").val(d.GROUP_UUID));
		$("#refDiv").append($("<input type='hidden' name='_REF_GROUP_CODE'>").val(d.GROUP_CODE));
		$("#refDiv").append($("<input type='hidden' name='_REF_GROUP_NAME_KO'>").val(d.GROUP_NAME_KO));
		$("#refDiv").append($("<input type='hidden' name='_REF_GROUP_NAME_EN'>").val(d.GROUP_NAME_EN));
		$("#refDiv").append($("<input type='hidden' name='_REF_TELEPHONE_NO'>").val(d.TELEPHONE_NO));
		$("#refDiv").append($("<input type='hidden' name='_REF_EMAIL'>").val(d.EMAIL));
		$("#refDiv").append($("<input type='hidden' name='_REF_HOESA_COD'>").val(d.HOESA_COD));
	});

	//-- 저장 및 상태처리
	doSubmit<%=sol_mas_uid%>("F");
	
	
}

$("[data-length][data-length!='']").trigger("keyup");
$(function(){
	try{
		setLoadPanel<%=sol_mas_uid%>();
		<%if(StringUtil.isNotBlank(next_stu_id)){%>
		$("#proc_<%=next_stu_id%>").hide();
		<%}%>
	}catch(e){
		
	}
})
</script>



