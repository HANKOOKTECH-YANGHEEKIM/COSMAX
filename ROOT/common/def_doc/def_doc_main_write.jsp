<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="org.apache.commons.lang3.StringEscapeUtils" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap = (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);

	//-- 결과값 셋팅
	BeanResultMap resultMap 			= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult 				= resultMap.getResult("DEF_DOC_MAIN");
	
	SQLResults defDocPatiSangdanList	= resultMap.getResult("DEF_DOC_PATI_SANGDAN_LIST");
	SQLResults defDocPatiHadanList		= resultMap.getResult("DEF_DOC_PATI_HADAN_LIST");
	SQLResults defDocPatiGeomList		= resultMap.getResult("DEF_DOC_PATI_GEOM_LIST");
	SQLResults defDocPatiGyeolList		= resultMap.getResult("DEF_DOC_PATI_GYEOL_LIST");
	SQLResults defDocPatiSuList			= resultMap.getResult("DEF_DOC_PATI_SU_LIST");
	SQLResults defDocAtchDoc			= resultMap.getResult("DEF_DOC_ATCH_DOC");
	
	SQLResults sysMunseoBunryuGbnList	= resultMap.getResult("SYS_MUNSEO_BUNRYU_GBN_LIST"); 
	
	SQLResults userAuthListResult 		= resultMap.getResult("AUTH_CODES");
	//SQLResults hcBiyongGyejeongCode 	= resultMap.getResult("HC_BIYONG_GYEJEONG_CODE");
	
	//-- 파라메터 셋팅
	String actionCode	= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode		= resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 상세보기 값 셋팅		
	
	BeanResultMap defMainMap = new BeanResultMap();
	if(viewResult != null && viewResult.getRowCount()  >0 ){
		defMainMap.putAll(viewResult.getRowResult(0));
	}
	//--기본 권한 전체 부여
	String paticleInitData = "";
	if(userAuthListResult != null && userAuthListResult.getRowCount() > 0){
		for(int i=0; i< userAuthListResult.getRowCount() ; i++){
			if(i > 0){
				paticleInitData += ",";
			}
			paticleInitData += userAuthListResult.getString(i, "CODE");
		}
	}
	
	//-- 코드정보 문자열 셋팅
	String sysMunseoBunryuGbnStr    = StringUtil.getCodestrFromSQLResults(sysMunseoBunryuGbnList, "CODE_ID,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale) );
	String userAuthCodestr 	        = StringUtil.getCodestrFromSQLResults(userAuthListResult, "CODE,LANG_CODE", "");
	//String hcBiyongGyejeongCodeStr  = StringUtil.getCodestrFromSQLResults(hcBiyongGyejeongCode, "COST_DETAIL,COST_NAME_KO",  "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale) );
%>
<script type="text/javascript" src="/common/_lib/jquery-ui/jquery-ui.js"></script>
<script type="text/javascript">
/**
 * 저장
 */	
function doSubmit(frm) {
	var mode_code = frm.<%=CommonConstants.MODE_CODE%>.value;
	
	if(frm.munseo_bunryu_gbn_sys_cod_id1.selectedIndex == 0 || frm.munseo_bunryu_gbn_sys_cod_id2.selectedIndex == 0 || frm.munseo_bunryu_gbn_sys_cod_id3.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서분류구분", siteLocale))%>");
		return;
	}
	
	if(frm.munseo_seosig_gbn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서서식구분", siteLocale))%>");
		frm.munseo_seosig_gbn.focus();
		return;
	}
	
	if(frm.gibon_tit_dsp_yn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.제목표시유무", siteLocale))%>");
		frm.gibon_tit_dsp_yn.focus();
		return;
	}

	if(frm.gibon_memo_dsp_yn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.내용표시유무", siteLocale))%>");
		frm.gibon_memo_dsp_yn.focus();
		return;
	}
	
	if(frm.seosig_nam.value == ""){
		alert("<%=StringUtil.getScriptMessage("M.입력해주세요",siteLocale,StringUtil.getLocaleWord("L.문서서식명", siteLocale))%>");
		frm.seosig_nam.focus();
		return;
	}
	
	if(frm.munseo_end_edit_yn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서종료후_수정가능", siteLocale))%>");
		frm.munseo_end_edit_yn.focus();
		return;
	}
	
	if(frm.munseo_create_gbn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서생성구분", siteLocale))%>");
		frm.munseo_create_gbn.focus();
		return;
	}
	
	if(frm.pyegi_able_yn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서폐기가능", siteLocale))%>");
		frm.pyegi_able_yn.focus();
		return;
	}
	
	if(frm.doc_sagje_able_yn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서삭제가능", siteLocale))%>");
		frm.doc_sagje_able_yn.focus();
		return;
	}
	
	if(frm.doc_real_sagje_able_yn.selectedIndex == 0){
		alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale,StringUtil.getLocaleWord("L.문서물리적삭제가능", siteLocale))%>");
		frm.doc_real_sagje_able_yn.focus();
		return;
	}
	
	
	if((frm.doc_sagje_able_yn.options[frm.doc_sagje_able_yn.selectedIndex].value == "Y")
			&& (frm.doc_real_sagje_able_yn.options[frm.doc_real_sagje_able_yn.selectedIndex].value == "Y")){
		alert ("<%=StringUtil.getLocaleWord("M.문서삭제와문서물리적삭제중한가지만Y가될수있습니다",siteLocale)%>");
		return;
	}
	
	//data-meaning="auth_codes"
	var sangdan_tr = $("#particleSangdanTable_body [data-meaning=sangdan_tr]");
	var sangdan_tr_cnt = $("#particleSangdanTable_body [data-meaning=sangdan_tr]").length;
	for(var i=0; i< sangdan_tr_cnt; i++){
		if(sangdan_tr.eq(i).find("[name=pati_sangdan_auth_codes_temp]:checked").length == 0){
			alert("상단 파티클 권한을 체크해주세요.");
			sangdan_tr.eq(i).find("[name=pati_sangdan_auth_codes_temp]").eq(0).focus();
		}
	}
	
	var $tr = $("tr[data-meaning='sangdan_tr']");
	$tr.each(function(i, o){
		var arrAuth = [];
		$("input:checkbox[name='pati_sangdan_auth_codes_temp']:checked").each(function(j, d){
			arrAuth.push($(d).val());
		});
		$("input:hidden[name='sangdan_pati_johoe_auth_codes']", o).val(arrAuth.join(","));
	});

	/* 
	var hadan_tr = $("#particlehadanTable_body [data-meaning=hadan_tr]");
	var hadan_tr_cnt = $("#particlehadanTable_body [data-meaning=hadan_tr]").length;
	for(var i=0; i< hadan_tr_cnt; i++){
		if(hadan_tr.eq(i).find("[name=pati_hadan_auth_codes_temp]:checked").length == 0){
			alert("하단 파티클 권한을 체크해주세요.");
			hadan_tr.eq(i).find("[name=pati_hadan_auth_codes_temp]").eq(0).focus();
		}
	}
	var geom_tr = $("#particlegeomTable_body [data-meaning=geom_tr]");
	var geom_tr_cnt = $("#particlegeomTable_body [data-meaning=geom_tr]").length;
	for(var i=0; i< geom_tr_cnt; i++){
		if(geom_tr.eq(i).find("[name=pati_geom_auth_codes_temp]:checked").length == 0){
			alert("검토 파티클 권한을 체크해주세요.");
			geom_tr.eq(i).find("[name=pati_geom_auth_codes_temp]").eq(0).focus();
		}
	}
	var gyeol_tr = $("#particlegyeolTable_body [data-meaning=gyeol_tr]");
	var gyeol_tr_cnt = $("#particlegyeolTable_body [data-meaning=gyeol_tr]").length;
	for(var i=0; i< gyeol_tr_cnt; i++){
		if(gyeol_tr.eq(i).find("[name=pati_gyeol_auth_codes_temp]:checked").length == 0){
			alert("결재 파티클 권한을 체크해주세요.");
			gyeol_tr.eq(i).find("[name=pati_gyeol_auth_codes_temp]").eq(0).focus();
		}
	}
	var su_tr = $("#particlesuTable_body [data-meaning=su_tr]");
	var su_tr_cnt = $("#particlesuTable_body [data-meaning=su_tr]").length;
	for(var i=0; i< su_tr_cnt; i++){
		if(su_tr.eq(i).find("[name=pati_su_auth_codes_temp]:checked").length == 0){
			alert("수신 파티클 권한을 체크해주세요.");
			su_tr.eq(i).find("[name=pati_su_auth_codes_temp]").eq(0).focus();
		}
	}
	
	for(var i=0; i< sangdan_tr_cnt; i++){
		var chkCnt = sangdan_tr.eq(i).find("[name=pati_sangdan_auth_codes_temp]:checked").length;
		var auth_codes = "";
		for(var j=0; j< chkCnt ; j++){
			if(j > 0){
				auth_codes += ",";
			}
			auth_codes += sangdan_tr.eq(i).find("[name=pati_sangdan_auth_codes_temp]:checked").eq(j).val();
		}
		var inHtml = "<input type=\"hidden\" name=\"sangdan_pati_johoe_auth_codes\" value=\""+auth_codes+"\" >";
		sangdan_tr.eq(i).find("[data-meaning=sangdan_auth_codes]").append(inHtml);
	}
	for(var i=0; i< hadan_tr_cnt; i++){
		var chkCnt = hadan_tr.eq(i).find("[name=pati_hadan_auth_codes_temp]:checked").length;
		var auth_codes = "";
		for(var j=0; j< chkCnt ; j++){
			if(j > 0){
				auth_codes += ",";
			}
			auth_codes += hadan_tr.eq(i).find("[name=pati_hadan_auth_codes_temp]:checked").eq(j).val();
		}
		var inHtml = "<input type=\"hidden\" name=\"hadan_pati_johoe_auth_codes\" value=\""+auth_codes+"\" >";
		hadan_tr.eq(i).find("[data-meaning=hadan_auth_codes]").append(inHtml);
	}
	for(var i=0; i< geom_tr_cnt; i++){
		var chkCnt = geom_tr.eq(i).find("[name=pati_geom_auth_codes_temp]:checked").length;
		var auth_codes = "";
		for(var j=0; j< chkCnt ; j++){
			if(j > 0){
				auth_codes += ",";
			}
			auth_codes += geom_tr.eq(i).find("[name=pati_geom_auth_codes_temp]:checked").eq(j).val();
		}
		var inHtml = "<input type=\"hidden\" name=\"geom_pati_johoe_auth_codes\" value=\""+auth_codes+"\" >";
		geom_tr.eq(i).find("[data-meaning=geom_auth_codes]").append(inHtml);
	}
	for(var i=0; i< gyeol_tr_cnt; i++){
		var chkCnt = gyeol_tr.eq(i).find("[name=pati_gyeol_auth_codes_temp]:checked").length;
		var auth_codes = "";
		for(var j=0; j< chkCnt ; j++){
			if(j > 0){
				auth_codes += ",";
			}
			auth_codes += gyeol_tr.eq(i).find("[name=pati_gyeol_auth_codes_temp]:checked").eq(j).val();
		}
		var inHtml = "<input type=\"hidden\" name=\"gyeol_pati_johoe_auth_codes\" value=\""+auth_codes+"\" >";
		gyeol_tr.eq(i).find("[data-meaning=gyeol_auth_codes]").append(inHtml);
	}
	for(var i=0; i< su_tr_cnt; i++){
		var chkCnt = su_tr.eq(i).find("[name=pati_su_auth_codes_temp]:checked").length;
		var auth_codes = "";
		for(var j=0; j< chkCnt ; j++){
			if(j > 0){
				auth_codes += ",";
			}
			auth_codes += su_tr.eq(i).find("[name=pati_su_auth_codes_temp]:checked").eq(j).val();
		}
		var inHtml = "<input type=\"hidden\" name=\"su_pati_johoe_auth_codes\" value=\""+auth_codes+"\" >";
		su_tr.eq(i).find("[data-meaning=su_auth_codes]").append(inHtml);
	}
	 */
	var obj_pati_view_only_sangdan = document.getElementsByName("pati_view_only_sangdan");
	var obj_pati_view_only_hadan   = document.getElementsByName("pati_view_only_hadan");
	
	var obj_pati_view_only_pyosi_sijeom_sangdan = document.getElementsByName("pati_view_only_pyosi_sijeom_sangdan");
	var obj_pati_view_only_pyosi_sijeom_hadan   = document.getElementsByName("pati_view_only_pyosi_sijeom_hadan");
	
	for(var i=0; i<obj_pati_view_only_sangdan.length; i++){
		if("Y" == obj_pati_view_only_sangdan[i].value){
			if(obj_pati_view_only_pyosi_sijeom_sangdan[i].selectedIndex == 0){
				alert("상단파티클의 VIEW전용파티클에 대한 값을 설정해주십시오.");
				return;
			}
		}
	}
	
	for(var i=0; i<obj_pati_view_only_hadan.length; i++){
		if("Y" == obj_pati_view_only_hadan[i].value){
			if(obj_pati_view_only_pyosi_sijeom_hadan[i].selectedIndex == 0){
				alert("하단파티클의 VIEW전용파티클에 대한 값을 설정해주십시오.");
				return;
			}
		}
	}
	
	
	var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>";
	if(confirm(msg)){
		var data = $("#form1").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_DONE", siteLocale, "B.SAVE")%>");
			try{
				opener.doSearch();
			}catch(e){
				
			}
			window.close();
			
		});
	}
	
}

