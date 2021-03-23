<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>
<%@ page import="com.emfrontier.air.common.bean.*" %>
<%@ page import="com.emfrontier.air.common.config.*" %>
<%@ page import="com.emfrontier.air.common.jdbc.*" %>
<%@ page import="com.emfrontier.air.common.model.*" %>
<%@ page import="com.emfrontier.air.common.util.*" %>
<%
	//-- 로그인 사용자 정보 셋팅
	SysLoginModel loginUser 	= (SysLoginModel)request.getSession().getAttribute(CommonConstants.SESSION_USER);
	String siteLocale			= loginUser.getSiteLocale();
	
	//-- 검색값 셋팅
	BeanResultMap requestMap 	= (BeanResultMap)request.getAttribute(CommonConstants.REQUEST);
	String pageNo 				= requestMap.getString(CommonConstants.PAGE_NO);
	String pageRowSize 			= requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	
	String callbackFunction		= StringUtil.convertNull(requestMap.getString("CALLBACKFUNCTION"));
	String initFunction			= StringUtil.convertNull(requestMap.getString("INITFUNCTION"));
    String schGroupName			= StringUtil.convertNull(requestMap.getString("SCHGROUPNAME"));
	String typeCodes			= StringUtil.convertNull(requestMap.getString("TYPECODES"));
	String groupTypeCodes		= StringUtil.convertNull(requestMap.getString("GROUPTYPECODES"));
	
	
	String typeName			    = requestMap.getString("TYPENAME");
    String rootCodeId			= requestMap.getString("ROOTCODEID");
    String defaultSet			= requestMap.getString("DEFAULTSET");
    String multiChk				= requestMap.getString("MULTICHK");
    
    defaultSet = "Y";
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults viewResult		= resultMap.getResult("VIEW"); 
	
	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);
    
	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE",  "|" + StringUtil.getLocaleWord("L.CBO_ALL",siteLocale));
	
	String groupCdPath = loginUser.getGroupUuidPath();

    String[] arrGroupPath = StringUtil.split(groupCdPath, CommonConstants.SEPAR_CONNECTPATH);
%>
<script type="text/javascript">
	var jsonData = {"ISNULL(PARENT_DEPT_CD,'')":"", "HOESA_COD":"<%=loginUser.gethoesaCod()%>"};
	
	 /**
	  * 확인 처리
	  */
	 function doConfirm(frm) {
		 
		 
		var rowsDpt = $("td[data-meaning='data_td']");
		 
		 //-- 결재자 정보 수집
		var data = [];
		$(rowsDpt).each(function(i, td){
		
			var $input = $("input:hidden", $(td));
			var rowData = {};
			$input.each(function(j, e){
				rowData[$(e).attr("name").toUpperCase()] = $(e).val(); 
			});
			data.push(rowData);
		});
		
		 
		if(opener){
			opener.<%=callbackFunction%>(JSON.stringify(data));
		
		} else {
			
			parent.<%=callbackFunction%>(JSON.stringify(data));
		}
	 	
		self.close();
	 }
	 
	 /**
	  * 선택된 참조부서 삭제
	  */
	 function Group_deleteNode(uuid) {
		 
		 $("#sel_"+uuid).remove();
		 
	 }
	 var doSearch = function(isCheckEnter) {
		if (isCheckEnter && event.keyCode != 13) {			
			return;
		}
		if($("#schValue").val() != ""){
			var schData = {"NAME_KO":$("#schValue").val(),"USR_SEQ":$("#schField").val(), "HOESA_COD":$("#hoesa_cod").val()};
			$("#treeArea").html("");
			treeDrawChild("treeArea","", airCommon.getSearchQueryParams());
		}else{
			$("#treeArea").html("");
			jsonData.HOESA_COD = $("#hoesa_cod").val();
			treeDrawChild("treeArea","", airCommon.getSearchQueryParams());
		}
	}
</script>
<script id="addAprvUserTmpl" type="text/x-jquery-tmpl">
<tr data-meaning="apvr_tr" id="sel_\${CODE}">
	<td align="center" data-meaning="data_td">
		<a href="javascript:void(0);" onClick="Group_deleteNode('\${CODE}');"><img src="/common/_images/del.gif"></a>
		<input type="hidden" name="code"  value="\${CODE}">
        <input type="hidden" name="parent_code" value="\${PARENT_CODE}">
		<input type="hidden" name="uuid"  value="\${UUID}">
		<input type="hidden" name="name_ko" value="\${NAME_KO}">
		<input type="hidden" name="name_en" value="\${NAME_EN}">
        <input type="hidden" name="parent_name_ko" value="\${PARENT_NAME_KO}">
        <input type="hidden" name="parent_name_en" value="\${PARENT_NAME_EN}">
        <input type="hidden" name="name_path_ko" value="\${NAME_PATH_KO}">
        <input type="hidden" name="name_path_en" value="\${NAME_PATH_EN}">
	</td>
	<td align="center" style="height:28px;">
			\${NAME_KO}
	</td>
