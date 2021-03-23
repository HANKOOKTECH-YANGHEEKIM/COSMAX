<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="java.sql.Array"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	String mng_pati_uid         = request.getParameter("AIR_PARTICLE");
	String doc_mas_mode_code	= request.getParameter("doc_mas_mode_code");
	String doc_mas_uid			= request.getParameter("doc_mas_uid");
	String new_doc_mas_uid		= request.getParameter("new_doc_mas_uid");
	String munseo_seosig_no		= request.getParameter("munseo_seosig_no");
	String sol_mas_uid			= StringUtil.convertNull(request.getParameter("sol_mas_uid"));
	
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults LMSIJ001			= resultMap.getResult("LMSIJ001");
	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	SQLResults GY_MAS			= resultMap.getResult("GY_MAS");
	
	BeanResultMap gyMas			= new BeanResultMap();
	if(GY_MAS !=null && GY_MAS.getRowCount() > 0){
		gyMas.putAll(GY_MAS.getRowResult(0));
	}
	
	String gy_seoryu_type_cod 	= "";
	if(StringUtil.isNotBlank(gyMas.getString("SOL_MAS_UID"))){
		gy_seoryu_type_cod = "IJ_SEORYU_01";
	}
	
	/* Code Start	
	String sampleField = "";	
	*/
	String lms_pati_ij_001_uid 			= jsonMap.getString("LMS_PATI_IJ_001_UID");
	
	if("".equals(lms_pati_ij_001_uid)){
		lms_pati_ij_001_uid = StringUtil.getRandomUUID();
	}
	
	String new_lms_pati_ij_001_uid   = StringUtil.getRandomUUID();
	//-- 시스템 코드에서 값 가저오기
	String PAPER_YH_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("PAPER_YH_CODE_LIST"), "CODE_ID,LANG_CODE", ""));
	String IJ_RECEIVE_CODESTR = StringUtil.convertForInput(StringUtil.getCodestrFromSQLResults(resultMap.getResult("IJ_RECEIVE_CODE"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)));

	String att_master_doc_id 			= doc_mas_uid;
	String att_default_master_doc_Ids 	= jsonMap.getString("DOC_MAS_UID");