function getMunseoBunryuGbnCode(targetId, val){
	var data = {};
	data["PARENT_CODE_ID"] = val;
	airCommon.callAjax("SYS_CODE", "JSON_DATA",data, function(json){
		
		airCommon.initializeSelectJson(targetId, json, "|-- 선택 --", "CODE_ID", "NAME_KO");
	});
	
}



function doAddAtchDoc(){
	var tRow	= atchDocTable.insertRow(-1);								// Append Row ==> TR 태그 생성
	var tRows   = atchDocTable.rows;										// array of TR object

	var tCells  = tRow.cells;										// array of TD object
	var tCell1  = tRows(tRow.rowIndex).insertCell(tCells.length);	// TD 태그 생성
	
	var strBody ='';
	strBody = strBody + '   <table class="basic">';
	strBody = strBody + '   	<tr>';
	strBody = strBody + '   		<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식번호",siteLocale)%></th>';			
	strBody = strBody + '   		<td class="td4">';
	strBody = strBody + '   			<input type="text" name="atch_munseo_seosig_no" value="" style="width:80%;border:0px" readonly/>'; 
	strBody = strBody + '   			<input type="button" name="btn_search_atch_doc" value="검색" onClick="doSearchAtchDoc(\''+(tRows.length-1)+'\')">';
	strBody = strBody + '   		</td>';
	strBody = strBody + '   		<th class="th4"><%=StringUtil.getLocaleWord("L.작성후첨부문서조회구분",siteLocale)%></th>';			
	strBody = strBody + '   		<td class="td4">';
	strBody = strBody + '   			<select name="atch_disp_type">';
	strBody = strBody + '   				<option value="WRITE_TIME" selected><%=StringUtil.getLocaleWord("L.작성시점기준최신",siteLocale)%></option>';	
	strBody = strBody + '   				<option value="CURRENT_TIME"><%=StringUtil.getLocaleWord("L.현재시점기준최신",siteLocale)%></option>';
	strBody = strBody + '   			</select>';
	strBody = strBody + '   		</td>';
	strBody = strBody + '   	</tr>';
	strBody = strBody + '   	<tr>';
	strBody = strBody + '   		<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식명",siteLocale)%></th>';			
	strBody = strBody + '   		<td class="td4" colspan="3">';
	strBody = strBody + '   			<input type="text" name="atch_munseo_seosig_nam_ko" value="" class="text width_max" style="border:0px" readonly/>';
	strBody = strBody + '   			<input type="hidden" name="atch_def_doc_main_uid" value="">';
	strBody = strBody + '   		</td>';
	strBody = strBody + '   	</tr>';
	strBody = strBody + '   </table>';
	tCell1.innerHTML  = strBody ;	// 첫번째 TD 태그 안의 내용
}