</tr>
</script>
<form name="form1" method="post" onsubmit="return false;">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="callbackFunction" value="<%=callbackFunction%>" />
    <input type="hidden" name="typeCodes" value="<%=typeCodes %>" />
    <input type="hidden" name="schGroupName" value="<%=schGroupName %>" />
	
	<table class="none">
		<colgroup>
			<col width="50%" />
			<col width="2%" />
			<col width="48%" />
		</colgroup>
		<tr>
			<td align="left" valign="top">
				
				
				<table class="basic">
				<caption><%=StringUtil.getLocaleWord("L.부서선택", siteLocale) %></caption>
					<tr>
						<td>
						<div class="table_cover">
							<table class="box">
								<tr>
									<td width="80%">
										<input type="text" name="schValue" id="schValue" value=""  class="text width_max" data-type="search" placeholder="Name Search"  onkeydown="doSearch(true)" />
									</td>
									<td rowspan="3" style="text-align: center;">
					            			<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();" ><%=StringUtil.getLocaleWord("L.검색",siteLocale)%></a></span>
				            		</td>
				            	</tr>
							</table>
						</div>
						<div id="treeArea" style="width:98%;height:342px;vertical-align: top;border:1px solid #CDCDCD;overflow: auto;"></div>
						</td>
					</tr>
				</table>
			</td>
			<td>&nbsp;</td>
			<td align="right" valign="top">				
				<table class="basic">
					<caption>
						<%=StringUtil.getLocaleWord("L.부서", siteLocale) %>				
					</caption>
					<tr>
						<td>
							<div style="height:372px; overflow-y:auto;">
								<table class="list" style="width:98%;">									
									<colgroup>
										<col width="8%" />
										<col width="*" />
									</colgroup>									
									<thead>
									<tr>
										<th style="height:28px;"></th>
										<th style="height:28px;"><%=StringUtil.getLocaleWord("L.부서",siteLocale)%></th>
									</tr>
									</thead>																	
									<tbody id="tbodyGroupList"></tbody>
								</table>
							</div>																				
						</td>
					</tr>
					</tbody>
				</table>				
			</td>			
		</tr>
	</table>	
</form>
<script>
/**
 * 사용자 선택 이벤트 처리
 */
 function Group_AddNode(json)
 {
	if(chkUserId(json)){
		var data = JSON.parse(json);
		//-- 이미 선택된 사용자인지 여부 체크!
		if(data.length > 0){
			 if("N" == "<%=multiChk%>"){
				 $("#tbodyGroupList").html("");
			 }
			$("#addAprvUserTmpl").tmpl(data).appendTo("#tbodyGroupList");
		}
	}
 }
 /**
 *	같은 사용자 선택 했는지 체크
 */
 function chkUserId(json){
	 if (json !== null && typeof json === 'string' && json !== '') {
		 var rtnBool = true;
		 var data = JSON.parse(json);
		 var arrObj = $("input:hidden[name='CODE']");
		 arrObj.each(function(i, d){
			 if(data[0].code == $(this).val()){
				 rtnBool = false;
			 }
		 });
		 return rtnBool;
	 } else{
		 return false;
	 }
	 
 }


var selectNode = function(code_id){

	var codGrp = $("#"+code_id); 
	var obj = codGrp.children("input:hidden");
	var jsonData = {};
	$(obj).each(function(i, d){
		jsonData[$(d).attr("name").toUpperCase()] = $(d).val();
	});
	var data = [];
	data.push(jsonData);
	Group_AddNode(JSON.stringify(data));
	
};

$(function(){
	var arrDEPTH = [];
	
	<%
		int cnt = 0;
		if("Y".equals(defaultSet) && arrGroupPath != null){
	%>
	<%
			for(int i=0; i< (arrGroupPath.length-2); i++){
				cnt++;
	%>
		arrDEPTH.push("<%=arrGroupPath[i]%>");
	<%
			}
	%>
	<%
		}
	%>
		//tree 불러오 air-action, air-mode 값 셋팅
		treeInitSet("SYS_GROUP","GROUP_TREE_JSON","GROUP",JSON.stringify(arrDEPTH),'<%=groupTypeCodes%>');
		
		//그려넣을 id, 루트id, 최종 
	    treeDrawChild("treeArea","",JSON.stringify(jsonData));
<%
	if(StringUtils.isNotBlank(initFunction)){
%>
	Group_AddNode(opener.<%=initFunction%>());
<%
	}
%>
	});


</script>
<div class="buttonlist">
	<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doConfirm(document.form1);" ><%=StringUtil.getLocaleWord("B.CONFIRM",siteLocale)%></a></span>
</div>
	