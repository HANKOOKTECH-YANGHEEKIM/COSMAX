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

	//-- 검색값 셋팅
	BeanResultMap 	requestMap 	= (BeanResultMap) request.getAttribute(CommonConstants.REQUEST);
	String 			pageNo 		= requestMap.getString(CommonConstants.PAGE_NO);
	String 			pageRowSize = requestMap.getString(CommonConstants.PAGE_ROWSIZE);
	String 			pageOrderByField  = requestMap.getString(CommonConstants.PAGE_ORDERBY_FIELD);
	String 			pageOrderByMethod = requestMap.getString(CommonConstants.PAGE_ORDERBY_METHOD);

	//-- 결과값 셋팅
	BeanResultMap resultMap = (BeanResultMap) request.getAttribute(CommonConstants.RESULT);
	
	SQLResults LMS_GBN = resultMap.getResult("LMS_GBN");

	//-- 파라메터 셋팅
	String actionCode = resultMap.getString(CommonConstants.ACTION_CODE);
	String modeCode = resultMap.getString(CommonConstants.MODE_CODE);

	String schLmsGbnStr = StringUtil.getCodestrFromSQLResults(LMS_GBN, "CODE,LANG_CODE", "|"+ StringUtil.getLocaleWord("L.CBO_SELECT",siteLocale));
	String lmsGbnStr = StringUtil.getCodestrFromSQLResults(LMS_GBN, "CODE,LANG_CODE", "");
	
	//-- 그리드 Url
	String jsonDataUrl = "/ServletController"
	   		   + "?AIR_ACTION="+actionCode
	   		   + "&AIR_MODE=JSON_LIST";
%>
<script type="text/javascript">
	
	 //--  리스트
	 var getLmsStuList = function(pageNo){
		  var data = {};
		  data["lms_gbn_cod"] = $("#lms_gbn_cod").val();
		  data["<%=CommonConstants.PAGE_NO%>"] = pageNo;
		  data["<%=CommonConstants.PAGE_ROWSIZE%>"] = "10";
		  
		  airCommon.callAjax("<%=actionCode%>", "JSON_LIST",data, function(json){
		   
			  airCommon.createTableRow("LmsStuListTable", json, pageNo, 10, "getRelIpsList");
		   
		  });
	 };
	 /**
	  * 검색 수행
	  */ 
	 function doSearch(isCheckEnter) {
	 	if (isCheckEnter && event.keyCode != 13) {         
	         return;
	     }
	 	
	 	$("#listTable").datagrid("load", airCommon.getSearchQueryParams());
	 }
	 
	var goModStr = function(row,index,changes){
			console.log(changes);
			var data = changes;
			data["STU_UID"] =row.STU_UID;
			airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
				doSearch();
			});
		
	}
	//--- 상태 추가 처리 및 저장 처리 
	var goAddStu = function(isCheckEnter){
		
		if (isCheckEnter && event.keyCode != 13) {         
	         return;
	     }
		if ("" == $("#STU_ID").val() ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"상태코드")%>");
			$("#STU_ID").focus();
		    return false;	
		}
		if ("" == $("#STU_BASE_NM").val() ) {
			alert ("<%=StringUtil.getScriptMessage("M.필수_입력사항_입니다",siteLocale,"기본상태명")%>");
			$("#STU_BASE_NM").focus();
		    return false;	
		}
		var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.ADD")%>";
		if(confirm(msg)){
			var data = $("#saveForm").serialize();
			airCommon.callAjax("<%=actionCode%>", "WRITE_PROC",data, function(json){
// 				$("#STU_ID").val("");
// 				$("#STU_BASE_NM").val("");
				doSearch();
			});
		}
	}
	
	var goDelete = function(){
		
		var stu_uids = [];
		
		var rows = $("#listTable").datagrid("getChecked");

		if(rows.length == 0){
			alert("<%=StringUtil.getScriptMessage("M.ALERT_SELECT",siteLocale, StringUtil.getLocaleWord("L.건",siteLocale))%>");
			return false;
		}

		for(var i=0; i<rows.length; i++) {
			stu_uids.push(rows[i].STU_UID);
		}
		
		
		var msg = "<%=StringUtil.getScriptMessage("M.하시겠습니까", siteLocale, "B.DELETE")%>";
		if(confirm(msg)){
			
			var data = {};
			data["stu_uids"] = stu_uids.join(",");
			
			airCommon.callAjax("<%=actionCode%>", "DELETE_PROC",data, function(json){
				doSearch();
			});
		}
	}
	function reject(){
	    $('#listTable').datagrid('rejectChanges');
	}
	$(function(){
// 		getLmsStuList(1);
		
		$('#listTabs-LIST').css('width','100%');
		$('#listTable').datagrid({
			url:'<%=jsonDataUrl%>',
			method:"post",				            	             
	     	queryParams:airCommon.getSearchQueryParams(),
			onBeforeLoad:function() { airCommon.showBackDrop(); },
			onLoadSuccess:function() {
				airCommon.hideBackDrop(), airCommon.gridResize();
			},
			onLoadError:function() { airCommon.hideBackDrop(); },
// 			onBeginEdit: function(index,row){
// 				var ed1 = $(this).datagrid('getEditor', {index:index,field:'PROC_GBN'});
// 				$(ed1.target).combobox('loadData',[
// 					{'label':'저장','value':'SAVE'},
// 					{'label':'상태처리','value':'STU'},
// 					{'label':'결재','value':'APRV'}
// 				])
// 			},
			onAfterEdit:function(index,row, changes){
				
		    	if(Object.keys(changes).length > 0){//객체의 키의 갯수(IE:8은 동작안함) air-Common.js에 대응 코딩함..
		    		
					if("ORD_SEQ" == Object.keys(changes)[0]){
						
						//-- 숫자 만 입력 가능하도록 
						var str = changes[Object.keys(changes)[0]];
						var regStr = /^\d+(?:.\d+)?$/;
						if(regStr.test(str)){
						}else{
							alert("'숫자' 와 한개의 '.' 만 입력 가능합니다.");
							reject()
							return false;
						}
						
					}
		    		
		    		var message = "<%=StringUtil.getLocaleWord("M.값_변경_저장", siteLocale)%>";
		    		if(confirm(message)){
			    		goModStr(row,index,changes );
		    		}else{
		    			reject();
		    		}
		    	}
		    }
		});
		$(window).bind('resize', airCommon.gridResize);
		$('#listTable').datagrid('enableCellEditing').datagrid('gotoCell', {
		    index: 0,
		    field: 'LANG_KO'

		});
	});