function doDelAtchDoc(){
	var tRows  = atchDocTable.rows;
	var rCount = tRows.length;
	
	if ( rCount == 1 ){
		return;		// 헤더를 위한 Row 를 제외한다.
	}
	
	atchDocTable.deleteRow(rCount-1);
}

// function goDocumentPreview(frm){
<%-- 	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_DOC_MAS&<%=CommonConstants.MODE_CODE%>=WRITE_FORM&def_doc_main_uid=<%=def_doc_main_uid%>','view_test','width=1024,height=700,left=50,top=20,status=0,scrollbars=yes'); --%>
// }
// function goDocumentPreview2(frm){
<%-- 	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_DOC_MAS&<%=CommonConstants.MODE_CODE%>=WRITE_FORM&def_doc_main_uid=<%=def_doc_main_uid%>&isErrorIgnore=Y','view_test','width=1024,height=700,left=50,top=20,status=0,scrollbars=yes'); --%>
// }

// function doSearchAtchDoc(seq_no){
<%-- 	window.open('/ServletController?<%=CommonConstants.ACTION_CODE%>=SYS_DEF_DOC_MAIN&<%=CommonConstants.MODE_CODE%>=POPUP_MUNSEO_ONE_SELECT&from_atch_munseo_yn=Y&item_seq='+seq_no,'def_doc_main_popup_select','width=900,height=600,left=50,top=20,status=0,scrollbars=yes'); --%>
// }

function moveRow(id, act, obj)
{
	var idx = -1;	

	var o_tbl = document.getElementById(id);
	var o_btn = $(o_tbl).find("input[name=btn_move_" + act+"]");

	for (var i = 0; i < o_btn.length; i++)
	{
		if (o_btn[i] == obj)
		{
			switch (act)
			{
				case "up":
					if (i == 0) return;							

					o_tbl.insertBefore(o_tbl.rows[i], o_tbl.rows[i-1]);							
					break;

				case "down":
					if (i == o_btn.length-1) return;

					o_tbl.insertBefore(o_tbl.rows[i+1], o_tbl.rows[i]);
					break;
			}					
			break;
		}
	}
	reBuildFlowSeqNo();
}

/**
 * 삭제
 */
function deleteRow(id, obj)
{
	var idx = -1;	
    
	var o_tbl = document.getElementById(id);
	var o_btn = $(o_tbl).find("input[name=btnDelete]");
	
	if(o_btn.length != 0){
		for (var i = 0; i < o_btn.length; i++)
		{
			if (o_btn[i] == obj)
			{
				o_tbl.deleteRow(i);
				break;
			}
		}
	}
	
	reBuildFlowSeqNo();
}


</script>

<form name="form1" id="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode %>" />
	<input type="hidden" name=<%=CommonConstants.PAGE_NO%> value="<%=pageNo%>" />
	<input type="hidden" name="def_doc_main_uid" value="<%=defMainMap.getString("DEF_DOC_MAIN_UID")%>" />
	<input type="hidden" name="munseo_seosig_no" value="<%=defMainMap.getString("MUNSEO_SEOSIG_NO")%>" />

	
<%
if(defMainMap.size() > 0){
	String[] arrKeys = defMainMap.getKeyNames();

	for(int i=0; i < arrKeys.length ; i++){
		
		%>
<%-- 		<%=arrKeys[i] %> : <input type="text" name="<%=arrKeys[i] %>" value="<%=defMainMap.getString(arrKeys[i])%>"/><br/> --%>
		<%
		
	}
}

%>	

