<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	//String page_no 			= requestMap.getString(CommonConstants.PAGE_NO);
	//String page_rowsize 		= requestMap.getString(CommonConstants.PAGE_ROWSIZE);

	//-- 결과값 셋팅
	BeanResultMap resultMap 	= (BeanResultMap)request.getAttribute(CommonConstants.RESULT);

	//-- 파라메터 셋팅
	String action_code 			= resultMap.getString(CommonConstants.ACTION_CODE);
	String mode_code 			= resultMap.getString(CommonConstants.MODE_CODE);

	String sel_uuid_path		= requestMap.getString("SEL_UUID_PATH");
	String parent_uuid 			= request.getParameter("parent_uuid");
	String callbackFunction		= requestMap.getString("CALLBACKFUNCTION");
	String rootCodeId			= requestMap.getString("ROOTCODEID");
	String selectType			= requestMap.getString("SELECTTYPE");
	String multiSelect			= requestMap.getString("MULTISELECT");

	//-- 기타값 셋팅
	String schFieldCodestr 		= "NAME_KO|"+StringUtil.getLocaleWord("L.이름", siteLocale)+"^CODE|코드"+"^CODE_ID|코드아이디";

%>
<script type="text/javascript">

var changeCodeView = function(json){
	//-- 이미 선택된 사용자인지 여부 체크!
	if(chkUserId(json)){
		var data = JSON.parse(json);
		 if("N" == "<%=multiSelect%>"){
			 $("#tbodyCodeList").html("");
		 }
		$("#addCodeTmpl").tmpl(data).appendTo("#tbodyCodeList");
	}


	}
	/**
	*	같은 사용자 선택 했는지 체크
	*/
	function chkUserId(json){
	 var data = JSON.parse(json);
	 var arrObj = $("input:hidden[name='uuid']","#tbodyUserList");
	 var rtnBool = true;
	 arrObj.each(function(i, d){
		 if(data.UUID == $(d).val()){
			 rtnBool = false;
		 }
	 });

	 return rtnBool;

	}

	/**
	 * 신규작성 페이지로 이동
	 */
	function goWrite(frm) {
		frm.action = "/ServletController";
		frm.<%=CommonConstants.MODE_CODE%>.value = "WRITE_FORM";
		frm.submit();
	}

	/**
	 * 수정 페이지로 이동
	 */
	function goModify(frm,update_mode) {
		if (frm.uuid.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.수정할코드정보", siteLocale))%>");
			return;
		}
		frm.update_mode.value = update_mode;
		frm.action = "/ServletController";
		frm.<%=CommonConstants.MODE_CODE%>.value = "UPDATE_FORM";
		frm.submit();
	}

	/**
	 * 삭제 페이지로 이동
	 */
	function goDelete(frm) {
		if (frm.uuid.value == "") {
			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.삭제할코드정보", siteLocale))%>");
			return;
		}

		if (confirm("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT",siteLocale, StringUtil.getLocaleWord("L.선택하신코드및하위코드정보를완전히삭제", siteLocale))%>")) {
			airCommon.showBackDrop();
			frm.<%=CommonConstants.MODE_CODE%>.value = "DELETE";
			$.ajax({
	            url: "/ServletController"
            	, type: "POST"
				, dataType: "json"
	            , data: $("#form1").serialize()
			})
			.done(function(data) {
	            alert("<%=StringUtil.getScriptMessage("M.ALERT_SUBMIT_DONE",siteLocale)%>");
	            $("#treeArea").html("");
	            drawTree();
				airCommon.hideBackDrop();
			})
	        .fail(function() {
	        	alert("오류");
	            //승인처리 도중 에러가 발생했습니다.
				airCommon.hideBackDrop()
<%-- 		            alert("<%=StringUtil.getScriptMessage("M.처리중오류발생관리자문의하세요",siteLocale, StringUtil.getLocaleWord("L.승인처리", siteLocale))%>"); --%>
	        });
		}
	}

	 /**
	  * 확인 처리
	  */
	 function doConfirm(frm) {
		 var aprv = $("[data-meaning='code_tr']");
		 if(aprv.length == 0){
			 alert("<%=StringUtil.getScriptMessage("M.선택해주세요",siteLocale, "L.코드")%>");
			 return;
		 }
		var json = [];
		aprv.each(function(i,e){
			var trTag = $(e);
			var obj = trTag.find("input:hidden");

			var jsonData = {};
			$(obj).each(function(i, d){
	 			jsonData[$(d).attr("name").toUpperCase()] = $(d).val();
	 		});
			json.push(jsonData);
		});

		opener.<%=callbackFunction%>(JSON.stringify(json));
		self.close();

	 }
	var doSearch = function(isCheckEnter) {
		if (isCheckEnter && event.keyCode != 13) {
			return;
		}
		if($("#schValue").val() != ""){
			$("#treeArea").html("");
			treeDrawChild("treeArea","", airCommon.getSearchQueryParams(document.schForm));
		}else{
			$("#treeArea").html("");
			treeDrawChild("treeArea","null","");
		}
	}

	var selectNode = function(code_id){

		var codGrp = $("#"+code_id);
		var obj = codGrp.children("input:hidden");
		var jsonData = {};
		$(obj).each(function(i, d){
			jsonData[$(d).attr("name").toUpperCase()] = $(d).val();
		});

		changeCodeView(JSON.stringify(jsonData));

	};
	var drawTree = function(){
		var arrDEPTH = [];
		//tree 불러오 air-action, air-mode 값 셋팅
		treeInitSet("SYS_CODE","JSON_TREE_DATA","CODE",JSON.stringify(arrDEPTH),'');

		//그려넣을 id, 루트id, 최종
	    treeDrawChild("treeArea","<%=StringUtil.convertNullDefault(rootCodeId, "null")%>");
	}
	$(function(){
		drawTree();
	});