</script>
<script type="text/javascript" src="/common/_lib/jquery-easyui/datagrid-cellediting.js"></script>
<form name="form1" method="post">
	<input type="hidden" name="<%=CommonConstants.ACTION_CODE%>"value="<%=actionCode%>" />
	<input type="hidden" name="<%=CommonConstants.MODE_CODE%>" value="<%=modeCode%>" />
<%-- 	<input type="hidden" name="<%=CommonConstants.PAGE_NO%>" value="<%=pageNo%>" /> --%>
<%-- 	<input type="hidden" name="<%=CommonConstants.PAGE_ROWSIZE%>"value="<%=pageRowSize%>" /> --%>
<%-- 	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_FIELD%>" value="<%=pageOrderByField%>" /> --%>
<%-- 	<input type="hidden" name="<%=CommonConstants.PAGE_ORDERBY_METHOD%>" value="<%=pageOrderByMethod%>" /> --%>
	<input type="hidden" name="munseo_seosig_no" />
	<input type="hidden" name="munseo_seosig_nam" />
	<input type="hidden" name="parent_code_id" />
	<input type="hidden" name="status_gbn" />

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
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:10%" />
					<col style="width:30%" />
					<col style="width:10%" />
					<col style="width:20%" />
					<col style="width:auto" />
				</colgroup>
				<tr>				
					<th>법무구분</th>						
					<td >
						<%=HtmlUtil.getSelect(request, true, "STU_GBN", "STU_GBN", schLmsGbnStr, "", "class=\"select width_max\" data-type=\"search\"") %>
					</td>
					<th>순번</th>					
					<td><input type="text" name="ORD_SEQ_GTEQ" value="" class="text" data-type="search"  onkeydown="doSearch(true)" />~<input type="text" name="ORD_SEQ_LTEQ" value=""  data-type="search" class="text"  onkeydown="doSearch(true)" /></td>	
					<th>기본상태명 :</th>					
					<td><input type="text" name="STU_BASE_NM" value="" data-type="search" class="text" onkeydown="doSearch( true)" /></td>
					<td rowspan="2" class="verticalContainer">
						<span class="ui_btn medium icon"><span class="search"></span><a href="javascript:void(0)" onclick="doSearch();"><%=StringUtil.getLocaleWord("B.SEARCH",siteLocale)%></a></span>
					</td>
				</tr>
				<tr>				
					<th>의뢰자뷰</th>						
					<td><input type="text" name="CMM_ISJ" value="" data-type="search" class="text " onkeydown="doSearch( true)" /></td>
					<th>담당자뷰</th>					
					<td><input type="text" name="LMS_BCD" value="" data-type="search" class="text" onkeydown="doSearch( true)" /></td>
					<th>배당자뷰 :</th>					
					<td><input type="text" name="LMS_BCD" value="" data-type="search" class="text" onkeydown="doSearch( true)" /></td>
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
</form>	
	<br/>
	<br/>
