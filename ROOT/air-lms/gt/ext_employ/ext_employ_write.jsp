<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>    
<%@ page import="com.emfrontier.air.common.jdbc.SQLResults"%>
<%@ page import="com.emfrontier.air.common.util.HtmlUtil"%>
<%@ page import="com.emfrontier.air.common.config.CommonConstants" %>
<%@ page import="com.emfrontier.air.common.config.CommonProperties" %>
<%@ page import="com.emfrontier.air.common.model.SysLoginModel" %>
<%@ page import="com.emfrontier.air.common.util.StringUtil" %>
<%@ page import="com.emfrontier.air.common.bean.BeanResultMap"%>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser = (SysLoginModel) request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale = loginUser.getSiteLocale();

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String pageNo 			= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 		= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	String sol_mas_uid	=	requestMap.getString("SOL_MAS_UID");
	String gbn =	requestMap.getString("GBN");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	String SIM_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("SIM_LIST"), "SIM_CHA_NO,SIM_CHA_NM", "");
	
	SQLResults		rsMemo = resultMap.getResult("MAS");
	
	BeanResultMap memoMap = new BeanResultMap();
	if(rsMemo != null && rsMemo.getRowCount()> 0){
		memoMap.putAll(rsMemo.getRowResult(0));
	}
	
	String gt_ext_uid	= memoMap.getString("GT_EXT_UID");
	String temp_gt_ext_uid = StringUtil.getRandomUUID();
	
	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String uuid = StringUtil.getRandomUUID();
	
	//첨부관련 셋팅
	String att_master_doc_id 				= "";
	String att_default_master_doc_Ids 	= "";
	
	if(StringUtil.isNotBlank(gt_ext_uid)){ //수정
		att_master_doc_id 			= gt_ext_uid;
		att_default_master_doc_Ids 	= gt_ext_uid;
	}else{ //등록
		att_master_doc_id 			= temp_gt_ext_uid;
		att_default_master_doc_Ids 	= "";
	}
%>
<form name="form1" id="form1" method="post">
	<input type="hidden" name="sol_mas_uid" value="<%=sol_mas_uid%>" />
	<input type="hidden" name="gt_ext_uid" id="gt_ext_uid" value="<%=gt_ext_uid%>" />
	<input type="hidden" name="temp_gt_ext_uid" id="temp_gt_ext_uid" value="<%=temp_gt_ext_uid%>" />
	<table class="none">
		<colgroup>
			<col style="width:45%" />
			<col style="width:1%" />
			<col style="width:auto" />
		</colgroup>
		<tr>
			<td align="left" valign="top">
				<table class="none">
					<tr>
						<td align="left" valign="top" colspan="2">
						<table class="box">
							<tr>
								<td class="corner_lt"></td>
								<td class="border_mt"></td>
								<td class="corner_rt"></td>
							</tr>
							<tr>
								<td class="border_lm"></td>
								<td class="body">		
									<table style="margin:4px;">
										<colgroup>
											<col style="width:auto;" />
											<col style="width:75px;" />
										</colgroup>	
<%-- 
						            	<tr>
						            		<th><%=StringUtil.getLocaleWord("L.회사",siteLocale)%></th>
						            		<td style="width:65%"><%=HtmlUtil.getSelect(request, true, "hoesa_cod", "hoesa_cod", HOESA_CODESTR, hoesa_cod, "onchange=\"changeHoesa();\" data-type=\"search\" class=\"width_max_select\"")%></td>
						            	</tr>
						            	<tr>
						            		<td colspan="1" style="height:2px;"></td>
						            	</tr>	 
