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
    String userType             = requestMap.getString("USERTYPE");
	String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");
	String signTypeCode			= requestMap.getString("SIGNTYPECODE");
	String signTypeName			= requestMap.getString("SIGNTYPENAME");
	String signUserCodestr		= requestMap.getString("SIGNUSERCODESTR");
	String jeongyeonAbleYn		= requestMap.getString("JEONGYEONABLEYN");
	String groupTypeCodes		= requestMap.getString("GROUPTYPECODES");
	String rootCodeId			= requestMap.getString("ROOTCODEID");
	String defaultSet			= requestMap.getString("DEFAULTSET");
	String multiSelect			= requestMap.getDefStr("MULTISELECT","Y");

	groupTypeCodes		= request.getParameter("groupTypeCodes");
	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);
	SQLResults aprLine		= resultMap.getResult("APR_LINE");
	SQLResults referral		= resultMap.getResult("REFERRAL");

	//-- 파라메터 셋팅
	String actionCode 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode 			= resultMap.getString(CommonConstants.MODE_CODE);

    String tit                  = "";
    String select               = "";
   /*  if("chamjo".equals(userType)){
        tit = StringUtil.getLocaleWord("L.참조자", siteLocale);
    }else if("susinja".equals(userType)) {
   	 	tit = StringUtil.getLocaleWord(Label.수신자, siteLocale);
    }else {
   		 tit = StringUtil.getLocaleWord(Label.사용자, siteLocale);
    } */
 	tit = StringUtil.getLocaleWord("L.사용자", siteLocale);
 	select = StringUtil.getLocaleWord("L.선택", siteLocale);

	String HOESA_CODESTR = StringUtil.getCodestrFromSQLResults(resultMap.getResult("HOESA_LIST"), "CODE_ID,LANG_CODE",  "|" + StringUtil.getLocaleWord("S.전체",siteLocale));

	String groupCdPath = loginUser.getGroupUuidPath();

    String[] arrGroupPath = StringUtil.split(groupCdPath, CommonConstants.SEPAR_CONNECTPATH);

    String schFieldCodestr 		= "0|"+StringUtil.getLocaleWord("L.성명", siteLocale)+"^1|"+StringUtil.getLocaleWord("L.부서", siteLocale);
%>
<form name="form1" method="post" onsubmit="return false;">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>" value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
	<input type="hidden" name="callbackFunction" value="<%=callbackFunction%>" />
	<input type="hidden" name="signTypeCode" value="<%=signTypeCode%>" />
	<input type="hidden" name="signUserCodestr" value="<%=signUserCodestr%>" />
	<input type="hidden" data-type="search" name="rootCodeId" value="<%=rootCodeId%>" />

	<table style="width:100%;">
		<colgroup>
			<col width="40%" />
			<col width="10%" />
			<col width="40%" />
		</colgroup>
		<tr>
			<td align="left" valign="top">
				<table class="basic">
				<caption><%=tit%> <%=select %></caption>
					<tr>
						<td>
						<div class="table_cover">
							<table class="box">
								<tr>
									<%-- <th width="15%"><%=HtmlUtil.getSelect(request,  true, "USR_SEQ", "USR_SEQ", schFieldCodestr, "", "data-type=\"search\"")%></th>	 --%>
									<td width="80%">
										<input type="text" name="schValue" id="schValue" value=""  class="text width_max" data-type="search" placeholder="Name Search"  onkeydown="doSearch(true)" maxlength="30" />
										<%if("INVENT".equals(userType)){ %>
											<input type="hidden" name="userType" id="userType" data-type="search" value="<%=userType%>"/>
										<%} %>
									</td>
									<td rowspan="3" style="text-align: center;">
					            			<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();" ><%=StringUtil.getLocaleWord("L.검색",siteLocale)%></a></span>
				            		</td>
				            	</tr>
							</table>
						</div>
						<div id="treeArea" style="width:98%;height:444px;vertical-align: top;border:1px solid #CDCDCD;overflow: auto;"></div>
						</td>
					</tr>
				</table>

			</td>
			<td style="padding-left:15px;">
				<input type="radio" name="aprType" value="G" checked/><%=StringUtil.getLocaleWord("L.승인", siteLocale)%><br/>
				<input type="radio" name="aprType" value="H"/><%=StringUtil.getLocaleWord("L.합의", siteLocale)%><br/>