<table class="basic">
	<caption>기본정보</caption>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.문서서식번호",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2" colspan="3"><%=defMainMap.getString("MUNSEO_SEOSIG_NO")%></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.문서분류구분",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2" colspan="3">
				솔루션 <%=HtmlUtil.getSelect(request, true, "munseo_bunryu_gbn_sys_cod_id1", "munseo_bunryu_gbn_sys_cod_id1", sysMunseoBunryuGbnStr, defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID1"), "onChange=\"getMunseoBunryuGbnCode('munseo_bunryu_gbn_sys_cod_id2', this.value);\"") %>
				업무유형 <%=HtmlUtil.getSelect(request, true, "munseo_bunryu_gbn_sys_cod_id2", "munseo_bunryu_gbn_sys_cod_id2", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale), "", "onChange=\"getMunseoBunryuGbnCode('munseo_bunryu_gbn_sys_cod_id3', this.value);\"") %>
				단계 <%=HtmlUtil.getSelect(request, true, "munseo_bunryu_gbn_sys_cod_id3", "munseo_bunryu_gbn_sys_cod_id3", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale), "", "") %>
		</td>		
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식구분",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "munseo_seosig_gbn", "munseo_seosig_gbn", "|--선택--^SIN|신청^BO|보고^GEOM|검토^YO|요청^JI|지시^WAN|완료", defMainMap.getString("MUNSEO_SEOSIG_GBN"), "") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식사용유무",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getInputRadio(request, true, "sayong_yn", "Y|사용^N|미사용", defMainMap.getString("SAYONG_YN"), "", "")%>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.제목표시유무",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "gibon_tit_dsp_yn", "gibon_tit_dsp_yn", "|--선택--^Y|표시^N|미표시", defMainMap.getString("GIBON_TIT_DSP_YN"), "") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.내용표시유무",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "gibon_memo_dsp_yn", "gibon_memo_dsp_yn", "|--선택--^Y|표시^N|미표시", defMainMap.getString("GIBON_MEMO_DSP_YN"), "") %>
			<input type="text" class="text" name="GIBON_MEMO_DSP_LABEL" value="<%=defMainMap.getString("GIBON_MEMO_DSP_LABEL")%>"/>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일표시유무",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, true, "gibon_file_dsp_yn", "gibon_file_dsp_yn", "|--선택--^Y|표시^N|미표시", defMainMap.getString("GIBON_FILE_DSP_YN"), "") %>
		</td>
		
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서종료후_수정가능",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "munseo_end_edit_yn", "munseo_end_edit_yn", "|--선택--^Y|가능^N|불가", defMainMap.getString("MUNSEO_END_EDIT_YN"), "") %>
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서생성구분",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "munseo_create_gbn", "munseo_create_gbn", "|--선택--^HEAD|시작문서^TAIL|파생문서", defMainMap.getString("MUNSEO_CREATE_GBN"), "") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.수신시_수신확인가능유무",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, true, "su_ok_able_yn", "su_ok_able_yn", "|--선택--^Y|가능^N|불가", defMainMap.getString("SU_OK_ABLE_YN"), "") %>
			※다음진행가능 문서가 있을 때, 진행하지않고 수신확인으로 문서 종결처리가능한지의 여부
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서폐기가능",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "pyegi_able_yn", "pyegi_able_yn", "|--선택--^Y|가능^N|불가", defMainMap.getString("PYEGI_ABLE_YN"), "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서삭제가능",siteLocale)%></th>						
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "doc_sagje_able_yn", "doc_sagje_able_yn", "|--선택--^Y|가능^N|불가", defMainMap.getString("DOC_SAGJE_ABLE_YN"), "") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서물리적삭제가능",siteLocale)%></th>						
		<td class="td4" >
			<%=HtmlUtil.getSelect(request, true, "doc_real_sagje_able_yn", "doc_real_sagje_able_yn", "|--선택--^Y|가능^N|불가", defMainMap.getString("DOC_REAL_SAGJE_ABLE_YN"), "") %>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.임시저장가능여부",siteLocale)%></th>					
		<td class="td4" >
			<%=HtmlUtil.getSelect(request, true, "imsi_save_yn", "imsi_save_yn", "|--선택--^Y|가능^N|불가", defMainMap.getString("IMSI_SAVE_YN"), "") %>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.상태관련문서여부",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, true, "sangtae_munseo_yn", "sangtae_munseo_yn", "|--선택--^Y|관련^N|미관련", defMainMap.getString("SANGTAE_MUNSEO_YN"), "") %>
			※업무단에서 최종진행상태(최종으로 진행한 문서)를 구해야 할 경우, 상태관련 문서여부가 Y인건만 구할수 있도록 하기 위한 구분값    
		</td>
	</tr>
	<%-- 
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.참조수신전달사용여부",siteLocale)%></th>					
		<td class="td4" colspan="3">
			<%=HtmlUtil.getSelect(request, true, "doc_refer_yn", "doc_refer_yn", "|--선택--^Y|유^N|무", doc_refer_yn, "") %>
			※사용여부가 '유' 이더라도, 본 문서의 Flow에 결재가 없으면 해당기능이 활성화 되지 않습니다.
			LGD 협의 시 결재가 있는 문서만 참조/수신, 전달 기능을 사용하기로 하였음, 추후 다른 프로젝트에서는 변경필요			 			    
		</td>
	</tr>
	 --%>
	<tr>				
		<th>Rev 문서 생성여부</th>						
		<td colspan="3">
			<%=HtmlUtil.getSelect(request, true, "rev_munseo_create_yn", "rev_munseo_create_yn", "|--선택--^Y|유^N|무", defMainMap.getString("REV_MUNSEO_CREATE_YN"), "") %>
		</td>
	</tr>
	
	
	
	 <tr>				
		<th class="th4">작성시 데이터 참조문서<br/>(문서 서식번호 콤마(,)로 입력)</th>						
		<td class="td4" colspan="3">
			<input type="text" class="text width_max" name="data_rel_munseo_seosig_no" value="<%=defMainMap.getString("DATA_REL_MUNSEO_SEOSIG_NO")%>"/><br/>
                                        ※문서 서식번호 입력시 <span style="font-weight: bold;">본 문서 작성 시(수정제외) 입력된 문서의 데이터를 참조</span>하여 체워준다.(파티클 데이터를 json String 형태로 저장시 사용)
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서설명",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<textarea class="memo width_max" name="munseo_desc" id="munseo_desc" onblur="airCommon.validateMaxLength(this, 2000)"><%=StringUtil.convertFor(defMainMap.getString("MUNSEO_DESC"), "INPUT")%></textarea>
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서생성권한",siteLocale)%></th>						
		<td class="td4" colspan="3">
			<%=HtmlUtil.getInputCheckbox(request,  true, "munseo_saengseong_auth", userAuthCodestr, defMainMap.getString("MUNSEO_SAENGSEONG_AUTH"), "", "") %>		
		</td>
	</tr>
	<tr>				
		<th class="th4"><%=StringUtil.getLocaleWord("L.문서조회권한",siteLocale)%></th>
		<td class="td4" colspan="3">
			<%=HtmlUtil.getInputCheckbox(request,  true, "doc_johoe_auth_codes", userAuthCodestr, defMainMap.getString("DOC_JOHOE_AUTH_CODES"), "", "") %>	
		</td>
	</tr>
</table>
<br>
<br>
<br>
<table class="basic">
	<caption>구성정보</caption>	
</table>

<table class="basic" >
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.문서서식명_한글",siteLocale)%></th>
		<td class="td2" align="left"> <input type="text" name="seosig_nam" value="<%=StringUtil.convertForInput(defMainMap.getString("SEOSIG_NAM")) %>" style="width:70%" class="text"/></td>		
	</tr>
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.다국어코드",siteLocale)%></th>
		<td class="td2" align="left"><input type="text" name="lang_code" value="<%=StringUtil.convertForInput(defMainMap.getString("LANG_CODE")) %>" style="width:70%" class="text"/></td>		
	</tr>
