<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%@ page import="com.emfrontier.air.lms.config.LmsConstants"%>
<%@ page import="com.emfrontier.air.lms.util.LmsUtil" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	boolean isBeobmuTeamUser	= LmsUtil.isBeobmuTeamUser(loginUser); 
	
	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String page_no 				= requestMap.getString(CommonConstants.PAGE_NO);
	String page_rowsize 		= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String schGubunCode			= requestMap.getString("SCHGUBUNCODE");
	String schTypeCode			= requestMap.getString("SCHTYPECODE");
	String schTypeCodeSub       = requestMap.getString("SCHTYPECODESUB");
	String schField				= requestMap.getString("SCH_COL");
	String schValue				= requestMap.getString("SCH_VAL");
	
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);	
	SQLResults totalResult 		= resultMap.getResult("TOTAL_SEARCH");	
	SQLResults BOARD_LIST 		= resultMap.getResult("BOARD_LIST");	
	
	//-- 파라메터 셋팅
	String action_code 		= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code 		= resultMap.getString(CommonConstants.MODE_CODE);

	String schGubunCodeStr = "|"+StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale)+"^GY|"+StringUtil.getLocaleWord("L.계약",siteLocale)+"^JM|"+StringUtil.getLocaleWord("L.자문",siteLocale)+"^SS|"+StringUtil.getLocaleWord("L.소송분쟁",siteLocale)+"^GT|"+StringUtil.getLocaleWord("L.기타",siteLocale);
	String schTypeCodeStr = "|"+StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	String schTypeCodeSubStr = "|"+StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale);
	String schFieldCodestr =  "ALL|" + StringUtil.getLocaleWord("L.CBO_ALL2",siteLocale)+"^TITLE|"+StringUtil.getLocaleWord("L.제목",siteLocale)+"^CONTENT|"+StringUtil.getLocaleWord("L.내용",siteLocale);

%>
<script type="text/javascript">
function doReset(frm) {
	if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_RESETSEARCHITEMS",siteLocale)%>")) {
		frm.reset();
		// 검색된 후의 input 값은 reset 으로 사라지지 않아 다음 초기화 로직 추가.
	    var inputs = frm.getElementsByTagName("input");
	    for(var i=0; i<inputs.length; i++){
	        var input=inputs.item(i);
	        if(input.type=='text')
	        	input.value = '';	
	    }
	}	    
};

var goView = function(uuid,board_cd) {
    var url = "/ServletController";
	url += "?AIR_ACTION=<%=action_code%>";
	url += "&AIR_MODE=POPUP_VIEW";
	url += "&UUID="+uuid;
	url += "&BOARD_CD="+board_cd;
	
	airCommon.openWindow(url, "1024", "700", "POPUP_VIEW", "yes", "yes", "");	
 };

/**
 * 검색 수행
 */	
var doSearch = function(frm, isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {			
		return;
	}
	$("#BOARD_CD").val("");
	$("#TYPE_CD1").val("");
	getDetailList(frm);
};

var viewDetail = function(board_cd, type_cd1, cnt){
	if("0" != cnt){
		$("#BOARD_CD").val(board_cd);
		$("#TYPE_CD1").val(type_cd1);
		getDetailList(document.form1);
	}else{
		$("#detailBody").html("<%=StringUtil.getLocaleWord("M.검색결과가없습니다",siteLocale)%>");
	}
};

var getDetailList = function(frm){
	$.ajax({
		url: "/ServletController"
		, type: "POST"
		, async: true
		, cache: false
		, data: $(frm).serialize()
		, dataType: "json"
	}).done(function(data){ 
		if(data.rows !="" ){
			$("#detailBody").html("");
			$("#detailTmpl").tmpl(data.rows).appendTo($("#detailBody"));
		}else{
			$("#detailBody").html("<%=StringUtil.getLocaleWord("M.검색결과가없습니다",siteLocale)%>");
		} 
		
	}).fail(function(){
		alert("<%=StringUtil.getScriptMessage("M.에러처리", siteLocale)%>");
	});
};
</script>
<script id="detailTmpl" type="text/html">
<table class="list" style="margin:0px 0px 10px 0px;">
	<colgroup>
		<col style="width:auto;" />
		<col style="width:15%;" />
		<col style="width:10%;" />
	</colgroup>
	<tr>
		<td colspan="3" style="padding-left:8px; background-color:#EEEEEE;"><b>\${BOARD_NM}</b> > \${TYPE_NM} </td>
	</tr>
	<tr>
		<td style="padding-left:8px;"><a href="javascript:void(0);" onclick="javascript:goView('\${UUID}','\${BOARD_CD}')">\${TITLE}</a></td>
		<td style="text-align:center">\${REG_NAM}</td>
		<td style="text-align:center">\${REG_DTE}</td>
	</tr>
	<tr style="min-height:80px;">
		<td colspan="4" style="padding-left:8px; vertical-align:top; ">{{html CONTENT.split("\n").join('<br>')}}</td>
	</tr>
{{if FILE_UID != ""}}
	<tr>
		<td colspan="4" style="padding-left:8px;">{{html FILE_NAME}}</td>
	</tr>
{{/if}}