<%-- 		<input type="radio" name="aprType" value="B"/>합의(병렬)<br/> --%>
<!-- 				<input type="radio" name="aprType" value="C"/>참조처 -->
			</td>
			<td align="right" valign="top">
				<div style="width:98%;vertical-align: top;border:1px solid #CDCDCD;overflow: auto;">
				<table class="basic">
					<caption>
						<%=tit%>
					</caption>
					<tr>
						<td>
							<div class="table_cover" style="height:476px;">
								<table class="list" style="width:98%">
									<colgroup>
										<col width="4%" />
										<col width="18%" />
										<col width="*" />
										<col width="4%" />
										<col width="4%" />
									</colgroup>
									<thead>
									<tr>
										<th colspan="1"></th>
										<th><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
										<th><%=StringUtil.getLocaleWord("L.결재자정보",siteLocale)%></th>
										<th colspan="2"></th>
									</tr>
									</thead>
									<tbody id="tbodyUserList">

<%
	if(aprLine != null && aprLine.getRowCount()> 0){
		for(int i=0; i< aprLine.getRowCount(); i++){
			String login_id 	= aprLine.getString(i, "login_id");
			String user_no	 	= aprLine.getString(i, "user_no");
			String uuid			= aprLine.getString(i, "uuid");
			String name				= aprLine.getString(i, "name_ko");
			String name_ko			= aprLine.getString(i, "name_ko");
			String name_en			= aprLine.getString(i, "name_en");
			String position_name			= aprLine.getString(i, "position_name_KO");
			String position_name_ko			= aprLine.getString(i, "position_name_ko");
			String position_name_en			= aprLine.getString(i, "position_name_en");
			String position_code			= aprLine.getString(i, "position_code");
			String group_name				= aprLine.getString(i, "group_name_KO");
			String group_name_ko			= aprLine.getString(i, "group_name_KO");
			String group_name_en			= aprLine.getString(i, "group_name_en");
			String parent_group_name_ko			= aprLine.getString(i, "parent_group_name_ko");
			String group_code			= aprLine.getString(i, "group_code");
			String group_uuid			= aprLine.getString(i, "group_uuid");
			String address_ko			= aprLine.getString(i, "address_ko");
			String address_en			= aprLine.getString(i, "address_en");
			String telephone_no			= aprLine.getString(i, "telephone_no");
			String email				= aprLine.getString(i, "email");
			String hoesa_cod			= aprLine.getString(i, "hoesa_cod");
			String apr_type				= aprLine.getString(i, "apr_type");
			
			if(StringUtil.isBlank(apr_type)){
				if(i == 0)apr_type = "S";
				else if(i > 0)apr_type = "G";
			}
			
%>
									<tr data-meaning="apvr_tr" id="sel_<%=uuid%>">
										
										<td align="center" >
										<%if(i > 0){ %>
											<a href="javascript:void(0);" onClick="User_DeleteNode('<%=uuid%>','tbodyUserList');"><img src="/common/_images/del.gif"></a>
										<%} %>
										</td>
										<td style="text-align:center" data-meaning="data_td">
										<%if("S".equals(apr_type)){ %>
											<%=StringUtil.getLocaleWord("L.DRAFT", siteLocale)%>
										<%}else if("G".equals(apr_type)){ %>
											<%=StringUtil.getLocaleWord("L.승인", siteLocale)%>
										<%}else if("H".equals(apr_type)){ %>
											<%=StringUtil.getLocaleWord("L.승인", siteLocale)%>
										<%}else if("B".equals(apr_type)){ %>
											<%=StringUtil.getLocaleWord("L.승인", siteLocale)%>
										<%} %>
									        <input type="hidden" name="uuid" value="<%=uuid%>"/>
											<input type="hidden" name="apr_type" value="<%=apr_type%>"/>
									        <input type="hidden" name="user_no" value="<%=user_no%>"/>
											<input type="hidden" name="name_ko" value="<%=name_ko%>"/>
											<input type="hidden" name="login_id" value="<%=login_id%>"/>
											<input type="hidden" name="position_code" value="<%=position_code%>"/>
											<input type="hidden" name="position_name_ko" value="<%=position_name_ko%>"/>
											<input type="hidden" name="position_name_en" value="<%=position_name_en%>"/>
											<input type="hidden" name="group_name_ko" value="<%=group_name_ko%>"/>
											<input type="hidden" name="group_name_en" value="<%=group_name_en%>"/>
											<input type="hidden" name="group_code" value="<%=group_code%>"/>
											<input type="hidden" name="group_uuid" value="<%=group_uuid%>"/>
											<input type="hidden" name="telephone_no" value="<%=telephone_no%>"/>
											<input type="hidden" name="email" value="<%=email%>"/>
									        <input type="hidden" name="hoesa_cod" value="<%=hoesa_cod%>"/>
										</td>
										<td style="text-align:left"><%=group_name_ko%> <%=name%> <%=position_name%></td>
										<td align="center" >
											<a href="javascript:void(0);" data-meaning="btn_move_up" onClick="moveRow('tbodyUserList', 'up', this);">▲</a>
										</td>
										<td align="center">
											<a href="javascript:void(0);" data-meaning="btn_move_down" onClick="moveRow('tbodyUserList', 'down', this);">▼</a>
										</td>
									</tr>
<%
		}
	}