%>
<script type="text/javascript">
    <%//Particle Data Field Check%>
    var frm = document.saveForm<%=sol_mas_uid%>;
    
    function <%="Parti"+mng_pati_uid%>_tmpDataCheck(){
    	/* 
    	var txt = $(".combo").find("input:text");
    	$("#lms_pati_hoesa_nam").val(txt.val());
    	 */
    }
    
	function <%="Parti"+mng_pati_uid%>_dataCheck(){
		
		var injang_type_cod = $("#lms_pati_injang_type_cod option:selected").val();
		if (frm.lms_pati_injang_tit.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.서류제목", siteLocale))%>");
			frm.lms_pati_injang_tit.focus();
		    return false;
		}
		var bool = true;
		if ($("input:checkbox[name='lms_pati_seoryu_type_cod']:checked").length == 0 ) {
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getLocaleWord("L.서류유형", siteLocale))%>");
			$("input:checkbox[name='lms_pati_seoryu_type_cod']").eq(0).focus();
		    return false;
		}else{
			/* 
			$("input:checkbox[name='lms_pati_seoryu_type_cod']:checked").each(function(i, o){
				if("IJ_SEORYU_01" == $(o).val()){
					if("" == $("#lms_pati_org_gy_uid").val()){
						alert("계약체결품의건은 필수 선택 사항 입니다.");
						bool = false;
					}
				}
				if("IJ_SEORYU_09" == $(o).val()){
					if("" == $("#lms_pati_seoryu_type_nam").val()){
						alert("서유형의 기타 선택 시 입력은 필수 입력 사항 입니다.");
						bool = false;
					}
				}
				
			});
			 */
		}
		if(!bool){
			return bool;
		}
		if($("#lms_pati_jechulcheo").val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.제출처", siteLocale))%>");
			$("#lms_pati_jechulcheo").focus();
			return false;
		}
		//날인수 확인
		if($("#lms_pati_nalinsu").val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getScriptMessage("L.날인수", siteLocale))%>");
			$("#lms_pati_nalinsu").focus();
		    return false;
		}
		if($("#lms_pati_seoryu_rec_cod").val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.서류수령방법", siteLocale))%>");
			$("#lms_pati_seoryu_rec_cod").focus();
			return false;
		}else{
			
			if($("#lms_pati_seoryu_rec_cod").val() == "IJ_RECEIVE_CODE_02"){
				if($("#lms_pati_rec_com_name").val() == ""){
					alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"사옥명")%>");
					bool = false;
				}
				
			}else if($("#lms_pati_seoryu_rec_cod").val() == "IJ_RECEIVE_CODE_03"){
				if($("#lms_pati_rec_addr").val() == ""){
					alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"주소")%>");
					bool = false;
				}
			}
			
		}
		
		if(!bool){
			return bool;
		}
		<%-- 
		
		if($("#lms_pati_seoryu_jangso").val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.서류수령장소", siteLocale))%>");
			$("#lms_pati_seoryu_jangso").focus();
			return false;
		}
		 --%>
		
		if($("#lms_pati_contents").val() == ""){
			alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,StringUtil.getLocaleWord("L.목적", siteLocale))%>");
			$("#lms_pati_contents").focus();
		    return false;
		}

		if($("#span_att_nalin").css("display") != "none"){
			if(!airCommon.validateAttachFile("LMS/IJ/NALIN")){
				alert("<%=StringUtil.getScriptMessage("M.첨부해주세요",siteLocale, StringUtil.getLocaleWord("L.날인대상서류", siteLocale))%>");
				bool = false;
			}
		}

		if(!bool){
			return bool;
		}
		
		return true;
	}

	/**
	 * 관련계약서 선택 팝업
	 */  
	var popupRelSelect =  function(gubun) {
		
		var sol_mas_uid = "<%=sol_mas_uid%>";
		var callbackFunction = "setRelMas";

		airLms.popupRelSelect(sol_mas_uid, gubun, callbackFunction);
	}

	/**
	 * 관련계약건 설정
	 */
	var setRelMas =  function(data){
		
		var rows = data.rows;
		var totCnt = 0;
		// 기존 데이터 삭제
		$("#gwanryon_geyagseo_list tr").remove();
		
		var arrData = JSON.parse(data);
	   	//jquery-tmpl
	   	var tgTbl = $("#gwanryon_geyagseo_list");
		$("#addRelHeaderTmpl").tmpl().appendTo(tgTbl);
		$("#addRelRowTmpl").tmpl(arrData).appendTo(tgTbl);	 
	}
   
   var setSelText = function(id){
	   $("#"+id).val($("#lms_pati_injang_type_cod option:selected").text());
// 	   if(id == "injang_type"){
// 		   $("#lms_pati_injang_type_nam").val($("#lms_pati_injang_type_cod option:selected").text());
// 	   }else if(id == "injang_type2"){
// 		   $("#lms_pati_injang_type_nam2").val($("#lms_pati_injang_type_cod2 option:selected").text());
// 	   }else if(id == "seoryu_type"){
// 		   $("#lms_pati_seoryu_type_nam").val($("#lms_pati_seoryu_type_cod option:selected").text());
// 	   }
   }
	
	/*
	관련계약건 삭제
	*/
	function doDelContItem(index){
		$("#"+index).remove();
	};	
	$(function(){
		$(".combo").find("input:text").attr("readonly","readonly");
	})
</script>
<script id="addRelHeaderTmpl" type="text/html">
    <tr>
        <th style="width:8%; text-align:center;"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
        <th style="width:12%; text-align:center;"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
        <th style="width:auto; text-align:center;"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
<%--         <th style="width:12%; text-align:center;"><%=StringUtil.getLocaleWord("L.의뢰일_작성일",siteLocale)%></th> --%>
<%--         <th style="width:8%; text-align:center;"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th> --%>
<%--         <th style="width:12%; text-align:center;"><%=StringUtil.getLocaleWord("L.진행상태",siteLocale)%></th> --%>
		<th style="width:7%; text-align:center;"></th>
    </tr>