</table>
<p>

<%-- 
<table class="basic">
	<tr>				
		<th class="th2"><%=StringUtil.getLocaleWord("L.자동첨부문서설정유무",siteLocale)%></th>						
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, true, "atch_doc_yn", "Y|설정^N|미설정", atch_doc_yn, "onClick=\"chgAtchDocAbleYn(this.value);\"", "")%>
			<span id="span_btn_atch_doc" style="display:<%if("Y".equals(pati_sangdan_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
				<input type="button" name="btn_atch_doc_add" value="추가" onClick="doAddAtchDoc()"><input type="button" name="btn_atch_doc_del" value="삭제" onClick="doDelAtchDoc()">
			</span>
		</td>
	</tr>
</table>
<table id="atchDocTable" class="basic" style="display:<%if("Y".equals(pati_sangdan_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<%if(defDocAtchDoc != null && defDocAtchDoc.getRowCount() > 0){%>
	<%for(int i=0; i<defDocAtchDoc.getRowCount(); i++){%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식번호",siteLocale)%></th>			
					<td class="td4">
						<input type="text" name="atch_munseo_seosig_no" value="<%=defDocAtchDoc.getString(i,"atch_munseo_seosig_no")%>" style="width:80%;border:0px" readonly/>
						<input type="button" name="btn_search_atch_doc" value="검색" onClick="doSearchAtchDoc('<%=i%>')">
					</td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.작성후첨부문서조회구분",siteLocale)%></th>			
					<td class="td4">
						<select name="atch_disp_type">
							<option value="WRITE_TIME"   <%if("WRITE_TIME".equals(defDocAtchDoc.getString(i,"atch_disp_type"))){%>selected<%}%>><%=StringUtil.getLocaleWord("L.작성시점기준최신",siteLocale)%></option>	
							<option value="CURRENT_TIME" <%if("CURRENT_TIME".equals(defDocAtchDoc.getString(i,"atch_disp_type"))){%>selected<%}%>><%=StringUtil.getLocaleWord("L.현재시점기준최신",siteLocale)%></option>
						</select>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="atch_munseo_seosig_nam_ko" value="<%=defDocAtchDoc.getString(i,"atch_munseo_seosig_nam_ko")%>" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="atch_def_doc_main_uid" value="<%=defDocAtchDoc.getString(i,"atch_def_doc_main_uid")%>">
					</td>
				</tr>
			</table>	
		</td>
	</tr>
	<%}%>
<%}else{%>
	<tr>
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식번호",siteLocale)%></th>			
					<td class="td4">
						<input type="text" name="atch_munseo_seosig_no" value="" style="width:80%;border:0px" readonly/>
						<input type="button" name="btn_search_atch_doc" value="검색" onClick="doSearchAtchDoc('0')">
					</td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.작성후첨부문서조회구분",siteLocale)%></th>			
					<td class="td4">
						<select name="atch_disp_type">
							<option value="WRITE_TIME" selected><%=StringUtil.getLocaleWord("L.작성시점기준최신",siteLocale)%></option>	
							<option value="CURRENT_TIME"><%=StringUtil.getLocaleWord("L.현재시점기준최신",siteLocale)%></option>
						</select>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.문서서식명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="atch_munseo_seosig_nam_ko" value="" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="atch_def_doc_main_uid" value="">
					</td>
				</tr>
			</table>	
		</td>
	</tr>
<%}%>
</table>
<p>
--%>

<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.상단파티클_존재유무",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<input type="text" class="text" name="sang_pati_sch" id="sang_pati_sch" placeholder="파티클 번호 및 파티클  명칭 검색" />
			<span id="span_particle_btn_sangdan" style="display:<%if("Y".equals(defMainMap.getString("PATI_SANGDAN_JONJAE_YN"))){%>visible<%}else{%>none<%}%>;">
				<input type="button" name="btn_add_particle_sangdan" value="파티클 추가" onClick="doAddParticleSangdan()">
				<input type="button" name="btn_del_particle_sangdan" value="파티클 삭제" onClick="doDelParticleSangdan()">
			</span>
		</td>		
	</tr>	
</table>

<table id="particleSangdanTable" class="basic">
	<tbody id="particleSangdanTable_body">
<%if(defDocPatiSangdanList != null && defDocPatiSangdanList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiSangdanList.getRowCount(); i++){%>
	<tr data-meaning="sangdan_tr">
		<td>
			<table class="basic">
				<tbody>
				<tr>
					<th class="th4">
						파티클 관리번호
					</th>
					<td class="td4"><input type="text" name="pati_gwanri_no_sangdan" value="<%=defDocPatiSangdanList.getString(i, "pati_gwanri_no") %>" style="width:80%;border:0px" readonly /></td>
					<th class="th4">파티클 구분</th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_sangdan" value="<%=defDocPatiSangdanList.getString(i, "PATI_GBN_NAM1") %>/<%=defDocPatiSangdanList.getString(i, "PATI_GBN_NAM2") %>" class="text width_max" style="border:0px" readonly="readonly"> </td>
					<td rowspan="4">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particleSangdanTable_body', 'up', this);">
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particleSangdanTable_body', 'down', this);"><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particleSangdanTable_body', this);">
					</td>
				</tr>
				<tr>
					<th class="th4">파티클 명</th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_sangdan" value="<%=defDocPatiSangdanList.getString(i, "PATI_NAM") %>" class="text width_max" style="border:0px" readonly />
						<input type="hidden" name="mng_pati_uid_sangdan" value="<%=defDocPatiSangdanList.getString(i, "MNG_PATI_UID") %>" />
					</td>
				</tr>
				
				<tr>
					<th class="th4">VIEW 전용 파티클설정</th>
					<td class="td4" colspan="3">
						<input type="hidden" name="pati_view_only_sangdan" value="<%=StringUtil.convertNullDefault(defDocPatiSangdanList.getString(i, "PATI_VIEW_ONLY"), "N" )%>" />
						<select name="pati_view_only_pyosi_sijeom_sangdan" <%if(!"Y".equals(defDocPatiSangdanList.getString(i, "PATI_VIEW_ONLY"))){ %>disabled<%} %>>
							<option value="" selected>--선택--</option>
							<option value="WRITE">작성모드</option>
							<option value="VIEW">뷰모드</option>
							<option value="ALL">작성모드+뷰모드</option>
						</select>
					</td>
				</tr>
				
				<tr>
					<th class="th4">권한선택</th>
					<td class="td4" colspan="3" data-meaning="sangdan_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_sangdan_auth_codes_temp", userAuthCodestr, defDocPatiSangdanList.getString(i, "PATI_JOHOE_AUTH_CODES") , "", "") %>
						<input type="hidden" name="sangdan_pati_johoe_auth_codes" value="<%=defDocPatiSangdanList.getString(i, "PATI_JOHOE_AUTH_CODES")%>"/>
					</td>
				</tr>				
				</tbody>
			</table>
		</td>
	</tr>
	<%}%>
<%}%>
	</tbody>