%>

									</tbody>
								</table>
							</div>
							
						</td>
					</tr>
					</tbody>
				</table>
				</div>
				<%-- <table class="basic">
					<caption>
						참조처
					</caption>
					<tr>
						<td>
							<div class="table_cover" style="height:220px;">
								<table class="list" style="width:98%">
									<colgroup>
										<col width="4%" />
										<col width="18%" />
										<col width="*" />
									</colgroup>
									<thead>
									<tr>
										<th colspan="1"></th>
										<th><%=StringUtil.getLocaleWord("L.구분",siteLocale)%></th>
										<th><%=StringUtil.getLocaleWord("L.결재자정보",siteLocale)%></th>
									</tr>
									</thead>
									<tbody id="tbodyRefList">

<%
	if(referral != null && referral.getRowCount()> 0){
		for(int i=0; i< referral.getRowCount(); i++){
			String login_id 	= referral.getString(i, "login_id");
			String user_no	 	= referral.getString(i, "user_no");
			String uuid			= referral.getString(i, "uuid");
			String name				= referral.getString(i, "name_"+siteLocale);
			String name_ko			= referral.getString(i, "name_ko");
			String name_en			= referral.getString(i, "name_en");
			String position_name			= referral.getString(i, "position_name_"+siteLocale);
			String position_name_ko			= referral.getString(i, "position_name_ko");
			String position_name_en			= referral.getString(i, "position_name_en");
			String position_code			= referral.getString(i, "position_code");
			String group_name				= referral.getString(i, "group_name_"+siteLocale);
			String group_name_ko			= referral.getString(i, "group_name_"+siteLocale);
			String group_name_en			= referral.getString(i, "group_name_en");
			String group_code				= referral.getString(i, "group_code");
			String group_uuid				= referral.getString(i, "group_uuid");
			String telephone_no				= referral.getString(i, "telephone_no");
			String email					= referral.getString(i, "email");
			String hoesa_cod				= referral.getString(i, "hoesa_cod");
			String apr_type				= aprLine.getString(i, "apr_type");
			
			if(StringUtil.isBlank(apr_type)){
				apr_type = "C";
			}
%>
									<tr data-meaning="apvr_tr" id="sel_<%=uuid%>">
										<td align="center" >
											<a href="javascript:void(0);" onClick="User_DeleteNode('<%=uuid%>','tbodyRefList');"><img src="/common/_images/close_popup.gif"></a>
										</td>
										<td style="text-align:center" data-meaning="data_td" >
												<%=StringUtil.getLocaleWord("L.참조", siteLocale)%>
									        <input type="hidden" name="uuid" value="<%=uuid%>"/>
									        <input type="hidden" name="apr_type" value="<%=apr_type%>"/>
									        <input type="hidden" name="user_no" value="<%=user_no%>"/>
											<input type="hidden" name="name_ko" value="<%=name_ko%>"/>
											<input type="hidden" name="login_id" value="<%=login_id%>"/>
											<input type="hidden" name="position_code" value="<%=position_code%>"/>
											<input type="hidden" name="position_name_ko" value="<%=position_name_ko%>"/>
											<input type="hidden" name="position_name_en" value="<%=position_name_en%>"/>
											<input type="hidden" name="group_name_ko" value="<%=group_name_ko%>"/>
											<input type="hidden" name="group_name_en" value="<%=group_name_en%>"/>
											<input type="hidden" name="group_code" value="<%=group_code%>"/>
											<input type="hidden" name="group_uuid" value="<%=group_uuid%>"/>
											<input type="hidden" name="telephone_no" value="<%=telephone_no%>"/>
											<input type="hidden" name="email" value="<%=email%>"/>
									        <input type="hidden" name="hoesa_cod" value="<%=hoesa_cod%>"/>
										</td>
										<td style="text-align:left"><%=group_name_ko%> <%=name%> <%=position_name%></td>
									</tr>
<%
		}
	}