</script>
<script id="addRelRowTmpl" type="text/html">
    <tr id="\${SOL_MAS_UID}">
        <td align="center" name="gubunName">
            \${GUBUN_NAME}
			<input type="hidden" name="lms_pati_rel_sol_mas" id="lms_pati_rel_sol_mas" value="\${SOL_MAS_UID}"/>
			<input type="hidden" name="lms_pati_rel_gubun" id="lms_pati_rel_gubun" value="\${GUBUN}"/>
			<input type="hidden" name="lms_pati_rel_gubun_name" id="lms_pati_rel_gubun_name" value="\${GUBUN_NAME}"/>
			<input type="hidden" name="lms_pati_rel_title_no" id="lms_pati_rel_title_no" value="\${TITLE_NO}"/>
			<input type="hidden" name="lms_pati_rel_title" id="lms_pati_rel_title" value="\${TITLE}"/>
        </td>
        <td align="center" name="titleNo">\${TITLE_NO}</td>
        <td align="left" name="title">\${TITLE}</td>
<%--        <td align="center" name="reg_dte">\${REG_DTE}</td>
        <td align="center" name="damdang_nam">\${DAMDANG_NAM}</td>
        <td align="center" name="sangtae_nam">\${SANGTAE_NAM}</td>
--%>
		<td>
		<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="doDelContItem('\${SOL_MAS_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
		</td>		
    </tr>
</script>
<pre>
<span style="color:red;">
※ 아래의 지침에 부합하지 않는 기안은 사전 통지 없이 반려하겠으니 반드시 읽어보신 후 양식에 맞추어 작성하시기 바랍니다.</span>
 1. 법인인감 날인 Process
     가. 법인인감 날인 신청 기안
     나. 법인인감 서류 자문법무팀에 송부
		(날인이 필요한 실물서류를 송부해주시지 않으면 날인 불가)
     다. 법무팀 담당자 실물서류 수령 및 검토 <span style="color:red;">(M일)</span>
       - 구비서류, 법무검토 여부 등 확인
       - 미비점에 대해 요청팀에 보완 요청
     라. 법무팀 서류 결재 후 법인 인감날인 <span style="color:red;">(M+1일 오후 3~4시, 1일 1회)</span>
     마. 날인 완료 후 날인 완료 처리
       - 직접수령의 경우 <span style="color:red;">M+1일 오후 4시</span> 전후 수령 가능
       - 행낭/등기의 경우 <span style="color:red;">M+2일</span> 발송 (퀵서비스는 불가)
     바. 요청팀에 송부

                                                       
<span style="color:red;">※ 위 일정 참고하시어 업무처리 진행하여 주시기 바랍니다.</span>
 2. 구비 서류 양식
     <span>가. 법인인감 날인 신청서 기안지 출력본 실물
       - 미비되는 경우가 많습니다. 반드시 출력하여 송부하여 주시기 바랍니다.
     나. 사용인감계
       - 사용인감 반드시 날인 후 송부
       - 사용용도 최대한 구체적으로 특정 (ex. 보증보험의 경우 증권번호, 대리점명 기재)
       - 하단에 일자 반드시 기입
       - 좌측 하단에 제출처 반드시 기입
     다. 인감날인 서류 (계약서, 신청서, 제안서, 입찰서류 등)
       - 계약서 : 계약체결품의
       - 담보관련(질권해지, 저당권해지, 보증보험 등) : 담보감액/반출시 담보감액/반출 품의 (부문별 전결규정 준수)
                                                 채권채무 확인서 증빙 (재무회계팀 협조)
       - 근저당설정해지 : 채권소멸내역 증빙
       - 결제계좌신고서 : 금융팀에 통장인감 날인 요청하여 날인 완료 후, 해당 서류를 자문법무팀으로 송부
       - 입찰신청용 : 사용인감계 사용용도 "입찰 목적"으로 한정하여 기재 (입찰신청 외 용도 기재시 반송)
                  (잘못된 예 :</span><span style="color:red;">계약 및 이에 수반되는 모든 행위</span><span style="color:darkred;">를 기재하는 경우)</span>
	 <span style="color:red;">사용인감으로 날인가능한 계약서는 사용인감계를 활용하시어 사용인감 날인으로 진행요망</span>
      <span style="color:darkred;">라. 날인받을 곳에 연필로 O표시
 
 3. 결재선 및 작성유의사항
   - 법인인감 날인 신청서 는 팀장의 승인 필요
   - 날인요청사유는 상세히 기재(대리점명&코드/KT유선번호/테스트폰 번호/기지국 주소등 모두 기재 요망)
   - 날인 수는 간인 포함하여 정확히 기재(수량선택)</span>
    
 4. 다운받기 <a onclick="airCommon.popupFormDownload('form','사용인감계_181019.ppt')" style="cursor:pointer; color:blue;"><u>①사용인감계</u></a>  <a onclick="airCommon.popupFormDownload('form','위임장_181019.doc');" style="cursor:pointer; color:blue;"><u>②위임장</u></a>