</table>
<%-- 
<table class="basic">
	<tr id="tr_gibon_tit" style="display:<%if("Y".equals(gibon_tit_dsp_yn)){%>visible<%}else{%>none<%}%>;">
		<th class="th2"><%=StringUtil.getLocaleWord("L.기본제목",siteLocale)%></td> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2"><input type="text" name="gibon_tit" value="<%=StringUtil.convertForInput(gibon_tit) %>" class="text width_max"/></td>		
	</tr>
	<tr id="tr_gibon_memo" style="display:<%if("Y".equals(gibon_memo_dsp_yn)){%>visible<%}else{%>none<%}%>;">
		<th class="th2"><%=StringUtil.getLocaleWord("L.기본내용",siteLocale)%></th>
		<td class="td2"><%=HtmlUtil.getHtmlEditor(request,true, "gibon_memo", "gibon_memo", StringUtil.convertFor(gibon_memo,"EDITOR"), "", "100%", "350", "Default")%></td>	
	</tr>
	<tr id="tr_gibon_file" style="display:<%if("Y".equals(gibon_file_dsp_yn)){%>visible<%}else{%>none<%}%>;">
		<th class="th2">첨부</th>
		<td class="td2"><font color="#AAAAAA">첨부파일 영역</font></td>	
	</tr>
</table>


<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.하단파티클_존재유무",siteLocale)%></td> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, true, "pati_hadan_jonjae_yn", "Y|있음^N|없음", pati_hadan_jonjae_yn, "onClick=\"chgPatiHadanJonjaeYn(this.value);\"", "")%>
			<span id="span_particle_btn_hadan" style="display:<%if("Y".equals(pati_hadan_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
				<input type="button" name="btn_add_particle_hadan" value="파티클 추가" onClick="doAddParticleHadan()"><input type="button" name="btn_del_particle_hadan" value="파티클 삭제" onClick="doDelParticleHadan()">
			</span>
		</td>		
	</tr>	
</table>

<table id="particleHadanTable" class="basic" style="display:<%if("Y".equals(pati_hadan_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
	<tbody id="particlehadanTable_body">
<%if(defDocPatiHadanList != null && defDocPatiHadanList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiHadanList.getRowCount(); i++){%>
	<tr data-meaning="hadan_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4">
						<%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%>
						<input type="hidden" name='pati_hadan_idx' value="<%=i%>">
					</th>
					<td class="td4"><input type="text" name="pati_gwanri_no_hadan" value="<%=StringUtil.convertForInput(defDocPatiHadanList.getString(i, "pati_gwanri_no")) %>" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_hadan_particle" value="검색" onClick="doSearchParticle('hadan',getPaticleIndex('btn_search_hadan_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_hadan" value="<%=(StringUtil.convertForInput(defDocPatiHadanList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiHadanList.getString(i, "pati_gbn_nam2")))%>" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlehadanTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlehadanTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlehadanTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_hadan" value="<%=StringUtil.convertForInput(defDocPatiHadanList.getString(i, "pati_nam")) %>" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_hadan" value="<%=StringUtil.convertForInput(defDocPatiHadanList.getString(i, "mng_pati_uid")) %>">
					</td>
				</tr>
				<tr>
		       		<th class="th4"><%=StringUtil.getLocaleWord("L.VIEW_전용_파티클설정",siteLocale)%></th>
		       		<td class="td4" colspan="3">
						<input type="hidden" name="pati_view_only_hadan" value="<%=defDocPatiHadanList.getString(i, "pati_view_only")%>">
		       			<select name="pati_view_only_pyosi_sijeom_hadan" <%if(!"Y".equals(defDocPatiHadanList.getString(i, "pati_view_only"))){%>disabled<%}%>>
							<option value=""      <%if("".equals(defDocPatiHadanList.getString(i, "pati_view_only_pyosi_sijeom"))){%>selected<%}%>>--선택--</option>
							<option value="WRITE" <%if("WRITE".equals(defDocPatiHadanList.getString(i, "pati_view_only_pyosi_sijeom"))){%>selected<%}%>>작성모드</option>
							<option value="VIEW"  <%if("VIEW".equals(defDocPatiHadanList.getString(i, "pati_view_only_pyosi_sijeom"))){%>selected<%}%>>뷰모드</option>
							<option value="ALL"   <%if("ALL".equals(defDocPatiHadanList.getString(i, "pati_view_only_pyosi_sijeom"))){%>selected<%}%>>작성모드+뷰모드</option>
						</select>
		       		</td>
		       	</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>
					<td class="td4" colspan="3" data-meaning="hadan_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_hadan_auth_codes_temp", userAuthCodestr, defDocPatiHadanList.getString(i, "pati_johoe_auth_codes"), "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}else{%>
	<tr data-meaning="hadan_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gwanri_no_hadan" value="" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_hadan_particle" value="검색" onClick="doSearchParticle('hadan',getPaticleIndex('btn_search_hadan_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_hadan" value="" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlehadanTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlehadanTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlehadanTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_hadan" value="" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_hadan" value="">
					</td>
				</tr>
				<tr>
		       		<th class="th4"><%=StringUtil.getLocaleWord("L.VIEW_전용_파티클설정",siteLocale)%></th>
		       		<td class="td4" colspan="3">
						<input type="hidden" name="pati_view_only_hadan" value="">
		       			<select name="pati_view_only_pyosi_sijeom_hadan" disabled>
							<option value="">--선택--</option>
							<option value="WRITE">작성모드</option>
							<option value="VIEW">뷰모드</option>
							<option value="ALL">작성모드+뷰모드</option>
						</select>
		       		</td>
		       	</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>			
					<td class="td4" colspan="3" data-meaning="hadan_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_hadan_auth_codes_temp", userAuthCodestr, paticleInitData, "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>
<%}%>
	</tbody>
</table>
<p>

<table class="basic">
	<tr>
		<th class="th2"><%=StringUtil.getLocaleWord("L.검토파티클_존재유무",siteLocale)%></td> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, true, "pati_geom_jonjae_yn", "Y|있음^N|없음", pati_geom_jonjae_yn, "onClick=\"chgPatiGeomJonjaeYn(this.value);\"", "")%>
			<span id="span_particle_btn_geom" style="display:<%if("Y".equals(pati_geom_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
				<input type="button" name="btn_add_particle_geom" value="파티클 추가" onClick="doAddParticleGeom()"><input type="button" name="btn_del_particle_geom" value="파티클 삭제" onClick="doDelParticleGeom()">
			</span>
		</td>		
	</tr>	
</table>
<table id="particleGeomTable" class="basic" style="display:<%if("Y".equals(pati_geom_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
	<tbody id="particlegeomTable_body">
<%if(defDocPatiGeomList != null && defDocPatiGeomList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiGeomList.getRowCount(); i++){%>
	<tr data-meaning="geom_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4">
						<%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%>
						<input type="hidden" name='pati_geom_idx' value="<%=i%>">
					</th>
					<td class="td4"><input type="text" name="pati_gwanri_no_geom" value="<%=StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_gwanri_no")) %>" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_geom_particle" value="검색" onClick="doSearchParticle('geom',getPaticleIndex('btn_search_geom_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_geom" value="<%=(StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_gbn_nam2")))%>" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlegeomTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlegeomTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlegeomTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_geom" value="<%=StringUtil.convertForInput(defDocPatiGeomList.getString(i, "pati_nam")) %>" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_geom" value="<%=StringUtil.convertForInput(defDocPatiGeomList.getString(i, "mng_pati_uid")) %>">
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>
					<td class="td4" colspan="3" data-meaning="geom_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_geom_auth_codes_temp", userAuthCodestr, defDocPatiGeomList.getString(i, "pati_johoe_auth_codes"), "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>	
	<%}%>