%>

									</tbody>
								</table>
							</div>
							
						</td>
					</tr>
					</tbody>
				</table> --%>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<input type="checkbox" name="none_apr_yn" id="none_apr_yn" value="Y" onclick="noneCheckApr();"><label for="none_apr_yn">전결처리</label>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<table class="basic">
					<tr>
						<th class="th2"><%=StringUtil.getLocaleWord("L.의견", siteLocale) %></th>
						<td class="td2"><textarea rows="3" class="text width_max" name="apr_memo" id="apr_memo"></textarea> </td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<div class="buttonlist">
	<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doConfirm(document.form1);" ><%=StringUtil.getLocaleWord("L.확인",siteLocale)%></a></span>
</div>
<script id="addAprvUserTmpl" type="text/x-jquery-tmpl">
<tr data-meaning="apvr_tr" id="sel_\${UUID}">
	<td align="center" >
{{if APR_TYPE == "C" }}
		<a href="javascript:void(0);" onClick="User_DeleteNode('\${UUID}','tbodyRefList');"><img src="/common/_images/del.gif"></a>
{{else}}
		<a href="javascript:void(0);" onClick="User_DeleteNode('\${UUID}','tbodyUserList');"><img src="/common/_images/del.gif"></a>
{{/if}}
	</td>
	<td align="center">
		{{if APR_TYPE == "G" }}
			<%=StringUtil.getLocaleWord("L.승인", siteLocale)%>
		{{else APR_TYPE == "H"}}
			<%=StringUtil.getLocaleWord("L.합의", siteLocale)%>
		{{else APR_TYPE == "B"}}
			<%=StringUtil.getLocaleWord("L.병렬합의", siteLocale)%>
		{{else APR_TYPE == "C"}}
			<%=StringUtil.getLocaleWord("L.참조", siteLocale)%>
		{{/if}}
	</td>
	<td style="text-align:left" data-meaning="data_td">
		\${GROUP_NAME_KO} \${NAME_KO} \${POSITION_NAME_KO}
		<input type="hidden" name="uuid" value="\${UUID}"/>
		<input type="hidden" name="apr_type" value="\${APR_TYPE}"/>
		<input type="hidden" name="user_no" value="\${USER_NO}"/>
		<input type="hidden" name="name_ko" value="\${NAME_KO}"/>
		<input type="hidden" name="name_en" value="\${NAME_EN}"/>
		<input type="hidden" name="login_id" value="\${LOGIN_ID}"/>
		<input type="hidden" name="position_code" value="\${POSITION_CODE}"/>
		<input type="hidden" name="position_name_ko" value="\${POSITION_NAME_KO}"/>
		<input type="hidden" name="position_name_en" value="\${POSITION_NAME_EN}"/>
		<input type="hidden" name="group_name_ko" value="\${GROUP_NAME_KO}"/>
		<input type="hidden" name="group_name_en" value="\${GROUP_NAME_EN}"/>
		<input type="hidden" name="group_code" value="\${GROUP_CODE}"/>
		<input type="hidden" name="group_uuid" value="\${GROUP_UUID}"/>
		<input type="hidden" name="telephone_no" value="\${TELEPHONE_NO}"/>
		<input type="hidden" name="email" value="\${EMAIL}"/>
		<input type="hidden" name="hoesa_cod" value="\${HOESA_COD}"/>
	</td>
{{if APR_TYPE != "C" }}
	<td align="center" >
		<a href="javascript:void(0);" data-meaning="btn_move_up" onClick="moveRow('tbodyUserList', 'up', this);">▲</a>
	</td>
	<td align="center">
		<a href="javascript:void(0);" data-meaning="btn_move_down" onClick="moveRow('tbodyUserList', 'down', this);">▼</a>
	</td>
{{/if}}
</tr>
</script>
<script type="text/javascript">
var jsonData = {};
//-- 전결처리 이벤트 
var noneCheckApr = function(){
	if($("#none_apr_yn").is(":checked")){
		var msg = "<%=StringUtil.getScriptMessage("M.전결알림", siteLocale)%>";
		if(confirm(msg)){
			$("tr", "#tbodyUserList").each(function(i, o){
				if(i == 0) return true;
				$(o).remove();
			});	
		}else{
			$("#none_apr_yn").prop("checked",false);
		}
	}
}

/**
 * 테이블 위 아래 이동
 */