</pre>
<!-- 여기서부터 코딩하세요. -->
<%if("UPDATE_FORM_INCLUDE".equals(doc_mas_mode_code) || "UPDATE_FORM_REV_EDIT_INCLUDE".equals(doc_mas_mode_code)){%>
<input type="hidden" name="lms_pati_ij_001_uid" value="<%=new_lms_pati_ij_001_uid%>">
<%}else{%>
<input type="hidden" name="lms_pati_ij_001_uid" value="<%=lms_pati_ij_001_uid%>">
<%}%>

<div id="div_PTC-LMS-IJ-001">

<table class="basic">
	<caption>
	<span style="float:left">
	<%=StringUtil.getLocaleWord("L.법인인감날인신청",siteLocale) %> ( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale) %>)
	</span>
	<%-- <div style="float:right;">
		<span style="color: red;">* <%=StringUtil.getLocaleWord("L.인장날인_상단_코멘트",siteLocale)%></span></caption>
	</div> --%>
	</caption>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.서류제목",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<input type="text" class="text width_max" name="lms_pati_injang_tit" id="lms_pati_injang_tit" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_INJANG_TIT"))%>" onblur="airCommon.validateMaxLength(this, 255);airCommon.validateSpecialChars(this);"/>
		</td>	
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.서류유형",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<script>
				var seoRyuSet = function(){
					var type_nam_bool = false;
					var org_gy_bool = false;
					$("input:checkbox[name='lms_pati_seoryu_type_cod']:checked").each(function(i, o){
						if("IJ_SEORYU_09" == $(o).val()){
							type_nam_bool = true;
						}
						
						if("IJ_SEORYU_01" == $(o).val()){
							org_gy_bool = true;
						}
						
						
					});
					if(type_nam_bool){
						$("#lms_pati_seoryu_type_nam").val("");
						$("#lms_pati_seoryu_type_nam").show();
					}else{
						$("#lms_pati_seoryu_type_nam").val("");
						$("#lms_pati_seoryu_type_nam").hide();
						
					}
					
					if(org_gy_bool){
						$("#orgGyP").show();
						$("#span_att_nalin").hide();

					}else{
						$("#orgGyP").hide();
						$("#span_att_nalin").show();
						
					}
					
					
				}
				var gyPumSelect = function(){
					
					var solUids = $('input[name=lms_pati_org_gy_no]').val();
					
					var url = '/ServletController';
					url += '?<%=CommonConstants.ACTION_CODE%>=LMS_GY_LIST_MAS';
					url += '&<%=CommonConstants.MODE_CODE%>=POPUP_ORGGY_GLIST';
					url += '&pum_en_dte=1900-01-01';
					url += '&callType=IJ';
					
					airCommon.openWindow(url, 1024, 700, 'popOrgGyList', 'yes', 'yes' );
				}
			</script>
			<%=HtmlUtil.getInputCheckbox(request,  true, "lms_pati_seoryu_type_cod", PAPER_YH_CODESTR, jsonMap.getDefStr("LMS_PATI_SEORYU_TYPE_COD", gy_seoryu_type_cod), "onClick=\"seoRyuSet();\"", "")%>
			<input type="text" style="display: <%if(jsonMap.getDefStr("LMS_PATI_SEORYU_TYPE_COD", gy_seoryu_type_cod).indexOf("IJ_SEORYU_09") < 0){ %>none<%} %>;;" class="text" name="lms_pati_seoryu_type_nam" id="lms_pati_seoryu_type_nam" value="<%=jsonMap.getString("LMS_PATI_SEORYU_TYPE_NAM")%>"/>
			<p style="display: <%if(jsonMap.getDefStr("LMS_PATI_SEORYU_TYPE_COD", gy_seoryu_type_cod).indexOf("IJ_SEORYU_01") < 0){ %>none<%} %>;" id="orgGyP">
				<%=StringUtil.getLocaleWord("L.계약체결품의",siteLocale)%>
				<input type="hidden" name="lms_pati_org_gy_uid" id="lms_pati_org_gy_uid" value="<%=jsonMap.getDefStr("LMS_PATI_ORG_GY_UID", gyMas.getString("SOL_MAS_UID")) %>" />
				<input type="hidden" name="lms_pati_org_gy_type" id="lms_pati_org_gy_type" value="<%=jsonMap.getString("LMS_PATI_ORG_GY_TYPE") %>" size="20" readonly />
				<input type="text" class="text" name="lms_pati_org_gy_no" id="lms_pati_org_gy_no" value="<%=jsonMap.getDefStr("LMS_PATI_ORG_GY_NO", gyMas.getString("GWANRI_NO")) %>" size="10" readonly />
				<input type="text" class="text" name="lms_pati_org_gy_title" id="lms_pati_org_gy_title" value="<%=jsonMap.getDefStr("LMS_PATI_ORG_GY_TITLE", gyMas.getString("GYEYAG_TIT")) %>" size="20" readonly />
				<input type="button" id="btn_lms_pati_org_gy_no" title="<%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%>" onclick="gyPumSelect()" class="btn_search" />
				<br/><span style="color:red;"><%=StringUtil.getLocaleMessage("M.인장_계약체결품의_알림", siteLocale) %></span>
			</p>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td colspan="3">
			<%= loginUser.gethoesaNam() %>
			<input type="hidden" name="lms_pati_hoesa_cod" value="<%= loginUser.gethoesaCod() %>" />
			<input type="hidden" name="lms_pati_hoesa_nam" value="<%= loginUser.gethoesaNam() %>" />
		</td>
	</tr>
	<%-- 
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.인감종류",siteLocale)%></span></th>
		<td class="td4">
		    <%=HtmlUtil.getSelect(request, true, "lms_pati_injang_type_cod", "lms_pati_injang_type_cod", IJ_KND_CODESTR, jsonMap.getString("LMS_PATI_INJANG_TYPE_COD"), "onChange=\"setSelText('injang_type'); changeValidation(this.value);\" style='width:100%;'")%>
		    <input type="hidden" name="lms_pati_injang_type_nam" id="lms_pati_injang_type_nam" value="<%=jsonMap.getString("LMS_PATI_INJANG_TYPE_NAM") %>"/>
		    <input type="hidden" name="ij_formid" id="ij_formid" value=""/>
		    <input type="hidden" name="if_chamjo_empno" id="if_chamjo_empno" value=""/>
		</td>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.처리요청일",siteLocale)%></span></th>
		<td class="td4">
			<%=HtmlUtil.getInputCalendar(request, true, "lms_pati_req_hop_dte", "lms_pati_req_hop_dte", jsonMap.getString("LMS_PATI_REQ_HOP_DTE"), "")%>
		</td>
	</tr>
	 --%>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰부서",siteLocale)%></th>
		<td class="td4" id="LMS_PATI_YOCHEONG_DPT_NAM">
			<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM_"+siteLocale, loginUser.getGroupName()) %>
			<input type="hidden" name="lms_pati_yocheong_dpt_cod" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_COD", loginUser.getGroupCode()) %>" />
			<input type="hidden" name="lms_pati_yocheong_dpt_nam_ko" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM_KO", loginUser.getGroupNameKo()) %>" />
			<input type="hidden" name="lms_pati_yocheong_dpt_nam_en" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_DPT_NAM_EN", loginUser.getGroupNameEn()) %>" />
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.의뢰자",siteLocale)%></th>
		<td class="td4" id="LMS_PATI_YOCHEONG_NAM">
			<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_"+siteLocale , loginUser.getName()) %>  
			<input type="hidden" name="lms_pati_yocheong_id" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_ID", loginUser.getLoginId()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_ko" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_KO", loginUser.getNameKo()) %>" />
			<input type="hidden" name="lms_pati_yocheong_nam_en" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_NAM_EN", loginUser.getNameEn()) %>" />
			<input type="hidden" name="LMS_PATI_YOCHEONG_POS_NAM_KO" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_POS_NAM_KO", loginUser.getPositionNameKo()) %>" />
			<input type="hidden" name="LMS_PATI_YOCHEONG_POS_NAM_EN" value="<%=jsonMap.getDefStr("LMS_PATI_YOCHEONG_POS_NAM_EN", loginUser.getPositionNameEn()) %>" />
		</td>
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.제출처",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<input type="text" class="text width_max" name="lms_pati_jechulcheo" id="lms_pati_jechulcheo" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_JECHULCHEO")) %>" onblur="airCommon.validateMaxLength(this, 127);airCommon.validateSpecialChars(this);"/>
		</td>
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_등",siteLocale)%></th>
		<td class="td4" colspan="3">
		    <span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="popupRelSelect('IJ');"><%=StringUtil.getLocaleWord("B.SELECT",siteLocale)%></a></span>
            <table id="gwanryon_geyagseo_list" class="basic">
		     <%
			String[] REL_SOL = jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS");
			if(REL_SOL != null && REL_SOL.length > 0){
		 	%>
    	    <tr>
		        <th width="12%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
		        <th width="13%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.관리번호",siteLocale)%></th>
		        <th width="75%" style="text-align:center;"><%=StringUtil.getLocaleWord("L.제목_사건명",siteLocale)%></th>
		        <th></th>
		    </tr>
   		   	<%
				for(int i=0; i< REL_SOL.length; i++){
			%>
			<tr id="<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i]%>">
		        <td align="center">
		            <%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN_NAME")[i]%>
		            <input type="hidden" name="lms_pati_rel_sol_mas" id="lms_pati_rel_sol_mas" value="<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i]%>"/>
					<input type="hidden" name="lms_pati_rel_gubun_name" id="lms_pati_rel_gubun_name" value="<%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN_NAME")[i]%>"/>
		            <input type="hidden" name="lms_pati_rel_gubun" id="lms_pati_rel_gubun" value="<%=jsonMap.getArrStr("LMS_PATI_REL_GUBUN")[i]%>"/>
		            <input type="hidden" name="lms_pati_rel_title_no" id="lms_pati_rel_title_no" value="<%=jsonMap.getArrStr("LMS_PATI_REL_TITLE_NO")[i]%>"/>
		            <input type="hidden" name="lms_pati_rel_title" id="lms_pati_rel_title" value="<%=jsonMap.getArrStr("LMS_PATI_REL_TITLE")[i]%>"/>
		        </td>
		        <td align="center"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE_NO")[i]%></td>
		        <td align="left"><%=jsonMap.getArrStr("LMS_PATI_REL_TITLE")[i]%></td>
				<td>
				<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="doDelContItem('<%=jsonMap.getArrStr("LMS_PATI_REL_SOL_MAS")[i]%>');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
				</td>		
		    </tr>
		    
			<%
				}
			}
			%>
            </table>
       </td>
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.날인수",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<input type="text" class="cost" name="lms_pati_nalinsu" id="lms_pati_nalinsu" maxLength="11" onblur="airCommon.getFormatCurrency(this, this.value);airCommon.validateMaxLength(this, 11);" value="<%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_NALINSU")) %>" />
		</td>
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.서류수령방법",siteLocale)%></span></th>
		<td class="td2" colspan="3">
			<script>
			 var setRecView = function(val){
				 if("IJ_RECEIVE_CODE_02" == val){
					 $("#lms_pati_rec_com_name").val("<%=jsonMap.getStringView("LMS_PATI_REC_COM_NAME")%>");
					 $("#lms_pati_rec_com_name").show();
					 $("#lms_pati_rec_addr").val("");
					 $("#lms_pati_rec_addr").hide();
					 
				 }else if("IJ_RECEIVE_CODE_03" == val){
					 $("#lms_pati_rec_com_name").val("");
					 $("#lms_pati_rec_com_name").hide();
					 $("#lms_pati_rec_addr").val("<%=jsonMap.getStringView("LMS_PATI_REC_ADDR")%>");
					 $("#lms_pati_rec_addr").show();
					 
				 }else {
					 $("#lms_pati_rec_com_name").val("");
					 $("#lms_pati_rec_com_name").hide();
					 $("#lms_pati_rec_addr").val("");
					 $("#lms_pati_rec_addr").hide();
				 }
			 }
			</script>
			<%=HtmlUtil.getSelect(request, true, "lms_pati_seoryu_rec_cod", "lms_pati_seoryu_rec_cod", IJ_RECEIVE_CODESTR, jsonMap.getString("LMS_PATI_SEORYU_REC_COD"), "onChange=\"setRecView(this.value)\"")%>
			<input type="text" class="text width_max" style="display:none;" name="lms_pati_rec_com_name" id="lms_pati_rec_com_name" placeholder="<%=StringUtil.getLocaleMessage("M.서류수령방법_알림2", siteLocale) %>" value="<%=jsonMap.getStringView("LMS_PATI_REC_COM_NAME")%>"/>
			<input type="text" class="text width_max" style="display:none;" name="lms_pati_rec_addr" id="lms_pati_rec_addr" placeholder="<%=StringUtil.getLocaleMessage("M.서류수령방법_알림", siteLocale) %>" value="<%=jsonMap.getStringView("LMS_PATI_REC_ADDR")%>"/>
		</td>
	</tr>
	<tr>
		<th class="th2"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.목적", siteLocale) %></span></th>
		<td class="td2" colspan="3">
			<textarea rows="5" class="text width_max" id="lms_pati_contents" name="lms_pati_contents" maxLength="4000"><%=StringUtil.convertForInput(jsonMap.getString("LMS_PATI_CONTENTS")) %></textarea>
			<br/><span style="color:red;"><%=StringUtil.getLocaleMessage("M.인장_목적_알림", siteLocale) %></span>
		</td>
	</tr>
	<tr>
		<th class="th4" id="th_att_nalin"><span id="span_att_nalin" class="ui_icon required" style="display:<%if(jsonMap.getDefStr("LMS_PATI_SEORYU_TYPE_COD", gy_seoryu_type_cod).indexOf("IJ_SEORYU_01") > -1){ %>none<%} %>"></span><%=StringUtil.getLocaleWord("L.날인대상서류",siteLocale) %></th>
		<td class="td4" >
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/IJ/NALIN" name="typeCode" />
				<jsp:param value="Y" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일",siteLocale) %></th>
		<td class="td4" >
			<jsp:include page="/ServletController" flush="true">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/IJ/REQ" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
			</jsp:include>
		</td>
	</tr>
</table>
<p></p>
</div>
<%if ("DEV".equals(CommonProperties.getSystemMode())){%>
	<div class="buttonlist">
		<div class="right">
		<span class="ui_btn medium icon"><span class="write"></span><input type="button" name="btnWrite"  value="Validation" onclick="<%="Parti"+mng_pati_uid%>_dataCheck()" /></span>
		</div>
	</div>
<%}%>
<script>
// 관련 계약/자문/소송 정보 조회
$(document).ready(function () {
	
	//-- 최초 작성 임시저장일떄는 TODO 영역을 가리기 위함
	//-- 그 이유는 삭제 처리가 있어 서로 햇갈리기 때문
	//-- 주석하고 테스트 해보면 알수 있음
	try{
		todoHide<%=sol_mas_uid%>();
	}catch(e){}
	
	// 인감종류 설정
	setSelText('injang_type');
	<%if(StringUtil.isNotBlank(jsonMap.getString("LMS_PATI_SEORYU_REC_COD"))){%>
	setRecView('<%=jsonMap.getString("LMS_PATI_SEORYU_REC_COD")%>');
	<%}%>

});
</script>