</script>
<script id="addCodeTmpl" type="text/x-jquery-tmpl">
<tr data-meaning="code_tr" id="sel_\${UUID}">
	<td align="center">
		<input type="checkbox"  value="sel_\${UUID}" name="chkSignList" >
	</td>
	<td style="text-align:center">
		\${NAME_<%=siteLocale.toUpperCase()%>}
		<input type="hidden" name="uuid"	        value="\${UUID}">
		<input type="hidden" name="code_id"	        value="\${CODE_ID}">
		<input type="hidden" name="code"	        value="\${CODE}">
		<input type="hidden" name="seq_no"	        value="\${SEQ_NO}">
		<input type="hidden" name="order_no"	    value="\${ORDER_NO}">
		<input type="hidden" name="name_ko"	        value="\${NAME_KO}">
		<input type="hidden" name="name_en"	        value="\${NAME_EN}">
		<input type="hidden" name="name_ja"	        value="\${NAME_JA}">
		<input type="hidden" name="name_zh"	        value="\${NAME_ZH}">
		<input type="hidden" name="memo_ja"	        value="\${MEMO_JA}">
		<input type="hidden" name="memo_zh"	        value="\${MEMO_ZH}">
		<input type="hidden" name="memo_ko"	        value="\${MEMO_KO}">
		<input type="hidden" name="memo_en"	        value="\${MEMO_EN}">
		<input type="hidden" name="parent_uuid"	    value="\${PARENT_UUID}">
		<input type="hidden" name="parent_name_ko"	value="\${PARENT_NAME_KO}">
		<input type="hidden" name="parent_name_en"	value="\${PARENT_NAME_EN}">
		<input type="hidden" name="parent_code_id"	value="\${PARENT_CODE_ID}">
		<input type="hidden" name="parent_code"	    value="\${PARENT_CODE}">
		<input type="hidden" name="parent_seq_no"	value="\${PARENT_SEQ_NO}">
		<input type="hidden" name="level_no"	    value="\${LEVEL_NO}">
		<input type="hidden" name="child_cnt"	    value="\${CHILD_CNT}">
		<input type="hidden" name="uuid_path"	    value="\${UUID_PATH}">
		<input type="hidden" name="code_id_path"	value="\${CODE_ID_PATH}">
		<input type="hidden" name="code_path"	    value="\${CODE_PATH}">
		<input type="hidden" name="name_path_ko"	value="\${NAME_PATH_KO}">
		<input type="hidden" name="name_path_en"	value="\${NAME_PATH_EN}">
		<input type="hidden" name="code_attr1"	    value="\${CODE_ATTR1}">
		<input type="hidden" name="code_attr2"	    value="\${CODE_ATTR2}">
		<input type="hidden" name="code_attr3"	    value="\${CODE_ATTR3}">
		<input type="hidden" name="code_attr4"	    value="\${CODE_ATTR4}">
		<input type="hidden" name="code_data"	    value="\${CODE_DATA}">
		<input type="hidden" name="status_code"	    value="\${STATUS_CODE}">
		<input type="hidden" name="status_name_ko"	value="\${STATUS_NAME_KO}">
		<input type="hidden" name="status_name_en"	value="\${STATUS_NAME_EN}">
		<input type="hidden" name="insert_date"	    value="\${INSERT_DATE}">
		<input type="hidden" name="update_date"	    value="\${UPDATE_DATE}">
		<input type="hidden" name="code_attr1_desc"	value="\${CODE_ATTR1_DESC}">
		<input type="hidden" name="code_attr2_desc"	value="\${CODE_ATTR2_DESC}">
		<input type="hidden" name="code_attr3_desc"	value="\${CODE_ATTR3_DESC}">
		<input type="hidden" name="code_attr4_desc"	value="\${CODE_ATTR4_DESC}">
	</td>
	<td align="center">
		\${NAME_PATH_KO}
	</td>