--%>
										<tr>
											<td style="vertical-align:top; width:80%;">
												<input type="text" name="schValue" id="schValue" value=""  class="text width_max" data-type="search" placeholder="Name Search"  onkeydown="doSearchUser(true)" maxlength="30" />
											</td>
											<td style="text-align:center;">
							            		<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearchUser();" ><%=StringUtil.getLocaleWord("L.검색",siteLocale)%></a></span>
						            		</td>
						            	</tr>	
									</table>
								</td>
								<td class="border_rm"></td>
							</tr>
							<tr>
								<td class="corner_lb"></td>
								<td class="border_mb"></td>
								<td class="corner_rb"></td>
							</tr>							
						</table>
						<%-- <iframe name="iframeUserSelect" frameborder="0" width="100%" height="380" scrolling="yes" src="<%=iframeUserSelectSrc.toString()%>"></iframe> --%>
						<div id="treeArea" class="treeArea" style="height:337px; margin-top:3px;"></div>
						</td>
					</tr>
				</table>
			</td>
 			<td>&nbsp;</td>
 			<td align="right" valign="top">
				<table class="basic" style="margin-top:5px;">   
<%if("SS".equals(gbn)){ %>
				    <tr>
						<th><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.심급",siteLocale) %></span></th>
						<td>
							<%=HtmlUtil.getSelect(request, true, "sim_cha_no", "sim_cha_no", SIM_CODESTR, "", "class=\"select\"")%>
						</td>
					</tr> 
<%} %>
				  <tr>
				  	<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.이름",siteLocale)%></th>
				  	<td class="td4">
				 			<span id="user_name"><%=memoMap.getString( "BYEONHOSA_NAM")%></span>
							<input type="hidden" name="byeonhosa_id"  value="<%=memoMap.getString( "BYEONHOSA_ID")%>">
							<input type="hidden" name="byeonhosa_nam" value="<%=memoMap.getString( "BYEONHOSA_NAM")%>">
							<input type="hidden" name="byeonhosa_nam_ko" value="<%=memoMap.getString( "BYEONHOSA_NAM_KO")%>">
							<input type="hidden" name="byeonhosa_nam_en" value="<%=memoMap.getString( "BYEONHOSA_NAM_EN")%>">
				  	</td>
				  </tr>
				  <tr>
				  	<th class="th4"><%=StringUtil.getLocaleWord("L.소속",siteLocale)%></th>
				  	<td class="td4">
				 			<span id="user_group"><%=memoMap.getString( "SOSOG_NAM")%></span>
					        <input type="hidden" name="sosog_nam" value="<%=memoMap.getString( "SOSOG_NAM")%>">
					        <input type="hidden" name="sosog_nam_ko" value="<%=memoMap.getString( "SOSOG_NAM_KO")%>">
					        <input type="hidden" name="sosog_nam_en" value="<%=memoMap.getString( "SOSOG_NAM_EN")%>">
					        <input type="hidden" name="sosog_cod" value="<%=memoMap.getString( "SOSOG_COD")%>">
				  	</td>
				  </tr>
				  <tr>
				  	<th class="th4"><span class="ui_icon required"></span><%=StringUtil.getLocaleWord("L.위임일",siteLocale)%></th>
				  	<td class="td4">
					        <%= HtmlUtil.getInputCalendar(request, true, "PLUS_DATE", "PLUS_DATE", memoMap.getString("PLUS_DATE"), "") %>
				  	</td>
				  </tr>	
				  <tr>
				  	<th class="th4"><%=StringUtil.getLocaleWord("L.위임종료일",siteLocale)%></th>
				  	<td class="td4">
					         <%= HtmlUtil.getInputCalendar(request, true, "MINUS_DATE", "MINUS_DATE", memoMap.getString("MINUS_DATE"), "") %>
				  	</td>
				  </tr>			  
				    <tr>
				        <th class="th4"><%=StringUtil.getLocaleWord("L.주요검토자",siteLocale)%></th>
				        <td class="td4">
				        	<input type="checkbox" name="PGL_YN" value="Y" <%="Y".equals(memoMap.getString("PGL_YN")) ? "checked" : "" %> />
				        </td>     
				    </tr>
				    <tr>
				        <th class="th4"><%=StringUtil.getLocaleWord("L.위임계약조건",siteLocale)%></th>
				        <td class="td4"><textarea name="memo" id="memo" class="textarea width_max" rows="6" onblur="airCommon.validateMaxLength(this, 2000);airCommon.validateSpecialChars(this);"><%=StringUtil.convertForInput( memoMap.getString("MEMO")) %></textarea></td>     
				    </tr>
				    <tr>
						<th class="th4"><%=StringUtil.getLocaleWord("L.위임계약서날인본",siteLocale) %></th>
						<td class="td4">
							<jsp:include page="/ServletController" flush="true">
								<jsp:param value="SYS_ATCH" name="AIR_ACTION" />
								<jsp:param value="FILE_WRITE" name="AIR_MODE" />
								<jsp:param value="<%=att_master_doc_id%>" name="masterDocId" />
								<jsp:param value="CMM" name="systemTypeCode" />
								<jsp:param value="CMM/CMM" name="typeCode" />
								<jsp:param value="N" name="requiredYn" />
								<jsp:param value="<%=att_default_master_doc_Ids%>" name="defaultMasterDocIds" />
							</jsp:include>
						</td>	
					</tr>    
			 <%--  
				   <tr>
				        <th><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.외부변호사",siteLocale)%></span></th>
				        <td class="none">
				            <div class="buttonlist">
				                <div class="left">
				                    <span class="ui_btn small icon"><span class="add"></span><a id="btnAddDaeriin" name="btnAddDaeriin" href="javascript:<%=mng_pati_hdr%>_selectDaeriin()"><%=StringUtil.getLocaleWord("B.추가",siteLocale)%></a></span>
				                    <span class="ui_btn small icon"><span class="delete"></span><a name="btnDelDaeriin" href="javascript:<%=mng_pati_hdr%>_delDaeriin()"><%=StringUtil.getLocaleWord("B.삭제",siteLocale)%></a></span>
				                    <input type="hidden" id="sol_mas_uid" name="sol_mas_uid" value="<%=sol_mas_uid%>">
				                </div>
				            </div>
				            <table id="daeriinTable" class="basic">
				            <colgroup>
				                <col style="width:10%" />             
				                <col style="width:40%" />
				                <col style="width:35%" />
				                <!-- <col style="width:15%" /> -->
				            </colgroup>     
				            <thead>
				            <tr>
				                <th style="text-align:center"><input type="checkbox" name="chk_all" id="chk_all" onclick="airCommon.toggleCheckbox('chk_wiim', this.checked)" /></th>             
				                <th style="text-align:center"><%=StringUtil.getLocaleWord("L.소속",siteLocale)%></th>
				                <th style="text-align:center"><%=StringUtil.getLocaleWord("L.변호사명",siteLocale)%></th>       
				                <th style="text-align:center"><span class="ui_icon required"><%=StringUtil.getLocaleWord("L.주요검토자",siteLocale)%></span></th>                          
				            </tr>
				            </thead>
				            <tbody id="<%=mng_pati_hdr%>DaeriinBody"></tbody>       
				            </table>
				        </td>
				    </tr>
			  --%> 
			    </table>
 			</td> 
		</tr>
	</table>
	
