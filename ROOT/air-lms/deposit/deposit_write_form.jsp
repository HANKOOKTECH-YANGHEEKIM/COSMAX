<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil"%>
<%
	//-- 로그인 사용자 정보
	SysLoginModel loginUser = (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 결과값 셋팅
	BeanResultMap requestMap = (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	BeanResultMap resultMap = (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	BeanResultMap jsonMap = (BeanResultMap)request.getAttribute(CommonConstants._JSON_DATA);
	if(jsonMap == null)jsonMap = new BeanResultMap();
	
	
	SQLResults viewResult = resultMap.getResult("VIEW");
	BeanResultMap viewMap = new BeanResultMap();

	if(viewResult != null && viewResult.getRowCount()> 0){
		viewMap.putAll(viewResult.getRowResult(0));
	}
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);
	
	//-- 상세보기 값 셋팅
	String sSOL_MAS_UID = "";
	String sDEPOSIT_MAS_UID = "";
	String sREG_NAM = loginUser.getName();
	String sREG_DTE  = DateUtil.getCurrentDate();
	
	if(viewResult != null && viewResult.getRowCount() > 0){
		sSOL_MAS_UID = viewMap.getString("SOL_MAS_UID");
		sDEPOSIT_MAS_UID = viewMap.getString("DEPOSIT_MAS_UID");
		sREG_NAM = viewMap.getString("REG_NAM");
		sREG_DTE = viewMap.getString("REG_DTE");
	}
	
	//-- 코드정보 문자열 셋팅
	String sHOESA_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sDPT_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DPT_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sYUHYEONG_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("YUHYEONG_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sBEOBWEON_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("BEOBWEON_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sDEPOSIT_BEOBWEON_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("DEPOSIT_BEOBWEON_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));	
	String sSANGTAE01_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SANGTAE01_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String sSANGTAE02_LIST = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SANGTAE02_LIST"), "CODE_ID,LANG_CODE", "|" + StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	
	String sol_mas_uid = requestMap.getString("SOL_MAS_UID");
	String deposit_mas_uid = viewMap.getString("DEPOSIT_MAS_UID");
	String temp_deposit_mas_uid = StringUtil.getRandomUUID();
	
	boolean isNew = false;
	
	if(StringUtil.isBlank(sol_mas_uid)){
		sol_mas_uid = StringUtil.getRandomUUID();
		isNew = true;
	}
	
	//첨부관련 셋팅
	String att_master_doc_id = "";
	String att_default_master_doc_Ids 	= "";
	if(isNew){
		att_master_doc_id = temp_deposit_mas_uid;
		att_default_master_doc_Ids 	= "";
	}else{
		att_master_doc_id = deposit_mas_uid;
		att_default_master_doc_Ids = deposit_mas_uid;
	}
	
	boolean isAuths = false;
	
	if(null==viewMap || "".equals(viewMap.getString("DAMDANGJA_ID"))) {
		if( loginUser.isUserAuth("LMS_SSM") || LmsUtil.isSysAdminUser(loginUser) || LmsUtil.isBeobmuTeamUser(loginUser) ) {
			isAuths = true;
		}
	} else {
		if(
				loginUser.getLoginId().equals(viewMap.getString("DAMDANGJA_ID")) || loginUser.isUserAuth("LMS_SSM") || LmsUtil.isSysAdminUser(loginUser)
		){
			isAuths = true;
		}
	}
%>
<form name="depositForm" id="depositForm" method="POST">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="deposit_mas_uid" value="<%=deposit_mas_uid%>" />
	<input type="hidden" name="temp_ss_mas_uid" value="<%=temp_deposit_mas_uid%>" />
	<input type="hidden" name="gb_doc_mas_uid" value="<%=viewMap.getString("GB_DOC_MAS_UID")%>" />
	<input type="hidden" name="is_new" value="<%=isNew%>" />
	<table class="basic">
		<caption><%=StringUtil.getLocaleWord("L.공탁", siteLocale) %>( <span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.는_필수_입력항목",siteLocale)%>)</caption>
		<tr>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록일", siteLocale) %></th>
			<td class="td4"><%=sREG_DTE %></td>
			<th class="th4"><%=StringUtil.getLocaleWord("L.등록자", siteLocale) %></th>
			<td class="td4"><%=sREG_NAM %></td>
		</tr>	
		<tr>
			<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.사건명",siteLocale) %></span></th>
			<td class="td4">
				<input type="text" name="DEPOSIT_TIT" id="DEPOSIT_TIT" value="<%=StringUtil.convertFor(viewMap.getString("DEPOSIT_TIT"), "INPUT")%>" maxlength="100" data-length="100" class="text width_max" onblur="airCommon.validateMaxLength(this, 1000);airCommon.validateSpecialChars(this);" />
			</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁서송달일",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "DELIVERY_DTE", "DELIVERY_DTE", viewMap.getString("DELIVERY_DTE"), "") %>
		</td>
		</tr>
	<tr>
	    <th class="th4"><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "HOESA_COD", "HOESA_COD", sHOESA_LIST, viewMap.getString("HOESA_COD"), "onchange=\"$('#HOESA_NAM').val($('#HOESA_COD option:selected').text());\" class=\"select width_max\"") %>
			<input type="hidden" name="HOESA_NAM" id="HOESA_NAM" value="<%=StringUtil.convertFor(viewMap.getString("HOESA_NAM"), "INPUT")%>" />
		</td>
		<th class="th4"><%=StringUtil.getLocaleWord("L.유형",siteLocale)%></th>
		<td class="td4">
				<%=HtmlUtil.getSelect(request, true, "YUHYEONG_COD", "YUHYEONG_COD", sYUHYEONG_LIST, viewMap.getString("YUHYEONG_COD"), "onchange=\"changeEtcTxt(this.value, 'YUHYEONG_NAM', this.id)\" class=\"select width_max\"") %>
				<input type="text" name="YUHYEONG_NAM" id="YUHYEONG_NAM" placeholder="<%=StringUtil.getLocaleWord("L.직접입력", siteLocale) %>..." value="<%=viewMap.getString("YUHYEONG_NAM")%>" maxlength="50" class="text width_max" style="display:<%=viewMap.getString("YUHYEONG_COD").endsWith("ZZ") ? "" : "none" %>;" />
		</td>	
	</tr>
	<tr>
		<th class="th4"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.공탁번호",siteLocale)%></span></th>
		<td class="td4">
			<input type="text" name="DEPOSIT_NO" id="DEPOSIT_NO" value="<%=StringUtil.convertFor(viewMap.getString("DEPOSIT_NO"), "INPUT")%>" maxlength="15" class="width_max" />
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁법원",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "DEPOSIT_BEOBWEON_COD", "DEPOSIT_BEOBWEON_COD", sDEPOSIT_BEOBWEON_LIST, viewMap.getString("DEPOSIT_BEOBWEON_COD"), "onchange=\"$('#DEPOSIT_BEOBWEON_NAM').val($('#DEPOSIT_BEOBWEON_COD option:selected').text());\" class=\"select width_max\"") %>
			<input type="hidden" name="DEPOSIT_BEOBWEON_NAM" id="DEPOSIT_BEOBWEON_NAM" value="<%=StringUtil.convertFor(viewMap.getString("DEPOSIT_BEOBWEON_NAM"), "INPUT")%>" />
		</td>	
	</tr>		
	<tr>
		<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.공탁자",siteLocale)%></th>
		<td class="td4">
			<input type="text" name="DEPOSIT_MAN" id="DEPOSIT_MAN" value="<%=viewMap.getString("DEPOSIT_MAN") %>" maxlength="100" class="width_max" />
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁일자",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "DEPOSIT_DTE", "DEPOSIT_DTE", viewMap.getString("DEPOSIT_DTE"), "") %>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁금액",siteLocale)%></th>
		<td class="td4" colspan="3">
			KRW <input type="text" name="DEPOSIT_COST" id="DEPOSIT_COST" onkeyup="airCommon.getFormatCurrency(this,-1,true);" value="<%=StringUtil.getFormatCurrency(viewMap.getString("DEPOSIT_COST"),-1) %>" maxlength="20" style="width:300px;" />
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관할법원",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "BEOBWEON_COD", "BEOBWEON_COD", sBEOBWEON_LIST, viewMap.getString("BEOBWEON_COD"), "onchange=\"$('#BEOBWEON_NAM').val($('#BEOBWEON_COD option:selected').text());\" class=\"select width_max\"") %>
			<input type="hidden" name="BEOBWEON_NAM" id="BEOBWEON_NAM"value="<%=StringUtil.convertFor(viewMap.getString("BEOBWEON_NAM"), "INPUT")%>" />
		</td>	
		<th class="th4"><%=StringUtil.getLocaleWord("L.사건번호",siteLocale)%></th>
		<td class="td4">
			<input type="text" name="SAGEON_NO" id="SAGEON_NO" value="<%=StringUtil.convertFor(viewMap.getString("SAGEON_NO"), "INPUT")%>" maxlength="15" style="width:99%;" />
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.현업부서",siteLocale)%></th>
		<td class="td4" colspan="3">
			<input type="text" name="REL_DPT_NAM" id="REL_DPT_NAM" value="<%=StringUtil.convertFor(viewMap.getString("REL_DPT_NAM"), "INPUT")%>" maxlength="150" style="width:99%;" />
		</td>	
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.관련_계약_자문_소송",siteLocale)%></th>
		<td class="td4" colspan="3">
			<span class="ui_btn small icon"><span class="add"></span><a href="javascript:void(0)" onclick="popupRelSelect('DE');"><%=StringUtil.getLocaleWord("B.SELECT",siteLocale)%></a></span>
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
		<th class="th4"><%=StringUtil.getLocaleWord("L.담당자",siteLocale)%></th>
		<td class="td4" colspan="3">
			<input type="hidden" name="damdangja_id" id="damdangja_id" value="<%=StringUtil.convertForInput(viewMap.getDefStr("DAMDANGJA_ID",loginUser.getLoginId())) %>" />
			<input type="text" name="damdangja_nam" id="damdangja_nam" value="<%=StringUtil.convertForInput(viewMap.getDefStr("DAMDANGJA_NAM_"+siteLocale, loginUser.getName())) %>" class="text width_full readonly" readonly style="width:280px" />
			<span class="ui_btn small icon"><span class="search"></span><a href="javascript:void(0)" onclick="searchDamdangja()"><%=StringUtil.getLocaleWord("B.검색",siteLocale)%></a></span>
			<script type="text/javascript">	
			function searchDamdangja() {
				var defaultUser = $("#damdangja_id").val();
				var param ={};
            	
            	param["groupTypeCodes"]= "IG";
            	param["defaultUser"]= defaultUser;
            	param["userType"]= "susin";
            	param["multiSelect"]= "N";
            	
            	airCommon.popupUserSelect("changeDamdangja", param);
			} 
			function changeDamdangja(json) {
				var data = JSON.parse(json);
				var ids = [];
				var nms = [];
				var views = [];
				$(data).each(function(i, d){
					ids.push(d.LOGIN_ID);
					nms.push(d.GROUP_NAME_<%=siteLocale%>+" "+d.NAME_<%=siteLocale%> +" "+d.POSITION_NAME_<%=siteLocale%>);
				});
				
				$("#damdangja_id").val(ids);
				$("#damdangja_nam").val(nms);
				
			}
			</script>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.공탁원인사실",siteLocale)%></th>
		<td class="td4" colspan="3">
			<input type="text" name="DEPOSIT_WONIN" id="DEPOSIT_WONIN" value="<%=StringUtil.convertFor(viewMap.getString("DEPOSIT_WONIN"), "INPUT")%>" maxLength="2000" style="width:99%;" />
		</td>	
	</tr>	
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.상태",siteLocale)%></th>
		<td class="td4">
			<%=HtmlUtil.getSelect(request, true, "SANGTAE01_COD", "SANGTAE01_COD", sSANGTAE01_LIST, viewMap.getString("SANGTAE01_COD"), "class=\"select\" onchange=\"changeRequ(this.value, 'span_required_END_DTE')\"") %>
			<%=HtmlUtil.getSelect(request, true, "SANGTAE02_COD", "SANGTAE02_COD", sSANGTAE02_LIST, viewMap.getString("SANGTAE02_COD"), "class=\"select\"") %>
		</td>	
		<th class="th4"><span class="ui_icon required" id="span_required_END_DTE" style="display:none;"></span><%=StringUtil.getLocaleWord("L.종결일",siteLocale)%></th>
		<td class="td4">
			<%= HtmlUtil.getInputCalendar(request, true, "END_DTE", "END_DTE", viewMap.getString("END_DTE"), "") %>
		</td>	
	</tr>
	<tr>
		<th class="th4"><%=StringUtil.getLocaleWord("L.처리결과",siteLocale)%></th>
		<td class="td4" colspan="3">
			<input type="text" name="RESULT" id="RESULT" value="<%=StringUtil.convertFor(viewMap.getString("RESULT"), "INPUT")%>" maxLength="150" style="width:99%;" />
		</td>	
	</tr>	
	<tr>
<%String requiredYn = "Y"; %>
		<th class="th4"><%=StringUtil.getLocaleWord("L.첨부파일", siteLocale) %></th>
		<td class="td4" colspan="3">
			<jsp:include page="/ServletController">
				<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
				<jsp:param value="FILE_WRITE" name="AIR_MODE" />  
				<jsp:param value="" name="AIR_PARTICLE" />
				<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
				<jsp:param value="LMS" name="systemTypeCode" />
				<jsp:param value="LMS/DEPOSIT/PUT" name="typeCode" />
				<jsp:param value="N" name="requiredYn" />
				<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
			</jsp:include>
		</td>
	</tr>	
	</table>

	<div class="buttonlist">
		<div class="right">
<% if(isAuths){ %>
			<script>
				/**
				 * 저장
				 */	
				function doSubmit(frm) {		
					if (frm.DEPOSIT_TIT.value == "") {
						alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale, StringUtil.getLocaleWord("L.사건명", siteLocale))%>");
						frm.DEPOSIT_TIT.focus();
						return;
					}
						
					if (frm.DEPOSIT_NO.value == "") {
						alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getLocaleWord("L.공탁번호", siteLocale))%>");
						frm.DEPOSIT_NO.focus();
						return;
					} 
					
					if (frm.DEPOSIT_MAN.value == "") {
						alert("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale, StringUtil.getLocaleWord("L.공탁자", siteLocale))%>");
						frm.DEPOSIT_MAN.focus();
						return;
					} 
					
					if (frm.SANGTAE01_COD.value.endsWith("LMS_DEPOSIT_SANGTAE_02")) { //상태가 종결인 경우
						if (frm.END_DTE.value == "") {
							alert("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale, StringUtil.getLocaleWord("L.종결일", siteLocale))%>");
							frm.END_DTE.focus();
							return;
						} 
					}
					
				<%--
					if($("#HOESA_COD").combobox('getValue') == undefined ){
				        $("#HOESA_COD").combobox('setValue', 'ALL_HOESA');
					}
				--%>		
						
					var txt = $(".combo").find("input:text");
					$("#HOESA_NAM").val(txt.val());
					
					if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까",siteLocale,StringUtil.getLocaleWord("L.저장", siteLocale))%>")) {
						//--에디터 서브밋 처리 by 강세원
						airCommon.setEditorSubmit("<%=CommonProperties.load("system.editor")%>");
						
						var data = $("#depositForm").serialize();
						airCommon.callAjax("<%=actionCode%>", "WRITE_PROC", $(frm).serialize() , function(json){
				<%if(isNew){%>
							try {
								opener.doSearch();
							} catch(e){
							}
				<%}else{%>
							try {
								opener.$('#VIEW<%=sol_mas_uid %>').panel('open').panel('refresh');
							} catch(e){
							}
				<%}%>
							window.close();
						});
					}
				}
			</script>
			<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:doSubmit(document.depositForm);"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
<% } %>
		</div>
	</div>
</form>
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
<% if(isAuths){ %>
		<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="doDelContItem('\${SOL_MAS_UID}');"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>
<% }%>
		</td>		
    </tr>
</script>
<script type="text/javascript">

var changeRequ = function(vThisVal, vId){
	if(vThisVal.endsWith("LMS_DEPOSIT_SANGTAE_02")){
		$("#"+vId).show();
	}else{
		$("#"+vId).hide();
	}
};

var changeEtcTxt = function(vThisVal, vId, vThisID){
	if(vThisVal.endsWith("99") || vThisVal.endsWith("ZZ")){
		$("#"+vId).val("");
		$("#"+vId).show();
	}else{
		$("#"+vId).val($("#"+vThisID+" option:selected").text());
		$("#"+vId).hide();
	}
};

<% if(isAuths){ %>
/*
관련계약건 삭제
*/
function doDelContItem(id){
	$("#"+id).remove();
};	
<% } %>
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
};

$(function(){
	changeRequ($("#SANGTAE01_COD").val(), 'span_required_END_DTE');
});
</script>