</tr>
</script>


<table class="none">
	<colgroup>
		<col width="54%" />
		<col width="46%" />
	</colgroup>
	<tr>
	<td align="left" valign="top">
		<table class="basic">
		<caption>Code select</caption>
			<tr>
				<td>
				<div class="table_cover_no_margin">
					<table class="box">
						<tr>
							<td width="80%">
								<input type="text" name="NAME_<%=siteLocale %>" id="schValue" value=""  class="text width_max" data-type="search"  onkeydown="doSearch(true)" />
							</td>
							<td rowspan="3" style="text-align: center;">
			            			<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();" ><%=StringUtil.getLocaleWord("L.검색",siteLocale)%></a></span>
		            		</td>
		            	</tr>
					</table>
				</div>
			<div id="treeArea" class="treeCodeArea" style="height:300px;"></div>
			</td>
		</tr>
		</table>
	</td>
	<td align="right" valign="top">
			<table class="basic">
				<caption>
					<%=StringUtil.getLocaleWord("B.SELECT", siteLocale)%>
				</caption>
				<tr>
					<td>
						<div class="table_cover_no_margin" style="height:332px;">
							<table class="list" style="width:98%">
								<colgroup>
									<col width="8%" />
									<col width="32%" />
									<col width="40%" />
								</colgroup>
								<thead>
								<tr>
									<td colspan="4">
										<span class="ui_btn small icon"><span class="delete"></span><a href="javascript:void(0)" onclick="User_DeleteNode();"><%=StringUtil.getLocaleWord("L.삭제",siteLocale)%></a></span>
									</td>
								</tr>
								<tr>
									<th><input type="checkbox" name="chkSignListAll" id="chkSignListAll" /></th>
									<th><%=StringUtil.getLocaleWord("L.코드",siteLocale)%></th>
									<th>Path</th>
								</tr>
								</thead>
								<tbody id="tbodyCodeList">
								</tbody>
							</table>
						</div>
					</td>
				</tr>
				</tbody>
			</table>
		</td>
	</tr>
</table>
	<div class="buttonlist">
	<div class="left">
<% if (mode_code.indexOf("POPUP_") > -1) { //팝업 모드일 경우에만 닫기 버튼 보여주기 %>
		<span class="ui_btn medium icon"><span class="close"></span><a href="javascript:void(0)" onclick="self.close();"><%=StringUtil.getLocaleWord("B.CLOSE",siteLocale)%></a></span>
<% } %>
	</div>
	<div class="right">
		<span class="ui_btn medium icon"><span class="confirm"></span><a href="javascript:void(0)" onclick="doConfirm(document.form1);" ><%=StringUtil.getLocaleWord("L.확인",siteLocale)%></a></span>
	</div>
	</div>