function moveRow(id, act, obj)
{
	var idx = -1;

	var o_tbl = document.getElementById(id);
	var o_btn = $("a[data-meaning='btn_move_"+act+"']");// document.getElementsByName("btn_move_" + act);

	for (var i = 1; i < o_btn.length; i++)
	{
		if (o_btn[i] == obj)
		{
			switch (act)
			{
				case "up":
					if (i == 1) return;

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
}

var doSearch = function(isCheckEnter) {
	if (isCheckEnter && event.keyCode != 13) {
		return;
	}

	if($("#schValue").val() != "" ){
		var schData = {"NAME_KO":$("#schValue").val(),"USR_SEQ":$("#schField").val(), "HOESA_COD":$("#hoesa_cod").val()};
		$("#treeArea").html("");
		treeDrawChild("treeArea","", airCommon.getSearchQueryParams());
	}else{
		$("#treeArea").html("");
		treeDrawChild("treeArea","",airCommon.getSearchQueryParams());
	}
}
/**
 * 사용자 선택 이벤트 처리
 */
 function User_AddNode2(json)
 {
	
	var tbody = "tbodyUserList";
	if("C" == $("input:radio[name='aprType']:checked").val()){
		tbody = "tbodyRefList";
	}
	//-- 이미 선택된 사용자인지 여부 체크!
	if(chkUserId(json, tbody)){
		var data = JSON.parse(json);
		 if("N" == "<%=multiSelect%>"){
			 $("#"+tbody).html("");
		 }
		$("#addAprvUserTmpl").tmpl(data).appendTo("#"+tbody);
	}


 }
 /**
 *	같은 사용자 선택 했는지 체크
 */
 function chkUserId(json, tbody){
	 var data = JSON.parse(json);
	 var arrObj = $("input:hidden[name='uuid']","#"+tbody);
	 var rtnBool = true;
	 arrObj.each(function(i, d){
		 if(data.UUID == $(d).val()){
			 rtnBool = false;
		 }
	 });

	 return rtnBool;

 }

 /**
  * 참조자 삭제
  */
 function User_DeleteNode(uuid, tar_id) {
	 
	 
	 $("#sel_"+uuid, "#"+tar_id).remove();
	 

 }

 /**
  * 확인 처리
  */
 function doConfirm(frm) {
	 
	 var rowsApr = $("td[data-meaning='data_td']", "#tbodyUserList");
	 var rowsRef = $("td[data-meaning='data_td']", "#tbodyRefList");
	 
	 var data = {};
	 //-- 결재자 정보 수집
	 var arrApr = [];
	 $(rowsApr).each(function(i, td){

		 var $input = $("input:hidden", $(td));
		 var rowData = {};
		 $input.each(function(j, e){
			 rowData[$(e).attr("name").toUpperCase()] = $(e).val(); 
		 });
		 arrApr.push(rowData);
	 });
	 data["APR"] = arrApr;
	 
	 
	 //-- 참조자 정보 수집
	 var arrRef = [];
	 $(rowsRef).each(function(i, td){

		 var $input = $("input:hidden", $(td));
		 var rowData = {};
		 $input.each(function(j, e){
			 rowData[$(e).attr("name").toUpperCase()] = $(e).val(); 
		 });
		 arrRef.push(rowData);
	 });
	 data["REF"] = arrRef;
	 
	 data["APR_MEMO"] = $("#apr_memo").val();
	 data["NONE_APR_YN"] = $("#none_apr_yn:checked").val();
	 
	 
	 try{
		if(opener){
	 		var a = opener.<%=callbackFunction%>(JSON.stringify(data));
	 	} else {
	 		parent.<%=callbackFunction%>(JSON.stringify(data));
	 	}
		 
	 }catch(e){
		 
	 }
	 self.close();

 }


var changeHoesa = function(){
 	var schData = {"PARENT_DEPT_CD IS NULL":"", "HOESA_COD":$("#hoesa_cod").val()};
	$("#treeArea").html("");
	treeDrawChild("treeArea","", airCommon.getSearchQueryParams());
 }
var selectNode = function(code_id){

	var codGrp = $("#"+code_id);
	var obj = codGrp.children("input:hidden");
	var jsonData = {};
	$(obj).each(function(i, d){
		jsonData[$(d).attr("name").toUpperCase()] = $(d).val();
	});
	jsonData["APR_TYPE"] = $("input:radio[name='aprType']:checked").val();
	User_AddNode2(JSON.stringify(jsonData));

};

$(function(){
	var arrDEPTH = [];
	<%
		int cnt = 0;
		if("Y".equals(defaultSet) && arrGroupPath != null){
	%>
	<%
			for(int i=0; i< (arrGroupPath.length); i++){
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
		treeInitSet("SYS_USER","JSON_TREE_LIST","USER",JSON.stringify(arrDEPTH),'<%=groupTypeCodes%>');

		//그려넣을 id, 루트id, 최종
		treeDrawChild("treeArea","",airCommon.getSearchQueryParams());
	});

	//외부발명자 추가
	function goInsertUser(){

		airIps.popupInsertOuUserForm();

	}

</script>