<table>
</script>
<style>
	div .total_srch {font-size:16px; }
	div .total_srch .total_srch_subject {font-weight:bold; color:#002eb8;}
	div .total_srch .total_srch_name {font-size:12px; color:#7d7d7d;}
	div .total_srch .total_srch_date {font-size:12px; color:#4c4c4c;}
	div .total_srch .total_srch_menu {font-size:12px; color:#858585; display:inline-block; float:right;}
	div .total_srch .total_srch_content {font-size:12px; color:#4f4f4f;}
</style>
<div id="listTabsLayer" class="easyui-tabs" data-options="border:false,plain:true" style="width:auto;height:auto">
	<div id="listTabs-LIST" title="<%=StringUtil.getLocaleWord("L.법무DB검색", loginUser.getSiteLocale()) %>" style="padding-top:5px" data-options="selected:true">
		<form name="form1" method="post" onSubmit="return false;">	
			<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=action_code%>" />
			<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="JSON_LIST" />
			<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=page_no%>" />
			<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>" value="<%=page_rowsize%>" />
			<input type="hidden" name="BOARD_TYPE" id="BOARD_TYPE" value="LMS_BBS_LEGALDB" />
			<input type="hidden" name="BOARD_CD" id="BOARD_CD" />
			<input type="hidden" name="TYPE_CD1" id="TYPE_CD1" />
			
			<!-- 검색창 시작 -->
			<table class="box">
				<tr>
					<td class="corner_lt"></td>
					<td class="border_mt"></td>
					<td class="corner_rt"></td>
				</tr>
				<tr>
					<td class="border_lm"></td>
					<td class="body">
						<table>
							<colgroup>
								<col style="width: 10%;" />
								<col style="width: auto;" />
								<col style="width: 14%;" />
							</colgroup>
							<tr>
								<th><%=HtmlUtil.getSelect(request, true, "SCH_COL", "SCH_COL", schFieldCodestr, schField, "class=\"select width_max_select\" data-type=\"search\" style='width:100%;'")%></th>
								<td><input type="text" name="SCH_VAL" id="SCH_VAL" data-type="search" onkeydown="doSearch(document.form1, true)" maxlength="50" class="text" style="width:100%;" /></td>
								<td class="verticalContainer">
									<span class="ui_btn medium icon"><span class="cancel"></span><a href="javascript:void(0)" onclick="doReset(document.form1);"><%=StringUtil.getLocaleWord("B.INIT",siteLocale)%></a></span>
									<span class="separ"></span> <span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch(document.form1);"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
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
			<!-- 검색창 끝 -->
		</form>

		<table class="basic" style="margin-top:5px;">
		<colgroup>
<%
	if(BOARD_LIST != null && BOARD_LIST.getRowCount() > 0){
		int width = 100/BOARD_LIST.getRowCount();
		for(int i=0; i< BOARD_LIST.getRowCount(); i++){
%>			
			<col style="width:<%=width%>%">
<%
		}
	}	
%>
		</colgroup>
		<tr>
<%
	if(BOARD_LIST != null && BOARD_LIST.getRowCount() > 0){
		for(int i=0; i< BOARD_LIST.getRowCount(); i++){
%>			
			<th style="text-align:center"><%=StringUtil.convertNull(BOARD_LIST.getString(i, "NAME_KO")) %></th>
<%
		}
	}	
%>			
		<tr>
<%
	if((BOARD_LIST != null && BOARD_LIST.getRowCount() > 0) &&(totalResult != null && totalResult.getRowCount() > 0)){
		for(int i=0; i< BOARD_LIST.getRowCount(); i++){
%>			
		<td style="vertical-align: top">
			<table class="none" >
<%
			String board_cd = BOARD_LIST.getString(i, "CODE_ID");
			for(int j=0; j< totalResult.getRowCount(); j++){
				String parent_code_id = StringUtil.convertNull(totalResult.getString(j, "PARENT_CODE_ID"));
				String code_id = StringUtil.convertNull(totalResult.getString(j, "CODE_ID"));
				if(board_cd.equals(parent_code_id)){
%>
			<tr><td><a href="javascript:void(0)" onClick="javascript:viewDetail('<%=parent_code_id%>','<%=code_id%>','<%=totalResult.getString(j, "CNT")%>');">
					<%=StringUtil.convertNull(totalResult.getString(j, "NAME_KO")) %>(<%=totalResult.getString(j, "CNT") %>)
			</a></td></tr>
<%
				}
			}
%>			
			</table>
		</td>
<%
		}
	} %> 
		</tr>
		</table>
		<p style="height:10px;"></p>
		
		<div id="detailView">
			<div id="detailBody"></div>
		</div>
			 		  
	</div>
</div>