<%}else{%>
	<tr data-meaning="geom_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gwanri_no_geom" value="" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_geom_particle" value="검색" onClick="doSearchParticle('geom',getPaticleIndex('btn_search_geom_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_geom" value="" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlegeomTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlegeomTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlegeomTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_geom" value="" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_geom" value="">
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>			
					<td class="td4" colspan="3" data-meaning="geom_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_geom_auth_codes_temp", userAuthCodestr, paticleInitData, "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>
<%} %>
</tbody>
</table>

<p>

<table class="basic">
	<tr>	
		<th class="th2"><%=StringUtil.getLocaleWord("L.결재파티클_존재유무",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, true, "pati_gyeol_jonjae_yn", "Y|있음^N|없음", pati_gyeol_jonjae_yn, "onClick=\"chgPatiGyeolJonjaeYn(this.value);\"", "")%>
			<span id="span_particle_btn_gyeol" style="display:<%if("Y".equals(pati_gyeol_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
				<input type="button" name="btn_add_particle_gyeol" value="파티클 추가" onClick="doAddParticleGyeol()"><input type="button" name="btn_del_particle_gyeol" value="파티클 삭제" onClick="doDelParticleGyeol()">
			</span>
		</td>		
	</tr>	
</table>
<table id="particleGyeolTable" class="basic" style="display:<%if("Y".equals(pati_gyeol_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<tbody id="particlegyeolTable_body">
<%if(defDocPatiGyeolList != null && defDocPatiGyeolList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiGyeolList.getRowCount(); i++){%>
	<tr data-meaning="gyeol_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4">
						<%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%>
						<input type="hidden" name='pati_gyeol_idx' value="<%=i%>">
					</th>
					<td class="td4"><input type="text" name="pati_gwanri_no_gyeol" value="<%=StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_gwanri_no")) %>" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_gyeol_particle" value="검색" onClick="doSearchParticle('gyeol',getPaticleIndex('btn_search_gyeol_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_gyeol" value="<%=(StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_gbn_nam2")))%>" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlegyeolTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlegyeolTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlegyeolTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_gyeol" value="<%=StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "pati_nam")) %>" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_gyeol" value="<%=StringUtil.convertForInput(defDocPatiGyeolList.getString(i, "mng_pati_uid")) %>">
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>
					<td class="td4" colspan="3" data-meaning="gyeol_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_gyeol_auth_codes_temp", userAuthCodestr, defDocPatiGyeolList.getString(i, "pati_johoe_auth_codes"), "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>
	<%}%>
<%}else{%>
	<tr data-meaning="gyeol_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gwanri_no_gyeol" value="" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_gyeol_particle" value="검색" onClick="doSearchParticle('gyeol',getPaticleIndex('btn_search_gyeol_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_gyeol" value="" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlegyeolTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlegyeolTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlegyeolTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_gyeol" value="" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_gyeol" value="">
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>			
					<td class="td4" colspan="3" data-meaning="gyeol_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_gyeol_auth_codes_temp", userAuthCodestr, paticleInitData, "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>
<%} %>
	</tbody>
</table>

<p>

<table class="basic">
	<tr>	
		<th class="th2"><%=StringUtil.getLocaleWord("L.수신파티클_존재유무",siteLocale)%></th> <!-- onblur="airCommon.validateNumber(this, this.value)" -->
		<td class="td2">
			<%=HtmlUtil.getInputRadio(request, true, "pati_su_jonjae_yn", "Y|있음^N|없음", pati_su_jonjae_yn, "onClick=\"chgPatiSuJonjaeYn(this.value);\"", "")%>
			<span id="span_particle_btn_su" style="display:<%if("Y".equals(pati_su_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
				<input type="button" name="btn_add_particle_su" value="파티클 추가" onClick="doAddParticleSu()"><input type="button" name="btn_del_particle_su" value="파티클 삭제" onClick="doDelParticleSu()">
			</span>
		</td>		
	</tr>	
</table>
<table id="particleSuTable" class="basic" style="display:<%if("Y".equals(pati_su_jonjae_yn)){%>visible<%}else{%>none<%}%>;">
<tbody id="particlesuTable_body">
<%if(defDocPatiSuList != null && defDocPatiSuList.getRowCount() > 0){ %>
	<%for(int i=0; i<defDocPatiSuList.getRowCount(); i++){%>
	<tr data-meaning="su_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4">
						<%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%>
						<input type="hidden" name='pati_su_idx' value="<%=i%>">
					</th>
					<td class="td4"><input type="text" name="pati_gwanri_no_su" value="<%=StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_gwanri_no")) %>" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_su_particle" value="검색" onClick="doSearchParticle('su',getPaticleIndex('btn_search_su_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_su" value="<%=(StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_gbn_nam1"))+" / "+StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_gbn_nam2")))%>" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlesuTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlesuTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlesuTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_su" value="<%=StringUtil.convertForInput(defDocPatiSuList.getString(i, "pati_nam")) %>" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_su" value="<%=StringUtil.convertForInput(defDocPatiSuList.getString(i, "mng_pati_uid")) %>">
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>
					<td class="td4" colspan="3" data-meaning="su_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_su_auth_codes_temp", userAuthCodestr, defDocPatiSuList.getString(i, "pati_johoe_auth_codes"), "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>
	<%}%>
<%}else{%>
	<tr data-meaning="su_tr">
		<td>
			<table class="basic">
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_관리번호",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gwanri_no_su" value="" style="width:80%;border:0px" readonly/> <input type="button" name="btn_search_su_particle" value="검색" onClick="doSearchParticle('su',getPaticleIndex('btn_search_su_particle',this))"></td>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_구분",siteLocale)%></th>			
					<td class="td4"><input type="text" name="pati_gbn_nam_su" value="" class="text width_max" style="border:0px" readonly/> </td>
					<td rowspan="3">	
						<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particlesuTable_body', 'up', this);" />
						<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particlesuTable_body', 'down', this);"/><br>
						<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particlesuTable_body', this);"/>
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.파티클_명",siteLocale)%></th>			
					<td class="td4" colspan="3">
						<input type="text" name="pati_nam_su" value="" class="text width_max" style="border:0px" readonly/>
						<input type="hidden" name="mng_pati_uid_su" value="">
					</td>
				</tr>
				<tr>
					<th class="th4"><%=StringUtil.getLocaleWord("L.권한선택",siteLocale)%></th>			
					<td class="td4" colspan="3" data-meaning="su_auth_codes">
						<%=HtmlUtil.getInputCheckbox(request,  true, "pati_su_auth_codes_temp", userAuthCodestr, paticleInitData, "", "") %>
					</td>
				</tr>
			</table>						
		</td>
	</tr>
<%} %>
</tbody>
</table>