</form>
<div class="buttonlist">
    <span class="left" style="color:darkred;">
    	<%=StringUtil.getLocaleWord("M.변호사선택", siteLocale) %>
    </span>
    <span class="rigth">
    	<span class="ui_btn medium icon"><span class="write"></span><a href="javascript:void(0)" onclick="goProc();"><%=StringUtil.getLocaleWord("B.SAVE",siteLocale)%></a></span>
	<%if(StringUtil.isNotBlank(gt_ext_uid)){ %>
    	<span class="ui_btn medium icon"><span class="refresh"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CANCEL",siteLocale)%></a></span>
   	<%}else{ %>
    	<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="window.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
   	<%} %>
    </span>
</div>	
<script>
var goProc = function(){
	var vForm = document.form1;
	var byeonhosa = document.getElementsByName("byeonhosa_id");

<%if("SS".equals(gbn)){ %>
	if ("" == vForm.sim_cha_no.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.심급", siteLocale))%>");
		vForm.sim_cha_no.focus();
		return false;
	}
<%}%>

	if($("input:hidden[name='byeonhosa_id']").val() == ""){
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.대리인", siteLocale))%>");
		$("#btnAddDaeriin").focus();
		return false;
	}

	if ("" == vForm.PLUS_DATE.value ) {
		alert ("<%=StringUtil.getScriptMessage("M.필수_선택사항_입니다",siteLocale,StringUtil.getScriptMessage("L.위임일", siteLocale))%>");
		vForm.PLUS_DATE.focus();
		return false;
	}

	if(confirm("<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.SAVE")%>")){
		var data = $("#form1").serialize();
		airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
			
		<%if(StringUtil.isNotBlank(gt_ext_uid)){ %>
			try {
				opener.getLmsGtExtEmploy<%=sol_mas_uid%>(1);
			}catch(e) {
			}
		
			var imsiForm = $("<form method='POST'>").attr("action","/ServletController")
			imsiForm.append($("<input type='hidden' name='AIR_ACTION'>").val("<%=actionCode%>"));
			imsiForm.append($("<input type='hidden' name='AIR_MODE'>").val("POPUP_VIEW_FORM"));
			imsiForm.append($("<input type='hidden' name='sol_mas_uid'>").val("<%=sol_mas_uid%>"));
			imsiForm.append($("<input type='hidden' name='gt_ext_uid'>").val("<%=gt_ext_uid%>"));
			imsiForm.attr("target","_self");
			imsiForm.appendTo("body");
			imsiForm.submit();
			
		<%}else{ %>
			opener.getLmsGtExtEmploy<%=sol_mas_uid%>(1);
			window.close();
   		<%} %>
		});
	}
};