<form name="saveForm" id="saveForm" method="post">
	<table class="basic">
	<tr>
		<th style="width:10%;">법무구분</th>						
		<td style="width:15%;">
			<%=HtmlUtil.getSelect(request, true, "STU_GBN", "STU_GBN", lmsGbnStr, "", "class=\"select\" data-type=\"search\" style='width:100%;'") %>
		</td>
		<th style="width:5%;">순번</th>
		<td style="width:10%;"><input type="text" name="ORD_SEQ" class="text" id="ORD_SEQ" style="width:97%;" /></td>
		<th style="width:10%;">상태코드</th>
		<td style="width:20%;"><input type="text" name="STU_ID" class="text" id="STU_ID" style="width:97%;" /></td>
		<th style="width:10%;">기본상태명</th>
		<td style="width:20%;"><input type="text" name="STU_BASE_NM" class="text"  id="STU_BASE_NM" onKeyUp="goAddStu(true);" style="width:97%;" /></td>
		<td style="text-align:center;">
			<span class="ui_btn medium icon"><span class="add"></span><a href="javascript:void(0)" onclick="goAddStu();"><%=StringUtil.getLocaleWord("B.ADD",siteLocale)%></a></span>		
			<span class="ui_btn medium icon"><span class="delete"></span><a href="javascript:void(0)" onclick="goDelete();"><%=StringUtil.getLocaleWord("B.DELETE",siteLocale)%></a></span>		
		</td>
	</tr>
	</table>
</form>
	<br/>
	T:임시저장<br/>
	A:결재<br/>
	D:삭제<br/>
	S:처리<br/>
	P:상태만 변경<br/>
	K:다른 법무진행(법무>인감신청)<br/>
	<br/>
	<table id="listTable" class="easyui-datagrid"
				data-options="singleSelect:true,
							  striped:true,
							  fitColumns:false,
							  rownumbers:true,
							  multiSort:true,
							  selectOnCheck:false,
							  checkOnSelect:false"
				style="height:auto">
				<thead>
				<tr>
					<th data-options="field:'STU_UID',width:0,hidden:true"></th>
					<th data-options="field:'STU_GBN',width:0,hidden:true"></th>
					<th data-options="field:'CK',halign:'center',align:'center',checkbox:true" width="5%"></th>
					<th data-options="field:'STU_GBN_NM',width:80,halign:'CENTER',align:'LEFT',sortable:true">구분</th>
					<th data-options="field:'ORD_SEQ',width:60,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">순번</th>
					<th data-options="field:'PROC_GBN',width:100,halign:'CENTER',align:'LEFT',editor:'text'">처리구분</th>
					<th data-options="field:'STU_ID',width:160,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">상태코드</th>
					<th data-options="field:'STU_BASE_NM',width:160,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">기본상태명</th>
					<th data-options="field:'LANG_CODE',width:120,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">다국어코드</th>
					<th data-options="field:'CMM_ISJ',width:140,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">의뢰자뷰명</th>
					<th data-options="field:'LMS_BCD',width:140,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">배당자뷰명</th>
					<th data-options="field:'LMS_BJD',width:140,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">담당자뷰명</th>
					<th data-options="field:'LMS_CMD',width:140,halign:'CENTER',align:'LEFT',editor:'text',sortable:true">인감담당자명</th>
				</tr>
			</table>
<!-- 	
<table class="basic" id="LmsStuListTable">
	<thead>
	<tr>
		<th style="width:10%" data-opt='{"align":"center","col":"LMS_GBN_COD","inputHidden","STU_UID"}'>법무구분</th>
		<th style="width:*"   data-opt='{"align":"left","col":"LMS_STU","on-click":"popupDocView(\"@{DOC_MAS_UID}\",\"@{DOC_FLOW_UID}\",\"@{SOL_MAS_UID}\")"}'>상태코드</th>
		<th style="width:10%" data-opt='{"align":"center","col":"BASE_NM"}'>기본상태명</th>
		<th style="width:10%" data-opt='{"align":"center","col":"C_EUIROE"}'>의뢰자뷰명</th>
		<th style="width:10%" data-opt='{"align":"center","col":"L_BAEDANG"}'>배당자뷰명</th>
		<th style="width:10%" data-opt='{"align":"center","col":"L_DAMDANG"}'>담당자뷰명</th>
		<th style="width:10%" data-opt='{"align":"right","col":"WRT_DTE", "dataTp":"date"}'>작성일</th>
		<th style="width:8%" data-opt='{"align":"center","col":"WRT_NM"}'></th>
		<th style="width:8%" data-opt='{"align":"center","col":"HTML_DEL_BTN"}'></th>
	</tr>
	</thead>
	<tbody id="LmsStuListTableBody">
	</tbody>
</table>
<%-- 페이지 목록 --%>
<div class="pagelist" id="LmsStuListTablePage"></div> 
 -->