<p>

<div class="buttonlist">
	<div class="right">
<%
if("UPDATE_FORM".equals(modeCode)||"UPDATE_FORM_POPUP".equals(modeCode)){
%>	
		<input type="button" name="btnPreview" value="에러무시하고 <%=StringUtil.getLocaleWord("B.미리보기",siteLocale)%>" class="btn140" onclick="goDocumentPreview2(this.form)" />
		<input type="button" name="btnPreview" value="<%=StringUtil.getLocaleWord("B.미리보기",siteLocale)%>" class="btn70" onclick="goDocumentPreview(this.form)" />
<%
}
%>		
		<input type="button" name="btnSave" value="<%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%>" class="btn70" onclick="doSubmit(this.form)" />		
		<input type="button" name="btnList" value="<%=StringUtil.getLocaleWord("B.LIST",siteLocale)%>" class="btn70" onclick="goList(this.form)" />
	</div>
</div>  
 --%>
 <div class="buttonlist">
	<div class="right">
<%
if("UPDATE_FORM".equals(modeCode)||"UPDATE_FORM_POPUP".equals(modeCode)){
%>	
		<input type="button" name="btnPreview" value="에러무시하고 <%=StringUtil.getLocaleWord("B.미리보기",siteLocale)%>" class="btn140" onclick="goDocumentPreview2(this.form)" />
		<input type="button" name="btnPreview" value="<%=StringUtil.getLocaleWord("B.미리보기",siteLocale)%>" class="btn70" onclick="goDocumentPreview(this.form)" />
<%
}
%>		
		<input type="button" name="btnSave" value="<%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%>" class="btn70" onclick="doSubmit(document.form1)" />		
		<input type="button" name="btnList" value="<%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%>" class="btn70" onclick="window.close();" />
	</div>
</div> 
</form>
<script id="sang_patiTemp" type="text/html">
<tr data-meaning="sangdan_tr">
	<td>
		<table class="basic">
			<tbody>
			<tr>
				<th class="th4">
					파티클 관리번호
				</th>
				<td class="td4"><input type="text" name="pati_gwanri_no_sangdan" value="\${PATI_GWANRI_NO}" style="width:80%;border:0px" readonly=""></td>
				<th class="th4">파티클 구분</th>			
				<td class="td4"><input type="text" name="pati_gbn_nam_sangdan" value="\${PATI_GBN_NAM1}/\${PATI_GBN_NAM2}" class="text width_max" style="border:0px" readonly=""> </td>
				<td rowspan="4">	
					<input type="button" name="btn_move_up" value="▲" title="위로 이동" class="btn70" onclick="moveRow('particleSangdanTable_body', 'up', this);">
					<input type="button" name="btn_move_down" value="▼" title="아래로 이동" class="btn70" onclick="moveRow('particleSangdanTable_body', 'down', this);"><br>
					<input type="button" name="btnDelete" value="삭제" class="btn70" onclick="deleteRow('particleSangdanTable_body', this);">
				</td>
			</tr>
			<tr>
				<th class="th4">파티클 명</th>			
				<td class="td4" colspan="3">
					<input type="text" name="pati_nam_sangdan" value="\${PATI_NAM}" class="text width_max" style="border:0px" readonly="">
					<input type="hidden" name="mng_pati_uid_sangdan" value="\${MNG_PATI_UID}">
				</td>
			</tr>
			
			<tr>
				<th class="th4">VIEW 전용 파티클설정</th>
				<td class="td4" colspan="3">
					<input type="hidden" name="pati_view_only_sangdan" value="\${PATI_VIEW_ONLY==""?"N":PATI_VIEW_ONLY}">
					<select name="pati_view_only_pyosi_sijeom_sangdan" {{if PATI_VIEW_ONLY != "Y"}} disabled=""{{/if}}>
						<option value="" selected="">--선택--</option>
						<option value="WRITE">작성모드</option>
						<option value="VIEW">뷰모드</option>
						<option value="ALL">작성모드+뷰모드</option>
					</select>
				</td>
			</tr>
			
			<tr>
				<th class="th4">권한선택</th>
				<td class="td4" colspan="3" data-meaning="sangdan_auth_codes">
					<%=HtmlUtil.getInputCheckbox(request,  true, "pati_sangdan_auth_codes_temp", userAuthCodestr, paticleInitData, "", "") %>
					<input type="hidden" name="sangdan_pati_johoe_auth_codes" value="<%=paticleInitData%>"/>
				</td>
			</tr>				
			</tbody>
		</table>
	</td>
</tr>
</script>
<script>
$(function(){
// 	iljaViewChange();
	$("#sang_pati_sch").autocomplete({
		minLength:2,
		matchContains: false,
		source:function(request, response){
			var data = {"SCHWORD":$("#sang_pati_sch").val()};
			airCommon.callAjax("SYS_MNG_PATI", "JSON_LIST",data, function(json){
				 response( jQuery.map( json.rows, function( item ) {
		              return {
		                //id: item.id,
		            	   value: "",
			                label: "["+item.PATI_GWANRI_NO+"]"+item.PATI_NAM,
			                data: item
		              }
		          }));
				
			});
			
		},select:function(e,u){
			$("#sang_patiTemp").tmpl(u.item.data).appendTo($("#particleSangdanTable_body"));
			
		}
	});
	
	<%if(StringUtil.isNotBlank(defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID1"))){%>
		getMunseoBunryuGbnCode('munseo_bunryu_gbn_sys_cod_id2', '<%=defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID1")%>');
	<%}%>
	
	if("<%=defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID2")%>" != ""){
		var obj = document.getElementById("munseo_bunryu_gbn_sys_cod_id2");
		var index = 0;
		for(var i=0; i<obj.length; i++){
			if(obj[i].value == "<%=defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID2")%>"){
				index = i;
			}
		}
		
		obj.selectedIndex = index;
	}
	
	<%if(StringUtil.isNotBlank(defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID2"))){%>
	getMunseoBunryuGbnCode('munseo_bunryu_gbn_sys_cod_id3', '<%=defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID2")%>');
	<%}%>
	
	if("<%=defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID3")%>" != ""){
		var obj = document.getElementById("munseo_bunryu_gbn_sys_cod_id3");
		var index = 0;
		for(var i=0; i<obj.length; i++){
			if(obj[i].value == "<%=defMainMap.getString("MUNSEO_BUNRYU_GBN_SYS_COD_ID3")%>"){
				index = i;
			}
		}
		
		obj.selectedIndex = index;
	}
});
</script>