var doSearchUser = function(isCheckEnter) {
	
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	
	if($("#schValue").val() != "" ){
		$("#treeArea").html("");
		treeDrawChild("treeArea","", airCommon.getSearchQueryParams());
	}else{
		$("#treeArea").html("");
		treeDrawChild("treeArea","", airCommon.getSearchQueryParams());
	}
}

//-- TKDYDWK TJSXOR
var selectNode = function(code_id){
	var codGrp = $("#"+code_id); 
	var obj = codGrp.children("input:hidden");
	var jsonData = {};
	$(obj).each(function(i, d){
		jsonData[$(d).attr("name")] = $(d).val();
	});
	
	User_AddNode(JSON.stringify(jsonData));
};

/**
 * 사용자 선택 이벤트 처리
 */
 var User_AddNode = function(json)
 {
	//-- 이미 선택된 사용자인지 여부 체크!
	var data = JSON.parse(json);
	
	$("input:hidden[name='byeonhosa_id']").eq(0).val(data.login_id);
	$("input:hidden[name='byeonhosa_nam']").eq(0).val(data.name_ko);
	$("#user_name").text(data.name_ko);
	$("input:hidden[name='byeonhosa_nam_ko']").eq(0).val(data.name_ko);
	$("input:hidden[name='byeonhosa_nam_en']").eq(0).val(data.name_en);
	
	$("input:hidden[name='sosog_cod']").eq(0).val(data.group_code);
	$("input:hidden[name='sosog_nam']").eq(0).val(data.group_name_ko);
	$("#user_group").text(data.group_name_ko);
	$("input:hidden[name='sosog_nam_ko']").eq(0).val(data.group_name_ko);
	$("input:hidden[name='sosog_nam_en']").eq(0).val(data.group_name_en);
 }

$(function(){
	var arrDEPTH = [];
	//tree 불러오 air-action, air-mode 값 셋팅
	treeInitSet("SYS_USER","JSON_TREE_LIST","USER",JSON.stringify(arrDEPTH),'OG');
	//그려넣을 id, 루트id, 최종 
	treeDrawChild("treeArea","",airCommon.getSearchQueryParams());
});
</script>